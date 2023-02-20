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
        ["Research_UpgradeSword1"] = Entities.PU_LeaderPoleArm1,
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
        -- TODO
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
    [Entities.PU_LeaderPoleArm1]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Speerträger{cr}{white}",
            en = "{grey}Spearman{cr}{white}",
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
    [Entities.PU_LeaderPoleArm2]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Lanzenträger{cr}{white}",
            en = "{grey}Lancer{cr}{white}",
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
    [Entities.PU_LeaderPoleArm3]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Landsknecht{cr}{white}",
            en = "{grey}Battle Lancer{cr}{white}",
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
    [Entities.PU_LeaderPoleArm4]            = {
        Button            = "Buy_LeaderSpear",
        TextNormal        = {
            de = "{grey}Hellebardier{cr}{white}",
            en = "{grey}Halberdier{cr}{white}",
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
        Rank              = 6,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Sawmill2},
    },

    [Entities.PU_LeaderSword1]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Kurzschwertkämpfer{cr}{white}",
            en = "{grey}Shortswordman{cr}{white}",
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
    [Entities.PU_LeaderSword2]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Breitschwertkämpfer{cr}{white}",
            en = "{grey}Broadswordman{cr}{white}",
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
    [Entities.PU_LeaderSword3]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Langschwertkämpfer{cr}{white}",
            en = "{grey}Longswordman{cr}{white}",
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
    [Entities.PU_LeaderSword4]              = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Bastardschwertkämpfer{cr}{white}",
            en = "{grey}Elite Swordman{cr}{white}",
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

    [Entities.CU_Barbarian_LeaderClub1]     = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Elitekrieger der Barbaren{cr}{white}",
            en = "{grey}Elite of the Barbarians{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Smithy",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {10, 150, 0, 0, 0, 60, 0},
            [2] = {0, 50, 0, 0, 0, 35, 0},
        },
        Rank              = 3,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_Barbarian_LeaderClub2]     = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Barbarenkrieger{cr}{white}",
            en = "{grey}Barbarian Warrior{cr}{white}",
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

    [Entities.CU_BlackKnight_LeaderMace1]   = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Edler Schwarzer Ritter{cr}{white}",
            en = "{grey}Black Knight Elite{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Garnison, Grobschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Garnison, Blacksmith",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {10, 150, 0, 0, 0, 60, 0},
            [2] = {0, 50, 0, 0, 0, 35, 0},
        },
        Rank              = 5,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_BlackKnight_LeaderMace2]   = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Schwarzer Ritter{cr}{white}",
            en = "{grey}Black Knight{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Smithy",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {6, 100, 0, 0, 0, 50, 0},
            [2] = {0, 15, 0, 0, 0, 10, 0},
        },
        Rank              = 3,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },

    [Entities.CU_BanditLeaderSword1]        = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Banditenkrieger{cr}{white}",
            en = "{grey}Bandit Warrior{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Grobschmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Blacksmith",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {10, 150, 0, 0, 0, 60, 0},
            [2] = {0, 50, 0, 0, 0, 35, 0},
        },
        Rank              = 4,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },
    [Entities.CU_BanditLeaderSword2]        = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Wegelagerer{cr}{white}",
            en = "{grey}Highwayman{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schmiede",
            en = "@color:244,184,0 requires:{white} #Rank#, Smithy",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {6, 100, 0, 0, 0, 50, 0},
            [2] = {0, 15, 0, 0, 0, 10, 0},
        },
        Rank              = 2,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Blacksmith1, Entities.PB_Blacksmith2, Entities.PB_Blacksmith3},
    },

    [Entities.CU_Evil_LeaderBearman1]       = {
        Button            = "Buy_LeaderSword",
        TextNormal        = {
            de = "{grey}Bärenmensch{cr}{white}",
            en = "{grey}Bearman{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 16,
        Costs             = {
            [1] = {10, 90, 0, 110, 0, 30, 0},
            [2] = {0, 30, 0, 50, 0, 10, 0},
        },
        Rank              = 4,
        Allowed           = true,
        RecruiterBuilding = {Entities.PB_Barracks1, Entities.PB_Barracks2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },

    [Entities.PU_LeaderBow1]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Kurzbogenschütze{cr}{white}",
            en = "{grey}Shortbowman{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#",
            en = "@color:244,184,0 requires:{white} #Rank#",
        },
        Soldiers          = 12,
        Costs             = {
            [1] = {2, 90, 0, 60, 0, 0, 0},
            [2] = {0, 10, 0, 10, 0, 0, 0},
        },
        Allowed           = true,
        Rank              = 2,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {},
    },
    [Entities.PU_LeaderBow2]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Langbogenschütze{cr}{white}",
            en = "{grey}Longbowman{cr}{white}",
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
    [Entities.PU_LeaderBow3]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Armbrustschütze{cr}{white}",
            en = "{grey}Crossbowman{cr}{white}",
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
    [Entities.PU_LeaderBow4]                = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Arbaleastschütze{cr}{white}",
            en = "{grey}Heavy Crossbowman{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schießanlage, Sägewerk",
            en = "@color:244,184,0 requires:{white} #Rank#, Archery, Lumber Mill",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {15, 300, 0, 40, 0, 40, 0},
            [2] = {0, 75, 0, 20, 0, 30, 0},
        },
        Allowed           = false,
        Rank              = 5,
        RecruiterBuilding = {Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill2},
    },

    [Entities.PU_LeaderRifle1]              = {
        Button            = "Buy_LeaderRifle",
        TextNormal        = {
            de = "{grey}Leichter Scharfschütze{cr}{white}",
            en = "{grey}Light Sharpshooter{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Büchsenmacher",
            en = "@color:244,184,0 requires:{white} #Rank#, Gunsmith's Shop",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {20, 250, 0, 20, 0, 0, 50},
            [2] = {0, 60, 0, 20, 0, 0, 30},
        },
        Allowed           = true,
        Rank              = 5,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_GunsmithWorkshop1, Entities.PB_GunsmithWorkshop2},
    },
    [Entities.PU_LeaderRifle2]              = {
        Button            = "Buy_LeaderRifle",
        TextNormal        = {
            de = "{grey}Schwerer Scharfschütze{cr}{white}",
            en = "{grey}Heavy Sharpshooter{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Schießanlage, Büchsenmanufaktur",
            en = "@color:244,184,0 requires:{white} #Rank#, Archery, Gun Factory",
        },
        Soldiers          = 6,
        Costs             = {
            [1] = {30, 300, 0, 0, 0, 20, 60},
            [2] = {0, 70, 0, 0, 0, 20, 30},
        },
        Allowed           = true,
        Rank              = 7,
        RecruiterBuilding = {Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_GunsmithWorkshop2},
    },

    [Entities.CU_BanditLeaderBow1]          = {
        Button            = "Buy_LeaderBow",
        TextNormal        = {
            de = "{grey}Banditenbogenschütze{cr}{white}",
            en = "{grey}Outlaw Bowman{cr}{white}",
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
            de = "{grey}Bärenmensch{cr}{white}",
            en = "{grey}Bearman{cr}{white}",
        },
        TextDisabled      = {
            de = "@color:244,184,0 benötigt:{white} #Rank#, Sägemühle",
            en = "@color:244,184,0 requires:{white} #Rank#, Sawmill",
        },
        Soldiers          = 16,
        Costs             = {
            [1] = {2, 100, 0, 140, 0, 0, 0},
            [2] = {0, 30, 0, 70, 0, 0, 0},
        },
        Allowed           = true,
        Rank              = 3,
        RecruiterBuilding = {Entities.PB_Archery1, Entities.PB_Archery2},
        ProviderBuilding  = {Entities.PB_Sawmill1, Entities.PB_Sawmill2},
    },
};

