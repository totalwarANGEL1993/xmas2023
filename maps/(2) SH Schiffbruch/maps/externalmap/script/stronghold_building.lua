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
        TowerDistance = 1500,

        Headquarters = {
            Health = {3500, 4500, 5500},
            Armor  = {8, 10, 12}
        },

        Monastery = {
            [BlessCategories.Construction] = {
                Text = "Eure Priester leuten die Glocke zum Gebet.",
                Reputation = 6,
                Honor = 0,
            },
            [BlessCategories.Research] = {
                Text = "Eure Priester vergeben die Sünden Eurer Arbeiter.",
                Reputation = 0,
                Honor = 6,
            },
            [BlessCategories.Weapons] = {
                Text = "Eure Priester predigen Bibeltexte zu ihrer Gemeinde.",
                Reputation = 12,
                Honor = 0,
            },
            [BlessCategories.Financial] = {
                Text = "Eure Priester rufen die Siedler auf zur Kollekte.",
                Reputation = 0,
                Honor = 12,
            },
            [BlessCategories.Canonisation] = {
                Text = "Eure Priester sprechen Eure Taten heilig.",
                Reputation = 9,
                Honor = 9,
            },
        },

        TypesToCheckForUpgrade = {
            [Technologies.UP1_Barracks]  = {Entities.PB_Barracks2,},
            [Technologies.UP1_Archery]   = {Entities.PB_Archery2,},
            [Technologies.UP1_Stables]   = {Entities.PB_Stable2,},
            [Technologies.UP1_Monastery] = {Entities.PB_Monastery2, Entities.PB_Monastery3},
            [Technologies.UP2_Monastery] = {Entities.PB_Monastery1, Entities.PB_Monastery3},
            [Technologies.UP1_Market]    = {Entities.PB_Market2},
        },
    },
}

function Stronghold.Building:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    self:CreateBuildingButtonHandlers();
    self:OverrideMonasteryButtons()
    self:OverrideHeadquarterButtons();
    self:OverridePlaceBuildingAction();
    self:OverrideBuildingUpgradeButtonUpdate();
    self:OverrideBuildingUpgradeButtonTooltip();
    self:OverrideManualButtonUpdate();
    self:OverrideSellBuildingAction();
end

function Stronghold.Building:OnSaveGameLoaded()
    for i= 1, table.getn(Score.Player) do
        self:HeadquartersConfigureBuilding(i);
    end
    self:OverrideManualButtonUpdate();
    self:OverrideSellBuildingAction();
end

function Stronghold.Building:CreateBuildingButtonHandlers()
    self.SyncEvents = {
        ChangeTax = 1,
        BuyLord = 2,
        BuySerf = 3,
        BuyUnit = 4,
        BlessSettlers = 5,
    };

    self.NetworkCall = Stronghold.Sync:CreateSyncEvent(
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
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Headquarters

function Stronghold.Building:HeadquartersConfigureBuilding(_PlayerID)
    if Stronghold:IsPlayer(_PlayerID) then
        local ID = GetID(Stronghold.Players[_PlayerID].HQScriptName);
        if ID > 0 then
            local Index = 1;
            if Logic.GetEntityType(ID) == Entities.PB_Headquarters2 then
                Index = 2;
            end
            if Logic.GetEntityType(ID) == Entities.PB_Headquarters3 then
                Index = 3;
            end
            CEntity.SetArmor(ID, self.Config.Headquarters.Armor[Index]);
            CEntity.SetMaxHealth(ID, self.Config.Headquarters.Health[Index]);
            Logic.HealEntity(ID, self.Config.Headquarters.Health[Index]);
        end
    end
end

function Stronghold.Building:HeadquartersButtonChangeTax(_PlayerID, _Level)
    if Stronghold:IsPlayer(_PlayerID) then
        Stronghold.Players[_PlayerID].TaxHeight = math.min(math.max(_Level +1, 0), 5);
    end
end

function Stronghold.Building:OverrideHeadquarterButtons()
    GUIAction_SetTaxes_Orig_StrongholdBuilding = GUIAction_SetTaxes;
    GUIAction_SetTaxes = function(_Level)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Building.Data[PlayerID] then
            return GUIAction_SetTaxes_Orig_StrongholdBuilding(_Level);
        end
        Stronghold.Sync:Call(
            Stronghold.Building.NetworkCall,
            PlayerID,
            Stronghold.Building.SyncEvents.ChangeTax,
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

    GUIAction_BuySerf_Orig_StrongholdBuilding = GUIAction_BuySerf;
    GUIAction_BuySerf = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return GUIAction_BuySerf_Orig_StrongholdBuilding();
        end
        if Stronghold.Players[PlayerID].BuyUnitLock then
            return;
        end

        local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_Serf);
        if not HasPlayerEnoughResourcesFeedback(Config.Costs) then
            return;
        end
        if Logic.GetPlayerAttractionUsage(PlayerID) >= Logic.GetPlayerAttractionLimit(PlayerID) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesSerf_SERF_No_rnd_01, 127);
            Message("Ihr habt keinen Platz für weitere Leibeigene!");
            return;
        end

        Stronghold.Players[PlayerID].BuyUnitLock = true;
        Stronghold.Sync:Call(
            Stronghold.Building.NetworkCall,
            PlayerID,
            Stronghold.Building.SyncEvents.BuySerf,
            GetID(Stronghold.Players[PlayerID].HQScriptName),
            Entities.PU_Serf,
            false
        );
    end

    GUIAction_CallMilitia = function()
        local PlayerID = GUI.GetPlayerID();
        Stronghold.Hero:OpenBuyHeroWindowForLordSelection(PlayerID);
    end

    GUIAction_BackToWork = function()
    end
