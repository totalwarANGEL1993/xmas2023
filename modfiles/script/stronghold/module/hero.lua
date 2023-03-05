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

        Text = {

        },

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
            Player = {
                [1] = {
                    de = "%s %s{grey}wurde als Laird gewählt!",
                    en = "%s %s{grey}was choosen as Laird!",
                },
                [2] = {
                    de = "%s %s{white}muss sich in die Burg zurückziehen!",
                    en = "%s %s{white}has to retreat to the castle!",
                },
            },
            Promotion = {
                [1] = {
                    de = "@color:180,180,180 %s @color:255,255,255 @cr Last Euch in einen höheren "..
                         "Rang erheben. @cr @color:244,184,0 benötigt: @color:255,255,255 %s",
                    en = "@color:180,180,180 %s @color:255,255,255 @cr Take on a new title so you "..
                         "can train better troops. @cr Requirements: %s",
                },
                [2] = {
                    de = "@color:180,180,180 Höchster Rang @cr @color:255,255,255 Ihr habt den "..
                         "höchsten Titel erreicht.",
                    en = "@color:180,180,180 Highest Rank @cr @color:255,255,255 You reached the "..
                         "highest possible title.",
                },
            },
            HeroSkill = {
                [Entities.PU_Hero5]              = {
                    de = "{grey}Pfeilhagel{cr}{white}Ari lässt einen Köcher voll Pfeile auf die Gegner herabregnen.",
                    en = "{grey}Pfeilhagel{cr}{white}Ari launches a quiver full of arrows on enemy troops.",
                },
            },
            HeroCV = {
                [Entities.PU_Hero1c]             = {
                    de = "DARIO, der könig @cr @cr @color:180,180,180 "..
                         "Trotz seiner jungen Jahre obliegen die Geschicke des Reiches ihm. "..
                         "Früher wurde er oft dabei gesehen, wie er rosa Kleidchen trug. Die "..
                         "tauschte er inzwischen gegen ein Schwert ein. Dennoch fragen sich "..
                         "viele, ob er einen Vogel hat. "..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Als König hat Dario die Autorität, schneller Maßnahmen zu "..
                         "ergreifen. Eure Maßnahmen sind 50% schneller wieder einsetzbar. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Feindliche Einheiten können verjagt werden (außer Nebelvolk).",
                    en = "DARIO, the king @cr @cr @color:180,180,180 "..
                         "Despite his young age Dario has a lot of responsibility on his "..
                         "shoulders. He is often seen wearing pink dresses. Sometimes he "..
                         "exchanges them for armor and sword. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "As king Dario has the autority to faster take measures when needed. "..
                         "Your measures are 50% faster usable. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can inflict fear to enemies (except the Shrouded).",
                },
                [Entities.PU_Hero2]              = {
                    de = "PILGRIM, der geologe @cr @cr @color:180,180,180 "..
                         "Pilgrim entstammt einer langen Linie von Bergmännern. Ein glückliches " ..
                         "Schicksal verhalf ihm zu Geld und Würden. Dem Alkohol ist er stets "..
                         "zugetan. Es fällt ihm oft schwer, seine Fahne vom Geruch des " ..
                         "Sprengstoffs zu unterscheiden. "..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Jedes mal wenn in einer Mine Rohstoffe abbaut werden, werden "..
                         " zusätzliche veredelbare Rohstoffe erzeugt. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Legt eine Bombe, die Feinde schädigt und Schächte freisprengt.",
                    en = "PILGRIM, the geologist @cr @cr @color:180,180,180 "..
                         "Pilgrim descended from a long line of miners. Serendipity helped "..
                         "him to money and dignity. He is always fond of alcohol. He often "..
                         "has trouble distinguishing the smell of the explosives from the "..
                         "alcohol. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Every time when resources are gathered by miners an aditional "..
                         "resource is earned. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can place a bomb that damages foes and blast open resources.",
                },
                [Entities.PU_Hero3]              = {
                    de = "SALIM, der gelehrte @cr @cr @color:180,180,180 "..
                         "Ein Schriftgelehrter aus dem nahen Osten. Manche sagen ihm nach, er " ..
                         "sei verrückt geworden und versuche in seinem Labor ein schwarzes Loch "..
                         "zu erschaffen und so die Vergangenheit zu verändern. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255"..
                         "@cr Wissen ist Macht! Wenn eine Technologie erforscht wird, "..
                         "erhält Salim 5 Ehre. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255"..
                         "@cr Kann eine Falle verstecken, die explodiert, sobald der Feind "..
                         "unvorsichtig an sie heran tritt.",
                    en = "SALIM, the scholar @cr @cr @color:180,180,180 "..
                         "A scholar from the east who decided to bring knowledge to the west. "..
                         "Some say he is crazy and tries to create a black hole inside his "..
                         "laboratory to alter time. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Knowledge is power! Everytime a technology is researched Salim "..
                         "receives 5 honor. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can hide a trap that explodes when reckless enemies come to close.",
                },
                [Entities.PU_Hero4]              = {
                    de = "EREC, der ritter "..
                         "@cr @cr @color:180,180,180 "..
                         "Er ist ein echter Ritter. Von Kopf bis Fuß gehüllt in glänzender Rüstung "..
                         "zieht er aus, seinen Ruhm zu mehren und Jungfrauen in Nöten beizustehen. " ..
                         "Seine Anwesenheit inspiriert die Truppen zu Höchsleistungen. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 "..
                         "@cr Soldaten werden mit der maximalen Erfahrung rekrutiert, "..
                         "dadurch steigen allerdings ihre Kosten um 30%. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 "..
                         "@cr Ein Rundumschlag verletzt alle nahestehenden Feinde.",
                    en = "EREC, the knight "..
                         "@cr @cr @color:180,180,180 "..
                         "He is a true knight. From head to toe clad in shining armor he strifes "..
                         "to gather fame and safe damsels in distress. His presence inspires all "..
                         "soldiers under his command. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Soldiers will be recruited with full experience. But their costs "..
                         "are increased by 30%. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can inflict high damage in a small area.",
                },
                [Entities.PU_Hero5]              = {
                    de = "ARI, die vogelfreie "..
                         "@cr @cr @color:180,180,180 "..
                         "Als Kind wurde Ari von Gesetzlosen adoptiert und wuchs nicht nur zu " ..
                         "einer atemberaubenden Lady heran. Aber dies ist mit Nichten ihre einzige " ..
                         "Qualität, was sie jeden spüren lässt, der sich erdreistet, ihre Augen " ..
                         "eine Etage tiefer zu suchen. "..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Als Banditenfürstin kennt sie alle Tricks, um an Gold zu "..
                         "kommen. Die Steuereinnahmen werden um 30% erhöht. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Kann einen Pfeilhagel auf Feinde hernieder gehen lassen.",
                    en = "ARI, the vagabund "..
                         "@cr @cr @color:180,180,180 "..
                         "As a little girl she was adopted by the outlaws. Since then she grew to "..
                         "be a breathtaking lady. Beauty is not her only quality. Anyone who dares "..
                         "to search her eyes one story to deep will regret it. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Her upbringing taught her where to search for money. The tax income is "..
                         "increased by 30%. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can unleash a hail of arrows on enemies.",
                },
                [Entities.PU_Hero6]              = {
                    de = "HELIAS, der priester "..
                         "@cr @cr @color:180,180,180 " ..
                         "Einst vorgesehen für die Thronfolge des Alten Reiches, war der Ruf des " ..
                         "Herrn stärker. Wenn er nicht gerade Wasser predigt und Wein trinkt, "..
                         "erfreut er sich an den lieblichen Klängen der Chorknaben. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Helias nimmt Euren Arbeitern die Beichte ab. Dadurch werden sie seltener "..
                         "das Gesetz brechen. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Helias kann die Rüstung von verbündeten Einheiten verbessern.",
                    en = "HELIAS, the priest "..
                         "@cr @cr @color:180,180,180 "..
                         "Once designated as the heir of the Old Reich the calling from god was "..
                         "stronger. When he is not preaching water and drinking wine he enjoys "..
                         "the lovely sounds of the choirboys. "..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Helias hears the confessions of your workers. This will make them less "..
                         "likely to break the law. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can bless the armor of allied troops.",
                },
                [Entities.CU_Mary_de_Mortfichet] = {
                    de = "MARY, die schlange "..
                         "@cr @cr @color:180,180,180 "..
                         "Die Countess de Mortfichet ist verrufen als ruchloses und ehrloses " ..
                         "Miststück. Zeigt ihr Gegenüber eine Schwäche, so wird sie nicht zögern, " ..
                         "sie auszunutzen. Ihr Motto: Ein gut platzierter Dolch erreicht mehr "..
                         "als 1000 Schwerter. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Diebe und Kundschafter verlangen keinen Sold. Diebe belegen weniger "..
                         "Bevölkerungsplatz. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Kann die Angriffskraft von nahestehenden Feinden senken.",
                    en = "MARY, the snake "..
                         "@cr @cr @color:180,180,180 "..
                         "The Countess the Mortfichet is infamous as beeing a nefarious and "..
                         "dishonorable bitch. If her opponent has any weaknesses she will expoit "..
                         "them without regrets. A good placed dagger is better than 1000 swords. "..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Scouts and thieves do not cost any upkeep. Thieves occupy less "..
                         "population places. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can damage moral to lower enemies strength.",
                },
                [Entities.CU_BlackKnight]        = {
                    de = "KERBEROS, der schrecken "..
                         "@cr @cr @color:180,180,180 "..
                         "Als sein Vater den Thron aufgab um Pfaffe zu werden, brach für " ..
                         "Kerberos eine Welt zusammen. Seinem Erbe beraubt, verfiel er der " ..
                         "Finsternis. Als Scherge eines bösen Königs wartet er auf seine "..
                         "Chance. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Alle Negative Effekte auf die Beliebtheit verringern sich "..
                         "um 30%. Die maximale Beliebtheit sinkt auf 175. " ..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Kann die Rüstung von nahestehenden Feinden halbieren.",
                    en = "KERBEROS, the dread "..
                         "@cr @cr @color:180,180,180 "..
                         "After his father gave up the throne to become a priest the world "..
                         "came crashing down for Kerberos. Deprived of his inheritance he "..
                         "embraced the darkness. As minion of a evil king he awaits his "..
                         "chance. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "All negative effects on the reputation are decreased by 30%. The "..
                         "reputation maximum becomes 175. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can halve the armor of enemies.",
                },
                [Entities.CU_Barbarian_Hero]     = {
                    de = "VARG, das wolfsblut "..
                         "@cr @cr @color:180,180,180 "..
                         "Als Baby wurde Varg von einer Alphawölfin gesäugt. Als zwölfjähriger "..
                         "Junge besiegte er einen Eisbären im Zweikampf und wurde daraufhin zum " ..
                         "Anführer aller Barbaren gekrönt."..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Einen Sieg muss man zu feiern wissen! Die Effektivität "..
                         "von Tavernen wird um 50% verstärkt. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Ruft Wölfe, die Ehre erzeugen, wenn sie Feinde töten. Ihre "..
                         "Stärke richtet sich nach dem Rang.",
                    en = "VARG, the beastblood "..
                         "@cr @cr @color:180,180,180 "..
                         "After he was suckled by a alpha wolf instead of a woman he grew to a "..
                         "strong boy who defeated a icebear after his twelth birthday. He was "..
                         "soon chosen as the sole leader of the Barbarians. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Barbarians know how to celebrate a victory. The efficiency of all "..
                         "taverns are increased by 50%. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Summons wolves. They produce honor when they kill an enemy. Their "..
                         "depends on Vargs rank.",
                },
                [Entities.PU_Hero10]             = {
                    de = "DRAKE, der schakal "..
                         "@cr @cr @color:180,180,180 "..
                         "Wenn er nicht gerade auf Haselnüsse und Tannenzapfen schießt, jagt " ..
                         "Drake als \"Der Schakal\" alle die behaupten, er wolle nur etwas "..
                         "kompensieren. Seine Mutter meint noch heute, er solle das Gewehr "..
                         "zuhause lassen. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Durch effizientere Trainingsmethoden sinken die Kosten "..
                         "für den Unterhalt aller Scharfschützen um 50%. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Kann den Schaden von verbündeten Fernkämpfern verbessern. ",
                    en = "DRAKE, the jackal "..
                         "@cr @cr @color:180,180,180 "..
                         "When he is not shooting at hazlenuts and pinecones he hunts down "..
                         "anyone as \"the jackal\" who dare to say he is compensating for "..
                         "something. His mother says to this day that he should leave his "..
                         "gun at home. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Through the efficient methods the costs of training riflemen "..
                         "are lowered by 50%. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can increase the damage of allied ranged troops.",
                },
                [Entities.PU_Hero11]             = {
                    de = "YUKI, die faust "..
                         "@cr @cr @color:180,180,180 "..
                         "Schon als kleines Mädchen beschäftigte sich Yuki mit Pyrotechnik. " ..
                         "Zusammen mit den drei Chinesen und deren Kontrabass verschlug es " ..
                         "sie in den Westen, wo sie Reichtum erlangte und nun eine Burg ihr "..
                         "Eigen nennt. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Yuki erhöht die maximale Beliebtheit auf 300. Außerdem "..
                         "wird die Beliebtheit einmalig um 50 erhöht, sobald sie erscheint. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Kann befreundete Arbeiter mit Feuerwerk motivieren.",
                    en = "YUKI, the fist "..
                         "@cr @cr @color:180,180,180 "..
                         "She was engaged in pyrotechnics since early childhood. Together "..
                         "with the 3 Chinese and their double bass she ended up in the west "..
                         "searching for wealth. Now she claimed a castle. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "Yuki raises the reputation maximum to 300. The current reputation "..
                         "is increased by 50 only once after she appears."..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can motivate workers with her pyrotechnics.",
                },
                [Entities.CU_Evil_Queen]         = {
                    de = "KALA, die hexe "..
                         "@cr @cr @color:180,180,180 "..
                         "Um ihre Herkunft ranken sich Mysterien und düstere Legenden. Vom "..
                         "Nebelvolk wird Kala wie eine Göttin verehrt. Böse Zungen behaupten, " ..
                         "sie hätte jeden Einzelnen ihrer Untertanen selbst zur Welt gebracht. " ..
                         "@cr @cr @color:255,255,255 " ..
                         "@color:55,145,155 Passive Fähigkeit: @color:255,255,255 @cr "..
                         "Die gesteigerte Geburtenrate sorgt für einen demographischen "..
                         "Wandel. Euer Bevölkerungslimit wird um 35% erhöht. "..
                         "@cr @cr "..
                         "@color:55,145,155 Aktive Fähigkeit: @color:255,255,255 @cr "..
                         "Kann nahestehende Feinde mit Gift schädigen.",
                    en = "KALA, the witch "..
                         "@cr @cr @color:180,180,180 "..
                         "Many rumors clowding the trugh about her origin. The shrouded praise "..
                         "her like a godess. Envy tongues claim that she had birthed the entirty "..
                         "of the shrouded pepole herself. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Passive Ability: @color:255,255,255 @cr "..
                         "The increased birth rate is causing demographic change. Your attraction "..
                         "limit is increased by 35%. "..
                         "@cr @cr @color:255,255,255 "..
                         "@color:55,145,155 Active Ability: @color:255,255,255 @cr "..
                         "Can inflict poison damage to enemies.",
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
    self:OverrideHero5AbilityArrowRain();
    self:StartTriggers();
    self:OverrideGUI();
    -- DEPRECATED
    -- self:OverrideHero5AbilitySummon();
end

function Stronghold.Hero:OnSaveGameLoaded()
    for i= 1, table.getn(Score.Player) do
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
                Stronghold.Hero:OnlineHelpUpdate("OnlineHelpButton", Technologies.T_OnlineHelp);
            end
            if _Action == Stronghold.Hero.SyncEvents.Hero5Summon then
                Stronghold.Hero:OnHero5SummonSelected(_PlayerID, arg[1], arg[2], arg[3]);
            end
        end
    );
end

-- -------------------------------------------------------------------------- --
-- Rank Up

function Stronghold.Hero:OnlineHelpAction()
    local PlayerID = GUI.GetPlayerID();
    if not Stronghold:IsPlayer(PlayerID) then
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
            Stronghold.Hero.SyncEvents.RankUp
        );
    end
    return true;
