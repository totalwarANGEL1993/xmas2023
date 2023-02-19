--- 
--- Building Script
---
--- This script implements buttons and all non-income properties of buildings.
--- 

Stronghold = Stronghold or {};

Stronghold.Building = {
    SyncEvents = {},
    Data = {},
    Config = {
        Headquarters = {
            Health = {3500, 4500, 5500},
            Armor  = {10, 12, 14},

            [BlessCategories.Construction] = {
                Text = "Ihr sprecht Recht und bestraft Kriminelle. Das Volk begrüßt dies!",
                Reputation = 5,
                Honor = 10,
            },
            [BlessCategories.Research] = {
                Text = "Die Siedler werden zur Kasse gebeten, was sie sehr verärgert!",
                Reputation = -18,
                Honor = 0,
            },
            [BlessCategories.Weapons] = {
                Text = "Eure Migrationspolitik wird von den zugezogenen Siedlern begrüßt.",
                Reputation = 100,
                Honor = 0,
            },
            [BlessCategories.Financial] = {
                Text = "Das Volksfest erfreut die Siedler und steigert Eure Beliebtheit.",
                Reputation = 22,
                Honor = 0,
            },
            [BlessCategories.Canonisation] = {
                Text = "Ein Bankett gereicht Euch an Ehre, aber verärgert das Volk!",
                Reputation = -40,
                Honor = 100,
            },
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
                Reputation = 16,
                Honor = 0,
            },
            [BlessCategories.Financial] = {
                Text = "Eure Priester rufen die Siedler auf zur Kollekte.",
                Reputation = 0,
                Honor = 16,
            },
            [BlessCategories.Canonisation] = {
                Text = "Eure Priester sprechen Eure Taten heilig.",
                Reputation = 12,
                Honor = 12,
            },
        },
    },
}

function Stronghold.Building:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    XGUIEng.TransferMaterials("BlessSettlers1", "Research_PickAxe");
    XGUIEng.TransferMaterials("BlessSettlers2", "Research_LightBricks");
    XGUIEng.TransferMaterials("BlessSettlers3", "Research_Taxation");
    XGUIEng.TransferMaterials("BlessSettlers4", "Research_Debenture");
    XGUIEng.TransferMaterials("BlessSettlers5", "Research_Scale");

    self:CreateBuildingButtonHandlers();
    self:OverrideMonasteryInterface()
    self:OverrideHeadquarterButtons();
    self:OverrideManualButtonUpdate();
    self:OverrideSellBuildingAction();
    self:OverrideUpdateConstructionButton();
    self:OverrideChangeBuildingMenuButton();
    self:InitalizeBuyUnitKeybindings();
end

function Stronghold.Building:OnSaveGameLoaded()
    XGUIEng.TransferMaterials("BlessSettlers1", "Research_PickAxe");
    XGUIEng.TransferMaterials("BlessSettlers2", "Research_LightBricks");
    XGUIEng.TransferMaterials("BlessSettlers3", "Research_Taxation");
    XGUIEng.TransferMaterials("BlessSettlers4", "Research_Debenture");
    XGUIEng.TransferMaterials("BlessSettlers5", "Research_Scale");

    self:OverrideManualButtonUpdate();
    self:OverrideSellBuildingAction();
    self:InitalizeBuyUnitKeybindings();
end

function Stronghold.Building:CreateBuildingButtonHandlers()
    self.SyncEvents = {
        ChangeTax = 1,
        BuySerf = 3,
        BuyUnit = 4,
        BlessSettlers = 5,
        MeasureTaken = 6,
    };

    self.NetworkCall = Syncer.CreateEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Building.SyncEvents.ChangeTax then
                Stronghold.Building:HeadquartersButtonChangeTax(_PlayerID, arg[1]);
            end
            if _Action == Stronghold.Building.SyncEvents.BuySerf then
                Stronghold.Unit:BuyUnit(_PlayerID, arg[2], arg[1], arg[3]);
            end
            if _Action == Stronghold.Building.SyncEvents.BuyUnit then
                Stronghold.Unit:BuyUnit(_PlayerID, arg[2], arg[1], arg[3]);
            end
            if _Action == Stronghold.Building.SyncEvents.BlessSettlers then
                Stronghold.Building:MonasteryBlessSettlers(_PlayerID, arg[1]);
            end
            if _Action == Stronghold.Building.SyncEvents.MeasureTaken then
                Stronghold.Building:HeadquartersBlessSettlers(_PlayerID, arg[1]);
            end
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Headquarters

function Stronghold.Building:HeadquartersButtonChangeTax(_PlayerID, _Level)
    if Stronghold:IsPlayer(_PlayerID) then
        Stronghold.Players[_PlayerID].TaxHeight = math.min(math.max(_Level +1, 0), 5);
    end
end

-- Regulas Headquarters

function Stronghold.Building:OverrideHeadquarterButtons()
    Overwrite.CreateOverwrite(
        "GUIAction_SetTaxes",
        function(_Level)
            Stronghold.Building:AdjustTax(_Level);
        end
    );

    Overwrite.CreateOverwrite(
        "GUIUpdate_TaxesButtons",
        function()
            local PlayerID = Stronghold:GetLocalPlayerID();
            local TaxLevel = Stronghold.Players[PlayerID].TaxHeight -1;
            XGUIEng.UnHighLightGroup(gvGUI_WidgetID.InGame, "taxesgroup");
            XGUIEng.HighLightButton(gvGUI_WidgetID.TaxesButtons[TaxLevel], 1);
        end
    );

    Overwrite.CreateOverwrite(
        "GUIAction_BuySerf",
        function()
            Stronghold.Building:HeadquartersBuySerf();
        end
    );

    GUIAction_CallMilitia = function()
        XGUIEng.ShowWidget("BuyHeroWindow", 1);
    end

    GUIAction_BackToWork = function()
    end
end

function Stronghold.Building:AdjustTax(_Level)
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local PlayerID = GUI.GetPlayerID();
    if GuiPlayer ~= PlayerID then
        return false;
    end
    if not Stronghold.Building.Data[PlayerID] then
        return false;
    end
    Syncer.InvokeEvent(
        Stronghold.Building.NetworkCall,
        Stronghold.Building.SyncEvents.ChangeTax,
        _Level
    );
    return true;
end

