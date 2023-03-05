--- 
--- Building Script
---
--- This script implements buttons and all non-income properties of buildings.
--- 

Stronghold = Stronghold or {};

Stronghold.Building = Stronghold.Building or {
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
        BlessSettlers = 4,
        MeasureTaken = 5,
    };

    self.NetworkCall = Syncer.CreateEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Building.SyncEvents.ChangeTax then
                Stronghold.Building:HeadquartersButtonChangeTax(_PlayerID, arg[1]);
            end
            if _Action == Stronghold.Building.SyncEvents.BuySerf then
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

    local Config = Stronghold.UnitConfig:GetConfig(Entities.PU_Serf);
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
                elseif _Key == 4 and XGUIEng.IsButtonDisabled("Research_UpgradeSpear2") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeSpear2);
                elseif _Key == 4 and XGUIEng.IsButtonDisabled("Research_UpgradeSpear3") == 0 then
                    GUIAction_ReserachTechnology(Technologies.T_UpgradeSpear3);
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
