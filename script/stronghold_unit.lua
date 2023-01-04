-- 
-- 
-- 

Stronghold = Stronghold or {};

Stronghold.Config.Units = {
    [Entities.PU_LeaderPoleArm1] = {
        Costs = {0, 40, 0, 24, 0, 0, 0},
        Allowed = true,
        Rank = 1,
        Upkeep = 15,
    },
    [Entities.PU_LeaderPoleArm2] = {
        Costs = {6, 20, 0, 45, 0, 0, 0},
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
        Costs = {8, 150, 0, 10, 0, 50, 90},
        Allowed = true,
        Rank = 5,
        Upkeep = 30,
    },
    [Entities.PV_Cannon2] = {
        Costs = {15, 10, 0, 20, 0, 0, 130},
        Allowed = true,
        Rank = 5,
        Upkeep = 50,
    },
    [Entities.PV_Cannon3] = {
        Costs = {25, 300, 30, 0, 0, 100, 120},
        Allowed = true,
        Rank = 8,
        Upkeep = 100,
    },
    [Entities.PV_Cannon4] = {
        Costs = {30, 300, 40, 0, 0, 180, 180},
        Allowed = true,
        Rank = 8,
        Upkeep = 120,
    },
    ---
    [Entities.PU_LeaderCavalry1] = {
        Costs = {6, 70, 0, 30, 0, 0, 0},
        Allowed = false,
        Rank = 0,
        Upkeep = 40,
    },
    [Entities.PU_LeaderCavalry2] = {
        Costs = {10, 100, 0, 40, 0, 0, 0},
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
        Rank = 9,
        Upkeep = 100,
    },
    ---
    [Entities.PU_Scout] = {
        Costs = {0, 100, 0, 0, 0, 50, 0},
        Allowed = true,
        Rank = 1,
        Upkeep = 5,
    },
    [Entities.PU_Thief] = {
        Costs = {30, 300, 0, 0, 0, 100, 0},
        Allowed = true,
        Rank = 4,
        Upkeep = 50,
    },
    ---
    [Entities.PU_Serf] = {
        Costs = {0, 50, 0, 0, 0, 0, 0},
        Allowed = true,
        Rank = 1,
        Upkeep = 0,
    },
}

-- -------------------------------------------------------------------------- --
-- Buy Unit

function Stronghold:BuyUnit(_PlayerID, _Type, _BarracksID, _AutoFill)
    if self.Players[_PlayerID] and self.Config.Units[_Type] then
        if not IsExisting(_BarracksID) then
            return;
        end
        local Position = self:GetBarracksDoorPosition(_BarracksID);
        local IsLeader = Logic.IsEntityTypeInCategory(_Type, EntityCategories.Leader) == 1;
        local Costs = CreateCostTable(unpack(self.Config.Units[_Type].Costs));

        -- Passive ability: experienced troops
        local Experience = 0;
        if IsLeader and self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
            self:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
            Experience = 5;
        end
        -- Create unit
        RemoveResourcesFromPlayer(_PlayerID, Costs);
        local ID = AI.Entity_CreateFormation(_PlayerID, _Type, 0, 0, Position.X, Position.Y, 0, 0, Experience, 0);
        if ID ~= 0 then
            if Logic.IsEntityInCategory(_BarracksID, EntityCategories.Headquarters) == 1 then
                Position = self.Players[_PlayerID].CampPos;
            end
            if IsLeader and _AutoFill then
                local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(ID);
                for i= 1, MaxSoldiers do
                    Costs[ResourceType.Honor] = 0;
                    RemoveResourcesFromPlayer(_PlayerID, Costs);
                end
                Tools.CreateSoldiersForLeader(ID, MaxSoldiers);
            end
            Logic.MoveSettler(ID, Position.X, Position.Y);
        end
        -- Release lock
        self.Players[_PlayerID].BuyUnitLock = nil;
    end
end

