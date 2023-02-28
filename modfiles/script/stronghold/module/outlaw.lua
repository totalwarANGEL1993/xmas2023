--- 
--- Outlaw Script
--- 
--- This implements a simple script for non player camps that are hostile
--- to all players. Those camps will spawn troops over time and if they
--- get large enough they launch a attack to the closest headquarters or
--- to a specified player.
---
--- They will NOT target inteligently. They are just simple mobs. Their
--- purpose is just to be a inconvenience and not a serious threat. 
--- 

Stronghold = Stronghold or {};

OutlawAttackState = {
    -- The camp waits for troops to respawn.
    Recruit = 1,
    -- The camp moves the troops to the attack target.
    Advance = 2,
    -- The camp attacks all targets in the area.
    Pillage = 3,
};

Stronghold.Outlaw = {
    Data = {
        CampSequenceID = 0,
    },
    Config = {},
}

function Stronghold.Outlaw:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {
            Spawner = {},
            Camps = {},
        };
    end
end

function Stronghold.Outlaw:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

function Stronghold.Outlaw:GetNextEnemy(_PlayerID, _Position, _Area)
    local EnemiesInArea = GetEnemiesInArea(_PlayerID, _Position, _Area);
    table.sort(EnemiesInArea, function(a, b)
        if not a then return false; end
        if not b then return true; end
        return GetDistance(a, _Position) < GetDistance(b, _Position);
    end);
    return EnemiesInArea[1] or 0;
end

-- -------------------------------------------------------------------------- --

function Stronghold.Outlaw:CreateCamp(_PlayerID, _HomePosition, _AtkTarget, _AtkArea, _AtkStrength)
    self.Data.CampSequenceID = self.Data.CampSequenceID +1;
    local Camp = {
        SpawnerList = {},
        Troops = {},
        State = OutlawAttackState.Recruit,

        ID = self.Data.CampSequenceID,
        PlayerID = _PlayerID,
        Position = _HomePosition,
        AttackTarget = _AtkTarget,
        AttackArea = _AtkArea,
        AttackStrength = _AtkStrength,
        IsDefeated = false,
        CanAttack = false,
    };

    local JobID = Job.Second(function(_PlayerID, _CampID)
        Stronghold.Outlaw:ControlCamp(_PlayerID, _CampID);
    end, _PlayerID, Camp.ID);
    Camp.JobID = JobID;

    self.Data[_PlayerID].Camps[Camp.ID] = Camp;
    return Camp.ID;
end

function Stronghold.Outlaw:DestroyCamp(_PlayerID, _CampID)
    if self.Data[_PlayerID].Camps[_CampID] then
        local Data = self.Data[_PlayerID].Camps[_CampID];
        if JobIsRunning(Data.JobID) then
            EndJob(Data.JobID);
        end
        for i= table.getn(Data.Troops), 1, -1 do
            DestroyEntity(Data.Troops[i]);
        end
        self.Data[_PlayerID].Camps[_CampID] = nil;
    end
end

function Stronghold.Outlaw:SetAttackTarget(_PlayerID, _CampID, _AtkTarget)
    if self.Data[_PlayerID].Camps[_CampID] then
        self.Data[_PlayerID].Camps[_CampID].AttackTarget = _AtkTarget;
    end
end

function Stronghold.Outlaw:SetAttackArea(_PlayerID, _CampID, _AtkArea)
    if self.Data[_PlayerID].Camps[_CampID] then
        self.Data[_PlayerID].Camps[_CampID].AttackArea = _AtkArea;
    end
end

function Stronghold.Outlaw:SetAttackAllowed(_PlayerID, _CampID, _CanAttack)
    if self.Data[_PlayerID].Camps[_CampID] then
        self.Data[_PlayerID].Camps[_CampID].CanAttack = _CanAttack == true;
    end
end

function Stronghold.Outlaw:AddSpawner(_PlayerID, _CampID, _SpawnerID)
    if self.Data[_PlayerID].Camps[_CampID] then
        if not IsInTable(_SpawnerID, self.Data[_PlayerID].Camps[_CampID].SpawnerList) then
            table.insert(self.Data[_PlayerID].Camps[_CampID].SpawnerList, _SpawnerID);
        end
    end
end

function Stronghold.Outlaw:RemoveSpawner(_PlayerID, _CampID, _SpawnerID)
    if self.Data[_PlayerID].Camps[_CampID] then
        for i= table.getn(self.Data[_PlayerID].Camps[_CampID].SpawnerList), 1, -1 do
            if self.Data[_PlayerID].Camps[_CampID].SpawnerList[i] == _SpawnerID then
                table.remove(self.Data[_PlayerID].Camps[_CampID].SpawnerList, i);
                break;
            end
        end
    end
end

-- -------------------------------------------------------------------------- --

