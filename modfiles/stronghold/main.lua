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
--- - GameCallback_Stronghold_OnPayday(_PlayerID)
---   Called after the payday is done.
---

Stronghold = {
    Shared = {
        DelayedAction = {},
        HQInfo = {},
    },
    Players = {},
    Config = {
        Rule = {
            MaxHonor = 9000,
            InitialResources = {0, 450, 2000, 1500, 850, 50, 50},
            InitialRank = 1,
            MaxRank = 7,
            StartingSerfs = 6,
        },

        Ranks = {
            [1] = {
                Text = {{de = "Edelmann", en = "Nobleman"},
                        {de = "Edelfrau", en = "Noblewoman"}},
                Costs = {0, 0, 0, 0, 0, 0, 0},
                Description = nil,
                Condition = function(_PlayerID)
                    return true;
                end,
            },
            [2] = {
                Text = {{de = "Landvogt", en = "Bailiff"},
                        {de = "Landvögtin", en = "Bailiff"}},
                Costs = {20, 100, 0, 0, 0, 0, 0},
                Description = "Kapelle",
                Condition = function(_PlayerID)
                    local Chapell1 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Monastery1));
                    local Chapell2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Monastery2);
                    local Chapell3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Monastery3);
                    return Chapell1 + Chapell2 + Chapell3 > 0;
                end,
            },
            [3] = {
                Text = {{de = "Fürst", en = "Lord"},
                        {de = "Fürstin", en = "Lady"}},
                Costs = {50, 200, 0, 0, 0, 0, 0},
                Description = "Handelswesen, Festung",
                Condition = function(_PlayerID)
                    local CastleID = GetID(Stronghold.Players[_PlayerID].HQScriptName);
                    if Logic.GetEntityType(CastleID) == Entities.PB_Headquarters2
                    or Logic.GetEntityType(CastleID) == Entities.PB_Headquarters3 then
                        return true;
                    end
                    return false;
                end,
            },
            [4] = {
                Text = {{de = "Baron", en = "Baron"},
                        {de = "Baronin", en = "Baroness"}},
                Costs = {100, 300, 0, 0, 0, 0, 0},
                Description = "8 Ziergebäude",
                Condition = function(_PlayerID)
                    local Beauty01 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification01));
                    local Beauty02 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification02));
                    local Beauty03 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification03));
                    local Beauty04 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification04));
                    local Beauty05 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification05));
                    local Beauty06 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification06));
                    local Beauty07 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification07));
                    local Beauty08 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification08));
                    local Beauty09 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification09));
                    local Beauty10 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification10));
                    local Beauty11 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification11));
                    local Beauty12 = table.getn(GetValidEntitiesOfType(_PlayerID, Entities.PB_Beautification12));
                    return Beauty01 + Beauty02 + Beauty03 + Beauty04 + Beauty05 + Beauty06 +
                           Beauty07 + Beauty08 + Beauty09 + Beauty10 + Beauty11 + Beauty12 >= 8;
                end,
            },
            [5] = {
                Text = {{de = "Graf", en = "Count"},
                        {de = "Gräfin", en = "Countess"}},
                Costs = {150, 500, 0, 0, 0, 0, 0},
                Description = "6 Alchemisten, 6 Ziegelbrenner, 6 Sägewerker, 6 Schmiede, 6 Steinmetze",
                Condition = function(_PlayerID)
                    local Workers1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_BrickMaker);
                    local Workers2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Sawmillworker);
                    local Workers3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Smith);
                    local Workers4 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Stonecutter);
                    local Workers5 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Alchemist);
                    return Workers1 >= 6 and Workers2 >= 6 and Workers3 >= 6 and Workers4 >= 6 and Workers5 >= 6;
                end,
            },
            [6] = {
                Text = {{de = "Markgraf", en = "Margrave"},
                        {de = "Markgräfin", en = "Margravine"}},
                Costs = {250, 2000, 0, 0, 0, 0, 0},
                Description = "Kathedrale, 50 Arbeiter",
                Condition = function(_PlayerID)
                    local Workers = Logic.GetNumberOfAttractedWorker(_PlayerID);
                    local Castle3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Monastery3);
                    return Castle3 > 0 and Workers >= 50;
                end,
            },
            [7] = {
                Text = {{de = "Herzog", en = "Duke"},
                        {de = "Herzogin", en = "Duchess"}},
                Costs = {300, 3000, 0, 0, 0, 0, 0},
                Description = "Alle Ziergebäude, Zitadelle, 75 Arbeiter",
                Condition = function(_PlayerID)
                    local IsFulfilled = false;
                    if Logic.GetNumberOfAttractedWorker(_PlayerID) >= 75 then
                        local CastleID = GetID(Stronghold.Players[_PlayerID].HQScriptName);
                        if Logic.GetEntityType(CastleID) == Entities.PB_Headquarters3 then
                            IsFulfilled = true;
                            for i= 1, 12 do
                                local Type = "PB_Beautification" .. ((i < 10 and "0"..i) or i);
                                if table.getn(GetValidEntitiesOfType(_PlayerID, Entities[Type])) < 1 then
                                    IsFulfilled = false;
                                    break;
                                end
                            end
                        end
                    end
                    return IsFulfilled;
                end,
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
    Archive.Install();
    Archive.ReloadEntities();

    Syncer.Install(999);
    EntityTracker.Install();
    BuyHero.Install();

    if not CMod then
        Message("The S5 Community Server is required!");
        return false;
    end

    Stronghold:AddDelayedAction(1, function(_PlayerID)
        Stronghold:LoadGUIDelayed(_PlayerID);
    end, GUI.GetPlayerID());
    GUI.SetTaxLevel(0);
    GUI.ClearSelection();
    ResourceType.Honor = 20;

    self.Economy:Install();
    self.Construction:Install();
    self.Building:Install();
    self.UnitConfig:Install();
    self.Recruitment:Install();
    self.Hero:Install();
    self.Unit:Install();
    self.Attraction:Install();
    self.Outlaw:Install();
    self.Province:Install();

    self:StartTurnDelayTrigger();
    self:StartPlayerPaydayUpdater();
    self:StartEntityCreatedTrigger();
    self:StartEntityHurtTrigger();
    self:StartOnEveryTurnTrigger();

    self:OverrideTooltipGenericMain();
    self:OverrideActionBuyMilitaryUnitMain();
    self:OverrideTooltipBuyMilitaryUnitMain();
    self:OverrideActionResearchTechnologyMain();
    self:OverrideTooltipUpgradeSettlersMain();
    self:OverwriteCommonCallbacks();

    self:InitTradeBalancer();

    return true;
end

-- Restore game state after load
function Stronghold:OnSaveGameLoaded()
    if not CMod then
        Message("The S5 Community Server is required!");
        return false;
    end
    Archive.ReloadEntities();

    Stronghold:AddDelayedAction(1, function(_PlayerID)
        Stronghold:LoadGUIDelayed(_PlayerID);
    end, GUI.GetPlayerID());
    GUI.ClearSelection();
    ResourceType.Honor = 20;

    self.Construction:OnSaveGameLoaded();
    self.Building:OnSaveGameLoaded();
    self.UnitConfig:OnSaveGameLoaded();
    self.Recruitment:OnSaveGameLoaded();
    self.Economy:OnSaveGameLoaded();
    self.Hero:OnSaveGameLoaded();
    self.Unit:OnSaveGameLoaded();
    self.Attraction:OnSaveGameLoaded();
    self.Outlaw:OnSaveGameLoaded();
    self.Province:OnSaveGameLoaded();

    return true;
end

function Stronghold:LoadGUIDelayed(_PlayerID)
    if GUI.GetPlayerID() == _PlayerID then
        XGUIEng.SetMaterialTexture("BackGround_Top", 0, gvBasePath.. "graphics/bg_top.png");
        XGUIEng.SetMaterialTexture("BackGround_BottomLeft", 1, gvBasePath.. "graphics/bg_bottom_left.png");
        XGUIEng.SetMaterialTexture("BackGround_BottomTexture", 0, gvBasePath.. "graphics/bg_bottom.png");
        XGUIEng.SetMaterialTexture("TooltipBackground", 1, gvBasePath.. "graphics/bg_tooltip.png");
        Camera.ZoomSetFactorMax(2.0);
    end
end

-- Add player
-- This function adds a new player.
function Stronghold:AddPlayer(_PlayerID)
    local LordName = "LordP" .._PlayerID;
    local HQName = "HQ" .._PlayerID;
    local DoorPosName = "DoorP" .._PlayerID;

    -- Create door pos
    local DoorPos = GetCirclePosition(HQName, 800, 180);
    local ID = Logic.CreateEntity(Entities.XD_ScriptEntity, DoorPos.X, DoorPos.Y, 0, 0);
    Logic.SetEntityName(ID, DoorPosName);

    -- Create player data
    self.Players[_PlayerID] = {
        LordScriptName = LordName,
        HQScriptName = HQName,
        DoorPos = DoorPos;

        TaxHeight = 3,
        Rank = 1,

        ReputationLimit = 200,
        Reputation = 100,
        Honor = 0,
        IncomeHonor = 0,

        InvulnerabilityInfoShown = false,
        VulnerabilityInfoShown = true,
        AttackMemory = {},
    };

    BuyHero.SetNumberOfBuyableHeroes(_PlayerID, 1);
    if CNetwork then
        SendEvent.SetTaxes(_PlayerID, 0);
    end
    self:InitalizePlayer(_PlayerID);
end

function Stronghold:InitalizePlayer(_PlayerID)
    local CampName = "CampP" .._PlayerID;

    -- Create camp Pos
    local CampPos = GetCirclePosition(self.Players[_PlayerID].HQScriptName, 1200, 180);
    ID = Logic.CreateEntity(Entities.XD_Camp_Internal, CampPos.X, CampPos.Y, 0, _PlayerID);
    Logic.SetEntityName(ID, CampName);

    -- Create serfs
    local SerfCount = self.Config.Rule.StartingSerfs;
    for i= 1, SerfCount do
        local SerfPos = GetCirclePosition(CampName, 250, (360/SerfCount) * i);
        ID = Logic.CreateEntity(Entities.PU_Serf, SerfPos.X, SerfPos.Y, 360 - ((360/SerfCount) * i), _PlayerID);
        LookAt(ID, CampName);
    end

    Tools.GiveResouces(
        _PlayerID,
        self.Config.Rule.InitialResources[2],
        self.Config.Rule.InitialResources[3],
        self.Config.Rule.InitialResources[4],
        self.Config.Rule.InitialResources[5],
        self.Config.Rule.InitialResources[6],
        self.Config.Rule.InitialResources[7]
    );
    self:SetPlayerRank(_PlayerID, self.Config.Rule.InitialRank);
    self:AddPlayerHonor(_PlayerID, self.Config.Rule.InitialResources[1]);
end

function Stronghold:GetPlayer(_PlayerID)
    return self.Players[_PlayerID];
end

function Stronghold:GetLocalPlayerID()
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID1 = GUI.GetPlayerID();
    if CNetwork and EntityID ~= 0 and PlayerID1 == 17 then
        local PlayerID2 = Logic.EntityGetPlayer(EntityID);
        if PlayerID1 ~= PlayerID2 then
            return PlayerID2;
        end
    end
    return PlayerID1;
end

function Stronghold:IsPlayer(_PlayerID)
    return self:GetPlayer(_PlayerID) ~= nil;
end

-- -------------------------------------------------------------------------- --
-- Game Callbacks

function GameCallback_Stronghold_OnPayday(_PlayerID)
end

-- -------------------------------------------------------------------------- --
-- Turn Delay

-- Delays an action by the amount of turns.
-- (Sometimes actions must be delayed a turn to work properly.)
function Stronghold:AddDelayedAction(_Delay, _Function, ...)
    table.insert(self.Shared.DelayedAction, {
        StartTime = Logic.GetTimeMs(),
        Delay     = _Delay,
        Action    = _Function,
        Parameter = arg
    });
end

function Stronghold:DelayedActionController()
    for i= table.getn(self.Shared.DelayedAction), 1, -1 do
        local Data = self.Shared.DelayedAction[i];
        if Logic.GetTimeMs() >= Data.StartTime + (Data.Delay * 100) then
            table.remove(self.Shared.DelayedAction, i);
            if Data.Action then
                Data.Action(unpack(Data.Parameter));
            end
        end
    end
end

function Stronghold:StartTurnDelayTrigger()
    function Stronghold_Trigger_TurnDelay()
        Stronghold:DelayedActionController();
    end
    StartSimpleHiResJob("Stronghold_Trigger_TurnDelay");
end

-- -------------------------------------------------------------------------- --
-- Trigger

function Stronghold:StartOnEveryTurnTrigger()
    function Stronghold_Trigger_OnEverySecond()
        for i= 1, table.getn(Score.Player) do
            Stronghold:PlayerDefeatCondition(i);
        end
    end

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_EVERY_SECOND,
        nil,
        "Stronghold_Trigger_OnEverySecond",
        1
    );
