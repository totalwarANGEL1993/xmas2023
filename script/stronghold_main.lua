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

-- Starts the script
function Stronghold:Init()
    GUI.ClearSelection();
    ResourceType.Honor = 20;

    self:InitTradeBalancer();
    self:StartPlayerPaydayUpdater();
    self:StartEntityCreatedTrigger();
    self:StartEntityHurtTrigger();
    self:StartOnEveryTurnTrigger();
    self:OverrideGainedResourceCallback();

    self:OverrideAttraction();
    self:OverridePaydayClockTooltip();
    self:OverrideTaxAndPayStatistics();
    self:OverrideFindViewUpdate();
    self:OverrideTooltipGenericMain();
    self:OverrideTooltipConstructionMain();
    self:OverrideUpdateConstructionMain();
    self:OverwriteCommonCallbacks();

    self:CreateHeadquartersButtonHandlers();
    self:CreateMonasteryButtonHandlers();
    self:OverrideBuyHeroWindow();
    self:OverrdeHeadquarterButtons();
    self:OverrdeMonasteryButtons();
end

-- Restore game state after load
function Stronghold:OnSaveGameLoaded()
    ResourceType.Honor = 20;
    self:OverrideAttraction();
    for k,v in pairs(self.Players) do
        self:HeadquartersConfigureBuilding(k);
        self:ConfigurePlayersLord(k);
        self:ConfigurePlayersSpouse(k);
    end
end

-- Add player
-- This function adds a new player.
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
        InvulnerabilityInfoShown = false,
        VulnerabilityInfoShown = true,
        AttackMemory = {},

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

    self:HeadquartersConfigureBuilding(_PlayerID);
end

-- -------------------------------------------------------------------------- --
-- Trigger

function Stronghold:StartOnEveryTurnTrigger()
    function Stronghold_Trigger_OnEveryTurn()
        ---@diagnostic disable-next-line: undefined-field
        local PlayerID = math.mod(math.floor(Logic.GetTime() * 10), 10);
        if PlayerID > 0 and PlayerID < 9 then
            Stronghold:EntityAttackedController(PlayerID);
            Stronghold:PlayerDefeatCondition(PlayerID);
            Stronghold:CreateWorkersForPlayer(PlayerID);
            Stronghold:UpdateIncomeAndUpkeep(PlayerID);
            Stronghold:EnergyProductionBonus(PlayerID);
            Stronghold:FaithProductionBonus(PlayerID);
        end
    end

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_EVERY_TURN,
        nil,
        "Stronghold_Trigger_OnEveryTurn",
        1
    );
end

function Stronghold:StartEntityCreatedTrigger()
    function Stronghold_Trigger_EntityCreated()
        local EntityID = Event.GetEntityID();
        local PlayerID = Logic.EntityGetPlayer(EntityID);

        -- Beautification limit
        if Logic.IsBuilding(EntityID) == 1 and GUI.GetPlayerID() == PlayerID then
            Stronghold:OnSelectionMenuChanged(EntityID);
        end
        -- Pets
        if Logic.IsSettler(EntityID) == 1 and GUI.GetPlayerID() == PlayerID then
            Stronghold:ConfigurePlayersHeroPet(EntityID);
        end
    end

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_ENTITY_CREATED,
        nil,
        "Stronghold_Trigger_EntityCreated",
        1
    );
end

function Stronghold:StartEntityHurtTrigger()
    function Stronghold_Trigger_OnEntityHurt()
        local Attacker = Event.GetEntityID1();
        local AttackerPlayer = Logic.EntityGetPlayer(Attacker);
        local Attacked = Event.GetEntityID2();
        local AttackedPlayer = Logic.EntityGetPlayer(Attacked);
        if Attacker and Attacked then
            if Logic.GetEntityHealth(Attacked) > 0 then
                if Stronghold.Players[AttackedPlayer] then
                    Stronghold.Players[AttackedPlayer].AttackMemory[Attacked] = {4, Attacker};
                end
            end
        end
    end

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_ENTITY_HURT_ENTITY,
        nil,
        "Stronghold_Trigger_OnEntityHurt",
        1
    );