end

function Stronghold.Building:OnHeadquarterSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
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
        XGUIEng.ShowWidget("HQ_CallMilitia", 0);
        XGUIEng.ShowWidget("HQ_BackToWork", 0);
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
            Text = "@color:180,180,180 Laird wählen @color:255,255,255 "..
                   "@cr Wählt euren Laird aus. Jeder Laird verfügt über "..
                   "starke Fähigkeiten.";
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
-- Soft Tower Limit

-- Check tower placement (Community Server)
-- Prevents towers from being placed if another tower of the same player is
-- to close. Type of tower does not matter.
-- This function is the one to be called!
function Stronghold.Building:StartCheckTowerDistanceCallback()
    if not GameCallback_PlaceBuildingAdditionalCheck then
        return false;
    end
    self.Orig_GameCallback_PlaceBuildingAdditionalCheck = GameCallback_PlaceBuildingAdditionalCheck;
    GameCallback_PlaceBuildingAdditionalCheck = function(_ucat, _x, _y, _rotation, _isBuildOn)
        local PlayerID = GUI.GetPlayerID();
        local Allowed = Stronghold.Building.Orig_GameCallback_PlaceBuildingAdditionalCheck(_ucat, _x, _y, _rotation, _isBuildOn);
        if Stronghold:IsPlayer(PlayerID) then
            if Allowed and _ucat == EntityCategories.Tower then
                local AreaSize = self.Config.TowerDistance;
                if self:AreTowersOfPlayerInArea(PlayerID, _x, _y, AreaSize) then
                    Allowed = false;
                end
            end
        end
        return Allowed;
    end
    return true;
end

-- Check tower placement (Vanilla)
-- Prevents towers from being placed if another tower of the same player is
-- to close. Type of tower does not matter.
-- Does overwrite place building and find view but only if the initalization
-- for the community server variant previously failed.
function Stronghold.Building:OverridePlaceBuildingAction()
    if self:StartCheckTowerDistanceCallback() then
        return;
    end

    self.Orig_GUIAction_PlaceBuilding = GUIAction_PlaceBuilding;
    GUIAction_PlaceBuilding = function(_UpgradeCategory)
        Stronghold.Building.Orig_GUIAction_PlaceBuilding(_UpgradeCategory);
        local PlayerID = GUI.GetPlayerID();
        if Stronghold:IsPlayer(PlayerID) then
            Stronghold.Building.Data[PlayerID].LastPlacedUpgradeCategory = _UpgradeCategory;
        end
    end

    self.Orig_GUIUpdate_FindView = GUIUpdate_FindView;
    GUIUpdate_FindView = function()
        Stronghold.Building.Orig_GUIUpdate_FindView();
        local PlayerID = GUI.GetPlayerID();
        if Stronghold:IsPlayer(PlayerID) then
            Stronghold.Building:CancelBuildingPlacementForUpgradeCategory(
                PlayerID,
                Stronghold.Building.Data[PlayerID].LastPlacedUpgradeCategory
            );
        end
	end