end

function Stronghold.Hero:OnlineHelpTooltip(_Key)
    if _Key == "MenuMap/OnlineHelp" then
        local Language = GetLanguage();
        local CostText = "";
        local Text = "";

        local PlayerID = Stronghold:GetLocalPlayerID();
        local NextRank = Stronghold:GetPlayerRank(PlayerID) +1;
        if PlayerID ~= 17 and Stronghold.Config.Ranks[NextRank] and NextRank <= Stronghold.Config.Rule.MaxRank then
            local Config = Stronghold.Config.Ranks[NextRank];
            local Costs = Stronghold:CreateCostTable(unpack(Config.Costs));
            Text = string.format(
                Stronghold.Hero.Config.UI.Promotion[1][Language],
                Stronghold:GetPlayerRankName(PlayerID, NextRank),
                (Config.Description and Config.Description[Language]) or ""
            );
            CostText = Stronghold:FormatCostString(PlayerID, Costs);
        else
            Text = Stronghold.Hero.Config.UI.Promotion[2][Language];
        end

        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, CostText);
        XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, "");
        return true;
    end
    return false;
end

function Stronghold.Hero:OnlineHelpUpdate(_PlayerID, _Button, _Technology)
    if _Button == "OnlineHelpButton" then
        local Texture = "graphics/textures/gui/b_rank_f2.png";
        local Disabled = 1;
        if GUI.GetPlayerID() == _PlayerID and Stronghold:IsPlayer(_PlayerID) then
            local Rank = Stronghold:GetPlayerRank(_PlayerID);
            Texture = "graphics/textures/gui/b_rank_" ..Rank.. ".png";
            if Stronghold:CanPlayerBePromoted(_PlayerID) then
                Disabled = 0;
            end
        end
        for i= 0, 6 do
            XGUIEng.SetMaterialTexture(_Button, i, Texture);
        end
        XGUIEng.DisableButton(_Button, Disabled);
        return true;
    end
    return false;
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
    XGUIEng.ShowWidget("Formation01", 0);
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
        XGUIEng.SetWidgetPosition("Hero5_RechargeArrowRain", 4, 38);
        XGUIEng.SetWidgetPosition("Hero5_ArrowRain", 4, 38);
        XGUIEng.ShowWidget("Hero5_RechargeCamouflage", 0);
        XGUIEng.ShowWidget("Hero5_Camouflage", 0);
        XGUIEng.ShowWidget("Hero5_RechargeSummon", 0);
        XGUIEng.ShowWidget("Hero5_Summon", 0);
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

