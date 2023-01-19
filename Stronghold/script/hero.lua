--- 
--- Hero Script
---
--- This script implements all processes around the hero.
---
--- Managed by the script:
--- - Stats of hero
--- - Stats of summons
--- - Selection of hero
--- - Activated abilities
--- - Passive abilities
--- - Selection menus
--- - Gender of hero (for text)
--- 

Stronghold = Stronghold or {};

Stronghold.Hero = {
    SyncEvents = {},
    Data = {},
    Config = {
        Rule = {
            Lord = {
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
        },

        --- 

        Unit = {
            Laird = {
                Health = 2500,
                Armor = 6,
                Damage = 50,
                Healing = 1,
            },
            Pet = {
                [Entities.CU_Barbarian_Hero_wolf] = {
                    Owner = Entities.CU_Barbarian_Hero,
                    Health = 400, Armor = 1, Damage = 20, Healing = 10,
                },
                [Entities.PU_Hero5_Outlaw] = {
                    Owner = Entities.PU_Hero5,
                    Health = 150, Armor = 3, Damage = 10, Healing = 5
                },
            },
        },

        ---

        UI = {
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
            HeroCV = {
                [Entities.PU_Hero1c]             = {
                    Description = "DARIO @cr @cr @color:180,180,180 "..
                                  "Trotz seiner jungen Jahre obliegen die Geschicke des Reiches ihm. Früher wurde er "..
                                  "oft dabei gesehen, wie er rosa Kleidchen trug. Die tauschte er inzwischen gegen ein "..
                                  "Schwert ein. Dennoch fragen sich viele, ob er einen Vogel hat."..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Als König hat Dario die Autorität, schneller Maßnahmen zu "..
                                  "ergreifen. Eure Maßnahmen sind 50% schneller wieder einsetzbar."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Feindliche Einheiten können verjagt werden (außer Nebelvolk).",
                },
                [Entities.PU_Hero2]              = {
                    Description = "PILGRIM @cr @cr @color:180,180,180 "..
                                  "Pilgrim entstammt einer langen Linie von Bergmännern. Ein Glückliches Schicksal " ..
                                  "verhalf ihm zu Geld und Würden. Dem Alkohol ist er stets zugetan. Es fällt ihm oft "..
                                  "schwer, seine Fahne vom Geruch des Sprengstoffs zu unterscheiden." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Jedes mal wenn in einer Mine Rohstoffe abbaut werden, werden "..
                                  " zusätzliche veredelbare Rohstoffe erzeugt."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Legt eine Bombe, die Feinde schädigt und Schächte freisprengt.",
                },
                [Entities.PU_Hero3]              = {
                    Description = "SALIM @cr @cr @color:180,180,180 "..
                                  "Ein Schriftgelehrter aus dem nahen Osten. Manche sagen ihm nach, er sei verrückt " ..
                                  "geworden und versuche in seinem Labor ein schwarzes Loch zu erschaffen und so "..
                                  "die Vergangenheit zu verändern." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Wissen ist Macht! Wenn eine Technologie erforscht wird, "..
                                  "erhält Salim 5 Ehre."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann eine Falle verstecken, die explodiert, sobald der Feind "..
                                  "unvorsichtig an sie heran tritt.",
                },
                [Entities.PU_Hero4]              = {
                    Description = "EREC @cr @cr @color:180,180,180 "..
                                  "Er ist ein echter Ritter. Von Kopf bis Fuß gehüllt in glänzender Rüstung zieht er "..
                                  "aus, seinen Ruhm zu mehren und Jungfrauen in Nöten beizustehen. Seine Anwesenheit " ..
                                  "inspiriert die Truppen zu Höchsleistungen." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Soldaten werden mit der maximalen Erfahrung rekrutiert, "..
                                  "dadurch steigen allerdings ihre Kosten um 30%."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Ein Rundumschlag verletzt alle nahestehenden Feinde.",
                },
                [Entities.PU_Hero5]              = {
                    Description = "ARI @cr @cr @color:180,180,180 "..
                                  "Als Kind wurde Ari von Gesetzlosen adoptiert und wuchs zu einer atemberaubenden " ..
                                  "Lady heran. Aber dies ist mit Nichten ihre einzige Qualität, was sie jeden spüren " ..
                                  "lässt, der sich erdreistet, ihre Augen eine Etage tiefer zu suchen." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Beim Volke ist mehr zu holen, als so mancher vermutet. Die "..
                                  "Steuereinnahmen werden um 50% erhöht."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann Gesetzlose um sich scharen. Je höher der Rang, desto mehr "..
                                  "Gesetzlose sind es.",
                },
                [Entities.PU_Hero6]              = {
                    Description = "HELIAS @cr @cr @color:180,180,180 "..
                                  "Einst vorgesehen für die Thronfolge des Alten Reiches, war der Ruf Gottes stärker. " ..
                                  "Vor grauen Jahren trat Helias in den geistlichen Stand und überließ seinem jüngerem " ..
                                  "Bruder den Thron des Alten Reiches." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Helias produziert für jeden Priester auf der Burg zusätzlichen "..
                                  "Glauben."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Helias kann die Rüstung von verbündeten Einheiten verbessern.",
                },
                [Entities.CU_Mary_de_Mortfichet] = {
                    Description = "MARY @cr @cr @color:180,180,180 "..
                                  "Die Countess de Mortfichet ist verrufen als ruchloses und ehrloses Miststück. " ..
                                  "Zeigt ihr Gegenüber eine Schwäche, so wird sie nicht zögern, sie auszunutzen. Ihr " ..
                                  "Motto: Ein gut platzierter Dolch erreicht mehr als 1000 Schwerter." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Kundschafter und Diebe nehmen keinen Bevölkerungsplatz ein "..
                                  "und verlangen keinen Sold."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann die Angriffskraft von nahestehenden Feinden senken.",
                },
                [Entities.CU_BlackKnight]        = {
                    Description = "KERBEROS @cr @cr @color:180,180,180 "..
                                  "Als sein Vater den Thron aufgab um Pfaffe zu werden, brach für Kerberos eine Welt " ..
                                  "zusammen. Seinem Erbe beraubt, verfiel der der Finsternis. Als Scherge eines bösen " ..
                                  " Königs wartet er auf seine Chance." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Alle Negative Effekte auf die Beliebtheit verringern sich "..
                                  "um 50%. Die maximale Beliebtheit sinkt auf 150%." ..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann die Rüstung von nahestehenden Feinden halbieren.",
                },
                [Entities.CU_Barbarian_Hero]     = {
                    Description = "VARG @cr @cr @color:180,180,180 "..
                                  "Als er als zwölfjähriger Junge einen Eisbären im Zweikampf besiegte, wurde Varg " ..
                                  "zum Anführer aller Barbaren gekrönt. Als Baby gesäugt von einer Alphawölfin, besitzt " ..
                                  "er die Macht, mächtige Bestien zu beschwören." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Einen Sieg muss man zu feiern wissen! Die Effektivität "..
                                  "von Tavernen wird um 50% verstärkt."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Ruft Wölfe, die Ehre erzeugen, wenn sie Feinde töten. Ihre "..
                                  "Stärke richtet sich nach dem Rang.",
                },
                [Entities.PU_Hero10]             = {
                    Description = "DRAKE @cr @cr @color:180,180,180 "..
                                  "Wenn er nicht gerade auf Haselnüsse und Tannenzapfen schießt, jagt Drake als " ..
                                  "\"Der Schakal\" alle die behaupten, er wolle nur etwas kompensieren. Seine Mutter "..
                                  " meint noch heute, er solle das Gewehr zuhause lassen." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Durch effizientere Trainingsmethoden sinken die Kosten "..
                                  "für den Unterhalt aller Scharfschützen um 50%."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann den Schaden von verbündeten Fernkämpfern verbessern.",
                },
                [Entities.PU_Hero11]             = {
                    Description = "YUKI @cr @cr @color:180,180,180 "..
                                  "Schon als kleines Mädchen beschäftigte sich Yuki mit Pyrotechnik. Zusammn mit den " ..
                                  "drei Chinesen und deren Kontrabass verschlug es sie in den Westen, wo sie Reichtum " ..
                                  "erlangte und nun eine Burg ihr Eigen nennt." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Yuki erhöht die maximale Beliebtheit auf 300. Außerdem "..
                                  "wird die Beliebtheit einmalig um 50 erhöht."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann befreundete Arbeiter mit Feuerwerk motivieren.",
                },
                [Entities.CU_Evil_Queen] = {
                    Description = "KALA @cr @cr @color:180,180,180 "..
                                  "Um ihre Herkunft ranken sich Mysterien und düstere Legenden. Vom Nebelvolk wird " ..
                                  "Kala wie eine Göttin verehrt. Böse Zungen behaupten, sie hätte jeden Einzelnen " ..
                                  "ihrer Untertanen selbst zur Welt gebracht." ..
                                  " @cr @cr @color:255,255,255 " ..
                                  "Passive Fähigkeit: @cr Die gesteigerte Geburtenrate sorgt für einen demographischen "..
                                  "Wandel, der Euer Bevölkerungslimit um 25% anhebt."..
                                  " @cr @cr "..
                                  "Aktive Fähigkeit: @cr Kann nahestehende Feinde mit Gift schädigen.",
                },
            },
        },
    }
}

function Stronghold.Hero:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end

    self:ConfigureBuyHero();
    self:OverrideCalculationCallbacks();
    self:CreateHeroButtonHandlers();
    self:OverrideHero5AbilitySummon();
    self:StartTriggers();
    self:OverrideGUI();
end

function Stronghold.Hero:OnSaveGameLoaded()
    for i= 1, table.getn(Score.Player) do
        self:ConfigurePlayersLord(i);

        local Bandits = {Logic.GetPlayerEntities(i, Entities.PU_Hero5_Outlaw, 48)};
        for j=2, Bandits[1] +1 do
            self:ConfigurePlayersHeroPet(Bandits[j]);
        end
        local Wolves = {Logic.GetPlayerEntities(i, Entities.CU_Barbarian_Hero_wolf, 48)};
        for j=2, Wolves[1] +1 do
            self:ConfigurePlayersHeroPet(Wolves[j]);
        end
    end
end

function Stronghold.Hero:CreateHeroButtonHandlers()
    self.SyncEvents = {
        RankUp = 1,
        Hero5Summon = 2,
    };

    self.NetworkCall = Syncer.CreateEvent(
        function(_PlayerID, _Action, ...)
            if _Action == Stronghold.Hero.SyncEvents.RankUp then
                Stronghold:PromotePlayer(_PlayerID);
            end
            if _Action == Stronghold.Hero.SyncEvents.Hero5Summon then
                Stronghold.Hero:OnHero5SummonSelected(_PlayerID, arg[1], arg[2], arg[3]);
            end
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Rank Up

function Stronghold.Hero:LeaderChangeFormationAction(_Index)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    if GetID(Stronghold.Players[PlayerID].LordScriptName) ~= EntityID then
        return false;
    end
    if _Index > 1 then
        return false;
    end

    local Rank = Stronghold:GetPlayerRank(PlayerID);
    local NextRank = Stronghold.Config.Ranks[Rank+1];
    if NextRank then
        local Costs = Stronghold:CreateCostTable(unpack(NextRank.Costs));
        if not HasPlayerEnoughResourcesFeedback(Costs) then
            return true;
        end
    end

    if Stronghold:CanPlayerBePromoted(PlayerID) then
        Syncer.InvokeEvent(
            Stronghold.Hero.NetworkCall,
            PlayerID,
            Stronghold.Hero.SyncEvents.RankUp
        );
    end
    return true;
end

function Stronghold.Hero:LeaderFormationTooltip(_Key)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Stronghold:GetLocalPlayerID();
    if not Stronghold:IsPlayer(PlayerID) then
        return false;
    end
    if GetID(Stronghold.Players[PlayerID].LordScriptName) ~= EntityID then
        return false;
    end

    local CostText = "";
    local Text = "";
    local NextRank = Stronghold:GetPlayerRank(PlayerID) +1;
    if _Key == "MenuCommandsGeneric/formation_group" then
        if Stronghold.Config.Ranks[NextRank] and NextRank <= Stronghold.Config.Rule.MaxRank then
            local Config = Stronghold.Config.Ranks[NextRank];
            Text = "@color:180,180,180 " ..Stronghold:GetPlayerRankName(PlayerID, NextRank)..
                    " @color:255,255,255 @cr Lasst Euch in einen höheren Adelsstand "..
                    " erheben, um Euer Heer besser aufzustellen.";
            if Config.Description ~= "" then
                Text = Text .. " @cr @color:244,184,0 benötigt: @color:255,255,255 "..
                        Config.Description;
            end

            local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
            CostText = Stronghold:FormatCostString(PlayerID, Costs);
        else
            Text = "@color:180,180,180 Höchster Rang @color:255,255,255 @cr "..
                    " Ihr könnt keinen höheren Rang erreichen.";
        end
    else
        return false;
    end
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostText);
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
    return true;
end

function Stronghold.Hero:LeaderFormationUpdate(_Button, _Technology)
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = GUI.GetPlayerID();
    if not Stronghold:IsPlayer(PlayerID) then
        return true;
    end
    if not string.find(_Button, "Formation") then
        return false;
    end
    local Disabled = 1;
    if Logic.IsTechnologyResearched(PlayerID, Technologies.GT_StandingArmy) == 1 then
        Disabled = 0;
    end
    if GetID(Stronghold.Players[PlayerID].LordScriptName) == EntityID then
        Disabled = (Stronghold:CanPlayerBePromoted(PlayerID) and 0) or 1;
    end
    XGUIEng.DisableButton(_Button, Disabled);
    return true;
end

-- -------------------------------------------------------------------------- --
-- Hero Selection

function Stronghold.Hero:OnSelectLeader(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    if not Stronghold:IsPlayer(PlayerID) or Logic.IsLeader(_EntityID) == 0 then
        return;
    end

    XGUIEng.SetWidgetPosition("Command_Attack", 4, 4);
    XGUIEng.SetWidgetPosition("Command_Stand", 38, 4);
    XGUIEng.SetWidgetPosition("Command_Defend", 72, 4);
    XGUIEng.SetWidgetPosition("Command_Patrol", 106, 4);
    XGUIEng.SetWidgetPosition("Command_Guard", 140, 4);
    XGUIEng.SetWidgetPosition("Formation01", 4, 38);

    XGUIEng.TransferMaterials("Research_Gilds", "Formation01");
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
    if not Stronghold:IsPlayer(PlayerID) or Logic.IsHero(_EntityID) == 0 then
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

function Stronghold.Hero:ConfigureBuyHero()
    self.Orig_GameCallback_Logic_BuyHero_OnHeroSelected = GameCallback_Logic_BuyHero_OnHeroSelected;
    GameCallback_Logic_BuyHero_OnHeroSelected = function(_PlayerID, _ID, _Type)
        if Stronghold:IsPlayer(_PlayerID) then
            Stronghold.Hero:BuyHeroCreateLord(_PlayerID, _ID, _Type);
            Stronghold.Hero:PlayFunnyComment(_PlayerID);
            return;
        end
        return Stronghold.Hero.Orig_GameCallback_Logic_BuyHero_OnHeroSelected(_PlayerID, _ID, _Type);
    end

    self.Orig_GameCallback_GUI_BuyHero_GetHeadline = GameCallback_GUI_BuyHero_GetHeadline;
    GameCallback_GUI_BuyHero_GetHeadline = function(_PlayerID)
        if Stronghold:IsPlayer(_PlayerID) then
            local LairdID = GetID(Stronghold.Players[_PlayerID].LordScriptName);
            local Caption = (LairdID ~= 0 and "Alea Iacta Est!") or "Wählt Euren Laird!";
            return Caption;
        end
        return Stronghold.Hero.Orig_GameCallback_GUI_BuyHero_GetHeadline(_PlayerID);
    end

    self.Orig_GameCallback_GUI_BuyHero_GetMessage = GameCallback_GUI_BuyHero_GetMessage;
    GameCallback_GUI_BuyHero_GetMessage = function(_PlayerID, _Type)
        if Stronghold:IsPlayer(_PlayerID) then
            return Stronghold.Hero.Config.UI.HeroCV[_Type].Description;
        end
        return Stronghold.Hero.Orig_GameCallback_GUI_BuyHero_GetMessage(_PlayerID, _Type);
    end
end

function Stronghold.Hero:BuyHeroCreateLord(_PlayerID, _ID, _Type)
    if Stronghold:IsPlayer(_PlayerID) then
        Logic.SetEntityName(_ID, Stronghold.Players[_PlayerID].LordScriptName);
        self:ConfigurePlayersLord(_PlayerID);

        local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
        local TypeName = Logic.GetEntityTypeName(_Type);
        local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
        Message(PlayerColor.. " " ..Name.. " @color:180,180,180 wurde als Laird gewählt!");

        if _Type == Entities.PU_Hero11 then
            Stronghold:AddPlayerReputation(_PlayerID, 50);
            Stronghold:UpdateMotivationOfWorkers(_PlayerID);
        end
        if _PlayerID == GUI.GetPlayerID() or GUI.GetPlayerID() == 17 then
            Stronghold.Building:OnHeadquarterSelected(GUI.GetSelectedEntity());
        end
    end
end

function Stronghold.Hero:ConfigurePlayersLord(_PlayerID)
    if Stronghold:IsPlayer(_PlayerID) then
        local ID = GetID(Stronghold.Players[_PlayerID].LordScriptName);
        if ID > 0 then
            CEntity.SetArmor(ID, self.Config.Unit.Laird.Armor);
            CEntity.SetDamage(ID, self.Config.Unit.Laird.Damage);
            CEntity.SetHealingPoints(ID, self.Config.Unit.Laird.Healing);
            CEntity.SetMaxHealth(ID, self.Config.Unit.Laird.Health);
            if Logic.GetEntityHealth(ID) > 0 then
                Logic.HealEntity(ID, self.Config.Unit.Laird.Health);
            end
        end
    end
end

function Stronghold.Hero:ConfigurePlayersHeroPet(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local Type = Logic.GetEntityType(_EntityID);
    if self.Config.Unit.Pet[Type] then
        if self:HasValidHeroOfType(PlayerID, self.Config.Unit.Pet[Type].Owner) then
            local Armor = self.Config.Unit.Pet[Type].Armor;
            local Damage = self.Config.Unit.Pet[Type].Damage;
            local Healing = self.Config.Unit.Pet[Type].Healing;
            local Health = self.Config.Unit.Pet[Type].Health;

            -- Vargs wolves getting stronger with higher rank
            -- (and getting bigger just for show)
            if Type == Entities.CU_Barbarian_Hero_wolf then
                local CurrentRank = Stronghold:GetPlayerRank(PlayerID);
                Logic.SetSpeedFactor(_EntityID, 1.1 + ((CurrentRank -1) * 0.04));
                SVLib.SetEntitySize(_EntityID, 1.1 + ((CurrentRank -1) * 0.04));
                Health = Health + math.floor((CurrentRank -1) * 65);
                Healing = Healing + math.floor((CurrentRank -1) * 2.2);
                Armor = Armor + math.floor(CurrentRank * 0.6);
                Damage = Damage + math.floor(CurrentRank * 2.2);
            end

            CEntity.SetArmor(_EntityID, Armor);
            CEntity.SetDamage(_EntityID, Damage);
            CEntity.SetHealingPoints(_EntityID, Healing);
            CEntity.SetMaxHealth(_EntityID, Health);
            Logic.HealEntity(_EntityID, Health);
        end
    end
end

-- Play a funny comment when the hero is selected.
-- (Yes, it is intended that every player hears them.)
function Stronghold.Hero:PlayFunnyComment(_PlayerID)
    local FunnyComment = Sounds.VoicesHero1_HERO1_FunnyComment_rnd_01;
    local LordID = GetID(Stronghold.Players[_PlayerID].LordScriptName);
    local Type = Logic.GetEntityType(LordID);
    if Type == Entities.PU_Hero2 then
        FunnyComment = Sounds.VoicesHero2_HERO2_FunnyComment_rnd_01;
    elseif Type == Entities.PU_Hero3 then
        FunnyComment = Sounds.VoicesHero3_HERO3_FunnyComment_rnd_01;
    elseif Type == Entities.PU_Hero4 then
        FunnyComment = Sounds.VoicesHero4_HERO4_FunnyComment_rnd_01;
    elseif Type == Entities.PU_Hero5 then
        FunnyComment = Sounds.VoicesHero5_HERO5_FunnyComment_rnd_01;
    elseif Type == Entities.PU_Hero6 then
        FunnyComment = Sounds.VoicesHero6_HERO6_FunnyComment_rnd_01;
    elseif Type == Entities.CU_BlackKnight then
        FunnyComment = Sounds.VoicesHero7_HERO7_FunnyComment_rnd_01;
    elseif Type == Entities.CU_Mary_de_Mortfichet then
        FunnyComment = Sounds.VoicesHero8_HERO8_FunnyComment_rnd_01;
    elseif Type == Entities.CU_Barbarian_Hero then
        FunnyComment = Sounds.VoicesHero9_HERO9_FunnyComment_rnd_01;
    elseif Type == Entities.PU_Hero10 then
        FunnyComment = Sounds.AOVoicesHero10_HERO10_FunnyComment_rnd_01;
    elseif Type == Entities.PU_Hero11 then
        FunnyComment = Sounds.AOVoicesHero11_HERO11_FunnyComment_rnd_01;
    elseif Type == Entities.CU_Evil_Queen then
        FunnyComment = Sounds.AOVoicesHero12_HERO12_FunnyComment_rnd_01;
    end
    Sound.PlayQueuedFeedbackSound(FunnyComment, 127);
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
                    Stronghold:AddPlayerHonor(WolfPlayerID, 1);
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
                    for i= 1, table.getn(self.Config.Rule.Lord) do
                        if self.Config.Rule.Lord[i][1] == HeroType then
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

function Stronghold.Hero:OnHero5SummonSelected(_PlayerID, _EntityID, _X, _Y)
    if GUI.GetPlayerID() == _PlayerID then
        Sound.PlayQueuedFeedbackSound(Sounds.VoicesHero5_HERO5_CallBandits_rnd_01, 127);
    end
    Logic.HeroSetAbilityChargeSeconds(_EntityID, Abilities.AbilitySummon, 0);
    local CurrentRank = Stronghold:GetPlayerRank(_PlayerID);
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
        local GuiPlayer = GUI.GetPlayerID();
        local PlayerID = Stronghold:GetLocalPlayerID();
        local EntityID = GUI.GetSelectedEntity();
        local x,y,z = Logic.EntityGetPos(EntityID);
        if not Stronghold:IsPlayer(PlayerID) then
            return Stronghold.Hero.Orig_GUIAction_Hero5Summon();
        end
        if GuiPlayer ~= PlayerID then
            return;
        end
        Syncer.InvokeEvent(
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

    self.Orig_GameCallback_Calculate_DynamicReputationIncrease = GameCallback_Calculate_DynamicReputationIncrease;
    GameCallback_Calculate_DynamicReputationIncrease = function(_PlayerID, _BuildingID, _WorkerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_DynamicReputationIncrease(_PlayerID, _BuildingID, _WorkerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyDynamicReputationBonusPassiveAbility(_PlayerID, _BuildingID, _WorkerID, CurrentAmount);
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

    self.Orig_GameCallback_Calculate_DynamicHonorIncrease = GameCallback_Calculate_DynamicHonorIncrease;
    GameCallback_Calculate_DynamicHonorIncrease = function(_PlayerID, _BuildingID, _WorkerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_DynamicHonorIncrease(_PlayerID, _BuildingID, _WorkerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyDynamicHonorBonusPassiveAbility(_PlayerID, _BuildingID, _WorkerID, CurrentAmount);
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

    self.Orig_GameCallback_Calculate_CivilAttrationLimit = GameCallback_Calculate_CivilAttrationLimit;
    GameCallback_Calculate_CivilAttrationLimit = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_CivilAttrationLimit(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyMaxAttractionPassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_CivilAttrationUsage = GameCallback_Calculate_CivilAttrationUsage;
    GameCallback_Calculate_CivilAttrationUsage = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_CivilAttrationUsage(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyAttractionPassiveAbility(_PlayerID, CurrentAmount);
        return CurrentAmount;
    end

    self.Orig_GameCallback_Calculate_MeasureIncrease = GameCallback_Calculate_MeasureIncrease;
    GameCallback_Calculate_MeasureIncrease = function(_PlayerID, _CurrentAmount)
        local CurrentAmount = Stronghold.Hero.Orig_GameCallback_Calculate_MeasureIncrease(_PlayerID, _CurrentAmount);
        CurrentAmount = Stronghold.Hero:ApplyMeasurePointsPassiveAbility(_PlayerID, CurrentAmount);
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
        Stronghold:AddPlayerHonor(_PlayerID, 5);
    end
end

-- Passive Ability: Faith production bonus
function Stronghold.Hero:FaithProductionBonus(_PlayerID)
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero6) then
        local Amount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Priest);
        if Amount > 0 then
            local Building1 = GetCompletedEntitiesOfType(_PlayerID, Entities.PB_Monastery1);
            local Building2 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Monastery2);
            local Building3 = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PB_Monastery3);
            if table.getn(Building1) + Building2 + Building3 > 0 then
                if math.mod(math.floor(Logic.GetTime() * 10), 2) == 0 then
                    Logic.AddToPlayersGlobalResource(_PlayerID, ResourceType.Faith, Amount);
                end
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

-- Passive Ability: unit costs
function Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, _Costs)
    local Costs = _Costs;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
        -- Honor is not a resource spend when the soldiers are trained.
        -- if Costs[ResourceType.Honor] then
        --     Costs[ResourceType.Honor] = math.ceil(Costs[ResourceType.Honor] * 1.30);
        -- end
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

-- Passive Ability: Increase of civil attraction
function Stronghold.Hero:ApplyMaxAttractionPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Evil_Queen) then
        Value = Value * 1.25;
    end
    return Value;
end

-- Passive Ability: decrease of used civil attraction
function Stronghold.Hero:ApplyAttractionPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if Stronghold.Hero:HasValidHeroOfType(_PlayerID, Entities.CU_Mary_de_Mortfichet) then
        local ScoutCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Scout);
        local ThiefCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Thief);
        Value = Value - (ScoutCount + ThiefCount * 5);
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold.Hero:ApplyMaxReputationPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_BlackKnight) then
        Value = 150;
    elseif self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero11) then
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

