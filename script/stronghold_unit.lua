-- 
-- 
-- 

Stronghold = Stronghold or {};

Stronghold.Unit = {
    Data = {},
    Config = {
        Units = {
            [Entities.PU_LeaderPoleArm1] = {
                Costs = {0, 40, 0, 24, 0, 0, 0},
                Allowed = true,
                Rank = 1,
                Upkeep = 15,
            },
            [Entities.PU_LeaderPoleArm2] = {
                Costs = {5, 20, 0, 45, 0, 0, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 20,
            },
            [Entities.PU_LeaderPoleArm3] = {
                Costs = {10, 65, 0, 35, 0, 10, 0},
                Allowed = true,
                Rank = 3,
                Upkeep = 70
            },
            [Entities.PU_LeaderPoleArm4] = {
                Costs = {15, 40, 0, 35, 0, 25, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 80
            },
            ---
            [Entities.PU_LeaderSword1] = {
                Costs = {6, 25, 0, 0, 0, 40, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 25,
            },
            [Entities.PU_LeaderSword2] = {
                Costs = {10, 30, 0, 0, 0, 40, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 40,
            },
            [Entities.PU_LeaderSword3] = {
                Costs = {20, 70, 0, 0, 0, 45, 0},
                Allowed = true,
                Rank = 5,
                Upkeep = 100,
            },
            [Entities.PU_LeaderSword4] = {
                Costs = {30, 80, 0, 0, 0, 55, 0},
                Allowed = true,
                Rank = 8,
                Upkeep = 120,
            },
            ---
            [Entities.PU_LeaderBow1] = {
                Costs = {2, 50, 0, 36, 0, 0, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 25,
            },
            [Entities.PU_LeaderBow2] = {
                Costs = {6, 56, 0, 44, 0, 0, 0},
                Allowed = true,
                Rank = 2,
                Upkeep = 30,
            },
            [Entities.PU_LeaderBow3] = {
                Costs = {12, 72, 0, 30, 0, 22, 0},
                Allowed = true,
                Rank = 4,
                Upkeep = 80,
            },
            [Entities.PU_LeaderBow4] = {
                Costs = {15, 10, 0, 0, 0, 0, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 90,
            },
            ---
            [Entities.PV_Cannon1] = {
                Costs = {8, 150, 0, 25, 0, 50, 100},
                Allowed = true,
                Rank = 3,
                Upkeep = 30,
            },
            [Entities.PV_Cannon2] = {
                Costs = {15, 10, 0, 25, 0, 75, 120},
                Allowed = true,
                Rank = 5,
                Upkeep = 50,
            },
            [Entities.PV_Cannon3] = {
                Costs = {25, 300, 0, 50, 0, 500, 250},
                Allowed = true,
                Rank = 7,
                Upkeep = 100,
            },
            [Entities.PV_Cannon4] = {
                Costs = {30, 300, 0, 50, 0, 250, 500},
                Allowed = true,
                Rank = 9,
                Upkeep = 120,
            },
            ---
            [Entities.PU_LeaderCavalry1] = {
                Costs = {6, 55, 0, 30, 0, 0, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 40,
            },
            [Entities.PU_LeaderCavalry2] = {
                Costs = {10, 75, 0, 35, 0, 15, 0},
                Allowed = true,
                Rank = 4,
                Upkeep = 70,
            },
            ---
            [Entities.PU_LeaderHeavyCavalry1] = {
                Costs = {28, 145, 0, 0, 0, 55, 0},
                Allowed = false,
                Rank = 0,
                Upkeep = 120,
            },
            [Entities.PU_LeaderHeavyCavalry2] = {
                Costs = {40, 165, 0, 0, 0, 65, 0},
                Allowed = true,
                Rank = 9,
                Upkeep = 150,
            },
            ---
            [Entities.PU_LeaderRifle1] = {
                Costs = {20, 90, 0, 10, 0, 0, 40},
                Allowed = true,
                Rank = 6,
                Upkeep = 70,
            },
            [Entities.PU_LeaderRifle2] = {
                Costs = {30, 105, 0, 20, 0, 0, 60},
                Allowed = true,
                Rank = 8,
                Upkeep = 100,
            },
            ---
            [Entities.PU_Scout] = {
                Costs = {0, 150, 0, 50, 0, 50, 0},
                Allowed = true,
                Rank = 2,
                Upkeep = 5,
            },
            [Entities.PU_Thief] = {
                Costs = {30, 500, 0, 0, 0, 100, 100},
                Allowed = true,
                Rank = 5,
                Upkeep = 50,
            },
            ---
            [Entities.PU_Serf] = {
                Costs = {0, 50, 0, 0, 0, 0, 0},
                Allowed = true,
                Rank = 1,
                Upkeep = 0,
            },
        },
    },
}

function Stronghold.Unit:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    self:OverrideTooltipConstructionButton();
    self:OverrideUpdateConstructionButton();
    self:OverrideUpdateUpgradeButton();
end

function Stronghold.Unit:OnSaveGameLoaded()

end

-- -------------------------------------------------------------------------- --
-- Config

function Stronghold.Unit:GetUnitConfig(_Type)
    if self.Config.Units[_Type] then
        return self.Config.Units[_Type];
    end
    return {
        Costs = {0, 0, 0, 0, 0, 0, 0},
        Allowed = false,
        Rank = 0,
        Upkeep = 0,
    }
end

-- -------------------------------------------------------------------------- --
-- Buy Unit

function Stronghold.Unit:BuyUnit(_PlayerID, _Type, _BarracksID, _AutoFill)
    if Stronghold:IsPlayer(_PlayerID) then
        if self.Config.Units[_Type] then
            if not IsExisting(_BarracksID) then
                return;
            end
            local TypeName = Logic.GetEntityTypeName(_Type);
            local Position = self:GetBarracksDoorPosition(_BarracksID);
            local IsLeader = Logic.IsEntityTypeInCategory(_Type, EntityCategories.Leader) == 1;
            local IsCannon = Logic.IsEntityTypeInCategory(_Type, EntityCategories.Cannon) == 1;
            local Costs = CreateCostTable(unpack(self.Config.Units[_Type].Costs));

            -- Passive ability: experienced troops
            local Experience = 0;
            if IsLeader and not IsCannon and Stronghold.Hero:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
                Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
                Experience = 3;
            end

            -- Check worker for foundry and send him to eat (no cannon spamming :) )
            if TypeName and string.find(TypeName, "Cannon") then
                local Workers = {Logic.GetAttachedWorkersToBuilding(_BarracksID)};
                if Workers[1] == 0 or Logic.IsSettlerAtWork(Workers[2]) == 0 then
                    Stronghold.Players[_PlayerID].BuyUnitLock = false;
                    Sound.PlayQueuedFeedbackSound(Sounds.VoicesWorker_WORKER_FunnyNo_rnd_01);
                    Message("Es ist kein Kanonengießer anwesend!");
                    return;
                else
                    Logic.SetCurrentMaxNumWorkersInBuilding(_BarracksID, 0);
                    Logic.SetCurrentMaxNumWorkersInBuilding(_BarracksID, 1);
                end
            end

            RemoveResourcesFromPlayer(_PlayerID, Costs);
            local ID = AI.Entity_CreateFormation(_PlayerID, _Type, 0, 0, Position.X, Position.Y, 0, 0, Experience, 0);
            if ID ~= 0 then
                if IsLeader and _AutoFill then
                    Costs[ResourceType.Honor] = 0;
                    local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(ID);
                    for i= 1, MaxSoldiers do
                        if HasEnoughResources(_PlayerID, Costs) then
                            RemoveResourcesFromPlayer(_PlayerID, Costs);
                            local SoldierType = Logic.LeaderGetSoldiersType(ID);
                            Logic.CreateEntity(SoldierType, Position.X, Position.Y, 0, _PlayerID);
                            Tools.AttachSoldiersToLeader(ID, 1);
                        end
                    end
                end
                if Logic.GetSector(ID) == Logic.GetSector(GetID("CampPosP" .._PlayerID)) then
                    Position = Stronghold.Players[_PlayerID].CampPos;
                end
                Logic.MoveSettler(ID, Position.X, Position.Y);
            end
        end
        Stronghold.Players[_PlayerID].BuyUnitLock = nil;
    end
end

function Stronghold.Unit:RefillUnit(_PlayerID, _UnitID, _Amount)
    if Stronghold:IsPlayer(_PlayerID) then
        local LeaderType = Logic.GetEntityType(_UnitID);
        if self.Config.Units[LeaderType] then
            if Logic.GetEntityHealth(_UnitID) > 0 then
                if Logic.IsEntityInCategory(_UnitID, EntityCategories.Leader) == 1 then
                    local Task = Logic.GetCurrentTaskList(_UnitID);
                    if not Task or (not string.find(Task, "DIE") and not string.find(Task, "BATTLE")) then
                        local BuildingID = Logic.LeaderGetNearbyBarracks(_UnitID);
                        local Position = self:GetBarracksDoorPosition((BuildingID ~= 0 and BuildingID) or _UnitID);

                        local Costs = CreateCostTable(unpack(self.Config.Units[LeaderType].Costs));
                        Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
                        Costs[ResourceType.Honor] = 0;

                        local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(_UnitID);
                        local Soldiers = Logic.LeaderGetNumberOfSoldiers(_UnitID);
                        for i= 1, _Amount do
                            if Soldiers < MaxSoldiers then
                                RemoveResourcesFromPlayer(_PlayerID, Costs);
                                local SoldierType = Logic.LeaderGetSoldiersType(_UnitID);
                                Logic.CreateEntity(SoldierType, Position.X, Position.Y, 0, _PlayerID);
                                Tools.AttachSoldiersToLeader(_UnitID, 1);
                            end
                        end
                    end
                end
            end
        end
        Stronghold.Players[_PlayerID].BuyUnitLock = nil;
    end
end

function Stronghold.Unit:GetBarracksDoorPosition(_BarracksID)
    local PlayerID = Logic.EntityGetPlayer(_BarracksID);
    local Position = Stronghold.Players[PlayerID].DoorPos;

    local BarracksType = Logic.GetEntityType(_BarracksID);
    if BarracksType == Entities.PB_Barracks1 or BarracksType == Entities.PB_Barracks2 then
        Position = GetCirclePosition(_BarracksID, 900, 180);
    elseif BarracksType == Entities.PB_Archery1 or BarracksType == Entities.PB_Archery2 then
        Position = GetCirclePosition(_BarracksID, 800, 180);
    elseif BarracksType == Entities.PB_Stable1 or BarracksType == Entities.PB_Stable2 then
        Position = GetCirclePosition(_BarracksID, 1000, 180);
    elseif BarracksType == Entities.PB_Foundry1 or BarracksType == Entities.PB_Foundry2 then
        Position = GetCirclePosition(_BarracksID, 800, 270);
    elseif BarracksType == Entities.PB_Tavern1 or BarracksType == Entities.PB_Tavern2 then
        Position = GetCirclePosition(_BarracksID, 600, 180);
    -- TODO: Add more positions if needed
    end
    return Position;
end

-- -------------------------------------------------------------------------- --
-- UI

function Stronghold.Unit:OverrideTooltipConstructionButton()
    self.Orig_GUITooltip_ConstructBuilding = GUITooltip_ConstructBuilding;
    GUITooltip_ConstructBuilding = function(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUITooltip_ConstructBuilding(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end

        -- Get default text
        local Text = XGUIEng.GetStringTableText(_KeyNormal);
        local LineBreakPos, LineBreakEnd = string.find(Text, " @cr ");
        local TextHeadline = string.sub(Text, 1, LineBreakPos);
        local TextBody = string.sub(Text, LineBreakEnd +1);

        local CostString = "";
        local ShortCutToolTip = "";
        local Type = Logic.GetBuildingTypeByUpgradeCategory(_UpgradeCategory, PlayerID);
        if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
            Text = XGUIEng.GetStringTableText(_KeyDisabled);
        else
            Logic.FillBuildingCostsTable(Type, InterfaceGlobals.CostTable);
            CostString = InterfaceTool_CreateCostString(InterfaceGlobals.CostTable);
            if _ShortCut then
                ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name")..
                    ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
            end
        end

        -- Effect text
        local EffectText = "";
        local UpgradeCategoryName = KeyOf(_UpgradeCategory, UpgradeCategories);
        if UpgradeCategoryName and (string.find(UpgradeCategoryName, "Beautification"))
        or _UpgradeCategory == UpgradeCategories.Tavern
        or _UpgradeCategory == UpgradeCategories.Tower
        or _UpgradeCategory == UpgradeCategories.Barracks
        or _UpgradeCategory == UpgradeCategories.Archery
        or _UpgradeCategory == UpgradeCategories.Stable
        or _UpgradeCategory == UpgradeCategories.Monastery
        or _UpgradeCategory == UpgradeCategories.PowerPlant then
            local Effects = Stronghold.Economy.Config.Income.Buildings[Type];
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
        else
            return Stronghold.Unit.Orig_GUITooltip_ConstructBuilding(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end

        -- Limit factor
        -- (Only for beautification)
        local LimitFactor = 1.0;
        local UpgradeCategoryName = KeyOf(_UpgradeCategory, UpgradeCategories);
        if UpgradeCategoryName and string.find(UpgradeCategoryName, "Beautification") then
            if Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Headquarters2) > 0 then
                LimitFactor = 1.5;
            end
            if Logic.GetNumberOfEntitiesOfTypeOfPlayer(PlayerID, Entities.PB_Headquarters3) > 0 then
                LimitFactor = 2.0;
            end
        end

        -- Building limit
        local BuildingMax = math.floor(GetLimitOfType(Type) * LimitFactor);
        if BuildingMax > -1 then
            local BuildingCount = GetUsageOfType(PlayerID, Type);
            if _UpgradeCategory == UpgradeCategories.Tower then
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Tower2);
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Tower3);
            end
            if _UpgradeCategory == UpgradeCategories.Monastery then
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Monastery2);
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Monastery3);
            end
            if _UpgradeCategory == UpgradeCategories.Barracks then
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Barracks2);
            end
            if _UpgradeCategory == UpgradeCategories.Archery then
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Archery2);
            end
            if _UpgradeCategory == UpgradeCategories.Stable then
                BuildingCount = BuildingCount + GetUsageOfType(PlayerID, Entities.PB_Stable2);
            end
            Text = TextHeadline.. " (" ..BuildingCount.. "/" ..BuildingMax.. ") @cr " .. TextBody;
        end

        -- Set text
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text.. " " ..EffectText);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip);
    end
