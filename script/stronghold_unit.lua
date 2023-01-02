-- 
-- 
-- 

Stronghold = Stronghold or {};

Stronghold.Config.Units = {
    [Entities.PU_LeaderPoleArm1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 10,
    },
    [Entities.PU_LeaderPoleArm2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 15,
    },
    [Entities.PU_LeaderPoleArm3] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 35
    },
    [Entities.PU_LeaderPoleArm4] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 45
    },
    ---
    [Entities.PU_LeaderSword1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 20,
    },
    [Entities.PU_LeaderSword2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 30,
    },
    [Entities.PU_LeaderSword3] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 60,
    },
    [Entities.PU_LeaderSword4] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 70,
    },
    ---
    [Entities.PU_LeaderBow1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 10,
    },
    [Entities.PU_LeaderBow2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 15,
    },
    [Entities.PU_LeaderBow3] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 50,
    },
    [Entities.PU_LeaderBow4] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 60,
    },
    ---
    [Entities.PV_Cannon1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 10,
    },
    [Entities.PV_Cannon2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 30,
    },
    [Entities.PV_Cannon3] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 90,
    },
    [Entities.PV_Cannon4] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 90,
    },
    ---
    [Entities.PU_LeaderCavalry1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 30,
    },
    [Entities.PU_LeaderCavalry2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 50,
    },
    ---
    [Entities.PU_LeaderHeavyCavalry1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 50,
    },
    [Entities.PU_LeaderHeavyCavalry2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 60,
    },
    ---
    [Entities.PU_LeaderRifle1] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 40,
    },
    [Entities.PU_LeaderRifle2] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 90,
    },
    ---
    [Entities.PU_Scout] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 5,
    },
    [Entities.PU_Thief] = {
        Costs = {0, 10, 0, 0, 0, 0, 0},
        Upkeep = 25,
    },
    ---
    [Entities.PU_Serf] = {
        Costs = {0, 50, 0, 0, 0, 0, 0},
        Upkeep = 0,
    },
}

-- -------------------------------------------------------------------------- --
-- Buy Unit

function Stronghold:BuyUnit(_PlayerID, _Type, _BarracksID, _AutoFill)
    if self.Players[_PlayerID] and self.Config.Units[_Type] then
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
            Logic.MoveSettler(ID, Position.X, Position.Y);
            if IsLeader and _AutoFill then
                local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(ID);
                for i= 1, MaxSoldiers do
                    RemoveResourcesFromPlayer(_PlayerID, Costs);
                end
                Tools.CreateSoldiersForLeader(ID, MaxSoldiers);
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
        Position = GetCirclePosition(_BarracksID, 900, 90);
    elseif BarracksType == Entities.PB_Archery1 or BarracksType == Entities.PB_Archery2 then
        Position = GetCirclePosition(_BarracksID, 800, 90);
    elseif BarracksType == Entities.PB_Stable1 or BarracksType == Entities.PB_Stable2 then
        Position = GetCirclePosition(_BarracksID, 1000, 90);
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
    else
        return false;
    end

    -- Beautification limit
    local LimitReached = false;
    local Limit = Stronghold.Config.Income.Buildings[Type].Limit;
    if Limit and Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Type) >= Limit then
        LimitReached = true;
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

    -- Beautification limit
    if TechnologyName and string.find(TechnologyName, "^B_Beautification") then
        local TechState = Logic.GetTechnologyState(_PlayerID, _Technology);
        if TechState == 2 or TechState == 3 or TechState == 4 then
            local Type = Entities["P" ..TechnologyName];
            local Limit = Stronghold.Config.Income.Buildings[Type].Limit;
            if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Type) >= Limit then
                XGUIEng.DisableButton(_Button, 1);
            else
                XGUIEng.DisableButton(_Button, 0);
            end
        else
            XGUIEng.DisableButton(_Button, 1);
        end
        return true;
    end
    return false;
end