end

function Stronghold:OverrideGainedResourceCallback()
    GameCallback_GainedResources_Orig_StrongholdMain = GameCallback_GainedResources;
    GameCallback_GainedResources = function(_PlayerID, _ResourceType, _Amount)
        GameCallback_GainedResources_Orig_StrongholdMain(_PlayerID, _ResourceType, _Amount);
        if Stronghold.Players[_PlayerID] then
            Stronghold:ResourceProductionBonus(_PlayerID, _ResourceType, _Amount);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Defeat Condition

-- The player is defeated when the headquarter is destroyed. This is not so
-- much like Stronghold but having 1 super strong hero as the main target
-- might be a bit risky.
function Stronghold:PlayerDefeatCondition(_PlayerID)
    if not self.Players[_PlayerID] then
        return;
    end

    -- Check lord
    local HeroAlive = false;
    if IsEntityValid(self.Players[_PlayerID].LordScriptName) then
        HeroAlive = true;
    end

    if HeroAlive then
        self.Players[_PlayerID].VulnerabilityInfoShown = false;
        if IsExisting(self.Players[_PlayerID].HQScriptName) then
            MakeInvulnerable(self.Players[_PlayerID].HQScriptName);
        end
        if not self.Players[_PlayerID].InvulnerabilityInfoShown then
            self.Players[_PlayerID].InvulnerabilityInfoShown = true;
            Sound.PlayGUISound(Sounds.Misc_so_signalhorn, 70);

            local PlayerName = UserTool_GetPlayerName(_PlayerID);
            local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
            Message(
                "@color:180,180,180 Das Haupthaus von " ..PlayerColor.. " "..
                PlayerName.. " @color:180,180,180 ist nun geschützt!"
            );
        end
    else
        self.Players[_PlayerID].InvulnerabilityInfoShown = false;
        if IsExisting(self.Players[_PlayerID].HQScriptName) then
            MakeVulnerable(self.Players[_PlayerID].HQScriptName);
        end
        if not self.Players[_PlayerID].VulnerabilityInfoShown then
            self.Players[_PlayerID].VulnerabilityInfoShown = true;
            Sound.PlayGUISound(Sounds.Misc_so_signalhorn, 70);

            local PlayerName = UserTool_GetPlayerName(_PlayerID);
            local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
            Message(
                "@color:180,180,180 Das Haupthaus von " ..PlayerColor.. " "..
                PlayerName.. " @color:180,180,180 ist nun verwundbar!"
            );
        end
    end

    -- Check HQ
    if not IsExisting(self.Players[_PlayerID].HQScriptName) then
        if Logic.PlayerGetGameState(_PlayerID) == 1 then
            Logic.PlayerSetGameStateToLost(_PlayerID);

            local PlayerName = UserTool_GetPlayerName(_PlayerID);
            local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
            Message(PlayerColor.. " " ..PlayerName.. " @color:180,180,180 wurde besiegt!");
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Workers

-- Worker Spawner
-- Because the attraction limit only affects serfs, workers and agents and I
-- don't feel like changing the properties of every entity type they must be
-- spawned this way.
function Stronghold:CreateWorkersForPlayer(_PlayerID)
    if self.Players[_PlayerID] then
        local DoCreate = true;
        local LeaveMotivation = Logic.GetLogicPropertiesMotivationThresholdLeave();
        if Logic.GetAverageMotivation(_PlayerID) > LeaveMotivation then
            if Logic.GetPlayerAttractionUsage(_PlayerID) < Logic.GetPlayerAttractionLimit(_PlayerID) then
                local Index = self.Players[_PlayerID].LastBuildingWorkerCreatedIndex or 1;
                local Buildings = GetAllWorkplaces(_PlayerID);
                if Buildings[Index] then
                    if DoCreate then
                        local PlacesLimit = Logic.GetBuildingWorkPlaceLimit(Buildings[Index]);
                        local PlacesUsed = Logic.GetBuildingWorkPlaceUsage(Buildings[Index]);
                        if PlacesUsed < PlacesLimit then
                            local Type = Logic.GetWorkerTypeByBuilding(Buildings[Index]);
                            local Position = self.Players[_PlayerID].DoorPos;
                            Logic.CreateEntity(Type, Position.X, Position.Y, 0, _PlayerID);
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

