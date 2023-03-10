--- 
--- Unit script
---
--- This script implements al unit specific actions and overwrites their
--- selection menus. Also properties like costs, needed rank, upkeep and
--- if they are allowed are defined here.
---
--- Defined game callbacks:
--- - <number> GameCallback_Calculate_UnitPlaces(_PlayerID, _EntityID, _Type, _Places)
---   Allows to overwrite the places a unit is occupying
--- 

Stronghold = Stronghold or {};

Stronghold.Unit = {
    SyncEvents = {},
    Data = {},
    Config = {
        Units = {
            [Entities.PU_LeaderPoleArm1] = {
                Costs = {0, 35, 0, 25, 0, 0, 0},
                Allowed = true,
                Places = 1,
                Rank = 1,
                Upkeep = 15,
            },
            [Entities.PU_LeaderPoleArm2] = {
                Costs = {5, 40, 0, 30, 0, 0, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 20,
            },
            [Entities.PU_LeaderPoleArm3] = {
                Costs = {10, 30, 0, 40, 0, 10, 0},
                Allowed = true,
                Places = 2,
                Rank = 3,
                Upkeep = 40
            },
            [Entities.PU_LeaderPoleArm4] = {
                Costs = {15, 35, 0, 50, 0, 20, 0},
                Allowed = false,
                Places = 2,
                Rank = 0,
                Upkeep = 50
            },
            ---
            [Entities.PU_LeaderSword1] = {
                Costs = {6, 20, 0, 0, 0, 40, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 20,
            },
            [Entities.PU_LeaderSword2] = {
                Costs = {10, 30, 0, 0, 0, 40, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 35,
            },
            [Entities.PU_LeaderSword3] = {
                Costs = {20, 45, 0, 0, 0, 35, 0},
                Allowed = true,
                Places = 2,
                Rank = 5,
                Upkeep = 60,
            },
            [Entities.PU_LeaderSword4] = {
                Costs = {30, 60, 0, 0, 0, 45, 0},
                Allowed = true,
                Places = 3,
                Rank = 7,
                Upkeep = 75,
            },
            ---
            [Entities.PU_LeaderBow1] = {
                Costs = {2, 35, 0, 25, 0, 0, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 15,
            },
            [Entities.PU_LeaderBow2] = {
                Costs = {6, 40, 0, 30, 0, 0, 0},
                Allowed = true,
                Places = 1,
                Rank = 2,
                Upkeep = 20,
            },
            [Entities.PU_LeaderBow3] = {
                Costs = {12, 35, 0, 25, 0, 10, 0},
                Allowed = true,
                Places = 1,
                Rank = 3,
                Upkeep = 35,
            },
            [Entities.PU_LeaderBow4] = {
                Costs = {15, 40, 0, 30, 0, 15, 0},
                Allowed = false,
                Places = 2,
                Rank = 0,
                Upkeep = 50,
            },
            ---
            [Entities.PV_Cannon1] = {
                Costs = {8, 150, 0, 20, 0, 50, 100},
                Allowed = true,
                Places = 5,
                Rank = 3,
                Upkeep = 30,
            },
            [Entities.PV_Cannon2] = {
                Costs = {15, 150, 0, 30, 0, 70, 120},
                Allowed = true,
                Places = 10,
                Rank = 4,
                Upkeep = 50,
            },
            [Entities.PV_Cannon3] = {
                Costs = {25, 300, 0, 50, 0, 500, 250},
                Allowed = true,
                Places = 15,
                Rank = 6,
                Upkeep = 100,
            },
            [Entities.PV_Cannon4] = {
                Costs = {30, 300, 0, 50, 0, 250, 500},
                Allowed = true,
                Places = 20,
                Rank = 7,
                Upkeep = 120,
            },
            ---
            [Entities.PU_LeaderCavalry1] = {
                Costs = {6, 85, 0, 40, 0, 0, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 25,
            },
            [Entities.PU_LeaderCavalry2] = {
                Costs = {10, 95, 0, 40, 0, 20, 0},
                Allowed = true,
                Places = 1,
                Rank = 4,
                Upkeep = 40,
            },
            ---
            [Entities.PU_LeaderHeavyCavalry1] = {
                Costs = {35, 200, 0, 0, 0, 130, 0},
                Allowed = true,
                Places = 3,
                Rank = 6,
                Upkeep = 70,
            },
            [Entities.PU_LeaderHeavyCavalry2] = {
                Costs = {50, 230, 0, 0, 0, 180, 0},
                Allowed = false,
                Places = 4,
                Rank = 7,
                Upkeep = 90,
            },
            ---
            [Entities.PU_LeaderRifle1] = {
                Costs = {20, 90, 0, 10, 0, 0, 60},
                Allowed = true,
                Places = 3,
                Rank = 5,
                Upkeep = 50,
            },
            [Entities.PU_LeaderRifle2] = {
                Costs = {30, 105, 0, 20, 0, 0, 65},
                Allowed = true,
                Places = 1,
                Rank = 6,
                Upkeep = 80,
            },
            ---
            [Entities.PU_Scout] = {
                Costs = {0, 150, 0, 50, 0, 50, 0},
                Allowed = true,
                Places = 0,
                Rank = 2,
                Upkeep = 10,
            },
            [Entities.PU_Thief] = {
                Costs = {30, 500, 0, 0, 0, 100, 100},
                Allowed = true,
                Places = 0,
                Rank = 4,
                Upkeep = 50,
            },
            ---
            [Entities.PU_Serf] = {
                Costs = {0, 50, 0, 0, 0, 0, 0},
                Allowed = true,
                Places = 0,
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

    self:CreateUnitButtonHandlers();
    self:OverrideGUI();
end

function Stronghold.Unit:OnSaveGameLoaded()
end

function Stronghold.Unit:CreateUnitButtonHandlers()
    self.SyncEvents = {
        BuySoldier = 1,
    };

    self.NetworkCall = Syncer.CreateEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Unit.SyncEvents.BuySoldier then
                Stronghold.Unit:RefillUnit(_PlayerID, arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7], arg[8]);
            end
        end
    );
end

function Stronghold.Unit:GetUnitConfig(_Type)
    if self.Config.Units[_Type] then
        return self.Config.Units[_Type];
    end
    return {
        Costs = {0, 0, 0, 0, 0, 0, 0},
        Allowed = false,
        Places = 0,
        Rank = 0,
        Upkeep = 0,
    }
end

function Stronghold.Unit:GetMillitarySize(_PlayerID)
    local Size = 0;
    for k,v in pairs(self.Config.Units) do
        local UnitList = GetPlayerEntities(_PlayerID, k);
        for i= 1, table.getn(UnitList) do
            -- Get unit size
            local Usage = v.Places;
            if Logic.IsLeader(UnitList[i]) == 1 then
                local Soldiers = {Logic.GetSoldiersAttachedToLeader(UnitList[i])};
                Usage = Usage + (Usage * Soldiers[1]);
            end
            -- External
            Usage = GameCallback_Calculate_UnitPlaces(_PlayerID, UnitList[i], k, Usage);

            Size = Size + Usage;
        end
    end
    return Size;
end

-- -------------------------------------------------------------------------- --
-- Callbacks

function GameCallback_Calculate_UnitPlaces(_PlayerID, _EntityID, _Type, _Usage)
    return _Usage;
end

-- -------------------------------------------------------------------------- --
-- Buy Unit (Logic)

function Stronghold.Unit:BuyUnit(_PlayerID, _Type, _BarracksID, _AutoFill)
    if Stronghold:IsPlayer(_PlayerID) then
        if self.Config.Units[_Type] then
            if not IsExisting(_BarracksID) then
                return;
            end
            local Orientation = Logic.GetEntityOrientation(_BarracksID);
            local TypeName = Logic.GetEntityTypeName(_Type);
            local Position = self:GetBarracksDoorPosition(_BarracksID);
            local IsLeader = Logic.IsEntityTypeInCategory(_Type, EntityCategories.Leader) == 1;
            local IsCannon = Logic.IsEntityTypeInCategory(_Type, EntityCategories.Cannon) == 1;
            local Costs = Stronghold:CreateCostTable(unpack(self.Config.Units[_Type].Costs));

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
                    Sound.PlayQueuedFeedbackSound(Sounds.VoicesWorker_WORKER_FunnyNo_rnd_01, 127);
                    Message("Es ist kein Kanonengie??er anwesend!");
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
                Logic.RotateEntity(ID, Orientation +180);
            end
        end
        Stronghold.Players[_PlayerID].BuyUnitLock = nil;
    end
end

function Stronghold.Unit:RefillUnit(_PlayerID, _UnitID, _Amount, _Gold, _Clay, _Wood, _Stone, _Iron, _Sulfur)
    if Stronghold:IsPlayer(_PlayerID) then
        local LeaderType = Logic.GetEntityType(_UnitID);
        if self.Config.Units[LeaderType] then
            if Logic.GetEntityHealth(_UnitID) > 0 then
                if Logic.IsEntityInCategory(_UnitID, EntityCategories.Leader) == 1 then
                    local Task = Logic.GetCurrentTaskList(_UnitID);
                    if not Task or (not string.find(Task, "DIE") and not string.find(Task, "BATTLE")) then
                        local BuildingID = Logic.LeaderGetNearbyBarracks(_UnitID);
                        local Position = self:GetBarracksDoorPosition((BuildingID ~= 0 and BuildingID) or _UnitID);

                        local Costs = Stronghold:CreateCostTable(unpack({
                            0,
                            _Gold or 0,
                            _Clay or 0,
                            _Wood or 0,
                            _Stone or 0,
                            _Iron or 0,
                            _Sulfur or 0
                        }));

                        RemoveResourcesFromPlayer(_PlayerID, Costs);
                        for i= 1, _Amount do
                            local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(_UnitID);
                            local Soldiers = Logic.LeaderGetNumberOfSoldiers(_UnitID);
                            if Soldiers < MaxSoldiers then
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

-- -------------------------------------------------------------------------- --
-- Buy Unit (UI)

function Stronghold.Unit:BuySoldierButtonAction()
    local GuiPlayer = GUI.GetPlayerID();
    local PlayerID = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    if not Stronghold:IsPlayer(PlayerID) then
        return true;
    end
    if GuiPlayer ~= PlayerID then
        return true;
    end

    local BuyAmount = 1;
    if XGUIEng.IsModifierPressed(Keys.ModifierShift)== 1 then
        local CurrentSoldiers = Logic.LeaderGetNumberOfSoldiers(EntityID);
        local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(EntityID);
        BuyAmount = MaxSoldiers - CurrentSoldiers;
    end
    if BuyAmount < 1 then
        return true;
    end
    if not Stronghold:HasPlayerSpaceForUnits(PlayerID, BuyAmount) then
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
        Message("Euer Heer ist bereits gro?? genug!");
        return true;
    end

    local Type = Logic.GetEntityType(EntityID);
    local Costs = self.Config.Units[Type].Costs;
    Costs = Stronghold.Unit:GetCurrentUnitCosts(PlayerID, EntityID, Costs, BuyAmount);
    Costs[ResourceType.Honor] = 0;
    if not HasPlayerEnoughResourcesFeedback(Costs) then
        return true;
    end

    local Task = Logic.GetCurrentTaskList(EntityID);
    if Task and (string.find(Task, "BATTLE") or string.find(Task, "DIE")) then
        return true;
    end

    Stronghold.Players[PlayerID].BuyUnitLock = true;
    Syncer.InvokeEvent(
        Stronghold.Unit.NetworkCall,
        Stronghold.Unit.SyncEvents.BuySoldier,
        EntityID,
        BuyAmount,
        Costs[ResourceType.Gold],
        Costs[ResourceType.Clay],
        Costs[ResourceType.Wood],
        Costs[ResourceType.Stone],
        Costs[ResourceType.Iron],
        Costs[ResourceType.Sulfur]
    );
    return true;
end

function Stronghold.Unit:BuySoldierButtonTooltip(_KeyNormal, _KeyDisabled, _ShortCut)
    local GuiPlayer = GUI.GetPlayerID();
    local PlayerID = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    if not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if GuiPlayer ~= PlayerID then
        return true;
    end

    local BuyAmount = 1;
    if XGUIEng.IsModifierPressed(Keys.ModifierShift)== 1 then
        local CurrentSoldiers = Logic.LeaderGetNumberOfSoldiers(EntityID);
        local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(EntityID);
        BuyAmount = MaxSoldiers - CurrentSoldiers;
    end

    local Type = Logic.GetEntityType(EntityID);
    local Costs = self.Config.Units[Type].Costs;
    Costs = Stronghold.Unit:GetCurrentUnitCosts(PlayerID, EntityID, Costs, BuyAmount);
    Costs[ResourceType.Honor] = nil;

    local Text = "@color:180,180,180 Soldat rekrutieren @color:255,255,255 @cr ";
    if BuyAmount > 1 then
        Text = "@color:180,180,180 Soldaten rekrutieren @color:255,255,255 @cr ";
    end
    Text = Text .. "Heuert Gruppenmitglieder an, um den Hauptmann zu verst??rken.";
    local CostText = FormatCostString(PlayerID, Costs);
    if _KeyNormal == "MenuCommandsGeneric/Buy_Soldier" then
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostText);
    end
    return true;
end

function Stronghold.Unit:BuySoldierButtonUpdate()
    local PlayerID = GUI.GetPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    local Type = Logic.GetEntityType(EntityID);
    if Stronghold:IsPlayer(PlayerID) then
        if not Stronghold.Unit.Config.Units[Type] then
            XGUIEng.ShowWidget("Buy_Soldier_Button", 0);
        end
        if Logic.IsLeader(EntityID) == 0 then
            XGUIEng.ShowWidget("Buy_Soldier_Button", 0);
        end
        local BarracksID = Logic.LeaderGetNearbyBarracks(EntityID);
        local CurrentSoldiers = Logic.LeaderGetNumberOfSoldiers(EntityID);
        local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(EntityID);
        if BarracksID == 0 or CurrentSoldiers == MaxSoldiers then
            XGUIEng.DisableButton("Buy_Soldier_Button", 1);
        else
            XGUIEng.DisableButton("Buy_Soldier_Button", 0);
        end
        return true;
    end
    return false;
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

function Stronghold.Unit:GetCurrentUnitCosts(_PlayerID, _EntityID, _Costs, _Amount)
    local Costs = CopyTable(_Costs);
    for i= 2, 7 do
        Costs[i] = Costs[i] * _Amount;
    end
    Costs = Stronghold:CreateCostTable(unpack(Costs));
    Costs = Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, Costs);
    return Costs;
end

-- -------------------------------------------------------------------------- --
-- Expel

function Stronghold.Unit:ExpelSettlerButtonTooltip(_Key)
    local PlayerID = Stronghold:GetLocalPlayerID();
    if Stronghold:IsPlayer(PlayerID) then
        if _Key == "MenuCommandsGeneric/expel" then
            local Text = "@color:180,180,180 Einheit entlassen @color:255,255,255 @cr "..
                            "Entlasst die selektierte Einheit aus ihrem Dienst. Wenn Ihr "..
                            "Soldaten entlasst, geht der Hauptmann zuletzt.";
            if XGUIEng.IsModifierPressed(Keys.ModifierShift) == 1 then
                Text   = "@color:180,180,180 Alle entlassen @color:255,255,255 @cr "..
                            "Entlasst alle selektierten Einheiten aus ihrem Dienst. Alle "..
                            "Einheiten werden sofort entlassen!";
            end
            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
            return true;
        end
    end
    return false;
end

function Stronghold.Unit:ExpelSettlerButtonAction()
    local GuiPlayer = GUI.GetPlayerID();
    local PlayerID = Stronghold:GetLocalPlayerID();
    local EntityID = GUI.GetSelectedEntity();
    if not Stronghold:IsPlayer(PlayerID) then
        return true;
    end
    if GuiPlayer ~= PlayerID then
        return true;
    end

    -- Stops the player from expeling workers to get new with full energy.
    if Logic.IsWorker(EntityID) == 1 and Logic.GetSettlersWorkBuilding(EntityID) ~= 0 then
        return true;
    end
    if XGUIEng.IsModifierPressed(Keys.ModifierShift) == 1 then
        local Selected = {GUI.GetSelectedEntities()};
        GUI.ClearSelection();
        for i= 1, table.getn(Selected) do
            if Logic.IsHero(Selected[i]) == 0 then
                if Logic.IsLeader(Selected[i]) == 1 then
                    local Soldiers = {Logic.GetSoldiersAttachedToLeader(Selected[i])};
                    for j= 2, Soldiers[1] +1 do
                        GUI.ExpelSettler(Soldiers[j]);
                    end
                end
                GUI.ExpelSettler(Selected[i]);
            end
        end
        return true;
    end
    return false;
end

-- -------------------------------------------------------------------------- --
-- UI

function Stronghold.Unit:OverrideGUI()
    Overwrite.CreateOverwrite(
        "GUIAction_BuySoldier",
        function()
            if not Stronghold.Unit:BuySoldierButtonAction() then
                Overwrite.CallOriginal();
            end
        end
    );

    Overwrite.CreateOverwrite(
        "GUIUpdate_BuySoldierButton",
        function()
            Overwrite.CallOriginal();
            return Stronghold.Unit:BuySoldierButtonUpdate();
        end
    );

    Overwrite.CreateOverwrite(
        "GUITooltip_NormalButton",
        function(_Key)
            Overwrite.CallOriginal();
            Stronghold.Unit:ExpelSettlerButtonTooltip(_Key);
        end
    );

    Overwrite.CreateOverwrite(
        "GUIAction_ExpelSettler",
        function()
            if not Stronghold.Unit:ExpelSettlerButtonAction() then
                Overwrite.CallOriginal();
            end
        end
    );

    Overwrite.CreateOverwrite(
        "GUITooltip_BuySoldier",
        function(_KeyNormal, _KeyDisabled, _ShortCut)
            Overwrite.CallOriginal();
            Stronghold.Unit:BuySoldierButtonTooltip(_KeyNormal, _KeyDisabled, _ShortCut);
        end
    );
end

