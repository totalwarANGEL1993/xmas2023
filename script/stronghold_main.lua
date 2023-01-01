---
--- Main Script
---
--- This script runs all jobs and calls all scripts.
---

Stronghold = {
    Shared = {},
    Players = {},
    Outposts = {},
    Config = {
        AttractionLimit = {[1] = 100, [2] = 200, [3] = 300},
        OutpostAttraction = 25,
    },

    Text = {
        Ranks = {
            [1] = "Edelmann",
            [2] = "Ritter",
            [3] = "Edler Ritter",
            [4] = "Reichsritter",
            [5] = "Streiter des Königs",
            [6] = "Fürst",
            [7] = "Baron",
            [8] = "Graf",
            [9] = "Herzog",
        }
    },
}

function Stronghold:Init()
    GUI.ClearSelection();
    ResourceType.Honor = 20;

    self:InitTradeBalancer();
    self:StartPlayerValuesUpdater();
    self:StartPlayerPaydayUpdater();

    self:OverrideAttraction();
    self:OverridePaydayClockTooltip();
    self:OverrideTaxAndPayStatistics();
    self:OverrideFindViewUpdate();
    self:OverrideTooltipGenericMain();
    self:OverrideTooltipConstructionMain();
    self:OverwriteCommonCallbacks();

    self:CreateHeadquartersButtonHandlers();
    self:OverrideBuyHeroWindow();
    self:OverrdeHeadquarterButtons();
end

function Stronghold:OnSaveGameLoaded()
    ResourceType.Honor = 20;
    self:OverrideAttraction();
    for k,v in pairs(self.Players) do
        self:BuyHeroConfigureLord(k);
        self:BuyHeroConfigureSpouse(k);
    end
end

function Stronghold:AddPlayer(_PlayerID)
    local LordName = "LordP" .._PlayerID;
    local SpouseName = "SpouseP" .._PlayerID;
    local HQName = "HQ" .._PlayerID;
    local DoorPosName = "DoorP" .._PlayerID;
    local CampPosName = "CampP" .._PlayerID;

    -- Create door pos
    local DoorPos = GetCirclePosition(HQName, 800, 180);
    local ID = Logic.CreateEntity(Entities.XD_ScriptEntity, DoorPos.X, DoorPos.Y, 0, 0);
    Logic.SetEntityName(ID, DoorPosName);

    -- Create camp Pos
    local CampPos = GetCirclePosition(HQName, 1200, 180);
    ID = Logic.CreateEntity(Entities.XD_LargeCampFire, CampPos.X, CampPos.Y, 0, 0);
    Logic.SetEntityName(ID, CampPosName);
    ID = AI.Entity_CreateFormation(8, Entities.PU_Serf, nil, 0, CampPos.X, CampPos.Y, 0, 0, 0, 0);
    local x,y,z = Logic.EntityGetPos(ID);
    CampPos.X = x; CampPos.Y = y; CampPos.Z = z;
    DestroyEntity(ID);

    -- Create dummy lord
    local LordOrientation = Logic.GetEntityOrientation(GetID(HQName)) -180;
    ID = Logic.CreateEntity(Entities.PU_Hero1, DoorPos.X, DoorPos.Y, LordOrientation, _PlayerID);
    Logic.SetEntitySelectableFlag(ID, 0);
    Logic.SetEntityName(ID, LordName);
    self:BuyHeroConfigureLord(_PlayerID);

    -- Create serfs
    for i= 1, 6 do
        local SerfPos = GetCirclePosition(CampPosName, 250, 60 * i);
        ID = Logic.CreateEntity(Entities.PU_Serf, SerfPos.X, SerfPos.Y, 360 - (60 * i), _PlayerID);
        LookAt(ID, CampPosName);
    end

    -- Deactivate normal upkeep
    Logic.SetPlayerPaysLeaderFlag(_PlayerID, 0);

    -- Create player data
    self.Players[_PlayerID] = {
        LordScriptName = LordName,
        SpouseScriptName = SpouseName,
        HQScriptName = HQName,
        DoorPos = DoorPos;
        CampPos = CampPos;

        IncomeMoney = 0,
        UpkeepDetails = {},
        UpkeepMoney = 0,

        Reputation = 100,
        ReputationLimit = 200,
        IncomeReputation = 0,

        Honor = 0,
        IncomeHonor = 0,

        TaxHeight = 3,
        Rank = 1,
    };
end

-- -------------------------------------------------------------------------- --
-- Defeat Condition

