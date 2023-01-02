---
--- Economy Script
---
--- This script implements all calculations reguarding tax, payment, honor
--- and reputation and all passive lord or spouse effects.
---

Stronghold = Stronghold or {};

Stronghold.Config.Income = {
    MaxReputation = 200,
    TaxPerWorker = 5,
    TaxEffect = {
        [1] = {Honor = 4, Reputation = 10,},
        [2] = {Honor = 2, Reputation = -2,},
        [3] = {Honor = 1, Reputation = -4,},
        [4] = {Honor = 0, Reputation = -8,},
        [5] = {Honor = 0, Reputation = -16,},
    },
    Buildings = {
        [Entities.CB_Bastille1] = {Honor = 15, Reputation = 5,},
        ---
        [Entities.PB_Beautification04] = {Limit = 4, Honor = 1, Reputation = 1,},
        [Entities.PB_Beautification06] = {Limit = 4, Honor = 1, Reputation = 1,},
        [Entities.PB_Beautification09] = {Limit = 4, Honor = 1, Reputation = 1,},
        ---
        [Entities.PB_Beautification01] = {Limit = 3, Honor = 1, Reputation = 2,},
        [Entities.PB_Beautification02] = {Limit = 3, Honor = 1, Reputation = 2,},
        [Entities.PB_Beautification12] = {Limit = 3, Honor = 1, Reputation = 2,},
        ---
        [Entities.PB_Beautification05] = {Limit = 2, Honor = 1, Reputation = 3,},
        [Entities.PB_Beautification07] = {Limit = 2, Honor = 1, Reputation = 3,},
        [Entities.PB_Beautification08] = {Limit = 2, Honor = 1, Reputation = 3,},
        ---
        [Entities.PB_Beautification03] = {Limit = 1, Honor = 1, Reputation = 4,},
        [Entities.PB_Beautification10] = {Limit = 1, Honor = 1, Reputation = 4,},
        [Entities.PB_Beautification11] = {Limit = 1, Honor = 1, Reputation = 4,},
        ---
        [Entities.PB_Tavern1] = {Honor = 0, Reputation = 3,},
        [Entities.PB_Tavern2] = {Honor = 0, Reputation = 6,},
        ---
        [Entities.PB_Farm2] = {Honor = 1, Reputation = 0,},
        [Entities.PB_Farm3] = {Honor = 2, Reputation = 0,},
        ---
        [Entities.PB_Residence2] = {Honor = 1, Reputation = 0,},
        [Entities.PB_Residence3] = {Honor = 2, Reputation = 0,},
    },
    Spouse = {Honor = 5, Reputation = 5,},
}

-- -------------------------------------------------------------------------- --
-- Trade

function Stronghold:InitTradeBalancer()
    local EntityID = Event.GetEntityID();
    local SellTyp = Event.GetSellResource();
    local PurchaseTyp = Event.GetBuyResource();
    local PlayerID = Logic.EntityGetPlayer(EntityID);

    if Logic.GetCurrentPrice(PlayerID, SellTyp) > 1.2 then
        Logic.SetCurrentPrice(PlayerID, SellTyp, 1.2);
    end
    if Logic.GetCurrentPrice(PlayerID, SellTyp) < 0.8 then
        Logic.SetCurrentPrice(PlayerID, SellTyp, 0.8);
    end
    if Logic.GetCurrentPrice(PlayerID, PurchaseTyp) > 1.2 then
        Logic.SetCurrentPrice(PlayerID, PurchaseTyp, 1.2);
    end
    if Logic.GetCurrentPrice(PlayerID, PurchaseTyp) < 0.8 then
        Logic.SetCurrentPrice(PlayerID, PurchaseTyp, 0.8);
    end
end

-- -------------------------------------------------------------------------- --
-- Income & Upkeep

function Stronghold:UpdateIncomeAndUpkeep(_PlayerID)
    if self.Players[_PlayerID] then
        local MaxReputation = self.Config.Income.MaxReputation;
        MaxReputation = self:ApplyMaxReputationPassiveAbility(_PlayerID, MaxReputation);
        self:SetPlayerReputationLimit(_PlayerID, MaxReputation);

        local Income = self:CalculateMoneyIncome(_PlayerID);
        local Upkeep = self:CalculateMoneyUpkeep(_PlayerID);
        local ReputationPlus = self:CalculateReputationIncrease(_PlayerID);
        local ReputationMinus = self:CalculateReputationDecrease(_PlayerID);
        local Honor = self:CalculateHonorIncome(_PlayerID);

        -- Spouse
        if Logic.GetEntityHealth(GetID(self.Players[_PlayerID].SpouseScriptName)) > 0 then
            ReputationPlus = ReputationPlus + self.Config.Income.Spouse.Reputation;
            Honor = Honor + self.Config.Income.Spouse.Honor;
        end

        self.Players[_PlayerID].IncomeMoney = Income;
        self.Players[_PlayerID].UpkeepMoney = Upkeep;
        self.Players[_PlayerID].IncomeReputation = math.floor(ReputationPlus - ReputationMinus);
        self.Players[_PlayerID].IncomeHonor = Honor;
    end
