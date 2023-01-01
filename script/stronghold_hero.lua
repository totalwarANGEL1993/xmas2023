-- 
-- 
-- 

Stronghold = Stronghold or {};

-- -------------------------------------------------------------------------- --
-- Select Hero

Stronghold.Config.Hero = {
    LordTypes = {
        [Entities.PU_Hero1c]             = true,
        [Entities.PU_Hero2]              = true,
        [Entities.PU_Hero3]              = true,
        [Entities.PU_Hero4]              = true,
        [Entities.PU_Hero6]              = true,
        [Entities.CU_BlackKnight]        = true,
    },
    SpouseTypes = {
        [Entities.PU_Hero5]              = true,
        [Entities.PU_Hero11]             = true,
        [Entities.CU_Mary_de_Mortfichet] = true,
    },

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
            Description = "Passive Fähigkeit: @cr Der Sold für alle Einheitentypen wird um 10% verringert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Ein Rundumschlag verletzt alle nahestehenden Feinde.",
        },
        [Entities.PU_Hero6]              = {
            Description = "Passive Fähigkeit: @cr Für jeden Priester wird zusätzlicher Glauben produziert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann die Rüstung von verbündeten Einheiten verbessern.",
        },
        [Entities.CU_BlackKnight]        = {
            Description = "Passive Fähigkeit: @cr Der Malus auf die Beliebtheit wird um 20% verringert."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann die Rüstung von nahestehenden Feinden senken.",
        },
        ---
        [Entities.PU_Hero5]              = {
            Description = "Passive Fähigkeit: @cr Die Steuereinnahmen werden um 10% erhöht."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann Pfeile auf feindliche Truppen regnen lassen.",
        },
        [Entities.PU_Hero11]             = {
            Description = "Passive Fähigkeit: @cr Die maximale Beliebtheit wird auf 300 erhöht."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann Shuriken auf feindliche Truppen schleudern.",
        },
        [Entities.CU_Mary_de_Mortfichet] = {
            Description = "Passive Fähigkeit: @cr Kundschafter und Diebe verlangen keinen Sold."..
                          " @cr @cr "..
                          "Aktive Fähigkeit: @cr Kann die Angriffskraft von nahestehenden Feinden senken.",
        },
    },

    LordStats = {
        Health = 10000,
        Armor = 10,
        Damage = 48,
        Healing = 0,
    },
    SpouseStats = {
        Health = 2000,
        Armor = 5,
        Damage = 22,
        Healing = 5,
    },

    TypeToBuyHeroButton = {
        [Entities.PU_Hero1c]             = "BuyHeroWindowBuyHero1",
        [Entities.PU_Hero2]              = "BuyHeroWindowBuyHero5",
        [Entities.PU_Hero3]              = "BuyHeroWindowBuyHero4",
        [Entities.PU_Hero4]              = "BuyHeroWindowBuyHero3",
        [Entities.PU_Hero6]              = "BuyHeroWindowBuyHero6",
        [Entities.CU_BlackKnight]        = "BuyHeroWindowBuyHero8",
        ---
        [Entities.PU_Hero5]              = "BuyHeroWindowBuyHero2",
        [Entities.PU_Hero11]             = "BuyHeroWindowBuyHero11",
        [Entities.CU_Mary_de_Mortfichet] = "BuyHeroWindowBuyHero7",
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
        ReplaceEntity(self.Players[_PlayerID].LordScriptName, _Type);
        self:BuyHeroConfigureLord(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            GameCallback_GUI_SelectionChanged();
        end
    end
end

function Stronghold:BuyHeroConfigureLord(_PlayerID, _Type)
    if self.Players[_PlayerID] then
        local ID = GetID(self.Players[_PlayerID].LordScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.Hero.LordStats.Armor);
            CEntity.SetDamage(ID, self.Config.Hero.LordStats.Damage);
            CEntity.SetHealingPoints(ID, self.Config.Hero.LordStats.Healing);
            CEntity.SetMaxHealth(ID, self.Config.Hero.LordStats.Health);
            Logic.HealEntity(ID, self.Config.Hero.LordStats.Health);
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
        self:BuyHeroConfigureSpouse(_PlayerID);
        if _PlayerID == GUI.GetPlayerID() then
            GameCallback_GUI_SelectionChanged();
        end
    end
end

function Stronghold:BuyHeroConfigureSpouse(_PlayerID)
    if self.Players[_PlayerID] then
        local ID = GetID(self.Players[_PlayerID].SpouseScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.Hero.SpouseStats.Armor);
            CEntity.SetDamage(ID, self.Config.Hero.SpouseStats.Damage);
            CEntity.SetHealingPoints(ID, self.Config.Hero.SpouseStats.Healing);
            CEntity.SetMaxHealth(ID, self.Config.Hero.SpouseStats.Health);
            Logic.HealEntity(ID, self.Config.Hero.SpouseStats.Health);
        end
    end
end

-- -------------------------------------------------------------------------- --
-- Passive Abilities

-- Passive Ability: Weather energy production bonus
function Stronghold:EnergyProductionBonus(_PlayerID)
    if self.Players[_PlayerID] then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(LordID));
        if TypeName and string.find(TypeName, "^PU_Hero1[abc]+$") then
            local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Engineer);
            local Bonus = math.ceil(Amount * 0.18);
            if Bonus > 0 then
                Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.WeatherEnergy, Bonus);
            end
        end
    end