function Stronghold.Building:HeadquartersBuySerf()
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local PlayerID = GUI.GetPlayerID();
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return false;
    end

    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_Serf);
    if not HasPlayerEnoughResourcesFeedback(Config.Costs[1]) then
        return false;
    end
    if Logic.GetPlayerAttractionUsage(PlayerID) >= Logic.GetPlayerAttractionLimit(PlayerID) then
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesSerf_SERF_No_rnd_01, 127);
        Message("Ihr habt keinen Platz für weitere Leibeigene!");
        return false;
    end

    Stronghold.Players[PlayerID].BuyUnitLock = true;
    Syncer.InvokeEvent(
        Stronghold.Building.NetworkCall,
        Stronghold.Building.SyncEvents.BuySerf,
        GetID(Stronghold.Players[PlayerID].HQScriptName),
        Entities.PU_Serf,
        false
    );
    return true;
end

function Stronghold.Building:OnHeadquarterSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return;
    end

    XGUIEng.ShowWidget("BuildingTabs", 1);
    self:HeadquartersChangeBuildingTabsGuiAction(PlayerID, _EntityID, gvGUI_WidgetID.ToBuildingCommandMenu);
end

function Stronghold.Building:PrintHeadquartersTaxButtonsTooltip(_PlayerID, _EntityID, _Key)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
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

        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 2);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[2];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation)).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetNormalTaxes" then
        Text = "@color:180,180,180 Faire Steuer @color:255,255,255 @cr "..
               "Ihr verlangt die übliche Steuer von Eurem Volk.";

        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 3);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[3];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation)).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetHighTaxes" then
        Text = "@color:180,180,180 Hohe Steuer @color:255,255,255 @cr "..
               "Ihr dreht an der Steuerschraube. Wenn das mal gut geht...";

        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 4);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[4];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation)).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/SetVeryHighTaxes" then
        Text = "@color:180,180,180 Grausame Steuer @color:255,255,255 @cr "..
               "Ihr zieht Euren Untertanen das letzte Hemd aus!";

        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 5);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[5];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation)).. " Beliebtheit ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _Key == "MenuHeadquarter/CallMilitia" then
        if Logic.IsEntityInCategory(GUI.GetSelectedEntity(), EntityCategories.Headquarters) == 1 then
            Text = "@color:180,180,180 Laird wählen @color:255,255,255 "..
                   "@cr Wählt euren Laird aus. Jeder Laird verfügt über "..
                   "starke Fähigkeiten. Ohne einen Laird könnt ihr keine "..
                   "Ehre erhalten.";
        end
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text.. " " ..EffectText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

function Stronghold.Building:HeadquartersShowNormalControls(_PlayerID, _EntityID, _WidgetID)
    XGUIEng.HighLightButton("ToBuildingCommandMenu", 0);
    XGUIEng.HighLightButton("ToBuildingSettlersMenu", 1);
    XGUIEng.ShowWidget("Headquarter", 1);
    XGUIEng.ShowWidget("Monastery", 0);
    XGUIEng.ShowWidget("WorkerInBuilding", 0);

    XGUIEng.SetWidgetPosition("TaxesAndPayStatistics", 105, 35);
    XGUIEng.SetWidgetPosition("HQTaxes", 143, 5);

    XGUIEng.ShowWidget("Buy_Hero", 0);
    XGUIEng.ShowWidget("HQ_Militia", 1);
    XGUIEng.SetWidgetPosition("HQ_Militia", 35, 0);
    XGUIEng.TransferMaterials("Buy_Hero", "HQ_CallMilitia");
    XGUIEng.TransferMaterials("Statistics_SubSettlers_Motivation", "HQ_BackToWork");

    -- TODO: Proper disable in singleplayer!
    -- local ShowBuyHero = XNetwork.Manager_DoesExist()
    XGUIEng.ShowWidget("HQ_CallMilitia", 1);
    XGUIEng.ShowWidget("HQ_BackToWork", 0);
end

-- Mesures (Blessings)

function Stronghold.Building:HeadquartersBlessSettlers(_PlayerID, _BlessCategory)
    local MeasurePoints = Stronghold.Economy:GetPlayerMeasure(_PlayerID);
    -- Prevent click spamming
    if MeasurePoints == 0 then
        return;
    end
    Stronghold.Economy:AddPlayerMeasure(_PlayerID, (-1) * MeasurePoints);
    local Msg = self.Config.Headquarters[_BlessCategory].Text;
    Message(Msg);

    local Effects = Stronghold.Building.Config.Headquarters[_BlessCategory];
    if _BlessCategory == BlessCategories.Construction then
        Stronghold.Economy:AddOneTimeReputation(_PlayerID, Effects.Reputation);
        Stronghold.Economy:AddOneTimeHonor(_PlayerID, Effects.Honor);

    elseif _BlessCategory == BlessCategories.Research then
        local RandomTax = 0;
        for i= 1, Logic.GetNumberOfAttractedWorker(_PlayerID) do
            RandomTax = RandomTax + math.random(1, 5);
        end
        Stronghold.Economy:AddOneTimeReputation(_PlayerID, Effects.Reputation);

        Message("Ihr habt " ..RandomTax.. " Taler erhalten!");
        Sound.PlayGUISound(Sounds.LevyTaxes, 100);
        AddGold(_PlayerID, RandomTax);
    elseif _BlessCategory == BlessCategories.Weapons then
        local WorkerList = GetAllWorker(_PlayerID, 0);
        table.sort(WorkerList, function(a, b) return a > b; end);
        for i= 1, table.getn(WorkerList) do
            local MotivationBonus = 100 - ((i-1) * 3);
            if MotivationBonus <= 0 then
                break;
            end
            local Motivation = Logic.GetSettlersMotivation(WorkerList[i]);
            CEntity.SetMotivation(WorkerList[i], Motivation + (MotivationBonus/100));
        end

    elseif _BlessCategory == BlessCategories.Financial then
        Stronghold.Economy:AddOneTimeReputation(_PlayerID, Effects.Reputation);

    elseif _BlessCategory == BlessCategories.Canonisation then
        Stronghold.Economy:AddOneTimeReputation(_PlayerID, Effects.Reputation);
        Stronghold.Economy:AddOneTimeHonor(_PlayerID, Effects.Honor);
    end
end

function Stronghold.Building:HeadquartersBlessSettlersGuiAction(_PlayerID, _EntityID, _BlessCategory)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    if Stronghold.Economy:GetPlayerMeasure(_PlayerID) < Stronghold.Economy:GetPlayerMeasureLimit(_PlayerID) then
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01, 127);
        Message("Ihr könnt noch keine neue Maßnahme beschließen, Milord!");
        return true;
    end

    Syncer.InvokeEvent(
        Stronghold.Building.NetworkCall,
        Stronghold.Building.SyncEvents.MeasureTaken,
        _BlessCategory
    );
    return true;
