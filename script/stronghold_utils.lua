-- 
-- 
-- 

-- -------------------------------------------------------------------------- --
-- UI Tools

function Stronghold:HasPlayerEnoughResourcesFeedback(_Costs)
    local PlayerID = GUI.GetPlayerID();
    if not self.Players[PlayerID] then
        return InterfaceTool_HasPlayerEnoughResources_Feedback(_Costs) == 1;
    end

    local CanBuy = true;
	local Honor = self:GetPlayerHonor(PlayerID);
    if _Costs[ResourceType.Honor] ~= nil and _Costs[ResourceType.Honor] - Honor > 0 then
		CanBuy = false;
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough);
		GUI.AddNote(string.format(
            "%d Ehre muss noch erlangt werden.",
            _Costs[ResourceType.Honor] - Honor
        ));
	end
    CanBuy = InterfaceTool_HasPlayerEnoughResources_Feedback(_Costs) == 1 and CanBuy;
    return CanBuy == true;
end
function HasPlayerEnoughResourcesFeedback(_Costs)
    return Stronghold:HasPlayerEnoughResourcesFeedback(_Costs);
end

function Stronghold:FormatCostString(_PlayerID, _Costs)
    local CostString = "";
    if not self.Players[_PlayerID] then
        return CostString;
    end

	local Honor     = self.Players[_PlayerID].Honor;
	local GoldRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.GoldRaw);
	local Gold      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Gold);
    local ClayRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.ClayRaw);
    local Clay      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Clay);
	local WoodRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.WoodRaw);
	local Wood      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Wood);
	local IronRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.IronRaw);
	local Iron      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Iron);
	local StoneRaw  = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.StoneRaw);
	local Stone     = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Stone);
    local SulfurRaw = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.SulfurRaw);
    local Sulfur    = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Sulfur);

    local ColWhite = " @color:255,255,255 ";
    local ColRed   = " @color:255,32,32 ";

    if _Costs[ResourceType.Honor] ~= nil then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. " Ehre:";
        if Honor < _Costs[ResourceType.Honor] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Honor];
    end
    if _Costs[ResourceType.Gold] ~= nil then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. " Taler:";
        if Gold+GoldRaw < _Costs[ResourceType.Gold] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Gold];
    end
	if _Costs[ResourceType.Clay] ~= nil  then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. " Lehm:";
		if Clay+ClayRaw < _Costs[ResourceType.Clay] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Clay];
	end
	if _Costs[ResourceType.Wood] ~= nil then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. " Holz:";
		if Wood+WoodRaw < _Costs[ResourceType.Wood] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Wood];
	end
	if _Costs[ResourceType.Iron] ~= nil then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. "Eisen:";
		if Iron+IronRaw < _Costs[ResourceType.Iron] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Iron];
	end
	if _Costs[ResourceType.Stone] ~= nil then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. "Stein:";
		if Stone+StoneRaw < _Costs[ResourceType.Stone] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Stone];
	end
    if _Costs[ResourceType.Sulfur] ~= nil then
		CostString = CostString .. ((string.len(CostString) > 0 and " @cr ") or "");
        CostString = CostString .. ColWhite.. "Schwefel:";
		if Sulfur+SulfurRaw < _Costs[ResourceType.Sulfur] then
            CostString = CostString .. ColRed;
        end
        CostString = CostString.. " " .._Costs[ResourceType.Sulfur];
	end
    return CostString;
end
function FormatCostString(_PlayerID, _Costs)
    return Stronghold:FormatCostString(_PlayerID, _Costs)
end

-- -------------------------------------------------------------------------- --
-- Resources

