---
--- Synchronizer script
---
--- This script provides synchronized calls for Multiplayer.
---
--- If the map is played in Singleplayer then each call is executed directly.
---
--- If played in Multiplayer the script automatically reconizes the community
--- server and uses its API. If the server methods are not defined the script
--- uses tributes and messages for synchronization.
---
--- TODO: Not compatible with EMS.
---

Stronghold = Stronghold or {};

Stronghold.Sync = {
    Data = {},
    Transaction = {
        Transactions = {},
        TransactionParameter = {},
        UniqueActionCounter = 1,
        UniqueTributeCounter = 999,
    },
};

-- -------------------------------------------------------------------------- --
-- API

-- Creates an script event and returns the event ID. Use the ID to call the
-- created event.
function CreateSyncEvent(_Function)
    return Stronghold.Sync:CreateSyncEvent(_Function);
end

-- Removes an script event.
function DeleteSyncEvent(_ID)
    return Stronghold.Sync:DeleteSyncEvent(_ID);
end

-- Calls the script event synchronous for all players.
function SynchronizedCall(_ID, ...)
    return Stronghold.Sync:Call(_ID, unpack(arg));
end

-- Checks if the current mission is running as a Multiplayer game.
function IsMultiplayerGame()
    return Stronghold.Sync:IsMultiplayerGame();
end

-- Returns true, if the copy of the game is the History Edition.
function IsHistoryEdition()
    return Stronghold.Sync:IsHistoryEdition();
end

-- Returns true, if the game runs on the community server.
function IsCNetwork()
    return Stronghold.Sync:IsCNetwork();
end

-- Returns true, if the copy of the game is the original version.
function IsOriginal()
    return Stronghold.Sync:IsOriginal();
end

-- Returns true, if the game is properly patched to version 1.06.0217.
-- If the copy of the game is History Edition than it is assumed that the
-- game has been patched.
function IsPatched()
    return Stronghold.Sync:IsPatched();
end

-- Returns true, if the player on this ID is active.
function IsPlayerActive(_PlayerID)
    return Stronghold.Sync:IsPlayerActive(_PlayerID);
end

-- Returns the player ID of the host.
function GetHostPlayerID()
    return Stronghold.Sync:GetHostPlayerID();
end

-- Returns true, if the player is the host.
function IsPlayerHost(_PlayerID)
    return Stronghold.Sync:IsPlayerHost(_PlayerID);
end

-- Returns the number of human players.
-- (In Singleplayer this will always be 1!)
function GetActivePlayers()
    return Stronghold.Sync:GetActivePlayers();
end

-- Returns all active teams.
function GetActiveTeams()
    return Stronghold.Sync:GetActiveTeams();
end

-- Returns the team the player is in.
function GetTeamOfPlayer(_PlayerID)
    return Stronghold.Sync:GetTeamOfPlayer(_PlayerID);
end

-- -------------------------------------------------------------------------- --
-- Main

function Stronghold.Sync:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    if XNetwork.Manager_DoesExist() == 1 then
        self:OverrideMessageReceived();
        self:ActivateTributePaidTrigger();
    end
end

function Stronghold.Sync:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --
-- Logic

function Stronghold.Sync:CreateSyncEvent(_Function)
    self.Transaction.UniqueActionCounter = self.Transaction.UniqueActionCounter +1;
    local ActionIndex = self.Transaction.UniqueActionCounter;

    -- Network handler for community server
    local NetworkHandler = function(name, _ID, _PlayerID, ...)
        if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
            Stronghold.Sync.Data[_ID].Function(_PlayerID, unpack(arg));
        end
    end

    self.Data[ActionIndex] = {
        Function = _Function,
        CNetwork = "Stronghold_Synchronization_CNetworkHandler_" .. self.Transaction.UniqueActionCounter;
    };
    if CNetwork then
        CNetwork.SetNetworkHandler(
            self.Data[ActionIndex].CNetwork,
            NetworkHandler
        );
    end
    return self.Transaction.UniqueActionCounter;
end

function Stronghold.Sync:DeleteSyncEvent(_ID)
    if _ID and self.Data[_ID] then
        self.Data[_ID] = nil;
    end
end

function Stronghold.Sync:Call(_ID, ...)
    arg = arg or {};
    if XNetwork.Manager_DoesExist() == 1 then
        if CNetwork then
            local Name = self.Data[_ID].CNetwork;
            CNetwork.SendCommand(Name, _ID, unpack(arg));
        else
            local PlayerID = GUI.GetPlayerID();
            local Time = Logic.GetTimeMs();
            local Msg = "";
            if table.getn(arg) > 0 then
                for i= 1, table.getn(arg), 1 do
                    Msg = Msg .. tostring(arg[i]) .. ":::";
                end
            end
            self:TransactionSend(_ID, PlayerID, Time, Msg, arg);
        end
        return;
    end
    self.Data[_ID].Function(unpack(arg));
end

function Stronghold.Sync:IsMultiplayerGame()
    return XNetwork.Manager_DoesExist() == 1;
end

