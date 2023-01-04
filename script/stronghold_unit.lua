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

        -- Passive ability: experienced troops
        local Experience = 0;
        if IsLeader and self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
            Experience = 3;
        end
        -- Create unit
        local Costs = CreateCostTable(unpack(self.Config.Units[_Type].Costs));
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

    -- Alter text
    local EffectText = "";
    if _UpgradeCategory == UpgradeCategories.Beautification04 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification04];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification06 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification06];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification09 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification09];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification01 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification01];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification02 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification02];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification12 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification12];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification05 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification05];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification07 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification07];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification08 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification08];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification03 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification03];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification10 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification10];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification11 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification11];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Tavern then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Tavern1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Barracks then
    elseif _UpgradeCategory == UpgradeCategories.Archery then
    elseif _UpgradeCategory == UpgradeCategories.Stables then
    else
        return false;
    end

    -- Beautification limit
    local LimitReached = false;
    local Limit;
    if Stronghold.Config.Income.Buildings[Type] then
        Limit = Stronghold.Config.Income.Buildings[Type].Limit;
    end
    if Limit and Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Type) >= Limit then
        LimitReached = true;
    end
    -- Military limit
    if Type == Entities.PB_Barracks1 then
        local BuildingT1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks1);
        local BuildingT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        LimitReached = LimitReached or BuildingT1+BuildingT2 > 0;
    end
    if Type == Entities.PB_Archery1 then
        local BuildingT1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks1);
        local BuildingT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        LimitReached = LimitReached or BuildingT1+BuildingT2 > 0;
    end
    if Type == Entities.PB_Stable1 then
        local BuildingT1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks1);
        local BuildingT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        LimitReached = LimitReached or BuildingT1+BuildingT2 > 0;
    end

    if LimitReached or (_Technology and Logic.GetTechnologyState(_PlayerID, _Technology) == 0) then
        Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        CostString = "";
        ShortCutToolTip = "";
        EffectText = "";
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

    -- Military building limit
    if _Technology == Technologies.B_Barracks then
        local BuildingT1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks1);
        local BuildingT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Barracks2);
        self:UpdateSerfConstructionButton(_PlayerID, _Button, _Technology, BuildingT1+BuildingT2 > 0);
        return true;
    end
    if _Technology == Technologies.B_Archery then
        local BuildingT1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Archery1);
        local BuildingT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Archery2);
        self:UpdateSerfConstructionButton(_PlayerID, _Button, _Technology, BuildingT1+BuildingT2 > 0);
        return true;
    end
    if _Technology == Technologies.B_Stables then
        local BuildingT1 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Stable1);
        local BuildingT2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Stable2);
        self:UpdateSerfConstructionButton(_PlayerID, _Button, _Technology, BuildingT1+BuildingT2 > 0);
        return true;
    end

    -- Beautification limit
    if TechnologyName and string.find(TechnologyName, "^B_Beautification") then
        local Type = Entities["P" ..TechnologyName];
        local Limit = Stronghold.Config.Income.Buildings[Type].Limit;
        LimitReached = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Type) >= Limit;
        self:UpdateSerfConstructionButton(_PlayerID, _Button, _Technology, LimitReached);
        return true;
    end
    return false;
end

function Stronghold:UpdateSerfConstructionButton(_PlayerID, _Button, _Technology, _Disable)
    local TechState = Logic.GetTechnologyState(_PlayerID, _Technology);
    if TechState == 2 or TechState == 3 or TechState == 4 then
        if _Disable then
            XGUIEng.DisableButton(_Button, 1);
        else
            XGUIEng.DisableButton(_Button, 0);
        end
    else
        XGUIEng.DisableButton(_Button, 1);
    end
end

