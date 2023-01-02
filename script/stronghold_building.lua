-- 
-- Building Script
--
-- This script implements buttons and all non-income properties of buildings.
-- 

Stronghold = Stronghold or {};

Stronghold.Config.Building = {
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
            Honor = 8,
        },
        [BlessCategories.Weapons] = {
            Text = "Eure Priester predigen Bibeltexte zu ihrer Gemeinde.",
            Reputation = 0,
            Honor = 16,
        },
        [BlessCategories.Financial] = {
            Text = "Eure Priester rufen auf zur Kollekte.",
            Reputation = 16,
            Honor = 0,
        },
        [BlessCategories.Canonisation] = {
            Text = "Eure Priester sprechen Eure Taten heilig.",
            Reputation = 12,
            Honor = 12,
        },
    }
}

-- -------------------------------------------------------------------------- --
-- Headquarters

function Stronghold:HeadquartersConfigureBuilding(_PlayerID)
    if self.Players[_PlayerID] then
        local ID = GetID(self.Players[_PlayerID].HQScriptName);
        if ID > 0 then
            local Index = 1;
            if Logic.GetEntityType(ID) == Entities.PB_Headquarters2 then
                Index = 2;
            end
            if Logic.GetEntityType(ID) == Entities.PB_Headquarters3 then
                Index = 3;
            end
            CEntity.SetArmor(ID, self.Config.Building.Headquarters.Stats.Armor[Index]);
            CEntity.SetMaxHealth(ID, self.Config.Building.Headquarters.Stats.Health[Index]);
            Logic.HealEntity(ID, self.Config.Building.Headquarters.Stats.Health[Index]);
        end
    end
end

function Stronghold:CreateHeadquartersButtonHandlers()
    Stronghold.Shared.Button = Stronghold.Shared.Button or {};

    Stronghold.Shared.Button.Headquarters = {
        ChangeTax = 1,
        BuyLord = 2,
        BuySpouse = 3,
    };

    function Stronghold_ButtonCallback_Headquarters(_PlayerID, _Action, ...)
        if _Action == Stronghold.Shared.Button.Headquarters.ChangeTax then
            Stronghold:HeadquartersButtonChangeTax(_PlayerID, arg[1]);
        end
        if _Action == Stronghold.Shared.Button.Headquarters.BuyLord then
            Stronghold:BuyHeroCreateLord(_PlayerID, arg[1]);
        end
        if _Action == Stronghold.Shared.Button.Headquarters.BuySpouse then
            Stronghold:BuyHeroCreateSpouse(_PlayerID, arg[1]);
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

function Stronghold:HeadquartersButtonChangeTax(_PlayerID, _Level)
    if self.Players[_PlayerID] then
        self.Players[_PlayerID].TaxHeight = math.min(math.max(_Level +1, 0), 5);
    end
end

function Stronghold:OverrdeHeadquarterButtons()
    GUIAction_SetTaxes_Orig_StrongholdBuilding = GUIAction_SetTaxes;
    GUIAction_SetTaxes = function(_Level)
        local PlayerID = GUI.GetPlayerID();
        if not self.Players[PlayerID] then
            return GUIAction_SetTaxes_Orig_StrongholdBuilding(_Level);
        end
        Sync.Call(
            "Stronghold_ButtonCallback_Headquarters",
            PlayerID,
            Stronghold.Shared.Button.Headquarters.ChangeTax,
            _Level
        );
    end

    GUIUpdate_TaxesButtons_Orig_StrongholdBuilding = GUIUpdate_TaxesButtons;
    GUIUpdate_TaxesButtons = function()
        local PlayerID = GUI.GetPlayerID();
        if not self.Players[PlayerID] then
            return GUIUpdate_TaxesButtons_Orig_StrongholdBuilding();
        end
        local TaxLevel = self.Players[PlayerID].TaxHeight -1;
        XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "taxesgroup");
	    XGUIEng.HighLightButton(gvGUI_WidgetID.TaxesButtons[TaxLevel], 1);
    end

    GUIAction_ToggleMenu_Orig_StrongholdBuilding = GUIAction_ToggleMenu;
    GUIAction_ToggleMenu = function(_Menu, _State)
        if _Menu == gvGUI_WidgetID.BuyHeroWindow and _State == -1 then
            Stronghold:OpenBuyHeroWindowForLordSelection(GUI.GetPlayerID());
        else
            GUIAction_ToggleMenu_Orig_StrongholdBuilding(_Menu, _State);
        end
    end

    GUIAction_CallMilitia = function()
        local PlayerID = GUI.GetPlayerID();
        Stronghold:OpenBuyHeroWindowForLordSelection(PlayerID);
    end

    GUIAction_BackToWork = function()
        local PlayerID = GUI.GetPlayerID();
        Stronghold:OpenBuyHeroWindowForSpouseSelection(PlayerID);
    end
end

function Stronghold:OnHeadquarterSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not self.Players[PlayerID] then
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

    if not self.Players[PlayerID].LordChosen then
        XGUIEng.ShowWidget("HQ_CallMilitia", 1);
        XGUIEng.ShowWidget("HQ_BackToWork", 0);
    else
        if not self.Players[PlayerID].SpouseChosen then
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

