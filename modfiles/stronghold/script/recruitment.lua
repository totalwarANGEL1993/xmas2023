--- 
--- Recruitment Script
--- 

Stronghold = Stronghold or {};

Stronghold.Recruitment = Stronghold.Recruitment or {
    SyncEvents = {},
    Data = {},
    Config = {},
};

function Stronghold.Recruitment:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {
            Config = CopyTable(self.Config.Units),
            Roster = {}
        };

        self:InitDefaultRoster(i);
    end
    self:CreateBuildingButtonHandlers();
end

function Stronghold.Recruitment:OnSaveGameLoaded()
end

function Stronghold.Recruitment:InitDefaultRoster(_PlayerID)
    self.Data[_PlayerID].Roster = {
        -- Barracks
        -- ["Research_UpgradeSword1"] = Entities.PU_LeaderPoleArm1,
        ["Research_UpgradeSword1"] = Entities.CU_BlackKnight_LeaderMace2,
        ["Research_UpgradeSword2"] = Entities.PU_LeaderPoleArm3,
        ["Research_UpgradeSword3"] = Entities.PU_LeaderSword2,
        ["Research_UpgradeSpear1"] = Entities.PU_LeaderSword3,
        ["Research_UpgradeSpear2"] = nil,
        ["Research_UpgradeSpear3"] = nil,
        -- Archery
        ["Research_UpgradeBow1"] = Entities.PU_LeaderBow1,
        ["Research_UpgradeBow2"] = Entities.PU_LeaderBow3,
        ["Research_UpgradeBow3"] = Entities.PU_LeaderRifle1,
        ["Research_UpgradeRifle1"] = Entities.PU_LeaderRifle2,
        -- Stable
        ["Research_UpgradeCavalryLight1"] = Entities.PU_LeaderCavalry1,
        ["Research_UpgradeCavalryHeavy1"] = Entities.PU_LeaderHeavyCavalry1,
        -- Foundry
        -- TODO???
    };
end

function Stronghold.Recruitment:CreateBuildingButtonHandlers()
    self.SyncEvents = {
        BuyUnit = 1,
    };
    self.NetworkCall = Syncer.CreateEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Recruitment.SyncEvents.BuyUnit then
                Stronghold.Unit:BuyUnit(_PlayerID, arg[2], arg[1], arg[3]);
            end
        end
    );
end

-- -------------------------------------------------------------------------- --

function Stronghold.Recruitment:IsSufficientRecruiterBuilding(_BuildingID, _Type)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local Config = self:GetConfig(_Type, PlayerID);
    if Config then
        local BuildingType = Logic.GetEntityType(_BuildingID);
        return IsInTable(BuildingType, Config.RecruiterBuilding);
    end
    return false;
end

function Stronghold.Recruitment:HasSufficientProviderBuilding(_BuildingID, _Type)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local Config = self:GetConfig(_Type, PlayerID);
    if Config then
        local Providers = table.getn(Config.ProviderBuilding);
        if Providers == 0 then
            return true;
        end
        for i= 1, Providers do
            local BuildingType = Config.ProviderBuilding[i];
            local Buildings = GetValidEntitiesOfType(PlayerID, BuildingType);
            if table.getn(Buildings) > 0 then
                return true;
            end
        end
    end
    return false;
end

function Stronghold.Recruitment:HasSufficientRank(_BuildingID, _Type)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local Config = self:GetConfig(_Type, PlayerID);
    if Config then
        if GetPlayerRank(PlayerID) >= Config.Rank then
            return true;
        end
    end
    return false;
end

function Stronghold.Recruitment:IsUnitAllowed(_BuildingID, _Type)
    local PlayerID = Logic.EntityGetPlayer(_BuildingID);
    local Config = self:GetConfig(_Type, PlayerID);
    if Config then
        return Config.Allowed == true;
    end
    return false;
end

function Stronghold.Recruitment:GetLeaderCosts(_PlayerID, _Type, _SoldierAmount)
    local Costs = {};
    local Config = self:GetConfig(_Type, _PlayerID);
    if Config then
        Costs = CopyTable(Config.Costs[1]);
        Costs = CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        if _SoldierAmount and _SoldierAmount > 0 then
            local SoldierCosts = self:GetSoldierCostsByLeaderType(_PlayerID, _Type, _SoldierAmount);
            Costs = MergeCostTable(Costs, SoldierCosts);
        end
    end
    return Costs;