end

function Stronghold:StartEntityCreatedTrigger()
    function Stronghold_Trigger_EntityCreated()
        local EntityID = Event.GetEntityID();
        local PlayerID = Logic.EntityGetPlayer(EntityID);

        if Logic.IsBuilding(EntityID) == 1 then
            if GUI.GetPlayerID() == PlayerID then
                Stronghold:OnSelectionMenuChanged(EntityID, GUI.GetSelectedEntity());
            end
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
-- Trade

function Stronghold:InitTradeBalancer()
    local EntityID = Event.GetEntityID();
    local SellTyp = Event.GetSellResource();
    local PurchaseTyp = Event.GetBuyResource();
    local PlayerID = Logic.EntityGetPlayer(EntityID);

    if Logic.GetCurrentPrice(PlayerID, SellTyp) > 1.25 then
        Logic.SetCurrentPrice(PlayerID, SellTyp, 1.25);
    end
    if Logic.GetCurrentPrice(PlayerID, SellTyp) < 0.75 then
        Logic.SetCurrentPrice(PlayerID, SellTyp, 0.75);
    end
    if Logic.GetCurrentPrice(PlayerID, PurchaseTyp) > 1.25 then
        Logic.SetCurrentPrice(PlayerID, PurchaseTyp, 1.25);
    end
    if Logic.GetCurrentPrice(PlayerID, PurchaseTyp) < 0.75 then
        Logic.SetCurrentPrice(PlayerID, PurchaseTyp, 0.75);
    end
