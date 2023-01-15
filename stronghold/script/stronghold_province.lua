--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.Province = {
    Data = {},
    Provinces = {},
    Offers = {},

    Config = {
        ProvinceConquerTimer = 1 * 60,
        ProvinceConquerArea = 3000,
        ProvinceCost = 100,
        AggressivePlayerID = 7,
        NeutralPlayerID = 8,

        Type = {
            Reputation = 1,
            Honor = 2,
            Resource = 3,
            Attraction = 4,
            Outlaw = 5,
        }
    },
}

-- -------------------------------------------------------------------------- --
-- Main

function Stronghold.Province:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    local Players = table.getn(GetActivePlayers());
    local MaxPlayers = table.getn(Score.Player) -2;
    assert(Players <= MaxPlayers, "Only " ..MaxPlayers.. " players players are allowed!");
    if Players > 6 then
        self.Config.AggressivePlayerID = Players +1;
        self.Config.NeutralPlayerID = Players +2;
    end

    self:OverrideCalculationCallbacks();
end

function Stronghold.Province:OnSaveGameLoaded()
end

function Stronghold.Province:CreateProvince(_Data)
    local ProvinceCount = table.getn(self.Provinces);
    assert(ProvinceCount < 6, "Only 6 provinces are possible on a map!");
    ProvinceCount = ProvinceCount +1;

    local CampName = "OP" ..ProvinceCount.. "Camp";
    local FlagName = "OP" ..ProvinceCount.. "Flag";
    local CampPosName = "OP" ..ProvinceCount.. "CampPos";

    -- Create camp Pos
    local CampPos = _Data.CampPos;
    ID = Logic.CreateEntity(Entities.XD_LargeCampFire, CampPos.X -5, CampPos.Y -5, 0, 0);
    Logic.SetEntityName(ID, CampName);
    ID = AI.Entity_CreateFormation(8, Entities.PU_Serf, nil, 0, CampPos.X, CampPos.Y, 0, 0, 0, 0);
    local x,y,z = Logic.EntityGetPos(ID);
    CampPos.X = x; CampPos.Y = y; CampPos.Z = z;
    DestroyEntity(ID);
    ID = Logic.CreateEntity(Entities.XD_ScriptEntity, x, y, 0, self.Config.NeutralPlayerID);
    Logic.SetEntityName(ID, CampPosName);

    -- Create flag
    local FlagPos = {X= CampPos.X -200, Y= CampPos.Y -200};
    ID = Logic.CreateEntity(Entities.XD_ScriptEntity, FlagPos.X, FlagPos.Y, 0, self.Config.NeutralPlayerID);
    Logic.SetEntityName(ID, FlagName);
    Logic.SetModelAndAnimSet(ID, Models.Banners_XB_LargeOccupied);
    SVLib.SetInvisibility(ID, false);

    self.Offers[ProvinceCount] = {};
    for i= 1, table.getn(Score.Player) -2 do
        local TributeID = Stronghold.Province:CreateTribute(i, ProvinceCount);
        self.Offers[ProvinceCount][i] = TributeID;
    end

    table.insert(self.Provinces, {
        WasClaimed      = false,
        Name            = _Data.Name,
        Description     = _Data.Description,
        Owner           = self.Config.NeutralPlayerID,
        Identifier      = _Data.Identifier,
        Index           = ProvinceCount,
        Type            = _Data.Type,
        CampPos         = CampPos,
        CampName        = CampName,
        FlagName        = FlagName,
        ConquerTimer    = self.Config.ProvinceConquerTimer,

        Income = {
            Reputation  = _Data.Reputation or 30,
            Honor       = _Data.Honor or 30,
            Attraction  = _Data.Attraction or 75,
            Gold        = _Data.Gold or 0,
            Clay        = _Data.Clay or 0,
            Wood        = _Data.Wood or 0,
            Stone       = _Data.Stone or 0,
            Iron        = _Data.Iron or 0,
            Sulfur      = _Data.Sulfur or 0,
        },
        Spawn = {
            Troops      = _Data.Troops or {},
            Amount      = _Data.Amount or 0,
            Index       = 0,
        },
    });
end

-- -------------------------------------------------------------------------- --
-- Claim Province

