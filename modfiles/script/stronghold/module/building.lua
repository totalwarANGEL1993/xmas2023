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
                Reputation = 5,
                Honor = 10,
            },
            [BlessCategories.Research] = {
                Reputation = -18,
                Honor = 0,
            },
            [BlessCategories.Weapons] = {
                Reputation = 100,
                Honor = 0,
            },
            [BlessCategories.Financial] = {
                Reputation = 22,
                Honor = 0,
            },
            [BlessCategories.Canonisation] = {
                Reputation = -40,
                Honor = 100,
            },
        },

        Monastery = {
            [BlessCategories.Construction] = {
                Reputation = 8,
                Honor = 0,
            },
            [BlessCategories.Research] = {
                Reputation = 0,
                Honor = 8,
            },
            [BlessCategories.Weapons] = {
                Reputation = 16,
                Honor = 0,
            },
            [BlessCategories.Financial] = {
                Reputation = 0,
                Honor = 16,
            },
            [BlessCategories.Canonisation] = {
                Reputation = 12,
                Honor = 12,
            },
        },

        UI = {
            MeasureNotReady = {
                de = "Hochwohlgeboren, Ihr könnt noch keine neue Maßnahme anordnen!",
                en = "Highness, you cannot yet order a new measure!",
            },
            MeasureRandomTax = {
                de = "Ihr habt %d Taler erhalten!",
                en = "The levy tax produced %d Gold!"
            },
            Measure = {
                [BlessCategories.Construction] = {
                    [1] = {
                        de = "{grey}Öffentlicher Prozess{white}{cr}Haltet einen öffentlichen "..
                             "Schaupozess ab. Recht und Ordnung steigert die Zufriedenheit "..
                             "des Pöbel.",
                        en = "{grey}Duty{white}{cr}Collect a special tax from your people. "..
                             "However, no one can predict your yield!",
                    },
                    [2] = {
                        de = "Ihr sprecht Recht und bestraft Kriminelle. Das Volk begrüßt dies!",
                        en = "You administer justice and punish criminals. The people welcome this!",
                    },
                    [3] = {de = "#Rank# ", en = "#Rank# ",},
                },
                [BlessCategories.Research] = {
                    [1] = {
                        de = "{grey}Zwangsabgabe{white}{cr}Treibt eine Sondersteuer von Eurem "..
                             "Volke ein. Ihren Ertrag vermag jedoch niemand vorherzusehen!",
                        en = "{grey}Levy Duty{white}{cr}Collect a special tax from your people. "..
                             "However, no one can predict your yield!",
                    },
                    [2] = {
                        de = "Die Siedler werden zur Kasse gebeten, was sie sehr verärgert!",
                        en = "The settlers are asked to pay, which upsets them greatly!",
                    },
                    [3] = {de = "#Rank# ", en = "#Rank# ",},
                },
                [BlessCategories.Weapons] = {
                    [1] = {
                        de = "{grey}Willkommenskultur{white}{cr}Eure Migrationspolitik wird "..
                             "Neuankömmlinge sehr zufrieden machen, bis die Realität des "..
                             "ersten Zahltags sie einholt...",
                        en = "{grey}Welcome Culture{white}{cr}Your migration policies will keep "..
                             "newcomers very content until the reality of first payday catches "..
                             "up with them...",
                    },
                    [2] = {
                        de = "Eure Migrationspolitik wird von den zugezogenen Siedlern begrüßt.",
                        en = "Your migration policy is welcomed by the new settlers.",
                    },
                    [3] = {de = "#Rank#, Festung ", en = "#Rank#, Fortress ",},
                },
                [BlessCategories.Financial] = {
                    [1] = {
                        de = "{grey}Folklorefest{white}{cr}Ihr beglückt eure Siedler mit einem "..
                             "rauschenden Fest, dass sie sehr glücklich machen wird.",
                        en = "{grey}Folklorefest{white}{cr}You treat your settlers to a lavish "..
                             "festival that will make them very happy.",
                    },
                    [2] = {
                        de = "Das Volksfest erfreut die Siedler und steigert Eure Beliebtheit.",
                        en = "The folk festival delights the settlers and increases your popularity.",
                    },
                    [3] = {de = "#Rank#, Festung ", en = "#Rank#, Fortress ",},
                },
                [BlessCategories.Canonisation] = {
                    [1] = {
                        de = "{grey}Gelage{white}{cr}Erhaltet Ehre durch ein verschwenderisches Gelage. "..
                             "Aber Ihr zieht ebenso den Zorn des Volkes auf Euch!",
                        en = "{grey}Feast{white}{cr}Gain honor from a lavish feast. But you draw the "..
                             "wrath of the people against you as well !",
                    },
                    [2] = {
                        de = "Ein Bankett gereicht Euch an Ehre, aber verärgert das Volk!",
                        en = "A banquet honors you, but angers the people!",
                    },
                    [3] = {de = "#Rank#, Zitadelle ", en = "#Rank#, Zitadel ",},
                },
            },

            PrayerMess = {
                [BlessCategories.Construction] = {
                    [1] = {
                        de = "{grey}Gebetsmesse{white}",
                        en = "{grey}Church Service{white}",
                    },
                    [2] = {
                        de = "Eure Priester leuten die Glocke zum Gebet.",
                        en = "Your priests ring the bell for prayer.",
                    },
                    [3] = {de = "", en = "",},
                },
                [BlessCategories.Research] = {
                    [1] = {
                        de = "{grey}Ablassbriefe{white}",
                        en = "{grey}Indulgence Letters{white}",
                    },
                    [2] = {
                        de = "Eure Priester vergeben die Sünden Eurer Arbeiter.",
                        en = "Your priests forgive the sins of your workers.",
                    },
                    [3] = {de = "", en = "",},
                },
                [BlessCategories.Weapons] = {
                    [1] = {
                        de = "{grey}Bibeln{white}",
                        en = "{grey}Bible Reading{white}",
                    },
                    [2] = {
                        de = "Eure Priester predigen Bibeltexte zu ihrer Gemeinde.",
                        en = "Your priests read from the bible to their community.",
                    },
                    [3] = {de = "Kirche", en = "Church",},
                },
                [BlessCategories.Financial] = {
                    [1] = {
                        de = "{grey}Kollekte{white}",
                        en = "{grey}Collect{white}",
                    },
                    [2] = {
                        de = "Eure Priester rufen die Siedler auf zur Kollekte.",
                        en = "Your priests are calling for the collection.",
                    },
                    [3] = {de = "Kirche", en = "Church",},
                },
                [BlessCategories.Canonisation] = {
                    [1] = {
                        de = "{grey}Heiligsprechung{white}",
                        en = "{grey}Canonisation{white}",
                    },
                    [2] = {
                        de = "Eure Priester sprechen Eure Taten heilig.",
                        en = "Your priests sanctify your deeds.",
                    },
                    [3] = {de = "Kathedrale", en = "Cathedral",},
                },
            },

            TaxLevel = {
                [1] = {
                    de = "{grey}Keine Steuer{white}{cr}Keine Steuern. Aber wie wollt Ihr zu Talern kommen?",
                    en = "{grey}No Taxes{white}{cr}No taxes. But how are you going to generate money?",
                },
                [2] = {
                    de = "{grey}Niedrige Steuer{white}{cr}Ihr seid großzügig und entlastet Eure Untertanen.",
                    en = "{grey}Low Taxes{white}{cr}You are generous and exonerate your subjects.",
                },
                [3] = {
                    de = "{grey}Faire Steuer{white}{cr}Ihr verlangt die übliche Steuer von Eurem Volk.",
                    en = "{grey}Fair Taxes{white}{cr}You demand the usual tax from your people.",
                },
                [4] = {
                    de = "{grey}Hohe Steuer{white}{cr}Ihr dreht an der Steuerschraube. Wenn das mal gut geht...",
                    en = "{grey}High Taxes{white}{cr}You increase the tax burden. How long will this go well...",
                },
                [5] = {
                    de = "{grey}Grausame Steuer{white}{cr}Ihr zieht Euren Untertanen das letzte Hemd aus!",
                    en = "{grey}Curel Taxes{white}{cr}You are stripping your subjects of their last shirts!",
                },
            },

            TreasurySubMenu = {
                de = "{grey}Schatzkammer{white}{cr}Hier könnt Ihr Leibeigene "..
                     "kaufen, Euren Laird wählen, den Alarm ausrufen und später "..
                     "sogar die Steuern einstellen.",
                en = "",
            },
            AdministrationSubMenu = {
                de = "{grey}Verwaltung{white}{cr}Hier könnt Ihr Regularien "..
                     "beschließen. Jede dieser Maßnahmen hat individuelle "..
                     "Konsequenzen. Überlegt gut, ob und wann Ihr sie einsetzt.",
                en = "",
            },
            Require = {
                de = " @cr @color:244,184,0 benötigt: @color:255,255,255 ",
                en = " @cr @color:244,184,0 requires: @color:255,255,255 ",
            },
            Effect  = {
                de = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ",
                en = " @cr @color:244,184,0 achives: @color:255,255,255 ",
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
    local Language = GetLanguage();
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    local Text = XGUIEng.GetStringTableText(_Key);
    local EffectText = "";

    if _Key == "MenuHeadquarter/SetVeryLowTaxes" then
        Text = self.Config.UI.TaxLevel[1][Language];
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[1];
        EffectText = self.Config.UI.Effect[Language];
        if Effects.Reputation ~= 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
        end
    elseif _Key == "MenuHeadquarter/SetLowTaxes" then
        Text = self.Config.UI.TaxLevel[2][Language];
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 2);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[2];
        EffectText = self.Config.UI.Effect[Language];
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation))..
                     " " ..Stronghold.Config.UI.Reputation[Language].. " ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
        end
    elseif _Key == "MenuHeadquarter/SetNormalTaxes" then
        Text = self.Config.UI.TaxLevel[3][Language];
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 3);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[3];
        EffectText = self.Config.UI.Effect[Language];
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation))..
                     " " ..Stronghold.Config.UI.Reputation[Language].. " ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
        end
    elseif _Key == "MenuHeadquarter/SetHighTaxes" then
        Text = self.Config.UI.TaxLevel[4][Language];
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 4);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[4];
        EffectText = self.Config.UI.Effect[Language];
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation))..
                     " " ..Stronghold.Config.UI.Reputation[Language].. " ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
        end
    elseif _Key == "MenuHeadquarter/SetVeryHighTaxes" then
        Text = self.Config.UI.TaxLevel[5][Language];
        local Penalty = Stronghold.Economy:CalculateReputationTaxPenaltyAmount(_PlayerID, 5);
        local Effects = Stronghold.Economy.Config.Income.TaxEffect[5];
        EffectText = self.Config.UI.Effect[Language];
        EffectText = EffectText .. ((-1) * ((Penalty > 0 and Penalty) or Effects.Reputation))..
                     " " ..Stronghold.Config.UI.Reputation[Language].. " ";
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
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

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Placeholder.Replace(Text.. " " ..EffectText));
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
    local Language = GetLanguage();
    Message(self.Config.UI.Measure[_BlessCategory][2][Language]);
    Stronghold.Economy:AddPlayerMeasure(_PlayerID, (-1) * MeasurePoints);

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

        Message(string.format(self.Config.UI.MeasureRandomTax[Language], RandomTax));
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
    local Language = GetLanguage();
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    if Stronghold.Economy:GetPlayerMeasure(_PlayerID) < Stronghold.Economy:GetPlayerMeasureLimit(_PlayerID) then
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01, 127);
        Message(self.Config.UI.MeasureNotReady[Language]);
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
    local Language = GetLanguage();
    local Text = "";
    local Effects;
    local RequireText = "";
    local EffectText = self.Config.UI.Effect[Language];
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end

    if _TooltipNormal == "AOMenuMonastery/BlessSettlers1_normal" then
        Text = self.Config.UI.Measure[BlessCategories.Construction][1][Language];
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            RequireText = string.gsub(
                self.Config.UI.Require[Language] ..
                self.Config.UI.Measure[BlessCategories.Construction][3][Language],
                "#Rank#", Stronghold:GetPlayerRankName(_PlayerID, 2)
            );
        end
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Construction];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers2_normal" then
        Text = self.Config.UI.Measure[BlessCategories.Research][1][Language];
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            RequireText = string.gsub(
                self.Config.UI.Require[Language] ..
                self.Config.UI.Measure[BlessCategories.Research][3][Language],
                "#Rank#", Stronghold:GetPlayerRankName(_PlayerID, 3)
            );
        end
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Research];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers3_normal" then
        Text = self.Config.UI.Measure[BlessCategories.Weapons][1][Language];
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            RequireText = string.gsub(
                self.Config.UI.Require[Language] ..
                self.Config.UI.Measure[BlessCategories.Weapons][3][Language],
                "#Rank#", Stronghold:GetPlayerRankName(_PlayerID, 4)
            );
        end
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Weapons];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers4_normal" then
        Text = self.Config.UI.Measure[BlessCategories.Financial][1][Language];
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            RequireText = string.gsub(
                self.Config.UI.Require[Language] ..
                self.Config.UI.Measure[BlessCategories.Financial][3][Language],
                "#Rank#", Stronghold:GetPlayerRankName(_PlayerID, 5)
            );
        end
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Financial];
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers5_normal" then
        Text = self.Config.UI.Measure[BlessCategories.Canonisation][1][Language];
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            RequireText = string.gsub(
                self.Config.UI.Require[Language] ..
                self.Config.UI.Measure[BlessCategories.Canonisation][3][Language],
                "#Rank#", Stronghold:GetPlayerRankName(_PlayerID, 7)
            );
        end
        Effects = Stronghold.Building.Config.Headquarters[BlessCategories.Canonisation];
    else
        return false;
    end

    if Effects.Reputation > 0 then
        EffectText = EffectText.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
    elseif Effects.Reputation < 0 then
        EffectText = EffectText .. Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
    end
    if Effects.Honor > 0 then
        EffectText = EffectText.. "+" ..Effects.Honor.." " ..Stronghold.Config.UI.Honor[Language];
    end

    XGUIEng.SetText(
        gvGUI_WidgetID.TooltipBottomText,
        Placeholder.Replace(Text .. RequireText .. EffectText)
    );
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
    local Language = GetLanguage();
    if Logic.IsEntityInCategory(_EntityID, EntityCategories.Headquarters) == 0 then
        return false;
    end
    local Text = "";
    if _Key == "MenuBuildingGeneric/ToBuildingcommandmenu" then
        Text = self.Config.UI.TreasurySubMenu[Language];
    elseif _Key == "MenuBuildingGeneric/tobuildingsettlersmenu" then
        Text = self.Config.UI.AdministrationSubMenu[Language];
    else
        return false;
    end
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Placeholder.Replace(Text));
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
        local Language = GetLanguage();
        Message(self.Config.UI.PrayerMess[_BlessCategory][2][Language]);
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
    local Language = GetLanguage();
    local Type = Logic.GetEntityType(_EntityID);
    if Logic.GetUpgradeCategoryByBuildingType(Type) ~= UpgradeCategories.Monastery then
        return false;
    end
    local Text = "";

    if _TooltipNormal == "AOMenuMonastery/BlessSettlers1_normal" then
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers1) == 0 then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        else
            Text = self.Config.UI.PrayerMess[BlessCategories.Construction][1][Language];
            Text = Text .. self.Config.UI.Effect[Language];
            local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Construction];
            if Effects.Reputation > 0 then
                Text = Text.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
            end
            if Effects.Honor > 0 then
                Text = Text.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
            end
        end
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers2_normal" then
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers2) == 0 then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        else
            Text = self.Config.UI.PrayerMess[BlessCategories.Research][1][Language];
            Text = Text .. self.Config.UI.Effect[Language];
            local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Research];
            if Effects.Reputation > 0 then
                Text = Text.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
            end
            if Effects.Honor > 0 then
                Text = Text.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
            end
        end
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers3_normal" then
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers3) == 0 then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        else
            Text = self.Config.UI.PrayerMess[BlessCategories.Weapons][1][Language];
            if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
                Text = Text .. self.Config.UI.Require[Language] ..
                       self.Config.UI.PrayerMess[BlessCategories.Weapons][3][Language];
            end
            Text = Text .. self.Config.UI.Effect[Language];
            local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Weapons];
            if Effects.Reputation > 0 then
                Text = Text.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
            end
            if Effects.Honor > 0 then
                Text = Text.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
            end
        end
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers4_normal" then
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers4) == 0 then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        else
            Text = self.Config.UI.PrayerMess[BlessCategories.Financial][1][Language];
            if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
                Text = Text .. self.Config.UI.Require[Language] ..
                       self.Config.UI.PrayerMess[BlessCategories.Financial][3][Language];
            end
            Text = Text .. self.Config.UI.Effect[Language];
            local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Financial];
            if Effects.Reputation > 0 then
                Text = Text.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
            end
            if Effects.Honor > 0 then
                Text = Text.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
            end
        end
    elseif _TooltipNormal == "AOMenuMonastery/BlessSettlers5_normal" then
        if Logic.GetTechnologyState(_PlayerID, Technologies.T_BlessSettlers5) == 0 then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        else
            Text = self.Config.UI.PrayerMess[BlessCategories.Canonisation][1][Language];
            if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
                Text = Text .. self.Config.UI.Require[Language] ..
                       self.Config.UI.PrayerMess[BlessCategories.Canonisation][3][Language];
            end
            Text = Text .. self.Config.UI.Effect[Language];
            local Effects = Stronghold.Building.Config.Monastery[BlessCategories.Canonisation];
            if Effects.Reputation > 0 then
                Text = Text.. "+" ..Effects.Reputation.. " " ..Stronghold.Config.UI.Reputation[Language].. " ";
            end
            if Effects.Honor > 0 then
                Text = Text.. "+" ..Effects.Honor.. " " ..Stronghold.Config.UI.Honor[Language];
            end
        end
    else
        return false;
    end

    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Placeholder.Replace(Text));
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
