-- 
-- 
-- 

Stronghold = Stronghold or {};

Stronghold.Hero = {
    Data = {},
    Config = {
        HeroSkills = {
            [Entities.PU_Hero1c]             = {
                Description = "Passive Fähigkeit: @cr Für jeden Ingeneur auf der Burg wird zusätzliche Wetterenergie produziert."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann feindliche Einheiten verjagen (außer Nebelvolk).",
            },
            [Entities.PU_Hero2]              = {
                Description = "Passive Fähigkeit: @cr Jedes mal wenn eine Mine Rohstoffe abbaut, wird ein zusätzlicher veredelbarer Rohstoff erzeugt."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Legt eine Bombe, die Feinde schädigt und Schächte freisprengt.",
            },
            [Entities.PU_Hero3]              = {
                Description = "Passive Fähigkeit: @cr Erhält mehr Ehre für jeden Alchemisten, Gelehrten und Ingeneur."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann Soldatengruppen wieder auffüllen, wenn diese nicht kämpfen.",
            },
            [Entities.PU_Hero4]              = {
                Description = "Passive Fähigkeit: @cr Soldaten werden mit der maximalen Erfahrung rekrutiert, dadurch steigen allerdings ihre Kosten um 30%."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Ein Rundumschlag verletzt alle nahestehenden Feinde.",
            },
            [Entities.PU_Hero5]              = {
                Description = "Passive Fähigkeit: @cr Beim Volke ist mehr zu holen, als mancher denkt. Die Steuereinnahmen werden um 15% erhöht."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann Pfeile auf feindliche Truppen regnen lassen.",
            },
            [Entities.PU_Hero6]              = {
                Description = "Passive Fähigkeit: @cr Für jeden Priester auf der Burg wird zusätzlicher Glauben produziert."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann die Rüstung von verbündeten Einheiten verbessern.",
            },
            [Entities.CU_Mary_de_Mortfichet] = {
                Description = "Passive Fähigkeit: @cr Kundschafter und Diebe nehmen keinen Bevölkerungsplatz ein und verlangen keinen Sold."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann die Angriffskraft von nahestehenden Feinden senken.",
            },
            [Entities.CU_BlackKnight]        = {
                Description = "Passive Fähigkeit: @cr Der Pöbel ist so leicht einzuschüchtern... Der Malus auf die Beliebtheit wird um 50% verringert."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann die Rüstung von nahestehenden Feinden senken.",
            },
            [Entities.CU_Barbarian_Hero]     = {
                Description = "Passive Fähigkeit: @cr Einen Sieg muss man zu feiern wissen! Alle Tavernen produzieren 50% zusätzliche Beliebtheit."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Ruft die mächtigen Wölfe Hati und Skalli herbei, die Ehre erzeugen, wenn sie Feinde töten.",
            },
            [Entities.PU_Hero10]             = {
                Description = "Passive Fähigkeit: @cr Für diesen meisterlichen Schützen kämpfen Scharfschützen für 10% weniger Sold."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann den Schaden von verbündeten Fernkämpfern verbessern.",
            },
            [Entities.PU_Hero11]             = {
                Description = "Passive Fähigkeit: @cr Jeder Arbeiter gibt alles für die Einheitspartei! Die maximale Beliebtheit wird auf 300 erhöht."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann befreundete Arbeiter mit Feuerwerk motivieren.",
            },
            [Entities.CU_Evil_Queen] = {
                Description = "Passive Fähigkeit: @cr Die gesteigerte Geburtenrate hebt Euer Bevölkerungslimit um 30% an."..
                            " @cr @cr "..
                            "Aktive Fähigkeit: @cr Kann nahestehende Feinde mit Gift schädigen.",
            },
        },

        ---

        TypeToBuyHeroButton = {
            [Entities.PU_Hero1c]             = "BuyHeroWindowBuyHero1",
            [Entities.PU_Hero2]              = "BuyHeroWindowBuyHero5",
            [Entities.PU_Hero3]              = "BuyHeroWindowBuyHero4",
            [Entities.PU_Hero4]              = "BuyHeroWindowBuyHero3",
            [Entities.PU_Hero5]              = "BuyHeroWindowBuyHero2",
            [Entities.PU_Hero6]              = "BuyHeroWindowBuyHero6",
            [Entities.CU_Mary_de_Mortfichet] = "BuyHeroWindowBuyHero7",
            [Entities.CU_BlackKnight]        = "BuyHeroWindowBuyHero8",
            [Entities.CU_Barbarian_Hero]     = "BuyHeroWindowBuyHero9",
            [Entities.PU_Hero10]             = "BuyHeroWindowBuyHero10",
            [Entities.PU_Hero11]             = "BuyHeroWindowBuyHero11",
            [Entities.CU_Evil_Queen]         = "BuyHeroWindowBuyHero12",
        },

        ---

        LordStats = {
            Health = 10000,
            Armor = 8,
            Damage = 16,
            Healing = 1,
        },
        SpouseStats = {
            Health = 1000,
            Armor = 3,
            Damage = 16,
            Healing = 10,
        },
        PetStats = {
            [Entities.CU_Barbarian_Hero_wolf] = {
                Owner = Entities.CU_Barbarian_Hero,
                Health = 800, Armor = 1, Damage = 35, Healing = 5,
            },
            [Entities.PU_Hero5_Outlaw] = {
                Owner = Entities.CU_Barbarian_Hero,
                Health = 330, Armor = 3, Damage = 16, Healing = 5
            },
        },

        ---

        LordTypes = {
            [Entities.PU_Hero1c]             = true,
            [Entities.PU_Hero2]              = true,
            [Entities.PU_Hero3]              = true,
            [Entities.PU_Hero4]              = true,
            [Entities.PU_Hero6]              = true,
            [Entities.PU_Hero10]             = true,
            [Entities.CU_BlackKnight]        = true,
            [Entities.CU_Barbarian_Hero]     = true,
        },
        SpouseTypes = {
            [Entities.PU_Hero5]              = true,
            [Entities.PU_Hero11]             = true,
            [Entities.CU_Mary_de_Mortfichet] = true,
            [Entities.CU_Evil_Queen]         = true,
        },
    }
}