-- Passive Ability: Improve dynamic reputation generation
function Stronghold.Hero:ApplyDynamicReputationBonusPassiveAbility(_PlayerID, _BuildingID, _WorkerID, _Amount)
    local Value = _Amount;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Barbarian_Hero) then
        local Type = Logic.GetEntityType(_BuildingID);
        if Type == Entities.PB_Tavern1 or Type == Entities.PB_Tavern2 then
            Value = Value * 1.5;
        end
    end
    return Value;
end

-- Passive Ability: Honor increase bonus
function Stronghold.Hero:ApplyHonorBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    -- do nothing
    return Income;
end

-- Passive Ability: Improve dynamic honor generation
function Stronghold.Hero:ApplyDynamicHonorBonusPassiveAbility(_PlayerID, _BuildingID, _WorkerID, _Amount)
    local Value = _Amount;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_Barbarian_Hero) then
        local Type = Logic.GetEntityType(_BuildingID);
        if Type == Entities.PB_Tavern1 or Type == Entities.PB_Tavern2 then
            Value = Value * 1.5;
        end
    end
    return Value;
end

-- Passive Ability: Tax income bonus
function Stronghold.Hero:ApplyIncomeBonusPassiveAbility(_PlayerID, _Income)
    local Income = _Income;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero5) then
        Income = Income * 1.5;
    end
    return Income;
end

-- Passive Ability: Upkeep discount
function Stronghold.Hero:ApplyUpkeepDiscountPassiveAbility(_PlayerID, _Upkeep)
    local Upkeep = _Upkeep;
    -- do nothing
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

-- Passive Ability: Generating measure points
function Stronghold.Hero:ApplyMeasurePointsPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, "^PU_Hero1[abc]+$") then
        Value = Value * 1.5;
    end
    return Value;
end

-- -------------------------------------------------------------------------- --
-- UI

function Stronghold.Hero:OverrideGUI()
    UiHacker.CreateHack(
        "GUIUpdate_BuildingButtons",
        function(_Name, _WidgetID, _Button, _Technology)
            return Stronghold.Hero:LeaderFormationUpdate(_Button, _Technology);
        end
    );

    UiHacker.CreateHack(
        "GUITooltip_NormalButton",
        function(_Name, _WidgetID, _Key)
            return Stronghold.Hero:LeaderFormationTooltip(_Key);
        end
    );

    UiHacker.CreateHack(
        "GUIAction_ChangeFormation",
        function(_Name, _WidgetID, _Index)
            return Stronghold.Hero:LeaderChangeFormationAction(_Index);
        end
    );
end