end

-- -------------------------------------------------------------------------- --
-- Payday

-- Payday updater
-- The real payday is deactivated. We simultate the payday by using a job the
-- old fashioned way.
function Stronghold:StartPlayerPaydayUpdater()

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

            local TimeLeft = Logic.GetPlayerPaydayTimeLeft(i);
            if TimeLeft > 119900 and TimeLeft <= 120000 then
                Stronghold.Shared.PaydayTriggerFlag[i] = true;
            elseif TimeLeft > 119600 and TimeLeft <= 119900 then
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
        -- First regular payday
        if Logic.GetNumberOfAttractedWorker(_PlayerID) > 0 and Logic.GetTime() > 1 then
            self.Players[_PlayerID].HasHadRegularPayday = true;
        end

        Tools.GiveResouces(_PlayerID, Logic.GetNumberOfLeader(_PlayerID) * 20, 0, 0, 0, 0, 0);
        Tools.GiveResouces(_PlayerID, Stronghold.Economy.Data[_PlayerID].IncomeMoney, 0, 0, 0, 0, 0);
        AddGold(_PlayerID, -Stronghold.Economy.Data[_PlayerID].UpkeepMoney);

        -- Reputation
        local OldReputation = self:GetPlayerReputation(_PlayerID);
        local Reputation = Stronghold.Economy.Data[_PlayerID].IncomeReputation;
        self.Players[_PlayerID].Reputation = OldReputation + Reputation;
        if self.Players[_PlayerID].Reputation > self.Players[_PlayerID].ReputationLimit then
            self.Players[_PlayerID].Reputation = self.Players[_PlayerID].ReputationLimit;
        end
        if self.Players[_PlayerID].Reputation < 0 then
            self.Players[_PlayerID].Reputation = 0;
        end

        -- Attraction
        if self.Players[_PlayerID].Reputation < 50 then
            self.Players[_PlayerID].CivilAttractionLocked = true;
        else
            self.Players[_PlayerID].CivilAttractionLocked = false;
        end

        -- Motivation
        self:AddDelayedAction(1, function()
            Stronghold:UpdateMotivationOfWorkers(_PlayerID);
            Stronghold:ControlReputationAttractionPenalty(_PlayerID);
        end);

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

        local Language = GetLanguage();
        local Text = self.Config.Ranks[Rank].Text[Gender][Language];
        if type (Text) == "table" then
            Text = Text[Language];
        end
        return Text;
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
            Sound.PlayGUISound(Sounds.OnKlick_Select_pilgrim, 100);
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
        if IsExisting(self.Players[_PlayerID].LordScriptName) then
            local Rank = self:GetPlayerRank(_PlayerID);
            if Rank == 0 or Rank >= self.Config.Rule.MaxRank then
                return false;
            end
            return self.Config.Ranks[Rank +1].Condition(_PlayerID);
        end
    end
    return false;