end

function Stronghold.Building:CancelBuildingPlacementForUpgradeCategory(_PlayerID, _UpgradeCategory)
    local StateID = GUI.GetCurrentStateID();
    if StateID == gvGUI_StateID.PlaceBuilding then
        if _UpgradeCategory == UpgradeCategories.Tower then
            AreaSize = self.Config.TowerDistance;
            local x, y = GUI.Debug_GetMapPositionUnderMouse();
            if self:AreTowersOfPlayerInArea(_PlayerID, x, y, AreaSize) then
                Message("Ihr könnt Türme nicht so na aneinander bauen!");
                Sound.PlayQueuedFeedbackSound(Sounds.VoicesSerf_SERF_No_rnd_01, 127);
                self.Data[_PlayerID].LastPlacedUpgradeCategory = nil;
                GUI.CancelState();
            end
        end
    end
end

function Stronghold.Building:AreTowersOfPlayerInArea(_PlayerID, _X, _Y, _AreaSize)
    local DarkTower1 = {Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.PB_DarkTower1, _X, _Y, _AreaSize, 1)};
    local DarkTower2 = {Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.PB_DarkTower2, _X, _Y, _AreaSize, 1)};
    local DarkTower3 = {Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.PB_DarkTower3, _X, _Y, _AreaSize, 1)};
    local Tower1 = {Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.PB_Tower1, _X, _Y, _AreaSize, 1)};
    local Tower2 = {Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.PB_Tower2, _X, _Y, _AreaSize, 1)};
    local Tower3 = {Logic.GetPlayerEntitiesInArea(_PlayerID, Entities.PB_Tower3, _X, _Y, _AreaSize, 1)};
    return Tower1[1] + Tower2[1] + Tower3[1] + DarkTower1[1] + DarkTower2[1] + DarkTower3[1] > 0;
end

