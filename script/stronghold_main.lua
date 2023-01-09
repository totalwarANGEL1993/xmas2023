---
--- Main Script
---
--- This script implements everything reguarding the player.
---
--- Managed by the script:
--- - Players rank
--- - Players honor
--- - Players reputation
--- - Players payday
--- - Players attraction limit
--- - Defeat condition
--- - Shared UI stuff
--- - automatic archive loading
---   (TODO: Use hook if CMod is nil)
---
--- Defined game callbacks:
--- - <number> GameCallback_Calculate_AttrationLimit(_PlayerID, _Amount)
---   Allows to overwrite the max attraction.
---
--- - GameCallback_Stronghold_OnPayday(_PlayerID)
---   Called after the payday is done.
---

Stronghold = {
    Shared = {
        UnitqueTributeID = 999,
    },
    Players = {},
    Config = {
        HonorLimit = 9000,
        HQAttraction = {
            [1] = 100,
            [2] = 200,
            [3] = 300
        },

        Ranks = {
            [1] = {
                Text = {"Edelmann", "Edelfrau"},
                Costs = {0, 0, 0, 0, 0, 0, 0},
            },
            [2] = {
                Text = {"Landvogt", "Landvögtin"},
                Costs = {10, 50, 0, 0, 0, 0, 0},
            },
            [3] = {
                Text = {"Lord", "Lady"},
                Costs = {30, 100, 0, 0, 0, 0, 0},
            },
            [4] = {
                Text = {"Edler Lord", "Edle Lady"},
                Costs = {50, 200, 0, 0, 0, 0, 0},
            },
            [5] = {
                Text = {"Fürst", "Fürstin"},
                Costs = {100, 300, 0, 0, 0, 0, 0},
            },
            [6] = {
                Text = {"Baron", "Baronin"},
                Costs = {150, 500, 0, 0, 0, 0, 0},
            },
            [7] = {
                Text = {"Graf", "Gräfin"},
                Costs = {200, 1000, 0, 0, 0, 0, 0},
            },
            [8] = {
                Text = {"Herzog", "Herzogin"},
                Costs = {250, 2000, 0, 0, 0, 0, 0},
            },
            [9] = {
                Text = {"Erzherzog", "Erzherzogin"},
                Costs = {300, 3000, 0, 0, 0, 0, 0},
            },
        },

        Gender = {
            [Entities.PU_Hero1c]             = 1,
            [Entities.PU_Hero2]              = 1,
            [Entities.PU_Hero3]              = 1,
            [Entities.PU_Hero4]              = 1,
            [Entities.PU_Hero5]              = 2,
            [Entities.PU_Hero6]              = 1,
            [Entities.CU_BlackKnight]        = 1,
            [Entities.CU_Mary_de_Mortfichet] = 2,
            [Entities.CU_Barbarian_Hero]     = 1,
            [Entities.PU_Hero10]             = 1,
            [Entities.PU_Hero11]             = 2,
            [Entities.CU_Evil_Queen]         = 2,
        },
    },
}

-- -------------------------------------------------------------------------- --
-- API

--- Starts the Stronghold script
function SetupStronghold()
    Stronghold:Init();
end

--- Creates a new human player.
function SetupHumanPlayer(_PlayerID)
    if not Stronghold:IsPlayer(_PlayerID) then
        Stronghold:AddPlayer(_PlayerID);
    end
end

--- Gives reputation to the player.
function AddPlayerReputation(_PlayerID, _Amount)
    Stronghold:AddPlayerReputation(_PlayerID, _Amount)
end

--- Returns the reputation of the player.
function GetPlayerReputation(_PlayerID)
    return Stronghold:GetPlayerReputation(_PlayerID);
end

--- Returns the max reputation of the player.
function GetPlayerMaxReputation(_PlayerID)
    return Stronghold:GetPlayerReputationLimit(_PlayerID);
end

--- Adds honor to the player.
function AddPlayerHonor(_PlayerID, _Amount)
    Stronghold:AddPlayerHonor(_PlayerID, _Amount);
end

--- Returns the amount of honor of the player.
function GetPlayerHonor(_PlayerID)
    return Stronghold:GetPlayerHonor(_PlayerID);
end

--- Returns the rank of the player.
function GetPlayerRank(_PlayerID)
    return Stronghold:GetPlayerRank(_PlayerID);
end

