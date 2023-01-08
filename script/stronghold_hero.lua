-- 
-- 
-- 

Stronghold = Stronghold or {};

Stronghold.Hero = {
    SyncEvents = {},
    Data = {},
    Config = {
        LordStats = {
            Health = 2500,
            Armor = 6,
            Damage = 50,
            Healing = 1,
        },
        PetStats = {
            [Entities.CU_Barbarian_Hero_wolf] = {
                Owner = Entities.CU_Barbarian_Hero,
                Health = 400, Armor = 1, Damage = 20, Healing = 10,
            },
            [Entities.PU_Hero5_Outlaw] = {
                Owner = Entities.PU_Hero5,
                Health = 150, Armor = 3, Damage = 10, Healing = 5
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

        LordTypes = {
            {Entities.PU_Hero1c,             true},
            {Entities.PU_Hero2,              true},
            {Entities.PU_Hero3,              true},
            {Entities.PU_Hero4,              true},
            {Entities.PU_Hero5,              true},
            {Entities.PU_Hero6,              true},
            {Entities.CU_BlackKnight,        true},
            {Entities.CU_Mary_de_Mortfichet, true},
            {Entities.CU_Barbarian_Hero,     true},
            {Entities.PU_Hero10,             true},
            {Entities.PU_Hero11,             true},
            {Entities.CU_Evil_Queen,         true},
        },

        --- 

        HeroSkills = {
            [Entities.PU_Hero1c]             = {
                Description = "Passive Fähigkeit: @cr Der Sold aller Einheiten wird von der Krone bezahlt, wodurch Euch alle Einheiten 15% weniger kosten."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Feindliche Einheiten können verjagt werden (außer Nebelvolk).",
            },
            [Entities.PU_Hero2]              = {
                Description = "Passive Fähigkeit: @cr Jedes mal wenn eine Mine Rohstoffe abbaut, wird ein zusätzlicher veredelbarer Rohstoff erzeugt."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Legt eine Bombe, die Feinde schädigt und Schächte freisprengt.",
            },
            [Entities.PU_Hero3]              = {
                Description = "Passive Fähigkeit: @cr Wissen ist Macht! Jedes Mal wenn Ihr eine Technologie erforscht, erhaltet Ihr 3 Ehre."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Kann Fallen verstecken, die explodieren, wenn Feinde in der Nähe sind.",
            },
            [Entities.PU_Hero4]              = {
                Description = "Passive Fähigkeit: @cr Soldaten werden mit der maximalen Erfahrung rekrutiert, dadurch steigen allerdings ihre Kosten um 30%."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Ein Rundumschlag verletzt alle nahestehenden Feinde.",
            },
            [Entities.PU_Hero5]              = {
                Description = "Passive Fähigkeit: @cr Beim Volke ist mehr zu holen, als mancher denkt. Die Steuereinnahmen werden um 30% erhöht."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Kann Gesetzlose um sich scharen. Je höher der Rang, desto mehr Gesetzlose sind es.",
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
                Description = "Passive Fähigkeit: @cr Der Pöbel ist so leicht einzuschüchtern... Alle negative Effekte auf die Beliebtheit werden um 50% verringert."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Kann die Rüstung von nahestehenden Feinden halbieren.",
            },
            [Entities.CU_Barbarian_Hero]     = {
                Description = "Passive Fähigkeit: @cr Einen Sieg muss man zu feiern wissen! Alle Tavernen produzieren 50% zusätzliche Beliebtheit."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Ruft Wölfe, die Ehre erzeugen, wenn sie Feinde töten. Ihre Stärke richtet sich nach dem Rang.",
            },
            [Entities.PU_Hero10]             = {
                Description = "Passive Fähigkeit: @cr Durch effizientere Trainingsmethoden sinken die Kosten für den Unterhalt aller Scharfschützen um 50%."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Kann den Schaden von verbündeten Fernkämpfern verbessern.",
            },
            [Entities.PU_Hero11]             = {
                Description = "Passive Fähigkeit: @cr Jeder Arbeiter gibt alles für die Einheitspartei! Die maximale Beliebtheit wird auf 300 erhöht."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Kann befreundete Arbeiter mit Feuerwerk motivieren.",
            },
            [Entities.CU_Evil_Queen] = {
                Description = "Passive Fähigkeit: @cr Die gesteigerte Geburtenrate sorgt für einen demographischen Wandel, der Euer Bevölkerungslimit um 30% anhebt."..
                              " @cr @cr "..
                              "Aktive Fähigkeit: @cr Kann nahestehende Feinde mit Gift schädigen.",
            },
        },
    }
}

function Stronghold.Hero:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    self:OverrideBuyHeroWindow();
    self:OverrideCalculationCallbacks();
    self:OverrideLeaderFormationAction();
    self:OverrideLeaderFormationTooltip();
    self:OverrideLeaderFormationUpdate();
    self:CreateHeroButtonHandlers();
    self:OverrideHero5AbilitySummon();
    self:StartTriggers();
end

function Stronghold.Hero:OnSaveGameLoaded()
    for i= 1, table.getn(Score.Player) do
        self:HeadquartersConfigureBuilding(i);
        self:ConfigurePlayersLord(i);
    end
end

-- -------------------------------------------------------------------------- --
-- Rank Up

function Stronghold.Hero:CreateHeroButtonHandlers()
    self.SyncEvents = {
        RankUp = 1,
        Hero5Summon = 2,
        BuyLord = 3,
    };

    self.NetworkCall = Stronghold.Sync:CreateSyncEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Hero.SyncEvents.RankUp then
                Stronghold:PromotePlayer(_PlayerID);
            end
            if _Action == Stronghold.Hero.SyncEvents.Hero5Summon then
                Stronghold:OnHero5SummonSelected(_PlayerID, arg[1], arg[2], arg[3]);
            end
            if _Action == Stronghold.Hero.SyncEvents.BuyLord then
                Stronghold.Hero:BuyHeroCreateLord(_PlayerID, arg[1]);
            end
        end
    );
end

function Stronghold.Hero:OverrideLeaderFormationAction()
    self.Orig_GUIAction_ChangeFormation = GUIAction_ChangeFormation;
    GUIAction_ChangeFormation = function(_Index)
        local EntityID = GUI.GetSelectedEntity();
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return self.Orig_GUIAction_ChangeFormation(_Index);
        end
        if GetID(Stronghold.Players[PlayerID].LordScriptName) ~= EntityID then
            return self.Orig_GUIAction_ChangeFormation(_Index);
        end
        if _Index > 1 then
            return self.Orig_GUIAction_ChangeFormation(_Index);
        end

        local Rank = Stronghold:GetRank(PlayerID);
        local NextRank = Stronghold.Config.Ranks[Rank+1];
        if NextRank then
            local Costs = Stronghold:CreateCostTable(unpack(NextRank.Costs));
            if not HasPlayerEnoughResourcesFeedback(Costs) then
                return;
            end
        end

        if Stronghold:CanPlayerBePromoted(PlayerID) then
            Stronghold.Sync:Call(
                Stronghold.Hero.NetworkCall,
                PlayerID,
                Stronghold.Hero.SyncEvents.RankUp
            );
        end
    end
end

function Stronghold.Hero:OverrideLeaderFormationTooltip()
    self.Orig_GUITooltip_NormalButton = GUITooltip_NormalButton;
    GUITooltip_NormalButton = function(_Key)
        local EntityID = GUI.GetSelectedEntity();
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return self.Orig_GUITooltip_NormalButton(_Key);
        end
        if GetID(Stronghold.Players[PlayerID].LordScriptName) ~= EntityID then
            return self.Orig_GUITooltip_NormalButton(_Key);
        end

        local CostText = "";
        local Text = "";
        local NextRank = Stronghold:GetRank(PlayerID) +1;
        if _Key == "MenuCommandsGeneric/formation_group" then
            if Stronghold.Config.Ranks[NextRank] then
                Text = "@color:180,180,180 " ..Stronghold:GetRankName(PlayerID, NextRank)..
                       " @color:255,255,255 @cr Lasst Euch in einen höheren Adelsstand "..
                       " erheben, um neuen Privilegien zu genießen.";

                local Costs = Stronghold.Config.Ranks[NextRank].Costs;
                Costs = Stronghold:CreateCostTable(unpack(Costs));
                CostText = Stronghold:FormatCostString(PlayerID, Costs);
            else
                Text = "@color:180,180,180 Höchster Rang @color:255,255,255 @cr "..
                       " Ihr könnt keinen höheren Rang erreichen.";
            end
        else
            return self.Orig_GUITooltip_NormalButton(_Key);
        end
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostText);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    end
end