end

function Stronghold.Building:HeadquartersBlessSettlersGuiTooltip(_PlayerID, _EntityID, _TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    local Text = "";
    local EffectText = "";
    local Effects;

    if _TooltipNormal == "AOMenuMonastery/BlessSettlers1_normal" then
        Text = "@color:180,180,180 Öffentlicher Prozess @color:255,255,255 @cr "..
               "Haltet einen öffentlichen Schaupozess ab. Recht und Ordnung "..
               " steigert die Zufriedenheit des Pöbel.";
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   Stronghold:GetPlayerRankName(_PlayerID, 2) .. "";
        end
        EffectText = EffectText .. " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Construction];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers2_normal" then
        Text = "@color:180,180,180 Zwangsabgabe @color:255,255,255 @cr "..
               "Treibt eine Sondersteuer von Eurem Volke ein. Ihren Ertrag "..
               "vermag jedoch niemand vorherzusehen!";
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   Stronghold:GetPlayerRankName(_PlayerID, 3) .. "";
        end
        EffectText = EffectText .. " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Research];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers3_normal" then
        Text = "@color:180,180,180 Willkommenskultur @color:255,255,255 @cr "..
               "Eure Migrationspolitik wird Neuankömmlinge sehr zufrieden machen, "..
               " bis die Realität des ersten Zahltags sie einholt...";
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   Stronghold:GetPlayerRankName(_PlayerID, 4) .. ", Festung";
        end
        EffectText = EffectText .. " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Weapons];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers4_normal" then
        Text = "@color:180,180,180 Folklorefest @color:255,255,255 @cr "..
               "Ihr beglückt eure Siedler mit einem rauschenden Fest, dass "..
               "sie  sehr glücklich machen wird.";
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   Stronghold:GetPlayerRankName(_PlayerID, 5) .. ", Festung";
        end
        EffectText = EffectText .. " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Financial];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers5_normal" then
        Text = "@color:180,180,180 Gelage @color:255,255,255 @cr "..
               "Erhaltet Ehre durch ein verschwenderisches Gelage. Aber Ihr "..
               " zieht ebenso den Zorn des Volkes auf Euch!";
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   Stronghold:GetPlayerRankName(_PlayerID, 7) .. ", Zitadelle";
        end
        EffectText = EffectText .. " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Canonisation];
    else
        return false;
    end

    if Effects.Reputation > 0 then
        EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
    elseif Effects.Reputation < 0 then
        EffectText = EffectText .. Effects.Reputation.. " Beliebtheit ";
    end
    if Effects.Honor > 0 then
        EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text .. EffectText);
    return true;
end

function Stronghold.Building:HeadquartersBlessSettlersGuiUpdate(_PlayerID, _EntityID, _Button)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end

    local Level = Logic.GetUpgradeLevelForBuilding(_EntityID);
    local Rank = Stronghold:GetPlayerRank(_PlayerID);
    local ButtonDisabled = 0;
    if _Button == "BlessSettlers1" then
        ButtonDisabled = (Rank < 2 and 1) or 0;
    elseif _Button == "BlessSettlers2" then
        ButtonDisabled = (Rank < 3 and 1) or 0;
    elseif _Button == "BlessSettlers3" then
        ButtonDisabled = ((Rank < 4 or Level < 1) and 1) or 0;
    elseif _Button == "BlessSettlers4" then
        ButtonDisabled = ((Rank < 5 or Level < 1) and 1) or 0;
    elseif _Button == "BlessSettlers5" then
        ButtonDisabled = ((Rank < 7 or Level < 2) and 1) or 0;
    end
    XGUIEng.DisableButton(_Button, ButtonDisabled);
    return true;
end

function Stronghold.Building:HeadquartersFaithProgressGuiUpdate(_PlayerID, _EntityID, _WidgetID)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    local ValueMax = Stronghold.Economy:GetPlayerMeasureLimit(_PlayerID);
    local Value = Stronghold.Economy:GetPlayerMeasure(_PlayerID);
    XGUIEng.SetProgressBarValues(_WidgetID, Value, ValueMax);
    return true;
end

function Stronghold.Building:HeadquartersShowMonasteryControls(_PlayerID, _EntityID, _WidgetID)
    XGUIEng.HighLightButton("ToBuildingCommandMenu", 1);
    XGUIEng.HighLightButton("ToBuildingSettlersMenu", 0);
    XGUIEng.ShowWidget("Headquarter", 0);
    XGUIEng.ShowWidget("Monastery", 1);
    XGUIEng.ShowWidget("WorkerInBuilding", 0);
    XGUIEng.ShowWidget("Upgrade_Monastery1", 0);
    XGUIEng.ShowWidget("Upgrade_Monastery2", 0);

    XGUIEng.TransferMaterials("Research_Laws", "BlessSettlers1");
    XGUIEng.TransferMaterials("Levy_Duties", "BlessSettlers2");
    XGUIEng.TransferMaterials("Statistics_SubSettlers_Worker", "BlessSettlers3");
    XGUIEng.TransferMaterials("Statistics_SubSettlers_Motivation", "BlessSettlers4");
    XGUIEng.TransferMaterials("Build_Tavern", "BlessSettlers5");

    self:HeadquartersBlessSettlersGuiUpdate(_PlayerID, _EntityID, "BlessSettlers1");
    self:HeadquartersBlessSettlersGuiUpdate(_PlayerID, _EntityID, "BlessSettlers2");
    self:HeadquartersBlessSettlersGuiUpdate(_PlayerID, _EntityID, "BlessSettlers3");
    self:HeadquartersBlessSettlersGuiUpdate(_PlayerID, _EntityID, "BlessSettlers4");
    self:HeadquartersBlessSettlersGuiUpdate(_PlayerID, _EntityID, "BlessSettlers5");
end

-- Sub menu

function Stronghold.Building:HeadquartersChangeBuildingTabsGuiAction(_PlayerID, _EntityID, _WidgetID)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    if _WidgetID == gvGUI_WidgetID.ToBuildingCommandMenu then
        self:HeadquartersShowNormalControls(_PlayerID, _EntityID, _WidgetID);
    elseif _WidgetID == gvGUI_WidgetID.ToBuildingSettlersMenu then
        self:HeadquartersShowMonasteryControls(_PlayerID, _EntityID, _WidgetID);
    end
    return true;