--- Sets the rank of the player.
function SetPlayerRank(_PlayerID, _Rank)
    return Stronghold:SetPlayerRank(_PlayerID, _Rank);
end

--- Returns the player data.
function GetPlayerData(_PlayerID)
    if Stronghold:IsPlayer(_PlayerID) then
        return Stronghold:GetPlayer(_PlayerID);
    end
end

-- -------------------------------------------------------------------------- --
-- Main

-- Starts the script
function Stronghold:Init()
    if not CMod then
        Message("The S5 Community Server is required!");
        return false;
    end
    self:LoadMapArchive();
    self:InitAutomaticMapArchiveUnload();
    self:OverrideFrameworkRestartMap();

    XGUIEng.TransferMaterials("Formation01", "Levy_Duties");
    XGUIEng.SetMaterialTexture("BackGround_Top", 0, "maps/externalmap/graphics/bg_top.png");
    XGUIEng.SetMaterialTexture("BackGround_BottomLeft", 1, "maps/externalmap/graphics/bg_bottom_left.png");
    XGUIEng.SetMaterialTexture("BackGround_BottomTexture", 0, "maps/externalmap/graphics/bg_bottom.png");
    XGUIEng.SetMaterialTexture("TooltipBackground", 1, "maps/externalmap/graphics/bg_tooltip.png");
    GUI.ClearSelection();
    ResourceType.Honor = 20;

    self.Economy:Install();
    self.Limitation:Install();
    self.Building:Install();
    self.Hero:Install();
    self.Unit:Install();
    self.Province:Install();
    self.AI:Install();

    self:StartPlayerPaydayUpdater();
    self:StartEntityCreatedTrigger();
    self:StartEntityHurtTrigger();
    self:StartOnEveryTurnTrigger();

    self:OverrideAttraction();
    self:OverrideTooltipGenericMain();
    self:OverrideActionBuyMilitaryUnitMain();
    self:OverrideTooltipBuyMilitaryUnitMain();
    self:OverrideActionResearchTechnologyMain();
    self:OverrideTooltipUpgradeSettlersMain();
    self:OverwriteCommonCallbacks();

    return true;
end

-- Restore game state after load
function Stronghold:OnSaveGameLoaded()
    if not CMod then
        Message("The S5 Community Server is required!");
        return false;
    end
    self:LoadMapArchive();
    self:OverrideFrameworkRestartMap();

    XGUIEng.TransferMaterials("Formation01", "Levy_Duties");
    XGUIEng.SetMaterialTexture("BackGround_Top", 0, "maps/externalmap/graphics/bg_top.png");
    XGUIEng.SetMaterialTexture("BackGround_BottomLeft", 1, "maps/externalmap/graphics/bg_bottom_left.png");
    XGUIEng.SetMaterialTexture("BackGround_BottomTexture", 0, "maps/externalmap/graphics/bg_bottom.png");
    XGUIEng.SetMaterialTexture("TooltipBackground", 1, "maps/externalmap/graphics/bg_tooltip.png");
    GUI.ClearSelection();
    ResourceType.Honor = 20;

    self.Building:OnSaveGameLoaded();
    self.Limitation:OnSaveGameLoaded();
    self.Hero:OnSaveGameLoaded();
    self.Unit:OnSaveGameLoaded();
    self.Province:OnSaveGameLoaded();
    self.AI:OnSaveGameLoaded();

    self:OverrideAttraction();
    return true;
end