function Stronghold.Hero:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    self:OverrideBuyHeroWindow();
    self:OverrideCalculationCallbacks();
    self:StartTriggers();
end

function Stronghold.Hero:OnSaveGameLoaded()
    for i= 1, table.getn(Score.Player) do
        self:HeadquartersConfigureBuilding(i);
        self:ConfigurePlayersLord(i);
        self:ConfigurePlayersSpouse(i);
    end
end

function Stronghold.Hero:OpenBuyHeroWindowForLordSelection(_PlayerID)
    if not Stronghold:IsPlayer(_PlayerID) then
        return;
    end
    XGUIEng.ShowWidget("BuyHeroWindow", 1);
    XGUIEng.SetText("BuyHeroWindowHeadline", "Wählt Euren Burgherren!");
    XGUIEng.SetText("BuyHeroWindowInfoLine", "");
    XGUIEng.ShowAllSubWidgets("BuyHeroLine1", 0);

    local PositionX = 20;
    for k, v in pairs(self.Config.LordTypes) do
        if v then
            local WidgetID = self.Config.TypeToBuyHeroButton[k];
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.SetWidgetPosition(WidgetID, PositionX, 120);
            PositionX = PositionX + 90;
        end
    end
end

function Stronghold.Hero:OpenBuyHeroWindowForSpouseSelection(_PlayerID)
    if not Stronghold:IsPlayer(_PlayerID) then
        return;
    end
    XGUIEng.ShowWidget("BuyHeroWindow", 1);
    XGUIEng.SetText("BuyHeroWindowHeadline", "Wählt Eurer Burgfräulein!");
    XGUIEng.SetText("BuyHeroWindowInfoLine", "");
    XGUIEng.ShowAllSubWidgets("BuyHeroLine1", 0);

    local PositionX = 20;
    for k, v in pairs(self.Config.SpouseTypes) do
        if v then
            local WidgetID = self.Config.TypeToBuyHeroButton[k];
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.SetWidgetPosition(WidgetID, PositionX, 120);
            PositionX = PositionX + 90;
        end
    end