end

function Stronghold.Building:HeadquartersBuildingTabsGuiTooltip(_PlayerID, _EntityID, _Key)
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    local Text = "";
    if _Key == "MenuBuildingGeneric/ToBuildingcommandmenu" then
        Text = "@color:180,180,180 Schatzkammer @cr @color:255,255,255 "..
               "Hier könnt Ihr Leibeigene kaufen, Euren Laird wählen, den "..
               "Alarm ausrufen und später sogar die Steuern einstellen.";
    elseif _Key == "MenuBuildingGeneric/tobuildingsettlersmenu" then
        Text = "@color:180,180,180 Maßnahmen @cr @color:255,255,255 "..
               "Hier könnt Ihr Regularien beschließen. Jede dieser Maßnahmen "..
               "hat individuelle Konsequenzen. Überlegt gut, ob und wann "..
               "Ihr sie einsetzt.";
    else
        return false;
    end
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Barracks

function Stronghold.Building:OnBarracksSettlerUpgradeTechnologyClicked(_Technology)
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GuiPlayer or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return true;
    end

    local Soldiers = 0;
    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeSword1 then
        UnitType = Entities.PU_LeaderPoleArm1;
        Soldiers = (AutoFillActive and 12) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword2 then
        UnitType = Entities.PU_LeaderPoleArm3;
        Soldiers = (AutoFillActive and 6) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword3 then
        UnitType = Entities.PU_LeaderSword2;
        Soldiers = (AutoFillActive and 6) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSpear1 then
        UnitType = Entities.PU_LeaderSword3;
        Soldiers = (AutoFillActive and 6) or 0;
        Action = self.SyncEvents.BuyUnit;
    end
    local Places = Stronghold.Attraction:GetMilitarySpaceForUnitType(UnitType, Soldiers +1);

    if Action > 0 then
        if not Stronghold.Attraction:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end
        local Costs = Stronghold.Unit:GetLeaderCosts(PlayerID, UnitType, Soldiers);
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Syncer.InvokeEvent(
                Stronghold.Building.NetworkCall,
                Action, EntityID, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnBarracksSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID);
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
    XGUIEng.ShowWidget("Research_UpgradeSword1", 1);
    XGUIEng.ShowWidget("Research_UpgradeSword2", 1);
    XGUIEng.ShowWidget("Research_UpgradeSword3", 1);
    XGUIEng.ShowWidget("Research_UpgradeSpear1", 1);
    XGUIEng.ShowWidget("Research_UpgradeSpear2", 0);
    XGUIEng.ShowWidget("Research_UpgradeSpear3", 0);

    local Blacksmith1 = table.getn(GetValidEntitiesOfType(PlayerID, Entities.PB_Blacksmith1));
    local Blacksmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith2);
    local Blacksmith3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith3);

    local Sawmill1 = table.getn(GetValidEntitiesOfType(PlayerID, Entities.PB_Sawmill1));
    local Sawmill2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill2);

    -- Spearmen
    local SpearDisabled = 0;
    local SpearConfig = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderPoleArm1);
    if SpearConfig.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < SpearConfig.Rank then
        SpearDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword1", SpearDisabled);

    -- Lancers
    local LancerDisabled = 0;
    local LancerConfig = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderPoleArm3);
    if LancerConfig.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < LancerConfig.Rank
    or Type ~= Entities.PB_Barracks2
    or Sawmill1 + Sawmill2 == 0 then
        LancerDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword2", LancerDisabled);

    -- Broadsword
    local SwordDisabled = 0;
    local SwordConfig = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderSword2);
    if SwordConfig.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < SwordConfig.Rank
    or Blacksmith1 + Blacksmith2 + Blacksmith3 == 0 then
        SwordDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword3", SwordDisabled);

    -- Longsword
    local SwordDisabled = 0;
    local BastardConfig = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderSword3);
    if BastardConfig.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < BastardConfig.Rank
    or Type ~= Entities.PB_Barracks2
    or Blacksmith2 + Blacksmith3 == 0 then
        SwordDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSpear1", SwordDisabled);
end

function Stronghold.Building:UpdateUpgradeSettlersBarracksTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local Text = "";
    local ShortcutText = "";
    local CostsText = "";

    if _TextKey == "MenuBarracks/UpgradeSword1" then
        local Type = Entities.PU_LeaderPoleArm1;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Speerträger @color:255,255,255 "..
               "@cr Ihr Götter, welch Memmen befehlen unsere Schar? Zum "..
               "Krieg zusammengekehrt, das Gerümpel des Landes.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [A]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 12) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " ..Stronghold:GetPlayerRankName(_PlayerID, Config.Rank);
        end

    elseif _TextKey == "MenuBarracks/UpgradeSword2" then
        local Type = Entities.PU_LeaderPoleArm3;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Lanzenträger @color:255,255,255 "..
               "@cr Die Leibwache Eures Laird. Sie sind gut gepanzert "..
               "und besonders stark gegen Kavalerie.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [S]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " ..Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Garnison, Sägewerk"
        end

    elseif _TextKey == "MenuBarracks/UpgradeSword3" then
        local Type = Entities.PU_LeaderSword2;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Breitschertkämpfer @color:255,255,255 "..
               "@cr Schwer gepanzerte Berufssoldaten, die für Euch über jede "..
               " Klinge springen.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [D]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Schmiede";
        end

    elseif _TextKey == "MenuBarracks/UpgradeSpear1" then
        local Type = Entities.PU_LeaderSword3;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Langschwertkämpfer @color:255,255,255 "..
               "@cr Adlige, die sich kein Pferd leisten können, aber dennoch "..
               "für Euch kämpfen. Sie fürchten weder Tod noch Teufel.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [F]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Garnison, Grobschmiede";
        end

    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortcutText);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Archery