-- Add player
-- This function adds a new player.
function Stronghold:AddPlayer(_PlayerID)
    local LordName = "LordP" .._PlayerID;
    local HQName = "HQ" .._PlayerID;
    local DoorPosName = "DoorP" .._PlayerID;
    local CampName = "CampP" .._PlayerID;
    local CampPosName = "CampPosP" .._PlayerID;

    -- Create door pos
    local DoorPos = GetCirclePosition(HQName, 800, 180);
    local ID = Logic.CreateEntity(Entities.XD_ScriptEntity, DoorPos.X, DoorPos.Y, 0, 0);
    Logic.SetEntityName(ID, DoorPosName);

    -- Create camp Pos
    local CampPos = GetCirclePosition(HQName, 1200, 180);
    ID = Logic.CreateEntity(Entities.XD_LargeCampFire, CampPos.X -5, CampPos.Y -5, 0, 0);
    Logic.SetEntityName(ID, CampName);
    ID = AI.Entity_CreateFormation(8, Entities.PU_Serf, nil, 0, CampPos.X, CampPos.Y, 0, 0, 0, 0);
    local x,y,z = Logic.EntityGetPos(ID);
    CampPos.X = x; CampPos.Y = y; CampPos.Z = z;
    DestroyEntity(ID);
    ID = Logic.CreateEntity(Entities.XD_ScriptEntity, x, y, 0, _PlayerID);
    Logic.SetEntityName(ID, CampPosName);

    -- Create serfs
    for i= 1, 6 do
        local SerfPos = GetCirclePosition(CampName, 250, 60 * i);
        ID = Logic.CreateEntity(Entities.PU_Serf, SerfPos.X, SerfPos.Y, 360 - (60 * i), _PlayerID);
        LookAt(ID, CampName);
    end

    -- Deactivate normal upkeep
    -- (Does not work. Payday clock does not start for soldiers)
    -- Logic.SetPlayerPaysLeaderFlag(_PlayerID, 0);

    -- Create player data
    self.Players[_PlayerID] = {
        InvulnerabilityInfoShown = false,
        VulnerabilityInfoShown = true,
        AttackMemory = {},

        LordScriptName = LordName,
        HQScriptName = HQName,
        DoorPos = DoorPos;
        CampPos = CampPos;

        ReputationLimit = 200,
        Reputation = 100,

        Honor = 0,
        IncomeHonor = 0,

        TaxHeight = 3,
        Rank = 1,
    };

    self.Building:HeadquartersConfigureBuilding(_PlayerID);
end

function Stronghold:GetPlayer(_PlayerID)
    return self.Players[_PlayerID];
end

function Stronghold:IsPlayer(_PlayerID)
    return self:GetPlayer(_PlayerID) ~= nil;
end

-- -------------------------------------------------------------------------- --
-- Game Callbacks

function GameCallback_Calculate_AttrationLimit(_PlayerID, _Amount)
    return _Amount
end

function GameCallback_Stronghold_OnPayday(_PlayerID)
end

-- -------------------------------------------------------------------------- --
-- Achive Loading

function Stronghold:LoadMapArchive()
    local ArchiveName = Framework.GetCurrentMapName() .. ".s5x";
    local TopArchive = CMod.GetAllArchives();
    if not TopArchive or not string.find(TopArchive, "s5x") then
        CMod.PushArchive(ArchiveName);
    end
end

function Stronghold:UnloadMapArchive()
    local TopArchive = CMod.GetAllArchives();
    if TopArchive and string.find(TopArchive, "s5x") then
        CMod.PopArchive();
    end
end

function Stronghold:OverrideFrameworkRestartMap()
    self.Orig_FrameworkRestartMap = Framework.RestartMap;
    Framework.RestartMap = function()
        Stronghold:UnloadMapArchive();
        Stronghold.Orig_FrameworkRestartMap();
    end
end

function Stronghold:InitAutomaticMapArchiveUnload()
    self.Orig_GUIAction_RestartMap = GUIAction_RestartMap;
    GUIAction_RestartMap = function()
        Stronghold:UnloadMapArchive();
        Stronghold.Orig_GUIAction_RestartMap();
    end

    self.Orig_QuitGame = QuitGame;
    QuitGame = function()
        Stronghold:UnloadMapArchive();
        Stronghold.Orig_QuitGame();
    end

    self.Orig_QuitApplication = QuitApplication;
    QuitApplication = function()
        Stronghold:UnloadMapArchive();
        Stronghold.Orig_QuitApplication();
    end

    self.Orig_QuickLoad = QuickLoad;
    QuickLoad = function()
        Stronghold:UnloadMapArchive();
        Stronghold.Orig_QuickLoad();
    end

    self.Orig_MainWindow_LoadGame_DoLoadGame = MainWindow_LoadGame_DoLoadGame;
    MainWindow_LoadGame_DoLoadGame = function(_Slot)
        Stronghold:UnloadMapArchive();
        Stronghold.Orig_MainWindow_LoadGame_DoLoadGame(_Slot);
    end
end

-- -------------------------------------------------------------------------- --
-- Trigger