end

-- Calculate reputation increase
-- Reputation is produced by buildings and units.
function Stronghold:CalculateReputationIncrease(_PlayerID)
    if self.Players[_PlayerID] then
        local Income = 0;
        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        if WorkerCount > 0 then
            -- Buildings
            for k, v in pairs(self.Config.Income.Buildings) do
                local Buildings = self:GetCompletedEntitiesOfType(_PlayerID, k);
                for i= table.getn(Buildings), 1, -1 do
                    if Logic.GetBuildingWorkPlaceLimit(Buildings[i]) > 0 then
                        if Logic.GetBuildingWorkPlaceUsage(Buildings[i]) == 0 then
                            table.remove(Buildings, i);
                        end
                    end
                end
                Income = Income + (table.getn(Buildings) * v.Reputation);
            end
            -- Tax
            local TaxtHeight = self.Players[_PlayerID].TaxHeight;
            if TaxtHeight == 1 then
                local TaxEffect = Stronghold.Config.Income.TaxEffect;
                Income = Income + TaxEffect[TaxtHeight].Reputation;
            end
            -- Hero
            Income = self:ApplyReputationIncreasePassiveAbility(_PlayerID, Income);
        end
        return math.floor(Income + 0.5);
    end
    return 0;
end

-- Calculate reputation decrease
-- A fixed penalty for the tax hight and the amout of workers the player didn't
-- provide a farm or house are negative factors.
function Stronghold:CalculateReputationDecrease(_PlayerID)
    if self.Players[_PlayerID] then
        local TaxEffect = Stronghold.Config.Income.TaxEffect;
        local Decrease = 0;
        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        if WorkerCount > 0 then
            local TaxPenalty = 0;
            local TaxtHeight = self.Players[_PlayerID].TaxHeight;
            if TaxtHeight > 1 then
                TaxPenalty = TaxEffect[TaxtHeight].Reputation * -1
                TaxPenalty = TaxPenalty * (1 + (WorkerCount/100));
            end
            local NoFood = Logic.GetNumberOfWorkerWithoutEatPlace(_PlayerID)/3;
            local NoSleep = Logic.GetNumberOfWorkerWithoutSleepPlace(_PlayerID)/3;
            Decrease = TaxPenalty + NoFood + NoSleep;
            Decrease = self:ApplyReputationDecreasePassiveAbility(_PlayerID, Decrease);
        end
        return math.floor(Decrease + 0.5);
    end
    return 0;
end

-- Calculate honor income
-- Honor is influenced by tax, buildings and units.
function Stronghold:CalculateHonorIncome(_PlayerID)
    if self.Players[_PlayerID] then
        local Income = 0;
        -- Tax
        local TaxHight = self.Players[_PlayerID].TaxHeight;
        local TaxBonus = self.Config.Income.TaxEffect[TaxHight].Honor;
        Income = Income + TaxBonus;

        -- Buildings
        for k, v in pairs(self.Config.Income.Buildings) do
            local Buildings = self:GetCompletedEntitiesOfType(_PlayerID, k);
            for i= table.getn(Buildings), 1, -1 do
                local WorkplaceLimit = Logic.GetBuildingWorkPlaceLimit(Buildings[i]);
                if WorkplaceLimit then
                    if Logic.GetBuildingWorkPlaceUsage(Buildings[i]) < WorkplaceLimit then
                        table.remove(Buildings, i);
                    end
                end
            end
            Income = Income + (table.getn(Buildings) * v.Honor);
        end

        -- Hero
        Income = self:ApplyHonorBonusPassiveAbility(_PlayerID, Income);
        return math.floor(Income + 0.5);
    end
    return 0;
end