function Stronghold.Province:StartTributePayedTrigger()
    function Stronghold_Province_Trigger_OnTributePayed()
        Stronghold.Province:OnTributePayed(Event.GetTributeUniqueID());
    end

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_TRIBUTE_PAID,
		"",
		"Stronghold_Province_Trigger_OnTributePayed",
        1
    );

    function Stronghold_Province_Trigger_OnEverySecond()
        Stronghold.Province:ConquerProvinceController();
    end

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_EVERY_SECOND,
		"",
		"Stronghold_Province_Trigger_OnEverySecond",
        1
    );
end

-- A province was claimed with honor
-- Removes all tributes and gives the province to the purchasing player.
function Stronghold.Province:OnProvinceClaimed(_PlayerID, _ProvinceID)
    if self.Data[_PlayerID] and self.Provinces[_ProvinceID] then
        self.Provinces[_ProvinceID].Owner = _PlayerID;
        self.Provinces[_ProvinceID].WasClaimed = true;

        if Stronghold:IsPlayer(_PlayerID) then
            -- TODO: Add messages with player color, player name and signal
            Message("Debug: Player " .._PlayerID.. " has bought " .._ProvinceID);
        end

        for k,v in pairs(self.Offers[_ProvinceID]) do
            Logic.RemoveTribute(k, v);
        end

        ChangePlayer(self.Provinces[_ProvinceID].FlagName, _PlayerID);
        Logic.SetEntityExplorationRange(GetID(self.Provinces[_ProvinceID].FlagName), 50);
        self:ClearOutlaws(_ProvinceID);
    end
end

-- Tribute payed handler
-- Gives the purchasing player the province or restores the tribute if the
-- player hasn't enough honor.
function Stronghold.Province:OnTributePayed(_TributeID)
    for ProvinceID,_ in pairs(self.Offers) do
        for PlayerID, TributeID in pairs(self.Offers[ProvinceID]) do
            if TributeID == _TributeID then
                local Costs = {[ResourceType.Honor] = self.Config.ProvinceCost}
                local Honor = Stronghold:GetPlayerHonor(PlayerID);
                if Costs[ResourceType.Honor] <= Honor then
                    if GUI.GetPlayerID() == PlayerID then
                        GUIAction_ToggleMenu( XGUIEng.GetWidgetID("TradeWindow"), 0);
                        Sound.PlayGUISound(Sounds.OnKlick_Select_helias, 127);
                    end
                    Stronghold.Province:OnProvinceClaimed(PlayerID, ProvinceID);
                    Stronghold:AddPlayerHonor(PlayerID, (-1) * Costs[ResourceType.Honor]);
                else
                    if GUI.GetPlayerID() == PlayerID then
                        HasPlayerEnoughResourcesFeedback(Costs);
                    end
                    local NewTributID = self:CreateTribute(PlayerID, ProvinceID);
                    self.Offers[ProvinceID][PlayerID] = NewTributID;
                end
            end
        end
    end
end

-- Creates a tribute for a player to claim a province.
-- Returns ID of tribute.
function Stronghold.Province:CreateTribute(_PlayerID, _ProvinceID)
    Stronghold.UnitqueTributeID = Stronghold.UnitqueTributeID +1;
    local TributeID = Stronghold.UnitqueTributeID;
    local Province = self.Provinces[_ProvinceID];

    local Text = Province.Description;
    if not Text then
        Text = "Beansprucht die Provinz \"" ..Province.Name.. "\" für Euch, "..
               " indem Ihr " ..self.Config.ProvinceCost.. " Ehre investiert.";
    end
    Logic.AddTribute(_PlayerID, TributeID, 0, 0, Text, {[ResourceType.Gold] = 0});
    return TributeID;
end

-- Allows tributes
function GameCallback_FulfillTribute(_PlayerID, _TributeID)
	return 1;
end

-- -------------------------------------------------------------------------- --
-- Conquer Province