end

-- -------------------------------------------------------------------------- --
-- Honor

function Stronghold:AddPlayerHonor(_PlayerID, _Amount)
    if self:IsPlayer(_PlayerID) then
        self.Players[_PlayerID].Honor = self.Players[_PlayerID].Honor + _Amount;
        if self.Players[_PlayerID].Honor > self.Config.Rule.MaxHonor then
            self.Players[_PlayerID].Honor = self.Config.Rule.MaxHonor;
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
        _Amount = _Amount or self:GetPlayerReputation(_PlayerID);
        _Amount = math.min(_Amount, self.Players[_PlayerID].ReputationLimit);
        _Amount = math.max(_Amount, 30);

        local WorkerList = GetAllWorker(_PlayerID);
        for i= 1, table.getn(WorkerList) do
            CEntity.SetMotivation(WorkerList[i], _Amount / 100);
        end
    end
end

function Stronghold:ControlReputationAttractionPenalty(_PlayerID)
    local Reputation = self:GetPlayerReputation(_PlayerID);
    local WorkerList = GetAllWorker(_PlayerID);
    local WorkerAmount = table.getn(WorkerList);
    local LeaveAmount = 0;

    -- Restore reputation when workers are all gone
    if  self.Players[_PlayerID].HasHadRegularPayday
    and Logic.GetNumberOfAttractedWorker(_PlayerID) == 0 then
        self:SetPlayerReputation(_PlayerID, math.min(Reputation +12, 75));
        return;
    end

    if Reputation <= 30 then
        -- Get all not already leaving workers
        for i= table.getn(WorkerList), 1, -1 do
            if Logic.GetCurrentTaskList(WorkerList[i]) == "TL_WORKER_LEAVE" then
                table.remove(WorkerList, i);
            end
        end

        -- Make workers leave
        WorkerAmount = table.getn(WorkerList);
        LeaveAmount = math.ceil(WorkerAmount * 0.75);
        while LeaveAmount > 0 do
            if table.getn(WorkerList) == 0 then
                break;
            end
            local ID = table.remove(WorkerList, math.random(1, WorkerAmount));
            Logic.SetTaskList(ID, TaskLists.TL_WORKER_LEAVE);
            WorkerAmount = table.getn(WorkerList);
            LeaveAmount = LeaveAmount -1;
        end
    end