function Stronghold.Hero:OverrideLeaderFormationUpdate()
    self.Orig_GUIUpdate_BuildingButtons = GUIUpdate_BuildingButtons;
    GUIUpdate_BuildingButtons = function(_Button, _Technology)
        local EntityID = GUI.GetSelectedEntity();
        local PlayerID = GUI.GetPlayerID();
        if not Stronghold:IsPlayer(PlayerID) then
            return self.Orig_GUIUpdate_BuildingButtons(_Button, _Technology);
        end
        if GetID(Stronghold.Players[PlayerID].LordScriptName) ~= EntityID then
            return self.Orig_GUIUpdate_BuildingButtons(_Button, _Technology);
        end
        local Disabled = (Stronghold:CanPlayerBePromoted(PlayerID) and 0) or 1;
        XGUIEng.DisableButton(_Button, Disabled);
    end
end

-- -------------------------------------------------------------------------- --
-- Selection Menu

function Stronghold.Hero:OnSelectLeader(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if GUI.GetPlayerID() ~= PlayerID and not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    if Logic.IsLeader(_EntityID) == 0 then
        return;
    end

    XGUIEng.SetWidgetPosition("Command_Attack", 4, 4);
    XGUIEng.SetWidgetPosition("Command_Stand", 38, 4);
    XGUIEng.SetWidgetPosition("Command_Defend", 72, 4);
    XGUIEng.SetWidgetPosition("Command_Patrol", 106, 4);
    XGUIEng.SetWidgetPosition("Command_Guard", 140, 4);
    XGUIEng.SetWidgetPosition("Formation01", 4, 38);

    XGUIEng.TransferMaterials("Levy_Duties", "Formation01");
    XGUIEng.ShowWidget("Selection_Leader", 1);

    local ShowFormations = 0;
    if  Logic.IsEntityInCategory(_EntityID, EntityCategories.Leader) == 1
    and Logic.IsEntityInCategory(_EntityID, EntityCategories.Cannon) == 0
    and Logic.IsEntityInCategory(_EntityID, EntityCategories.Scout) == 0
    and Logic.IsEntityInCategory(_EntityID, EntityCategories.Thief) == 0 then
        ShowFormations = 1;
    end
    XGUIEng.ShowWidget("Commands_Leader", ShowFormations);
    for i= 1, 4 do
        XGUIEng.ShowWidget("Formation0" ..i, 1);
        if XGUIEng.IsButtonDisabled("Formation0" ..i) == 1 then
            if Logic.IsTechnologyResearched(_EntityID, Technologies.GT_StandingArmy) == 1 then
                XGUIEng.DisableButton("Formation0" ..i, 0);
            end
        end
    end
end

function Stronghold.Hero:OnSelectHero(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if GUI.GetPlayerID() ~= PlayerID and not Stronghold:IsPlayer(PlayerID) then
        return;
    end
    if Logic.IsHero(_EntityID) == 0 then
        return;
    end

    XGUIEng.SetWidgetPosition("Command_Attack", 4, 4);
    XGUIEng.SetWidgetPosition("Command_Stand", 38, 4);
    XGUIEng.SetWidgetPosition("Command_Defend", 72, 4);
    XGUIEng.SetWidgetPosition("Command_Patrol", 106, 4);
    XGUIEng.SetWidgetPosition("Command_Guard", 140, 4);
    XGUIEng.SetWidgetPosition("Formation01", 404, 4);

    local Formation1Visible = 0;
    local Formation1Disabled = 0;
    if GetID(Stronghold.Players[PlayerID].LordScriptName) == _EntityID then
        Formation1Disabled = (Stronghold:CanPlayerBePromoted(PlayerID) and 0) or 1;
        Formation1Visible = 1;
        XGUIEng.TransferMaterials("Upgrade_Foundry1", "Formation01");
        XGUIEng.ShowWidget("Selection_Leader", 1);
        XGUIEng.ShowWidget("Commands_Leader", 1);
    end
    XGUIEng.ShowWidget("Formation01", Formation1Visible);
    XGUIEng.DisableButton("Formation01", Formation1Disabled);
    XGUIEng.ShowWidget("Formation02", 0);
    XGUIEng.ShowWidget("Formation03", 0);
    XGUIEng.ShowWidget("Formation04", 0);

    self:OnSelectHero1(_EntityID);
    self:OnSelectHero2(_EntityID);
    self:OnSelectHero3(_EntityID);
    self:OnSelectHero4(_EntityID);
    self:OnSelectHero5(_EntityID);
    self:OnSelectHero6(_EntityID);
    self:OnSelectHero7(_EntityID);
    self:OnSelectHero8(_EntityID);
    self:OnSelectHero9(_EntityID);
    self:OnSelectHero10(_EntityID);
    self:OnSelectHero11(_EntityID);
    self:OnSelectHero12(_EntityID);
end

function Stronghold.Hero:OnSelectHero1(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    local TypeName = Logic.GetEntityTypeName(Type);
    if string.find(TypeName, "^PU_Hero1[abc]+$") then
        XGUIEng.SetWidgetPosition("Hero1_RechargeProtectUnits", 4, 38);
        XGUIEng.SetWidgetPosition("Hero1_ProtectUnits", 4, 38);
        XGUIEng.ShowWidget("Hero1_RechargeSendHawk", 0);
        XGUIEng.ShowWidget("Hero1_SendHawk", 0);
        XGUIEng.ShowWidget("Hero1_LookAtHawk", 0);
    end
end

function Stronghold.Hero:OnSelectHero2(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero2 then
        XGUIEng.SetWidgetPosition("Hero2_RechargePlaceBomb", 4, 38);
        XGUIEng.SetWidgetPosition("Hero2_PlaceBomb", 4, 38);
        XGUIEng.ShowWidget("Hero2_RechargeBuildCannon", 0);
        XGUIEng.ShowWidget("Hero2_BuildCannon", 0);
    end
end

function Stronghold.Hero:OnSelectHero3(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero3 then
        XGUIEng.SetWidgetPosition("Hero3_RechargeBuildTrap", 4, 38);
        XGUIEng.SetWidgetPosition("Hero3_BuildTrap", 4, 38);
        XGUIEng.ShowWidget("Hero3_RechargeHeal", 0);
        XGUIEng.ShowWidget("Hero3_Heal", 0);
    end
end

function Stronghold.Hero:OnSelectHero4(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero4 then
        XGUIEng.SetWidgetPosition("Hero4_RechargeCircularAttack", 4, 38);
        XGUIEng.SetWidgetPosition("Hero4_CircularAttack", 4, 38);
        XGUIEng.ShowWidget("Hero4_RechargeAuraOfWar", 0);
        XGUIEng.ShowWidget("Hero4_AuraOfWar", 0);
    end
end

function Stronghold.Hero:OnSelectHero5(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero5 then
        XGUIEng.SetWidgetPosition("Hero5_RechargeSummon", 4, 38);
        XGUIEng.SetWidgetPosition("Hero5_Summon", 4, 38);
        XGUIEng.ShowWidget("Hero5_RechargeCamouflage", 0);
        XGUIEng.ShowWidget("Hero5_Camouflage", 0);
    end
end

function Stronghold.Hero:OnSelectHero6(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero6 then
        XGUIEng.SetWidgetPosition("Hero6_RechargeBless", 4, 38);
        XGUIEng.SetWidgetPosition("Hero6_Bless", 4, 38);
        XGUIEng.ShowWidget("Hero6_RechargeConvertSettler", 0);
        XGUIEng.ShowWidget("Hero6_ConvertSettler", 0);
    end
end

function Stronghold.Hero:OnSelectHero7(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.CU_BlackKnight then
        XGUIEng.SetWidgetPosition("Hero7_RechargeMadness", 4, 38);
        XGUIEng.SetWidgetPosition("Hero7_Madness", 4, 38);
        XGUIEng.ShowWidget("Hero7_RechargeInflictFear", 0);
        XGUIEng.ShowWidget("Hero7_InflictFear", 0);
    end
end

function Stronghold.Hero:OnSelectHero8(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.CU_Mary_de_Mortfichet then
        XGUIEng.SetWidgetPosition("Hero8_RechargeMoraleDamage", 4, 38);
        XGUIEng.SetWidgetPosition("Hero8_MoraleDamage", 4, 38);
        XGUIEng.ShowWidget("Hero8_RechargePoison", 0);
        XGUIEng.ShowWidget("Hero8_Poison", 0);
    end
end

function Stronghold.Hero:OnSelectHero9(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.CU_Barbarian_Hero then
        XGUIEng.SetWidgetPosition("Hero9_RechargeCallWolfs", 4, 38);
        XGUIEng.SetWidgetPosition("Hero9_CallWolfs", 4, 38);
        XGUIEng.ShowWidget("Hero9_RechargeBerserk", 0);
        XGUIEng.ShowWidget("Hero9_Berserk", 0);
    end
end

function Stronghold.Hero:OnSelectHero10(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero10 then
        XGUIEng.SetWidgetPosition("Hero10_RechargeLongRangeAura", 4, 38);
        XGUIEng.SetWidgetPosition("Hero10_LongRangeAura", 4, 38);
        XGUIEng.ShowWidget("Hero10_RechargeSniperAttack", 0);
        XGUIEng.ShowWidget("Hero10_SniperAttack", 0);
    end
end

function Stronghold.Hero:OnSelectHero11(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.PU_Hero11 then
        XGUIEng.SetWidgetPosition("Hero11_RechargeFireworksMotivate", 4, 38);
        XGUIEng.SetWidgetPosition("Hero11_FireworksMotivate", 4, 38);
        XGUIEng.ShowWidget("Hero11_RechargeShuriken", 0);
        XGUIEng.ShowWidget("Hero11_RechargeFireworksFear", 0);
        XGUIEng.ShowWidget("Hero11_Shuriken", 0);
        XGUIEng.ShowWidget("Hero11_FireworksFear", 0);
    end
end

function Stronghold.Hero:OnSelectHero12(_EntityID)
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.CU_Evil_Queen then
        XGUIEng.SetWidgetPosition("Hero12_RechargePoisonRange", 4, 38);
        XGUIEng.SetWidgetPosition("Hero12_PoisonRange", 4, 38);
        XGUIEng.ShowWidget("Hero12_RechargePoisonArrows", 0);
        XGUIEng.ShowWidget("Hero12_PoisonArrows", 0);
    end
end

-- -------------------------------------------------------------------------- --
-- Buy Hero

function Stronghold.Hero:OpenBuyHeroWindowForLordSelection(_PlayerID)
    if not Stronghold:IsPlayer(_PlayerID) then
        return;
    end
    XGUIEng.ShowWidget("BuyHeroWindow", 1);
    XGUIEng.SetText("BuyHeroWindowHeadline", "Wählt Euren Laird!");
    XGUIEng.SetText("BuyHeroWindowInfoLine", "");
    XGUIEng.SetWidgetPositionAndSize("BuyHeroWindowInfoLine", 350, 60, 460, 50);
    XGUIEng.ShowAllSubWidgets("BuyHeroLine1", 0);

    local PositionX = 20;
    local PositionY = 20;
    XGUIEng.SetWidgetPosition("BuyHeroLine1", 40, 40);
    for i= 1, table.getn(self.Config.LordTypes) do
        local Type = self.Config.LordTypes[i][1];
        if self.Config.LordTypes[i][2] then
            local WidgetID = self.Config.TypeToBuyHeroButton[Type];
            local ButtonW, ButtonH = 60, 90;
            XGUIEng.ShowWidget(WidgetID, 1);
            XGUIEng.SetWidgetPositionAndSize(WidgetID, PositionX, PositionY, ButtonW, ButtonH);
            PositionX = PositionX + 65;
        end
        if math.mod(i, 4) == 0 then
            PositionY = PositionY + 95;
            PositionX = 20;
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

        local RowX, RowY = 122, 155;
        local ButtonW, ButtonH = 65, 90;

        local Text = "";
        for i= 1, table.getn(self.Config.LordTypes) do
            local Type = self.Config.LordTypes[i][1];
            local ButtonStartX = (RowX + (ButtonW * (math.mod(i-1, 4))));
            local ButtonEndX = ButtonStartX + ButtonW;
            local ButtonStartY = RowY;
            local ButtonEndY = RowY + ButtonH;

            local WidgetName = self.Config.TypeToBuyHeroButton[Type];
            if XGUIEng.IsWidgetShown(WidgetName) == 1 then
                if (MouseX >= ButtonStartX and MouseX <= ButtonEndX) and (MouseY >= ButtonStartY and MouseY <= ButtonEndY) then
                    Text = Stronghold.Hero.Config.HeroSkills[Type].Description;
                end
            end

            if math.mod(i, 4) == 0 then
                RowY = RowY + 95;
                RowX = 122;
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
        Stronghold.Sync:Call(
            Stronghold.Hero.NetworkCall,
            PlayerID,
            Stronghold.Hero.SyncEvents.BuyLord,
            _Type
        );
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
        Message(PlayerColor.. " " ..Name.. " @color:180,180,180 wurde als Laird gewählt!");

        if _PlayerID == GUI.GetPlayerID() then
            Stronghold.Building:OnHeadquarterSelected(GUI.GetSelectedEntity());
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

function Stronghold.Hero:ConfigurePlayersHeroPet(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local Type = Logic.GetEntityType(_EntityID);
    if self.Config.PetStats[Type] then
        if self:HasValidHeroOfType(PlayerID, self.Config.PetStats[Type].Owner) then
            local Armor = self.Config.PetStats[Type].Armor;
            local Damage = self.Config.PetStats[Type].Damage;
            local Healing = self.Config.PetStats[Type].Healing;
            local Health = self.Config.PetStats[Type].Health;

            -- Vargs wolves getting stronger with higher rank
            -- (and getting bigger just for show)
            if Type == Entities.CU_Barbarian_Hero_wolf then
                local CurrentRank = Stronghold:GetRank(PlayerID);
                Logic.SetSpeedFactor(_EntityID, 1.1 + ((CurrentRank -1) * 0.035));
                SVLib.SetEntitySize(_EntityID, 1.1 + ((CurrentRank -1) * 0.035));
                Health = Health + math.floor((CurrentRank -1) * 50);
                Healing = Healing + math.floor((CurrentRank -1) * 2);
                Armor = Armor + math.floor(CurrentRank/2);
                Damage = Damage + math.floor(CurrentRank * 2);
            end

            CEntity.SetArmor(_EntityID, Armor);
            CEntity.SetDamage(_EntityID, Damage);
            CEntity.SetHealingPoints(_EntityID, Healing);
            CEntity.SetMaxHealth(_EntityID, Health);
            Logic.HealEntity(_EntityID, Health);
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
                    for i= 1, table.getn(self.Config.LordTypes) do
                        if self.Config.LordTypes[i][1] == HeroType then
                            self:ConfigurePlayersLord(_PlayerID);
                            break;
                        end
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
        "Stronghold_Hero_Trigger_EntityCreated",
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
        Stronghold.Hero:FaithProductionBonus(i);
    end
end

-- -------------------------------------------------------------------------- --
-- Activated Abilities

function Stronghold:OnHero5SummonSelected(_PlayerID, _EntityID, _X, _Y)
    if GUI.GetPlayerID() == _PlayerID then
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesHero5_HERO5_CallBandits_rnd_01);
    end
    Logic.HeroSetAbilityChargeSeconds(_EntityID, Abilities.AbilitySummon, 0);
    local CurrentRank = self:GetRank(_PlayerID);
    for i= 1, (4 + (2 * (CurrentRank -1))) do
        local x = _X + math.random(-400, 400);
        local y = _Y + math.random(-400, 400);
        local ID = AI.Entity_CreateFormation(_PlayerID, Entities.PU_Hero5_Outlaw, nil, 0, x, y, 0, 0, 0, 0);
        Logic.GroupAttackMove(ID, x, y);
    end
end

function Stronghold.Hero:OverrideHero5AbilitySummon()
    self.Orig_GUIAction_Hero5Summon = GUIAction_Hero5Summon;
    GUIAction_Hero5Summon = function()
        local PlayerID = GUI.GetPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        local x,y,z = Logic.EntityGetPos(EntityID);
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Hero.Orig_GUIAction_Hero5Summon();
        end
        Stronghold.Sync:Call(
            Stronghold.Hero.NetworkCall,
            PlayerID,
            Stronghold.Hero.SyncEvents.Hero5Summon,
            EntityID,
            x,y
        );
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

    self.Orig_GameCallback_OnTechnologyResearched = GameCallback_OnTechnologyResearched;
	GameCallback_OnTechnologyResearched = function(_PlayerID, _Technology, _EntityID)
		Stronghold.Hero.Orig_GameCallback_OnTechnologyResearched(_PlayerID, _Technology, _EntityID);
        Stronghold.Hero:ProduceHonorForTechnology(_PlayerID, _Technology, _EntityID);
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
        local LairdID = GetID(Stronghold.Players[_PlayerID].LordScriptName);
        if IsEntityValid(LairdID) then
            local HeroType = Logic.GetEntityType(LairdID);
            local TypeName = Logic.GetEntityTypeName(HeroType);
            if type(_Type) == "string" and TypeName and string.find(TypeName, _Type) then
                return true;
            elseif type(_Type) == "number" and HeroType == _Type then
                return true;
            end
        end
    end
    return false;
end

-- Passive Ability: Produce honor for technology
function Stronghold.Hero:ProduceHonorForTechnology(_PlayerID, _Technology, _EntityID)
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero3) then
        AddHonor(_PlayerID, 3);
    end
end

-- Passive Ability: Faith production bonus
function Stronghold.Hero:FaithProductionBonus(_PlayerID)
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero6) then
        local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Priest);
        if Amount > 0 then
            if math.mod(math.floor(Logic.GetTime() * 10), 2) == 0 then
                Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.Faith, Amount);
            end
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
    -- Do nothing
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
    -- do nothing
    return Income;
end

-- Passive Ability: Tax income bonus
function Stronghold.Hero:ApplyIncomeBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero5) then
        Income = Income * 1.3;
    end
    return Income;
end

-- Passive Ability: Upkeep discount
function Stronghold.Hero:ApplyUpkeepDiscountPassiveAbility(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    if self:HasValidHeroOfType(_PlayerID, "^PU_Hero1[abc]+$") then
        Upkeep = Upkeep * 0.85;
    end
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
            Upkeep = Upkeep * 0.5;
        end
    end
    return Upkeep;
end

