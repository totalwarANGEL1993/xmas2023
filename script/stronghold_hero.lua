-- 
-- 
-- 

Stronghold = Stronghold or {};

-- -------------------------------------------------------------------------- --
-- Select Hero

Stronghold.Config.Hero = {
    HeroSkills = {
        [Entities.PU_Hero1c]             = {
            Description = "Passive Fähigkeit: @cr Für jeden Ingeneur wird zusätzliche Wetterenergie produziert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann feindliche Einheiten verjagen (außer Nebelvolk).",
        },
        [Entities.PU_Hero2]              = {
            Description = "Passive Fähigkeit: @cr Minen bauen pro Arbeitsschritt 1 Einheit Rohstoffe mehr ab."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Legt eine Bombe, die Feinde schädigt und Schächte freisprengt.",
        },
        [Entities.PU_Hero3]              = {
            Description = "Passive Fähigkeit: @cr Erhält mehr Ehre für jeden Alchemisten, Gelehrten und Ingeneur."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann Bataillone auffüllen, wenn diese nicht kämpfen.",
        },
        [Entities.PU_Hero4]              = {
            Description = "Passive Fähigkeit: @cr Der Sold für alle Einheitentypen wird um 15% verringert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Ein Rundumschlag verletzt alle nahestehenden Feinde.",
        },
        [Entities.PU_Hero5]              = {
            Description = "Passive Fähigkeit: @cr Die Steuereinnahmen werden um 15% erhöht."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann Pfeile auf feindliche Truppen regnen lassen.",
        },
        [Entities.PU_Hero6]              = {
            Description = "Passive Fähigkeit: @cr Für jeden Priester wird zusätzlicher Glauben produziert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann die Rüstung von verbündeten Einheiten verbessern.",
        },
        [Entities.CU_Mary_de_Mortfichet] = {
            Description = "Passive Fähigkeit: @cr Kundschafter und Diebe verlangen keinen Sold."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann die Angriffskraft von nahestehenden Feinden senken.",
        },
        [Entities.CU_BlackKnight]        = {
            Description = "Passive Fähigkeit: @cr Der Malus auf die Beliebtheit wird um 30% verringert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann die Rüstung von nahestehenden Feinden senken.",
        },
        [Entities.CU_Barbarian_Hero]     = {
            Description = "Passive Fähigkeit: @cr Alle Tavernen produzieren +3 zusätzliche Beliebtheit."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Ruft Wölfe herbei, die Ehre erzeugen, wenn sie Feinde töten.",
        },
        [Entities.PU_Hero10]             = {
            Description = "Passive Fähigkeit: @cr Scharfschützen verlangen 10% weniger Sold."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann den Schaden von verbündeten Fernkämpfern verbessern.",
        },
        [Entities.PU_Hero11]             = {
            Description = "Passive Fähigkeit: @cr Die maximale Beliebtheit wird auf 300 erhöht."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann befreundete Arbeiter mit Feuerwerk motivieren.",
        },
        [Entities.CU_Evil_Queen] = {
            Description = "Passive Fähigkeit: @cr Das Bevölkerungslimit wird um 10% erhöht."..
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
        Health = 3000,
        Armor = 10,
        Damage = 50,
        Healing = 25,
    },
    SpouseStats = {
        Health = 1500,
        Armor = 6,
        Damage = 35,
        Healing = 15,
    },
    PetStats = {
        [Entities.CU_Barbarian_Hero_wolf] = {
            Owner = Entities.CU_Barbarian_Hero,
            Health = 1000, Armor = 4, Damage = 22, Healing = 15
        },
        [Entities.PU_Hero5_Outlaw] = {
            Owner = Entities.CU_Barbarian_Hero,
            Health = 650, Armor = 5, Damage = 16, Healing = 15
        },
    },

    ---

    LordTypes = {
        [Entities.PU_Hero2]              = true,
        [Entities.PU_Hero3]              = true,
        [Entities.PU_Hero4]              = true,
        [Entities.PU_Hero6]              = true,
        [Entities.PU_Hero10]             = true,
        [Entities.CU_BlackKnight]        = true,
        [Entities.CU_Barbarian_Hero]     = true,
    },
    SpouseTypes = {
        [Entities.PU_Hero1c]             = true,
        [Entities.PU_Hero5]              = true,
        [Entities.PU_Hero11]             = true,
        [Entities.CU_Mary_de_Mortfichet] = true,
        [Entities.CU_Evil_Queen]         = true,
    },
}

function Stronghold:OpenBuyHeroWindowForLordSelection(_PlayerID)
    if not self.Players[_PlayerID] then
        return;
    end
    XGUIEng.ShowWidget("BuyHeroWindow", 1);
    XGUIEng.SetText("BuyHeroWindowHeadline", "Wählt Euren Burgherren!");
    XGUIEng.SetText("BuyHeroWindowInfoLine", "");
    XGUIEng.ShowAllSubWidgets("BuyHeroLine1", 0);

    local PositionX = 20;
    for k, v in pairs(Stronghold.Config.Hero.LordTypes) do
        if v then
            local WidgetID = Stronghold.Config.Hero.TypeToBuyHeroButton[k];
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.SetWidgetPosition(WidgetID, PositionX, 120);
            PositionX = PositionX + 90;
        end
    end
end

function Stronghold:OpenBuyHeroWindowForSpouseSelection(_PlayerID)
    if not self.Players[_PlayerID] then
        return;
    end
    XGUIEng.ShowWidget("BuyHeroWindow", 1);
    XGUIEng.SetText("BuyHeroWindowHeadline", "Wählt Eurer Burgfräulein!");
    XGUIEng.SetText("BuyHeroWindowInfoLine", "");
    XGUIEng.ShowAllSubWidgets("BuyHeroLine1", 0);

    local PositionX = 20;
    for k, v in pairs(Stronghold.Config.Hero.SpouseTypes) do
        if v then
            local WidgetID = Stronghold.Config.Hero.TypeToBuyHeroButton[k];
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.SetWidgetPosition(WidgetID, PositionX, 120);
            PositionX = PositionX + 90;
        end
    end
end

function Stronghold:OverrideBuyHeroWindow(_PlayerID)
    BuyHeroWindow_UpdateInfoLine_Orig_StrongholdHero = BuyHeroWindow_UpdateInfoLine;
    BuyHeroWindow_UpdateInfoLine = function()
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return BuyHeroWindow_UpdateInfoLine_Orig_StrongholdHero();
        end

        local ScreenX, ScreenY = GUI.GetScreenSize();
        local MouseX, MouseY = GUI.GetMousePosition();
        MouseX = MouseX * (ScreenX/1024);
        MouseY = MouseY * (ScreenY/768);

        local RowX, RowY = 160, 278;
        local ButtonW, ButtonH = 90, 135;

        local Text = "";
        local Index = 0;
        for k,v in pairs(Stronghold.Config.Hero.LordTypes) do
            Index = Index +1;
            local ButtonStartX = (RowX + (ButtonW * (Index -1)));
            local ButtonEndX = ButtonStartX + ButtonW;
            local ButtonStartY = RowY;
            local ButtonEndY = RowY + ButtonH;

            local WidgetName = Stronghold.Config.Hero.TypeToBuyHeroButton[k];
            if XGUIEng.IsWidgetShown(WidgetName) == 1 then
                if (MouseX >= ButtonStartX and MouseX <= ButtonEndX) and (MouseY >= ButtonStartY and MouseY <= ButtonEndY) then
                    Text = Stronghold.Config.Hero.HeroSkills[k].Description;
                end
            end
        end
        local Index = 0;
        for k,v in pairs(Stronghold.Config.Hero.SpouseTypes) do
            Index = Index +1;
            local ButtonStartX = (RowX + (ButtonW * (Index -1)));
            local ButtonEndX = ButtonStartX + ButtonW;
            local ButtonStartY = RowY;
            local ButtonEndY = RowY + ButtonH;

            local WidgetName = Stronghold.Config.Hero.TypeToBuyHeroButton[k];
            if XGUIEng.IsWidgetShown(WidgetName) == 1 then
                if (MouseX >= ButtonStartX and MouseX <= ButtonEndX) and (MouseY >= ButtonStartY and MouseY <= ButtonEndY) then
                    Text = Stronghold.Config.Hero.HeroSkills[k].Description;
                end
            end
        end
        XGUIEng.SetText("BuyHeroWindowInfoLine", Text);
    end

    BuyHeroWindow_Action_BuyHero_Orig_StrongholdHero = BuyHeroWindow_Action_BuyHero;
    BuyHeroWindow_Action_BuyHero = function(_Type)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return BuyHeroWindow_Action_BuyHero_Orig_StrongholdHero(_Type);
        end
        if Stronghold.Config.Hero.LordTypes[_Type] then
            Sync.Call(
                "Stronghold_ButtonCallback_Headquarters",
                PlayerID,
                Stronghold.Shared.Button.Headquarters.BuyLord,
                _Type
            );
        else
            Sync.Call(
                "Stronghold_ButtonCallback_Headquarters",
                PlayerID,
                Stronghold.Shared.Button.Headquarters.BuySpouse,
                _Type
            );
        end
        XGUIEng.ShowWidget("BuyHeroWindow", 0);
    end

    BuyHeroWindow_Update_BuyHero_Orig_StrongholdHero = BuyHeroWindow_Update_BuyHero;
    BuyHeroWindow_Update_BuyHero = function(_Type)
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold.Players[PlayerID] then
            return BuyHeroWindow_Update_BuyHero_Orig_StrongholdHero(_Type);
        end
    end
end

function Stronghold:BuyHeroCreateLord(_PlayerID, _Type)
    if self.Players[_PlayerID] then
        self.Players[_PlayerID].LordChosen = true;
        local Position = self.Players[_PlayerID].DoorPos;
        ID = Logic.CreateEntity(_Type, Position.X, Position.Y, 0, _PlayerID);
        Logic.SetEntityName(ID, self.Players[_PlayerID].LordScriptName);
        Position = self.Players[_PlayerID].CampPos;
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

function Stronghold:ConfigurePlayersLord(_PlayerID)
    if self.Players[_PlayerID] then
        local ID = GetID(self.Players[_PlayerID].LordScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.Hero.LordStats.Armor);
            CEntity.SetDamage(ID, self.Config.Hero.LordStats.Damage);
            CEntity.SetHealingPoints(ID, self.Config.Hero.LordStats.Healing);
            CEntity.SetMaxHealth(ID, self.Config.Hero.LordStats.Health);
            if Logic.GetEntityHealth(ID) > 0 then
                Logic.HealEntity(ID, self.Config.Hero.LordStats.Health);
            end
        end
    end
end

function Stronghold:BuyHeroCreateSpouse(_PlayerID, _Type)
    if self.Players[_PlayerID] then
        self.Players[_PlayerID].SpouseChosen = true;
        local Position = self.Players[_PlayerID].DoorPos;
        local ID = Logic.CreateEntity(_Type, Position.X, Position.Y, 0, _PlayerID);
        Logic.SetEntityName(ID, self.Players[_PlayerID].SpouseScriptName);
        Position = self.Players[_PlayerID].CampPos;
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

function Stronghold:ConfigurePlayersSpouse(_PlayerID)
    if self.Players[_PlayerID] then
        local ID = GetID(self.Players[_PlayerID].SpouseScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.Hero.SpouseStats.Armor);
            CEntity.SetDamage(ID, self.Config.Hero.SpouseStats.Damage);
            CEntity.SetHealingPoints(ID, self.Config.Hero.SpouseStats.Healing);
            CEntity.SetMaxHealth(ID, self.Config.Hero.SpouseStats.Health);
            if Logic.GetEntityHealth(ID) > 0 then
                Logic.HealEntity(ID, self.Config.Hero.SpouseStats.Health);
            end
        end
    end
end

function Stronghold:ConfigurePlayersHeroPet(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local Type = Logic.GetEntityType(_EntityID);
    if self.Config.Hero.PetStats[Type] then
        if Stronghold:HasValidHeroOfType(PlayerID, self.Config.Hero.PetStats[Type].Owner) then
            CEntity.SetArmor(_EntityID, self.Config.Hero.PetStats[Type].Armor);
            CEntity.SetDamage(_EntityID, self.Config.Hero.PetStats[Type].Damage);
            CEntity.SetHealingPoints(_EntityID, self.Config.Hero.PetStats[Type].Healing);
            CEntity.SetMaxHealth(_EntityID, self.Config.Hero.PetStats[Type].Health);
            Logic.HealEntity(_EntityID, self.Config.Hero.PetStats[Type].Health);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Trigger

function Stronghold:EntityAttackedController(_PlayerID)
    if self.Players[_PlayerID] then
        for k,v in pairs(self.Players[_PlayerID].AttackMemory) do
            -- Count down and remove
            self.Players[_PlayerID].AttackMemory[k][1] = v[1] -1;
            if self.Players[_PlayerID].AttackMemory[k][1] <= 0 then
                self.Players[_PlayerID].AttackMemory[k] = nil;
            end

            -- Hati und Skalli
            if Logic.GetEntityType(v[2]) == Entities.CU_Barbarian_Hero_wolf then
                if Logic.GetEntityHealth(k) == 0 then
                    self.Players[_PlayerID].AttackMemory[k] = nil;
                    local WolfPlayerID = Logic.EntityGetPlayer(v[2]);
                    AddHonor(WolfPlayerID, 1);
                end
            end

            -- Teleport to HQ
            if Logic.IsHero(k) == 1 then
                if Logic.GetEntityHealth(k) == 0 then
                    self.Players[_PlayerID].AttackMemory[k] = nil;
                    local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
                    local HeroType = Logic.GetEntityType(k);
                    local x,y,z = Logic.EntityGetPos(k);

                    -- Place hero
                    Logic.CreateEffect(GGL_Effects.FXDieHero, x, y, _PlayerID);
                    local ID = SetPosition(k, self.Players[_PlayerID].DoorPos);
                    Logic.HurtEntity(ID, Logic.GetEntityHealth(ID));
                    -- Handle lord
                    if self.Config.Hero.LordTypes[HeroType] then
                        self:ConfigurePlayersLord(_PlayerID);
                    end
                    -- Handle spouse
                    if self.Config.Hero.SpouseTypes[HeroType] then
                        self:ConfigurePlayersSpouse(_PlayerID);
                    end
                    -- Send message
                    local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(k));
                    local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
                    Message(PlayerColor.. " " ..Name.. " @color:255,255,255 muss sich in die Burg zurückziehen!");
                end
            end

            if not IsExisting(k) then
                self.Players[_PlayerID].AttackMemory[k] = nil;
            end
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Passive Abilities

function Stronghold:HasValidHeroOfType(_PlayerID, _Type)
    if self.Players[_PlayerID] then
        -- Check lord
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
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
        local SpouseID = GetID(self.Players[_PlayerID].SpouseScriptName);
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
function Stronghold:EnergyProductionBonus(_PlayerID)
    if self:HasValidHeroOfType(_PlayerID, "^PU_Hero1[abc]+$") then
        local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Engineer);
        if Amount > 0 then
            Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.WeatherEnergy, Amount * 2);
        end
    end
