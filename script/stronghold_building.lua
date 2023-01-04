-- 
-- Building Script
--
-- This script implements buttons and all non-income properties of buildings.
-- 

Stronghold = Stronghold or {};

Stronghold.Building = {
    SyncEvents = {},
    Data = {},
    Config = {
        Headquarters = {
            Stats = {Health = {5000, 7500, 10000}, Armor = {8, 12, 16}},
        },

        Monastery = {
            [BlessCategories.Construction] = {
                Text = "Eure Priester leuten die Glocke zum Gebet.",
                Reputation = 8,
                Honor = 0,
            },
            [BlessCategories.Research] = {
                Text = "Eure Priester vergeben die Sünden Eurer Arbeiter.",
                Reputation = 0,
                Honor = 4,
            },
            [BlessCategories.Weapons] = {
                Text = "Eure Priester predigen Bibeltexte zu ihrer Gemeinde.",
                Reputation = 16,
                Honor = 0,
            },
            [BlessCategories.Financial] = {
                Text = "Eure Priester rufen auf zur Kollekte.",
                Reputation = 8,
                Honor = 0,
            },
            [BlessCategories.Canonisation] = {
                Text = "Eure Priester sprechen Eure Taten heilig.",
                Reputation = 12,
                Honor = 6,
            },
        },
    },
}

function Stronghold.Building:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    self:OverrdeMonasteryButtons()
    self:OverrdeHeadquarterButtons();
    self:CreateHeadquartersButtonHandlers();
    self:CreateMonasteryButtonHandlers();
    self:CreateBarracksButtonHandlers();
    self:CreateArcheryButtonHandlers();
    self:CreateStableButtonHandlers();
    -- self:CreateFoundryButtonHandlers();
end

function Stronghold.Building:OnSaveGameLoaded()
    for i= 1, table.getn(Score.Player) do
        self:HeadquartersConfigureBuilding(i);
    end
end

-- -------------------------------------------------------------------------- --
-- Headquarters

function Stronghold.Building:HeadquartersConfigureBuilding(_PlayerID)
    if self.Data[_PlayerID] and Stronghold.Players[_PlayerID] then
        local ID = GetID(Stronghold.Players[_PlayerID].HQScriptName);
        if ID > 0 then
            local Index = 1;
            if Logic.GetEntityType(ID) == Entities.PB_Headquarters2 then
                Index = 2;
            end
            if Logic.GetEntityType(ID) == Entities.PB_Headquarters3 then
                Index = 3;
            end
            CEntity.SetArmor(ID, self.Config.Headquarters.Stats.Armor[Index]);
            CEntity.SetMaxHealth(ID, self.Config.Headquarters.Stats.Health[Index]);
            Logic.HealEntity(ID, self.Config.Headquarters.Stats.Health[Index]);
        end
    end
end

function Stronghold.Building:CreateHeadquartersButtonHandlers()
    self.SyncEvents.Headquarters = {
        ChangeTax = 1,
        BuyLord = 2,
        BuySpouse = 3,
        BuySerf = 4,
    };

    function Stronghold_ButtonCallback_Headquarters(_PlayerID, _Action, ...)
        if _Action == Stronghold.Building.SyncEvents.Headquarters.ChangeTax then
            Stronghold.Building:HeadquartersButtonChangeTax(_PlayerID, arg[1]);
        end
        if _Action == Stronghold.Building.SyncEvents.Headquarters.BuyLord then
            Stronghold.Hero:BuyHeroCreateLord(_PlayerID, arg[1]);
        end
        if _Action == Stronghold.Building.SyncEvents.Headquarters.BuySpouse then
            Stronghold.Hero:BuyHeroCreateSpouse(_PlayerID, arg[1]);
        end
        if _Action == Stronghold.Building.SyncEvents.Headquarters.BuySerf then
            Stronghold:BuyUnit(_PlayerID, arg[1], arg[2], arg[3]);
        end
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("Stronghold_ButtonCallback_Headquarters",
            function(name, _PlayerID, _Action, ...)
                if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
                    Stronghold_ButtonCallback_Headquarters(_PlayerID, _Action, unpack(arg));
                end;
            end
        );
    end;
end

function Stronghold.Building:HeadquartersButtonChangeTax(_PlayerID, _Level)
    if Stronghold.Players[_PlayerID] then
        Stronghold.Players[_PlayerID].TaxHeight = math.min(math.max(_Level +1, 0), 5);
    end