function Stronghold.Outlaw:ControlCamp(_PlayerID, _CampID)
    if self.Data[_PlayerID].Camps[_CampID] then
        local Data = self.Data[_PlayerID].Camps[_CampID];

        -- Check defeated
        if Data.IsDefeated then
            return true;
        end
        -- Check spawner
        for i= table.getn(Data.Spawner), 1, -1 do
            local Spawner = self.Data[_PlayerID].Spawner[Data.Spawner[i]];
            if not Spawner or not IsExisting(Spawner.ScriptName) then
                table.remove(self.Data[_PlayerID].Camps[_CampID].Spawner, i);
            end
        end
        if table.getn(Data.Spawner) == 0 then
            self.Data[_PlayerID].Camps[_CampID].IsDefeated = true;
        end

        if not Data.IsDefeated then
            if Data.State == OutlawAttackState.Recruit then
                if table.getn(Data.Troops) >= Data.AttackStrength then
                    self.Data[_PlayerID].Camps[_CampID].State = OutlawAttackState.Advance;
                else
                    -- Fill troops for attack
                    if Data.CanAttack then
                        for i= table.getn(Data.Spawner), 1, -1 do
                            if self:HasFullStrength(_PlayerID, Data.Spawner[i]) then
                                local ID = self:GetTroop(_PlayerID, Data.Spawner[i]);
                                table.insert(self.Data[_PlayerID].Camps[_CampID].Troops, ID);
                            end
                            if table.getn(Data.Troops) >= Data.AttackStrength then
                                self.Data[_PlayerID].Camps[_CampID].State = OutlawAttackState.Advance;
                                break;
                            end
                        end
                    end

                    -- Defend against enemies
                    -- TODO?
                end

            elseif Data.State == OutlawAttackState.Advance then
                -- Check if attack is defeated
                if table.getn(Data.Troops) / Data.AttackStrength < 0.3 then
                    self.Data[_PlayerID].Camps[_CampID].State = OutlawAttackState.Recruit;
                    for i= table.getn(Data.Troops), 1, -1 do
                        DestroyEntity(Data.Troops[i]);
                    end
                    self.Data[_PlayerID].Camps[_CampID].Troops = {};
                -- Check if attack target is reached
                elseif GetDistance(Data.Troops[1], Data.AttackTarget) <= 1000 then
                    self.Data[_PlayerID].Camps[_CampID].State = OutlawAttackState.Pillage;
                -- Move troops to attack target
                else
                    for i= table.getn(Data.Troops), 1, -1 do
                        if not IsExisting(Data.Troops[i]) then
                            table.remove(self.Data[_PlayerID].Camps[_CampID].Troops, i);
                        else
                            local Task = Logic.GetCurrentTaskList(ID);
                            if  Logic.IsEntityMoving(Data.Troops[i]) == false
                            and (not Task or not string.find(Task, "BATTLE")) then
                                Logic.GroupAttackMove(Data.Troops[i], Data.AttackTarget.X, Data.AttackTarget.Y);
                            end
                        end
                    end
                end

            elseif Data.State == OutlawAttackState.Pillage then
                -- Check if attack is defeated
                if table.getn(Data.Troops) / Data.AttackStrength < 0.3 then
                    self.Data[_PlayerID].Camps[_CampID].State = OutlawAttackState.Recruit;
                    for i= table.getn(Data.Troops), 1, -1 do
                        DestroyEntity(Data.Troops[i]);
                    end
                    self.Data[_PlayerID].Camps[_CampID].Troops = {};
                else
                    -- Search for enemies to kill
                    local EnemyFound = false;
                    for i= table.getn(Data.Troops), 1, -1 do
                        if not IsExisting(Data.Troops[i]) then
                            table.remove(self.Data[_PlayerID].Camps[_CampID].Troops, i);
                        else
                            if GetDistance(Data.Troops[i], Data.AttackPos) > Data.AttackArea then
                                Logic.MoveSettler(Data.Troops[i], Data.AttackPos.X, Data.AttackPos.Y);
                            else
                                local Task = Logic.GetCurrentTaskList(Data.Troops[i]);
                                if  (not Task and (not string.find(Task, "BATTLE") and not string.find(Task, "DIE")))
                                and Logic.IsEntityMoving(Data.Troops[i]) == false then
                                    local EnemyID = self:GetNextEnemy(_PlayerID, Data.AttackPos, Data.AttackArea);
                                    if EnemyID ~= 0 then
                                        Logic.GroupAttack(Data.Troops[i], EnemyID);
                                        EnemyFound = true;
                                    end
                                end
                            end
                        end
                    end
                    -- End attack if done
                    if not EnemyFound then
                        self.Data[_PlayerID].Camps[_CampID].State = OutlawAttackState.Recruit;
                        for i= table.getn(Data.Troops), 1, -1 do
                            DestroyEntity(Data.Troops[i]);
                        end
                        self.Data[_PlayerID].Camps[_CampID].Troops = {};
                    end
                end
            end
        end
    end
end

-- -------------------------------------------------------------------------- --