function Stronghold:StartOnEveryTurnTrigger()
    function Stronghold_Trigger_OnEveryTurn()
        ---@diagnostic disable-next-line: undefined-field
        local PlayerID = math.mod(math.floor(Logic.GetTime() * 10), 10);
        if PlayerID > 0 and PlayerID < 9 then
            Stronghold:PlayerDefeatCondition(PlayerID);
            Stronghold:CreateWorkersForPlayer(PlayerID);
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
            Stronghold:OnSelectionMenuChanged(EntityID, GUI.GetSelectedEntity());
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

-- -------------------------------------------------------------------------- --
-- Defeat Condition

-- The player is defeated when the headquarter is destroyed. This is not so
-- much like Stronghold but having 1 super strong hero as the main target
-- might be a bit risky.
function Stronghold:PlayerDefeatCondition(_PlayerID)
    if not self:IsPlayer(_PlayerID) then
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
    if self:IsPlayer(_PlayerID) then
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
		if not Stronghold:IsPlayer(_PlayerID) then
            return GetPlayerAttractionUsage_Orig_StrongholdEco(_PlayerID);
        end

        -- Attraction limit
        local AttractionLimit = Stronghold.Config.HQAttraction[1];
        local CastleT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters2);
        if CastleT2 > 0 then
            AttractionLimit = Stronghold.Config.HQAttraction[2];
        end
        local CastleT3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters3);
        if CastleT3 > 0 then
            AttractionLimit = Stronghold.Config.HQAttraction[3];
        end
        -- External
        AttractionLimit = GameCallback_Calculate_AttrationLimit(_PlayerID, AttractionLimit);

        return math.floor(AttractionLimit + 0.5);
	end

	GetPlayerAttractionUsage_Orig_StrongholdEco = Logic.GetPlayerAttractionUsage
    ---@diagnostic disable-next-line: duplicate-set-field
	Logic.GetPlayerAttractionUsage = function(_PlayerID)
		if not Stronghold:IsPlayer(_PlayerID) then
            return GetPlayerAttractionUsage_Orig_StrongholdEco(_PlayerID);
        end
        local WorkerCount = Logic.GetNumberOfAttractedWorker(_PlayerID);
        local SerfCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Serf);
        local ScoutCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Scout);
        local ThiefCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Thief);
        -- Mary makes scouts and thieves totally free of charge
        if Stronghold.Hero:HasValidHeroOfType(_PlayerID, Entities.CU_Mary_de_Mortfichet) then
            ScoutCount = 0;
            ThiefCount = 0;
        end
        return WorkerCount + SerfCount + ScoutCount + (ThiefCount *5);
	end
end

-- -------------------------------------------------------------------------- --
-- Payday

-- Payday updater
-- The real payday is deactivated. If the payday callback is present the payday
-- is implemented using it. If not we use the good old fashioned way.
function Stronghold:StartPlayerPaydayUpdater()
    -- On community server
    if CNetwork then
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

        for i= 1, table.getn(Score.Player) do
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
    if self:IsPlayer(_PlayerID) then
        -- Fix money for payday (only singleplayr)
        if _FixGold then
            local TaxAmount = Logic.GetPlayerPaydayCost(_PlayerID);
            if TaxAmount > 0 then
                AddGold(_PlayerID, -1 * TaxAmount);
            end
        end
        AddGold(_PlayerID, Logic.GetNumberOfLeader(_PlayerID) * 20, 0, 0, 0, 0, 0);
        Tools.GiveResouces(_PlayerID, Stronghold.Economy.Data[_PlayerID].IncomeMoney, 0, 0, 0, 0, 0);
        AddGold(_PlayerID, -Stronghold.Economy.Data[_PlayerID].UpkeepMoney);

        -- Reputation
        local OldReputation = self:GetPlayerReputation(_PlayerID);
        local Reputation = Stronghold.Economy.Data[_PlayerID].IncomeReputation;
        self:UpdateMotivationOfWorkers(_PlayerID, OldReputation + Reputation);
        self.Players[_PlayerID].Reputation = OldReputation + Reputation;
        if self.Players[_PlayerID].Reputation > self.Players[_PlayerID].ReputationLimit then
            self.Players[_PlayerID].Reputation = self.Players[_PlayerID].ReputationLimit;
        end
        if self.Players[_PlayerID].Reputation < 0 then
            self.Players[_PlayerID].Reputation = 0;
        end

        -- Honor
        local Honor = Stronghold.Economy.Data[_PlayerID].IncomeHonor;
        self:AddPlayerHonor(_PlayerID, Honor);

        -- Payday done
        GameCallback_Stronghold_OnPayday(_PlayerID);
    end