end

function Stronghold.Building:OverrdeHeadquarterButtons()
    GUIAction_SetTaxes_Orig_StrongholdBuilding = GUIAction_SetTaxes;
    GUIAction_SetTaxes = function(_Level)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Building.Data[PlayerID] then
            return GUIAction_SetTaxes_Orig_StrongholdBuilding(_Level);
        end
        Sync.Call(
            "Stronghold_ButtonCallback_Headquarters",
            PlayerID,
            Stronghold.Building.SyncEvents.Headquarters.ChangeTax,
            _Level
        );
    end

    GUIUpdate_TaxesButtons_Orig_StrongholdBuilding = GUIUpdate_TaxesButtons;
    GUIUpdate_TaxesButtons = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Building.Data[PlayerID] then
            return GUIUpdate_TaxesButtons_Orig_StrongholdBuilding();
        end
        local TaxLevel = Stronghold.Players[PlayerID].TaxHeight -1;
        XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "taxesgroup");
	    XGUIEng.HighLightButton(gvGUI_WidgetID.TaxesButtons[TaxLevel], 1);
    end

    GUIAction_ToggleMenu_Orig_StrongholdBuilding = GUIAction_ToggleMenu;
    GUIAction_ToggleMenu = function(_Menu, _State)
        if _Menu == gvGUI_WidgetID.BuyHeroWindow and _State == -1 then
            Stronghold.Hero:OpenBuyHeroWindowForLordSelection(GUI.GetPlayerID());
        else
            GUIAction_ToggleMenu_Orig_StrongholdBuilding(_Menu, _State);
        end
    end

    GUIAction_BuySerf_Orig_StrongholdBuilding = GUIAction_BuySerf;
    GUIAction_BuySerf = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Building.Data[PlayerID] then
            return GUIAction_BuySerf_Orig_StrongholdBuilding();
        end
        -- Check costs
        local Costs = Stronghold.Config.Units[Entities.PU_Serf].Costs;
        if HasPlayerEnoughResourcesFeedback(Costs) == 0 then
            return;
        end
        -- Check attraction
        if Logic.GetPlayerAttractionUsage(PlayerID) >= Logic.GetPlayerAttractionLimit(PlayerID) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesSerf_SERF_No_rnd_01);
            Message("Ihr habt keinen Platz für weitere Leibeigene!");
            return;
        end
        -- Buy lock
        if Stronghold.Building.Data[PlayerID].BuyUnitLock then
            return;
        end
        Stronghold.Building.Data[PlayerID].BuyUnitLock = true;
        -- Send call
        Sync.Call(
            "Stronghold_ButtonCallback_Headquarters",
            PlayerID,
            Stronghold.Building.SyncEvents.Headquarters.BuySerf,
            Entities.PU_Serf,
            GetID(Stronghold.Building.Data[PlayerID].HQScriptName),
            false
        );
    end

    GUIAction_CallMilitia = function()
        local PlayerID = GUI.GetPlayerID();
        Stronghold.Hero:OpenBuyHeroWindowForLordSelection(PlayerID);
    end

    GUIAction_BackToWork = function()
        local PlayerID = GUI.GetPlayerID();
        Stronghold.Hero:OpenBuyHeroWindowForSpouseSelection(PlayerID);
    end
end

function Stronghold.Building:OnHeadquarterSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] or not Stronghold.Players[PlayerID] then
        return;
    end
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return;
    end

    XGUIEng.ShowWidget("Buy_Hero", 0);
    XGUIEng.ShowWidget("HQ_Militia", 1);
    XGUIEng.SetWidgetPosition("HQ_Militia", 35, 0);
    XGUIEng.TransferMaterials("Buy_Hero", "HQ_CallMilitia");
    XGUIEng.TransferMaterials("Statistics_SubSettlers_Motivation", "HQ_BackToWork");

    if not Stronghold.Players[PlayerID].LordChosen then
        XGUIEng.ShowWidget("HQ_CallMilitia", 1);
        XGUIEng.ShowWidget("HQ_BackToWork", 0);
    else
        if not Stronghold.Players[PlayerID].SpouseChosen then
            XGUIEng.ShowWidget("HQ_CallMilitia", 0);
            XGUIEng.ShowWidget("HQ_BackToWork", 1);
            local Disabled = Logic.GetEntityType(_EntityID) == Entities.PB_Headquarters1;
            XGUIEng.DisableButton("HQ_BackToWork", (Disabled and 1) or 0);
        else
            XGUIEng.ShowWidget("HQ_CallMilitia", 0);
            XGUIEng.ShowWidget("HQ_BackToWork", 0);
        end
    end