end

-- -------------------------------------------------------------------------- --
-- UI Update

-- Menu update
-- This calls all updates of the selection menu when selection has changed.
function Stronghold:OnSelectionMenuChanged(_EntityID)
    local GuiPlayer = self:GetLocalPlayerID();
    local SelectedID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if GuiPlayer ~= 17 and GuiPlayer ~= PlayerID then
        return;
    end

    self.Hero:OnSelectLeader(SelectedID);
    self.Hero:OnSelectHero(SelectedID);

    self.Building:OnHeadquarterSelected(SelectedID);
    self.Building:OnMonasterySelected(SelectedID);

    self.Recruitment:OnBarracksSelected(SelectedID);
    self.Recruitment:OnArcherySelected(SelectedID);
    self.Recruitment:OnStableSelected(SelectedID);
    self.Recruitment:OnFoundrySelected(SelectedID);
    self.Recruitment:OnTavernSelected(SelectedID);

    -- self.Economy:ShowHeadquartersDetail(GuiPlayer);
end

function Stronghold:OverwriteCommonCallbacks()
    Overwrite.CreateOverwrite("GameCallback_GUI_SelectionChanged", function()
        Overwrite.CallOriginal();
        local EntityID = GUI.GetSelectedEntity();
        Stronghold:OnSelectionMenuChanged(EntityID);
    end);

    Overwrite.CreateOverwrite("GameCallback_OnBuildingConstructionComplete", function(_EntityID, _PlayerID)
        Overwrite.CallOriginal();
        Stronghold:OnSelectionMenuChanged(_EntityID);
    end);

    Overwrite.CreateOverwrite("GameCallback_OnBuildingUpgradeComplete", function(_EntityIDOld, _EntityIDNew)
        Overwrite.CallOriginal();
        -- Fixes the problem with the building attraction. The currend amount
        -- will be red and then set. After that all workers are reattached.
        local PlayerID = Logic.EntityGetPlayer(_EntityIDNew);
        local Workers = {Logic.GetAttachedWorkersToBuilding(_EntityIDNew)};
        Stronghold.Attraction:SetBuildingCurrentWorkerAmount(_EntityIDNew, Workers[1]);
        Logic.PlayerReAttachAllWorker(PlayerID);
        Stronghold:OnSelectionMenuChanged(_EntityIDNew);
    end);

    Overwrite.CreateOverwrite("GameCallback_OnTechnologyResearched", function(_PlayerID, _Technology, _EntityID)
        Overwrite.CallOriginal();
        Stronghold:OnSelectionMenuChanged(_EntityID);
    end);

    Overwrite.CreateOverwrite("GameCallback_OnCannonConstructionComplete", function(_BuildingID)
        Overwrite.CallOriginal();
        Stronghold:OnSelectionMenuChanged(_BuildingID);
    end);

    Overwrite.CreateOverwrite("GameCallback_OnTransactionComplete", function(_BuildingID)
        Overwrite.CallOriginal();
        Stronghold:OnSelectionMenuChanged(_BuildingID);
    end);

    ---

	self.Orig_Mission_OnSaveGameLoaded = Mission_OnSaveGameLoaded;
	Mission_OnSaveGameLoaded = function()
		Stronghold.Orig_Mission_OnSaveGameLoaded();
        Stronghold:OnSaveGameLoaded();
	end