function Stronghold:PlayerDefeatCondition(_PlayerID)
    if not self.Players[_PlayerID] then
        return;
    end

    -- Invulnerable HQ
    if IsExisting(self.Players[_PlayerID].HQScriptName) then
        MakeInvulnerable(self.Players[_PlayerID].HQScriptName);
    end
    -- Check health of the lord
    if IsExisting(self.Players[_PlayerID].LordScriptName) then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        if Logic.PlayerGetGameState(_PlayerID) == 1 then
            if Logic.GetEntityHealth(LordID) == 0 then
                Logic.PlayerSetGameStateToLost(_PlayerID);
            end
        end
    end
end

-- TODO: Self Destruct?

-- -------------------------------------------------------------------------- --
-- Update Values

function Stronghold:StartPlayerValuesUpdater()
    function Stronghold_Trigger_UpdateIncomeAndUpkeep()
        local PlayerID = math.mod(math.floor(Logic.GetTime() * 10), 10);
        if PlayerID > 0 and PlayerID < 9 then
            Stronghold:PlayerDefeatCondition(PlayerID);
            Stronghold:CreateWorkersForPlayer(PlayerID);
            Stronghold:UpdateIncomeAndUpkeep(PlayerID);
            Stronghold:EnergyProductionBonus(PlayerID);
            Stronghold:FaithProductionBonus(PlayerID);
        end
    end
    StartSimpleHiResJob("Stronghold_Trigger_UpdateIncomeAndUpkeep");
end

-- -------------------------------------------------------------------------- --
-- Workers

function Stronghold:CreateWorkersForPlayer(_PlayerID)
    if self.Players[_PlayerID] then
        local DoCreate = true;
        local LeaveMotivation = Logic.GetLogicPropertiesMotivationThresholdLeave();
        if Logic.GetAverageMotivation(_PlayerID) > LeaveMotivation then
            if Logic.GetPlayerAttractionUsage(_PlayerID) < Logic.GetPlayerAttractionLimit(_PlayerID) then
                local Index = self.Players[_PlayerID].LastBuildingWorkerCreatedIndex or 1;
                local Buildings = self:GetAllWorkplaces(_PlayerID);
                if Buildings[Index] then
                    if DoCreate then
                        local PlacesLimit = Logic.GetBuildingWorkPlaceLimit(Buildings[Index]);
                        local PlacesUsed = Logic.GetBuildingWorkPlaceUsage(Buildings[Index]);
                        if PlacesUsed < PlacesLimit then
                            local Type = Logic.GetWorkerTypeByBuilding(Buildings[Index]);
                            CreateEntity(1, Type, self.Players[_PlayerID].DoorPos);
                            DoCreate = false;
                        end
                    end
                    self.Players[_PlayerID].LastBuildingWorkerCreatedIndex = Index +1;
                else
                    self.Players[_PlayerID].LastBuildingWorkerCreatedIndex = nil;
                end
            end
        end
    end
end

function Stronghold:OverrideAttraction()
    GetPlayerAttractionLimit_Orig_StrongholdEco = Logic.GetPlayerAttractionLimit
	Logic.GetPlayerAttractionLimit = function(_PlayerID)
		if not Stronghold.Players[_PlayerID] then
            return GetPlayerAttractionUsage_Orig_StrongholdEco(_PlayerID);
        end

        -- Attraction limit
        local AttractionLimit = Stronghold.Config.AttractionLimit[1];
        local CastleT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters2);
        if CastleT2 > 0 then
            AttractionLimit = Stronghold.Config.AttractionLimit[2];
        end
        local CastleT3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters3);
        if CastleT3 > 0 then
            AttractionLimit = Stronghold.Config.AttractionLimit[3];
        end
        -- Outposts bonus
        local Outposts = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.CB_Bastille1);
        if Outposts > 0 then
            local OutpostAttraction = Stronghold.Config.OutpostAttraction;
            AttractionLimit = AttractionLimit + (Outposts * OutpostAttraction);
        end
        -- Lord bonus
        AttractionLimit = Stronghold:ApplyMaxAttractionPassiveAbility(_PlayerID, AttractionLimit);

        return AttractionLimit;
	end

	GetPlayerAttractionUsage_Orig_StrongholdEco = Logic.GetPlayerAttractionUsage
	Logic.GetPlayerAttractionUsage = function(_PlayerID)
		if not Stronghold.Players[_PlayerID] then
            return GetPlayerAttractionUsage_Orig_StrongholdEco(_PlayerID);
        end
        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local SerfCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Serf);
        local ScoutCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Scout);
        local ThiefCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Thief);
        return WorkerCount + SerfCount + ScoutCount + (ThiefCount *5);
	end
end

-- -------------------------------------------------------------------------- --
-- Payday