end

function Stronghold.Building:PrintHeadquartersTaxButtonsTooltip(_PlayerID, _Key)
    local Text = XGUIEng.GetStringTableText(_Key);
    local EffectText = "";

    if _Key == "MenuHeadquarter/SetVeryLowTaxes" then        
        Text = "@color:180,180,180 Keine Steuer @color:255,255,255 @cr "..
               "Keine Steuern. Aber wie wollt Ihr zu Talern kommen?"

        local Effects = Stronghold.Economy.Config.Income.TaxEffect[1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation ~= 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetLowTaxes" then
        Text = "@color:180,180,180 Niedrige Steuer @color:255,255,255 @cr "..
               "Ihr seid großzügig und entlastet Eure Untertanen.";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 2, WorkerCount);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[2];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetNormalTaxes" then
        Text = "@color:180,180,180 Faire Steuer @color:255,255,255 @cr "..
               "Ihr verlangt die übliche Steuer von Eurem Volk.";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 3, WorkerCount);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[3];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetHighTaxes" then
        Text = "@color:180,180,180 Hohe Steuer @color:255,255,255 @cr "..
               "Ihr dreht an der Steuerschraube. Wenn das mal gut geht...";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 4, WorkerCount);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[4];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetVeryHighTaxes" then
        Text = "@color:180,180,180 Grausame Steuer @color:255,255,255 @cr "..
               "Ihr zieht Euren Untertanen das letzte Hemd aus!";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 5, WorkerCount);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[5];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/CallMilitia" then
        if Logic.IsEntityInCategory(GUI.GetSelectedEntity(), EntityCategories.Headquarters) == 1 then
            Text = "@color:180,180,180 Burgherren wählen @color:255,255,255 "..
                   "@cr Wählt euren Burgherren aus. Jeder Burgherr verfügt "..
                   "über starke Fähigkeiten.";
        end
    elseif _Key == "MenuHeadquarter/BackToWork" then
        if Logic.IsEntityInCategory(GUI.GetSelectedEntity(), EntityCategories.Headquarters) == 1 then
            Text = "@color:180,180,180 Burgfräulein wählen @color:255,255,255 ";

            if Logic.GetEntityType(GUI.GetSelectedEntity()) == Entities.PB_Headquarters1 then
                Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                       "Festung";
            else
                Text = Text .. " @cr Die bessere Hälfte Eures Burgherren. Sie "..
                       "gewährt Euch extra Beliebtheit und Ehre, solange sie lebt.";
            end

            local Effects = Stronghold.Economy.Config.Income.Spouse;
            EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
            if Effects.Reputation > 0 then
                EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
            end
            if Effects.Honor > 0 then
                EffectText = EffectText.. "+" ..Effects.Honor.." Ehre ";
            end
        end
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text.. " " ..EffectText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Barracks

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountBarracks(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Data[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:CreateBarracksButtonHandlers()
    self.SyncEvents.Button = self.SyncEvents.Button or {};

    self.SyncEvents.Barracks = {
        BuyUnit = 1,
    };

    function Stronghold_ButtonCallback_Barracks(_PlayerID, ...)
        if arg[2] == Stronghold.Building.SyncEvents.Barracks.BuyUnit then
            if arg[3] ~= 0 then
                Stronghold:BuyUnit(_PlayerID, arg[3], arg[1], arg[4]);
            end
            Stronghold.Building.Data[_PlayerID].BuyUnitLock = false;
            return;
        end
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("Stronghold_ButtonCallback_Barracks",
            function(name, _PlayerID, _Action, ...)
                if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
                    Stronghold_ButtonCallback_Barracks(_PlayerID, _Action, unpack(arg));
                end;
            end
        );
    end;
end

function Stronghold.Building:OnBarracksSettlerUpgradeTechnologyClicked(_Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return false;
    end
    if self.Data[PlayerID].BuyUnitLock then
        return false;
    end

    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeSword1 then
        UnitType = Entities.PU_LeaderPoleArm1;
        Action = self.SyncEvents.Barracks.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword2 then
        UnitType = Entities.PU_LeaderPoleArm3;
        Action = self.SyncEvents.Barracks.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword3 then
        UnitType = Entities.PU_LeaderSword3;
        Action = self.SyncEvents.Barracks.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword4 then
        UnitType = Entities.PU_LeaderSword4;
        Action = self.SyncEvents.Barracks.BuyUnit;
    end

    if Action > 0 then
        local Costs = CreateCostTable(unpack(Stronghold.Config.Units[UnitType].Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if not HasPlayerEnoughResourcesFeedback(Costs) then
            self.Data[PlayerID].BuyUnitLock = true;
            Sync.Call(
                "Stronghold_ButtonCallback_Barracks",
                PlayerID, EntityID, Action, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnBarracksSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID)
    if Type ~= Entities.PB_Barracks1 and Type ~= Entities.PB_Barracks2 then
        return;
    end

    XGUIEng.TransferMaterials("Buy_LeaderSpear", "Research_UpgradeSword1");
    XGUIEng.TransferMaterials("Buy_LeaderSpear", "Research_UpgradeSword2");
    XGUIEng.TransferMaterials("Buy_LeaderSword", "Research_UpgradeSword3");
    XGUIEng.TransferMaterials("Buy_LeaderSword", "Research_UpgradeSpear1");
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeSword1", 4, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeSword2", 38, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeSword3", 72, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeSpear1", 106, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeSpear2", 140, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeSpear3", 174, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_BetterTrainingBarracks", 4, 38, 31, 31);
    XGUIEng.ShowWidget("Buy_LeaderSword", 0);
    XGUIEng.ShowWidget("Buy_LeaderSpear", 0);
    XGUIEng.ShowWidget("Research_UpgradeSword3", 1);
    XGUIEng.ShowWidget("Research_UpgradeSpear1", 1);
    XGUIEng.ShowWidget("Research_UpgradeSpear2", 0);
    XGUIEng.ShowWidget("Research_UpgradeSpear3", 0);

    local Blacksmith1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Blacksmith1));
    local Blacksmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith2);
    local Blacksmith3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith3);

    local Sawmill1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Sawmill1));
    local Sawmill2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill2);

    local Rank = Stronghold.Players[PlayerID].Rank;

    -- Spearmen
    local SpearDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderPoleArm1].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderPoleArm1].Rank then
        SpearDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword1", SpearDisabled);

    -- Lancers
    local LancerDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderPoleArm3].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderPoleArm3].Rank
    or Sawmill1 + Sawmill2 == 0 then
        LancerDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword2", LancerDisabled);

    -- Longsword
    local SwordDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderSword3].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderSword3].Rank
    or Type ~= Entities.PB_Barracks2
    or Blacksmith1 + Blacksmith2 + Blacksmith3 == 0 then
        SwordDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword3", SwordDisabled);

    -- Bastards
    local SwordDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderSword4].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderSword4].Rank
    or Type ~= Entities.PB_Barracks2
    or Blacksmith3 == 0 then
        SwordDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSpear1", SwordDisabled);