function CreateCostTable(_Honor, _Gold, _Clay, _Wood, _Stone, _Iron, _Sulfur)
    local Costs = {};
    if _Honor ~= nil and _Honor > 0 then
        Costs[ResourceType.Honor] = _Honor;
    end
    if _Gold ~= nil and _Gold > 0 then
        Costs[ResourceType.Gold] = _Gold;
    end
    if _Clay ~= nil and _Clay > 0 then
        Costs[ResourceType.Clay] = _Clay;
    end
    if _Wood ~= nil and _Wood > 0 then
        Costs[ResourceType.Wood] = _Wood;
    end
    if _Stone ~= nil and _Stone > 0 then
        Costs[ResourceType.Stone] = _Stone;
    end
    if _Iron ~= nil and _Iron > 0 then
        Costs[ResourceType.Iron] = _Iron;
    end
    if _Sulfur ~= nil and _Sulfur > 0 then
        Costs[ResourceType.Sulfur] = _Sulfur;
    end
    return Costs
end

function Stronghold:HasEnoughResources(_PlayerID, _Costs)
    if self.Players[_PlayerID] then
        local Honor     = self.Players[_PlayerID].Honor;
        local GoldRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.GoldRaw);
        local Gold      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Gold);
        local ClayRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.ClayRaw);
        local Clay      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Clay);
        local WoodRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.WoodRaw);
        local Wood      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Wood);
        local IronRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.IronRaw);
        local Iron      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Iron);
        local StoneRaw  = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.StoneRaw);
        local Stone     = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Stone);
        local SulfurRaw = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.SulfurRaw);
        local Sulfur    = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Sulfur);

        if _Costs[ResourceType.Honor] ~= nil and Honor < _Costs[ResourceType.Honor] then
            return false;
        end
        if _Costs[ResourceType.Gold] ~= nil and Gold+GoldRaw < _Costs[ResourceType.Gold] then
            return false;
        end
        if _Costs[ResourceType.Clay] ~= nil and Clay+ClayRaw < _Costs[ResourceType.Clay]  then
            return false;
        end
        if _Costs[ResourceType.Wood] ~= nil and Wood+WoodRaw < _Costs[ResourceType.Wood]  then
            return false;
        end
        if _Costs[ResourceType.Iron] ~= nil and Iron+IronRaw < _Costs[ResourceType.Iron] then
            return false;
        end
        if _Costs[ResourceType.Stone] ~= nil and Stone+StoneRaw < _Costs[ResourceType.Stone] then
            return false;
        end
        if _Costs[ResourceType.Sulfur] ~= nil and Sulfur+SulfurRaw < _Costs[ResourceType.Sulfur] then
            return false;
        end
    end
    return true;
end
function HasEnoughResources(_PlayerID, _Costs)
    return Stronghold:HasEnoughResources(_PlayerID, _Costs);
end

function Stronghold:AddResourcesToPlayer(_PlayerID, _Resources)
    if self.Players[_PlayerID] then
        if _Resources[ResourceType.Honor] ~= nil then
            AddHonor(_PlayerID, _Resources[ResourceType.Honor]);
        end
        if _Resources[ResourceType.Gold] ~= nil then
            AddGold(_PlayerID, _Resources[ResourceType.Gold] or _Resources[ResourceType.GoldRaw]);
        end
        if _Resources[ResourceType.Clay] ~= nil then
            AddClay(_PlayerID, _Resources[ResourceType.Clay] or _Resources[ResourceType.ClayRaw]);
        end
        if _Resources[ResourceType.Wood] ~= nil then
            AddWood(_PlayerID, _Resources[ResourceType.Wood] or _Resources[ResourceType.WoodRaw]);
        end
        if _Resources[ResourceType.Iron] ~= nil then		
            AddIron(_PlayerID, _Resources[ResourceType.Iron] or _Resources[ResourceType.IronRaw]);
        end
        if _Resources[ResourceType.Stone] ~= nil then		
            AddStone(_PlayerID, _Resources[ResourceType.Stone] or _Resources[ResourceType.StoneRaw]);
        end
        if _Resources[ResourceType.Sulfur] ~= nil then		
            AddSulfur(_PlayerID, _Resources[ResourceType.Sulfur] or _Resources[ResourceType.SulfurRaw]);
        end
    end