end

-- -------------------------------------------------------------------------- --
-- Rank

function Stronghold:GetPlayerRank(_PlayerID)
    if self:IsPlayer(_PlayerID) then
        return self.Players[_PlayerID].Rank;
    end
    return 0;
end

function Stronghold:GetPlayerRankName(_PlayerID, _Rank)
    if self:IsPlayer(_PlayerID) then
        local Rank = _Rank or self.Players[_PlayerID].Rank;
        local LairdID = GetID(self.Players[_PlayerID].LordScriptName);

        local Gender = 1;
        if LairdID ~= 0 then
            Gender = self:GetLairdGender(Logic.GetEntityType(LairdID)) or 1;
        end
        return self.Config.Ranks[Rank].Text[Gender];
    end
    return "Fußvolk";
end

function Stronghold:GetLairdGender(_Type)
    if self.Config.Gender[_Type] then
        return self.Config.Gender[_Type];
    end
    return 1;
end

function Stronghold:SetPlayerRank(_PlayerID, _Rank)
    if self:IsPlayer(_PlayerID) then
        self.Players[_PlayerID].Rank = _Rank;
    end
end

function Stronghold:PromotePlayer(_PlayerID)
    if self:CanPlayerBePromoted(_PlayerID) then
        local Rank = self:GetPlayerRank(_PlayerID);
        local RankName = Stronghold:GetPlayerRankName(_PlayerID, Rank +1);
        self:SetPlayerRank(_PlayerID, Rank +1);

        local Costs = Stronghold:CreateCostTable(unpack(self.Config.Ranks[Rank +1].Costs));
        RemoveResourcesFromPlayer(_PlayerID, Costs);

        local MsgText = "Erhebt Euch, " ..RankName.. "!";
        if GUI.GetPlayerID() == _PlayerID then
            Stronghold.Hero:OnSelectHero(GUI.GetSelectedEntity());
        else
            local PlayerName = UserTool_GetPlayerName(_PlayerID);
            local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
            MsgText = PlayerColor.. " " ..PlayerName.. " @color:180,180,180 wurde "..
                        "befördert und ist nun @color:255,255,255 " ..RankName;
        end
        Message(MsgText);
    end
end

function Stronghold:CanPlayerBePromoted(_PlayerID)
    if self:IsPlayer(_PlayerID) then
        local Rank = self:GetPlayerRank(_PlayerID);
        if Rank == 0 or Rank >= 9 then
            return false;
        end
        return true;
    end
    return false;
end

-- -------------------------------------------------------------------------- --
-- Honor

function Stronghold:AddPlayerHonor(_PlayerID, _Amount)
    if self:IsPlayer(_PlayerID) then
        self.Players[_PlayerID].Honor = self.Players[_PlayerID].Honor + _Amount;
        if self.Players[_PlayerID].Honor > self.Config.HonorLimit then
            self.Players[_PlayerID].Honor = self.Config.HonorLimit;
        end
        if self.Players[_PlayerID].Honor < 0 then
            self.Players[_PlayerID].Honor = 0;
        end
    end
end

function Stronghold:GetPlayerHonor(_PlayerID)
    if self:IsPlayer(_PlayerID) then
        return self.Players[_PlayerID].Honor;
    end
    return 0;
end

-- -------------------------------------------------------------------------- --
-- Reputation

function Stronghold:AddPlayerReputation(_PlayerID, _Amount)
    if self:IsPlayer(_PlayerID) then
        local Reputation = self:GetPlayerReputation(_PlayerID);
        self:SetPlayerReputation(_PlayerID, Reputation + _Amount);
    end
end

function Stronghold:SetPlayerReputation(_PlayerID, _Amount)
    if self:IsPlayer(_PlayerID) then
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
    if self:IsPlayer(_PlayerID) then
        self.Players[_PlayerID].ReputationLimit = _Amount;
    end
end

function Stronghold:GetPlayerReputationLimit(_PlayerID)
    if self:IsPlayer(_PlayerID) then
        return self.Players[_PlayerID].ReputationLimit;
    end
    return 200;
end

function Stronghold:GetPlayerReputation(_PlayerID)
    if self:IsPlayer(_PlayerID) then
        return self.Players[_PlayerID].Reputation;
    end
    return 100;
end

