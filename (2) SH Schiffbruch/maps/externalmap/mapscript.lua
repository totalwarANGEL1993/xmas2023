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

    local Path = "E:/Siedler/Projekte/xmas2023/script/";
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
    Script.Load(Path.. "stronghold_ai.lua");

    ---

    SetupStronghold();
    SetupHumanPlayer(1);
    SetupHumanPlayer(2);

    Tools.GiveResouces(1, 950, 2500, 1750, 950, 50, 50);
    Tools.GiveResouces(2, 950, 2500, 1750, 950, 50, 50);

    local WoodPiles = {Logic.GetEntities(Entities.XD_SingnalFireOff, 48)};
    for i= 2, WoodPiles[1] +1 do
        CreateWoodPile(WoodPiles[i], 25000);
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

