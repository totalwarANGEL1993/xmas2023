--- 
--- Spawner Script
--- 

Stronghold = Stronghold or {};

Stronghold.Spawner = {
    Data = {
        SpawnerSequenceID = 0,
    },
    Config = {},
}

function Stronghold.Spawner:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {
            Spawner = {},
        };
    end
end

function Stronghold.Spawner:OnSaveGameLoaded()
end

-- -------------------------------------------------------------------------- --

function CreateTroopSpawner(_PlayerID, _ScriptName, _SpawnPosition, _SpawnMax, _RespawnTime, _DefArea, ...)
    return Stronghold.Spawner:CreateSpawner(_PlayerID, _ScriptName, _SpawnPosition, _SpawnMax, _RespawnTime, _DefArea, unpack(arg));
end

function DestroyTroopSpawner(_PlayerID, _SpawnerID)
    return Stronghold.Spawner:DestroySpawner(_PlayerID, _SpawnerID);
end

function HasSpawnerFullStrength(_PlayerID, _SpawnerID)
    return Stronghold.Spawner:HasFullStrength(_PlayerID, _SpawnerID);
end

function CountTroopsBySpawner(_PlayerID, _SpawnerID)
    return Stronghold.Spawner:CountTroops(_PlayerID, _SpawnerID);
end

function GetTroopFromSpawner(_PlayerID, _SpawnerID)
    return Stronghold.Spawner:GetTroop(_PlayerID, _SpawnerID);
end

-- -------------------------------------------------------------------------- --

function Stronghold.Spawner:CreateSpawner(_PlayerID, _ScriptName, _SpawnPosition, _SpawnMax, _RespawnTime, _DefArea, ...)
    if _SpawnPosition == nil then
        local Position = GetPosition(_ScriptName);
        local ID = AI.Entity_CreateFormation(_PlayerID, Entities.PU_Serf, 0, 0, Position.X, Position.Y, 0, 0, 0, 0);
        local x,y,z = Logic.EntityGetPos(ID);
        DestroyEntity(ID);
        _SpawnPosition = {X= x, Y= y, Z= z};
    end

    assert(_SpawnMax >= 2);
    assert(_RespawnTime >= 15);
    assert(_DefArea >= 1500);

    self.Data.SpawnerSequenceID = self.Data.SpawnerSequenceID +1;
    local Spawner = {
        AllowedTypes = {},
        SpawnedTroops = {},

        ID = self.Data.SpawnerSequenceID,
        ScriptName = _ScriptName,
        DefendArea = _DefArea,
        PlayerID = _PlayerID,
        SpawnPosition = _SpawnPosition,
        MaxAmount = _SpawnMax,
        RespawnTime = _RespawnTime,
        Timer = 0,
    };

    local JobID = Job.Second(
        function(_PlayerID, _SpawnerID)
            Stronghold.Spawner:ControlSpawner(_PlayerID, _SpawnerID);
        end,
        _PlayerID,
        Spawner.ID
    );
    Spawner.JobID = JobID;
    Spawner.AllowedTypes = CopyTable(arg);
    self.Data[_PlayerID].Spawner[Spawner.ID] = Spawner;
    return Spawner.ID;
end

function Stronghold.Spawner:DestroySpawner(_PlayerID, _SpawnerID)
    if self.Data[_PlayerID].Spawner[_SpawnerID] then
        if JobIsRunning(self.Data[_PlayerID].Spawner[_SpawnerID].JobID) then
            EndJob(self.Data[_PlayerID].Spawner[_SpawnerID].JobID);
        end
        self.Data[_PlayerID].Spawner[_SpawnerID] = nil;
    end
end

function Stronghold.Spawner:HasFullStrength(_PlayerID, _SpawnerID)
    if self.Data[_PlayerID].Spawner[_SpawnerID] then
        return self:CountTroops(_PlayerID, _SpawnerID) >= self.Data[_PlayerID].Spawner[_SpawnerID].MaxAmount;
    end
    return false;
end

function Stronghold.Spawner:CountTroops(_PlayerID, _SpawnerID)
    if self.Data[_PlayerID].Spawner[_SpawnerID] then
        return table.getn(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops);
    end
    return 0;
end

function Stronghold.Spawner:GetTroop(_PlayerID, _SpawnerID)
    if self.Data[_PlayerID].Spawner[_SpawnerID] then
        return table.remove(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops, 1);
    end
    return 0;
end

function Stronghold.Spawner:CreateTroop(_PlayerID, _SpawnerID)
    local Data = self.Data[_PlayerID].Spawner[_SpawnerID];
    local ID = AI.Entity_CreateFormation(
        _PlayerID,
        Data.AllowedTypes[math.random(1, table.getn(Data.AllowedTypes))],
        0, 0,
        Data.SpawnPosition.X, Data.SpawnPosition.Y,
        0, 0, 3, 0
    );
    Tools.CreateSoldiersForLeader(ID, 16);
    table.insert(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops, ID);
    return ID;
end

function Stronghold.Spawner:GetNextEnemy(_PlayerID, _Position, _Area)
    local EnemiesInArea = GetEnemiesInArea(_PlayerID, _Position, _Area);
    table.sort(EnemiesInArea, function(a, b)
        if not a then return false; end
        if not b then return true; end
        return GetDistance(a, _Position) < GetDistance(b, _Position);
    end);
    return EnemiesInArea[1] or 0;
end

-- -------------------------------------------------------------------------- --

function Stronghold.Spawner:ControlSpawner(_PlayerID, _SpawnerID)
    if self.Data[_PlayerID].Spawner[_SpawnerID] then
        local Data = self.Data[_PlayerID].Spawner[_SpawnerID];

        -- Check existing
        if not IsExisting(Data.ScriptName) then
            self.Data[_PlayerID].Spawner[_SpawnerID] = nil;
            return true;
        end

        -- Check inital spawn
        if not Data.InitalSpawn then
            for i= 1, Data.MaxAmount do
                self:CreateTroop(_PlayerID, _SpawnerID);
            end
            self.Data[_PlayerID].Spawner[_SpawnerID].InitalSpawn = true;
            return;
        end

        -- Spawn troops
        if self:CountTroops(_PlayerID, _SpawnerID) < Data.MaxAmount then
            self.Data[_PlayerID].Spawner[_SpawnerID].Timer = Data.Timer -1;
            if Data.Timer <= 0 then
                self.Data[_PlayerID].Spawner[_SpawnerID].Timer = Data.RespawnTime;
                self:CreateTroop(_PlayerID, _SpawnerID);
            end
        end

        -- Update troops
        for i= table.getn(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops), 1, -1 do
            if not IsExisting(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops[i]) then
                table.remove(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops, i);
            end
        end

        -- Attack near enemies
        local EnemyID =  self:GetNextEnemy(_PlayerID, Data.SpawnPosition, Data.DefendArea);
        if EnemyID ~= 0 then
            for i= table.getn(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops), 1, -1 do
                local ID = self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops[i];
                local Task = Logic.GetCurrentTaskList(ID);
                if  (not Task or (not string.find(Task, "BATTLE") and not string.find(Task, "DIE")))
                and Logic.IsEntityMoving(ID) == false then
                    Logic.GroupAttack(ID, EnemyID);
                end
            end
        end

        -- Check in defend area
        for i= table.getn(self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops), 1, -1 do
            local ID = self.Data[_PlayerID].Spawner[_SpawnerID].SpawnedTroops[i];
            if GetDistance(ID, Data.SpawnPosition) > Data.DefendArea then
                Logic.MoveSettler(ID, Data.SpawnPosition.X, Data.SpawnPosition.Y);
            end
        end
    end
end