end

function Stronghold.Building:UpdateUpgradeSettlersBarracksTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local Text = "";
    local CostsText = "";

    if _TextKey == "MenuBarracks/UpgradeSword1" then
        local Type = Entities.PU_LeaderPoleArm1;
        Text = "@color:180,180,180 Speerträger @color:255,255,255 "..
               "@cr Das Gesindel des Landes für den Krieg zusammengekehrt "..
               " erwartet Euren Befehl.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 5; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " ..Stronghold.Config.Text.Ranks[Rank];
        end

    elseif _TextKey == "MenuBarracks/UpgradeSword2" then
        local Type = Entities.PU_LeaderPoleArm3;
        Text = "@color:180,180,180 Lanzenträger @color:255,255,255 "..
               "@cr Die Leibwache Eures Burgherren. Sie sind gut gepanzert "..
               "und besonders stark gegen Kavalerie.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " ..Stronghold.Config.Text.Ranks[Rank].. ", Sägemühle"
        end

    elseif _TextKey == "MenuBarracks/UpgradeSword3" then
        local Type = Entities.PU_LeaderSword3;
        Text = "@color:180,180,180 Langschwertkämpfer @color:255,255,255 "..
               "@cr Schwer gepanzerte Berufssoldaten, die für Euch über jede "..
               " Klinge springen.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Garnison, Schmiede";
        end

    elseif _TextKey == "MenuBarracks/UpgradeSpear1" then
        local Type = Entities.PU_LeaderSword4;
        Text = "@color:180,180,180 Bastardschwertkämpfer @color:255,255,255 "..
               "@cr Die schwerste Infanterie, die Ihr in die Schlacht werfen "..
               "könnt. Diese Männer fürchten weder Tod noch Teufel.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Garnison, Feinschmiede";
        end

    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Archery

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountArchery(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Data[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Archery2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:CreateArcheryButtonHandlers()
    self.SyncEvents.Archery = {
        BuyUnit = 1,
    };

    function Stronghold_ButtonCallback_Archery(_PlayerID, ...)
        if arg[2] == self.SyncEvents.Archery.BuyUnit then
            if arg[3] ~= 0 then
                Stronghold:BuyUnit(_PlayerID, arg[3], arg[1], arg[4]);
            end
            Stronghold.Building.Data[_PlayerID].BuyUnitLock = false;
            return;
        end
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("Stronghold_ButtonCallback_Archery",
            function(name, _PlayerID, _Action, ...)
                if CNetwork.Stronghold_ButtonCallback_Archery(name, _PlayerID) then
                    Stronghold_ButtonCallback_Archery(_PlayerID, _Action, unpack(arg));
                end;
            end
        );
    end;
end

function Stronghold.Building:OnArcherySettlerUpgradeTechnologyClicked(_Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return false;
    end
    if self.Data[PlayerID].BuyUnitLock then
        return false;
    end

    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeBow1 then
        UnitType = Entities.PU_LeaderBow2;
        Action = self.SyncEvents.Archery.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeBow2 then
        UnitType = Entities.PU_LeaderBow3;
        Action = self.SyncEvents.Archery.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeBow3 then
        UnitType = Entities.PU_LeaderRifle1;
        Action = self.SyncEvents.Archery.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeRifle1 then
        UnitType = Entities.PU_LeaderRifle2;
        Action = self.SyncEvents.Archery.BuyUnit;
    end

    if Action > 0 then
        local Costs = CreateCostTable(unpack(Stronghold.Config.Units[UnitType].Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, unpack(Costs));
        if not HasPlayerEnoughResourcesFeedback(Costs) then
            self.Data[PlayerID].BuyUnitLock = true;
            Sync.Call(
                "Stronghold_ButtonCallback_Archery",
                PlayerID, EntityID, Action, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnArcherySelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID)
    if Type ~= Entities.PB_Archery1 and Type ~= Entities.PB_Archery2 then
        return;
    end

    XGUIEng.TransferMaterials("Buy_LeaderBow", "Research_UpgradeBow1");
    XGUIEng.TransferMaterials("Buy_LeaderBow", "Research_UpgradeBow2");
    XGUIEng.TransferMaterials("Buy_LeaderRifle", "Research_UpgradeBow3");
    XGUIEng.TransferMaterials("Buy_LeaderRifle", "Research_UpgradeRifle1");
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeBow1", 4, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeBow2", 38, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeBow3", 72, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeRifle1", 106, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_BetterTrainingArchery", 4, 40, 31, 31);
    XGUIEng.ShowWidget("Buy_LeaderBow", 0);
    XGUIEng.ShowWidget("Buy_LeaderRifle", 0);
    XGUIEng.ShowWidget("Research_UpgradeBow3", 1);
    XGUIEng.ShowWidget("Research_UpgradeRifle1", 1);

    local Gunsmith1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_GunsmithWorkshop1));
    local Gunsmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_GunsmithWorkshop2);

    local Sawmill1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Sawmill1));
    local Sawmill2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill2);

    local Rank = Stronghold.Players[PlayerID].Rank;

    -- Bowmen
    local BowDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderBow2].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderBow2].Rank
    or Sawmill1 + Sawmill2 == 0  then
        BowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow1", BowDisabled);

    -- Crossbow
    local CrossbowDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderBow3].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderBow3].Rank
    or Sawmill1 + Sawmill2 == 0 then
        CrossbowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow2", CrossbowDisabled);

    -- Rifle
    local RifleDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderRifle1].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderRifle1].Rank
    or Gunsmith1 + Gunsmith2 == 0 then
        RifleDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow3", RifleDisabled);

    -- Musket
    local MusketDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderRifle2].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderRifle2].Rank
    or Type ~= Entities.PB_Archery2
    or Gunsmith1 + Gunsmith2 == 0 then
        MusketDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeRifle1", MusketDisabled);