-- A province was taken by force
-- Gives the province to the conquerer and resets all data.
function Stronghold.Province:OnProvinceConquered(_OldPlayerID, _NewPlayerID, _ProvinceID)
    if self.Provinces[_ProvinceID] then
        self.Provinces[_ProvinceID].ConquerTimer = self.Config.ProvinceConquerTimer;
        self.Provinces[_ProvinceID].Owner = _NewPlayerID;
        self.Provinces[_ProvinceID].AttackMassage = false;

        if Stronghold:IsPlayer(_OldPlayerID) then
            -- TODO: Add messages with player color, player name and signal
            Message("Debug: Player " .._OldPlayerID.. " lost province " .._ProvinceID);
        end
        if Stronghold:IsPlayer(_NewPlayerID) then
            -- TODO: Add messages with player color, player name and signal
            Message("Debug: Player " .._NewPlayerID.. " has gain control over province " .._ProvinceID);
        end

        ChangePlayer(self.Provinces[_ProvinceID].FlagName, _NewPlayerID);
        Logic.SetEntityExplorationRange(GetID(self.Provinces[_ProvinceID].FlagName), 50);
        self:ClearOutlaws(_ProvinceID);
    end
end

-- Checks each claimed province if it is taken by the enemy.
function Stronghold.Province:ConquerProvinceController()
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.WasClaimed then
            local AreaSize = self.Config.ProvinceConquerArea;
            if  not AreAlliesInArea(Province.Owner, Province.CampPos, AreaSize)
            and AreEnemiesInArea(Province.Owner, Province.CampPos, AreaSize) then
                self.Provinces[i].ConquerTimer = self.Provinces[i].ConquerTimer -1;

                if not self.Provinces[i].AttackMassage then
                    self.Provinces[i].AttackMassage = true;
                    -- TODO: Add messages with player color, player name and signal
                    Message("Debug: Province " ..i.." of player " ..Province.Owner.. " is under attack!");
                end

                if Province.ConquerTimer <= 0 then
                    local OldPlayerID = Province.Owner;
                    local NewPlayerID = self.Config.AggressivePlayerID;
                    for j= 1, table.getn(Score.Player) -2 do
                        if j ~= OldPlayerID and Logic.GetDiplomacyState(OldPlayerID, j) == Diplomacy.Hostile then
                            if Logic.IsPlayerEntityOfCategoryInArea(j, Province.CampPos.X, Province.CampPos.Y, AreaSize, "DefendableBuilding", "Military", "MilitaryBuilding") == 1 then
                                NewPlayerID = j
                                break;
                            end
                        end
                    end
                    self:OnProvinceConquered(OldPlayerID, NewPlayerID, i);
                end
            else
                self.Provinces[i].ConquerTimer = self.Config.ProvinceConquerTimer;
                self.Provinces[i].AttackMassage = false;
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Income Handlers

-- Provides more reputation for the player.
-- This is called once a second (or less if more than 8 players).
function Stronghold.Province:ProvideReputation(_PlayerID, _CurrentAmount)
    local CurrentAmount = _CurrentAmount;
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.Owner == _PlayerID then
            if Province.Type == self.Config.Type.Reputation then
                CurrentAmount = CurrentAmount + Province.Income.Reputation;
            end
        end
    end
    return CurrentAmount;
end

-- Provides more honor for the player.
-- This is called once a second (or less if more than 8 players).
function Stronghold.Province:ProvideHonor(_PlayerID, _CurrentAmount)
    local CurrentAmount = _CurrentAmount;
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.Owner == _PlayerID then
            if Province.Type == self.Config.Type.Honor then
                CurrentAmount = CurrentAmount + Province.Income.Honor;
            end
        end
    end
    return CurrentAmount;
end

-- Provides more attraction for the player.
-- This is called once a second (or less if more than 8 players).
function Stronghold.Province:ProvideAttraction(_PlayerID, _CurrentAmount)
    local CurrentAmount = _CurrentAmount;
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.Owner == _PlayerID then
            if Province.Type == self.Config.Type.Attraction then
                CurrentAmount = CurrentAmount + Province.Income.Attraction;
            end
        end
    end
    return CurrentAmount;
end

-- Provides resources for the player.
-- This is called once on a players payday.
function Stronghold.Province:ProvideResources()
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.Owner ~= self.Config.AggressivePlayerID
        or Province.Owner ~= self.Config.NeutralPlayerID then
            if Province.Type == self.Config.Type.Resource then
                Tools.GiveResouces(
                    Province.Owner,
                    Province.Income.Gold or 0,
                    Province.Income.Clay or 0,
                    Province.Income.Wood or 0,
                    Province.Income.Stone or 0,
                    Province.Income.Iron or 0,
                    Province.Income.Sulfur or 0
                );
            end
        end
    end
