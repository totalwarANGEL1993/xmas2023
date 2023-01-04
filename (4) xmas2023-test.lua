-- ************************************************************************************************
-- *                                                                                              *
-- *                                                                                              *
-- *                                              EMS                                             *
-- *                                         CONFIGURATION                                        *
-- *                                                                                              *
-- *                                                                                              *
-- ************************************************************************************************

EMS_CustomMapConfig = {
    -- ********************************************************************************************
    -- * Configuration File Version
    -- * A version check will make sure every player has the same version of the configuration file
    -- ********************************************************************************************
    Version = 1,

    -- ********************************************************************************************
    -- * Callback_OnMapStart
    -- * Called directly after the loading screen vanishes and works as your entry point.
    -- * Similar use to FirstMapAction/GameCallback_OnGameSart
    -- ********************************************************************************************

    Callback_OnMapStart = function()
        Player_Teams = {[1] = {1, 2}, [2] = {3, 4}};

        local Path = "E:/Siedler/Projekte/xmas2023/script/";
        Script.Load(Path.. "comforts.lua");
        Script.Load(Path.. "stronghold_main.lua");
        Script.Load(Path.. "stronghold_utils.lua");
        Script.Load(Path.. "stronghold_eco.lua");
        Script.Load(Path.. "stronghold_limitation.lua");
        Script.Load(Path.. "stronghold_building.lua");
        Script.Load(Path.. "stronghold_unit.lua");
        Script.Load(Path.. "stronghold_hero.lua");
        Script.Load(Path.. "stronghold_ai.lua");

        AddPeriodicSummer(60);
        SetupNormalWeatherGfxSet();
        LocalMusic.UseSet = DARKMOORMUSIC;
    end,

    -- ********************************************************************************************
    -- * Callback_OnGameStart
    -- * Called at the end of the 10 seconds delay, after the host chose the rules and started
    -- ********************************************************************************************
    Callback_OnGameStart = function()
        Stronghold:Init();
        Stronghold:AddPlayer(1);
        Stronghold:AddPlayer(2);
        Stronghold:AddPlayer(3);
        Stronghold:AddPlayer(4);
    end,

    -- ********************************************************************************************
    -- * Callback_OnPeacetimeEnded
    -- * Called when the peacetime counter reaches zero
    -- ********************************************************************************************
    Callback_OnPeacetimeEnded = function()
        -- All players are enemies by default
        for i= 1, 4 do
            for j= 1, 4 do
                if i ~= j then
                    Logic.SetShareExplorationWithPlayerFlag(i, j, 0);
                    SetHostile(i, j);
                end
            end
        end
        -- If 2vs2 was selected then player 1 and 2 und player 3 and 4
        -- are teaming up
        if Game_Mode == "2vs2" then
            Logic.SetShareExplorationWithPlayerFlag(Player_Teams[1][1], Player_Teams[1][2], 1);
            SetFriendly(Player_Teams[1][1], Player_Teams[1][2]);
            Logic.SetShareExplorationWithPlayerFlag(Player_Teams[2][1], Player_Teams[2][2], 1);
            SetFriendly(Player_Teams[2][1], Player_Teams[2][2]);
        end
    end,

    -- ********************************************************************************************
    -- * Peacetime
    -- * Number of minutes the players will be unable to attack each other
    -- ********************************************************************************************
    Peacetime = 40,

    -- ********************************************************************************************
    -- * GameMode
    -- * GameMode is a concept of a switchable option, that the scripter can freely use
    -- *
    -- * GameModes is a table that contains the available options for the players, for example:
    -- * GameModes = {"3vs3", "2vs2", "1vs1"},
    -- *
    -- * GameMode contains the index of selected mode by default - ranging from 1 to X
    -- *
    -- * Callback_GameModeSelected
    -- * Lets the scripter make changes, according to the selected game mode.
    -- * You could give different ressources or change the map environment accordingly
    -- * _gamemode contains the index of the selected option according to the GameModes table
    -- ********************************************************************************************
    GameMode = 1,
    GameModes = {"2vs2", "kingsmaker"},
    Callback_GameModeSelected = function(_gamemode)
        Game_Mode = _gamemode;
        if _gamemode == "2vs2" then
            Player_Teams = {[1] = {1, 2}, [2] = {3, 4}};
        end
        if _gamemode == "kingsmaker" then
            Player_Teams = {[1] = {1}, [2] = {2}, [3] = {3}, [4] = {4}};
        end
    end,

    -- ********************************************************************************************
    -- * Resource Level
    -- * Determines how much ressources the players start with
    -- * 1 = Normal
    -- * 2 = FastGame
    -- * 3 = SpeedGame
    -- * See the ressources table below for configuration
    -- ********************************************************************************************
    ResourceLevel = 1,

    -- ********************************************************************************************
    -- * Resources
    -- * Order:
    -- * Gold, Clay, Wood, Stone, Iron, Sulfur
    -- * Rules:
    -- * 1. If no player is defined, default values are used
    -- * 2. If player 1 is defined, these ressources will be used for all other players too
    -- * 3. Use the players index to give ressources explicitly
    -- ********************************************************************************************    
    Ressources =
    {
        -- * Normal default: 1k, 1.8k, 1.5k, 0.8k, 50, 50
        Normal = {
            [1] = {
                1000,
                1800,
                1500,
                800,
                50,
                50,
            },
        },
        -- * FastGame default: 2 x Normal Ressources
        FastGame = {},

        -- * SpeedGame default: 20k, 12k, 14k, 10k, 7.5k, 7.5k
        SpeedGame = {},
    },

    -- ********************************************************************************************
    -- * Callback_OnFastGame
    -- * Called together with Callback_OnGameStart if the player selected ResourceLevel 2 or 3
    -- * (FastGame or SpeedGame)
    -- ********************************************************************************************
    Callback_OnFastGame = function()
    end,

    -- ********************************************************************************************
    -- * AI Players
    -- * Player Entities that belong to an ID that is also present in the AIPlayers table won't be
    -- * removed
    -- ********************************************************************************************
    AIPlayers = {
        5, 6, 7, 8
    },

    -- ********************************************************************************************
    -- * DisableInitCameraOnHeadquarter
    -- * Set to true if you don't want the camera to be set to the headquarter automatically
    -- * (default: false)
    -- ********************************************************************************************
    DisableInitCameraOnHeadquarter = false,

    -- ********************************************************************************************
    -- * DisableSetZoomFactor
    -- * If set to false, ZoomFactor will be set to 2 automatically
    -- * Set to true if nothing should be done
    -- * (default: false)
    -- ********************************************************************************************
    DisableSetZoomFactor = false,

    -- ********************************************************************************************
    -- * DisableStandardVictoryCondition
    -- * Set to true if you want to implement your own victory condition
    -- * Otherwise the player will lose upon losing his headquarter
    -- * (default: false)
    -- ********************************************************************************************
    DisableStandardVictoryCondition = true,

    -- * Buildings
    Bridge = 1,

    -- * Markets
    -- * -1 = Building markets is forbidden
    -- * 0 = Building markets is allowed
    -- * >0 = Markets are allowed and limited to the number given
    Markets = 3,

    -- * Trade Limit
    -- * 0 = no trade limit
    -- * greater zero = maximum amount that you can buy in one single trade
    TradeLimit = 3000,

    -- * TowerLevel
    -- * 0 = Towers forbidden
    -- * 1 = Watchtowers
    -- * 2 = Balistatowers
    -- * 3 = Cannontowers
    TowerLevel = 3, -- 0-3

    -- * TowerLimit
    -- * 0  = no tower limit
    -- * >0 = towers are limited to the number given
    TowerLimit = 0,

    -- * WeatherChangeLockTimer
    -- * Minutes for how long the weather can't be changed directly again after a weatherchange happened
    WeatherChangeLockTimer =  3,

    MakeSummer = 1,
    MakeRain   = 1,
    MakeSnow   = 1,

    -- * Fixes the DestrBuild bug
    AntiBug    = 1,

    -- * BlessLimit
    BlessLimit = 2,

    -- ********************************************************************************************
    -- 
    -- HAS NO EFFECT IN THIS MAP!
    -- 
    -- ********************************************************************************************

    HQRush     = 0,

    Heroes = {0,0,0,0},

    Dario              = 1,
    Pilgrim            = 1,
    Ari                = 1,
    Erec               = 1,
    Salim              = 1,
    Helias             = 1,
    Drake              = 1,
    Yuki               = 1,
    Kerberos           = 1,
    Varg               = 1,
    Mary_de_Mortfichet = 1,
    Kala               = 1,

    Sword        = 4,
    Bow          = 4,
    PoleArm      = 4,
    HeavyCavalry = 2,
    LightCavalry = 2,
    Rifle        = 2,
    Thief        = 1,
    Scout        = 1,
    Cannon1      = 1,
    Cannon2      = 1,
    Cannon3      = 1,
    Cannon4      = 1,
};

-- -------------------------------------------------------------------------- --

