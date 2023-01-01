-- 
-- Building Script
--
-- This script implements buttons and all non-income properties of buildings.
-- 

Stronghold = Stronghold or {};

-- -------------------------------------------------------------------------- --
-- Headquarters

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
        if Effects.Reputation > 0 then
            EffectText = EffectText.. ((Effects.Reputation > 0 and "+") or "") ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetLowTaxes" then
        Text = "@color:180,180,180 Niedrige Steuer @color:255,255,255 @cr "..
               "Ihr seid großzügig und entlastet Eure Untertanen.";

        local Effects = Stronghold.Config.Income.TaxEffect[1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. ((Effects.Reputation > 0 and "+") or "") ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetNormalTaxes" then
        Text = "@color:180,180,180 Faire Steuer @color:255,255,255 @cr "..
               "Ihr verlangt die übliche Steuer von Eurem Volk.";

        local Effects = Stronghold.Config.Income.TaxEffect[1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. ((Effects.Reputation > 0 and "+") or "") ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetHighTaxes" then
        Text = "@color:180,180,180 Hohe Steuer @color:255,255,255 @cr "..
               "Ihr dreht an der Steuerschraube. Wenn das mal gut geht...";

        local Effects = Stronghold.Config.Income.TaxEffect[1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. ((Effects.Reputation > 0 and "+") or "") ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetVeryHighTaxes" then
        Text = "@color:180,180,180 Grausame Steuer @color:255,255,255 @cr "..
               "Ihr zieht Euren Untertanen das letzte Hemd aus!";

        local Effects = Stronghold.Config.Income.TaxEffect[1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. ((Effects.Reputation > 0 and "+") or "") ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/CallMilitia" then
        if Logic.IsEntityInCategory(GUI.GetSelectedEntity(), EntityCategories.Headquarters) == 1 then
            Text = "@color:180,180,180 Burgherren wählen @color:255,255,255 "..
                   "@cr Wählt euren Burgherren aus. Jeder Burgherr verfügt "..
                   "über starke Fähigkeiten. Sein Wohlergehen entscheidet "..
                   "über Gedeih oder Verderb Eurer Burg!";
        end
    elseif _Key == "MenuHeadquarter/BackToWork" then
        if Logic.IsEntityInCategory(GUI.GetSelectedEntity(), EntityCategories.Headquarters) == 1 then
            Text = "@color:180,180,180 Burgfräulein wählen @color:255,255,255 ";

            if Logic.GetEntityType(GUI.GetSelectedEntity()) == Entities.PB_Headquarters1 then
                Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 ";
            else
                Text = Text .. " @cr Die bessere Hälfte Eures Burgherren. Sie "..
                       "gewährt Euch extra Beliebtheit und Ehre, solange sie lebt.";
            end

            local Effects = Stronghold.Config.Income.TaxEffect[1];
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