function Stronghold.Hero:PrintSelectionName()
    local EntityID = GUI.GetSelectedEntity();
    local PlayerID = Logic.EntityGetPlayer(EntityID);
    if Stronghold:IsPlayer(PlayerID) then
		if EntityID == GetID(Stronghold.Players[PlayerID].LordScriptName) then
            local Type = Logic.GetEntityType(EntityID);
            local TypeName = Logic.GetEntityTypeName(Type);
            local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
            local Rank = GetPlayerRank(PlayerID);
            local Language = GetLanguage();
            local Gender = Stronghold:GetLairdGender(Type);
            local Text = Stronghold:GetPlayerRankName(PlayerID, Rank);
            XGUIEng.SetText("Selection_Name", Text.. " " ..Name);
		end
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
            local Language = GetLanguage();
            return Stronghold.Hero.Config.UI.HeroCV[_Type][Language];
        end
        return Stronghold.Hero.Orig_GameCallback_GUI_BuyHero_GetMessage(_PlayerID, _Type);
    end
end

function Stronghold.Hero:BuyHeroCreateLord(_PlayerID, _ID, _Type)
    if Stronghold:IsPlayer(_PlayerID) then
        Logic.SetEntityName(_ID, Stronghold.Players[_PlayerID].LordScriptName);

        local Language = GetLanguage();
        local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
        local TypeName = Logic.GetEntityTypeName(_Type);
        local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
        Message(string.format(self.Config.UI.Player[1][Language], PlayerColor, Name));

        if _Type == Entities.PU_Hero11 then
            Stronghold:AddPlayerReputation(_PlayerID, 50);
            Stronghold:UpdateMotivationOfWorkers(_PlayerID);
        end
        if _PlayerID == GUI.GetPlayerID() or GUI.GetPlayerID() == 17 then
            Stronghold.Building:OnHeadquarterSelected(GUI.GetSelectedEntity());
        end
    end