function Stronghold:StartPlayerPaydayUpdater()
    -- In multiplayer
    if GameCallback_PaydayPayed then
        GameCallback_PaydayPayed = function(_player, _amount)
            Stronghold.OnPlayerPayday(_player);
            return 0;
        end
        return;
    end

    -- In singleplayer
    function Stronghold_Trigger_OnPayday()
        Stronghold.Shared.PaydayTriggerFlag = Stronghold.Shared.PaydayTriggerFlag or {};
        Stronghold.Shared.PaydayOverFlag = Stronghold.Shared.PaydayOverFlag or {};

        for i= 1, 8, 1 do
            if Stronghold.Shared.PaydayTriggerFlag[i] == nil then
                Stronghold.Shared.PaydayTriggerFlag[i] = false;
            end
            if Stronghold.Shared.PaydayOverFlag[i] == nil then
                Stronghold.Shared.PaydayOverFlag[i] = false;
            end

            if Logic.GetPlayerPaydayTimeLeft(i) > 119800 then
                Stronghold.Shared.PaydayTriggerFlag[i] = true;
            elseif Logic.GetPlayerPaydayTimeLeft(i) > 119600 then
                Stronghold.Shared.PaydayTriggerFlag[i] = false;
                Stronghold.Shared.PaydayOverFlag[i] = false;
            end
            if Stronghold.Shared.PaydayTriggerFlag[i] and not Stronghold.Shared.PaydayOverFlag[i] then
                Stronghold:OnPlayerPayday(i, true);
                Stronghold.Shared.PaydayOverFlag[i] = true;
            end
        end
    end
    StartSimpleHiResJob("Stronghold_Trigger_OnPayday");
end

function Stronghold:OnPlayerPayday(_PlayerID, _FixGold)
    if self.Players[_PlayerID] then
        -- Fix money for payday (only singleplayr)
        if _FixGold then
            local TaxAmount = Logic.GetPlayerPaydayCost(_PlayerID);
            if TaxAmount > 0 then
                AddGold(_PlayerID, -1 * TaxAmount);
            end
        end
        Tools.GiveResouces(_PlayerID, self.Players[_PlayerID].IncomeMoney, 0, 0, 0, 0, 0);
        AddGold(_PlayerID, -self.Players[_PlayerID].UpkeepMoney);

        -- Reputation
        local OldReputation = self:GetPlayerReputation(_PlayerID);
        local Reputation = self.Players[_PlayerID].IncomeReputation;
        self:UpdateMotivationOfWorkers(_PlayerID, OldReputation + Reputation);
        self.Players[_PlayerID].Reputation = OldReputation + Reputation;
        if self.Players[_PlayerID].Reputation > self.Players[_PlayerID].ReputationLimit then
            self.Players[_PlayerID].Reputation = self.Players[_PlayerID].ReputationLimit;
        end
        if self.Players[_PlayerID].Reputation < 0 then
            self.Players[_PlayerID].Reputation = 0;
        end

        -- Honor
        local Honor = self.Players[_PlayerID].IncomeHonor;
        self:AddPlayerHonor(_PlayerID, Honor);

        if GameCallback_Stronghold_OnPayday then
            GameCallback_Stronghold_OnPayday(_PlayerID);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Honor

function Stronghold:AddPlayerHonor(_PlayerID, _Amount)
    if self.Players[_PlayerID] then
        self.Players[_PlayerID].Honor = self.Players[_PlayerID].Honor + _Amount;
        if self.Players[_PlayerID].Honor < 0 then
            self.Players[_PlayerID].Honor = 0;
        end
    end
end

function Stronghold:GetPlayerHonor(_PlayerID)
    if self.Players[_PlayerID] then
        return self.Players[_PlayerID].Honor;
    end
    return 0;
end

-- -------------------------------------------------------------------------- --
-- Reputation

function Stronghold:AddPlayerReputation(_PlayerID, _Amount)
    if self.Players[_PlayerID] then
        local Reputation = self:GetPlayerReputation(_PlayerID);
        self:SetPlayerReputation(_PlayerID, Reputation + _Amount);
    end
end

function Stronghold:SetPlayerReputation(_PlayerID, _Amount)
    if self.Players[_PlayerID] then
        self.Players[_PlayerID].Reputation = _Amount;
        if self.Players[_PlayerID].Reputation > self.Players[_PlayerID].ReputationLimit then
            self.Players[_PlayerID].Reputation = self.Players[_PlayerID].ReputationLimit;
        end
        if self.Players[_PlayerID].Reputation < 0 then
            self.Players[_PlayerID].Reputation = 0;
        end
    end
end

function Stronghold:SetPlayerReputationLimit(_PlayerID, _Amount)
    if self.Players[_PlayerID] then
        self.Players[_PlayerID].ReputationLimit = _Amount;
    end
end

function Stronghold:GetPlayerReputationLimit(_PlayerID)
    if self.Players[_PlayerID] then
        return self.Players[_PlayerID].ReputationLimit;
    end
    return 200;