end

function Stronghold.Recruitment:GetSoldierCostsByLeaderType(_PlayerID, _Type, _Amount)
    local Costs = {};
    local Config = self:GetConfig(_Type, _PlayerID);
    if Config then
        Costs = CopyTable(Config.Costs[2]);
        for i= 2, 7 do
            Costs[i] = Costs[i] * _Amount;
        end
        Costs = CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
    end
    return Costs;
end

-- -------------------------------------------------------------------------- --

function Stronghold.Recruitment:OnBarracksSettlerUpgradeTechnologyClicked(_Technology)
    local UnitToRecruit = {
        [Technologies.T_UpgradeSword1] = {"Research_UpgradeSword1"},
        [Technologies.T_UpgradeSword2] = {"Research_UpgradeSword2"},
        [Technologies.T_UpgradeSword3] = {"Research_UpgradeSword3"},
        [Technologies.T_UpgradeSpear1] = {"Research_UpgradeSpear1"},
        [Technologies.T_UpgradeSpear2] = {"Research_UpgradeSpear2"},
        [Technologies.T_UpgradeSpear3] = {"Research_UpgradeSpear3"},
    }
    return self:OnRecruiterSettlerUpgradeTechnologyClicked(UnitToRecruit, _Technology);
end

function Stronghold.Recruitment:OnArcherySettlerUpgradeTechnologyClicked(_Technology)
    local UnitToRecruit = {
        [Technologies.T_UpgradeBow1] = {"Research_UpgradeBow1"},
        [Technologies.T_UpgradeBow2] = {"Research_UpgradeBow2"},
        [Technologies.T_UpgradeBow3] = {"Research_UpgradeBow3"},
        [Technologies.T_UpgradeRifle1] = {"Research_UpgradeRifle1"},
    }
    return self:OnRecruiterSettlerUpgradeTechnologyClicked(UnitToRecruit, _Technology);
end

function Stronghold.Recruitment:OnStableSettlerUpgradeTechnologyClicked(_Technology)
    local UnitToRecruit = {
        [Technologies.T_UpgradeLightCavalry1] = {"Research_UpgradeCavalryLight1"},
        [Technologies.T_UpgradeHeavyCavalry1] = {"Research_UpgradeCavalryHeavy1"},
    }
    return self:OnRecruiterSettlerUpgradeTechnologyClicked(UnitToRecruit, _Technology);
end

function Stronghold.Recruitment:OnRecruiterSettlerUpgradeTechnologyClicked(_UnitToRecruit, _Technology)
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
    if _UnitToRecruit[_Technology] then
        local Button = _UnitToRecruit[_Technology][1];
        if self.Data[PlayerID].Roster[Button] then
            local UnitType = self.Data[PlayerID].Roster[Button];
            local Config = self:GetConfig(UnitType, PlayerID);
            local Soldiers = (AutoFillActive and Config.Soldiers) or 0;

            local Places = Stronghold.Attraction:GetMilitarySpaceForUnitType(UnitType, Soldiers +1);
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
                    self.NetworkCall,
                    self.SyncEvents.BuyUnit, EntityID, UnitType, AutoFillActive
                );
            end
            return true;
        end
    end
    return false;
end

-- -------------------------------------------------------------------------- --

function Stronghold.Recruitment:OnBarracksSelected(_EntityID)
    local ButtonsToUpdate = {
        ["Research_UpgradeSword1"] = {4, 4, 31, 31},
        ["Research_UpgradeSword2"] = {38, 4, 31, 31},
        ["Research_UpgradeSword3"] = {72, 4, 31, 31},
        ["Research_UpgradeSpear1"] = {106, 4, 31, 31},
        ["Research_UpgradeSpear2"] = {174, 4, 31, 31},
        ["Research_UpgradeSpear3"] = {208, 4, 31, 31},
    };
    local Type = Logic.GetEntityType(_EntityID);
    if Type ~= Entities.PB_Barracks1 and Type ~= Entities.PB_Barracks2 then
        return;
    end
    XGUIEng.SetWidgetPositionAndSize("Research_BetterTrainingBarracks", 4, 38, 31, 31);
    XGUIEng.ShowWidget("Buy_LeaderSword", 0);
    XGUIEng.ShowWidget("Buy_LeaderSpear", 0);
    self:OnRecruiterSelected(ButtonsToUpdate, _EntityID);
