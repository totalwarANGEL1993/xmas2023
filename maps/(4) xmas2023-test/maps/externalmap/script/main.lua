function StartTestStuff()
    Lib.Require("module/io/NonPlayerCharacter");
    Lib.Require("module/io/NonPlayerMerchant");
    Lib.Require("module/mp/Syncer");
    Lib.Require("module/cinematic/BriefingSystem");
    Lib.Require("module/lua/Overwrite");

    -- AiArmyController.Install();

    -- CreateBriefingNpc();
    -- CreateMerchantNpc();

    Overwrite.CreateOverwrite("Foo", function()
        Overwrite.CallOriginal();
        Message("Foo Overwrite 1");
    end);
    Overwrite.CreateOverwrite("Foo", function()
        Overwrite.CallOriginal();
        Bar()
        Message("Foo Overwrite 2");
    end);
    Overwrite.CreateOverwrite("Bar", function()
        Overwrite.CallOriginal();
        Message("Bar Overwrite 1");
    end);
end


-- [ 2023/01/28 17:41:20 ] ERROR: DEBUG ERROR!

-- Error: LUA_ERRRUN: [string "E:/Siedler/Projekte/xmas2023/Stronghold/scr..."]:365: bad argument #1 to `find' (string expected, got nil)
-- Additional info: Game turn 99 (0:09)

function Foo()
    Message("Foo Original");
end

function Bar()
    Message("Bar Original");
end

function CreateTestArmy()
    SetHostile(1, 5);
    local Position = GetPosition("OP2_DoorPos");
    TestArmyID = AiArmy.New(5, 10, Position, 3500);

    local TroopID = Tools.CreateGroup(5, Entities.PU_LeaderSword4, 8, Position.X, Position.Y, 0);
    AiArmy.AddTroop(TestArmyID, TroopID);
    local TroopID = Tools.CreateGroup(5, Entities.PU_LeaderBow4, 8, Position.X, Position.Y, 0);
    AiArmy.AddTroop(TestArmyID, TroopID);
    local TroopID = Tools.CreateGroup(5, Entities.PU_LeaderRifle2, 8, Position.X, Position.Y, 0);
    AiArmy.AddTroop(TestArmyID, TroopID);
    local TroopID = Tools.CreateGroup(5, Entities.PV_Cannon4, 4, Position.X, Position.Y, 0);
    AiArmy.AddTroop(TestArmyID, TroopID);
end

function ReinforceTestArmy()
    local Position = GetPosition("OP2_DoorPos");
    AiArmy.SpawnTroop(TestArmyID, Entities.PU_LeaderSword4, Position, 3);
    AiArmy.SpawnTroop(TestArmyID, Entities.PU_LeaderBow4, Position, 3);
    AiArmy.SpawnTroop(TestArmyID, Entities.PU_LeaderRifle2, Position, 3);
    AiArmy.SpawnTroop(TestArmyID, Entities.PV_Cannon4, Position, 3);
end

function AttackWithTestArmy()
    AiArmy.SetPosition(TestArmyID, Stronghold.Players[1].DoorPos);
end

function CreateMerchantNpc()
    Message("{scarlet}It{blue}just{yellow}work's{white}!")
    NonPlayerMerchant.Create {
        ScriptName  = "Wolf",
    };
    NonPlayerMerchant.AddResourceOffer("Wolf", ResourceType.Iron, 500, {Gold = 450}, 5, 60);
    NonPlayerMerchant.Activate("Wolf");
end

function CreateBriefingNpc()
    Message("NPC created")
    NonPlayerCharacter.Create {
        ScriptName  = "Wolf",
        Callback    = function()
            CreateStartBriefing(1, "Test1");
        end,
    };
    NonPlayerCharacter.Activate("Wolf");
end

function CreateStartBriefing(_PlayerID, _Name)
    local Briefing = {};
    local AP, ASP, AMC = BriefingSystem.AddPages(Briefing);

    ASP("LordP1", "Page 1", "Test page number 1.", true);
    AMC("Wolf", "Page 2", "Test page number 2.", true, nil, "Option1", "Option1", "Option2", "Option2");

    ASP("Option1", "LordP1", "Page 4", "Test page number 4.", true);
    ASP("LordP1", "Page 5", "{scarlet}Test page number 5.", true);
    AP();
    
    AP {
        Name    = "Option2",
        Title   = "Page 6",
        Text    = "Test page number 6.",
        Target  = "Wolf",
        MiniMap = true
    }
    AP {
        Title   = "Page 6",
        Text    = "Test page number 6.",
        Target  = "Wolf",
        MiniMap = false
    }
    AP {
        Title   = "Page 6",
        Text    = "Test page number 6.",
        Target  = "Wolf",
        MiniMap = true
    }

    BriefingSystem.Start(_PlayerID, _Name, Briefing);
end

function CreateStartBriefing2(_PlayerID, _Name)
    local Briefing = {};
    local AP, ASP, AMC = BriefingSystem.AddPages(Briefing);

    AP {
        Text         = "Test 123 Test 123 Test 123 Test 123 Test 123",
        Target       = "Wolf",
        DialogCamera = true,
    }

    AP {
        Target       = "Wolf",
        Duration     = 3,
        FadeOut      = 3,
        DialogCamera = true,
    }

    AP {
        Target       = "Wolf",
        Duration     = 0.1,
        FaderAlpha   = 1,
        DialogCamera = true,
    }

    AP {
        Target       = "Wolf",
        Duration     = 3,
        FadeIn       = 3,
        DialogCamera = true,
    }

    AP {
        Text         = "Test 456 Test 456 Test 456 Test 456 Test 456",
        Target       = "Wolf",
        DialogCamera = true,
    }

    BriefingSystem.Start(_PlayerID, _Name, Briefing);
end