end

function Stronghold.Building:UpdateUpgradeSettlersArcheryTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local CostsText = "";
    local Text = "";

    if _TextKey == "MenuArchery/UpgradeBow1" then
        local Type = Entities.PU_LeaderBow2;
        Text = "@color:180,180,180 Langbogenschützen @color:255,255,255 "..
               "@cr Diese Männer sind vor allem gegen Speerträger und Reiter "..
               "sehr effektiv.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 5; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Sägemühle";
        end

    elseif _TextKey == "MenuArchery/UpgradeBow2" then
        local Type = Entities.PU_LeaderBow3;
        Text = "@color:180,180,180 Armbrustschützen @color:255,255,255 "..
               "@cr Loyale und gut ausgebiltete Schützen. Sie werden Euer "..
               "Heer  hervorragend ergänzen.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Schießanlage, Sägemühle";
        end

    elseif _TextKey == "MenuArchery/UpgradeBow3" then
        local Type = Entities.PU_LeaderRifle1;
        Text = "@color:180,180,180 Leichte Scharfschützen @color:255,255,255 "..
               "@cr Diese Männer nutzen die neuen Feuerwaffen. Sie sind stark"..
               " gegen gepanzerte Einheiten.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 5; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Büchsenmacher";
        end

    elseif _TextKey == "AOMenuArchery/UpgradeRifle1" then
        local Type = Entities.PU_LeaderRifle2;
        Text = "@color:180,180,180 Schwere Scharfschützen @color:255,255,255 "..
               "@cr Die verbesserten Gewehre haben eine gewaltige Reichweite. "..
               "Keine Waffe der bekannten Welt trifft aus dieser Distanz.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Schießanlage, Büchsenmacher";
        end
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Stable

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountStable(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Data[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Stable2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:CreateStableButtonHandlers()
    self.SyncEvents.Stable = {
        BuyUnit = 1,
    };

    function Stronghold_ButtonCallback_Stable(_PlayerID, ...)
        if arg[2] == Stronghold.Building.SyncEvents.Stable.BuyUnit then
            if arg[3] ~= 0 then
                Stronghold:BuyUnit(_PlayerID, arg[3], arg[1], arg[4]);
            end
            Stronghold.Building.Data[_PlayerID].BuyUnitLock = false;
            return;
        end
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("Stronghold_ButtonCallback_Stable",
            function(name, _PlayerID, _Action, ...)
                if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
                    Stronghold_ButtonCallback_Stable(_PlayerID, _Action, unpack(arg));
                end;
            end
        );
    end;
end

function Stronghold.Building:OnStableSettlerUpgradeTechnologyClicked(_Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return false;
    end
    if self.Data[PlayerID].BuyUnitLock then
        return false;
    end

    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeLightCavalry1 then
        UnitType = Entities.PU_LeaderCavalry2;
        Action = self.SyncEvents.Stable.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeHeavyCavalry1 then
        UnitType = Entities.PU_LeaderHeavyCavalry2;
        Action = self.SyncEvents.Stable.BuyUnit;
    end

    if Action > 0 then
        local Costs = CreateCostTable(unpack(Stronghold.Config.Units[UnitType].Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if not HasPlayerEnoughResourcesFeedback(Costs) then
            self.Data[PlayerID].BuyUnitLock = true;
            Sync.Call(
                "Stronghold_ButtonCallback_Stable",
                PlayerID, EntityID, Action, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnStableSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID)
    if Type ~= Entities.PB_Stable1 and Type ~= Entities.PB_Stable2 then
        return;
    end

    XGUIEng.TransferMaterials("Buy_LeaderCavalryLight", "Research_UpgradeCavalryLight1");
    XGUIEng.TransferMaterials("Buy_LeaderCavalryHeavy", "Research_UpgradeCavalryHeavy1");
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeCavalryLight1", 4, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_UpgradeCavalryHeavy1", 38, 4, 31, 31);
    XGUIEng.SetWidgetPositionAndSize("Research_Shoeing", 4, 40, 31, 31);
    XGUIEng.ShowWidget("Buy_LeaderCavalryLight", 0);
    XGUIEng.ShowWidget("Buy_LeaderCavalryHeavy", 0);

    local Blacksmith1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Blacksmith1));
    local Blacksmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith2);
    local Blacksmith3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith3);

    local Rank = Stronghold.Players[PlayerID].Rank;

    -- Bowmen
    local BowDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderCavalry2].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderCavalry2].Rank then
        BowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeCavalryLight1", BowDisabled);

    -- Knights
    local KnightDisabled = 0;
    if Stronghold.Config.Units[Entities.PU_LeaderHeavyCavalry2].Allowed == false
    or Rank < Stronghold.Config.Units[Entities.PU_LeaderHeavyCavalry2].Rank
    or Type ~= Entities.PB_Stable2
    or Blacksmith3 == 0 then
        KnightDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeCavalryHeavy1", KnightDisabled);
