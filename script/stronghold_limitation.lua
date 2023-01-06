-- 
-- Entity Limitaions
--
-- Any entity type can be tracked whit this. The script only tracks the types
-- configured in the limits table. Changes in the UI aka disableing buttons ect.
-- must be done by the scripts using this.
--
-- GameCallback_GUI_SelectionChanged is called by code if an configured type
-- is created/destroyed or an building upgrade is started/canceled.
-- 

Stronghold = Stronghold or {};

Stronghold.Limitation = {
    Data = {},
    Config = {
        Limits = {
            [Entities.PB_Beautification04] = 4,
            [Entities.PB_Beautification06] = 4,
            [Entities.PB_Beautification09] = 4,
            ---
            [Entities.PB_Beautification01] = 3,
            [Entities.PB_Beautification02] = 3,
            [Entities.PB_Beautification12] = 3,
            ---
            [Entities.PB_Beautification05] = 2,
            [Entities.PB_Beautification07] = 2,
            [Entities.PB_Beautification08] = 2,
            ---
            [Entities.PB_Beautification03] = 1,
            [Entities.PB_Beautification10] = 1,
            [Entities.PB_Beautification11] = 1,
            ---
            [Entities.PB_Monastery1] = 1,
            [Entities.PB_Monastery2] = 1,
            [Entities.PB_Monastery3] = 1,
            ---
            [Entities.PB_Market2] = 1,
            [Entities.PB_Tavern1] = 6,
            [Entities.PB_Tavern2] = 3,
            [Entities.PB_Farm2] = 8,
            [Entities.PB_Farm3] = 4,
            [Entities.PB_Residence2] = -1,
            [Entities.PB_Residence3] = 8,
            ---
            [Entities.PB_Barracks1] = 3,
            [Entities.PB_Barracks2] = 1,
            [Entities.PB_Archery1] = 3,
            [Entities.PB_Archery2] = 1,
            [Entities.PB_Stable1] = 3,
            [Entities.PB_Stable2] = 1,
        },
    },
}

-- -------------------------------------------------------------------------- --
-- API

-- Must be called to setup tracking
function Stronghold.Limitation:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {
            Potential = {},
            Current = {},
        };
    end

    self:SetupSynchronization();
    self:OverrideUpgradeBuilding();
    self:StartTriggers();
end

-- Must be called on savegame loaded
function Stronghold.Limitation:OnSaveGameLoaded()
    self:OverrideUpgradeBuilding();
end

-- Checks if the limit is reached
function Stronghold.Limitation:IsTypeLimitReached(_PlayerID, _Type)
    if self.Data[_PlayerID] then
        local Limit = self:GetTypeLimit(_Type);
        if Limit > -1 then
            return self:GetTypeUsage(_PlayerID, _Type) >= Limit;
        end
    end
    return false;
end

-- Returns the amount currently tracked entities
function Stronghold.Limitation:GetTypeUsage(_PlayerID, _Type)
    local Amount = 0;
    if self.Data[_PlayerID] then
        if self.Data[_PlayerID].Potential[_Type] then
            Amount = Amount + table.getn(self.Data[_PlayerID].Potential[_Type]);
        end
        if self.Data[_PlayerID].Current[_Type] then
            Amount = Amount + table.getn(self.Data[_PlayerID].Current[_Type]);
        end
    end
    return Amount;
end

-- Sets a limit for the type
-- -1   No limit
--  0   Forbidden
-- >0   Limit
function Stronghold.Limitation:SetTypeLimit(_Type, _Limit)
    self.Config.Limits[_Type] = _Limit;
end

-- Returns thelimit for the type
-- -1   No limit
--  0   Forbidden
-- >0   Limit
function Stronghold.Limitation:GetTypeLimit(_Type)
    if self.Config.Limits[_Type] then
        return self.Config.Limits[_Type];
    end
    return -1;
end

-- -------------------------------------------------------------------------- --
-- Logic

function Stronghold.Limitation:SetupSynchronization()
    self.SyncEvent = {
        UpgradeStarted = 1,
        UpgradeCanceled = 2,
    };

    function Stronghold_Limitation_SyncEvent(_PlayerID, _Action, ...)
        if _Action == Stronghold.Limitation.SyncEvent.UpgradeStarted then
            Stronghold.Limitation:OnUpgradeStarted(_PlayerID, arg[1]);
        end
        if _Action == Stronghold.Limitation.SyncEvent.UpgradeCanceled then
            Stronghold.Limitation:OnUpgradeCanceled(_PlayerID, arg[1]);
        end
    end
    if CNetwork then
        CNetwork.SetNetworkHandler("Stronghold_Limitation_SyncEvent",
            function(name, _PlayerID, _Action, ...)
                if CNetwork.IsAllowedToManipulatePlayer(name, _PlayerID) then
                    Stronghold_Limitation_SyncEvent(_PlayerID, _Action, unpack(arg));
                end;
            end
        );
    end;