end

-- The wolves of Varg becoming stronger when he gets higher titles.
function Stronghold.Hero:ConfigurePlayersHeroPet(_EntityID)
    local PlayerID = Logic.EntityGetPlayer(_EntityID);
    local Type = Logic.GetEntityType(_EntityID);
    if Type == Entities.CU_Barbarian_Hero_wolf then
        if self:HasValidHeroOfType(PlayerID, Entities.CU_Barbarian_Hero) then
            local CurrentRank = Stronghold:GetPlayerRank(PlayerID);
            local Armor = 1 + math.floor(CurrentRank * 1.0);
            local Damage = 30 + math.floor(CurrentRank * 5);
            Logic.SetSpeedFactor(_EntityID, 1.1 + ((CurrentRank -1) * 0.04));
            SVLib.SetEntitySize(_EntityID, 1.1 + ((CurrentRank -1) * 0.04));
            CEntity.SetArmor(_EntityID, Armor);
            CEntity.SetDamage(_EntityID, Damage);
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
    local Language = GetLanguage();
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
                    Stronghold.Economy:AddOneTimeHonor(WolfPlayerID, 1);
                end
            end

            -- Teleport to HQ
            if Logic.IsHero(k) == 1 then
                if Logic.GetEntityHealth(k) == 0 then
                    Stronghold.Players[_PlayerID].AttackMemory[k] = nil;
                    local PlayerColor = "@color:"..table.concat({GUI.GetPlayerColor(_PlayerID)}, ",");
                    local x,y,z = Logic.EntityGetPos(k);

                    -- Send message
                    local TypeName = Logic.GetEntityTypeName(Logic.GetEntityType(k));
                    local Name = XGUIEng.GetStringTableText("Names/" ..TypeName);
                    Message(string.format(self.Config.UI.Player[2][Language], PlayerColor, Name));
                    -- Place hero
                    Logic.CreateEffect(GGL_Effects.FXDieHero, x, y, _PlayerID);
                    local ID = SetPosition(k, Stronghold.Players[_PlayerID].DoorPos);
                    Logic.HurtEntity(ID, Logic.GetEntityHealth(ID));
                end
            end

            if not IsExisting(k) then
                Stronghold.Players[_PlayerID].AttackMemory[k] = nil;
            end
        end
    end