-- -------------------------------------------------------------------------- --
-- Barracks

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountBarracks(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if Stronghold:IsPlayer(_PlayerID) and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:OnBarracksSettlerUpgradeTechnologyClicked(_Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return false;
    end

    local Places = 0;
    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeSword1 then
        UnitType = Entities.PU_LeaderPoleArm1;
        Places = (AutoFillActive and 5) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword2 then
        UnitType = Entities.PU_LeaderPoleArm3;
        Places = (AutoFillActive and 5) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword3 then
        UnitType = Entities.PU_LeaderSword3;
        Places = (AutoFillActive and 9) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeSword4 then
        UnitType = Entities.PU_LeaderSword4;
        Places = (AutoFillActive and 9) or 1;
        Action = self.SyncEvents.BuyUnit;
    end

    if Action > 0 then
        if not Stronghold:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end

        local Config = Stronghold.Unit:GetUnitConfig(UnitType);
        local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Stronghold.Sync:Call(
                Stronghold.Building.NetworkCall,
                PlayerID, Action, EntityID, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnBarracksSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
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
    XGUIEng.ShowWidget("Research_UpgradeSword3", 1);
    XGUIEng.ShowWidget("Research_UpgradeSpear1", 1);
    XGUIEng.ShowWidget("Research_UpgradeSpear2", 0);
    XGUIEng.ShowWidget("Research_UpgradeSpear3", 0);

    local Blacksmith1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Blacksmith1));
    local Blacksmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith2);
    local Blacksmith3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith3);

    local Sawmill1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Sawmill1));
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
    or Sawmill1 + Sawmill2 == 0 then
        LancerDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword2", LancerDisabled);

    -- Longsword
    local SwordDisabled = 0;
    local SwordConfig = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderSword3);
    if SwordConfig.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < SwordConfig.Rank
    or Type ~= Entities.PB_Barracks2
    or Blacksmith1 + Blacksmith2 + Blacksmith3 == 0 then
        SwordDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeSword3", SwordDisabled);

    -- Bastards
    local SwordDisabled = 0;
    local BastardConfig = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderSword4);
    if BastardConfig.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < BastardConfig.Rank
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
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Speerträger @color:255,255,255 "..
               "@cr Ihr Götter, welch Memmen befehlen unsere Schar? Zum "..
               "Krieg zusammengekehrt, das Gerümpel des Landes.";

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 5; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
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

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " ..Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Sägemühle"
        end

    elseif _TextKey == "MenuBarracks/UpgradeSword3" then
        local Type = Entities.PU_LeaderSword3;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Langschwertkämpfer @color:255,255,255 "..
               "@cr Schwer gepanzerte Berufssoldaten, die für Euch über jede "..
               " Klinge springen.";

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Garnison, Schmiede";
        end

    elseif _TextKey == "MenuBarracks/UpgradeSpear1" then
        local Type = Entities.PU_LeaderSword4;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Bastardschwertkämpfer @color:255,255,255 "..
               "@cr Die schwerste Infanterie, die Ihr in die Schlacht werfen "..
               "könnt. Diese Männer fürchten weder Tod noch Teufel.";

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Garnison, Feinschmiede";
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
    if Stronghold:IsPlayer(_PlayerID) and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Archery2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:OnArcherySettlerUpgradeTechnologyClicked(_Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return false;
    end

    local Places = 1;
    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeBow1 then
        UnitType = Entities.PU_LeaderBow2;
        Places = (AutoFillActive and 5) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeBow2 then
        UnitType = Entities.PU_LeaderBow3;
        Places = (AutoFillActive and 5) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeBow3 then
        UnitType = Entities.PU_LeaderRifle1;
        Places = (AutoFillActive and 5) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeRifle1 then
        UnitType = Entities.PU_LeaderRifle2;
        Places = (AutoFillActive and 5) or 1;
        Action = self.SyncEvents.BuyUnit;
    end

    if Action > 0 then
        if not Stronghold:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end

        local Config = Stronghold.Unit:GetUnitConfig(UnitType);
        local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Stronghold.Sync:Call(
                Stronghold.Building.NetworkCall,
                PlayerID, Action, EntityID, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnArcherySelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
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

    local Gunsmith1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_GunsmithWorkshop1));
    local Gunsmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_GunsmithWorkshop2);

    local Sawmill1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Sawmill1));
    local Sawmill2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Sawmill2);

    -- Bowmen
    local BowDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderBow2);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Sawmill1 + Sawmill2 == 0 then
        BowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow1", BowDisabled);

    -- Crossbow
    local CrossbowDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderBow3);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank
    or Sawmill1 + Sawmill2 == 0 then
        CrossbowDisabled = 1;
    end
    XGUIEng.DisableButton("Research_UpgradeBow2", CrossbowDisabled);

    -- Rifle
    local RifleDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderRifle2);
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
    local Text = "";

    if _TextKey == "MenuArchery/UpgradeBow1" then
        local Type = Entities.PU_LeaderBow2;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Langbogenschützen @color:255,255,255 "..
               "@cr Diese Männer sind vor allem gegen Speerträger und Reiter "..
               "sehr effektiv.";

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 5; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Sägemühle";
        end

    elseif _TextKey == "MenuArchery/UpgradeBow2" then
        local Type = Entities.PU_LeaderBow3;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Armbrustschützen @color:255,255,255 "..
               "@cr Loyale und gut ausgebiltete Schützen. Sie werden Euer "..
               "Heer  hervorragend ergänzen.";

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. ", Schießanlage, Sägemühle";
        end

    elseif _TextKey == "MenuArchery/UpgradeBow3" then
        local Type = Entities.PU_LeaderRifle1;
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Text = "@color:180,180,180 Leichte Scharfschützen @color:255,255,255 "..
               "@cr Diese Männer nutzen die neuen Feuerwaffen. Sie sind stark"..
               " gegen gepanzerte Einheiten.";

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 5; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
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

        -- Costs text
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 9; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
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
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Tavern