end

function Stronghold.Building:UpdateUpgradeSettlersStableTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local Text = "";

    if _TextKey == "MenuStables/UpgradeCavalryLight1" then
        local Type = Entities.PU_LeaderCavalry2;
        Text = "@color:180,180,180 Berittene Armbrustschützen @color:255,255,255 "..
               "@cr Der Vorteil der berittenen Armbrustschützen ist ihre hohe "..
               "Flexibelität und Geschwindigkeit.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 4; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. "";
        end

    elseif _TextKey == "MenuStables/UpgradeCavalryHeavy1" then
        local Type = Entities.PU_LeaderHeavyCavalry2;
        Text = "@color:180,180,180 Berittene Streitaxtkämpfer @color:255,255,255 "..
               "@cr Treue Ritter, die jeden Gegner gnadenlos niedermähen, der "..
               "es wagt, sich Euch entgegenzustallen.";

        -- Costs text
        local Costs = CopyTable(Stronghold.Config.Units[Type].Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 4; end
        end
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, CreateCostTable(unpack(Costs)));
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Stronghold.Config.Units[Type].Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            local Rank = Stronghold.Config.Units[Type].Rank;
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold.Config.Text.Ranks[Rank].. ", Reiterei, Feinschmiede";
        end

    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Foundry

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountFoundry(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Data[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Foundry2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:OnFoundrySelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not self.Data[PlayerID] then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID)
    if Type ~= Entities.PB_Foundry1 and Type ~= Entities.PB_Foundry2 then
        return;
    end
end

-- -------------------------------------------------------------------------- --
-- Monastery

function Stronghold.Building:CreateMonasteryButtonHandlers()
    self.SyncEvents = self.SyncEvents or {};

    self.SyncEvents.Monastery = {
        BlessSettlers = 1,
    };

    function Stronghold_ButtonCallback_Monastery(_PlayerID, _Action, ...)
        if _Action == Stronghold.Building.SyncEvents.Monastery.BlessSettlers then
            Stronghold.Building:MonasteryBlessSettlers(_PlayerID, arg[1]);
        end
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("Stronghold_ButtonCallback_Monastery",
            function(name, _PlayerID, _Action, ...)
                if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
                    Stronghold_ButtonCallback_Monastery(_PlayerID, _Action, unpack(arg));
                end;
            end
        );
    end;
end

function Stronghold.Building:MonasteryBlessSettlers(_PlayerID, _BlessCategory)
    local CurrentFaith = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Faith);
    Logic.SubFromPlayersGlobalResource(_PlayerID, ResourceType.Faith, CurrentFaith);

    local BlessData = self.Config.Monastery[_BlessCategory];
    if BlessData.Reputation > 0 then
        Stronghold:AddPlayerReputation(_PlayerID, BlessData.Reputation);
        local Amount = Stronghold:GetPlayerReputation(_PlayerID);
        Stronghold:UpdateMotivationOfWorkers(_PlayerID, Amount);
    end
    if BlessData.Honor > 0 then
        Stronghold:AddPlayerHonor(_PlayerID, BlessData.Honor);
    end

    if GUI.GetPlayerID() == _PlayerID then
        GUI.AddNote(BlessData.Text);
        Sound.PlayGUISound(Sounds.Buildings_Monastery, 0);
        Sound.PlayFeedbackSound(Sounds.VoicesMentor_INFO_SettlersBlessed_rnd_01, 0);
    end