end

function Stronghold.Recruitment:OnArcherySelected(_EntityID)
    local ButtonsToUpdate = {
        ["Research_UpgradeBow1"] = {4, 4, 31, 31},
        ["Research_UpgradeBow2"] = {38, 4, 31, 31},
        ["Research_UpgradeBow3"] = {72, 4, 31, 31},
        ["Research_UpgradeRifle1"] = {106, 4, 31, 31},
    };
    local Type = Logic.GetEntityType(_EntityID);
    if Type ~= Entities.PB_Archery1 and Type ~= Entities.PB_Archery2 then
        return;
    end
    XGUIEng.SetWidgetPositionAndSize("Research_BetterTrainingArchery", 4, 38, 31, 31);
    XGUIEng.ShowWidget("Buy_LeaderBow", 0);
    XGUIEng.ShowWidget("Buy_LeaderRifle", 0);
    self:OnRecruiterSelected(ButtonsToUpdate, _EntityID);
end

function Stronghold.Recruitment:OnStableSelected(_EntityID)
    local ButtonsToUpdate = {
        ["Research_UpgradeCavalryLight1"] = {4, 4, 31, 31},
        ["Research_UpgradeCavalryHeavy1"] = {38, 4, 31, 31},
    };
    local Type = Logic.GetEntityType(_EntityID);
    if Type ~= Entities.PB_Stable1 and Type ~= Entities.PB_Stable2 then
        return;
    end
    XGUIEng.SetWidgetPositionAndSize("Research_Shoeing", 4, 38, 31, 31);
    XGUIEng.ShowWidget("Buy_LeaderCavalryLight", 0);
    XGUIEng.ShowWidget("Buy_LeaderCavalryHeavy", 0);
    self:OnRecruiterSelected(ButtonsToUpdate, _EntityID);
end