function Stronghold:UpdateMotivationOfWorkers(_PlayerID, _Amount)
    if self:IsPlayer(_PlayerID) then
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
    self.Hero:OnSelectLeader(_EntityID);
    self.Hero:OnSelectHero(_EntityID);

    self.Building:OnHeadquarterSelected(_EntityID);
    self.Building:OnBarracksSelected(_EntityID);
    self.Building:OnArcherySelected(_EntityID);
    self.Building:OnStableSelected(_EntityID);
    self.Building:OnFoundrySelected(_EntityID);
    self.Building:OnTavernSelected(_EntityID);
end

function Stronghold:OverwriteCommonCallbacks()
    self.Orig_GameCallback_GUI_SelectionChanged = GameCallback_GUI_SelectionChanged;
	GameCallback_GUI_SelectionChanged = function()
        local EntityID = GUI.GetSelectedEntity();
		Stronghold.Orig_GameCallback_GUI_SelectionChanged();
        Stronghold:OnSelectionMenuChanged(EntityID);
	end

	self.Orig_GameCallback_OnBuildingConstructionComplete = GameCallback_OnBuildingConstructionComplete;
	GameCallback_OnBuildingConstructionComplete = function(_EntityID, _PlayerID)
		Stronghold.Orig_GameCallback_OnBuildingConstructionComplete(_EntityID, _PlayerID);
        local EntityID = GUI.GetSelectedEntity();
        Stronghold.Building:HeadquartersConfigureBuilding(_PlayerID);
        Stronghold:OnSelectionMenuChanged(EntityID);
	end

	self.Orig_GameCallback_OnBuildingUpgradeComplete = GameCallback_OnBuildingUpgradeComplete;
	GameCallback_OnBuildingUpgradeComplete = function(_EntityIDOld, _EntityIDNew)
        local EntityID = GUI.GetSelectedEntity();
		Stronghold.Orig_GameCallback_OnBuildingUpgradeComplete(_EntityIDOld, _EntityIDNew);
        if Logic.IsEntityInCategory(_EntityIDNew, EntityCategories.Headquarters) == 1 then
            Stronghold.Building:HeadquartersConfigureBuilding(Logic.EntityGetPlayer(_EntityIDNew));
        end
        if EntityID == _EntityIDNew then
            Stronghold:OnSelectionMenuChanged(_EntityIDNew);
        end
	end

	self.Orig_GameCallback_OnTechnologyResearched = GameCallback_OnTechnologyResearched;
	GameCallback_OnTechnologyResearched = function(_PlayerID, _Technology, _EntityID)
        local EntityID = GUI.GetSelectedEntity();
		Stronghold.Orig_GameCallback_OnTechnologyResearched(_PlayerID, _Technology, _EntityID);
        Stronghold:OnSelectionMenuChanged(EntityID);
	end

    self.Orig_GameCallback_OnCannonConstructionComplete = GameCallback_OnCannonConstructionComplete;
    GameCallback_OnCannonConstructionComplete = function(_BuildingID, _null)
        local EntityID = GUI.GetSelectedEntity();
        Stronghold.Orig_GameCallback_OnCannonConstructionComplete(_BuildingID, _null);
        Stronghold:OnSelectionMenuChanged(EntityID);
    end

    self.Orig_GameCallback_OnTransactionComplete = GameCallback_OnTransactionComplete;
    GameCallback_OnCannonConstructionComplete = function(_BuildingID, _null)
        local EntityID = GUI.GetSelectedEntity();
        Stronghold.Orig_GameCallback_OnTransactionComplete(_BuildingID, _null);
        Stronghold:OnSelectionMenuChanged(EntityID);
    end

	self.Orig_Mission_OnSaveGameLoaded = Mission_OnSaveGameLoaded;
	Mission_OnSaveGameLoaded = function()
		Stronghold.Orig_Mission_OnSaveGameLoaded();
        Stronghold:OnSaveGameLoaded();
	end
end

-- Tooptip Generic Override
function Stronghold:OverrideTooltipGenericMain()
    GUITooltip_Generic_Orig_StrongholdMain = GUITooltip_Generic;
    GUITooltip_Generic = function(_Key)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return GUITooltip_Generic_Orig_StrongholdMain(_Key);
        end

        local TooltipSet = false;
        if not TooltipSet then
            TooltipSet = Stronghold.Economy:PrintTooltipGenericForFindView(PlayerID, _Key);
        end
        if not TooltipSet then
            TooltipSet = Stronghold.Economy:PrintTooltipGenericForEcoGeneral(PlayerID, _Key);
        end
        if not TooltipSet then
            TooltipSet = Stronghold.Building:PrintHeadquartersTaxButtonsTooltip(PlayerID, _Key);
        end
        if not TooltipSet then
            GUITooltip_Generic_Orig_StrongholdMain(_Key);
        end
    end