function Stronghold.Building:OnArcherySettlerUpgradeTechnologyClicked(_Technology)
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GuiPlayer or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return true;
    end

    local Soldiers = 0;
    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeBow1 then
        UnitType = Entities.PU_LeaderBow1;
        Soldiers = (AutoFillActive and 12) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeBow2 then
        UnitType = Entities.PU_LeaderBow3;
        Soldiers = (AutoFillActive and 6) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeBow3 then
        UnitType = Entities.PU_LeaderRifle1;
        Soldiers = (AutoFillActive and 6) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeRifle1 then
        UnitType = Entities.PU_LeaderRifle2;
        Soldiers = (AutoFillActive and 6) or 0;
        Action = self.SyncEvents.BuyUnit;
    end
    local Places = Stronghold.Attraction:GetMilitarySpaceForUnitType(UnitType, Soldiers +1);

    if Action > 0 then
        if not Stronghold.Attraction:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end
        local Costs = Stronghold.Unit:GetLeaderCosts(PlayerID, UnitType, Soldiers);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Syncer.InvokeEvent(
                Stronghold.Building.NetworkCall,
                Action, EntityID, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnArcherySelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID);
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

    local Gunsmith1 = table.getn(GetValidEntitiesOfType(PlayerID, Entities.PB_GunsmithWorkshop1));
    local Gunsmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_GunsmithWorkshop2);

    local Sawmill1 = table.getn(GetValidEntitiesOfType(PlayerID, Entities.PB_Sawmill1));
    local Sawmill2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill2);

    -- Bowmen
    local BowDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderBow1);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank then
        BowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow1", BowDisabled);

    -- Crossbow
    local CrossbowDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderBow3);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Type ~= Entities.PB_Archery2
    or Sawmill1 + Sawmill2 == 0 then
        CrossbowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow2", CrossbowDisabled);

    -- Rifle
    local RifleDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderRifle1);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Gunsmith1 + Gunsmith2 == 0 then
        RifleDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow3", RifleDisabled);

    -- Musket
    local MusketDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderRifle2);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Type ~= Entities.PB_Archery2
    or Gunsmith2 == 0 then
        MusketDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeRifle1", MusketDisabled);
end

function Stronghold.Building:UpdateUpgradeSettlersArcheryTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local CostsText = "";
    local ShortcutText = "";
    local Text = "";

    if _TextKey == "MenuArchery/UpgradeBow1" then
        local Type = Entities.PU_LeaderBow1;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Kurzbogenschützen @color:255,255,255 "..
               "@cr Diese Männer sind vor allem gegen Speerträger und Reiter "..
               "sehr effektiv.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [A]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 12) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank);
        end

    elseif _TextKey == "MenuArchery/UpgradeBow2" then
        local Type = Entities.PU_LeaderBow3;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Armbrustschützen @color:255,255,255 "..
               "@cr Loyale und gut ausgebiltete Schützen. Sie werden Euer "..
               "Heer  hervorragend ergänzen.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [S]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Schießanlage, Sägewerk";
        end

    elseif _TextKey == "MenuArchery/UpgradeBow3" then
        local Type = Entities.PU_LeaderRifle1;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Leichte Scharfschützen @color:255,255,255 "..
               "@cr Diese Männer nutzen die neuen Feuerwaffen. Sie sind stark"..
               " gegen gepanzerte Einheiten.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [D]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Büchsenmacher";
        end

    elseif _TextKey == "AOMenuArchery/UpgradeRifle1" then
        local Type = Entities.PU_LeaderRifle2;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Schwere Scharfschützen @color:255,255,255 "..
               "@cr Die verbesserten Gewehre haben eine gewaltige Reichweite. "..
               "Keine Waffe der bekannten Welt trifft aus dieser Distanz.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [F]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Schießanlage, Büchsenmanufaktur";
        end
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortcutText);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Tavern

function Stronghold.Building:BuyMilitaryUnitFromTavernAction(_UpgradeCategory)
    local PlayerID = GUI.GetPlayerID();
    if Stronghold:IsPlayer(PlayerID) then
        local EntityID = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(EntityID);
        if Type == Entities.PB_Tavern1 or Type == Entities.PB_Tavern2 then
            return self:OnTavernBuyUnitClicked(_UpgradeCategory);
        end
    end
    return false;
end

function Stronghold.Building:OnTavernBuyUnitClicked(_UpgradeCategory)
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    if PlayerID ~= GuiPlayer or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return true;
    end

    local UnitType = 0;
    local Action = 0;
    if _UpgradeCategory == UpgradeCategories.Scout then
        if Logic.GetPlayerAttractionLimit(PlayerID) >= Logic.GetPlayerAttractionUsage(PlayerID) then
            UnitType = Entities.PU_Scout;
            Action = self.SyncEvents.BuyUnit;
        end
    elseif _UpgradeCategory == UpgradeCategories.Thief then
        if Logic.GetPlayerAttractionLimit(PlayerID) >= Logic.GetPlayerAttractionUsage(PlayerID) +5 then
            UnitType = Entities.PU_Thief;
            Action = self.SyncEvents.BuyUnit;
        end
    end

    if Action > 0 then
        local Costs = Stronghold.Unit:GetLeaderCosts(PlayerID, UnitType, 0);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Syncer.InvokeEvent(
                Stronghold.Building.NetworkCall,
                Action, EntityID, UnitType, false
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnTavernSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID);
    if Type ~= Entities.PB_Tavern1 and Type ~= Entities.PB_Tavern2 then
        return;
    end

    local Rank = Stronghold:GetPlayerRank(PlayerID);

    -- Scout
    local ScoutDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_Scout);
    if Config.Allowed == false
    or Rank < Config.Rank then
        ScoutDisabled = 1;
    end
    XGUIEng.DisableButton("Buy_Scout", ScoutDisabled);

    -- Thief
    local ThiefDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_Thief);
    if Config.Allowed == false
    or Rank < Config.Rank
    or Type ~= Entities.PB_Tavern2 then
        ThiefDisabled = 1;
    end
    XGUIEng.DisableButton("Buy_Thief", ThiefDisabled);
end