end

function Stronghold.Hero:OverrideBuyHeroWindow()
    BuyHeroWindow_UpdateInfoLine_Orig_StrongholdHero = BuyHeroWindow_UpdateInfoLine;
    BuyHeroWindow_UpdateInfoLine = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return BuyHeroWindow_UpdateInfoLine_Orig_StrongholdHero();
        end

        local ScreenX, ScreenY = GUI.GetScreenSize();
        local MouseX, MouseY = GUI.GetMousePosition();
        MouseX = MouseX * (1024/ScreenX);
        MouseY = MouseY * (768/ScreenY);

        local RowX, RowY = 160, 278;
        local ButtonW, ButtonH = 90, 135;

        local Text = "";
        local Index = 0;
        for k,v in pairs(self.Config.LordTypes) do
            Index = Index +1;
            local ButtonStartX = (RowX + (ButtonW * (Index -1)));
            local ButtonEndX = ButtonStartX + ButtonW;
            local ButtonStartY = RowY;
            local ButtonEndY = RowY + ButtonH;

            local WidgetName = self.Config.TypeToBuyHeroButton[k];
            if XGUIEng.IsWidgetShown(WidgetName) == 1 then
                if (MouseX >= ButtonStartX and MouseX <= ButtonEndX) and (MouseY >= ButtonStartY and MouseY <= ButtonEndY) then
                    Text = Stronghold.Hero.Config.HeroSkills[k].Description;
                end
            end
        end
        local Index = 0;
        for k,v in pairs(Stronghold.Hero.Config.SpouseTypes) do
            Index = Index +1;
            local ButtonStartX = (RowX + (ButtonW * (Index -1)));
            local ButtonEndX = ButtonStartX + ButtonW;
            local ButtonStartY = RowY;
            local ButtonEndY = RowY + ButtonH;

            local WidgetName = Stronghold.Hero.Config.TypeToBuyHeroButton[k];
            if XGUIEng.IsWidgetShown(WidgetName) == 1 then
                if (MouseX >= ButtonStartX and MouseX <= ButtonEndX) and (MouseY >= ButtonStartY and MouseY <= ButtonEndY) then
                    Text = Stronghold.Hero.Config.HeroSkills[k].Description;
                end
            end
        end
        XGUIEng.SetText("BuyHeroWindowInfoLine", Text);
    end

    BuyHeroWindow_Action_BuyHero_Orig_StrongholdHero = BuyHeroWindow_Action_BuyHero;
    BuyHeroWindow_Action_BuyHero = function(_Type)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return BuyHeroWindow_Action_BuyHero_Orig_StrongholdHero(_Type);
        end
        if Stronghold.Hero.Config.LordTypes[_Type] then
            Sync.Call(
                "Stronghold_ButtonCallback_Headquarters",
                PlayerID,
                Stronghold.Building.SyncEvents.Headquarters.BuyLord,
                _Type
            );
        else
            Sync.Call(
                "Stronghold_ButtonCallback_Headquarters",
                PlayerID,
                Stronghold.Building.SyncEvents.Headquarters.BuySpouse,
                _Type
            );
        end
        XGUIEng.ShowWidget("BuyHeroWindow", 0);
    end

    BuyHeroWindow_Update_BuyHero_Orig_StrongholdHero = BuyHeroWindow_Update_BuyHero;
    BuyHeroWindow_Update_BuyHero = function(_Type)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return BuyHeroWindow_Update_BuyHero_Orig_StrongholdHero(_Type);
        end
    end
end

