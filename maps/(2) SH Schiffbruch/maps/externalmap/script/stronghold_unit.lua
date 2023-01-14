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
                Costs = {10, 40, 0, 40, 0, 10, 0},
                Allowed = true,
                Places = 2,
                Rank = 3,
                Upkeep = 70
            },
            [Entities.PU_LeaderPoleArm4] = {
                Costs = {15, 50, 0, 50, 0, 20, 0},
                Allowed = false,
                Places = 2,
                Rank = 0,
                Upkeep = 80
            },
            ---
            [Entities.PU_LeaderSword1] = {
                Costs = {6, 20, 0, 0, 0, 40, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 25,
            },
            [Entities.PU_LeaderSword2] = {
                Costs = {10, 30, 0, 0, 0, 40, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 40,
            },
            [Entities.PU_LeaderSword3] = {
                Costs = {20, 60, 0, 0, 0, 40, 0},
                Allowed = true,
                Places = 2,
                Rank = 5,
                Upkeep = 100,
            },
            [Entities.PU_LeaderSword4] = {
                Costs = {30, 80, 0, 0, 0, 60, 0},
                Allowed = true,
                Places = 3,
                Rank = 8,
                Upkeep = 120,
            },
            ---
            [Entities.PU_LeaderBow1] = {
                Costs = {2, 50, 0, 30, 0, 0, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 25,
            },
            [Entities.PU_LeaderBow2] = {
                Costs = {6, 60, 0, 40, 0, 0, 0},
                Allowed = true,
                Places = 1,
                Rank = 2,
                Upkeep = 30,
            },
            [Entities.PU_LeaderBow3] = {
                Costs = {12, 70, 0, 40, 0, 20, 0},
                Allowed = true,
                Places = 2,
                Rank = 4,
                Upkeep = 80,
            },
            [Entities.PU_LeaderBow4] = {
                Costs = {15, 80, 0, 50, 0, 40, 0},
                Allowed = false,
                Places = 3,
                Rank = 0,
                Upkeep = 90,
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
                Costs = {15, 10, 0, 30, 0, 70, 120},
                Allowed = true,
                Places = 10,
                Rank = 5,
                Upkeep = 50,
            },
            [Entities.PV_Cannon3] = {
                Costs = {25, 300, 0, 50, 0, 500, 250},
                Allowed = true,
                Places = 15,
                Rank = 7,
                Upkeep = 100,
            },
            [Entities.PV_Cannon4] = {
                Costs = {30, 300, 0, 50, 0, 250, 500},
                Allowed = true,
                Places = 20,
                Rank = 9,
                Upkeep = 120,
            },
            ---
            [Entities.PU_LeaderCavalry1] = {
                Costs = {6, 100, 0, 60, 0, 0, 0},
                Allowed = false,
                Places = 1,
                Rank = 0,
                Upkeep = 40,
            },
            [Entities.PU_LeaderCavalry2] = {
                Costs = {10, 120, 0, 60, 0, 40, 0},
                Allowed = true,
                Places = 2,
                Rank = 4,
                Upkeep = 70,
            },
            ---
            [Entities.PU_LeaderHeavyCavalry1] = {
                Costs = {30, 200, 0, 0, 0, 130, 0},
                Allowed = true,
                Places = 3,
                Rank = 7,
                Upkeep = 120,
            },
            [Entities.PU_LeaderHeavyCavalry2] = {
                Costs = {40, 230, 0, 0, 0, 180, 0},
                Allowed = false,
                Places = 4,
                Rank = 9,
                Upkeep = 150,
            },
            ---
            [Entities.PU_LeaderRifle1] = {
                Costs = {20, 90, 0, 10, 0, 0, 40},
                Allowed = true,
                Places = 3,
                Rank = 6,
                Upkeep = 70,
            },
            [Entities.PU_LeaderRifle2] = {
                Costs = {30, 110, 0, 20, 0, 0, 60},
                Allowed = true,
                Places = 2,
                Rank = 8,
                Upkeep = 100,
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
                Rank = 5,
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

        TypesToCheckForConstruction = {
            [Technologies.B_Beautification01] = {Entities.PB_Beautification01},
            [Technologies.B_Beautification02] = {Entities.PB_Beautification02},
            [Technologies.B_Beautification03] = {Entities.PB_Beautification03},
            [Technologies.B_Beautification04] = {Entities.PB_Beautification04},
            [Technologies.B_Beautification05] = {Entities.PB_Beautification05},
            [Technologies.B_Beautification06] = {Entities.PB_Beautification06},
            [Technologies.B_Beautification07] = {Entities.PB_Beautification07},
            [Technologies.B_Beautification08] = {Entities.PB_Beautification08},
            [Technologies.B_Beautification09] = {Entities.PB_Beautification09},
            [Technologies.B_Beautification10] = {Entities.PB_Beautification10},
            [Technologies.B_Beautification11] = {Entities.PB_Beautification11},
            [Technologies.B_Beautification12] = {Entities.PB_Beautification12},

            [Technologies.B_Barracks]         = {Entities.PB_Barracks1, Entities.PB_Barracks2,},
            [Technologies.B_Archery]          = {Entities.PB_Archery1, Entities.PB_Archery2,},
            [Technologies.B_Stables]          = {Entities.PB_Stable1, Entities.PB_Stable2,},
            [Technologies.B_Monastery]        = {Entities.PB_Monastery1, Entities.PB_Monastery2, Entities.PB_Monastery3},
            [Technologies.B_PowerPlant]       = {Entities.PB_PowerPlant1},
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
    self:OverrideBuySoldierButtonAction();
    self:OverrideBuySoldierButtonTooltip();
    self:OverrideBuySoldierButtonUpdate();
    self:OverrideExpelSettlerButtonAction();
    self:OverrideExpelSettlerButtonTooltip();
    self:CreateUnitButtonHandlers();
end

function Stronghold.Unit:OnSaveGameLoaded()
end

function Stronghold.Unit:CreateUnitButtonHandlers()
    self.SyncEvents = {
        BuySoldier = 1,
    };

    self.NetworkCall = Stronghold.Sync:CreateSyncEvent(
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
        local UnitList = GetEntitiesOfType(_PlayerID, k);
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
-- Buy Unit

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
                if _BarracksID == GetID(Stronghold.Players[_PlayerID].HQScriptName) then
                    local CampPos = Stronghold.Players[_PlayerID].CampPos;
                    Logic.MoveSettler(ID, CampPos.X, CampPos.Y);
                else
                    Logic.RotateEntity(ID, Orientation +180);
                end
            end
        end

        Stronghold:AddDelayedAction(3, function(_PlayerID)
            Stronghold.Players[_PlayerID].BuyUnitLock = nil;
        end, _PlayerID);
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
        Stronghold:AddDelayedAction(1, function(_PlayerID)
            Stronghold.Players[_PlayerID].BuyUnitLock = nil;
        end, _PlayerID);
    end
end

function Stronghold.Unit:OverrideBuySoldierButtonAction()
    self.Orig_GUIAction_BuySoldier = GUIAction_BuySoldier;
    GUIAction_BuySoldier = function()
        local GuiPlayer = GUI.GetPlayerID();
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUIAction_BuySoldier();
        end
        if GuiPlayer ~= PlayerID then
            return;
        end

        local BuyAmount = 1;
        if XGUIEng.IsModifierPressed(Keys.ModifierShift)== 1 then
            local CurrentSoldiers = Logic.LeaderGetNumberOfSoldiers(EntityID);
            local MaxSoldiers = Logic.LeaderGetMaxNumberOfSoldiers(EntityID);
            BuyAmount = MaxSoldiers - CurrentSoldiers;
        end
        if BuyAmount < 1 then
            return;
        end
        if not Stronghold:HasPlayerSpaceForUnits(PlayerID, BuyAmount) then
            Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01, 127);
            Message("Euer Heer ist bereits groß genug!");
            return;
        end

        local Type = Logic.GetEntityType(EntityID);
        local Costs = self.Config.Units[Type].Costs;
        Costs = Stronghold.Unit:GetCurrentUnitCosts(PlayerID, EntityID, Costs, BuyAmount);
        Costs[ResourceType.Honor] = 0;
        if not HasPlayerEnoughResourcesFeedback(Costs) then
            return;
        end

        local Task = Logic.GetCurrentTaskList(EntityID);
        if Task and (string.find(Task, "BATTLE") or string.find(Task, "DIE")) then
            return;
        end

        Stronghold.Players[PlayerID].BuyUnitLock = true;
        Stronghold.Sync:Call(
            Stronghold.Unit.NetworkCall,
            PlayerID,
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
    end
end

function Stronghold.Unit:OverrideBuySoldierButtonTooltip()
    self.Orig_GUITooltip_BuySoldier = GUITooltip_BuySoldier;
    GUITooltip_BuySoldier = function(_KeyNormal, _KeyDisabled, _ShortCut)
        local GuiPlayer = GUI.GetPlayerID();
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUITooltip_BuySoldier(_KeyNormal, _KeyDisabled, _ShortCut);
        end
        if GuiPlayer ~= PlayerID then
            return;
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
        Text = Text .. "Heuert Gruppenmitglieder an, um den Hauptmann zu verstärken.";
        local CostText = FormatCostString(PlayerID, Costs);
        if _KeyNormal == "MenuCommandsGeneric/Buy_Soldier" then
            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostText);
        end
    end
end

function Stronghold.Unit:OverrideBuySoldierButtonUpdate()
    self.Orig_GUIUpdate_BuySoldierButton = GUIUpdate_BuySoldierButton;
    GUIUpdate_BuySoldierButton = function()
        local PlayerID = GUI.GetPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        local Type = Logic.GetEntityType(EntityID);
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUIUpdate_BuySoldierButton();
        end
        if not self.Config.Units[Type] then
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
            return;
        end
        XGUIEng.DisableButton("Buy_Soldier_Button", 0);
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

function Stronghold.Unit:OverrideExpelSettlerButtonAction()
    self.Orig_GUIAction_ExpelSettler = GUIAction_ExpelSettler;
    GUIAction_ExpelSettler = function()
        local GuiPlayer = GUI.GetPlayerID();
        local PlayerID = Stronghold:GetLocalPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUIAction_ExpelSettler();
        end
        if GuiPlayer ~= PlayerID then
            return;
        end
        if XGUIEng.IsModifierPressed(Keys.ModifierShift) == 1 then
            local Selected = {GUI.GetSelectedEntities()};
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
            return;
        end
        Stronghold.Unit.Orig_GUIAction_ExpelSettler();
    end
end

function Stronghold.Unit:OverrideExpelSettlerButtonTooltip()
    self.Orig_GUITooltip_NormalButton = GUITooltip_NormalButton;
    GUITooltip_NormalButton = function(_Key)
        local PlayerID = Stronghold:GetLocalPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUITooltip_NormalButton(_Key);
        end
        if _Key == "MenuCommandsGeneric/expel" then
            local Text = "@color:180,180,180 Einheit entlassen @color:255,255,255 @cr "..
                         "Entlasst die selektierte Einheit aus ihrem Dienst. Wenn Ihr "..
                         "Soldaten entlasst, geht der Hauptmann zuletzt.";
            if XGUIEng.IsModifierPressed(Keys.ModifierShift)== 1 then
                Text   = "@color:180,180,180 Alle entlassen @color:255,255,255 @cr "..
                         "Entlasst alle selektierten Einheiten aus ihrem Dienst. Alle "..
                         "Einheiten werden sofort entlassen!";
            end
            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
            return;
        end
        Stronghold.Unit.Orig_GUITooltip_NormalButton(_Key);
    end
end


-- -------------------------------------------------------------------------- --
-- Construction

function Stronghold.Unit:OverrideTooltipConstructionButton()
    self.Orig_GUITooltip_ConstructBuilding = GUITooltip_ConstructBuilding;
    GUITooltip_ConstructBuilding = function(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
        local PlayerID = Stronghold:GetLocalPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Unit.Orig_GUITooltip_ConstructBuilding(_UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut);
        end
        local IsForbidden = false;

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
            if _Technology and Logic.GetTechnologyState(PlayerID, _Technology) == 0 then
                Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
                IsForbidden = true;
            end
        else
            Logic.FillBuildingCostsTable(Type, InterfaceGlobals.CostTable);
            CostString = InterfaceTool_CreateCostString(InterfaceGlobals.CostTable);
            if _ShortCut then
                ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name")..
                    ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]"
            end
        end

        local EffectText = "";
        if not IsForbidden then
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

            local BuildingMax = math.ceil(GetLimitOfType(Type) * LimitFactor);
            if BuildingMax > -1 then
                local BuildingCount = GetUsageOfType(PlayerID, Type);
                Text = TextHeadline.. " (" ..BuildingCount.. "/" ..BuildingMax.. ") @cr " .. TextBody;
            end
        end
        Text = Text .. EffectText;

        -- Set text
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostString);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip);
    end
end

function Stronghold.Unit:OverrideUpdateConstructionButton()
    self.Orig_GUIUpdate_BuildingButtons = GUIUpdate_BuildingButtons;
    GUIUpdate_BuildingButtons = function(_Button, _Technology)
        local PlayerID = Stronghold:GetLocalPlayerID();
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
        local PlayerID = Stronghold:GetLocalPlayerID();
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

    local LimitReached = false;
    local CheckList = Stronghold.Unit.Config.TypesToCheckForConstruction[_Technology];

    local Usage = 0;
    local Limit = -1;
    if CheckList then
        Limit = GetLimitOfType(CheckList[1]);
    end
    if Limit > -1 then
        for i= 1, table.getn(CheckList) do
            Usage = Usage + GetUsageOfType(_PlayerID, CheckList[i]);
        end
        local LimitFactor = 1.0;
        if TechnologyName and string.find(TechnologyName, "^B_Beautification") then
            if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters2) > 0 then
                LimitFactor = 1.5;
            end
            if Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Headquarters3) > 0 then
                LimitFactor = 2.0;
            end
        end
        LimitReached = math.ceil(Limit * LimitFactor) <= Usage;
    end

    if LimitReached then
        XGUIEng.DisableButton(_Button, 1);
        return true;
    end
    return false;
end