end

-- Action research technology Override
function Stronghold:OverrideActionResearchTechnologyMain()
    GUIAction_ReserachTechnology_Orig_StrongholdMain = GUIAction_ReserachTechnology;
    GUIAction_ReserachTechnology = function(_Technology)
        if Stronghold.Building:OnBarracksSettlerUpgradeTechnologyClicked(_Technology) then
            return;
        end
        if Stronghold.Building:OnArcherySettlerUpgradeTechnologyClicked(_Technology) then
            return;
        end
        if Stronghold.Building:OnStableSettlerUpgradeTechnologyClicked(_Technology) then
            return;
        end
        GUIAction_ReserachTechnology_Orig_StrongholdMain(_Technology);
    end
end

-- Tooptip Upgrade Settlers Override
function Stronghold:OverrideTooltipUpgradeSettlersMain()
    GUITooltip_ResearchTechnologies_Orig_StrongholdMain = GUITooltip_ResearchTechnologies;
    GUITooltip_ResearchTechnologies = function(_Technology, _TextKey, _ShortCut)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return GUITooltip_ResearchTechnologies_Orig_StrongholdMain(_Technology, _TextKey, _ShortCut);
        end

        local TooltipSet = false;
        if not TooltipSet then
            TooltipSet = Stronghold.Building:UpdateUpgradeSettlersBarracksTooltip(PlayerID, _Technology, _TextKey, _ShortCut);
        end
        if not TooltipSet then
            TooltipSet = Stronghold.Building:UpdateUpgradeSettlersArcheryTooltip(PlayerID, _Technology, _TextKey, _ShortCut);
        end
        if not TooltipSet then
            TooltipSet = Stronghold.Building:UpdateUpgradeSettlersStableTooltip(PlayerID, _Technology, _TextKey, _ShortCut);
        end
        if not TooltipSet then
            GUITooltip_ResearchTechnologies_Orig_StrongholdMain(_Technology, _TextKey, _ShortCut);
        end
    end
end

function Stronghold:OverrideActionBuyMilitaryUnitMain()
    self.Orig_GUIAction_BuyMilitaryUnit = GUIAction_BuyMilitaryUnit;
    GUIAction_BuyMilitaryUnit = function(_UpgradeCategory)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Orig_GUIAction_BuyMilitaryUnit(_UpgradeCategory);
        end
        local EntityID = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(EntityID);
        if Type == Entities.PB_Tavern1 or Type == Entities.PB_Tavern2 then
            return Stronghold.Building:OnTavernBuyUnitClicked(_UpgradeCategory);
        end
        Stronghold.Orig_GUIAction_BuyMilitaryUnit(_UpgradeCategory);
    end

    self.Orig_GUIAction_BuyCannon = GUIAction_BuyCannon;
    GUIAction_BuyCannon = function(_Type, _UpgradeCategory)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Orig_GUIAction_BuyCannon(_Type, _UpgradeCategory);
        end
        local EntityID = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(EntityID);
        if Type == Entities.PB_Foundry1 or Type == Entities.PB_Foundry2 then
            return Stronghold.Building:OnFoundryBuyUnitClicked(_Type, _UpgradeCategory);
        end
        Stronghold.Orig_GUIAction_BuyCannon(_Type, _UpgradeCategory);
    end
end

function Stronghold:OverrideTooltipBuyMilitaryUnitMain()
    self.Orig_GUITooltip_BuyMilitaryUnit = GUITooltip_BuyMilitaryUnit;
    GUITooltip_BuyMilitaryUnit = function(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Orig_GUITooltip_BuyMilitaryUnit(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end

        local TooltipSet = false;
        if not TooltipSet then
            TooltipSet = Stronghold.Building:UpdateTavernBuyUnitTooltip(PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
        if not TooltipSet then
            TooltipSet = Stronghold.Building:UpdateFoundryBuyUnitTooltip(PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
        if not TooltipSet then
            Stronghold.Orig_GUITooltip_BuyMilitaryUnit(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
    end
end