function Stronghold.Hero:BuyHeroCreateLord(_PlayerID, _Type)
    if Stronghold:IsPlayer(_PlayerID) then
        Stronghold.Players[_PlayerID].LordChosen = true;
        local Position = Stronghold.Players[_PlayerID].DoorPos;
        ID = Logic.CreateEntity(_Type, Position.X, Position.Y, 0, _PlayerID);
        Logic.SetEntityName(ID, Stronghold.Players[_PlayerID].LordScriptName);
        Position = Stronghold.Players[_PlayerID].CampPos;
        Logic.MoveSettler(ID, Position.X, Position.Y);
        self:ConfigurePlayersLord(_PlayerID);

        local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
        local TypeName = Logic.GetEntityTypeName(_Type);
        local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
        Message(PlayerColor.. " " ..Name.. " @color:180,180,180 wurde als Burgherr gewählt!");

        if _PlayerID == GUI.GetPlayerID() then
            GameCallback_GUI_SelectionChanged();
        end
    end
end

function Stronghold.Hero:ConfigurePlayersLord(_PlayerID)
    if Stronghold:IsPlayer(_PlayerID) then
        local ID = GetID(Stronghold.Players[_PlayerID].LordScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.LordStats.Armor);
            CEntity.SetDamage(ID, self.Config.LordStats.Damage);
            CEntity.SetHealingPoints(ID, self.Config.LordStats.Healing);
            CEntity.SetMaxHealth(ID, self.Config.LordStats.Health);
            if Logic.GetEntityHealth(ID) > 0 then
                Logic.HealEntity(ID, self.Config.LordStats.Health);
            end
        end
    end
end

function Stronghold.Hero:BuyHeroCreateSpouse(_PlayerID, _Type)
    if Stronghold:IsPlayer(_PlayerID) then
        Stronghold.Players[_PlayerID].SpouseChosen = true;
        local Position = Stronghold.Players[_PlayerID].DoorPos;
        local ID = Logic.CreateEntity(_Type, Position.X, Position.Y, 0, _PlayerID);
        Logic.SetEntityName(ID, Stronghold.Players[_PlayerID].SpouseScriptName);
        Position = Stronghold.Players[_PlayerID].CampPos;
        Logic.MoveSettler(ID, Position.X, Position.Y);
        self:ConfigurePlayersSpouse(_PlayerID);

        local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
        local TypeName = Logic.GetEntityTypeName(_Type);
        local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
        Message(PlayerColor.. " " ..Name.. " @color:180,180,180 wurde als Burgfräulein gewählt!");

        if _PlayerID == GUI.GetPlayerID() then
            GameCallback_GUI_SelectionChanged();
        end
    end
end

function Stronghold.Hero:ConfigurePlayersSpouse(_PlayerID)
    if Stronghold:IsPlayer(_PlayerID) then
        local ID = GetID(Stronghold.Players[_PlayerID].SpouseScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.SpouseStats.Armor);
            CEntity.SetDamage(ID, self.Config.SpouseStats.Damage);
            CEntity.SetHealingPoints(ID, self.Config.SpouseStats.Healing);
            CEntity.SetMaxHealth(ID, self.Config.SpouseStats.Health);
            if Logic.GetEntityHealth(ID) > 0 then
                Logic.HealEntity(ID, self.Config.SpouseStats.Health);
            end
        end
    end
end