end

-- Passive Ability: Faith production bonus
function Stronghold:FaithProductionBonus(_PlayerID)
    if self.Players[_PlayerID] then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        if Logic.GetEntityType(LordID) == Entities.PU_Hero6 then
            local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Priest);
            local Bonus = math.ceil(Amount * 0.24);
            if Bonus > 0 then
                Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.Faith, Bonus);
            end
        end
    end
end

-- Passive Ability: Increase of attraction
function Stronghold:ApplyMaxAttractionPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    -- Do nothing
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold:ApplyMaxReputationPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self.Players[_PlayerID] then
        local SopuseID = GetID(self.Players[_PlayerID].SpouseScriptName);
        if Logic.GetEntityType(SopuseID) == Entities.PU_Hero11 then
            Value = 300;
        end
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold:ApplyReputationIncreasePassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    -- Do nothing
    return Value;
end

-- Passive Ability: Decrease of reputation
function Stronghold:ApplyReputationDecreasePassiveAbility(_PlayerID, _Decrease)
    local Decrease = _Decrease;
    if self.Players[_PlayerID] then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        if Logic.GetEntityType(LordID) == Entities.CU_BlackKnight then
            Decrease = (Decrease * 0.8);
        end
    end
    return Decrease;
end

-- Passive Ability: Honor increase bonus
function Stronghold:ApplyHonorBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self.Players[_PlayerID] then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        if Logic.GetEntityType(LordID) == Entities.PU_Hero3 then
            local Factor = 1.0;
            local Alchemists = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Alchemist);
            local Engineers = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Engineer);
            local Scholars = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Scholar);
            Factor = (Scholars+Engineers+Alchemists) + 0.15;
            Income = Income * Factor;
        end
    end
    return Income;
end

-- Passive Ability: Tax income bonus
function Stronghold:ApplyIncomeBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self.Players[_PlayerID] then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        if Logic.GetEntityType(LordID) == Entities.PU_Hero5 then
            Income = (Income * 1.1) + 0.5;
        end
    end
    return Income;
end

-- Passive Ability: Upkeep discount
-- This function is called for each unit type individually.
function Stronghold:ApplyUpkeepDiscountPassiveAbility(_PlayerID, _Type, _Upkeep)
    local Upkeep = _Upkeep;
    if self.Players[_PlayerID] and Upkeep > 0 then
        local LordID = GetID(self.Players[_PlayerID].LordScriptName);
        if Logic.GetEntityType(LordID) == Entities.PU_Hero4 then
            Upkeep = (Upkeep * 0.9) + 0.5;
        elseif Logic.GetEntityType(LordID) == Entities.CU_Mary_de_Mortfichet then
            if _Type == Entities.PU_Scout or _Type == Entities.PU_Thief then
                Upkeep = 0;
            end
        end
    end
    return Upkeep;
end