end

function Stronghold.Hero:StartTriggers()
    Job.Turn(function()
        for i= 1, table.getn(Score.Player) do
            Stronghold.Hero:EntityAttackedController(i);
        end
    end);

    Job.Create(function()
        local EntityID = Event.GetEntityID();
        local PlayerID = Logic.EntityGetPlayer(EntityID);
        if Logic.IsSettler(EntityID) == 1 and GUI.GetPlayerID() == PlayerID then
            Stronghold.Hero:ConfigurePlayersHeroPet(EntityID);
        end
    end);
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

-- DEPRECATED!
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
            Stronghold.Hero.SyncEvents.Hero5Summon,
            EntityID,
            x,y
        );
    end
end

function Stronghold.Hero:OverrideHero5AbilityArrowRain()
    function GUIAction_Hero5ArrowRain()
        GUI.ActivateShurikenCommandState();
	    GUI.State_SetExclusiveMessageRecipient(HeroSelection_GetCurrentSelectedHeroID());
    end
    Overwrite.CreateOverwrite("GUITooltip_NormalButton", function(_TextKey, _ShortCut)
        Overwrite.CallOriginal();
        if _TextKey == "AOMenuHero5/command_poisonarrows" then
            local Language = GetLanguage();
            local Text = Stronghold.Hero.Config.UI.HeroSkill[Entities.PU_Hero5][Language];
            ShortCutToolTip = XGUIEng.GetStringTableText("MenuGeneric/Key_name")..
                ": [" .. XGUIEng.GetStringTableText(_ShortCut) .. "]";

            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Placeholder.Replace(Text));
            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomCosts, "");
            XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomShortCut, ShortCutToolTip);
        end
    end);
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

    self.Orig_GameCallback_Calculate_CrimeRate = GameCallback_Calculate_CrimeRate;
    GameCallback_Calculate_CrimeRate = function(_PlayerID, _Rate)
        local CrimeRate = Stronghold.Hero.Orig_GameCallback_Calculate_CrimeRate(_PlayerID, _Rate);
        CrimeRate = Stronghold.Hero:ApplyCrimeRatePassiveAbility(_PlayerID, CrimeRate);
        return CrimeRate;
    end

    self.Orig_GameCallback_Calculate_CrimeChance = GameCallback_Calculate_CrimeChance;
    GameCallback_Calculate_CrimeChance = function(_PlayerID, _CrimeChance)
        local CrimeChance = Stronghold.Hero.Orig_GameCallback_Calculate_CrimeChance(_PlayerID, _CrimeChance);
        CrimeChance = Stronghold.Hero:ApplyCrimeChancePassiveAbility(_PlayerID, CrimeChance);
        return CrimeChance;
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
        Stronghold.Economy:AddOneTimeHonor(_PlayerID, 5);
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
                Logic.AddToPlayersGlobalResource(_PlayerID, _Type, math.max(_Amount-4, 1));
            end
        end
    end