function Stronghold.Recruitment:OnRecruiterSelected(_ButtonsToUpdate, _EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    for k, v in pairs(_ButtonsToUpdate) do
        XGUIEng.ShowWidget(k, 0);
        if self.Data[PlayerID].Roster[k] then
            local UnitType = self.Data[PlayerID].Roster[k];
            local Config = self:GetConfig(UnitType, PlayerID);
            XGUIEng.TransferMaterials(Config.Button, k);
            XGUIEng.SetWidgetPositionAndSize(k, v[1], v[2], v[3], v[4]);
            XGUIEng.ShowWidget(k, 1);

            local Disabled = 1;
            if  self:IsSufficientRecruiterBuilding(_EntityID, UnitType)
            and self:HasSufficientProviderBuilding(_EntityID, UnitType)
            and self:HasSufficientRank(_EntityID, UnitType)
            and self:IsUnitAllowed(_EntityID, UnitType) then
                Disabled = 0;
            end
            XGUIEng.DisableButton(k, Disabled);
        end
    end
end

-- -------------------------------------------------------------------------- --

function Stronghold.Recruitment:UpdateUpgradeSettlersBarracksTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local TextToPrint = {
        ["MenuBarracks/UpgradeSword1"] = {"Research_UpgradeSword1", " [A]"},
        ["MenuBarracks/UpgradeSword2"] = {"Research_UpgradeSword2", " [S]"},
        ["MenuBarracks/UpgradeSword3"] = {"Research_UpgradeSword3", " [D]"},
        ["MenuBarracks/UpgradeSpear1"] = {"Research_UpgradeSpear1", " [F]"},
        ["MenuBarracks/UpgradeSpear2"] = {"Research_UpgradeSpear2", " [G]"},
        ["MenuBarracks/UpgradeSpear3"] = {"Research_UpgradeSpear3", " [H]"},
    };
    return self:UpdateUpgradeSettlersRecruiterTooltip(TextToPrint, _PlayerID, _Technology, _TextKey, _ShortCut);
end

function Stronghold.Recruitment:UpdateUpgradeSettlersArcheryTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local TextToPrint = {
        ["MenuArchery/UpgradeBow1"] = {"Research_UpgradeBow1", " [A]"},
        ["MenuArchery/UpgradeBow2"] = {"Research_UpgradeBow2", " [S]"},
        ["MenuArchery/UpgradeBow3"] = {"Research_UpgradeBow3", " [D]"},
        ["AOMenuArchery/UpgradeRifle1"] = {"Research_UpgradeRifle1", " [F]"},
    };
    return self:UpdateUpgradeSettlersRecruiterTooltip(TextToPrint, _PlayerID, _Technology, _TextKey, _ShortCut);
end

function Stronghold.Recruitment:UpdateUpgradeSettlersStableTooltip(_PlayerID, _Technology, _TextKey, _ShortCut)
    local TextToPrint = {
        ["MenuStables/UpgradeCavalryLight1"] = {"Research_UpgradeCavalryLight1", " [A]"},
        ["MenuStables/UpgradeCavalryHeavy1"] = {"Research_UpgradeCavalryHeavy1", " [S]"},
    };
    return self:UpdateUpgradeSettlersRecruiterTooltip(TextToPrint, _PlayerID, _Technology, _TextKey, _ShortCut);
end

function Stronghold.Recruitment:UpdateUpgradeSettlersRecruiterTooltip(_TextToPrint, _PlayerID, _Technology, _TextKey, _ShortCut)
    local WidgetID = XGUIEng.GetCurrentWidgetID();
    local EntityID = GUI.GetSelectedEntity();
    local Text = "";
    local ShortcutText = "";
    local CostsText = "";

    if _TextToPrint[_TextKey] then
        local UnitType = self.Data[_PlayerID].Roster[_TextToPrint[_TextKey][1]];
        local Config = self:GetConfig(UnitType, _PlayerID);
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/UnitNotAvailable");
        else
            ShortcutText = XGUIEng.GetStringTableText("MenuGeneric/Key_name") .. _TextToPrint[_TextKey][2];
            local Soldiers = (Logic.IsAutoFillActive(EntityID) == 1 and 6) or 0;
            local Costs = Stronghold.Unit:GetLeaderCosts(_PlayerID, UnitType, Soldiers);
            CostsText = Stronghold:FormatCostString(_PlayerID, Costs);
            Text = Placeholder.Replace(Config.TextNormal[GetLanguage()]);
            if XGUIEng.IsButtonDisabled(WidgetID) == 1 then
                local DisabledText = Placeholder.Replace(Config.TextDisabled[GetLanguage()]);
                local RankName = Stronghold:GetPlayerRankName(_PlayerID, Config.Rank);
                DisabledText = string.gsub(DisabledText, "#Rank#", RankName);
                Text = Text .. DisabledText;
            end
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

function Stronghold.Recruitment:GetConfig(_Type, _PlayerID)
    if not _PlayerID or not self.Data[_PlayerID] then
        return self.Config.Units[_Type];
    end
    return self.Data[_PlayerID].Config[_Type];
end

Stronghold.Recruitment.Config.Units = {
    -- Spear Tier 1 --
    [Entities.PU_LeaderPoleArm1]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Speerträger{cr}{white}Billige Truppen, die höchstens als Kanonenfutter taugen.{cr}",
            en = "{grey}Spearman{cr}{white}Cheap troops, good only as cannon fodder.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#",
            en = "@color:244,184,0 requires:{white} #Rank#",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {0, 50, 0, 40, 0, 0, 0},
            [2] = {0, 5, 0, 10, 0, 0, 0},
        },
        Rank              = 1,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {},
    },
    -- Spear Tier 2 --
    [Entities.PU_LeaderPoleArm2]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Lanzenträger{cr}{white}Leichte Speerträger, die nur gegen Kavallerie eingesetzt werden sollten.{cr}",
            en = "{grey}Lancer{cr}{white}Light spearmen that should only be used against cavalry.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {5, 75, 0, 50, 0, 0, 0},
            [2] = {0, 10, 0, 25, 0, 0, 0},
        },
        Rank              = 2,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    -- Spear Tier 3 --
    [Entities.PU_LeaderPoleArm3]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Landsknecht{cr}{white}Diese Männer führen eine Streitlanze gegen Kavallerie, können aber auch Schwertkämpfer beschäftigen.{cr}",
            en = "{grey}Battle Lancer{cr}{white}Diese Männer führen eine Streitlanze gegen Kavallerie, können aber auch Schwertkämpfer beschäftigen.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Sawmill",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {10, 150, 0, 70, 0, 10, 0},
            [2] = {0, 65, 0, 40, 0, 5, 0},
        },
        Rank              = 3,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    -- Spear Tier 4 --
    [Entities.PU_LeaderPoleArm4]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Hellebardier{cr}{white}Hellebardiere sind stark gegen Kavallerie und können dank guter Rüstung die Position lange halten.{cr}",
            en = "{grey}Halberdier{cr}{white}Halberdiers are strong against cavalry and can hold their position for a long time thanks to good armor.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Sägewerk",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Lumber Mill",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {15, 200, 0, 80, 0, 20, 0},
            [2] = {0, 75, 0, 45, 0, 10, 0},
        },
        Rank              = 3,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Sawmill2},
    },

    -- Sword Tier 1 --
    [Entities.PU_LeaderSword1]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Kurzschwertkämpfer{cr}{white}Statt mit ihrem \"Schwert\" könnten diese Männer genauso gut mit einem Buttermesser in die Schlacht ziehen.{cr}",
            en = "{grey}Shortswordman{cr}{white}{cr}Instead of using their \"sword\" these men might as well go into battle with a butter knife.",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#",
            en = "@color:244,184,0 requires:{white} #Rank#",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {6, 100, 0, 0, 0, 50, 0},
            [2] = {0, 15, 0, 0, 0, 10, 0},
        },
        Rank              = 2,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {},
    },
    [Entities.CU_Barbarian_LeaderClub2]     = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Barbarenkrieger{cr}{white}Barbarenkrieger sind effektiv gegen gepanzerte Truppen und ihre Nagelkeulen können tiefe Wunden reißen.{cr}",
            en = "{grey}Barbarian Warrior{cr}{white}Barbarian warriors are effective against armored troops, and their spiked clubs can inflict deep wounds.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#",
            en = "@color:244,184,0 requires:{white} #Rank#",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {10, 150, 0, 80, 0, 20, 0},
            [2] = {0, 50, 0, 25, 0, 10, 0},
        },
        Rank              = 2,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {},
    },
    [Entities.CU_BlackKnight_LeaderMace2]   = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Schwarzer Ritter{cr}{white}Diese Truppen setzt man am Besten gegen gepanzerte Truppen ein.{cr}",
            en = "{grey}Black Knight{cr}{white}{cr}These troops are best used against armored troops.",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Smithy",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {12, 170, 0, 0, 0, 65, 0},
            [2] = {0, 50, 0, 0, 0, 40, 0},
        },
        Rank              = 3,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_BanditLeaderSword2]        = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Wegelagerer{cr}{white}Räuber und Wegelagerer, die ihre Äxte gut gegen andere Infanterie einsetzen können.{cr}",
            en = "{grey}Highwayman{cr}{white}Raiders and highwaymen who are good at using their axes against other infantry.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Smithy",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {12, 170, 0, 0, 0, 65, 0},
            [2] = {0, 50, 0, 0, 0, 40, 0},
        },
        Rank              = 2,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    -- Sword Tier 2 --
    [Entities.PU_LeaderSword2]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Breitschwertkämpfer{cr}{white}Breitschwertkämpfer können gegen Speerträger und Fernkämpfer eingesetzt werden.{cr}",
            en = "{grey}Broadswordman{cr}{white}{cr}Broadswordsmen can be used against spearmen and ranged troops.",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Smithy",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {10, 150, 0, 0, 0, 60, 0},
            [2] = {0, 50, 0, 0, 0, 35, 0},
        },
        Rank              = 4,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_Barbarian_LeaderClub1]     = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Elitekrieger der Barbaren{cr}{white}Diese Elitekrieger sind gut gegen gepanzerte Truppen und können hohen kritischen Schaden austeilen.{cr}",
            en = "{grey}Elite of the Barbarians{cr}{white}These elite warriors are good against armored troops and can deal high critical damage.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Smithy",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {16, 200, 0, 0, 0, 65, 0},
            [2] = {0, 60, 0, 0, 0, 40, 0},
        },
        Rank              = 3,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_BlackKnight_LeaderMace1]   = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Edler Schwarzer Ritter{cr}{white}Die edlen schwarzen Ritter können mit ihren Keulen Rüstungen verbeulen und ein wahrer Albtraum werden.{cr}",
            en = "{grey}Black Knight Elite{cr}{white}The noble black knights can dent armor with their clubs and become a real nightmare.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Grobschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Blacksmith",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {16, 200, 0, 0, 0, 65, 0},
            [2] = {0, 60, 0, 0, 0, 40, 0},
        },
        Rank              = 5,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_BanditLeaderSword1]        = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Banditenkrieger{cr}{white}Diese erfahrenen Gesetzlosen schwingen die Axt und schnetzeln sich durch feindliche Infanterie.{cr}",
            en = "{grey}Bandit Warrior{cr}{white}These experienced outlaws wield their ax and slice through the lines of the enemy.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Grobschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Blacksmith",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {16, 200, 0, 0, 0, 65, 0},
            [2] = {0, 60, 0, 0, 0, 40, 0},
        },
        Rank              = 4,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_Evil_LeaderBearman1]       = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Bärenmensch{cr}{white}Fanatiker in rituellen Bärenkostümen, die keine Gnade für gewöhnliche Infantrie aufbringen wird.{cr}",
            en = "{grey}Bearman{cr}{white}Fanatics in ritual bear costumes who will show no mercy to ordinary infantry.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 16,
        Costs             = {
            [1] = {15, 90, 0, 160, 0, 40, 0},
            [2] = {0, 30, 0, 60, 0, 20, 0},
        },
        Rank              = 4,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    -- Sword Tier 3 --
    [Entities.PU_LeaderSword3]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Langschwertkämpfer{cr}{white}Erfahrene und gut ausgerüstete Soldaten, die mit Infanterie kurzen Prozess machen.{cr}",
            en = "{grey}Longswordman{cr}{white}Experienced and well-equipped soldiers who make short work of infantry.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Grobschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Blacksmith",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {20, 230, 0, 0, 0, 70, 0},
            [2] = {0, 60, 0, 0, 0, 45, 0},
        },
        Rank              = 5,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    -- Sword Tier 4 --
    [Entities.PU_LeaderSword4]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Bastardschwertkämpfer{cr}{white}Bastardschwertkämpfer sind die Elite unter den Nahkämpfern und stark gegen alle anderen Fußsolldaten.{cr}",
            en = "{grey}Elite Swordman{cr}{white}{cr}Elite Swordsmen are the best of the best and strong against all other foot soldiers.",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Feinschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Finishing Smithy",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {30, 275, 0, 0, 0, 85, 0},
            [2] = {0, 75, 0, 0, 0, 60, 0},
        },
        Rank              = 7,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith3},
    },

    -- Bow Tier 1 --
    [Entities.PU_LeaderBow1]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Kurzbogenschütze{cr}{white}Diese leichten Bogenschützen sind in großen Gruppen effektiv gegen leichte Infanterie.{cr}",
            en = "{grey}Shortbowman{cr}{white}These light archers are effective against light infantry in large groups.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#",
            en = "@color:244,184,0 requires:{white} #Rank#",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {4, 90, 0, 60, 0, 0, 0},
            [2] = {0, 10, 0, 10, 0, 0, 0},
        },
        Allowed           = true,
        Rank              = 2,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {},
    },
    [Entities.CU_BanditLeaderBow1]          = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Banditenbogenschütze{cr}{white}Diese Bogenschützen sind den Kampf gewohnt und darum excellent gegen leicht gepanzerte Truppen.{cr}",
            en = "{grey}Outlaw Bowman{cr}{white}These archers are used to combat and are therefore excellent against lightly armored troops.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {8, 110, 0, 70, 0, 0, 0},
            [2] = {0, 20, 0, 20, 0, 0, 0},
        },
        Allowed           = false,
        Rank              = 2,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    -- Bow Tier 2 --
    [Entities.PU_LeaderBow2]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Langbogenschütze{cr}{white}Diese professionellen Bogenschützen sind effektiv gegen andere leicht gepanterte Truppen.{cr}",
            en = "{grey}Longbowman{cr}{white}These professional archers are effective against other lightly armored troops.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {6, 110, 0, 70, 0, 0, 0},
            [2] = {0, 20, 0, 20, 0, 0, 0},
        },
        Allowed           = false,
        Rank              = 2,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    [Entities.CU_Evil_LeaderSkirmisher1]    = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Bärenmensch{cr}{white}Nicht weniger fanatisch als die Bärenmenschen sind auch die Speerwerfer stark gegen gewöhnliche Truppen.{cr}",
            en = "{grey}Bearman{cr}{white}No less fanatical than the bearmen, the javelin throwers are strong against common troops.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 16,
        Costs             = {
            [1] = {10, 100, 0, 140, 0, 0, 0},
            [2] = {0, 30, 0, 70, 0, 0, 0},
        },
        Allowed           = true,
        Rank              = 3,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    -- Bow Tier 3 --
    [Entities.PU_LeaderBow3]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Armbrustschütze{cr}{white}Armbrustschützen können viel Schaden austeilen, brauchen aber lange um nachzuladen.{cr}",
            en = "{grey}Crossbowman{cr}{white}Crossbowmen can deal a lot of damage but take a long time to reload.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schießanlage, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Archery, Sawmill",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {12, 250, 0, 35, 0, 35, 0},
            [2] = {0, 60, 0, 15, 0, 25, 0},
        },
        Allowed           = true,
        Rank              = 3,
        RecruiterBuilding = {Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
    -- Bow Tier 4 --
    [Entities.PU_LeaderBow4]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Arbaleastschütze{cr}{white}Die hochmittelalterliche Armbrust ist sehr stark gegen Infanterie aber auch sehr langsam.{cr}",
            en = "{grey}Heavy Crossbowman{cr}{white}The high medieval crossbow is very strong against foot soldiers but also very slow.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schießanlage, Sägewerk",
            en = "@color:244,184,0 requires:{white} #Rank#, Archery, Lumber Mill",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {16, 300, 0, 40, 0, 40, 0},
            [2] = {0, 75, 0, 20, 0, 30, 0},
        },
        Allowed           = false,
        Rank              = 5,
        RecruiterBuilding = {Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill2},
    },

    -- Rifle Tier 1 --
    [Entities.PU_LeaderRifle1]              = {
        Button            = "Buy_LeaderRifle",
        TextNormal        = {
            de = "{grey}Leichter Scharfschütze{cr}{white}Scharfschützen sind gut gegen alle anderen Truppen, werden im Nahkampf jedoch niedergemetzelt.{cr}",
            en = "{grey}Light Sharpshooter{cr}{white}{cr}Sharpshooters are good to use against all other troops, but should stay out of close combat.",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Büchsenmacher",
            en = "@color:244,184,0 requires:{white} #Rank#, Gunsmith's Shop",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {35, 250, 0, 20, 0, 0, 50},
            [2] = {0, 60, 0, 20, 0, 0, 30},
        },
        Allowed           = true,
        Rank              = 5,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_GunsmithWorkshop1, Entities.PB_GunsmithWorkshop2},
    },
    -- Rifle Tier 1 --
    [Entities.PU_LeaderRifle2]              = {
        Button            = "Buy_LeaderRifle",
        TextNormal        = {
            de = "{grey}Schwerer Scharfschütze{cr}{white}Die schweren Scharfschützen haben Feuerrate gegen Schaden gegen alle anderen Truppentypen eingetauscht.{cr}",
            en = "{grey}Heavy Sharpshooter{cr}{white}The heavy sharpshooters traded a higher firerate for collosal damage against all other troop types.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schießanlage, Büchsenmanufaktur",
            en = "@color:244,184,0 requires:{white} #Rank#, Archery, Gun Factory",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {50, 300, 0, 0, 0, 20, 60},
            [2] = {0, 70, 0, 0, 0, 20, 30},
        },
        Allowed           = true,
        Rank              = 7,
        RecruiterBuilding = {Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_GunsmithWorkshop2},
    },

    -- Cavalry Tier 1 --
    [Entities.PU_LeaderCavalry1] = {
        Button            = "Buy_LeaderCavalryLight",
        TextNormal        = {
            de = "{grey}Berittener Bogenschütze{cr}{white}Berittene Bogenschützen sind schnell und stark gegen leichte Truppen.{cr}",
            en = "{grey}Mounted Archer{cr}{white}Mounted archers are fast and strong against light troops.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägewerk",
            en = "@color:244,184,0 requires:{white} #Rank#, Lumber Mill",
        },
        Soldiers          = 5,
        Costs             = {
            [1] = {12, 200, 0, 40, 0, 20, 0},
            [2] = {0, 60, 0, 15, 0, 5, 0},
        },
        Allowed           = true,
        Rank              = 4,
        RecruiterBuilding = {Entities.PB_Stable1, Entities.PB_Stable2},
        ProviderBuilding  = {Entities.PB_Sawmill2},
    },
    -- Cavalry Tier 2 --
    [Entities.PU_LeaderCavalry2] = {
        Button            = "Buy_LeaderCavalryLight",
        TextNormal        = {
            de = "{grey}Berittener Armbrustschütze{cr}{white}Zu Pferde sind Armbrustschützen nicht weniger tödlich gegen Infanterie, dafür aber schneller zu Fuß.{cr}",
            en = "{grey}Mounted Crossbowman{cr}{white}Mounted crossbowmen are no less deadly against infantry, but are faster on foot.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägewerk",
            en = "@color:244,184,0 requires:{white} #Rank#, Lumber Mill",
        },
        Soldiers          = 5,
        Costs             = {
            [1] = {24, 250, 0, 20, 0, 50, 0},
            [2] = {0, 80, 0, 20, 0, 10, 0},
        },
        Allowed           = false,
        Rank              = 4,
        RecruiterBuilding = {Entities.PB_Stable1, Entities.PB_Stable2},
        ProviderBuilding  = {Entities.PB_Sawmill2},
    },
    -- Heavy Cavalry Tier 1 --
    [Entities.PU_LeaderHeavyCavalry1] = {
        Button            = "Buy_LeaderCavalryHeavy",
        TextNormal        = {
            de = "{grey}Berittener Schwertkämpfer{cr}{white}Die berittenen Schwertkämpfer können feindliche Infanterie - besonders Schwertkämpfer - auseinander nehmen.{cr}",
            en = "{grey}Mounted Swordman{cr}{white}The mounted swordsmen can slice apart enemy infantry very well. Especially swordsmen will fall to their hands.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Reitanlage, Feinschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Stables, Finishing Smithy",
        },
        Soldiers          = 5,
        Costs             = {
            [1] = {40, 300, 0, 0, 0, 90, 0},
            [2] = {0, 100, 0, 0, 0, 30, 0},
        },
        Allowed           = true,
        Rank              = 6,
        RecruiterBuilding = {Entities.PB_Stable2},
        ProviderBuilding  = {Entities.PB_Blacksmith3},
    },
    -- Heavy Cavalry Tier 2 --
    [Entities.PU_LeaderHeavyCavalry2] = {
        Button            = "Buy_LeaderCavalryHeavy",
        TextNormal        = {
            de = "{grey}Berittener Axtkämpfer{cr}{white}Diese brutalen Krieger schwingen zu Pferde die Axt und hacken die feindlichen Truppen in Stücke.{cr}",
            en = "{grey}Mounted Axeman{cr}{white}These brutal warriors wield axes on horseback and enjoy choping enemy troops to pieces.{cr}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Reitanlage, Feinschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Stables, Finishing Smithy",
        },
        Soldiers          = 5,
        Costs             = {
            [1] = {50, 400, 0, 0, 0, 110, 0},
            [2] = {0, 120, 0, 0, 0, 40, 0},
        },
        Allowed           = false,
        Rank              = 6,
        RecruiterBuilding = {Entities.PB_Stable2},
        ProviderBuilding  = {Entities.PB_Blacksmith3},
    },
};