-- Calculate tax income
-- The tax income is mostly unchanged. A worker pays 5 gold times the tax level.
function Stronghold:CalculateMoneyIncome(_PlayerID)
    if self.Players[_PlayerID] then
        local TaxHeight = self.Players[_PlayerID].TaxHeight;
        local PerWorker = Stronghold.Config.Income.TaxPerWorker;
        local Income = (Logic.GetNumberOfAttractedWorker(1) * PerWorker) * (TaxHeight -1);
        Income = self:ApplyIncomeBonusPassiveAbility(_PlayerID, Income);
        return math.floor(Income + 0.5);
    end
    return 0;
end

-- Calculate unit upkeep
-- The upkeep is not for the leader himself. Soldiers are also incluced in the
-- calculation. The upkeep decreases if the group looses soldiers.
function Stronghold:CalculateMoneyUpkeep(_PlayerID)
    if self.Players[_PlayerID] then
        local Upkeep = 0;
        for k, v in pairs(self.Config.Upkeep.Units) do
            local Military = self:GetCompletedEntitiesOfType(_PlayerID, k);
            local TypeUpkeep = 0;
            for i= 1, table.getn(Military) do
                local UnitUpkeep = v.Gold;
                local SoldiersMax = Logic.LeaderGetMaxNumberOfSoldiers(Military[i]);
                local SoldiersCur = Logic.LeaderGetNumberOfSoldiers(Military[i]);
                if SoldiersMax > 0 then
                    UnitUpkeep = math.ceil(UnitUpkeep * ((SoldiersCur +1) / (SoldiersMax +1)));
                end
                TypeUpkeep = TypeUpkeep + UnitUpkeep;
            end

            -- Barracks high tier discount
            if k == Entities.PU_LeaderPoleArm3 or k == Entities.PU_LeaderPoleArm4
            or k == Entities.PU_LeaderSword3 or k == Entities.PU_LeaderSword4 then
                TypeUpkeep = self:ApplyUpkeepDiscountBarracks(_PlayerID, TypeUpkeep);
            end
            -- Archery high tier discount
            if Logic.IsEntityTypeInCategory(k, EntityCategories.Rifle) == 1
            or k == Entities.PU_LeaderBow3 or k == Entities.PU_LeaderBow4 then
                TypeUpkeep = self:ApplyUpkeepDiscountArchery(_PlayerID, TypeUpkeep);
            end
            -- Stables high tier discount
            if Logic.IsEntityTypeInCategory(k, EntityCategories.CavalryHeavy) == 1
            or Logic.IsEntityTypeInCategory(k, EntityCategories.CavalryLight) == 1 then
                TypeUpkeep = self:ApplyUpkeepDiscountStable(_PlayerID, TypeUpkeep);
            end
            -- Foundry high tier discount
            if k == Entities.PV_Cannon3 or k == Entities.PV_Cannon4 then
                TypeUpkeep = self:ApplyUpkeepDiscountFoundry(_PlayerID, TypeUpkeep);
            end
            -- Lord discount
            TypeUpkeep = self:ApplyUpkeepDiscountPassiveAbility(_PlayerID, k, TypeUpkeep);

            self.Players[_PlayerID].UpkeepDetails[k] = TypeUpkeep;
            Upkeep = Upkeep + TypeUpkeep;
        end
        return math.floor(Upkeep + 0.5);
    end
    return 0;
end

-- -------------------------------------------------------------------------- --
-- UI

function Stronghold:OverrideFindViewUpdate()
    GUIUpdate_FindView = function()
        XGUIEng.ShowWidget("FindView", 1);
		XGUIEng.ShowWidget("FindSpearmen", 1);
        XGUIEng.ShowWidget("FindSwordmen", 1);
		XGUIEng.ShowWidget("FindBowmen", 1);
        XGUIEng.ShowWidget("FindCannon", 1);
		XGUIEng.ShowWidget("FindLightCavalry", 1);
        XGUIEng.ShowWidget("FindHeavyCavalry", 1);
		XGUIEng.ShowWidget("FindRiflemen", 1);
        XGUIEng.ShowWidget("FindScout", 1);
		XGUIEng.ShowWidget("FindThief", 1);
        XGUIEng.ShowWidget("Find_IdleSerf", 1);
	end
end