end

function Stronghold.Unit:OverrideUpdateConstructionButton()
    self.Orig_GUIUpdate_BuildingButtons = GUIUpdate_BuildingButtons;
    GUIUpdate_BuildingButtons = function(_Button, _Technology)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUIUpdate_BuildingButtons(_Button, _Technology);
        end
        if not Stronghold.Unit:UpdateSerfConstructionButtons(PlayerID, _Button, _Technology) then
            Stronghold.Unit.Orig_GUIUpdate_BuildingButtons(_Button, _Technology);
        end
    end
end

function Stronghold.Unit:OverrideUpdateUpgradeButton()
    self.Orig_GUIUpdate_UpgradeButtons = GUIUpdate_UpgradeButtons;
    GUIUpdate_UpgradeButtons = function(_Button, _Technology)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUIUpdate_UpgradeButtons(_Button, _Technology);
        end
        if not Stronghold.Unit:UpdateSerfConstructionButtons(PlayerID, _Button, _Technology) then
            Stronghold.Unit.Orig_GUIUpdate_UpgradeButtons(_Button, _Technology);
        end
    end
end

-- Update buttons in serf menu
-- for some reason most of the beautification buttons call the update of the
-- upgrade button instead of the construction button. A classical case of the
-- infamos "BB-Logic".... To avoid boilerplate we outsource the changes.
function Stronghold.Unit:UpdateSerfConstructionButtons(_PlayerID, _Button, _Technology)
    local TechnologyName = KeyOf(_Technology, Technologies);

    -- No village centers
    if _Technology == Technologies.B_Village then
        XGUIEng.ShowWidget(_Button, 0);
        return true;
    end

    -- Limit factor
    local LimitFactor = 1.0;
    if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters2) > 0 then
        LimitFactor = 1.5;
    end
    if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters3) > 0 then
        LimitFactor = 2.0;
    end

    local LimitReached = false;

    -- Recruiter buildings
    if _Technology == Technologies.B_Barracks then
        local Limit = GetLimitOfType(Entities.PB_Barracks1);
        local Barracks1 = GetUsageOfType(_PlayerID, Entities.PB_Barracks1);
        local Barracks2 = GetUsageOfType(_PlayerID, Entities.PB_Barracks2);
        LimitReached = Limit <= (Barracks1 + Barracks2);
    end
    if _Technology == Technologies.B_Archery then
        local Limit = GetLimitOfType(Entities.PB_Archery1);
        local Barracks1 = GetUsageOfType(_PlayerID, Entities.PB_Archery1);
        local Barracks2 = GetUsageOfType(_PlayerID, Entities.PB_Archery2);
        LimitReached = Limit <= (Barracks1 + Barracks2);
    end
    if _Technology == Technologies.B_Stables then
        local Limit = GetLimitOfType(Entities.PB_Stable1);
        local Barracks1 = GetUsageOfType(_PlayerID, Entities.PB_Stable1);
        local Barracks2 = GetUsageOfType(_PlayerID, Entities.PB_Stable2);
        LimitReached = Limit <= (Barracks1 + Barracks2);
    end

    -- Special buildings
    if _Technology == Technologies.B_Monastery then
        local Limit = GetLimitOfType(Entities.PB_Monastery1);
        local Building1 = GetUsageOfType(_PlayerID, Entities.PB_Monastery1);
        local Building2 = GetUsageOfType(_PlayerID, Entities.PB_Monastery2);
        local Building3 = GetUsageOfType(_PlayerID, Entities.PB_Monastery3);
        LimitReached = Limit <= (Building1 + Building2 + Building3);
    end
    if _Technology == Technologies.B_PowerPlant then
        local Limit = GetLimitOfType(Entities.PB_PowerPlant1);
        local Building1 = GetUsageOfType(_PlayerID, Entities.PB_PowerPlant1);
        LimitReached = Limit <= Building1;
    end

    -- Beautification
    if TechnologyName and string.find(TechnologyName, "^B_Beautification") then
        local Limit = GetLimitOfType(Entities["P" ..TechnologyName]);
        local Usage = GetUsageOfType(_PlayerID, Entities["P" ..TechnologyName]);
        LimitReached = math.floor(Limit * LimitFactor) <= Usage;
    end

    if LimitReached then
        XGUIEng.DisableButton(_Button, 1);
        return true;
    end
    return false;
end