function Stronghold.Hero:ConfigurePlayersHeroPet(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local Type = Logic.GetEntityType(_EntityID);
    if self.Config.PetStats[Type] then
        if Stronghold:HasValidHeroOfType(PlayerID, self.Config.PetStats[Type].Owner) then
            -- Special treatment for Vargs wolves
            if Type == Entities.CU_Barbarian_Hero_wolf then
                Logic.SetSpeedFactor(_EntityID, 1.5);
                SVLib.SetEntitySize(_EntityID, 1.5);
            end
            CEntity.SetArmor(_EntityID, self.Config.PetStats[Type].Armor);
            CEntity.SetDamage(_EntityID, self.Config.PetStats[Type].Damage);
            CEntity.SetHealingPoints(_EntityID, self.Config.PetStats[Type].Healing);
            CEntity.SetMaxHealth(_EntityID, self.Config.PetStats[Type].Health);
            Logic.HealEntity(_EntityID, self.Config.PetStats[Type].Health);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Trigger

function Stronghold.Hero:EntityAttackedController(_PlayerID)
    if Stronghold:IsPlayer(_PlayerID) then
        for k,v in pairs(Stronghold.Players[_PlayerID].AttackMemory) do
            -- Count down and remove
            Stronghold.Players[_PlayerID].AttackMemory[k][1] = v[1] -1;
            if Stronghold.Players[_PlayerID].AttackMemory[k][1] <= 0 then
                Stronghold.Players[_PlayerID].AttackMemory[k] = nil;
            end

            -- Hati und Skalli
            if Logic.GetEntityType(v[2]) == Entities.CU_Barbarian_Hero_wolf then
                if Logic.GetEntityHealth(k) == 0 then
                    Stronghold.Players[_PlayerID].AttackMemory[k] = nil;
                    local WolfPlayerID = Logic.EntityGetPlayer(v[2]);
                    AddHonor(WolfPlayerID, 1);
                end
            end

            -- Teleport to HQ
            if Logic.IsHero(k) == 1 then
                if Logic.GetEntityHealth(k) == 0 then
                    Stronghold.Players[_PlayerID].AttackMemory[k] = nil;
                    local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
                    local HeroType = Logic.GetEntityType(k);
                    local x,y,z = Logic.EntityGetPos(k);

                    -- Send message
                    local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(k));
                    local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
                    Message(PlayerColor.. " " ..Name.. " @color:255,255,255 muss sich in die Burg zurückziehen!");
                    -- Place hero
                    Logic.CreateEffect(GGL_Effects.FXDieHero, x, y, _PlayerID);
                    local ID = SetPosition(k, Stronghold.Players[_PlayerID].DoorPos);
                    Logic.HurtEntity(ID, Logic.GetEntityHealth(ID));
                    -- Handle lord
                    if self.Config.LordTypes[HeroType] then
                        self:ConfigurePlayersLord(_PlayerID);
                    end
                    -- Handle spouse
                    if self.Config.SpouseTypes[HeroType] then
                        self:ConfigurePlayersSpouse(_PlayerID);
                    end
                end
            end

            if not IsExisting(k) then
                Stronghold.Players[_PlayerID].AttackMemory[k] = nil;
            end
        end
    end
end

function Stronghold.Hero:StartTriggers()
    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_EVERY_TURN,
        nil,
        "Stronghold_Hero_Trigger_OnEveryTurn",
        1
    );

    Trigger.RequestTrigger(
        Events.LOGIC_EVENT_ENTITY_CREATED,
        nil,
        "Stronghold_Trigger_EntityCreated",
        1
    );
end

function Stronghold_Hero_Trigger_EntityCreated()
    local EntityID = Event.GetEntityID();
    local PlayerID = Logic.EntityGetPlayer(EntityID);

    if Logic.IsSettler(EntityID) == 1 and GUI.GetPlayerID() == PlayerID then
        Stronghold.Hero:ConfigurePlayersHeroPet(EntityID);
    end
end

function Stronghold_Hero_Trigger_OnEveryTurn()
    for i= 1, table.getn(Score.Player) do
        Stronghold.Hero:EntityAttackedController(i);
        Stronghold.Hero:EnergyProductionBonus(i);
        Stronghold.Hero:FaithProductionBonus(i);
    end
end

-- -------------------------------------------------------------------------- --
-- Passive Abilities