function Stronghold.Building:UpdateTavernBuyUnitTooltip(_PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local CostsText = "";
    local Text = "";

    if _KeyNormal == "MenuTavern/BuyScout_normal" then
        local Type = Entities.PU_Scout;
        Text = "@color:180,180,180 Kundschafter @color:255,255,255 "..
               "@cr Kundschafter erkunden die Umgebung und finden Rohstoffe.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, 0);
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. "";
        end

    elseif _KeyNormal == "MenuTavern/BuyThief_normal" then
        local Type = Entities.PU_Thief;
        Text = "@color:180,180,180 Dieb @color:255,255,255 "..
               "@cr Diebe können den Feind bestehlen und später sabotieren.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, 0);
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Wirtshaus";
        end

    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Stable

function Stronghold.Building:OnStableSettlerUpgradeTechnologyClicked(_Technology)
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GuiPlayer or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return true;
    end

    local Soldiers = 0;
    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeLightCavalry1 then
        UnitType = Entities.PU_LeaderCavalry1;
        Soldiers = (AutoFillActive and 5) or 0;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeHeavyCavalry1 then
        UnitType = Entities.PU_LeaderHeavyCavalry1;
        Soldiers = (AutoFillActive and 5) or 0;
        Action = self.SyncEvents.BuyUnit;
    end
    local Places = Stronghold.Attraction:GetMilitarySpaceForUnitType(UnitType, Soldiers +1);

    if Action > 0 then
        if not Stronghold.Attraction:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end
        local Costs = Stronghold.Unit:GetLeaderCosts(PlayerID, UnitType, Soldiers);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Syncer.InvokeEvent(
                Stronghold.Building.NetworkCall,
                Action, EntityID, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnStableSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID);
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

    local Blacksmith1 = table.getn(GetValidEntitiesOfType(PlayerID, Entities.PB_Blacksmith1));
    local Blacksmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith2);
    local Blacksmith3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith3);

    local Sawmill1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill1);
    local Sawmill2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill2);

    -- Bowmen
    local BowDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderCavalry1);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Sawmill1 + Sawmill2 == 0  then
        BowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeCavalryLight1", BowDisabled);

    -- Knights
    local KnightDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderHeavyCavalry1);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Type ~= Entities.PB_Stable2
    or Blacksmith3 == 0 then
        KnightDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeCavalryHeavy1", KnightDisabled);
end

function Stronghold.Building:UpdateUpgradeSettlersStableTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local CostsText = "";
    local ShortcutText = "";
    local Text = "";

    if _TextKey == "MenuStables/UpgradeCavalryLight1" then
        local Type = Entities.PU_LeaderCavalry1;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Berittener Bogenschütze @color:255,255,255 "..
               "@cr Der Vorteil der berittenen Bogenschützen ist ihre hohe "..
               "Flexibelität und Geschwindigkeit.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [A]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 5) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Sägemühle";
        end

    elseif _TextKey == "MenuStables/UpgradeCavalryHeavy1" then
        local Type = Entities.PU_LeaderHeavyCavalry1;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Berittener Schwertkämpfer @color:255,255,255 "..
               "@cr Treue Ritter, die jeden Gegner gnadenlos niedermähen, der "..
               "es wagt, sich Euch entgegenzustallen.";

        -- Hotkey
        ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name").. " [S]";
        -- Costs text
        local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 5) or 0;
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, Soldiers);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Reiterei, Feinschmiede";
        end

    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortcutText);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Foundry

function Stronghold.Building:BuyMilitaryUnitFromFoundryAction(_Type, _UpgradeCategory)
    local PlayerID = GUI.GetPlayerID();
    if Stronghold:IsPlayer(PlayerID) then
        local EntityID = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(EntityID);
        if Type == Entities.PB_Foundry1 or Type == Entities.PB_Foundry2 then
            return self:OnFoundryBuyUnitClicked(_Type, _UpgradeCategory);
        end;
    end
    return false;
end

function Stronghold.Building:OnFoundryBuyUnitClicked(_Type, _UpgradeCategory)
    local GuiPlayer = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    if GuiPlayer ~= PlayerID or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return true;
    end

    local Places = 0;
    local UnitType = 0;
    local Action = 0;
    if _Type == Entities.PV_Cannon1 then
        UnitType = _Type;
        Action = self.SyncEvents.BuyUnit;
    elseif _Type == Entities.PV_Cannon2 then
        UnitType = _Type;
        Action = self.SyncEvents.BuyUnit;
    elseif _Type == Entities.PV_Cannon3 then
        UnitType = _Type;
        Action = self.SyncEvents.BuyUnit;
    elseif _Type == Entities.PV_Cannon4 then
        UnitType = _Type;
        Action = self.SyncEvents.BuyUnit;
    end
    Places = Stronghold.Attraction:GetMilitarySpaceForUnitType(UnitType, 1);

    if Action > 0 then
        if not Stronghold.Attraction:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end
        local Costs = Stronghold.Unit:GetLeaderCosts(PlayerID, UnitType, 0);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;

            GUI.BuyCannon(EntityID, _Type);
		    XGUIEng.ShowWidget(gvGUI_WidgetID.CannonInProgress,1);

            Syncer.InvokeEvent(
                Stronghold.Building.NetworkCall,
                Action, EntityID, UnitType, false
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnFoundrySelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID);
    if Type ~= Entities.PB_Foundry1 and Type ~= Entities.PB_Foundry2 then
        return;
    end

    -- Cannon 1
    local Cannon1Disabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PV_Cannon1);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank then
        Cannon1Disabled = 1;
    end
    XGUIEng.DisableButton("Buy_Cannon1", Cannon1Disabled);

    -- Cannon 2
    local Cannon2Disabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PV_Cannon2);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank then
        Cannon2Disabled = 1;
    end
    XGUIEng.DisableButton("Buy_Cannon2", Cannon2Disabled);

    -- Cannon 3
    local Cannon3Disabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PV_Cannon3);
    if Config.Allowed == false
    or Type ~= Entities.PB_Foundry2
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank then
        Cannon3Disabled = 1;
    end
    XGUIEng.DisableButton("Buy_Cannon3", Cannon3Disabled);

    -- Cannon 4
    local Cannon4Disabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PV_Cannon4);
    if Config.Allowed == false
    or Type ~= Entities.PB_Foundry2
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank then
        Cannon4Disabled = 1;
    end
    XGUIEng.DisableButton("Buy_Cannon4", Cannon4Disabled);
end

function Stronghold.Building:UpdateFoundryBuyUnitTooltip(_PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local Text = "";
    local CostsText = "";

    if _KeyNormal == "MenuFoundry/BuyCannon1_normal" then
        local Type = Entities.PV_Cannon1;
        Text = "@color:180,180,180 Bombarde @color:255,255,255 @cr "..
               "Die kleinste Kanone. Sie wird gegen Soldaten verwendet, ist "..
               "aber nicht nennenswert effektiv.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, 0);
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. "";
        end

    elseif _KeyNormal == "MenuFoundry/BuyCannon2_normal" then
        local Type = Entities.PV_Cannon2;
        Text = "@color:180,180,180 Bronzekanone @color:255,255,255 @cr "..
               "Die stärkste Kanone des späten Mittelalter. Sie wird gegen "..
               "Befätigungen eingesetzt.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, 0);
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. "";
        end

    elseif _KeyNormal == "MenuFoundry/BuyCannon3_normal" then
        local Type = Entities.PV_Cannon3;
        Text = "@color:180,180,180 Eisenkanone @color:255,255,255 @cr "..
               "Diese große Kanone ist zum vernichten von Truppen gedacht.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, 0);
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Kanonenmanufaktur";
        end

    elseif _KeyNormal == "MenuFoundry/BuyCannon4_normal" then
        local Type = Entities.PV_Cannon4;
        Text = "@color:180,180,180 Belagerungskanone @color:255,255,255 @cr "..
               "Eine schwere Kanone deren Aufgabe es ist Befestigungen zu "..
               " zerstören.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, Type, 0);
        CostsText = FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Kanonenmanufaktur";
        end

    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostsText);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Monastery