function Stronghold.Sync:IsHistoryEdition()
    return XNetwork.Manager_IsNATReady ~= nil;
end

function Stronghold.Sync:IsCNetwork()
    return CNetwork ~= nil;
end

function Stronghold.Sync:IsOriginal()
    return not self:IsHistoryEdition() and not self:IsCNetwork();
end

function Stronghold.Sync:IsPatched()
    if not self:IsOriginal() then
        return true;
    end
    return string.find(Framework.GetProgramVersion(), "1.06.0217") ~= nil;
end

function Stronghold.Sync:IsPlayerActive(_PlayerID)
    local Players = {};
    if self:IsMultiplayerGame() then
        return Logic.PlayerGetGameState(_PlayerID) == 1;
    end
    return _PlayerID == GUI.GetPlayerID();
end

function Stronghold.Sync:GetHostPlayerID()
    if self:IsMultiplayerGame() then
        for k, v in pairs(self:GetActivePlayers()) do
            local HostNetworkAddress   = XNetwork.Host_UserInSession_GetHostNetworkAddress();
            local PlayerNetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID(v);
            if HostNetworkAddress == PlayerNetworkAddress then
                return v;
            end
        end
    end
    return GUI.GetPlayerID();
end

function Stronghold.Sync:IsPlayerHost(_PlayerID)
    if self:IsMultiplayerGame() then
        local HostNetworkAddress   = XNetwork.Host_UserInSession_GetHostNetworkAddress();
        local PlayerNetworkAddress = XNetwork.GameInformation_GetNetworkAddressByPlayerID(_PlayerID);
        return HostNetworkAddress == PlayerNetworkAddress;
    end
    return true;
end

function Stronghold.Sync:GetActivePlayers()
    local Players = {};
    if self:IsMultiplayerGame() then
        -- TODO: Does that fix everything for Community Server?
        for i= 1, table.getn(Score.Player), 1 do
            if Logic.PlayerGetGameState(i) == 1 then
                table.insert(Players, i);
            end
        end
    else
        table.insert(Players, GUI.GetPlayerID());
    end
    return Players;
end

function Stronghold.Sync:GetActiveTeams()
    if self:IsMultiplayerGame() then
        local Teams = {};
        for k, v in pairs(self:GetActivePlayers()) do
            local Team = self:GetTeamOfPlayer(v);
            if not IsInTable(Team, Teams) then
                table.insert(Teams, Team);
            end
        end
        return Teams;
    else
        return {1};
    end
end

function Stronghold.Sync:GetTeamOfPlayer(_PlayerID)
    if self:IsMultiplayerGame() then
        return XNetwork.GameInformation_GetPlayerTeam(_PlayerID);
    else
        return _PlayerID;
    end
end

-- -------------------------------------------------------------------------- --
-- Traditional Synchronization
-- From here on out the traditional method for synchronization is implemented.
-- This will NOT be used on the community server!

function Stronghold.Sync:ActivateTributePaidTrigger()
    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_TRIBUTE_PAID,
        nil,
        "Stronghold_Sync_Trigger_OnTributePaid",
        1
    );
end

function Stronghold.Sync:ActivateEveryTurnTrigger(_PlayerID, _ID, _Hash, _Time, ...)
    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_EVERY_TURN,
        nil,
        "Stronghold_Sync_Trigger_OnEveryTurn",
        1,
        {},
        {_PlayerID, _ID, _Hash, Logic.GetTime(), unpack(arg)}
    );
end

function Stronghold.Sync:TransactionSend(_ID, _PlayerID, _Time, _Msg, _Parameter)
    -- Create message
    _Msg = _Msg or "";
    local PreHashedMsg = "".._ID..":::" .._PlayerID..":::" .._Time.. ":::" .._Msg;
    local Hash = _ID.. "_" .._PlayerID.. "_" .._Time;
    local TransMsg = "___MPTransact:::"..Hash..":::" ..PreHashedMsg;
    self.Transaction.Transactions[Hash] = {};
    -- Send message
    if self:IsMultiplayerGame() then
        XNetwork.Chat_SendMessageToAll(TransMsg);
    else
        MPGame_ApplicationCallback_ReceivedChatMessage(TransMsg, 0, _PlayerID);
    end
    -- Wait for ack
    self:ActivateEveryTurnTrigger(_PlayerID, _ID, Hash, Logic.GetTime(), unpack(_Parameter));
end

function Stronghold.Sync:TransactionAcknowledge(_Hash, _Time)
    -- Create message
    local PlayerID = GUI.GetPlayerID();
    local TransMsg = "___MPAcknowledge:::" .._Hash.. ":::" ..PlayerID.. ":::" .._Time.. ":::";
    -- Send message
    if self:IsMultiplayerGame() then
        XNetwork.Chat_SendMessageToAll(TransMsg);
    else
        MPGame_ApplicationCallback_ReceivedChatMessage(TransMsg, 0, PlayerID);
    end
end