end

function Stronghold.Limitation:OnEntityCreated(_PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        local Type = Logic.GetEntityType(_EntityID);
        self:AddToList("Current", Type, _PlayerID, _EntityID);
        self:UpdateSelectionBuildingUpgradeButtons(_PlayerID, _EntityID);
        self:UpdateSelectionSerfConstrucButtons(_PlayerID);
    end
end

function Stronghold.Limitation:OnEntityDestroyed(_PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        local Type = Logic.GetEntityType(_EntityID);
        self:RemoveFromList("Potential", Type +1, _PlayerID, _EntityID);
        self:RemoveFromList("Potential", Type, _PlayerID, _EntityID);
        self:RemoveFromList("Current", Type, _PlayerID, _EntityID);
        self:UpdateSelectionBuildingUpgradeButtons(_PlayerID, _EntityID);
        self:UpdateSelectionSerfConstrucButtons(_PlayerID);
    end
end

function Stronghold.Limitation:OnUpgradeStarted(_PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        local Type = Logic.GetEntityType(_EntityID);
        self.Data[_PlayerID].UpgradeBuildingLock = false;
        self:AddToList("Potential", Type +1, _PlayerID, _EntityID);
        self:RemoveFromList("Current", Type, _PlayerID, _EntityID);
        -- self:UpdateSelectionBuildingUpgradeButtons(_PlayerID, _EntityID);
        -- self:UpdateSelectionSerfConstrucButtons(_PlayerID);
    end
end

function Stronghold.Limitation:OnUpgradeCanceled(_PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        local Type = Logic.GetEntityType(_EntityID);
        self:RemoveFromList("Potential", Type +1, _PlayerID, _EntityID);
        self:AddToList("Current", Type, _PlayerID, _EntityID);
        self:UpdateSelectionBuildingUpgradeButtons(_PlayerID, _EntityID);
        self:UpdateSelectionSerfConstrucButtons(_PlayerID);
    end
end

function Stronghold.Limitation:AddToList(_ListName, _Type, _PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        if not self.Data[_PlayerID][_ListName][_Type] then
            self.Data[_PlayerID][_ListName][_Type] = {};
        end
        if not self:IsEntityInList(_ListName, _PlayerID, _EntityID) then
            table.insert(self.Data[_PlayerID][_ListName][_Type], _EntityID);
        end
    end
end

function Stronghold.Limitation:RemoveFromList(_ListName, _Type, _PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        if self.Data[_PlayerID][_ListName][_Type] then
            for i= table.getn(self.Data[_PlayerID][_ListName][_Type]), 1, -1 do
                if self.Data[_PlayerID][_ListName][_Type][i] == _EntityID then
                    table.remove(self.Data[_PlayerID][_ListName][_Type], i);
                    return;
                end
            end
        end
    end
end

function Stronghold.Limitation:IsEntityInList(_ListName, _PlayerID, _EntityID)
    if self.Data[_PlayerID] then
        local Type = Logic.GetEntityType(_EntityID);
        if self.Data[_PlayerID][_ListName][Type] then
            for i= 1, table.getn(self.Data[_PlayerID][_ListName][Type]) do
                if self.Data[_PlayerID][_ListName][Type][i] == _EntityID then
                    return true;
                end
            end
        end
    end
    return false;
end

-- -------------------------------------------------------------------------- --
-- UI

function Stronghold.Limitation:UpdateSelectionSerfConstrucButtons(_PlayerID)
    if GUI.GetPlayerID() == _PlayerID then
        local SelectedID = GUI.GetSelectedEntity();
        if Logic.GetEntityType(SelectedID) == Entities.PU_Serf then
            if XGUIEng.IsButtonHighLighted(gvGUI_WidgetID.ToSerfBeatificationMenu) == 0 then
                GUIUpdate_BuildingButtons("Build_Beautification01", Technologies.B_Beautification01);
                GUIUpdate_BuildingButtons("Build_Beautification02", Technologies.B_Beautification02);
                for i= 3, 12 do
                    local Num = (i < 10 and "0" ..i) or i;
                    GUIUpdate_UpgradeButtons("Build_Beautification" ..Num, Technologies["B_Beautification" ..Num]);
                end
            else
                GUI.DeselectEntity(SelectedID);
                GUI.SelectEntity(SelectedID);
            end
        end
    end
end

function Stronghold.Limitation:UpdateSelectionBuildingUpgradeButtons(_PlayerID, _EntityID)
    if GUI.GetPlayerID() == _PlayerID then
        local SelectedID = GUI.GetSelectedEntity();
        if _EntityID == SelectedID and Logic.IsBuilding(SelectedID) == 1 then
            GUI.DeselectEntity(SelectedID);
            GUI.SelectEntity(SelectedID);
        end
    end
end

function Stronghold.Limitation:OverrideUpgradeBuilding()
    self.GUI_UpgradeSingleBuilding = GUI.UpgradeSingleBuilding;
    GUI.UpgradeSingleBuilding = function(_EntityID)
        local PlayerID = Logic.EntityGetPlayer(_EntityID);
        if not Stronghold.Limitation.Data[PlayerID] then
            return Stronghold.Limitation.GUI_UpgradeSingleBuilding(_EntityID);
        end

        -- Upgrade only if not waiting for server response
        -- (Prevent framerate and pause abuse)
        if not Stronghold.Limitation.Data[PlayerID].UpgradeBuildingLock then
            Stronghold.Limitation.Data[PlayerID].UpgradeBuildingLock = true;
            Stronghold.Limitation.GUI_UpgradeSingleBuilding(_EntityID);

            Sync.Call(
                "Stronghold_Limitation_SyncEvent",
                PlayerID,
                Stronghold.Limitation.SyncEvent.UpgradeStarted,
                _EntityID
            );
        end
    end

    self.Orig_GUIAction_UpgradeSelectedBuilding = GUIAction_UpgradeSelectedBuilding;
	GUIAction_UpgradeSelectedBuilding = function()
		local EntityID = GUI.GetSelectedEntity();
		local Type = Logic.GetEntityType(EntityID);

        if InterfaceTool_IsBuildingDoingSomething(EntityID) == true then
            return;
        end
        if Logic.IsAlarmModeActive(EntityID) == true then
            GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_StoptAlarmFirst"));
            return;
        end
        local LeadersTrainingAtMilitaryBuilding = Logic.GetLeaderTrainingAtBuilding(EntityID);
        if LeadersTrainingAtMilitaryBuilding ~= 0 then
            GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/GUI_UpgradeNotPossibleBecauseOfTraining"))
            return;
        end

        gvGUI_UpdateButtonIDArray[EntityID] = XGUIEng.GetCurrentWidgetID();
        Logic.FillBuildingUpgradeCostsTable(Type, InterfaceGlobals.CostTable);
        if InterfaceTool_HasPlayerEnoughResources_Feedback(InterfaceGlobals.CostTable) == 1 then
            GUI.UpgradeSingleBuilding(EntityID);
            XGUIEng.ShowWidget(gvGUI_WidgetID.UpgradeInProgress, 1);
            XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame);
        end
	end
end

-- -------------------------------------------------------------------------- --
-- Trigger

function Stronghold.Limitation:StartTriggers()
    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_ENTITY_CREATED,
        nil,
        "Stronghold_Limitation_Trigger_EntityCreated",
        1
    );

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_ENTITY_DESTROYED,
        nil,
        "Stronghold_Limitation_Trigger_EntityDestroyed",
        1
    );

    self.GUIAction_CancelUpgrade = GUIAction_CancelUpgrade;
    GUIAction_CancelUpgrade = function()
        Stronghold.Limitation.GUIAction_CancelUpgrade();
        local EntityID = GUI.GetSelectedEntity();
        local PlayerID = Logic.EntityGetPlayer(EntityID);

        Sync.Call(
            "Stronghold_Limitation_SyncEvent",
            PlayerID,
            Stronghold.Limitation.SyncEvent.UpgradeCanceled,
            EntityID
        );
    end
end

function Stronghold_Limitation_Trigger_EntityCreated()
    local EntityID = Event.GetEntityID();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    Stronghold.Limitation:OnEntityCreated(PlayerID, EntityID);
end

function Stronghold_Limitation_Trigger_EntityDestroyed()
    local EntityID = Event.GetEntityID();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    Stronghold.Limitation:OnEntityDestroyed(PlayerID, EntityID);
end