end
function AddResourcesToPlayer(_PlayerID, _Resources)
    Stronghold:AddResourcesToPlayer(_PlayerID, _Resources);
end

function Stronghold:RemoveResourcesFromPlayer(_PlayerID, _Costs)
    if self.Players[_PlayerID] then
        local Honor     = self.Players[_PlayerID].Honor;
        local GoldRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.GoldRaw);
        local Gold      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Gold);
        local ClayRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.ClayRaw);
        local Clay      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Clay);
        local WoodRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.WoodRaw);
        local Wood      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Wood);
        local IronRaw   = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.IronRaw);
        local Iron      = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Iron);
        local StoneRaw  = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.StoneRaw);
        local Stone     = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Stone);
        local SulfurRaw = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.SulfurRaw);
        local Sulfur    = Logic.GetPlayersGlobalResource(_PlayerID, ResourceType.Sulfur);

        -- Silver cost
        if  _Costs[ResourceType.Honor] ~= nil and _Costs[ResourceType.Honor] > 0
        and Honor >= _Costs[ResourceType.Honor] then
            AddHonor(_PlayerID, _Costs[ResourceType.Honor] * (-1));
        end
        -- Gold cost
        if  _Costs[ResourceType.Gold] ~= nil and _Costs[ResourceType.Gold] > 0
        and Gold+GoldRaw >= _Costs[ResourceType.Gold] then
            AddGold(_PlayerID, _Costs[ResourceType.Gold] * (-1));
        end
        -- Clay cost
        if  _Costs[ResourceType.Clay] ~= nil and _Costs[ResourceType.Clay] > 0
        and Clay+ClayRaw >= _Costs[ResourceType.Clay]  then
            AddClay(_PlayerID, _Costs[ResourceType.Clay] * (-1));
        end
        -- Wood cost
        if  _Costs[ResourceType.Wood] ~= nil and _Costs[ResourceType.Wood] > 0
        and Wood+WoodRaw >= _Costs[ResourceType.Wood]  then
            AddWood(_PlayerID, _Costs[ResourceType.Wood] * (-1));
        end
        -- Iron cost
        if  _Costs[ResourceType.Iron] ~= nil and _Costs[ResourceType.Iron] > 0
        and Iron+IronRaw >= _Costs[ResourceType.Iron] then
            AddIron(_PlayerID, _Costs[ResourceType.Iron] * (-1));
        end
        -- Stone cost
        if  _Costs[ResourceType.Stone] ~= nil and _Costs[ResourceType.Stone] > 0
        and Stone+StoneRaw >= _Costs[ResourceType.Stone] then
            AddStone(_PlayerID, _Costs[ResourceType.Stone] * (-1));
        end
        -- Sulfur cost
        if  _Costs[ResourceType.Sulfur] ~= nil and _Costs[ResourceType.Sulfur] > 0
        and Sulfur+SulfurRaw >= _Costs[ResourceType.Sulfur] then
            AddSulfur(_PlayerID, _Costs[ResourceType.Sulfur] * (-1));
        end
    end
end
function RemoveResourcesFromPlayer(_PlayerID, _Costs)
    Stronghold:RemoveResourcesFromPlayer(_PlayerID, _Costs);
end

-- -------------------------------------------------------------------------- --
-- Entities

function GetUpgradeCategoryByEntityType(_Type)
    local TypeName = Logic.GetEntityTypeName(_Type);
    if TypeName then
        local Key = string.sub(TypeName, 4);
        local s,e = string.find(Key, "^[A-Za-z_]+");
        local Suffix = string.sub(Key, e+1);
        if Suffix and tonumber(Suffix) and tonumber(Suffix) < 10 and not string.find(Suffix, "0[0-9]+") then
            Key = string.sub(Key, 1, e);
        end
        if UpgradeCategories[Key] then
            return UpgradeCategories[Key];
        end
    end
    return 0;
end