function Stronghold.Sync:TransactionManage(_Type, _Msg)
    -- Handle received request
    if _Type == 1 then
        local Parameters      = self:TransactionSplitMessage(_Msg);
        local Hash            = table.remove(Parameters, 1);
        local Action          = table.remove(Parameters, 1);
        local SendingPlayerID = table.remove(Parameters, 1);
        local Timestamp       = table.remove(Parameters, 1);
        if SendingPlayerID ~= GUI.GetPlayerID() then
            self:TransactionAcknowledge(Hash, Timestamp);
            Stronghold.Sync:CreateTribute(SendingPlayerID, Action, unpack(Parameters));
        end
    -- Handle received client ack
    elseif _Type == 2 then
        local Parameters = self:TransactionSplitMessage(_Msg);
        local Hash       = table.remove(Parameters, 1);
        local PlayerID   = table.remove(Parameters, 1);
        local Timestamp  = table.remove(Parameters, 1);
        self.Transaction.Transactions[Hash] = self.Transaction.Transactions[Hash] or {};
        self.Transaction.Transactions[Hash][PlayerID] = true;
    end
end

function Stronghold.Sync:TransactionSplitMessage(_Msg)
    local MsgParts = {};
    local Msg = _Msg;
    repeat
        local s, e = string.find(Msg, ":::");
        local PartString = string.sub(Msg, 1, s-1);
        local PartNumber = tonumber(PartString);
        local Part = (PartNumber ~= nil and PartNumber) or PartString;
        table.insert(MsgParts, Part);
        Msg = string.sub(Msg, e+1);
    until Msg == "";
    return MsgParts;
end

function Stronghold.Sync:CreateTribute(_PlayerID, _ID, ...)
    self.Transaction.UniqueTributeCounter = self.Transaction.UniqueTributeCounter +1;
    Logic.AddTribute(_PlayerID, self.Transaction.UniqueTributeCounter, 0, 0, "", {[ResourceType.Gold] = 0});
    self.Transaction.TransactionParameter[self.Transaction.UniqueTributeCounter] = {
        Action    = _ID,
        Parameter = CopyTable(arg),
    };
    return self.Transaction.UniqueTributeCounter;
end

function Stronghold.Sync:PayTribute(_PlayerID, _TributeID)
    GUI.PayTribute(_PlayerID, _TributeID);
end

function Stronghold.Sync:OverrideMessageReceived()
    if self.IsActive then
        return true;
    end
    self.IsActive = true;

    self.Orig_MPGame_ApplicationCallback_ReceivedChatMessage = MPGame_ApplicationCallback_ReceivedChatMessage
    MPGame_ApplicationCallback_ReceivedChatMessage = function(_Message, _AlliedOnly, _SenderPlayerID)
        -- Receive transaction
        local s, e = string.find(_Message, "___MPTransact:::");
        if e then
            Stronghold.Sync:TransactionManage(1, string.sub(_Message, e+1));
            return;
        end
        -- Receive ack
        local s, e = string.find(_Message, "___MPAcknowledge:::");
        if e then
            Stronghold.Sync:TransactionManage(2, string.sub(_Message, e+1));
            return;
        end
        -- Execute callback
        Stronghold.Sync.Orig_MPGame_ApplicationCallback_ReceivedChatMessage(_Message, _AlliedOnly, _SenderPlayerID);
    end
end

function Stronghold.Sync:OnTributePaidTrigger(_ID)
    if self.Transaction.TransactionParameter[_ID] then
        local ActionID  = self.Transaction.TransactionParameter[_ID].Action;
        local Parameter = self.Transaction.TransactionParameter[_ID].Parameter;
        if self.Data[ActionID] then
            self.Data[ActionID].Function(unpack(Parameter));
        end
    end
end

function Stronghold.Sync:OnAcknowlegementReceivedTrigger(_PlayerID, _ID, _Hash, _Time, ...)
    arg = arg or {};
    if _Time +2 < Logic.GetTime() then
        return true;
    end
    local Msg = table.remove(arg);
    local Parameter = {unpack(arg)};

    local ActivePlayers = Stronghold.Sync:GetActivePlayers();
    local AllAcksReceived = true;
    for i= 1, table.getn(ActivePlayers), 1 do
        if _PlayerID ~= ActivePlayers[i] and not self.Transaction.Transactions[_Hash][ActivePlayers[i]] then
            AllAcksReceived = false;
        end
    end
    if AllAcksReceived == true then
        table.insert(Parameter, 1, -1);
        local ID = Stronghold.Sync:CreateTribute(_PlayerID, _ID, unpack(Parameter));
        Stronghold.Sync:PayTribute(_PlayerID, ID);
        return true;
    end
end

function Stronghold_Sync_Trigger_OnEveryTurn(_PlayerID, _ID, _Hash, _Time, ...)
    Stronghold.Sync:OnAcknowlegementReceivedTrigger(_PlayerID, _ID, _Hash, _Time, unpack(arg));
end

function Stronghold_Sync_Trigger_OnTributePaid()
    Stronghold.Sync:OnTributePaidTrigger(Event.GetTributeUniqueID());
end