function Stronghold.Building:MonasteryBlessSettlers(_PlayerID, _BlessCategory)
    local CurrentFaith = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Faith);
    Logic.SubFromPlayersGlobalResource(_PlayerID, ResourceType.Faith, CurrentFaith);

    local BlessData = self.Config.Monastery[_BlessCategory];
    if BlessData.Reputation > 0 then
        Stronghold.Economy:AddOneTimeReputation(_PlayerID, BlessData.Reputation);
    end
    if BlessData.Honor > 0 then
        Stronghold.Economy:AddOneTimeHonor(_PlayerID, BlessData.Honor);
    end

    if GUI.GetPlayerID() == _PlayerID then
        GUI.AddNote(BlessData.Text);
        Sound.PlayGUISound(Sounds.Buildings_Monastery, 0);
        Sound.PlayFeedbackSound(Sounds.VoicesMentor_INFO_SettlersBlessed_rnd_01, 0);
    end
end

function Stronghold.Building:OnMonasterySelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    local Type = Logic.GetEntityType(_EntityID);
    if Logic.GetUpgradeCategoryByBuildingType(Type) ~= UpgradeCategories.Monastery then
        return;
    end

    local Level = Logic.GetUpgradeLevelForBuilding(_EntityID);
    if Level < 2 then
        XGUIEng.ShowWidget("Upgrade_Monastery2", 1);
    end
    if Level < 1 then
        XGUIEng.ShowWidget("Upgrade_Monastery1", 1);
    end
    XGUIEng.TransferMaterials("Research_PickAxe", "BlessSettlers1");
    XGUIEng.TransferMaterials("Research_LightBricks", "BlessSettlers2");
    XGUIEng.TransferMaterials("Research_Taxation", "BlessSettlers3");
    XGUIEng.TransferMaterials("Research_Debenture", "BlessSettlers4");
    XGUIEng.TransferMaterials("Research_Scale", "BlessSettlers5");
end

function Stronghold.Building:OverrideMonasteryInterface()
    Overwrite.CreateOverwrite(
        "GUIAction_BlessSettlers",
        function(_BlessCategory)
            local GuiPlayer = Stronghold:GetLocalPlayerID();
            local EntityID = GUI.GetSelectedEntity();
            if InterfaceTool_IsBuildingDoingSomething(EntityID) == true then
                return true;
            end
            if not Stronghold.Building:HeadquartersBlessSettlersGuiAction(GuiPlayer, EntityID, _BlessCategory) then
                Overwrite.CallOriginal();
            end
        end
    );

    Overwrite.CreateOverwrite(
        "GUIAction_BlessSettlers",
        function(_BlessCategory)
            local GuiPlayer = Stronghold:GetLocalPlayerID();
            local EntityID = GUI.GetSelectedEntity();
            if InterfaceTool_IsBuildingDoingSomething(EntityID) == true then
                return true;
            end
            if not Stronghold.Building:MonasteryBlessSettlersGuiAction(GuiPlayer, EntityID, _BlessCategory) then
                Overwrite.CallOriginal();
            end
        end
    );

    Overwrite.CreateOverwrite(
        "GUITooltip_BlessSettlers",
        function(_TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut)
            local GuiPlayer = Stronghold:GetLocalPlayerID();
            local EntityID = GUI.GetSelectedEntity();
            Overwrite.CallOriginal();
            Stronghold.Building:MonasteryBlessSettlersGuiTooltip(GuiPlayer, EntityID, _TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut);
        end
    );

    Overwrite.CreateOverwrite(
        "GUITooltip_BlessSettlers",
        function(_TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut)
            local GuiPlayer = Stronghold:GetLocalPlayerID();
            local EntityID = GUI.GetSelectedEntity();
            Overwrite.CallOriginal();
            Stronghold.Building:HeadquartersBlessSettlersGuiTooltip(GuiPlayer, EntityID, _TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut);
        end
    );

    Overwrite.CreateOverwrite(
        "GUIUpdate_FaithProgress",
        function()
            local WidgetID = XGUIEng.GetCurrentWidgetID();
            local PlayerID = Stronghold:GetLocalPlayerID();
            local EntityID = GUI.GetSelectedEntity();
            Overwrite.CallOriginal();
            Stronghold.Building:HeadquartersFaithProgressGuiUpdate(PlayerID, EntityID, WidgetID);
        end
    );
end

function Stronghold.Building:MonasteryBlessSettlersGuiAction(_PlayerID, _EntityID, _BlessCategory)
    local Type = Logic.GetEntityType(_EntityID);
    if Logic.GetUpgradeCategoryByBuildingType(Type) ~= UpgradeCategories.Monastery then
        return false;
    end

    local CurrentFaith = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Faith);
    local BlessCosts = Logic.GetBlessCostByBlessCategory(_BlessCategory);
    if BlessCosts <= CurrentFaith then
        Syncer.InvokeEvent(
            Stronghold.Building.NetworkCall,
            Stronghold.Building.SyncEvents.BlessSettlers,
            _BlessCategory
        );
    else
        GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_NotEnoughFaith"));
        Sound.PlayFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01, 0);
    end
    return true;
end

function Stronghold.Building:MonasteryBlessSettlersGuiTooltip(_PlayerID, _EntityID, _TooltipDisabled, _TooltipNormal, _TooltipResearched, _ShortCut)
    local Type = Logic.GetEntityType(_EntityID);
    if Logic.GetUpgradeCategoryByBuildingType(Type) ~= UpgradeCategories.Monastery then
        return false;
    end
    local Text = "";

    if _TooltipNormal == "AOMenuMonastery/BlessSettlers1_normal" then
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers1) == 0 then
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
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers2) == 0 then
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
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers3) == 0 then
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
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers4) == 0 then
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
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers5) == 0 then
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
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Keybindings