function Stronghold.Hero:OverrideCalculationCallbacks()
    self.Orig_GameCallback_GainedResources = GameCallback_GainedResources;
    GameCallback_GainedResources = function(_PlayerID, _ResourceType, _Amount)
        Stronghold.Hero.Orig_GameCallback_GainedResources(_PlayerID, _ResourceType, _Amount);
        if Stronghold:IsPlayer(_PlayerID) then
            Stronghold.Hero:ResourceProductionBonus(_PlayerID, _ResourceType, _Amount);
        end
    end

    self.Orig_GameCallback_Calculate_ReputationMax = GameCallback_Calculate_ReputationMax;
    GameCallback_Calculate_ReputationMax = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_ReputationMax(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyMaxReputationPassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end
    self.Orig_GameCallback_Calculate_ReputationIncrease = GameCallback_Calculate_ReputationIncrease;
    GameCallback_Calculate_ReputationIncrease = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_ReputationIncrease(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyReputationIncreasePassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_BuildingReputationIncrease = GameCallback_Calculate_BuildingReputationIncrease;
    GameCallback_Calculate_BuildingReputationIncrease = function(_PlayerID, _Type, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_BuildingReputationIncrease(_PlayerID, _Type, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyReputationBuildingBonusPassiveAbility(_PlayerID, _Type, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_ReputationDecrease = GameCallback_Calculate_ReputationDecrease;
    GameCallback_Calculate_ReputationDecrease = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_ReputationDecrease(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyReputationDecreasePassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_HonorIncrease = GameCallback_Calculate_HonorIncrease;
    GameCallback_Calculate_HonorIncrease = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_HonorIncrease(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyHonorBonusPassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_TotalPaydayIncome = GameCallback_Calculate_TotalPaydayIncome;
    GameCallback_Calculate_TotalPaydayIncome = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_TotalPaydayIncome(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyIncomeBonusPassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_TotalPaydayUpkeep = GameCallback_Calculate_TotalPaydayUpkeep;
    GameCallback_Calculate_TotalPaydayUpkeep = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_TotalPaydayUpkeep(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyUpkeepDiscountPassiveAbility(_PlayerID, _CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_PaydayUpkeep = GameCallback_Calculate_PaydayUpkeep;
    GameCallback_Calculate_PaydayUpkeep = function(_PlayerID, _UnitType, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_PaydayUpkeep(_PlayerID, _UnitType, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyUnitUpkeepDiscountPassiveAbility(_PlayerID, _UnitType, CurrentAmount)
        return CurrentAmount;
    end
end

function Stronghold.Hero:HasValidHeroOfType(_PlayerID, _Type)
    if Stronghold:IsPlayer(_PlayerID) then
        -- Check lord
        local LordID = GetID(Stronghold.Players[_PlayerID].LordScriptName);
        if IsEntityValid(LordID) then
            local HeroType = Logic.GetEntityType(LordID);
            local TypeName = Logic.GetEntityTypeName(HeroType);
            if type(_Type) == "string" and TypeName and string.find(TypeName, _Type) then
                return true;
            elseif type(_Type) == "number" and HeroType == _Type then
                return true;
            end
        end
        -- Check spouse
        local SpouseID = GetID(Stronghold.Players[_PlayerID].SpouseScriptName);
        if IsEntityValid(SpouseID) then
            local HeroType = Logic.GetEntityType(SpouseID);
            local TypeName = Logic.GetEntityTypeName(HeroType);
            if type(_Type) == "string" and TypeName and string.find(TypeName, _Type) then
                return true;
            elseif type(_Type) == "number" and HeroType == _Type then
                return true;
            end
        end
    end
    -- No hero found
    return false;
end

-- Passive Ability: Weather energy production bonus
function Stronghold.Hero:EnergyProductionBonus(_PlayerID)
    if self:HasValidHeroOfType(_PlayerID, "^PU_Hero1[abc]+$") then
        local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Engineer);
        if Amount > 0 then
            Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.WeatherEnergy, Amount * 2);
        end
    end
end

-- Passive Ability: Faith production bonus
function Stronghold.Hero:FaithProductionBonus(_PlayerID)
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero6) then
        local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Priest);
        if Amount > 0 then
            Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.Faith, Amount * 2);
        end
    end
end

-- Passive Ability: Resource production bonus
-- (Callback is only called for main resource types)
function Stronghold.Hero:ResourceProductionBonus(_PlayerID, _Type, _Amount)
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero2) then
        if _Amount >= 4 then
            if _Type == ResourceType.SulfurRaw
            or _Type == ResourceType.ClayRaw
            or _Type == ResourceType.WoodRaw
            or _Type == ResourceType.StoneRaw
            or _Type == ResourceType.IronRaw then
                -- TODO: Maybe use the non-raw here?
                Logic.AddToPlayersGlobalResource(_PlayerID, _Type, 1);
            end
        end
    end
end

-- Passive Ability: Increase of reputation
function Stronghold.Hero:ApplyReputationBuildingBonusPassiveAbility(_PlayerID, _Type, _Amount)
    local Value = _Amount;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Barbarian_Hero) then
        if _Type == Entities.PB_Tavern1 or _Type == Entities.PB_Tavern2 then
            Value = Value * 1.5;
        end
    end
    return Value;
end

-- Passive Ability: unit costs
function Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, _Costs)
    local Costs = _Costs;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
        if Costs[ResourceType.Honor] then
            Costs[ResourceType.Honor] = math.ceil(Costs[ResourceType.Honor] * 1.30);
        end
        if Costs[ResourceType.Gold] then
            Costs[ResourceType.Gold] = math.ceil(Costs[ResourceType.Gold] * 1.30);
        end
        if Costs[ResourceType.Clay] then
            Costs[ResourceType.Clay] = math.ceil(Costs[ResourceType.Clay] * 1.30);
        end
        if Costs[ResourceType.Wood] then
            Costs[ResourceType.Wood] = math.ceil(Costs[ResourceType.Wood] * 1.30);
        end
        if Costs[ResourceType.Stone] then
            Costs[ResourceType.Stone] = math.ceil(Costs[ResourceType.Stone] * 1.30);
        end
        if Costs[ResourceType.Iron] then
            Costs[ResourceType.Iron] = math.ceil(Costs[ResourceType.Iron] * 1.30);
        end
        if Costs[ResourceType.Sulfur] then
            Costs[ResourceType.Sulfur] = math.ceil(Costs[ResourceType.Sulfur] * 1.30);
        end
    end
    return Costs;
end

-- Passive Ability: Increase of attraction
function Stronghold.Hero:ApplyMaxAttractionPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Evil_Queen) then
        Value = Value * 1.3;
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold.Hero:ApplyMaxReputationPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero11) then
        Value = 300;
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold.Hero:ApplyReputationIncreasePassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    -- do nothing
    return Value;
end

-- Passive Ability: Decrease of reputation
function Stronghold.Hero:ApplyReputationDecreasePassiveAbility(_PlayerID, _Decrease)
    local Decrease = _Decrease;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_BlackKnight) then
        Decrease = Decrease * 0.5;
    end
    return Decrease;
end

-- Passive Ability: Honor increase bonus
function Stronghold.Hero:ApplyHonorBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero3) then
        local Alchemists = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Alchemist);
        local Engineers = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Engineer);
        local Scholars = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Scholar);
        Income = Income + ((Scholars+Engineers+Alchemists) * 0.15);
    end
    return Income;
end

-- Passive Ability: Tax income bonus
function Stronghold.Hero:ApplyIncomeBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero5) then
        Income = Income * 1.15;
    end
    return Income;
end

-- Passive Ability: Upkeep discount
function Stronghold.Hero:ApplyUpkeepDiscountPassiveAbility(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    -- Do nothing
    return Upkeep;
end

-- Passive Ability: Upkeep discount
-- This function is called for each unit type individually.
function Stronghold.Hero:ApplyUnitUpkeepDiscountPassiveAbility(_PlayerID, _Type, _Upkeep)
    local Upkeep = _Upkeep;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Mary_de_Mortfichet) then
        if _Type == Entities.PU_Scout or _Type == Entities.PU_Thief then
            Upkeep = 0;
        end
    end
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero10) then
        if _Type == Entities.PU_LeaderRifle1 or _Type == Entities.PU_LeaderRifle2 then
            Upkeep = Upkeep * 0.9;
        end
    end
    return Upkeep;
end