end

function Stronghold.Building:OverrdeMonasteryButtons()
    GUIAction_BlessSettlers_Orig_StrongholdBuilding = GUIAction_BlessSettlers;
    GUIAction_BlessSettlers = function(_BlessCategory)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Building.Data[PlayerID] then
            return GUIAction_BlessSettlers_Orig_StrongholdBuilding(_BlessCategory);
        end

        if InterfaceTool_IsBuildingDoingSomething(GUI.GetSelectedEntity()) == true then
            return;
        end
        local CurrentFaith = Logic.GetPlayersGlobalResource(PlayerID, ResourceType.Faith);
        local BlessCosts = Logic.GetBlessCostByBlessCategory(_BlessCategory);
        if BlessCosts <= CurrentFaith then
            Sync.Call(
                "Stronghold_ButtonCallback_Monastery",
                PlayerID,
                Stronghold.Building.SyncEvents.Monastery.BlessSettlers,
                _BlessCategory
            );
        else
            GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_NotEnoughFaith"));
            Sound.PlayFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01, 0);
        end
    end

    GUITooltip_BlessSettlers_Orig_StrongholdBuilding = GUITooltip_BlessSettlers;
	GUITooltip_BlessSettlers = function(_TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut)
        GUITooltip_BlessSettlers_Orig_StrongholdBuilding(_TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut);

        local PlayerID = GUI.GetPlayerID();
        local Text = "";
        if _TooltipNormal == "AOMenuMonastery/BlessSettlers1_normal" then
            if Logic.GetTechnologyState(PlayerID, Technologies.T_BlessSettlers1) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
            else
                Text = "@color:180,180,180 Gebetsmesse @color:255,255,255 @cr ";
                Text = Text .. " @color:244,184,0 bewirkt: @color:255,255,255 ";
                local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Construction];
                if Effects.Reputation > 0 then
                    Text = Text.. "+" ..Effects.Reputation.. " Beliebtheit ";
                end
                if Effects.Honor > 0 then
                    Text = Text.. "+" ..Effects.Honor.." Ehre";
                end
            end
		elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers2_normal" then
			if Logic.GetTechnologyState(PlayerID, Technologies.T_BlessSettlers2) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
            else
                Text = "@color:180,180,180 Ablassbriefe @color:255,255,255 @cr ";
                Text = Text .. " @color:244,184,0 bewirkt: @color:255,255,255 ";
                local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Research];
                if Effects.Reputation > 0 then
                    Text = Text.. "+" ..Effects.Reputation.. " Beliebtheit ";
                end
                if Effects.Honor > 0 then
                    Text = Text.. "+" ..Effects.Honor.." Ehre";
                end
            end
		elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers3_normal" then
			if Logic.GetTechnologyState(PlayerID, Technologies.T_BlessSettlers3) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
            else
                Text = "@color:180,180,180 Bibeln @color:255,255,255 @cr ";
                if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
                    Text = Text .. " @color:244,184,0 benötigt: @color:255,255,255 Kirche @cr";
                end
                Text = Text .. " @color:244,184,0 bewirkt: @color:255,255,255 ";
                local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Weapons];
                if Effects.Reputation > 0 then
                    Text = Text.. "+" ..Effects.Reputation.. " Beliebtheit ";
                end
                if Effects.Honor > 0 then
                    Text = Text.. "+" ..Effects.Honor.." Ehre";
                end
            end
		elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers4_normal" then
			if Logic.GetTechnologyState(PlayerID, Technologies.T_BlessSettlers4) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
            else
                Text = "@color:180,180,180 Kollekte @color:255,255,255 @cr ";
                if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
                    Text = Text .. " @color:244,184,0 benötigt: @color:255,255,255 Kirche @cr";
                end
                Text = Text .. " @color:244,184,0 bewirkt: @color:255,255,255 ";
                local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Financial];
                if Effects.Reputation > 0 then
                    Text = Text.. "+" ..Effects.Reputation.. " Beliebtheit ";
                end
                if Effects.Honor > 0 then
                    Text = Text.. "+" ..Effects.Honor.." Ehre";
                end
            end
		elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers5_normal" then
			if Logic.GetTechnologyState(PlayerID, Technologies.T_BlessSettlers5) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
            else
                Text = "@color:180,180,180 Heiligsprechung @color:255,255,255 @cr ";
                if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
                    Text = Text .. " @color:244,184,0 benötigt: @color:255,255,255 Kathedrale @cr";
                end
                Text = Text .. " @color:244,184,0 bewirkt: @color:255,255,255 ";
                local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Canonisation];
                if Effects.Reputation > 0 then
                    Text = Text.. "+" ..Effects.Reputation.. " Beliebtheit ";
                end
                if Effects.Honor > 0 then
                    Text = Text.. "+" ..Effects.Honor.." Ehre";
                end
            end
		end

        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    end
end