end

-- Tooptip Generic Override
function Stronghold:OverrideTooltipGenericMain()
    Overwrite.CreateOverwrite( "GUITooltip_Generic", function(_Key)
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        Overwrite.CallOriginal();
        Stronghold.Economy:PrintTooltipGenericForFindView(PlayerID, _Key);
    end);

    Overwrite.CreateOverwrite("GUITooltip_Generic", function(_Key)
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        Overwrite.CallOriginal();
        Stronghold.Economy:PrintTooltipGenericForEcoGeneral(PlayerID, _Key);
    end);

    Overwrite.CreateOverwrite("GUITooltip_Generic", function(_Key)
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        Overwrite.CallOriginal();
        Stronghold.Building:PrintHeadquartersTaxButtonsTooltip(PlayerID, EntityID, _Key);
    end);

    Overwrite.CreateOverwrite("GUITooltip_Generic", function(_Key)
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        Overwrite.CallOriginal();
        Stronghold.Building:HeadquartersBuildingTabsGuiTooltip(PlayerID, EntityID, _Key);
    end);
end

-- Action research technology Override
function Stronghold:OverrideActionResearchTechnologyMain()
    Overwrite.CreateOverwrite("GUIAction_ReserachTechnology", function(_Technology)
        if not Stronghold.Recruitment:OnBarracksSettlerUpgradeTechnologyClicked(_Technology) then
            Overwrite.CallOriginal();
        end
    end);

    Overwrite.CreateOverwrite("GUIAction_ReserachTechnology", function(_Technology)
        if not Stronghold.Recruitment:OnArcherySettlerUpgradeTechnologyClicked(_Technology) then
            Overwrite.CallOriginal();
        end
    end);

    Overwrite.CreateOverwrite("GUIAction_ReserachTechnology", function(_Technology)
        if not Stronghold.Recruitment:OnStableSettlerUpgradeTechnologyClicked(_Technology) then
            Overwrite.CallOriginal();
        end
    end);
