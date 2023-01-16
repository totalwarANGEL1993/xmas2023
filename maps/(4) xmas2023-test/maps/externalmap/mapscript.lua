-- ###################################################################################################
-- #                                                                                                 #
-- #                                                                                                 #
-- #     Mapname:  Stronghold Testmap                                                                #
-- #                                                                                                 #
-- #     Author:   totalwarANGEL                                                                     #
-- #                                                                                                 #
-- #                                                                                                 #
-- ###################################################################################################

-- initEMS = function()return false end;
-- Script.Load("maps\\user\\EMS\\load.lua");
-- if not initEMS() then
--         local errMsgs = 
--         {
--             ["de"] = "Achtung: Enhanced Multiplayer Script wurde nicht gefunden! @cr \195\156berpr\195\188fe ob alle Dateien am richtigen Ort sind!",
--             ["eng"] = "Attention: Enhanced Multiplayer Script could not be found! @cr Make sure you placed all the files in correct place!",
--         }
--         local lang = "de";
--         if XNetworkUbiCom then
--             lang = XNetworkUbiCom.Tool_GetCurrentLanguageShortName();
--             if lang ~= "eng" and lang ~= "de" then
--                 lang = "eng";
--             end
--         end
--         GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
--         GUI.AddStaticNote("@color:255,0,0 " .. errMsgs[lang]);
--         GUI.AddStaticNote("@color:255,0,0 ------------------------------------------------------------------------------------------------------------");
--         return;
-- end

-- -------------------------------------------------------------------------- --

function OnMapStart()
    Player_Teams = {[1] = {1, 2}, [2] = {3, 4}};

    local Path = "E:/Siedler/Projekte/xmas2023/dev/devload.lua";
    if false then
        Path = "maps/user/Stronghold/script/stronghold/loader.lua";
    end
    Script.Load(Path);

    if not DetectStronghold or DetectStronghold() == false then
        return;
    end

    ---

    SetupStronghold();
    SetupHumanPlayer(1);
    SetupHumanPlayer(2);
    SetupHumanPlayer(3);
    SetupHumanPlayer(4);

    for i= 1, 4 do
        Tools.GiveResouces(i, 999999, 999999, 999999, 999999, 999999, 999999);
        AddPlayerHonor(i, 1000);
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

    AddPeriodicSummer(60);
    Mission_InitWeatherGfxSets();
    LocalMusic.UseSet = DARKMOORMUSIC;

    OnMapStart();
end

function Mission_InitWeatherGfxSets()
    SetupNormalWeatherGfxSet();
end