end

-- Passive Ability: Faith production bonus
function Stronghold:FaithProductionBonus(_PlayerID)
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero6) then
        local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Priest);
        if Amount > 0 then
            Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.Faith, Amount * 2);
        end
    end
end

-- Passive Ability: Resource production bonus
-- (Callback is only called for main resource types)
function Stronghold:ResourceProductionBonus(_PlayerID, _Type, _Amount)
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

-- Passive Ability: Increase of attraction
function Stronghold:ApplyMaxAttractionPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Evil_Queen) then
        Value = Value * 1.1;
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold:ApplyMaxReputationPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero11) then
        Value = 300;
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold:ApplyReputationIncreasePassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    -- do nothing
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold:ApplyReputationBuildingBonusPassiveAbility(_PlayerID, _Type, _Amount, _Value)
    local Value = _Value * _Amount;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Barbarian_Hero) then
        if _Type == Entities.PB_Tavern1 or _Type == Entities.PB_Tavern2 then
            Value = Value + (3 * _Amount);
        end
    end
    return Value;
end

-- Passive Ability: Decrease of reputation
function Stronghold:ApplyReputationDecreasePassiveAbility(_PlayerID, _Decrease)
    local Decrease = _Decrease;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_BlackKnight) then
        Decrease = Decrease * 0.7;
    end
    return Decrease;
end

-- Passive Ability: Honor increase bonus
function Stronghold:ApplyHonorBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero3) then
        local Factor = 1.0;
        local Alchemists = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Alchemist);
        local Engineers = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Engineer);
        local Scholars = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Scholar);
        Factor = (Scholars+Engineers+Alchemists) + 0.15;
        Income = Income * Factor;
    end
    return Income;
end

-- Passive Ability: Tax income bonus
function Stronghold:ApplyIncomeBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero5) then
        Income = Income * 1.15;
    end
    return Income;
end

-- Passive Ability: Upkeep discount
-- This function is called for each unit type individually.
function Stronghold:ApplyUpkeepDiscountPassiveAbility(_PlayerID, _Type, _Upkeep)
    local Upkeep = _Upkeep;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
        Upkeep = Upkeep * 0.85;
    end
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