function Stronghold:RefillUnit(_PlayerID, _Type, _UnitID, _Amount)
    if self.Players[_PlayerID] and self.Config.Units[_Type] then
        -- Buy soldiers
        if Logic.GetEntityHealth(_UnitID) > 0 then
            if Logic.IsEntityInCategory(_UnitID, EntityCategories.Leader) == 1 then
                local Task = Logic.GetCurrentTaskList(_UnitID);
                if not Task or (not string.find(Task, "DIE") and not string.find(Task, "BATTLE")) then
                    -- Get soldier costs
                    local Costs = CreateCostTable(unpack(self.Config.Units[_Type].Costs));
                    Costs[ResourceType.Honor] = 0;
                    -- Create soldiers
                    local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(_UnitID);
                    for i= 1, _Amount do
                        local Soldiers = Logic.LeaderGetNumberOfSoldiers(_UnitID);
                        if Soldiers < MaxSoldiers then
                            RemoveResourcesFromPlayer(_PlayerID, Costs);
                            Tools.CreateSoldiersForLeader(_UnitID, MaxSoldiers);
                        end
                    end
                end
            end
        end
        -- Release lock
        self.Players[_PlayerID].BuyUnitLock = nil;
    end
end

function Stronghold:GetBarracksDoorPosition(_BarracksID)
    local PlayerID = Logic.EntityGetPlayer(_BarracksID);
    local Position = self.Players[PlayerID].DoorPos;

    local BarracksType = Logic.GetEntityType(_BarracksID);
    if BarracksType == Entities.PB_Barracks1 or BarracksType == Entities.PB_Barracks2 then
        Position = GetCirclePosition(_BarracksID, 900, 180);
    elseif BarracksType == Entities.PB_Archery1 or BarracksType == Entities.PB_Archery2 then
        Position = GetCirclePosition(_BarracksID, 800, 180);
    elseif BarracksType == Entities.PB_Stable1 or BarracksType == Entities.PB_Stable2 then
        Position = GetCirclePosition(_BarracksID, 1000, 180);
    elseif BarracksType == Entities.PB_Foundry1 or BarracksType == Entities.PB_Foundry2 then
        Position = GetCirclePosition(_BarracksID, 800, 180);
    end
    return Position;
end

-- -------------------------------------------------------------------------- --
-- Serf

function Stronghold:PrintSerfConstructionTooltip(_PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
    -- Get default text
    local Text = XGUIEng.GetStringTableText(_KeyNormal);
    local LineBreakPos, LineBreakEnd = string.find(Text, " @cr ");
    local TextHeadline = string.sub(Text, 1, LineBreakPos);
    local TextBody = string.sub(Text, LineBreakEnd +1);

    local CostString = "";
    local ShortCutToolTip = "";
    local Type = Logic.GetBuildingTypeByUpgradeCategory(_UpgradeCategory, _PlayerID);
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
    or _UpgradeCategory == UpgradeCategories.Barracks
    or _UpgradeCategory == UpgradeCategories.Archery
    or _UpgradeCategory == UpgradeCategories.Stable then
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
        return false;
    end

    -- Building limit
    local BuildingMax = Stronghold.Limitation:GetTypeLimit(Type);
    if BuildingMax > -1 then
        local BuildingCount = Stronghold.Limitation:GetTypeUsage(_PlayerID, Type);
        Text = TextHeadline.. " (" ..BuildingCount.. "/" ..BuildingMax.. ") @cr " .. TextBody;
    end

    -- Set text
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text.. " " ..EffectText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip);
    return true;
end

function Stronghold:UpdateSerfConstructionButtons(_PlayerID, _Button, _Technology)
    local TechnologyName = KeyOf(_Technology, Technologies);

    -- No village centers
    if _Technology == Technologies.B_Village then
        XGUIEng.ShowWidget(_Button, 0);
        return true;
    end

    local LimitReached = false;

    -- Recruiter buildings
    if _Technology == Technologies.B_Barracks then
        local Barracks1 = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Entities.PB_Barracks1);
        local Barracks2 = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Entities.PB_Barracks2);
        LimitReached = Barracks1 or Barracks2;
    end
    if _Technology == Technologies.B_Archery then
        local Barracks1 = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Entities.PB_Archery1);
        local Barracks2 = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Entities.PB_Archery2);
        LimitReached = Barracks1 or Barracks2;
    end
    if _Technology == Technologies.B_Stables then
        local Barracks1 = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Entities.PB_Stable1);
        local Barracks2 = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Entities.PB_Stable2);
        LimitReached = Barracks1 or Barracks2;
    end

    -- Beautification
    if TechnologyName and string.find(TechnologyName, "^B_Beautification") then
        local Type = Entities["P" ..TechnologyName];
        LimitReached = Stronghold.Limitation:IsTypeLimitReached(_PlayerID, Type);
    end

    if LimitReached then
        XGUIEng.DisableButton(_Button, 1);
        return true;
    end
    return false;
end