function Stronghold.Building:InitalizeBuyUnitKeybindings()
    Stronghold_KeyBindings_BuyUnit = function(_Key, _PlayerID, _EntityID)
        Sound.PlayGUISound(Sounds.klick_rnd_1, 0);
        Stronghold.Building:ExecuteBuyUnitKeybindForBarracks(_Key, _PlayerID, _EntityID);
        Stronghold.Building:ExecuteBuyUnitKeybindForArchery(_Key, _PlayerID, _EntityID);
        Stronghold.Building:ExecuteBuyUnitKeybindForStable(_Key, _PlayerID, _EntityID);
    end

    Input.KeyBindDown(Keys.A, "Stronghold_KeyBindings_BuyUnit(1, GUI.GetPlayerID(), GUI.GetSelectedEntity())", 2);
    Input.KeyBindDown(Keys.S, "Stronghold_KeyBindings_BuyUnit(2, GUI.GetPlayerID(), GUI.GetSelectedEntity())", 2);
    Input.KeyBindDown(Keys.D, "Stronghold_KeyBindings_BuyUnit(3, GUI.GetPlayerID(), GUI.GetSelectedEntity())", 2);
    Input.KeyBindDown(Keys.F, "Stronghold_KeyBindings_BuyUnit(4, GUI.GetPlayerID(), GUI.GetSelectedEntity())", 2);
    -- TODO: Hero special units?
    Input.KeyBindDown(Keys.G, "Stronghold_KeyBindings_BuyUnit(5, GUI.GetPlayerID(), GUI.GetSelectedEntity())", 2);
    Input.KeyBindDown(Keys.H, "Stronghold_KeyBindings_BuyUnit(6, GUI.GetPlayerID(), GUI.GetSelectedEntity())", 2);
end

function Stronghold.Building:ExecuteBuyUnitKeybindForBarracks(_Key, _PlayerID, _EntityID)
    if Stronghold:IsPlayer(_PlayerID) then
        local Type = Logic.GetEntityType(_EntityID);
        if Type == Entities.PB_Barracks1 or Type == Entities.PB_Barracks2 then
            if Logic.IsConstructionComplete(_EntityID) == 1 then
                if _Key == 1 and XGUIEng.IsButtonDisabled("Research_UpgradeSword1") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeSword1);
                elseif _Key == 2 and XGUIEng.IsButtonDisabled("Research_UpgradeSword2") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeSword2);
                elseif _Key == 3 and XGUIEng.IsButtonDisabled("Research_UpgradeSword3") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeSword3);
                elseif _Key == 4 and XGUIEng.IsButtonDisabled("Research_UpgradeSpear1") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeSpear1);
                end
            end
        end
    end
end

function Stronghold.Building:ExecuteBuyUnitKeybindForArchery(_Key, _PlayerID, _EntityID)
    if Stronghold:IsPlayer(_PlayerID) then
        local Type = Logic.GetEntityType(_EntityID);
        if Type == Entities.PB_Archery1 or Type == Entities.PB_Archery2 then
            if Logic.IsConstructionComplete(_EntityID) == 1 then
                if _Key == 1 and XGUIEng.IsButtonDisabled("Research_UpgradeBow1") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeBow1);
                elseif _Key == 2 and XGUIEng.IsButtonDisabled("Research_UpgradeBow2") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeBow2);
                elseif _Key == 3 and XGUIEng.IsButtonDisabled("Research_UpgradeBow3") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeBow3);
                elseif _Key == 4 and XGUIEng.IsButtonDisabled("Research_UpgradeRifle1") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeRifle1);
                end
            end
        end
    end
end

function Stronghold.Building:ExecuteBuyUnitKeybindForStable(_Key, _PlayerID, _EntityID)
    if Stronghold:IsPlayer(_PlayerID) then
        local Type = Logic.GetEntityType(_EntityID);
        if Type == Entities.PB_Stable1 or Type == Entities.PB_Stable2 then
            if Logic.IsConstructionComplete(_EntityID) == 1 then
                if _Key == 1 and XGUIEng.IsButtonDisabled("Research_UpgradeCavalryLight1") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeLightCavalry1);
                elseif _Key == 2 and XGUIEng.IsButtonDisabled("Research_UpgradeCavalryHeavy1") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeHeavyCavalry1);
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- General

function Stronghold.Building:OverrideChangeBuildingMenuButton()
    Overwrite.CreateOverwrite(
        "GUIAction_ChangeBuildingMenu",
        function(_WidgetID)
            local EntityID = GUI.GetSelectedEntity();
            local PlayerID = Stronghold:GetLocalPlayerID();
            if not Stronghold.Building:HeadquartersChangeBuildingTabsGuiAction(PlayerID, EntityID, _WidgetID) then
                Overwrite.CallOriginal();
            end
        end
    );
end

function Stronghold.Building:OverrideUpdateConstructionButton()
    Overwrite.CreateOverwrite(
        "GUIUpdate_BuildingButtons",
        function(_Button, _Technology)
            local PlayerID = Stronghold:GetLocalPlayerID();
            local EntityID = GUI.GetSelectedEntity();
            Overwrite.CallOriginal();
            Stronghold.Building:HeadquartersBlessSettlersGuiUpdate(PlayerID, EntityID, _Button);
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Dirty Hacks

-- Prevent nasty update when toggle groups is used.
function Stronghold.Building:OverrideManualButtonUpdate()
    self.Orig_XGUIEng_DoManualButtonUpdate = XGUIEng.DoManualButtonUpdate;
    XGUIEng.DoManualButtonUpdate = function(_WidgetID)
        local WidgetID = XGUIEng.GetCurrentWidgetID();
        local SingleLeader = XGUIEng.GetWidgetID("Activate_RecruitSingleLeader");
        local FullLeader = XGUIEng.GetWidgetID("Activate_RecruitGroups");
        if WidgetID ~= SingleLeader and WidgetID ~= FullLeader then
            self.Orig_XGUIEng_DoManualButtonUpdate(_WidgetID);
        end
    end
end

-- Deselect building on demolition to prevent click spamming.
function Stronghold.Building:OverrideSellBuildingAction()
    self.Orig_GUI_SellBuilding = GUI.SellBuilding;
    GUI.SellBuilding = function(_EntityID)
        GUI.DeselectEntity(_EntityID);
        self.Orig_GUI_SellBuilding(_EntityID);
    end
end