-- Overwrite attraction
-- The attraction limit is based on the headquarters. To make my life easier
-- I just overwrite the logics.
function Stronghold:OverrideAttraction()
    GetPlayerAttractionLimit_Orig_StrongholdEco = Logic.GetPlayerAttractionLimit
    ---@diagnostic disable-next-line: duplicate-set-field
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
        -- Hero bonus
        AttractionLimit = Stronghold:ApplyMaxAttractionPassiveAbility(_PlayerID, AttractionLimit);

        return math.floor(AttractionLimit + 0.5);
	end

	GetPlayerAttractionUsage_Orig_StrongholdEco = Logic.GetPlayerAttractionUsage
    ---@diagnostic disable-next-line: duplicate-set-field
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

-- Payday updater
-- The real payday is deactivated. If the payday callback is present the payday
-- is implemented using it. If not we use the good old fashioned way.
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

-- Payday controller
-- Applies everything that is happening on the payday.
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
            local WorkerList = GetAllWorker(_PlayerID);
            for i= 1, table.getn(WorkerList) do
                CEntity.SetMotivation(WorkerList[i], _Amount / 100);
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- UI Update

-- Menu update
-- This calls all updates of the selection menu when selection has changed.
function Stronghold:OnSelectionMenuChanged(_EntityID)
    self:OnHeadquarterSelected(_EntityID);

    GUIUpdate_BuildingButtons("Build_Beautification01", Technologies.B_Beautification01)
    GUIUpdate_BuildingButtons("Build_Beautification02", Technologies.B_Beautification02)
    for i= 3, 12 do
        local Num = (i < 10 and "0" ..i) or i;
        GUIUpdate_UpgradeButtons("Build_Beautification" ..Num, Technologies["B_Beautification" ..Num]);
    end
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
        Stronghold:HeadquartersConfigureBuilding(_PlayerID);
	end

	GameCallback_OnBuildingUpgradeComplete_Orig_Stronghold = GameCallback_OnBuildingUpgradeComplete;
	GameCallback_OnBuildingUpgradeComplete = function(_EntityIDOld, _EntityIDNew)
		GameCallback_OnBuildingUpgradeComplete_Orig_Stronghold(_EntityIDOld, _EntityIDNew);
        Stronghold:OnSelectionMenuChanged(_EntityIDNew);
        Stronghold:HeadquartersConfigureBuilding(Logic.EntityGetPlayer(_EntityIDNew));
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

-- Tooptip Generic Override
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

-- Tooptip Construction Override
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

-- Update Construction Override
function Stronghold:OverrideUpdateConstructionMain()
    GUIUpdate_BuildingButtons_Orig_StrongholdMain = GUIUpdate_BuildingButtons;
    GUIUpdate_BuildingButtons = function(_Button, _Technology)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUIUpdate_BuildingButtons_Orig_StrongholdMain(_Button, _Technology);
        end

        local Updated = false;
        if not Updated then
            Updated = Stronghold:UpdateSerfConstructionButtons(PlayerID, _Button, _Technology);
        end
        if not Updated then
            GUIUpdate_BuildingButtons_Orig_StrongholdMain(_Button, _Technology);
        end
    end

    GUIUpdate_UpgradeButtons_Orig_StrongholdMain = GUIUpdate_UpgradeButtons;
    GUIUpdate_UpgradeButtons = function(_Button, _Technology)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return GUIUpdate_UpgradeButtons_Orig_StrongholdMain(_Button, _Technology);
        end

        local Updated = false;
        if not Updated then
            Updated = Stronghold:UpdateSerfConstructionButtons(PlayerID, _Button, _Technology);
        end
        if not Updated then
            GUIUpdate_UpgradeButtons_Orig_StrongholdMain(_Button, _Technology);
        end
    end
end