function GetUpgradeLevelByEntityType(_Type)
    local UpgradeCategory = GetUpgradeCategoryByEntityType(_Type);
    if UpgradeCategory ~= 0 then
        local Buildings = {Logic.GetBuildingTypesInUpgradeCategory(UpgradeCategory)};
        for i=2, Buildings[1] do
            if Buildings[i] == _Type then
                return i - 2;
            end
        end
        local Settlers = {Logic.GetSettlerTypesInUpgradeCategory(UpgradeCategory)};
        for i=2, Settlers[1] do
            if Settlers[i] == _Type then
                return i - 2;
            end
        end
    end
    return 0;
end

function IsEntityValid(_Entity)
    local ID = GetID(_Entity);
    if IsExisting(ID) then
        if Logic.GetEntityHealth(ID) > 0 then
            if Logic.IsSettler(ID) == 1 then
                local Task = Logic.GetCurrentTaskList(ID);
                if Task and string.find(Task, "DIE") then
                    return false;
                end
            end
            return true;
        end
    end
    return false;
end

function GetAllWorker(_PlayerID, _EntityType)
    _EntityType = _EntityType or 0;
    local PlayerEntities = GetEntitiesOfType(_PlayerID, _EntityType);
    for i= table.getn(PlayerEntities), 1, -1 do
        if Logic.IsWorker(PlayerEntities[i]) == 0 then
            table.remove(PlayerEntities, i);
        end
    end
    return PlayerEntities;
end

function GetAllWorkplaces(_PlayerID, _EntityType)
    _EntityType = _EntityType or 0;
    local PlayerEntities = GetCompletedEntitiesOfType(_PlayerID, _EntityType);
    for i= table.getn(PlayerEntities), 1, -1 do
        if Logic.GetBuildingWorkPlaceLimit(PlayerEntities[i]) == 0 then
            table.remove(PlayerEntities, i);
        end
    end
    return PlayerEntities;
end

function GetCompletedEntitiesOfType(_PlayerID, _EntityType)
    local PlayerEntities = GetEntitiesOfType(_PlayerID, _EntityType);
    for i= table.getn(PlayerEntities), 1, -1 do
        -- Remove buildings if construction is incomplete or no workers.
        if Logic.IsBuilding(PlayerEntities[i]) == 1 then
            if Logic.IsConstructionComplete(PlayerEntities[i]) == 0 then
                table.remove(PlayerEntities, i);
            end
        end
        -- Remove settlers if they are training or dying
        if Logic.IsSettler(PlayerEntities[i]) == 1 then
            local Task = Logic.GetCurrentTaskList(PlayerEntities[i]);
            if Task and (string.find(Task, "TRAIN") or string.find(Task, "DIE")) then
                table.remove(PlayerEntities, i);
            end
        end
    end
    return PlayerEntities;
end

function GetEntitiesOfType(_PlayerID, _EntityType)
    local PlayerEntities = {}
    if _EntityType ~= 0 then
        local n,eID = Logic.GetPlayerEntities(_PlayerID, _EntityType, 1);
        if (n > 0) then
            local firstEntity = eID;
            repeat
                table.insert(PlayerEntities,eID)
                eID = Logic.GetNextEntityOfPlayerOfType(eID);
            until (firstEntity == eID);
        end
    elseif _EntityType == 0 then
        for k,v in pairs(Entities) do
            if string.find(k, "PU_") or string.find(k, "PB_") or string.find(k, "CU_") or string.find(k, "CB_")
            or string.find(k, "XD_DarkWall") or string.find(k, "XD_Wall") or string.find(k, "PV_") then
                local n,eID = Logic.GetPlayerEntities(_PlayerID, v, 1);
                if (n > 0) then
                local firstEntity = eID;
                repeat
                    table.insert(PlayerEntities,eID)
                    eID = Logic.GetNextEntityOfPlayerOfType(eID);
                until (firstEntity == eID);
                end
            end
        end
    end
    return PlayerEntities;
end