end

-- Passive Ability: unit costs
function Stronghold.Hero:ApplyUnitCostPassiveAbility(_PlayerID, _Costs)
    local Costs = _Costs;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero4) then
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
        Value = Value * 1.35;
    end
    return Value;
end

-- Passive Ability: decrease of used civil attraction
function Stronghold.Hero:ApplyAttractionPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if Stronghold.Hero:HasValidHeroOfType(_PlayerID, Entities.CU_Mary_de_Mortfichet) then
        local ThiefCount = Logic.GetNumberOfEntitiesOfTypeOfPlayer(_PlayerID, Entities.PU_Thief);
        Value = Value - (ThiefCount * 3);
    end
    return Value;
end

-- Passive Ability: Increase of reputation
function Stronghold.Hero:ApplyMaxReputationPassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.CU_BlackKnight) then
        Value = 175;
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
        Decrease = Decrease * 0.7;
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
        Income = Income * 1.3;
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

-- Passive Ability: Change factor of becoming a criminal
function Stronghold.Hero:ApplyCrimeRatePassiveAbility(_PlayerID, _Value)
    local Value = _Value;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero6) then
        Value = Value * 1.75;
    end
    return Value;
end

-- Passive Ability: Chance the chance of becoming a criminal
function Stronghold.Hero:ApplyCrimeChancePassiveAbility(_PlayerID, _Chance)
    local Value = _Chance;
    if self:HasValidHeroOfType(_PlayerID, Entities.PU_Hero6) then
        Value = Value * 0.75;
    end
    return Value;
end

-- -------------------------------------------------------------------------- --
-- UI

function Stronghold.Hero:OverrideGUI()
    Overwrite.CreateOverwrite("GUIAction_OnlineHelp", function()
        Stronghold.Hero:OnlineHelpAction();
    end);

    Overwrite.CreateOverwrite("GUITooltip_Generic", function(_Key)
        Overwrite.CallOriginal();
        Stronghold.Hero:OnlineHelpTooltip(_Key);
    end);

    Overwrite.CreateOverwrite("GUIUpdate_BuildingButtons", function(_Button, _Technology)
        Overwrite.CallOriginal();
        local PlayerID = GUI.GetPlayerID();
        return Stronghold.Hero:OnlineHelpUpdate(PlayerID, _Button, _Technology);
    end);
    Job.Second(function()
        local PlayerID = GUI.GetPlayerID();
        Stronghold.Hero:OnlineHelpUpdate(PlayerID, "OnlineHelpButton", Technologies.T_OnlineHelp);
    end);

    Overwrite.CreateOverwrite("GUIUpdate_SelectionName", function()
        Overwrite.CallOriginal();
        Stronghold.Hero:PrintSelectionName();
    end);
end