function Stronghold:PrintHeadquartersTaxButtonsTooltip(_PlayerID, _Key)
    local Text = XGUIEng.GetStringTableText(_Key);
    local EffectText = "";

    if _Key == "MenuHeadquarter/SetVeryLowTaxes" then        
        Text = "@color:180,180,180 Keine Steuer @color:255,255,255 @cr "..
               "Keine Steuern. Aber wie wollt Ihr zu Talern kommen?"

        local Effects = Stronghold.Config.Income.TaxEffect[1];
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
        local Penalty = Stronghold:CalculateReputationTaxPenaltyAmount(_PlayerID, 2, WorkerCount);
        local Effects = Stronghold.Config.Income.TaxEffect[2];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetNormalTaxes" then
        Text = "@color:180,180,180 Faire Steuer @color:255,255,255 @cr "..
               "Ihr verlangt die übliche Steuer von Eurem Volk.";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold:CalculateReputationTaxPenaltyAmount(_PlayerID, 3, WorkerCount);
        local Effects = Stronghold.Config.Income.TaxEffect[3];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetHighTaxes" then
        Text = "@color:180,180,180 Hohe Steuer @color:255,255,255 @cr "..
               "Ihr dreht an der Steuerschraube. Wenn das mal gut geht...";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold:CalculateReputationTaxPenaltyAmount(_PlayerID, 4, WorkerCount);
        local Effects = Stronghold.Config.Income.TaxEffect[4];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. (((-1) * (Penalty > 0 and Penalty)) or Effects.Reputation).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetVeryHighTaxes" then
        Text = "@color:180,180,180 Grausame Steuer @color:255,255,255 @cr "..
               "Ihr zieht Euren Untertanen das letzte Hemd aus!";

        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local Penalty = Stronghold:CalculateReputationTaxPenaltyAmount(_PlayerID, 5, WorkerCount);
        local Effects = Stronghold.Config.Income.TaxEffect[5];
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

            local Effects = Stronghold.Config.Income.Spouse;
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
function Stronghold:ApplyUpkeepDiscountBarracks(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Players[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        for i= 1, Barracks do
            if i > 10 then break; end
            Upkeep = Upkeep * 0.95;
        end
    end
    return Upkeep;
end

-- -------------------------------------------------------------------------- --
-- Archery

-- This function is called for each unit type individually.
function Stronghold:ApplyUpkeepDiscountArchery(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Players[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Archery2);
        for i= 1, Barracks do
            if i > 10 then break; end
            Upkeep = Upkeep * 0.95;
        end
    end
    return Upkeep;
end

-- -------------------------------------------------------------------------- --
-- Stable

-- This function is called for each unit type individually.
function Stronghold:ApplyUpkeepDiscountStable(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Players[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Stable2);
        for i= 1, Barracks do
            if i > 10 then break; end
            Upkeep = Upkeep * 0.95;
        end
    end
    return Upkeep;
end

-- -------------------------------------------------------------------------- --
-- Foundry

-- This function is called for each unit type individually.
function Stronghold:ApplyUpkeepDiscountFoundry(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Players[_PlayerID] and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Foundry2);
        for i= 1, Barracks do
            if i > 10 then break; end
            Upkeep = Upkeep * 0.95;
        end
    end
    return Upkeep;
end

-- -------------------------------------------------------------------------- --
-- Monastery

function Stronghold:CreateMonasteryButtonHandlers()
    Stronghold.Shared.Button = Stronghold.Shared.Button or {};

    Stronghold.Shared.Button.Monastery = {
        BlessSettlers = 1,
    };

    function Stronghold_ButtonCallback_Monastery(_PlayerID, _Action, ...)
        if _Action == Stronghold.Shared.Button.Monastery.BlessSettlers then
            Stronghold:MonasteryBlessSettlers(_PlayerID, arg[1]);
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

function Stronghold:MonasteryBlessSettlers(_PlayerID, _BlessCategory)
    local CurrentFaith = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Faith);
    Logic.SubFromPlayersGlobalResource(_PlayerID, ResourceType.Faith, CurrentFaith);

    local BlessData = self.Config.Building.Monastery[_BlessCategory];
    if BlessData.Reputation > 0 then
        self:AddPlayerReputation(_PlayerID, BlessData.Reputation);
        local Amount = self:GetPlayerReputation(_PlayerID);
        self:UpdateMotivationOfWorkers(_PlayerID, Amount);
    end
    if BlessData.Honor > 0 then
        self:AddPlayerHonor(_PlayerID, BlessData.Honor);
    end

    if GUI.GetPlayerID() == _PlayerID then
        GUI.AddNote(BlessData.Text);
        Sound.PlayGUISound(Sounds.Buildings_Monastery, 0);
        Sound.PlayFeedbackSound(Sounds.VoicesMentor_INFO_SettlersBlessed_rnd_01, 0);
    end
end

function Stronghold:OverrdeMonasteryButtons()
    GUIAction_BlessSettlers_Orig_StrongholdBuilding = GUIAction_BlessSettlers;
    GUIAction_BlessSettlers = function(_BlessCategory)
        local PlayerID = GUI.GetPlayerID();
        if not self.Players[PlayerID] then
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
                Stronghold.Shared.Button.Monastery.BlessSettlers,
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
                local Effects = Stronghold.Config.Building.Monastery[BlessCategories.Construction];
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
                local Effects = Stronghold.Config.Building.Monastery[BlessCategories.Research];
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
                local Effects = Stronghold.Config.Building.Monastery[BlessCategories.Weapons];
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
                local Effects = Stronghold.Config.Building.Monastery[BlessCategories.Financial];
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
                local Effects = Stronghold.Config.Building.Monastery[BlessCategories.Canonisation];
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