function Stronghold:OverridePaydayClockTooltip()
    GUITooltip_Payday_Orig_StrongholdEco = GUITooltip_Payday
    GUITooltip_Payday = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUITooltip_Payday_Orig_StrongholdEco();
        end

        local PaydayTime = math.floor((Logic.GetPlayerPaydayTimeLeft(1)/1000) + 0.5);
        local Honor = Stronghold.Players[PlayerID].IncomeHonor;
        local Reputation = Stronghold.Players[PlayerID].IncomeReputation;

        local TextCol = " @color:255,255,255 ";
        local GreenCol = " @color:173,255,47 ";
        local RepuColor = GreenCol;

        if Reputation < 0 then
            RepuColor = " @color:255,32,32 ";
        else
            Reputation = "+" .. Reputation;
        end
        if Honor >= 0 then
            Honor = "+" .. Honor;
        end

        XGUIEng.SetText(
            "TooltipTopText",
            " @color:180,180,180 Zahltag @cr " ..TextCol.. " " ..PaydayTime..
            " Sekunden verbleiben @cr Ihr erhaltet: @cr "..
            RepuColor.. " " ..Reputation.. " " ..TextCol.. " Beliebtheit @cr "..
            GreenCol.. " " ..Honor.. " " ..TextCol.. " Ehre"
        );
    end
end

function Stronghold:OverrideTaxAndPayStatistics()
    GUIUpdate_TaxPaydayIncome_Orig_StrongholdEco = GUIUpdate_TaxPaydayIncome;
    GUIUpdate_TaxPaydayIncome = function()
		local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUIUpdate_TaxPaydayIncome_Orig_StrongholdEco();
        end

        local Income = Stronghold.Players[PlayerID].IncomeMoney;
        local Upkeep = Stronghold.Players[PlayerID].UpkeepMoney;
        if Income - Upkeep < 0 then
			XGUIEng.SetText( "SumOfPayday", " @color:255,32,32 @ra "..(Income-Upkeep));
			XGUIEng.SetText( "TaxSumOfPayday", " @color:255,32,32 @ra "..(Income-Upkeep));
		else
			XGUIEng.SetText( "SumOfPayday", " @color:173,255,47 @ra +"..(Income-Upkeep));
			XGUIEng.SetText( "TaxSumOfPayday", " @color:173,255,47 @ra +"..(Income-Upkeep));
		end
	end

    GUIUpdate_TaxSumOfTaxes_Orig_StrongholdEco = GUIUpdate_TaxSumOfTaxes;
	GUIUpdate_TaxSumOfTaxes = function()
		local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUIUpdate_TaxSumOfTaxes_Orig_StrongholdEco();
        end

        local Income = Stronghold.Players[PlayerID].IncomeMoney;
        XGUIEng.SetText( "TaxWorkerSumOfTaxes", " @color:173,255,47 @ra " ..Income);
	end

    GUIUpdate_TaxLeaderCosts_Orig_StrongholdEco = GUIUpdate_TaxLeaderCosts;
	GUIUpdate_TaxLeaderCosts = function()
		local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUIUpdate_TaxLeaderCosts_Orig_StrongholdEco();
        end

        local Upkeep = Stronghold.Players[PlayerID].UpkeepMoney;
        XGUIEng.SetText( "TaxLeaderSumOfPay", " @color:255,32,32 @ra "..Upkeep);
	end

    GUIUpdate_AverageMotivation_Orig_StrongholdEco = GUIUpdate_AverageMotivation;
    GUIUpdate_AverageMotivation = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUIUpdate_AverageMotivation_Orig_StrongholdEco();
        end
        local Reputation = Stronghold.Players[PlayerID].Reputation;
        local ReputationLimit = Stronghold.Players[PlayerID].ReputationLimit;
        -- Icon
        local TexturePath = "data/graphics/textures/gui/";
        if Reputation < 70 then
            TexturePath = TexturePath .. "i_res_motiv_worse.png";
        elseif Reputation >= 70 and Reputation < 100 then
            TexturePath = TexturePath .. "i_res_motiv_bad.png";
        elseif Reputation >= 100 and Reputation < 150 then
            TexturePath = TexturePath .. "i_res_motiv_good.png";
        elseif Reputation >= 150 then
            TexturePath = TexturePath .. "i_res_motiv_fine.png";
        end
        XGUIEng.SetMaterialTexture("IconMotivation", 0, TexturePath);
        -- Text
        XGUIEng.SetWidgetPosition("AverageMotivation", 38, 118);
		XGUIEng.SetText("AverageMotivation", Reputation.. "/" ..ReputationLimit);
	end
end

