-- ###################################################################################################
-- #                                                                                                 #
-- #                                                                                                 #
-- #     Mapname:  Stronghold Testmap                                                                #
-- #                                                                                                 #
-- #     Author:   totalwarANGEL                                                                     #
-- #                                                                                                 #
-- #                                                                                                 #
-- ###################################################################################################

-- -------------------------------------------------------------------------- --

function OnMapStart()
    Player_Teams = {[1] = {1}, [2] = {2}};

    local Path = "maps/externalmap/script/";
    if false then
        Path = "E:/Siedler/Projekte/xmas2023/stronghold/script/";
    end
    Script.Load(Path.. "comforts.lua");
    Script.Load(Path.. "stronghold_main.lua");
    Script.Load(Path.. "stronghold_utils.lua");
    Script.Load(Path.. "stronghold_sync.lua");
    Script.Load(Path.. "stronghold_eco.lua");
    Script.Load(Path.. "stronghold_limitation.lua");
    Script.Load(Path.. "stronghold_building.lua");
    Script.Load(Path.. "stronghold_unit.lua");
    Script.Load(Path.. "stronghold_hero.lua");
    Script.Load(Path.. "stronghold_province.lua");
    Script.Load(Path.. "stronghold_ai_army.lua");
    Script.Load(Path.. "stronghold_ai_camp.lua");
    Script.Load(Path.. "stronghold_ai_player.lua");

    ---

    SetupStronghold();
    SetupHumanPlayer(1);
    SetupHumanPlayer(2);

    Tools.GiveResouces(1, 450, 2500, 2000, 850, 50, 50);
    Tools.GiveResouces(2, 450, 2500, 2000, 850, 50, 50);

    -- Cut off half of the map in Singleplayer
    if XNetwork.Manager_DoesExist() == 0 then
        Message("@color:255,0,0 SINGLEPLAYER MODUS");
        Message("Im Singleplayer sind Brücken und Wetteränderung gesperrt!");
        ForbidTechnology(Technologies.B_Bridge, 1);
        ForbidTechnology(Technologies.T_ChangeWeather, 1);
    end

    StockResourceEntities();
    CreatePilesOfWood();
end

-- Create wood piles
function CreatePilesOfWood()
    local WoodPiles = {Logic.GetEntities(Entities.XD_SingnalFireOff, 48)};
    for i= 2, WoodPiles[1] +1 do
        Logic.SetEntityName(WoodPiles[i], "WoodPile" ..i);
        CreateWoodPile("WoodPile" ..i, 25000);
    end
end

-- Fills resource heaps with additional units.
function StockResourceEntities()
    local ResourceHeapTypes = {
        Entities.XD_Clay1,
        Entities.XD_Iron1,
        Entities.XD_Stone1,
        Entities.XD_Sulfur1,
    }
    for _,Type in pairs(ResourceHeapTypes) do
        local Heaps = {Logic.GetEntities(Type, 48)};
        for i= 2, Heaps[1]+1, 1 do
            Logic.SetResourceDoodadGoodAmount(Heaps[i], 4000);
        end
    end
end

-- -------------------------------------------------------------------------- --

function GameCallback_OnGameStart()
	Script.Load(Folders.MapTools.."Ai\\Support.lua");
	Script.Load("Data\\Script\\MapTools\\MultiPlayer\\MultiplayerTools.lua");
	Script.Load("Data\\Script\\MapTools\\Tools.lua");
	Script.Load("Data\\Script\\MapTools\\WeatherSets.lua");
	IncludeGlobals("Comfort");

	MultiplayerTools.InitCameraPositionsForPlayers();
	MultiplayerTools.SetUpGameLogicOnMPGameConfig();
	MultiplayerTools.GiveBuyableHerosToHumanPlayer(0);

	if XNetwork.Manager_DoesExist() == 0 then
		for i=1,2,1 do
			MultiplayerTools.DeleteFastGameStuff(i);
		end
		local PlayerID = GUI.GetPlayerID();
		Logic.PlayerSetIsHumanFlag(PlayerID, 1);
		Logic.PlayerSetGameStateToPlaying(PlayerID);
	end

    AddPeriodicSummer(360);
    AddPeriodicRain(90);
    SetupNormalWeatherGfxSet();
    LocalMusic.UseSet = HIGHLANDMUSIC;

    OnMapStart();
end