function Stronghold.Building:OnTavernBuyUnitClicked(_UpgradeCategory)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return false;
    end

    local UnitType = 0;
    local Action = 0;
    if _UpgradeCategory == UpgradeCategories.Scout then
        UnitType = Entities.PU_Scout;
        Action = self.SyncEvents.BuyUnit;
    elseif _UpgradeCategory == UpgradeCategories.Thief then
        if Logic.GetPlayerAttractionLimit(PlayerID) >= Logic.GetPlayerAttractionUsage(PlayerID) +5 then
            UnitType = Entities.PU_Thief;
            Action = self.SyncEvents.BuyUnit;
        end
    end

    if Action > 0 then
        local Config = Stronghold.Unit:GetUnitConfig(UnitType);
        local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Stronghold.Sync:Call(
                Stronghold.Building.NetworkCall,
                PlayerID, Action, EntityID, UnitType, false
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnTavernSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
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
    local EntityID = GUI.GetSelectedEntity();
    local CostsText = "";
    local Text = "";

    if _KeyNormal == "MenuTavern/BuyScout_normal" then
        local Type = Entities.PU_Scout;
        Text = "@color:180,180,180 Kundschafter @color:255,255,255 "..
               "@cr Kundschafter erkunden die Umgebung und finden Rohstoffe.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Costs = Stronghold:CreateCostTable(unpack(CopyTable(Config.Costs)));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

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
               "@cr Kundschafter erkunden die Umgebung und finden Rohstoffe.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        Costs = Stronghold:CreateCostTable(unpack(CopyTable(Config.Costs)));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

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
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Stable

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountStable(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if Stronghold:IsPlayer(_PlayerID) and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Stable2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:OnStableSettlerUpgradeTechnologyClicked(_Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    local AutoFillActive = Logic.IsAutoFillActive(EntityID) == 1;
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return false;
    end

    local Places = 0;
    local UnitType = 0;
    local Action = 0;
    if _Technology == Technologies.T_UpgradeLightCavalry1 then
        UnitType = Entities.PU_LeaderCavalry2;
        Places = (AutoFillActive and 4) or 1;
        Action = self.SyncEvents.BuyUnit;
    elseif _Technology == Technologies.T_UpgradeHeavyCavalry1 then
        UnitType = Entities.PU_LeaderHeavyCavalry1;
        Places = (AutoFillActive and 4) or 1;
        Action = self.SyncEvents.BuyUnit;
    end

    if Action > 0 then
        if not Stronghold:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end

        local Config = Stronghold.Unit:GetUnitConfig(UnitType);
        local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(PlayerID, Costs);
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Stronghold.Sync:Call(
                Stronghold.Building.NetworkCall,
                PlayerID, Action, EntityID, UnitType, AutoFillActive
            );
        end
        return true;
    end
    return false;
end

function Stronghold.Building:OnStableSelected(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
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

    local Blacksmith1 = table.getn(GetCompletedEntitiesOfType(PlayerID, Entities.PB_Blacksmith1));
    local Blacksmith2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith2);
    local Blacksmith3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Blacksmith3);

    -- Bowmen
    local BowDisabled = 0;
    local Config = Stronghold.Unit:GetUnitConfig(Entities.PU_LeaderCavalry2);
    if Config.Allowed == false
    or Stronghold:GetPlayerRank(PlayerID) < Config.Rank then
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
    local Text = "";

    if _TextKey == "MenuStables/UpgradeCavalryLight1" then
        local Type = Entities.PU_LeaderCavalry2;
        Text = "@color:180,180,180 Berittene Armbrustschützen @color:255,255,255 "..
               "@cr Der Vorteil der berittenen Armbrustschützen ist ihre hohe "..
               "Flexibelität und Geschwindigkeit.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 4; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. "";
        end

    elseif _TextKey == "MenuStables/UpgradeCavalryHeavy1" then
        local Type = Entities.PU_LeaderHeavyCavalry1;
        Text = "@color:180,180,180 Berittene Streitaxtkämpfer @color:255,255,255 "..
               "@cr Treue Ritter, die jeden Gegner gnadenlos niedermähen, der "..
               "es wagt, sich Euch entgegenzustallen.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = CopyTable(Config.Costs);
        if Logic.IsAutoFillActive(EntityID) == 1 then
            for i= 2, 7 do Costs[i] = Costs[i] * 4; end
        end
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
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
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

-- -------------------------------------------------------------------------- --
-- Foundry

-- This function is called for each unit type individually.
function Stronghold.Building:ApplyUpkeepDiscountFoundry(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if Stronghold:IsPlayer(_PlayerID) and Upkeep > 0 then
        local Barracks = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Foundry2);
        if Barracks > 0 then
            Upkeep = Upkeep * 0.85;
        end
    end
    return Upkeep;
end

function Stronghold.Building:OnFoundryBuyUnitClicked(_Type, _UpgradeCategory)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    if PlayerID ~= GUI.GetPlayerID() or not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if Stronghold.Players[PlayerID].BuyUnitLock then
        return false;
    end

    local Places = 0;
    local UnitType = 0;
    local Action = 0;
    if _Type == Entities.PV_Cannon1 then
        UnitType = _Type;
        Places = 5;
        Action = self.SyncEvents.BuyUnit;
    elseif _Type == Entities.PV_Cannon2 then
        UnitType = _Type;
        Places = 10;
        Action = self.SyncEvents.BuyUnit;
    elseif _Type == Entities.PV_Cannon3 then
        UnitType = _Type;
        Places = 15;
        Action = self.SyncEvents.BuyUnit;
    elseif _Type == Entities.PV_Cannon4 then
        UnitType = _Type;
        Places = 15;
        Action = self.SyncEvents.BuyUnit;
    end

    if Action > 0 then
        if not Stronghold:HasPlayerSpaceForUnits(PlayerID, Places) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return true;
        end

        local Config = Stronghold.Unit:GetUnitConfig(UnitType);
        local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
        if HasPlayerEnoughResourcesFeedback(Costs) then
            Stronghold.Players[PlayerID].BuyUnitLock = true;
            Stronghold.Sync:Call(
                Stronghold.Building.NetworkCall,
                PlayerID, Action, EntityID, UnitType, false
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
    local EntityID = GUI.GetSelectedEntity();
    local CostsText = "";
    local Text = "";

    if _KeyNormal == "MenuFoundry/BuyCannon1_normal" then
        local Type = Entities.PV_Cannon1;
        Text = "@color:180,180,180 Bombarde @color:255,255,255 @cr "..
               "Die kleinste Kanone. Sie wird gegen Soldaten verwendet, ist "..
               "aber nicht nennenswert effektiv.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = CopyTable(Config.Costs);
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

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
        local Costs = CopyTable(Config.Costs);
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

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
        local Costs = CopyTable(Config.Costs);
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. "";
        end

    elseif _KeyNormal == "MenuFoundry/BuyCannon4_normal" then
        local Type = Entities.PV_Cannon4;
        Text = "@color:180,180,180 Belagerungskanone @color:255,255,255 @cr "..
               "Eine schwere Kanone deren Aufgabe es ist Befestigungen zu "..
               " zerstören.";

        -- Costs text
        local Config = Stronghold.Unit:GetUnitConfig(Type);
        local Costs = CopyTable(Config.Costs);
        Costs = Stronghold:CreateCostTable(unpack(Costs));
        CostsText = Stronghold:FormatCostString(_PlayerID, Costs);

        -- Disabled text
        if not Config.Allowed then
            Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        elseif XGUIEng.IsButtonDisabled(WidgetID) == 1 then
            Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                   " " .. Stronghold:GetPlayerRankName(_PlayerID, Config.Rank).. "";
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

function Stronghold.Building:OverrideMonasteryButtons()
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
            Stronghold.Sync:Call(
                Stronghold.Building.NetworkCall,
                PlayerID,
                Stronghold.Building.SyncEvents.BlessSettlers,
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

-- -------------------------------------------------------------------------- --
-- Upgrade Button

function Stronghold.Building:OverrideBuildingUpgradeButtonTooltip()
    -- Don't let EMS fuck with my script...
    if EMS then
        function EMS.RD.Rules.Markets:Evaluate(self) end
    end

    self.GUITooltip_UpgradeBuilding = GUITooltip_UpgradeBuilding;
    GUITooltip_UpgradeBuilding = function(_Type, _KeyDisabled, _KeyNormal, _Technology)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return self.GUITooltip_UpgradeBuilding(_Type, _KeyDisabled, _KeyNormal, _Technology);
        end
        local IsForbidden = false;

        -- Get default text
        local Text = XGUIEng.GetStringTableText(_KeyNormal);
        local LineBreakPos, LineBreakEnd = string.find(Text, " @cr ");
        local TextHeadline = string.sub(Text, 1, LineBreakPos);
        local TextBody = string.sub(Text, LineBreakEnd +1);

        local CostString = "";
        local ShortCutToolTip = "";
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = XGUIEng.GetStringTableText(_KeyDisabled);
            if _Technology and Logic.GetTechnologyState(PlayerID, _Technology) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
                IsForbidden = true;
            end
        else
            Logic.FillBuildingUpgradeCostsTable(_Type, InterfaceGlobals.CostTable);
            CostString = InterfaceTool_CreateCostString(InterfaceGlobals.CostTable);
            ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name")..
                ": [" .. XGUIEng.GetStringTableText("KeyBindings/UpgradeBuilding") .. "]";
        end

        local EffectText = "";
        if not IsForbidden then
            -- Text amendments
            if Logic.GetUpgradeCategoryByBuildingType(_Type) == UpgradeCategories.Farm then
                Text = Text .. " Das bessere Essen wird Euch zu Ehre gereichen.";
            end
            if Logic.GetUpgradeCategoryByBuildingType(_Type) == UpgradeCategories.Residence then
                Text = Text .. " Die bessere Unterbringung steigert Eure Beliebtheit.";
            end

            -- Effect text
            local Effects = Stronghold.Economy.Config.Income.Buildings[_Type +1];
            if Effects then
                if Effects.Reputation > 0 then
                    EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
                end
                if Effects.Honor > 0 then
                    EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
                end
                if EffectText ~= "" then
                    EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 " ..EffectText;
                end
            end

            -- Building limit
            local BuildingMax = GetLimitOfType(_Type +1);
            if BuildingMax > -1 then
                local BuildingCount = GetUsageOfType(PlayerID, _Type +1);
                Text = TextHeadline.. " (" ..BuildingCount.. "/" ..BuildingMax.. ") @cr " .. TextBody;
            end
            Text = Text .. EffectText;
        end

        -- Set text
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip);
    end
end

function Stronghold.Building:OverrideBuildingUpgradeButtonUpdate()
    self.Orig_GUIUpdate_UpgradeButtons = GUIUpdate_UpgradeButtons;
    GUIUpdate_UpgradeButtons = function(_Button, _Technology)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Building.Data[PlayerID] then
            return self.Orig_GUIUpdate_UpgradeButtons(_Button, _Technology);
        end
        local LimitReached = false;
        local CheckList = Stronghold.Building.Config.TypesToCheckForUpgrade[_Technology] or {};

        local Type = Logic.GetEntityType(GUI.GetSelectedEntity());
        local Limit = GetLimitOfType(Type);
        local Usage = 0;
        if Limit > -1 then
            for i= 1, table.getn(CheckList) do
                Usage = Usage + GetUsageOfType(PlayerID, CheckList[i]);
            end
            LimitReached = Limit <= Usage;
        end

        if LimitReached then
            XGUIEng.DisableButton(_Button, 1);
            return true;
        end
        self.Orig_GUIUpdate_UpgradeButtons(_Button, _Technology);
        return false;
    end
end

-- -------------------------------------------------------------------------- --
-- UI Stuff

-- HACK: Prevent nasty update when toggle groups is used.
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

-- HACK: Deselect building on demolition to prevent click spamming.
function Stronghold.Building:OverrideSellBuildingAction()
    self.Orig_GUI_SellBuilding = GUI.SellBuilding;
    GUI.SellBuilding = function(_EntityID)
        GUI.DeselectEntity(_EntityID);
        self.Orig_GUI_SellBuilding(_EntityID);
    end
end