function Stronghold:PrintTooltipGenericForEcoGeneral(_PlayerID, _Key)
    if _Key == "MenuHeadquarter/TaxWorker" then
        XGUIEng.SetText(
            gvGUI_WidgetID.TooltipBottomText,
            " @color:180,180,180 Steuern @color:255,255,255 @cr Jeder "..
            " Arbeiter entrichtet Euch zum Zahltag seine Steuer. Wägt "..
            " ab, ob Ihr sie schonen oder schröpfen wollt."
        );
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
        return true;
    elseif _Key == "MenuHeadquarter/TaxLeader" then
        XGUIEng.SetText(
            gvGUI_WidgetID.TooltipBottomText,
            " @color:180,180,180 Sold @color:255,255,255 @cr Am Zahltag "..
            " wird der Sold der Soldaten fällig. Ihr könnt so viele "..
            " haben, wie ihr wollt, müsst sie aber bezahlen können."
        );
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
        return true;
    elseif _Key == "MenuResources/population" then
        XGUIEng.SetText(
            gvGUI_WidgetID.TooltipBottomText,
            " @color:180,180,180 Bevölkerung @color:255,255,255 @cr Zur "..
            "Bevölkerung zählen alle Arbeiter, Leibeigene, Kundschafter "..
            "und Diebe. Baut die Burg aus, um mehr Volk anzulocken."
        );
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
        return true;
    elseif _Key == "MenuResources/Motivation" then
        local Text = " @color:180,180,180 Beliebtheit @color:255,255,255 @cr ";
        local Reputation = Stronghold.Players[_PlayerID].Reputation;
        if Reputation <= 30 then
            Text = Text .. "Sir, Ihr seid eine Katastrophe! Die Leute verlassen die Burg!";
        elseif Reputation > 30 and Reputation < 70 then
            Text = Text .. "Wenn man Euch etwas zuruft, ist es meistens etwas unanständiges.";
        elseif Reputation >= 70 and Reputation < 90 then
            Text = Text .. "Der Pöbel tuschelt hinter vorgehaltener Hand über Euch.";
        elseif Reputation >= 90 and Reputation < 150 then
            Text = Text .. "Die Leute sind zufrieden mit Eurer Herrschaft, Milord.";
        elseif Reputation >= 150 then
            Text = Text .. "Ihr seid unglaublich, Sir! Das Volk verehrt Euch.";
        end

        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
        return true;
    else
        return false;
    end
end

function Stronghold:PrintTooltipGenericForFindView(_PlayerID, _Key)
    local Text = XGUIEng.GetStringTableText(_Key);
    local Upkeep = 0;

    if _Key == "MenuTop/Find_spear" then
        local SpeerT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderPoleArm1] or 0;
        local SpeerT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderPoleArm2] or 0;
        local SpeerT3 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderPoleArm3] or 0;
        local SpeerT4 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderPoleArm4] or 0;
        Upkeep = SpeerT1+SpeerT2+SpeerT3+SpeerT4;
    elseif _Key == "MenuTop/Find_sword" then
        local SwordT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderSword1] or 0;
        local SwordT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderSword2] or 0;
        local SwordT3 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderSword3] or 0;
        local SwordT4 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderSword4] or 0;
        Upkeep = SwordT1+SwordT2+SwordT3+SwordT4;
    elseif _Key == "MenuTop/Find_bow" then
        local BowT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderBow1] or 0;
        local BowT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderBow2] or 0;
        local BowT3 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderBow3] or 0;
        local BowT4 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderBow4] or 0;
        Upkeep = BowT1+BowT2+BowT3+BowT4;
    elseif _Key == "MenuTop/Find_cannon" then
        local CannonT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PV_Cannon1] or 0;
        local CannonT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PV_Cannon2] or 0;
        local CannonT3 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PV_Cannon3] or 0;
        local CannonT4 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PV_Cannon4] or 0;
        Upkeep = CannonT1+CannonT2+CannonT3+CannonT4;
    elseif _Key == "MenuTop/Find_lightcavalry" then
        local LCavT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderCavalry1] or 0;
        local LcavT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderCavalry2] or 0;
        Upkeep = LCavT1+LcavT2;
    elseif _Key == "MenuTop/Find_heavycavalry" then
        local SCavT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderHeavyCavalry1] or 0;
        local ScavT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderHeavyCavalry2] or 0;
        Upkeep = SCavT1+ScavT2;
    elseif _Key == "AOMenuTop/Find_rifle" then
        local RifleT1 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderRifle1] or 0;
        local RifleT2 = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_LeaderRifle2] or 0;
        Upkeep = RifleT1+RifleT2;
    elseif _Key == "AOMenuTop/Find_scout" then
        Upkeep = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_Scout] or 0;
    elseif _Key == "AOMenuTop/Find_Thief" then
        Upkeep = Stronghold.Players[_PlayerID].UpkeepDetails[Entities.PU_Thief] or 0;
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text.. " @cr Unterhalt: @color:255,32,32 " ..Upkeep.. " @color:255,255,255 Taler");
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