end

-- Tooptip Upgrade Settlers Override
function Stronghold:OverrideTooltipUpgradeSettlersMain()
    Overwrite.CreateOverwrite("GUITooltip_ResearchTechnologies", function(_Technology, _TextKey, _ShortCut)
        local PlayerID = Stronghold:GetLocalPlayerID();
        Overwrite.CallOriginal();
        Stronghold.Recruitment:UpdateUpgradeSettlersBarracksTooltip(PlayerID, _Technology, _TextKey, _ShortCut);
    end);

    Overwrite.CreateOverwrite("GUITooltip_ResearchTechnologies", function(_Technology, _TextKey, _ShortCut)
        local PlayerID = Stronghold:GetLocalPlayerID();
        Overwrite.CallOriginal();
        Stronghold.Recruitment:UpdateUpgradeSettlersArcheryTooltip(PlayerID, _Technology, _TextKey, _ShortCut);
    end);

    Overwrite.CreateOverwrite("GUITooltip_ResearchTechnologies", function(_Technology, _TextKey, _ShortCut)
        local PlayerID = Stronghold:GetLocalPlayerID();
        Overwrite.CallOriginal();
        Stronghold.Recruitment:UpdateUpgradeSettlersStableTooltip(PlayerID, _Technology, _TextKey, _ShortCut);
    end);
end

function Stronghold:OverrideActionBuyMilitaryUnitMain()
    Overwrite.CreateOverwrite("GUIAction_BuyMilitaryUnit", function(_UpgradeCategory)
        if not Stronghold.Recruitment:BuyMilitaryUnitFromTavernAction(_UpgradeCategory) then
            Overwrite.CallOriginal();
        end
    end);

    Overwrite.CreateOverwrite("GUIAction_BuyCannon", function(_Type, _UpgradeCategory)
        if not Stronghold.Recruitment:BuyMilitaryUnitFromFoundryAction(_Type, _UpgradeCategory) then
            Overwrite.CallOriginal();
        end
    end);
end

function Stronghold:OverrideTooltipBuyMilitaryUnitMain()
    self.Orig_GUITooltip_BuyMilitaryUnit = GUITooltip_BuyMilitaryUnit;
    GUITooltip_BuyMilitaryUnit = function(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
        local PlayerID = Stronghold:GetLocalPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Orig_GUITooltip_BuyMilitaryUnit(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end

        local TooltipSet = false;
        if not TooltipSet then
            TooltipSet = Stronghold.Recruitment:UpdateTavernBuyUnitTooltip(PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
        if not TooltipSet then
            TooltipSet = Stronghold.Recruitment:UpdateFoundryBuyUnitTooltip(PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
        if not TooltipSet then
            Stronghold.Orig_GUITooltip_BuyMilitaryUnit(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
    end
end


