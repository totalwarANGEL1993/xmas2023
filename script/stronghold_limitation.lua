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
        Limit = {
            [UpgradeCategories.Beautification04]    = {[1] =  4, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification06]    = {[1] =  4, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification09]    = {[1] =  4, [2] = -1, [3] = -1, [4] = -1},
            ---
            [UpgradeCategories.Beautification01]    = {[1] =  3, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification02]    = {[1] =  3, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification12]    = {[1] =  3, [2] = -1, [3] = -1, [4] = -1},
            ---
            [UpgradeCategories.Beautification05]    = {[1] =  2, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification07]    = {[1] =  2, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification08]    = {[1] =  2, [2] = -1, [3] = -1, [4] = -1},
            ---
            [UpgradeCategories.Beautification03]    = {[1] =  1, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification10]    = {[1] =  1, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Beautification11]    = {[1] =  1, [2] = -1, [3] = -1, [4] = -1},
            ---
            [UpgradeCategories.Monastery]           = {[1] =  1, [2] =  1, [3] =  1, [4] = -1},
            [UpgradeCategories.Farm]                = {[1] = -1, [2] =  8, [3] =  4, [4] = -1},
            [UpgradeCategories.Residence]           = {[1] = -1, [2] =  8, [3] =  4, [4] = -1},
            [UpgradeCategories.Market]              = {[1] = -1, [2] =  1, [3] = -1, [4] = -1},
            [UpgradeCategories.Tavern]              = {[1] =  6, [2] =  3, [3] = -1, [4] = -1},
            [UpgradeCategories.PowerPlant]          = {[1] =  1, [2] = -1, [3] = -1, [4] = -1},
            ---
            [UpgradeCategories.Tower]               = {[1] = -1, [2] = -1, [3] = -1, [4] = -1},
            [UpgradeCategories.Barracks]            = {[1] =  1, [2] =  1, [3] = -1, [4] = -1},
            [UpgradeCategories.Archery]             = {[1] =  1, [2] =  1, [3] = -1, [4] = -1},
            [UpgradeCategories.Stable]              = {[1] =  1, [2] =  1, [3] = -1, [4] = -1},
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
end

-- Returns the limit for the type.
-- -1   No limit
--  0   Forbidden
-- >0   Limit
function GetLimitOfType(_Type)
    return Stronghold.Limitation:GetLimitForType(_Type);
end

-- Sets a limit for the type.
-- (Type must have a upgrade category)
-- -1   No limit
--  0   Forbidden
-- >0   Limit
function SetLimitOfType(_Type, _Limit)
    Stronghold.Limitation:SetLimitForType(_Type, _Limit);
end

-- Returns the amount currently tracked entities.
function GetUsageOfType(_PlayerID, _Type)
    return Stronghold.Limitation:GetCurrentAmountOfType(_PlayerID, _Type);
end

-- -------------------------------------------------------------------------- --
-- Logic

function Stronghold.Limitation:SetupSynchronization()
    self.SyncEvent = {
        UpgradeStarted = 1,
        UpgradeCanceled = 2,
    };

    self.NetworkCall = Stronghold.Sync:CreateSyncEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Limitation.SyncEvent.UpgradeStarted then
                Stronghold.Limitation:OnUpgradeStarted(_PlayerID, arg[1]);
            end
            if _Action == Stronghold.Limitation.SyncEvent.UpgradeCanceled then
                Stronghold.Limitation:OnUpgradeCanceled(_PlayerID, arg[1]);
            end
        end
    );
end

function Stronghold.Limitation:GetLimitForType(_Type)
    local UpgradeCategory = GetUpgradeCategoryByEntityType(_Type);
    local UpgradeLevel = GetUpgradeLevelByEntityType(_Type);
    if UpgradeCategory ~= 0 and self.Config.Limit[UpgradeCategory] then
        return self.Config.Limit[UpgradeCategory][UpgradeLevel +1];
    end
    return -1;
end

function Stronghold.Limitation:SetLimitForType(_Type, _Limit)
    local UpgradeCategory = GetUpgradeCategoryByEntityType(_Type);
    local UpgradeLevel = GetUpgradeLevelByEntityType(_Type);
    if UpgradeCategory ~= 0 then
        if not self.Config.Limit[UpgradeCategory] then
            self.Config.Limit[UpgradeCategory] = {-1, -1, -1, -1};
        end
        self.Config.Limit[UpgradeCategory][UpgradeLevel +1] = _Limit;
    end
end

function Stronghold.Limitation:GetCurrentAmountOfType(_PlayerID, _Type)
    local Amount = 0;
    local UpgradeCategory = GetUpgradeCategoryByEntityType(_Type);
    if self.Data[_PlayerID] and self.Config.Limit[UpgradeCategory] then
        if self.Data[_PlayerID].Potential[_Type] then
            Amount = Amount + table.getn(self.Data[_PlayerID].Potential[_Type]);
        end
        if self.Data[_PlayerID].Current[_Type] then
            Amount = Amount + table.getn(self.Data[_PlayerID].Current[_Type]);
        end
    end
    return Amount;
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
    self.Orig_GUIAction_UpgradeSelectedBuilding = GUIAction_UpgradeSelectedBuilding;
	GUIAction_UpgradeSelectedBuilding = function()
        local PlayerID = GUI.GetPlayerID();
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
            if not Stronghold.Limitation.Data[PlayerID] then
                GUI.UpgradeSingleBuilding(EntityID);
            else
                if not Stronghold.Limitation.Data[PlayerID].UpgradeBuildingLock then
                    Stronghold.Limitation.Data[PlayerID].UpgradeBuildingLock = true;
                    GUI.UpgradeSingleBuilding(EntityID);
                    Stronghold.Sync:Call(
                        Stronghold.Limitation.NetworkCall,
                        PlayerID,
                        Stronghold.Limitation.SyncEvent.UpgradeStarted,
                        EntityID
                    );
                end
            end
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

        Stronghold.Sync:Call(
            Stronghold.Limitation.NetworkCall,
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