end

-- Provides resources for the player.
-- This is called once on a players payday.
function Stronghold.Province:ProvideOutlaws()
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.Owner ~= self.Config.AggressivePlayerID
        or Province.Owner ~= self.Config.NeutralPlayerID then
            if Province.Type == self.Config.Type.Outlaw then
                while table.getn(Province.Spawn.Troops) < Province.Spawn.Amount do
                    local SpawnIndex = Province.Spawn.Types.Index +1;
                    if SpawnIndex > table.getn(Province.Spawn.Types) then
                        SpawnIndex = 1;
                    end

                    local Position = Province.CampPos;
                    local ID = AI.Entity_CreateFormation(
                        Province.Owner,
                        Province.Spawn.Types[SpawnIndex],
                        0,
                        16,
                        Position.X, Position.Y,
                        0,0,
                        3,
                        0
                    );
                    Logic.GroupAttackMove(ID, Position.X, Position.Y);
                    table.insert(self.Provinces[i].Spawn.Troops, ID);

                    self.Provinces[i].Spawn.Types.Index = SpawnIndex;
                end
            end
        end
    end
end

-- Removes all troop IDs that are dead.
-- Must be called before new troops are spawned from an outpost.
function Stronghold.Province:ClearOnlyDeadOutlaws()
    for i= 1, table.getn(self.Provinces) do
        local Province = self.Provinces[i];
        if Province.Type == self.Config.Type.Outlaw then
            for j= table.getn(Province.Spawn.Troops), 1, -1 do
                if not IsExisting(Province.Spawn.Troops[j]) then
                    table.remove(Province.Spawn.Troops, j);
                end
            end
        end
    end
end

-- Removes all troop IDs. This MUST be called before ownership changes!
function Stronghold.Province:ClearOutlaws(_ProvinceID)
    local Province = self.Provinces[_ProvinceID];
    if Province.Type == self.Config.Type.Outlaw then
        for j= table.getn(Province.Spawn.Troops), 1, -1 do
            table.remove(Province.Spawn.Troops, j);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Callback

function Stronghold.Province:OverrideCalculationCallbacks()
    self.Orig_GameCallback_Calculate_ReputationIncrease = GameCallback_Calculate_ReputationIncrease;
    GameCallback_Calculate_ReputationIncrease = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Province.Orig_GameCallback_Calculate_ReputationIncrease(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Province:ProvideReputation(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_HonorIncrease = GameCallback_Calculate_HonorIncrease;
    GameCallback_Calculate_HonorIncrease = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Province.Orig_GameCallback_Calculate_HonorIncrease(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Province:ProvideHonor(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_CivilAttrationLimit = GameCallback_Calculate_CivilAttrationLimit;
    GameCallback_Calculate_CivilAttrationLimit = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Province.Orig_GameCallback_Calculate_CivilAttrationLimit(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Province:ProvideAttraction(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_PaydayUpkeep = GameCallback_Calculate_PaydayUpkeep;
    GameCallback_Calculate_PaydayUpkeep = function(_PlayerID, _UnitType, _CurrentAmount)
        local CurrentAmount = Stronghold.Province.Orig_GameCallback_Calculate_PaydayUpkeep(_PlayerID, _UnitType, _CurrentAmount);
        -- TODO: Sub costs of troops that are provided by a province

        -- Idea: The callback does not provide the current amount of upkeep for
        -- a single unit of the type. But the value is not rounded yet. So we
        -- can just get the total amount of troops of that type and then divive
        -- the value with that amount to get the single unit upkeep.

        return CurrentAmount;
    end

    self.Orig_GameCallback_Stronghold_OnPayday = GameCallback_Stronghold_OnPayday;
    GameCallback_Stronghold_OnPayday = function(_PlayerID)
        self.Orig_GameCallback_Stronghold_OnPayday(_PlayerID);
        Stronghold.Province:ClearOnlyDeadOutlaws();
        Stronghold.Province:ProvideResources();
        Stronghold.Province:ProvideOutlaws();
    end
end