end

function Stronghold:GetPlayerReputation(_PlayerID)
    if self.Players[_PlayerID] then
        return self.Players[_PlayerID].Reputation;
    end
    return 100;
end

function Stronghold:UpdateMotivationOfWorkers(_PlayerID, _Amount)
    if self.Players[_PlayerID] then
        if _Amount > 0 and _Amount < self.Players[_PlayerID].ReputationLimit then
            local WorkerList = self:GetAllWorker(_PlayerID);
            for i= 1, table.getn(WorkerList) do
                CEntity.SetMotivation(WorkerList[i], _Amount / 100);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- UI Update

function Stronghold:OnSelectionMenuChanged(_EntityID)
    self:OnHeadquarterSelected(_EntityID);
end

function Stronghold:OverwriteCommonCallbacks()
    GameCallback_GUI_SelectionChanged_Orig_Stronghold = GameCallback_GUI_SelectionChanged;
	GameCallback_GUI_SelectionChanged = function()
		GameCallback_GUI_SelectionChanged_Orig_Stronghold();
        Stronghold:OnSelectionMenuChanged(GUI.GetSelectedEntity());
	end

	GameCallback_OnBuildingConstructionComplete_Orig_Stronghold = GameCallback_OnBuildingConstructionComplete;
	GameCallback_OnBuildingConstructionComplete = function(_EntityID, _PlayerID)
		GameCallback_OnBuildingConstructionComplete_Orig_Stronghold(_EntityID, _PlayerID);
        Stronghold:OnSelectionMenuChanged(_EntityID);
	end

	GameCallback_OnBuildingUpgradeComplete_Orig_Stronghold = GameCallback_OnBuildingUpgradeComplete;
	GameCallback_OnBuildingUpgradeComplete = function(_EntityIDOld, _EntityIDNew)
		GameCallback_OnBuildingUpgradeComplete_Orig_Stronghold(_EntityIDOld, _EntityIDNew);
        Stronghold:OnSelectionMenuChanged(_EntityIDNew);
	end

	GameCallback_OnTechnologyResearched_Orig_Stronghold = GameCallback_OnTechnologyResearched;
	GameCallback_OnTechnologyResearched = function(_PlayerID, _Technology, _EntityID)
		GameCallback_OnTechnologyResearched_Orig_Stronghold(_PlayerID, _Technology, _EntityID);
        Stronghold:OnSelectionMenuChanged(_EntityID);
	end

    GameCallback_OnCannonConstructionComplete_Orig_Stronghold = GameCallback_OnCannonConstructionComplete;
    GameCallback_OnCannonConstructionComplete = function(_BuildingID, _null)
        GameCallback_OnCannonConstructionComplete_Orig_Stronghold(_BuildingID, _null);
        Stronghold:OnSelectionMenuChanged(_BuildingID);
    end

    GameCallback_OnTransactionComplete_Orig_Stronghold = GameCallback_OnTransactionComplete;
    GameCallback_OnCannonConstructionComplete = function(_BuildingID, _null)
        GameCallback_OnTransactionComplete_Orig_Stronghold(_BuildingID, _null);
        Stronghold:OnSelectionMenuChanged(_BuildingID);
    end

	Mission_OnSaveGameLoaded_Orig_Stronghold = Mission_OnSaveGameLoaded;
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_Orig_Stronghold();

	end
end

function Stronghold:OverrideTooltipGenericMain()
    GUITooltip_Generic_Orig_StrongholdMain = GUITooltip_Generic;
    GUITooltip_Generic = function(_Key)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUITooltip_Generic_Orig_StrongholdMain(_Key);
        end

        local TooltipSet = false;
        if not TooltipSet then
            TooltipSet = Stronghold:PrintTooltipGenericForFindView(PlayerID, _Key);
        end
        if not TooltipSet then
            TooltipSet = Stronghold:PrintTooltipGenericForEcoGeneral(PlayerID, _Key);
        end
        if not TooltipSet then
            TooltipSet = Stronghold:PrintHeadquartersTaxButtonsTooltip(PlayerID, _Key);
        end
        if not TooltipSet then
            GUITooltip_Generic_Orig_StrongholdMain(_Key);
        end
    end
end

function Stronghold:OverrideTooltipConstructionMain()
    GUITooltip_ConstructBuilding_Orig_StrongholdMain = GUITooltip_ConstructBuilding;
    GUITooltip_ConstructBuilding = function(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUITooltip_ConstructBuilding_Orig_StrongholdMain(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end

        local TooltipSet = false;
        if not TooltipSet then
            TooltipSet = Stronghold:PrintSerfConstructionTooltip(PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
        if not TooltipSet then
            GUITooltip_ConstructBuilding_Orig_StrongholdMain(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
    end
end

