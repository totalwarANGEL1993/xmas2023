-- by Siedler Team
-- # # # # # # # # # # SCRIPT LOAD # # # # # # # # # # --

Script.Load( Folders.MapTools.."Main.lua" ); IncludeGlobals("MapEditorTools")

-- # # # # # # # # # # BEFOR MAP STARTS # # # # # # # # # # --

function RestoreBriefingWindow()
	ShowTheButton = 1
	BRIEFING_ZOOMDISTANCE = 3300
	BRIEFING_ZOOMANGLE = 36
	local size = {GUI.GetScreenSize()}
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar00"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"),1)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrame"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMapOverlay"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMiniMap"),0)
	XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicFrameBG"),0)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Container"),0,0,1400,1000)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),100,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button2"),550,800,425,33)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Text"),100,669,850,48)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Headline"),120,642,500,80)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("Cinematic_Text"),100,669,850,77)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar02"),0,1000,size[1],128)
	XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicBar01"),70,625,size[1],100)
end
--------------------------------------------
function InitDiplomacy()
	SetPlayerName(1,"Matthew Steele")
	SetPlayerName(2,"K\195\182nigstreue")
	SetPlayerName(3,"Deveraux \"Der Falke\"")
	SetPlayerName(4,"Barcley \"Der Hammer\"")
	SetPlayerName(5,"Edwin Blackfly")
	SetPlayerName(7,"Olaf Grimzahn")
	SetPlayerName(8,"Bauernvolk")
end
--------------------------------------------
function InitResources()
	--Tools.GiveResouces( 1, 900000, 90000, 90000, 90000, 90000, 90000 )
	Tools.GiveResouces( 1, 1000, 1000, 1500, 800, 800, 450 )
end
--------------------------------------------
function InitTechnologies()
	ResearchTechnology(Technologies.GT_Literacy,1)
	ResearchTechnology(Technologies.GT_Construction,1)
	ResearchTechnology( Technologies.T_BetterChassis, 1 )
	ForbidTechnology(Technologies.T_ChangeWeather,1)
	ForbidTechnology(Technologies.T_WeatherForecast,1)
end
--------------------------------------------
function SetupNormalWeatherGfxSet()
	Display.GfxSetSetSkyBox(1, 0, 0, "YSkyBox05")
	Display.GfxSetSetFogParams(1, 0, 1, 1, 152, 172, 182, 5000, 28000)
	Display.GfxSetSetLightParams(1, 0, 1, 40, -15, -90, 120, 110, 110, 205, 204, 180)
	Display.GfxSetSetRainEffectStatus(1, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(1, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(1, 0.0, 0.8, 0)
	Display.SetRenderSky(1)
	Display.SetRenderUseGfxSets(1)
end
function SetupCaveRPGGfxSet()
	Display.GfxSetSetSkyBox(1, 0, 0, "YSkyBox01")
	Display.GfxSetSetFogParams(1, 0.0, 1.0, 1, 0,0,0, 3000,6000)
	Display.GfxSetSetLightParams(1, 0.0, 0, 0, 0, 0, 170,170,170, 110,110,110)
	Display.GfxSetSetRainEffectStatus(1, 0.0, 1.0, 0)
    Display.GfxSetSetSnowStatus(1, 0, 1.0, 0)
    Display.GfxSetSetSnowEffectStatus(1, 0.0, 0.8, 0)
	Display.SetRenderSky(0)
	Display.SetRenderUseGfxSets(1)
end
--------------------------------------------
function InitWeatherGfxSets()
	SetupNormalWeatherGfxSet()
end
--------------------------------------------
function InitWeather()
	AddPeriodicSummer(10)
end
--------------------------------------------
function InitPlayerColorMapping()
	XGUIEng.SetText("TopTradeMenuTextButton", "@color:0,0,0,0 ___ @color:255,255,255 Tribute @cr "..
					" @color:180,180,180 Siedler_Team")
	XGUIEng.SetText("TopQuestMenuTextButton", "@color:0,0,0,0 ....... @color:255,255,255 Quests @cr "..
					" @color:0,255,255 Stronghold 2")
	XGUIEng.SetText("TopStatisticsMenuTextButton", "@color:0,0,0,0 ....... @color:255,255,255 Stat. @cr "..
					" Version 1.0")
	RestoreBriefingWindow()
	
	Display.SetPlayerColorMapping(1,2)
	Display.SetPlayerColorMapping(2,6)
	Display.SetPlayerColorMapping(3,4)
	Display.SetPlayerColorMapping(4,9)
	Display.SetPlayerColorMapping(5,3)
	Display.SetPlayerColorMapping(6,9)
	Display.SetPlayerColorMapping(7,5)
	Display.SetPlayerColorMapping(8,14)
end

-- # # # # # # # # # # FIRST MAP ACTION # # # # # # # # # # --

function FirstMapAction()
	Score.Player[0] = {}
	Score.Player[0]["buildings"] = 0
	Score.Player[0]["all"] = 0
	
	gvMission = {}
	gvMission.Player = (string.format(UserTool_GetPlayerName(1)))
	gvMission.GameTime = 1
	gvMission.Edwin = false
	gvMission.Olaf = false
	gvMission.EdwinOnOlav = false
	gvMission.ScholarFree = false
	gvMission.CanBuildBombs = false
	gvMission.InfoText3 = "Zeit zum Wiederbeleben"
	gvMission.Value3 = HEROCOOLDOWN
	
	Init_InfoLines()
	MyBriefingsExpansion()
	SetupProtectedEntities()
	DIALOG_DISTANCE()
	Init_Colors()
	Init_Objects()
	GameSpeed()
	
	Camera.ZoomSetFactorMax(1)
	math.randomseed(GUI.GetTimeMS())
	AI.Player_EnableAi( 2 )
	AI.Player_EnableAi( 3 )
	AI.Player_EnableAi( 4 )
	AI.Player_EnableAi( 5 )
	AI.Player_EnableAi( 7 )
	
	jKR_ActivateMessageExpansion()
	Vorspann()

	--Tools.ExploreArea( 1,-1,900 )
end

-- # # # # # # # # # # ONLINEHELP HACK # # # # # # # # # # --

function GameSpeed()
	XGUIEng.TransferMaterials("OnlineHelpButton", "Research_Gilds" )
	XGUIEng.TransferMaterials("StatisticsWindowTimeScaleButton", "OnlineHelpButton" )
	XGUIEng.SetWidgetPositionAndSize("OnlineHelpButton",200,2,35,35)
	GUIAction_OnlineHelp = function()
		if Game.GameTimeGetFactor() < 3 then
			Game.GameTimeSpeedUp()
			Game.GameTimeSpeedUp()
			gvMission.GameTime = Game.GameTimeGetFactor()
			GUI.ClearNotes()
		else
			Game.GameTimeReset()
			gvMission.GameTime = Game.GameTimeGetFactor()
			GUI.ClearNotes()
		end
	end
	GUITooltip_Generic_OrigGS = GUITooltip_Generic
	GUITooltip_Generic = function(a)
	local newString,numberOfChanges = string.gsub( a, "MenuMap/", "" )
	if newString == "OnlineHelp" then
		if numberOfChanges == 1 then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Spielgeschwindigkeit: "..Weiss.." "..gvMission.GameTime.." "))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		end
	else
		GUITooltip_Generic_OrigGS(a)
	end
	end
	Mission_OnSaveGameLoaded_OrigGS = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_OrigGS()
		Game.GameTimeSetFactor( gvMission.GameTime )
		GUI.ClearNotes()
		Message( "Spielstand geladen!" )
		XGUIEng.TransferMaterials("OnlineHelpButton", "Research_Gilds" )
		XGUIEng.TransferMaterials("StatisticsWindowTimeScaleButton", "OnlineHelpButton" )
		XGUIEng.SetWidgetPositionAndSize("OnlineHelpButton",200,2,35,35)
	end
end

-- # # # # # # # # # # COLORS # # # # # # # # # # --

function Init_Colors()
	DBlau	 = "@color:70,70,255" -- Legenden
	Blau	 = "@color:153,210,234" --hellblau
	Weiss	 = "@color:255,255,255" -- wei�
	Rot		 = "@color:255,32,32" -- rot
	Gelb  	 = "@color:244,184,0" -- gelb
	Gruen	 = "@color:173,255,47" --hellgruen
	Orange 	 = "@color:255,127,0" --orange
	Mint 	 = "@color:0,255,255" --Mint
	Grau	 = "@color:180,180,180" -- grau
	Trans	 = "@color:0,0,0,0" -- transparent
	
	SZ 		 = "@color:150,150,75 Auftrag @cr "..Weiss..""
	NZ 		 = "@color:150,150,75 Niederlage @cr "..Weiss..""
	
	tSim	 = ""..DBlau.." Tom Simpkins "..Weiss..""
	tErz	 = ""..DBlau.." Matthew Steele "..Weiss.." (Erz�hler)"
	tMat	 = ""..Orange.." Matthew Steele"
	tWil	 = ""..Orange.." Sir William"
	tSer	 = ""..Orange.." Lady Seren"
	tKing	 = ""..Orange.." Der K�nig"
	tBish	 = ""..Orange.." Der Bischof"
	tDev	 = ""..Orange.." Graf Deveraux "..Weiss.." \"Der Falke\""
	tBarc	 = ""..Orange.." Lord Barcley "..Weiss.." \"Der Hammer\""
	tEdw	 = ""..Orange.." Edwin Blackfly"
	tOlaf	 = ""..Orange.." Olaf Grimzahn"
	tThief	 = ""..Orange.." Lars Langfinger"
	tBot1	 = ""..Orange.." Bastian Flitzer"
	tBot2	 = ""..Orange.." Brian Brenner"
	tBish	 = ""..Orange.." Alexander Bell "..Weiss.." (Bischof)"
	tGut	 = ""..Orange.." Klaus von und zu Guttenplag"
	tVamp	 = ""..Orange.." Edward Cullen"
	tMac	 = ""..Orange.." Connor MacClaud"
	
	mMat	 = ""..Gelb.." Matthew Steele "..Weiss..""
	mSim	 = ""..Gelb.." Tom Simpkins "..Weiss..""
	mWil	 = ""..Gruen.." William "..Weiss..""
	mSer	 = ""..Gruen.." Lady Seren "..Weiss..""
	mKing	 = ""..Gruen.." K�nig "..Weiss..""
	mBish	 = ""..Gruen.." Bischof "..Weiss..""
	mDev1	 = ""..Gruen.." \"der Falke\" "..Weiss..""
	mDev2	 = ""..Gruen.." Deveraux "..Weiss..""
	mBarc1	 = ""..Gruen.." \"der Hammer\" "..Weiss..""
	mBarc2	 = ""..Gruen.." Barcley "..Weiss..""
	mBarc3	 = ""..Gruen.." dem Hammer "..Weiss..""
	mEdw	 = ""..Gruen.." Edwin Blackfly "..Weiss..""
	mEdt	 = ""..Gelb.." Sir Edwards des II. "..Weiss..""
	mOlaf	 = ""..Gruen.." Olaf Grimzahn "..Weiss..""
	mThief	 = ""..Gruen.." Lars Langfinger "..Weiss..""
	mVamp	 = ""..Orange.." Edward Cullen "..Weiss..""
end

-- # # # # # # # # # # OBJECTS # # # # # # # # # # --

function Init_Objects()
	-- Tore
	local pos = GetPosition( "Edoor1pos" )
	SetEntityName(Tools.CreateGroup(0, Entities.XD_WallStraightGate, 0, pos.X, pos.Y, 135.00 ),"Edoor1")
	local pos = GetPosition( "Edoor2pos" )
	SetEntityName(Tools.CreateGroup(0, Entities.XD_WallStraightGate, 0, pos.X, pos.Y, 135.00 ),"Edoor1")
	local pos = GetPosition( "Wdoor1pos" )
	SetEntityName(Tools.CreateGroup(0, Entities.XD_WallStraightGate, 0, pos.X, pos.Y, 315.00 ),"Wdoor1")
	local pos = GetPosition( "Kdoor1pos" )
	SetEntityName(Tools.CreateGroup(0, Entities.XD_WallStraightGate, 0, pos.X, pos.Y, 315.00 ),"Kdoor1")
	local pos = GetPosition( "Kdoor2pos" )
	SetEntityName(Tools.CreateGroup(0, Entities.XD_WallStraightGate, 0, pos.X, pos.Y, 45.00 ),"Kdoor2")
	local pos = GetPosition( "place_cata_gate6" )
	SetEntityName(Tools.CreateGroup(0, Entities.XD_WallStraightGate_Closed, 0, pos.X, pos.Y, 45.00 ),"cata_gate6")
	-- Soldaten
	local pos = GetPosition( "OT1" )
	SetEntityName(Tools.CreateGroup(7, Entities.CU_Barbarian_LeaderClub2, 4, pos.X, pos.Y, 222.00 ),"Fdef1")
	local pos = GetPosition( "OT2" )
	SetEntityName(Tools.CreateGroup(7, Entities.CU_Barbarian_LeaderClub2, 4, pos.X, pos.Y, 0.00 ),"Fdef1")
	local pos = GetPosition( "OT3" )
	SetEntityName(Tools.CreateGroup(7, Entities.CU_Barbarian_LeaderClub2, 4, pos.X, pos.Y, 135.00 ),"Fdef1")
	
	ReplaceEntity( "Bfarm1", Entities.PB_Farm3 );ReplaceEntity( "Bfarm2", Entities.PB_Farm3 );
	ReplaceEntity( "Bfarm3", Entities.PB_Farm3 );ReplaceEntity( "Bmarket1", Entities.PB_Market1 );
	ReplaceEntity( "Bhouse1", Entities.PB_Residence3 );ReplaceEntity( "Bhouse2", Entities.PB_Residence3 );
	ReplaceEntity( "Bhouse3", Entities.PB_Residence3 );ReplaceEntity( "Bsaw1", Entities.PB_Sawmill2 );
	ReplaceEntity( "Bsaw2", Entities.PB_Sawmill2 );ReplaceEntity( "Bsmith1", Entities.PB_Blacksmith3 );
	ReplaceEntity( "Bsmith2", Entities.PB_Blacksmith3 );ReplaceEntity( "Bsmith3", Entities.PB_Blacksmith3 );
	ReplaceEntity( "Bsmith4", Entities.PB_Blacksmith3 );ReplaceEntity( "Bkeep1", Entities.PB_Headquarters2 );
	ReplaceEntity( "Dbarracks1", Entities.PB_Barracks2 );
	ReplaceEntity( "Dfarm1", Entities.PB_Farm3 );ReplaceEntity( "Dfarm2", Entities.PB_Farm3 );
	ReplaceEntity( "Dfarm3", Entities.PB_Farm3 );ReplaceEntity( "Dsmith1", Entities.PB_Blacksmith3 );
	ReplaceEntity( "Dsmith2", Entities.PB_Blacksmith3 );ReplaceEntity( "DGsmith1", Entities.PB_GunsmithWorkshop1 );
	ReplaceEntity( "Dhouse1", Entities.PB_Residence3 );ReplaceEntity( "Dhouse2", Entities.PB_Residence3 );
	ReplaceEntity( "Dhouse3", Entities.PB_Residence3 );ReplaceEntity( "Dhouse4", Entities.PB_Residence3 );
	ReplaceEntity( "Dtavern", Entities.PB_Tavern2 );ReplaceEntity( "Dsaw1", Entities.PB_Sawmill2 );
	ReplaceEntity( "Ssmith1", Entities.PB_Blacksmith2 );ReplaceEntity( "Ssmith2", Entities.PB_Blacksmith2 )
	ReplaceEntity( "Stavern1", Entities.PB_Tavern2 );ReplaceEntity( "Shouse1", Entities.PB_Residence3 )
	ReplaceEntity( "Shouse2", Entities.PB_Residence3 );ReplaceEntity( "Pfarm1", Entities.PB_Farm2 )
	ReplaceEntity( "Phouse1", Entities.PB_Residence2 );ReplaceEntity( "Phouse2", Entities.PB_Residence2 );
	ReplaceEntity( "Phouse3", Entities.PB_Residence2 );ReplaceEntity( "Puni", Entities.PB_University1 );
	ReplaceEntity( "Esmith1", Entities.PB_Blacksmith1 )
	ReplaceEntity( "Esmith2", Entities.PB_Blacksmith1 );ReplaceEntity( "Esmith3", Entities.PB_Blacksmith1 )
	ReplaceEntity( "Esmith4", Entities.PB_Blacksmith1 );ReplaceEntity( "Efarm1", Entities.PB_Farm2 )
	ReplaceEntity( "Efarm2", Entities.PB_Farm3 );ReplaceEntity( "Emarket", Entities.PB_Market1 )
	ReplaceEntity( "Ehouse1", Entities.PB_Residence1 );ReplaceEntity( "Ehouse2", Entities.PB_Residence1 )
	ReplaceEntity( "Ehouse3", Entities.PB_Residence1 );ReplaceEntity( "Emason1", Entities.PB_StoneMason1 )
	ReplaceEntity( "HQEdwin", Entities.PB_Headquarters1 )
	ReplaceEntity( "Kkeep", Entities.PB_Headquarters1 ); ReplaceEntity( "Kbarracks1", Entities.PB_Barracks2 );
	ReplaceEntity( "Kuni", Entities.PB_University2 )
	ReplaceEntity( "Ksmith1", Entities.PB_Blacksmith3 );ReplaceEntity( "Ksmith2", Entities.PB_Blacksmith3 )
	ReplaceEntity( "Kbeauty1", Entities.PB_Beautification12 );ReplaceEntity( "Kfarm1", Entities.PB_Farm3 )
	ReplaceEntity( "Kfarm2", Entities.PB_Farm3 );ReplaceEntity( "Kfarm3", Entities.PB_Farm3 )
	ReplaceEntity( "Kfarm4", Entities.PB_Farm3 );ReplaceEntity( "Ksaw1", Entities.PB_Sawmill2 )
	ReplaceEntity( "Khouse1", Entities.PB_Residence3 );ReplaceEntity( "Khouse2", Entities.PB_Residence3 )
	ReplaceEntity( "Khouse3", Entities.PB_Residence3 );ReplaceEntity( "Khouse4", Entities.PB_Residence3 )
	ReplaceEntity( "Khouse5", Entities.PB_Residence3 );ReplaceEntity( "Khouse6", Entities.PB_Residence3 )
	ReplaceEntity( "Khouse7", Entities.PB_Residence3 );ReplaceEntity( "Khouse8", Entities.PB_Residence3 )
	ReplaceEntity( "Khouse9", Entities.PB_Residence3 )
	ReplaceEntity( "viking1", Entities.CB_Camp_19 );ReplaceEntity( "viking2", Entities.CB_Camp_17 )
	ReplaceEntity( "Walchemist", Entities.PB_Alchemist1 )
	ReplaceEntity( "Whouse1", Entities.PB_Residence3 );ReplaceEntity( "Whouse2", Entities.PB_Residence3 )
	ReplaceEntity( "Whouse3", Entities.PB_Residence3 );ReplaceEntity( "Wfarm1", Entities.PB_Farm3 )
	ReplaceEntity( "Wfarm2", Entities.PB_Farm1 );ReplaceEntity( "Wtavern1", Entities.PB_Tavern2 )
	ReplaceEntity( "Wbarrack1", Entities.PB_Barracks2 );ReplaceEntity( "Warchery1", Entities.PB_Archery1 )
	ReplaceEntity( "Wsmith1", Entities.PB_Blacksmith2 );ReplaceEntity( "Wsmith2", Entities.PB_Blacksmith2 )
	ReplaceEntity( "Wsmith3", Entities.PB_Blacksmith2 );ReplaceEntity( "Wsaw1", Entities.PB_Sawmill2 )
	-- Spieler 8
	ReplaceEntity( "appleh1", Entities.PB_Residence1 );ReplaceEntity( "appleh2", Entities.PB_Farm1 )
	ReplaceEntity( "fishing1", Entities.CB_MinerCamp4 );ReplaceEntity( "fishing2", Entities.CB_MinerCamp6 )
	ReplaceEntity( "cheese1", Entities.CB_MinerCamp1 );ReplaceEntity( "cheese2", Entities.CB_MinerCamp6 )
	ReplaceEntity( "hunterh1", Entities.CB_HermitHut1 );ReplaceEntity( "hunterh2", Entities.CB_MinerCamp6 )
	ReplaceEntity( "obst1", Entities.PB_Residence1 );ReplaceEntity( "obst2", Entities.PB_Farm3 )
	-- Sonstiges
	local pos = GetPosition("nameBridge1")
	SpacePos,NameBridge = Logic.GetEntitiesInArea(Entities.PB_DrawBridgeClosed1,pos.X,pos.Y,4000,1)
	SetEntityName(NameBridge,"bridge1")
	ReplaceEntity( "bridge1", Entities.XD_DrawBridgeOpen1 )
	local pos = GetPosition("nameBridge2")
	SpacePos,NameBridge = Logic.GetEntitiesInArea(Entities.PB_DrawBridgeClosed2,pos.X,pos.Y,4000,1)
	SetEntityName(NameBridge,"bridge2")
	ReplaceEntity( "bridge2", Entities.XD_DrawBridgeOpen2 )
	local pos = GetPosition("nameBridge3")
	SpacePos,NameBridge = Logic.GetEntitiesInArea(Entities.PB_Bridge1,pos.X,pos.Y,4000,1)
	SetEntityName(NameBridge,"bridge3"); MakeInvulnerable( "bridge3" )
	CreateWoodPile( "stapel1", 5000 ); CreateWoodPile( "stapel2", 5000 ); CreateWoodPile( "stapel3", 5000 )
	; CreateWoodPile( "stapel4", 5000 ); CreateWoodPile( "stapel5", 5000 ); CreateWoodPile( "stapel6", 5000 )
	Logic.SetModelAndAnimSet( GetEntityId("podium"),Models.Effects_XF_ExtractStone )
	Logic.SetModelAndAnimSet( GetEntityId("hering"),Models.Banners_XB_LargeOccupied )
	Logic.SetModelAndAnimSet( GetEntityId("cheesevil"),Models.Banners_XB_LargeOccupied )
	Logic.SetModelAndAnimSet( GetEntityId("cloisterf"),Models.Banners_XB_LargeOccupied )
	Logic.SetModelAndAnimSet( GetEntityId("obstf"),Models.Banners_XB_LargeOccupied )
	Logic.SetModelAndAnimSet( GetEntityId("applef"),Models.Banners_XB_LargeOccupied )
	Logic.SetModelAndAnimSet( GetEntityId("hunterf"),Models.Banners_XB_LargeOccupied )
	for i=1,2 do Logic.SetModelAndAnimSet( GetEntityId("Stower"..i),Models.ZB_ConstructionSiteTower1 )end
	SetHostile( 6, 8 ); MakeInvulnerable( "shootingsheep" ); for i=1,3 do Attack("hunter"..i,"shootingsheep")end
	for i=1,6 do Logic.SetTaskList( GetEntityId( "hacker"..i ), TaskLists.TL_SERF_EXTRACT_RESOURCE )end
	for i=1,11 do Logic.SetModelAndAnimSet( GetEntityId("T1_waterfall"..i),Models.XD_PlantDecalTideland5 )end
	ReplaceEntity( "blockstone1", Entities.XD_Rock6 )
	Init_Interactives()
end
function Init_Interactives()
	
	local IO = {
		Name = "ruine1",Type = 1,Range = 800,Rewards = { 0, 0, 0, 500, 500, 0 },
		Callback = function()
		end,
	}
	Interactive_Setup( IO )
	
	local IO = {
		Name = "ruine2",Type = 1,Range = 800,Rewards = { 0, 1000, 0, 0, 0, 0 },
		Callback = function()
		end,
	}
	Interactive_Setup( IO )
	
	local IO = {
		Name = "ruine3",Type = 1,Range = 800,Rewards = { 600, 0, 0, 0, 0, 0 },
		Callback = function()
		end,
	}
	Interactive_Setup( IO )
	local IO = {
		Name = "ruine4",Type = 1,Range = 900,Rewards = { 5000, 0, 0, 0, 5000, 0 },
		Callback = function()
		end,
	}
	Interactive_Setup( IO )
	local IO = {
		Name = "ruine5",Type = 1,Range = 900,Rewards = { 0, 0, 0, 0, 0, 6000 },
		Callback = function()
		end,
	}
	Interactive_Setup( IO )
	
	local IO = {
		Name 		 = "cheesevil",
		Type 		 = 3,
		Range		 = 1000,
		Button		= "Build_Village",
		WinSize		= "small",
		Costs 		= { 0, 0, 0, 0, 0, 0, 50, },
		Title		= "Flagge hissen",
		Text		= Gruen.." 2 "..Weiss.." Beliebtheit "..Gruen.." 2 "..Weiss.." Ehre.",
		Callback	 = function()
			AddFlag( {"cheesevil",1,0} )
			Logic.SetModelAndAnimSet( GetEntityId("cheesevil"),Models.Banners_XB_LargeOccupied )
		end,
	}
	Interactive_Setup( IO )
	
	local IO = {
		Name 		 = "obstf",
		Type 		 = 3,
		Range		 = 1000,
		Button		= "Build_Village",
		WinSize		= "small",
		Costs 		= { 0, 0, 0, 0, 0, 0, 100, },
		Title		= "Flagge hissen",
		Text		= Gruen.." 4 "..Weiss.." Beliebtheit "..Gruen.." 4 "..Weiss.." Ehre.",
		Callback	 = function()
			AddFlag( {"obstf",2,0} )
			Logic.SetModelAndAnimSet( GetEntityId("obstf"),Models.Banners_XB_LargeOccupied )
		end,
	}
	Interactive_Setup( IO )
end

-- # # # # # # # # # # VILLAGES # # # # # # # # # # --

function ConqerableVillages()
	InitConqerableVillages()
	AddFlag( {"hering",1,0} )
	Explore.Show( "ShowObst", "obstf", 2000 )
	Explore.Show( "ShowCheesevil", "cheesevil", 2000 )
	Explore.Show( "ShowHering", "hering", 2000 )
end

-- Conqer

function InitConqerableVillages()

	function GetIdOfHoldingPlayer( _name )
		local pos = GetPosition( _name )
		local players = { 0, 0, 0, 0, 0, 0, 0, }
		for i = 1,7 do
			local entities = SucheAufDerWelt( i, 0, round(3000*0.75), pos )
			players[i] = table.getn(entities)
		end
		local holding = math.max( players[1],players[2],players[3],players[4],players[5],players[6],players[7] )
		for j = 1, 7 do
			if holding == 0 then
				return GetPlayer( _name )
			else
				if players[j] == holding then 
					local owner = GetPlayer( _name )
					if Logic.GetDiplomacyState( owner, j ) == Diplomacy.Hostile or owner == 8 then
						return j
					else 
						return GetPlayer( _name )
					end
				end 
			end
		end
	end
	
	function ControlCaptureableFlags()
		local food = 0
		local cloister = 0
		for i = 1,table.getn(gvMission.ConqVillages)do
			local holding = GetIdOfHoldingPlayer( gvMission.ConqVillages[i][1] )
			ChangePlayer( gvMission.ConqVillages[i][1], holding )
			Logic.SetModelAndAnimSet( GetEntityId(gvMission.ConqVillages[i][1]),Models.Banners_XB_LargeOccupied )
			if GetPlayer( gvMission.ConqVillages[i][1] ) == 1 then
				food = food + gvMission.ConqVillages[i][2]
				cloister = cloister + gvMission.ConqVillages[i][3]
			end
		end
		Stronghold.FoodKinds = food
		Stronghold.Cloisters = cloister
	end
	
	function AddFlag( _table )
		gvMission = gvMission or {}
		gvMission.ConqVillages = gvMission.ConqVillages or {}
		if not(IstDrin(_table[1], gvMission.ConqVillages))then
			table.insert(gvMission.ConqVillages, _table)
		end
		if not gvMission.ConqJob then
			gvMission.ConqJob = StartSimpleJob( "ControlCaptureableFlags" )
		end
	end
	
end

-- # # # # # # # # # # CREDITS # # # # # # # # # # --
function Vorspann()
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "Windows" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "Top" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "MiniMapOverlay" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "BackGround_Top" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "MinimapButtons" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "BackGroundBottomContainer" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "MiniMap" ), 0 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "ResourceView" ), 0 )
	StartCountdown( 34, VorspannEnde, false )
	Game.GameTimeSpeedUp()
	Game.GameTimeSpeedUp()
	local text
	Vorspanntext = " "..
			" "..Gelb.." Maptester: "..Weiss.." @cr Michael, Walino, Kalle, Fritz_98"..
			" @cr @cr @cr @cr @cr @cr @cr @cr @cr "..Rot..""..
			" NAMEN UND HANDLUNGEN SIND FREI ERFUNDEN @cr UND EVENTUELLE �HNLICHKEITEN ZU REALEN ODER @cr "..
			" FIKTIVEN PERSONEN SIND REIN ZUF�LLIG!"
	TestText2 = Umlaute(Vorspanntext)
	Vorsp = StartSimpleJob("Test1")
end

function VorspannEnde()
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "Windows" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "Top" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "MiniMapOverlay" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "BackGround_Top" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "MinimapButtons" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "BackGroundBottomContainer" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "MiniMap" ), 1 )
	XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "ResourceView" ), 1 )
	for i=1,16 do Message( " " )end
	Briefing_Schwierigkeit()
end

-- # # # # # # # # # # INTRO # # # # # # # # # # --
	
	W_Verrat_Strength = 3 W_Verrat_Time = 250
	W_Army1_Strength = 6  W_Army2_Strength = 6 W_Army3_Strength = 6  W_Army4_Strength = 6
	W_Army1_Time = 130 W_Army2_Time = 160 W_Army3_Time = 130 W_Army4_Time = 130
	S_Army1_Strength = 6 S_Army1_Time = 140 S_Army2_Strength = 6 S_Army2_Time = 140
	S_Army3_Strength = 6 S_Army3_Time = 160
	K_Army1_Strength = 6 K_Army2_Strength = 6 K_Army3_Strength = 6 K_Army4_Strength = 6
	K_Army5_Strength = 6 K_Army6_Strength = 6
	K_Army1_Time = 140 K_Army2_Time = 140 K_Army3_Time = 140 K_Army4_Time = 140 
	K_Army5_Time = 180 K_Army6_Time = 180 
	
	BarcIn_Strength = 10 BarcIn_Addition = 2 BarcIn_Time = 180
	CloisterIn_Strength = 4 CloisterIn_Addition = 2 CloisterIn_Time = 90
	WilIn_Strength = 3 WilIn_Addition = 1 WilIn_Time = 180
	
	B_Treue_Strength = 6 B_Treue_Time = 200 B_Verrat_Time = 130
	B_Army1_Strength = 8  B_Army2_Strength = 8 B_Army3_Strength = 8 B_Army4_Strength = 12
	B_Army5_Strength = 8 B_Army6_Strength = 4 B_Army7_Strength = 12 B_Army8_Strength = 2
	B_Army1_Time = 140 B_Army2_Time = 140 B_Army3_Time = 140 B_Army4_Time = 120
	B_Army5_Time = 120 B_Army6_Time = 180 B_Army7_Time = 140 B_Army8_Time = 180
	
	D_Verrat_Time = 130
	D_Army1_Strength = 4 D_Army1_Time = 140 D_Army2_Strength = 4 D_Army2_Time = 140 
	D_Army3_Strength = 4 D_Army3_Time = 140 D_Army4_Strength = 4 D_Army4_Time = 140
	D_Army5_Strength = 2 D_Army5_Time = 140 D_Army6_Strength = 2 D_Army6_Time = 140 
	D_Army7_Strength = 2 D_Army7_Time = 140 D_Army8_Strength = 2 D_Army8_Time = 140 
	
	P5_Army1_Strength = 4 P5_Army1_Time = 110 P5_Army2_Strength = 2 P5_Army2_Time = 140
	P5_Army3_Strength = 2 P5_Army3_Time = 140 P5_Army4_Strength = 3 P5_Army4_Time = 140
	P5_Army5_Strength = 3 P5_Army5_Time = 140 P5_Army6_Strength = 3 P5_Army6_Time = 250
	P5_Army7_Strength = 4 P5_Army7_Time = 250 P5_Army8_Strength = 4 P5_Army8_Time = 250
	P5_Army9_Strength = 4 P5_Army9_Time = 350 P5_Army10_Strength = 4 P5_Army10_Time = 350
	
	P7_Army1_Strength = 3 P7_Army1_Time = 140
	P7_Army2_Strength = 3 P7_Army2_Time = 140 P7_Army3_Strength = 3 P7_Army3_Time = 140
	P7_Army4_Strength = 12 P7_Army4_Time = 250 P7_Army5_Strength = 12 P7_Army5_Time = 350
	
function Briefing_Schwierigkeit()
	BRIEFING_ZOOMDISTANCE = 300
	BRIEFING_ZOOMANGLE = 90
	local briefing = {}
	local AP, ASP = AddPages(briefing)

	local Angreifer = AP { 
		title   = "Siedler Team", 
		text   = Gelb.." "..gvMission.Player.." "..Weiss.." , nun k�nnt Ihr die Schwierigkeit des Spiels einstellen."..
					" W�hlt Eure Einstellungen weise, denn Ihr k�nnt es Euch hier verdammt schwer machen!", 
		position = GetPosition( "cOlav" ),
		dialogCamera = false,
	}
	local Angreifer = AP { 
		mc = {
			title   = "Angreifer", 
			text   = "Wie stark sollen die Angreifer sein?", 
			firstText  = Gelb.." Durchschnittlich", 
			secondText = Gelb.." Stark", 
			firstSelected = 3, 
			secondSelected = 3,  
		},
		position = GetPosition( "cOlav" ),
		dialogCamera = false,
	}
	local Verteidiger = AP { 
		mc = {
			title   = "Verteidiger", 
			text   = "Wie gro� soll die Anzahl der Verteidiger sein?", 
			firstText  = Gelb.." Durchschnittlich", 
			secondText = Gelb.." Hoch", 
			firstSelected = 4, 
			secondSelected = 4,  
		},
		position = GetPosition( "cOlav" ),
		dialogCamera = false,
	}
	local Erholung = AP { 
		mc = {
			title   = "Erhohlung", 
			text   = "Wie schnell sollen sich feindliche Armeen erhohlen?", 
			firstText  = Gelb.." Durchschnittlich", 
			secondText = Gelb.." Schnell", 
			firstSelected = 5, 
			secondSelected = 5,  
		},
		position = GetPosition( "cOlav" ),
		dialogCamera = false,
	}
	local Ruestung = AP { 
		mc = {
			title   = "Millit�rverbesserung", 
			text   = "Soll der Feind Milit�rverbesserungen erhalten?", 
			firstText  = Gelb.." Ja", 
			secondText = Gelb.." Nein", 
			firstSelected = 6, 
			secondSelected = 6,  
		},
		position = GetPosition( "cOlav" ),
		dialogCamera = false,
	}
	local Volk = AP { 
		mc = {
			title   = "Volksgrenze", 
			text   = "Wie hoch soll Eure Bev�lkerungsgrenze sein?", 
			firstText  = Gelb.." Normal", 
			secondText = Gelb.." Erh�ht", 
			firstSelected = 7, 
			secondSelected = 7,  
		},
		position = GetPosition( "cOlav" ),
		dialogCamera = false,
	}	
	
	briefing.finished = function()
		if GetSelectedBriefingMCButton( Angreifer ) == 2 then
			B_Treue_Strength = 8 W_Verrat_Strength = 4
			P7_Army4_Strength = 15 P7_Army5_Strength = 15
			P5_Army6_Strength = 5 P5_Army7_Strength = 6 P5_Army8_Strength = 7 P5_Army9_Strength = 6
			P5_Army10_Strength = 6
			BarcIn_Addition = 4 CloisterIn_Addition = 4 WilIn_Addition = 2
		end
		if GetSelectedBriefingMCButton( Verteidiger ) == 2 then
			B_Army1_Strength = 10  B_Army2_Strength = 10 B_Army3_Strength = 10 B_Army4_Strength = 18
			B_Army5_Strength = 12 B_Army6_Strength = 4 B_Army7_Strength = 15 B_Army8_Strength = 9
			D_Army1_Strength = 6 D_Army2_Strength = 6 D_Army3_Strength = 6 D_Army4_Strength = 6
			D_Army5_Strength = 4 D_Army6_Strength = 4 D_Army7_Strength = 4 D_Army8_Strength = 4
			K_Army1_Strength = 9 K_Army2_Strength = 9 K_Army3_Strength = 9 K_Army4_Strength = 9
			K_Army5_Strength = 6 K_Army6_Strength = 6
			P5_Army1_Strength = 6 P5_Army2_Strength = 3 P5_Army3_Strength = 3 P5_Army4_Strength = 3
			P5_Army5_Strength = 6
			P7_Army1_Strength = 4 P7_Army2_Strength = 4 P7_Army3_Strength = 4
			S_Army1_Strength = 9 S_Army2_Strength = 9 S_Army3_Strength = 9 
			W_Army1_Strength = 9  W_Army2_Strength = 9 W_Army3_Strength = 12  W_Army4_Strength = 9
			
		end
		if GetSelectedBriefingMCButton( Erholung ) == 2 then
			B_Treue_Time = 150 W_Verrat_Time = 200
			B_Verrat_Time = 100 D_Verrat_Time = 100
			B_Army1_Time = 100 B_Army2_Time = 100 B_Army3_Time = 100 B_Army4_Time = 80
			B_Army5_Time = 80 B_Army6_Time = 120 B_Army7_Time = 100 B_Army8_Time = 120
			D_Army1_Time = 110 D_Army2_Time = 110 D_Army3_Time = 110 D_Army4_Time = 110
			D_Army5_Time = 110 D_Army6_Time = 110 D_Army7_Time = 110 D_Army8_Time = 110
			K_Army1_Time = 100 K_Army2_Time = 100 K_Army3_Time = 100 K_Army4_Time = 100 
			K_Army5_Time = 140 K_Army6_Time = 140
			W_Army1_Time = 100 W_Army2_Time = 130 W_Army3_Time = 100 W_Army4_Time = 100
			S_Army1_Time = 100 S_Army2_Time = 100 S_Army3_Time = 120
			P5_Army1_Time = 95 P5_Army2_Time = 140 P5_Army3_Time = 140 P5_Army4_Time = 140
			P5_Army5_Time = 110 P5_Army6_Time = 250 P5_Army7_Time = 250 P5_Army8_Time = 250
			P5_Army9_Time = 300 P5_Army10_Time = 300
			P7_Army1_Time = 120 P7_Army2_Time = 110 P7_Army3_Time = 110 P7_Army4_Time = 210
			P7_Army5_Time = 310
			BarcIn_Time = 120 CloisterIn_Time = 60 WilIn_Time = 120	
		end
		if GetSelectedBriefingMCButton( Ruestung ) == 2 then
			for i =2,7 do
				ResearchTechnology(Technologies.T_SoftArcherArmor,i) ResearchTechnology(Technologies.T_LeatherArcherArmor,i)
				ResearchTechnology(Technologies.T_PaddedArcherArmor,i) ResearchTechnology(Technologies.T_Fletching,i)
				ResearchTechnology(Technologies.T_BodkinArrow,i) ResearchTechnology(Technologies.T_WoodAging,i)
				ResearchTechnology(Technologies.T_Turnery,i) ResearchTechnology(Technologies.T_LeatherMailArmor,i)
				ResearchTechnology(Technologies.T_ChainMailArmor,i) ResearchTechnology(Technologies.T_PlateMailArmor,i)
				ResearchTechnology(Technologies.T_MasterOfSmithery,i) ResearchTechnology(Technologies.T_IronCasting,i)
				ResearchTechnology(Technologies.T_LeadShot,i) ResearchTechnology(Technologies.T_Sights,i)
				ResearchTechnology(Technologies.T_FleeceArmor,i) ResearchTechnology(Technologies.T_FleeceLinedLeatherArmor,i)
			end
		end
		if GetSelectedBriefingMCButton( Volk ) == 1 then
			VOLKSLIMIT = 1
		else
			VOLKSLIMIT = 1.25
		end
		Defender_Olaf()
		Defender_Edwin()
		Intro()
	end
	StartBriefing(briefing)
end

-- # # # # # # # # # # INTRO # # # # # # # # # # --

function Intro()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cOlav",""," ", true)
	briefing.finished = function()
		local cutscene={
		StartPosition={ zoom = 1100,rotation = -90,angle = 5,position = GetPosition( "cam1" ),},
		Flights={
			{
			position = GetPosition( "cOlav" ),angle = 5,zoom = 1000,rotation = -93,duration = 15,delay = 1,
			title = tOlaf,
			text = "Bei Odins Bart... @cr Wo sind wir denn hier gelandet? @cr Ich will, dass ihr mir einen Wall"..
					" hochzieht, der sich sehen lassen kann, hahaha!",
			},
			{
			position = GetPosition( "william" ),angle = 25,zoom = 800,rotation = 134,duration = 0,delay = 0,
			title = "",
			text = "",
			action = function()
				DestroyEntity( "cOlav" )
				for i=2,12 do DestroyEntity( "cBarb"..i )end
				Move( "william", "willpos1" )
				Camera.FollowEntity(GetEntityId("william"))
				StartMusic("20_Evelance_Summer2.mp3", 153)
			end
			},
			{
			position = GetPosition( "william" ),angle = 12,zoom = 1100,rotation = 158,duration = 9,delay = 0,
			title = tErz,
			text = "Das Land war schutzlos... @cr Vom K�nig hatte man lange nichts mehr geh�rt... @cr Man"..
					" glaubte er sei tot...",
			},
			{
			position = GetPosition( "william" ),angle = 5,zoom = 2000,rotation = 38,duration = 0,delay = 0,
			title = "",
			text = "",
			action = function()
				Move( "william", "willpos2" )
			end
			},
			{
			position = GetPosition( "william" ),angle = 10,zoom = 800,rotation = 52,duration = 7,delay = 0,
			title = tErz,
			text = "Ich fragte Master William damals, wof�r wir k�mpfen wenn der �berm�chtige Feind niemals"..
					" besiegt wird...",
			},
			{
			position = GetPosition( "towers1" ),angle = 20,zoom = 2000,rotation = 15,duration = 0,delay = 0,
			title = "",
			text = "",
			action = function()
				Move( "william", "conversation" )
				Camera.FollowEntity(0)
			end
			},
			{
			position = GetPosition( "cam2" ),angle = 5,zoom = 1800,rotation = 100,duration = 10,delay = 0,
			title = tErz,
			text = "Aber William war der Ansicht, dass auch viele kleine Siege den Feind irgendwann f�llen."..
					" Und fast w�re "..mBarc2.." besiegt worden.",
			},
			{
			position = GetPosition( "HQSteele" ),angle = 30,zoom = 5000,rotation = -86,duration = 0,delay = 0,
			title = "",
			text = "",
			action = function()
			end
			},
			{
			position = GetPosition( "HQSteele" ),angle = 25,zoom = 3500,rotation = -113,duration = 20,delay = 5,
			title = tErz,
			text = "Doch "..mBarc1.." hatte �berlebt und war nun auf Rache aus. Er versammelte die Feinde des"..
					" K�nigs - darunter auch Master Williams �lterer Bruder Deveraux - um dem Reich entg�ltig den"..
					" Todessto� zu geben...",
			},
		},
		Callback=function()
			StartsBriefing()
		end,
	 }
	 StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end
function StartsBriefing()
	BRIEFING_CAMERA_FLYTIME = 10
	BRIEFING_TIMER_PER_CHAR = 4
	BRIEFING_ZOOMDISTANCE = 6500
	BRIEFING_ZOOMANGLE = 10
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	AP{	
		title = "",
		text = "",
		position = GetPosition("HQSteele"),
		dialogCamera = false,
		action = function()
			BRIEFING_ZOOMDISTANCE = 3500
			BRIEFING_ZOOMANGLE = 15
		end
	}
	AP{	
		title = Gruen.." KAPITEL VI:",
		text = Gelb.." WEHE DIR, OLAV GRIMZAHN!",
		position = GetPosition("matthew"),
		dialogCamera = false,
		action = function()
			BRIEFING_CAMERA_FLYTIME = 0
			BRIEFING_TIMER_PER_CHAR = 1
			BRIEFING_DISTANCE1()
		end
	}
	ASP("matthew",tMat,"Master William, sch�n dass Ihr Euch die M�he gemacht habt, zu mir zu finden.", true)
	ASP("william",tWil,mMat.." , Ihr seid nicht mehr mein Diener. Ich habe Euch eine L�nderei und einen Titel"..
					" gegeben, weil ich glaube, dass Ihr der einzige seid, der meine alten Posten �ber"..
					"nehmen kann.", true)
	ASP("william",tWil,"Dem K�nig gehen seine Getreuen aus. Dass ich Euch, meinem ehemaligen Pagen, so eine Ehre zuteil"..
					"werden lasse, zeigt mein Vertrauen. Sch�n, wenn auch mir die selbe Ehre zu Teil w�rde.", true)
	AP{	
		title = tWil,
		text = "Ich bin aber nicht zum Spa� hier, Matthew.",
		position = GetPosition("william"),
		dialogCamera = true,
		action = function()
			BRIEFING_DISTANCE3()
		end
	}
	ASP("spawnP7_2",tWil,mOlaf.." ist zur�ck. Seine Flotte ist in einen Sturm geraten und vor der K�ste havariert."..
					" Unseren Spionen zufolge, haben die �berlebenden Wikinger eine Holzburg errichtet. Ihr"..
					" m�sst mit Angriffen rechnen.", false)
	ASP("HQEdwin",tWil,"Der schleimige Verr�ter "..mEdw.." hat seine Burg heruntergewirtschaftet. Er l�gt, betr�gt und"..
					" hat schon mehrfach die Seiten gewechselt, wenn ihm ein Sack Gold zugeworfen wurde. Er ist"..
					" ein Schandfleck f�r England.", false)
	ASP("william",tWil,"Beide sind als Gegner nicht zu untersch�tzen. Ihr m�sst verhindern, dass Edwin und Olaf"..
					" eine Allianz eingehen. Wenn sie sich nicht gr�n sind, werden sie miteinander besch�ftigt"..
					" sein und Eure Burg vorerst in Ruhe lassen.", true)
	ASP("william",tWil,"Wenn sie sich verb�nden sollten, entsteht eine neue Macht in diesem Land. Das k�nnen wir uns nicht"..
						" leisten, jetzt wo das Land ohne K�nig ist.", true)
	ASP("cheesevil",tWil,"Es gibt hier einige L�ndereien, in denen Ihr eure Flagge hissen k�nnt, doch gebt"..
					" Acht, sie liegen meist in Marschrichtung der Feinde.", false)
	ASP("william",tWil,"Leider muss ich Euch auch schon wieder verlassen. Doch Ihr habt Euren Wert bereits"..
					" unter Beweis gestellt, so bin ich zuversichtlich. F�r alle F�lle unterstelle ich Euch"..
					" den k�niglichen Berater "..mSim.." auf dass er Eure Fragen beantworte.", true)
	AP{	
		title = tSim,
		text = "Ich gr��e Euch, Sire. Sch�n, Euch wiederzusehen.",
		position = GetPosition("matthew"),
		dialogCamera = true,
		action = function()
			Move( "william", "willpos1" )
			BRIEFING_DISTANCE1()
		end
	}
	ASP("matthew",tMat,"Ich gr��e Euch auch.", true)
	ASP("destroy1",tSim,"Sire, diese Burg ist bald noch sch�biger als jene von Edwin. Man kann nur hoffen, dass der"..
					" Verantwortliche daf�r im Kerker versauert, denn er hat uns die Arbeit nur erschwert.", false)
	ASP("matthew",tSim,"Ihr m�sst Euch so schnell wie m�glich beim Volke beliebt machen, damit Ihr demn�chst"..
						" noch ein Volk habt, dass Euch Steuern zahlt, Sire.", false)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		StartChapter6()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

-- # # # # # # # # # # CHAPTER 6 # # # # # # # # # # --

function StartChapter6()
	Init_Stronghold( "matthew", "HQSteele", "ari", Entities.PU_Hero5 )
	SetPosition( "william", GetPosition("willpos3") )
	ConqerableVillages()
	Stronghold.AttractionMulti = VOLKSLIMIT
	Stronghold.Motivation = 55
	Stronghold.Ehre = 200
	StartSimpleJob( "ImmortalbilityForCharackter" )
	DefeatJob1 = StartSimpleJob( "MainDefeatConstitution" )
	DefeatJob2 = StartSimpleJob( "HeroReanimationCooldown" )
	MakeInvulnerable( "HQOlaf" )
	MakeInvulnerable( "HQEdwin" )
	SetHostile( 1, 5 )
	SetHostile( 1, 7 )
	SetHostile( 5, 7 )
	Write_Quest1()
	Quest1()
end

-- #### ARMIES #### --

-- Olaf

function Defender_Olaf()
	local P7_Army1 = {
	player = 7,					
	erstehungsPunkt = "spawnP7_1", 
	ziel = {"patrol7_1","patrol7_2","patrol7_3"},
	lebensFaden = "lifeP7_1",
	tod = true,					
	zeit = P7_Army1_Time,					 
	type = {23}, 	
	menge = P7_Army1_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 1500,		
	endAktion = function()
    end
	}
	P7_Army1 = CreateRobArmee(P7_Army1)
	StartArmee(P7_Army1)
	
	local P7_Army2 = {
	player = 7,					
	erstehungsPunkt = "spawnP7_2", 
	ziel = {"spawnP7_2"},
	lebensFaden = "lifeP7_2",
	tod = true,					
	zeit = P7_Army2_Time,					 
	type = {23}, 	
	menge = P7_Army2_Strength,					
	erfahrung = 3,				
	refresh = 2,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	P7_Army2 = CreateRobArmee(P7_Army2)
	StartArmee(P7_Army2)
	
	local P7_Army3 = {
	player = 7,					
	erstehungsPunkt = "spawnP7_3", 
	ziel = {"patrol7_1","patrol7_2","patrol7_3"},
	lebensFaden = "lifeP7_3",
	tod = true,					
	zeit = P7_Army3_Time,					 
	type = {23}, 	
	menge = P7_Army3_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P7_Army3 = CreateRobArmee(P7_Army3)
	StartArmee(P7_Army3)
	
	MachKumpel(P7_Army1,P7_Army3)
	MachKumpel(P7_Army2,P7_Army1)
	MachKumpel(P7_Army2,P7_Army3)
end

function Attacker_Olav()
	local P7_Army4 = {
	player = 7,					
	erstehungsPunkt = "mainspawn7", 
	ziel = {"HQSteele"},
	lebensFaden = "lifeA7_1",
	tod = false,					
	zeit = P7_Army4_Time,					 
	type = {23}, 	
	menge = P7_Army4_Strength,					
	erfahrung = 3,				
	refresh = P7_Army4_Strength,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P7_Army4 = CreateRobArmee(P7_Army4)
	StartArmee(P7_Army4)
	StartSimpleJob( "Control_OlafAttacker" )
end
function Control_OlafAttacker()
	if not(IsExisting("HQOlav"))then
		DestroyEntity("lifeA7_1")
		return true
	end
	if not(IsExisting("lifeA7_1"))then
		return true
	end
end

function Attacker_Olav_Stolen()
	DestroyEntity("lifeA7_1")
	local P7_Army5 = {
	player = 7,					
	erstehungsPunkt = "mainspawn7", 
	ziel = {"HQEdwin"},
	lebensFaden = "lifeA7_2",
	tod = true,					
	zeit = P7_Army5_Time,					 
	type = {23}, 	
	menge = P7_Army5_Strength,					
	erfahrung = 3,				
	refresh = P7_Army5_Strength,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P7_Army5 = CreateRobArmee(P7_Army5)
	StartArmee(P7_Army5)	
	StartSimpleJob( "Control_OlafAttacker_Stolen" )
end
function Control_OlafAttacker_Stolen()
	if not(IsExisting("HQOlav"))then
		DestroyEntity("lifeA7_2")
		return true
	end
end

-- Edwin

function Defender_Edwin()
	local P5_Army1 = {
	player = 5,					
	erstehungsPunkt = "spawnP5_1", 
	ziel = {"patrol5_1"},
	lebensFaden = "lifeP5_1",
	tod = true,					
	zeit = P5_Army1_Time,					 
	type = {9}, 	
	menge = P5_Army1_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = false,				
	kriegRadius = 1000,		
	endAktion = function()
    end
	}
	P5_Army1 = CreateRobArmee(P5_Army1)
	StartArmee(P5_Army1)
	
	local P5_Army2 = {
	player = 5,					
	erstehungsPunkt = "spawnP5_1", 
	ziel = {"patrol5_1"},
	lebensFaden = "lifeP5_1",
	tod = true,					
	zeit = P5_Army2_Time,					 
	type = {2}, 	
	menge = P5_Army2_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = false,				
	kriegRadius = 1000,		
	endAktion = function()
    end
	}
	P5_Army2 = CreateRobArmee(P5_Army2)
	StartArmee(P5_Army2)
	
	local P5_Army3 = {
	player = 5,					
	erstehungsPunkt = "spawnP5_2", 
	ziel = {"patrol5_2","spawnP5_2","HQEdwin"},
	lebensFaden = "lifeP5_2",
	tod = true,					
	zeit = P5_Army3_Strength,					 
	type = {9}, 	
	menge = P5_Army3_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army3 = CreateRobArmee(P5_Army3)
	StartArmee(P5_Army3)
	
	local P5_Army4 = {
	player = 5,					
	erstehungsPunkt = "spawnP5_2", 
	ziel = {"patrol5_2","spawnP5_2","HQEdwin"},
	lebensFaden = "lifeP5_2",
	tod = true,					
	zeit = P5_Army4_Time,					 
	type = {2}, 	
	menge = P5_Army4_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army4 = CreateRobArmee(P5_Army4)
	StartArmee(P5_Army4)
	
	local P5_Army5 = {
	player = 5,					
	erstehungsPunkt = "mainspawn5", 
	ziel = {"mainspawn5"},
	lebensFaden = "HQEdwin",
	tod = true,					
	zeit = P5_Army5_Time,					 
	type = {25}, 	
	menge = P5_Army5_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	P5_Army5 = CreateRobArmee(P5_Army5)
	StartArmee(P5_Army5)
	
	MachKumpel(P5_Army1,P5_Army2)
	MachKumpel(P5_Army1,P5_Army4)
	MachKumpel(P5_Army5,P5_Army2)
	MachKumpel(P5_Army5,P5_Army4)
end

function Attacker_Edwin()
	gvMission.EdwinOnOlav = true
	local P5_Army6 = {
	player = 5,					
	erstehungsPunkt = "mainspawn5", 
	ziel = {"HQOlav"},
	lebensFaden = "HQOlav",
	tod = true,					
	zeit = P5_Army6_Time,					 
	type = {25}, 	
	menge = P5_Army6_Strength,					
	erfahrung = 0,				
	refresh = 3,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army6 = CreateRobArmee(P5_Army6)
	StartArmee(P5_Army6)
	
	local P5_Army7 = {
	player = 5,					
	erstehungsPunkt = "mainspawn5", 
	ziel = {"HQOlav"},
	lebensFaden = "HQOlav",
	tod = true,					
	zeit = P5_Army7_Time,					 
	type = {9}, 	
	menge = P5_Army7_Strength,					
	erfahrung = 0,				
	refresh = 3,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army7 = CreateRobArmee(P5_Army7)
	StartArmee(P5_Army7)
	
	local P5_Army8 = {
	player = 5,					
	erstehungsPunkt = "mainspawn5", 
	ziel = {"HQOlav"},
	lebensFaden = "HQOlav",
	tod = true,					
	zeit = P5_Army8_Time,					 
	type = {2}, 	
	menge = P5_Army8_Strength,					
	erfahrung = 0,				
	refresh = 5,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army8 = CreateRobArmee(P5_Army8)
	StartArmee(P5_Army8)
	
	MachKumpel(P5_Army6,P5_Army7)
	MachKumpel(P5_Army6,P5_Army8)
	MachKumpel(P5_Army7,P5_Army8)
end

function Attacker_Edwin_NotStolen()
	local P5_Army9 = {
	player = 5,					
	erstehungsPunkt = "mainspawn5", 
	ziel = {"HQSteele"},
	lebensFaden = "HQEdwin",
	tod = true,					
	zeit = P5_Army9_Time,					 
	type = {2}, 	
	menge = P5_Army9_Strength,					
	erfahrung = 0,				
	refresh = 2,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army9 = CreateRobArmee(P5_Army9)
	StartArmee(P5_Army9)
	
	local P5_Army10 = {
	player = 5,					
	erstehungsPunkt = "mainspawn5", 
	ziel = {"HQSteele"},
	lebensFaden = "HQEdwin",
	tod = true,					
	zeit = P5_Army10_Time,					 
	type = {9}, 	
	menge = P5_Army10_Strength,					
	erfahrung = 0,				
	refresh = 2,				
	scharf = false,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	P5_Army10 = CreateRobArmee(P5_Army10)
	StartArmee(P5_Army10)
	
	MachKumpel(P5_Army9,P5_Army10)
end

-- #### QUESTS #### --

-- Motivation

function Write_Quest1()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL VI: @cr Wehe dir, Olaf Grimzahn!"
	local questtext	 =	"Nach dem Sieg �ber Lord Barcley, dem Hammer, schien doch noch Hoffnung zu bestehen."..
						" William suchte jetzt noch eifriger nach dem K�nig. Doch dann starb Sir Edward an der"..
						" Pest, ein harter Schlag ins Gesicht der K�nigstreuen. War Gott nicht mehr auf unserer"..
						" Seite? @cr Ein Nachfolger f�r Edward musste her, so erhielt William den begehrten Titel"..
						" \"Streiter des K�nigs\" und ich, sein Page, �bernahm seine Position. @cr @cr Ein alter"..
						" Wikinger und ein Verr�ter stellten eine ernstzunehmende Bedrohung dar. Ich musste mich"..
						" ihrer annehmen. @cr @cr "..SZ.." - TOD: "..mOlaf.." (Pilgrim) @cr - TOD: "..mEdw.." "..
						" @cr @cr "..NZ.." - TOD: "..mMat.." (Erec) @cr - GEB�UDE: - Bergfried verlieren @cr @cr "..
						" "..Rot.." Achtung: "..Weiss.." Olaf und Edwin k�nnen erst get�tet werden, wenn ihre "..
						" Bergfriede zerst�rt wurden."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Befiedet den P�bel"
	local questtext	 =	"Da hat William mir mal wieder eine sch�ne L�nderei �bergeben. Keine Ahnung wer da"..
						" vorher der Burgherr war, aber er hatte kein Geschick, das stand fest. Das Volk war "..
						" unzufrieden und projizierte seine Wut auf mich. So konnte es nicht weitergehen, denn"..
						" bald w�rden sie meine Burg verlassen. @cr @cr "..SZ.." - BELIEBTHEIT: mind. 80 "..
						" @cr @cr "..NZ.." - BELIEBTHEIT: unter 50 @cr - ZEIT: 10 Wochen(Zahltage)"..
						" @cr - GEB�UDE: - Bergfried verlieren."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

function Quest1()
	Aussetzen = false; Ausloesen = false
	Q1_ID = StartSimpleHiResJob( "Quest1_OnPayday" )
	StartSimpleJob( "Quest1_Control" )
	gvMission.InfoText1 = "Beliebtheit erreichen"
	gvMission.InfoText2 = "Verbleibende Zeit"
	gvMission.Value1 = 80
	gvMission.Value2 = 10
end

function Quest1_OnPayday()
   Aussetzen = Aussetzen or false
   Ausloesen = Ausloesen or false
   
   if Logic.GetPlayerPaydayTimeLeft(1) < 1000  then
	Aussetzen = true
   elseif Logic.GetPlayerPaydayTimeLeft(1) > 118000 then
	   Aussetzen = false
	   Ausloesen = false
   end
   if Aussetzen and not Ausloesen then
		gvMission.Value2 = gvMission.Value2 - 1
		Ausloesen = true
   end
end

function Quest1_Control()
	Show_Infoline( 1, gvMission.InfoText1, Stronghold.Motivation-50, gvMission.Value1-50 )
	Show_Infoline( 2, gvMission.InfoText2, gvMission.Value2, 10 )
	if Stronghold.Motivation >= gvMission.Value1 then
		EndJob( Q1_ID )
		Quest1_Ende()
	return true
	elseif (Stronghold.Motivation < 50 or gvMission.Value2 < 1)then
		Defeat_Motivation()
	return true
	end
end

function Quest1_Ende()
	Briefing_Aufruestung()
	
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Befiedet den P�bel"
	local questtext	 =	"Da hat William mir mal wieder eine sch�ne L�nderei �bergeben. Keine Ahnung wer da"..
						" vorher der Burgherr war, aber er hatte kein Geschick, das stand fest. Das Volk war "..
						" unzufrieden und projizierte seine Wut auf mich. So konnte es nicht weitergehen, denn"..
						" bald w�rden sie meine Burg verlassen. @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),0)
end

function Defeat_Motivation()
	BRIEFING_DISTANCE1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	ASP("matthew",tMat,"Verdammt, ich habe versagt! Wenn ich nicht mal den P�bel von mir �berzeugen kann, wie"..
						" soll ich dann Soldaten kommandieren? Es werden keine B�rger mehr auf die Burg kommen,"..
						" die Wirtschaft ist tot.", true)
	
	briefing.finished = function()
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
	end
	StartBriefing(briefing)
end

-- Aufr�sten

function Briefing_Aufruestung()
	BRIEFING_DISTANCE1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	ASP("matthew",tMat,"Ich habe es geschafft. Die Untertanen akzeptieren mich.", true)
	ASP("HQSteele",tSim,"Dann solltet Ihr mit dem Aufr�sten beginnen, sofern Ihr das nicht schon getan habt,"..
						" Sire.", false)
	ASP("towers1",tSim,"Ich schlage vor, dass wir diese alten T�rme restaurieren.", false)
	ASP("matthew",tSim,"Wo Ihr schon mal dabei seit, solltet Ihr auch Soldaten rekrutieren, falls Olaf sich"..
						" entschlie�t anzugreifen.", true)
	ASP("HQSteele",tSim,"Bedenkt; Ihr m�sst Euch die Soldaten leisten k�nnen. Ihr braucht Rohstoffe,"..
						" Gold, entsprechende Geb�ude und vor allem Ehre, Sire.", false)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		Hide_Infoline( 1 )
		Hide_Infoline( 2 )
		Write_Quest2()
		Quest2()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function Write_Quest2()
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Aufr�stung"
	local questtext	 =	"Ich musste schnell zu einer Macht in diesem Land werden. Nur so konnte ich verhindern, dass sich"..
						" William noch einem Gegner entgegenstellen muss."..
						" @cr @cr "..SZ.." - REPARIEREN: Turmruinen am Mauerdurchgang. @cr "..
						" - UNTERHALTEN: 90 Soldaten (Hauptm�nner + Gruppenmitglieder)"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

function Quest2()
	gvMission.InfoText1 = "Soldaten unterhalten"
	gvMission.InfoText2 = "T�rme restaurieren"
	gvMission.Value1 = 90
	gvMission.Value2 = 2
	StartSimpleJob( "Quest2_Control" )
	
	for i=1,4 do
		local IO = {
			Name 		 = "tCTower"..i,
			Type 		 = 2,
			Range		 = 400,
			Endless 	 = true,
			Callback	 = function()
			end,
		}
		Interactive_Setup( IO )
	end
end

function Quest2_Control()
	local tower = SucheAufDerWelt( 1, Entities.PB_Tower2, 4000, GetPosition( "towers1" ))
	local tower2 = SucheAufDerWelt( 1, Entities.PB_Tower3, 4000, GetPosition( "towers1" ))
	local soldiers = Logic.GetNumberOfAttractedSoldiers(1)-Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_BattleSerf )
	Show_Infoline( 1, Umlaute(gvMission.InfoText2), table.getn(tower)+table.getn(tower2), gvMission.Value2 )
	Show_Infoline( 2, gvMission.InfoText1, soldiers, gvMission.Value1 )
	
	if ((table.getn(tower)>= 2) or (table.getn(tower2)>= 2)) and Logic.GetNumberOfAttractedSoldiers(1) >= gvMission.Value1 then
		Quest2_Ende()
		return true
	end
end

function Quest2_Ende()
	Hide_Infoline( 1 )
	Hide_Infoline( 2 )
	Briefing_OlafGreiftAn()
	
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Aufr�stung"
	local questtext	 =	"Ich musste schnell zu einer Macht in diesem Land werden. Nur so konnte ich verhindern, dass sich"..
						" William noch einem Gegner entgegenstellen muss."..
						" @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),0)
end

-- Beweis besorgen

function Briefing_OlafGreiftAn()
	BRIEFING_DISTANCE3()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	AP{	
		title = tOlaf,
		text = "M�nner: Auf die Burg! Bringt mir den Kopf des Burgherren!",
		position = GetPosition("olaf"),
		dialogCamera = true,
		action = function()
			BRIEFING_DISTANCE1()
		end
	}
	ASP("HQSteele",tSim,"Mein Herr, wir werden die Soldaten, die Ihr angeheuert habt, jetzt brauchen. Die"..
						" erbarmungslosen Krieger von "..mOlaf.." sind f�r ihre brutalen Massenangriffe"..
						" gef�rchtet.", false)
	ASP("matthew",tMat,mWil.." hat mir schon oft von dem alten Wikinger erz�hlt. Ich werde meine Leute anweisen,"..
						" die Verteidigung zu verbessern.", true)
	ASP("HQSteele",tSim,"Worte allein werden nicht reichen, Sire.", false)
	ASP("matthew",tMat,"William meinte, ich solle verhindern, dass sich Olaf und Edwin verb�nden. Wie soll ich das"..
						" anstellen?", true)
	ASP("HQSteele",tSim,"Vielleicht kann ich da behilflich sein. Mein Spion k�nnte bei Edwin herumschn�ffeln, My"..
						" Lord. Vielleicht kann er ihn gegen Olaf aufstacheln.", false)
	ASP("matthew",tMat,"So sei es. Schick deinen Spion aus. Ich werde Olafs Truppen solange besch�ftigen.", true)
	ASP("HQSteele",tSim,mThief.." ist schon auf dem Weg.", false)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		Attacker_Olav()
		Write_Quest3()
		Quest3()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function Write_Quest3()
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Spionage"
	local questtext	 =	mOlaf.." und "..mEdw.." sich verb�nden? Das h�tte zu diesen Gestalten gepasst. Ich wurde"..
						" nun mehrfach davor gewarnt. Mein Berater hat mir einen Agenten angeheuert, der Edwin"..
						" auskundschaften sollte. @cr @cr "..SZ.." - ERKUNDEN: Edwins Siedlung @cr @cr "..NZ.." "..
						" - TOD: "..mThief.." @cr @cr "..Gelb.." Olaf und Edwin k�nnen erst nach Abschluss dieses"..
						" Auftrags besiegt werden. @cr @cr Edwins Bergfried wurde auf der Minikarte markiert. @cr @cr "..
						" Ihr solltet genauer auf Verteidigungst�rme achten."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

function Quest3()
	local pos = GetPosition( "doorpos" )
	SetEntityName(Tools.CreateGroup(1, Entities.PU_Thief, 0, pos.X, pos.Y, 180.00 ),"thief1")
	ProtectEntity( "thief1" )
	StartSimpleJob( "BeweiseFinden" )
	
	local pos = GetPosition("HQEdwin")
	GUI.CreateMinimapMarker(pos.X,pos.Y)
end

function BeweiseFinden()
	if IsDead( "thief1" )then
		Briefing_OlafEdwinBund()
		local pos = GetPosition("HQEdwin")
		GUI.DestroyMinimapPulse(pos.X,pos.Y)
	return true
	else
		if IsNear( "thief1", "Beweis", 400 )then
			Briefing_BeweisGefunden()
			ReplaceEntity( "Beweis", Entities.XD_ChestOpen )
		return true
		end
	end
end

function Briefing_BeweisGefunden()
	BRIEFING_DISTANCE1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	ASP("thief1",tThief,"Was haben wir denn da? Wer steckt denn ein Dokument in eine Kiste und baut solche"..
						" auff�lligen T�rme daneben? @cr Wollen wir mal sehen, was da steht...", true)
	ASP("thief1",tThief,"Es sieht so aus, als ob Edwin Blackfly nicht der Sohn seines Vaters ist. Er ist"..
						" ein "..Gruen.." Erbschleicher "..Weiss.." wie er im Buche steht! Wenn ich diesen"..
						" Beweis in Olafs Turm schmuggle, wird Edwin annehmen, dass der Wikinger seine"..
						" Geburtsurkunde stahl.", true)
	ASP("thief1",tThief,"Dann ist Krieg vorprogrammiert...", true)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		Write_Quest3Neu()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function Write_Quest3Neu()
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Spionage"
	local questtext	 =	"Der Spion fand unerwartet eine Geburtsurkunde, die best�tigt, was eigentlich kein"..
						" Geheimnis war. Edwin war ein Betr�ger. Doch war er dies nunmehr nachweislich. Der"..
						" Dieb entschied, diesen Beweis in Olafs Turm zu schmuggeln. Und das so offensichtlich,"..
						" dass Edwin mitbekam, wer jetzt seine Geburtsurkunde hatte. @cr @cr "..SZ.." - "..
						" Positioniert den Agenten vor dem Eingang von Olafs Turm @cr @cr "..NZ.." "..
						" - TOD: "..mThief.." @cr @cr "..Gelb.." Olaf und Edwin k�nnen erst nach Abschluss dieses"..
						" Auftrags besiegt werden. @cr @cr Olafs Turm wurde auf der Minikarte markiert."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	StartSimpleJob( "BeweisInOlafsTurm" )
	
	local pos = GetPosition("HQEdwin")
	GUI.DestroyMinimapPulse(pos.X,pos.Y)
	local pos = GetPosition("HQOlav")
	GUI.CreateMinimapMarker(pos.X,pos.Y)
end

function BeweisInOlafsTurm()
	if IsDead( "thief1" )then
		Briefing_OlafEdwinBund()
		local pos = GetPosition("HQOlav")
		GUI.DestroyMinimapPulse(pos.X,pos.Y)
	return true
	else
		if IsNear( "thief1", "mainspawn7", 400 )then
			Briefing_BeweisInOlafsTurm()
			DestroyEntity( "thief1" )
		return true
		end
	end
end

function Briefing_BeweisInOlafsTurm()
	BRIEFING_DISTANCE3()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	AP{	
		title = tEdw,
		text = "SIE IST WEG!!! @cr Wie konntet ihr Idioten das nur zulassen?! @cr Wisst ihr, was das f�r mich"..
				" hei�t, wenn der Wisch in die falschen H�nde kommt?! @cr Ich lasse die Verantwortlichen ent"..
				"haupten!",
		position = GetPosition("HQEdwin"),
		action = function()
			BRIEFING_DISTANCE1()
		end
	}
	ASP("HQOlav",tEdw,"Jetzt muss ich mich darum k�mmern, diese \"delikaten\" Informationen zur�ck zu holen."..
						" @cr M�nner: Brennt den Turm dieses Wikingers nieder!", false)
	ASP("HQEdwin",tEdw,"Der wird schon sehen, was er davon hat, mich bestehlen zu lassen!", false)
	ASP("HQOlav",tOlaf,"Du willst meinen Turm niederbrennen? Du schaffst es doch nicht mal, einen Kr�mel"..
						" von ihm zu brechen! Ich werde dir zeigen, wo es lang geht!", false)
	ASP("matthew",tSim,"Es ist vollbracht: Edwins und Olafs Leute schlagen sich nun die K�pfe ein! Das sollten"..
						" wir ausnutzen und Angreifen, wenn sie mit sich besch�ftigt sind, Sire.", false)
	
	briefing.finished = function()
		local pos = GetPosition("HQOlav")
		GUI.DestroyMinimapPulse(pos.X,pos.Y)
		
		Display.SetRenderFogOfWar(1)
		Attacker_Edwin()
		Attacker_Olav_Stolen()
		Quest3_Erfuellt()
		Quest4()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function Quest3_Erfuellt()
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Spionage"
	local questtext	 =	"Lars Langfinger fand unerwartet eine Geburtsurkunde, die best�tigte, was eigentlich kein"..
						" Geheimnis war. Edwin war ein Betr�ger. Doch war er dies nun mehr nachweislich. Der"..
						" Dieb entschied diesen Beweis in Olafs Turm zu schmuggeln. Und das so offensichtlich,"..
						" das Edwin mitbekam, wer jetzt seine Geburtsurkunde hatte. @cr @cr "..Mint.." Diese"..
						" Aufgabe wurde erf�llt. @cr @cr "..Gelb.." Olaf und Edwin k�nnen nun besiegt werden."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),0)
end

function Briefing_OlafEdwinBund()
	BRIEFING_DISTANCE1()
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	ASP("HQEdwin",tEdw,"Hey, Wikinger, bist du gestrandet?", false)
	ASP("HQOlav",tOlaf,"Willst du dich jetzt bei mir anbiedern oder was?", false)
	ASP("HQEdwin",tEdw,"Na ja, mir ist "..Grau.." nat�rlich "..Weiss.." klar, das so ein "..Grau.." starker"..
						" "..Weiss.." Wikinger wie du keine Hilfe gegen einen Feind braucht, aber ich w�rde"..
						" mich gerne mit dir zusammentun.", false)
	ASP("HQOlav",tOlaf,"Hm... @cr Ich verb�nde mich zwar nicht gerne mit Schw�chlingen, aber ich bin fremd"..
						" in diesem Land und k�nnte Hilfe gebrauchen. Also warum nicht.", false)
	ASP("HQEdwin",tEdw,"Dann t�ten wir diesen Burgherren gemeinsam.", false)
	ASP("HQOlav",tOlaf,"Ja, nat�rlich. @cr (zu sich selbst) "..Grau.." Und danach bist du drann, hehehe!", false)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		Attacker_Edwin_NotStolen()
		SetFriendly( 5, 7 )
		Quest3_Verloren()
		Quest4()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function Quest3_Verloren()
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Spionage"
	local questtext	 =	"Jetzt wo der Agend entdeckt wurde, bestand keine Hoffnung mehr, dass B�ndnis zwischen"..
						" Edwin Blackfly und Olaf Grimzahn zu verhindern. @cr @cr "..Rot.." Diese"..
						" Aufgabe wurde nicht erf�llt. @cr @cr "..Gelb.." Olaf und Edwin k�nnen nun besiegt werden."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),0)
end

function Quest4()
	MakeVulnerable( "HQOlaf" )
	MakeVulnerable( "HQEdwin" )
	StartSimpleJob( "EndQuestOlavKilled" )
	StartSimpleJob( "EndQuestEdwinKilled" )
	StartSimpleJob( "EndQuest4" )
end

function EndQuestOlavKilled()
	if GetHealth( "olaf" )<1 then
		Briefing_OlafDied()
	return true
	end
end
function Briefing_OlafDied()
	BRIEFING_DISTANCE1()
	if GetHealth( "olaf" )>0 then SetHealth("olav",0)end
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	ASP("olaf",tOlaf,"Ahrrr, ich kann mein Walk�renlied h�ren... @cr Walhalla... erwartet mich...", true)
	if IsExisting( "HQEdwin" )then
		ASP("olaf",tEdw,"Der Wikinger hat ins Gras gebissen! @cr "..Gruen.." Empork�mling: "..Weiss.." @cr "..
						" Ihr seid der N�chste!", true)
						
		if gvMission.EdwinOnOlav == true then Attacker_Edwin_NotStolen() end
		
		ASP("olaf",tSim,"Mein Herr, wir haben unseren ersten gro�en Sieg errungen. Schnell, reiten wir auf der Welle des"..
						" Erfolgs und t�ten diesen Edwin.", false)
	else
		ASP("olaf",tMat,"Ha, das wars f�r dich, Grimzahn...", false)
	end
	
	briefing.finished = function()
		local units = SucheAufDerWelt( 7, 0 )
		for i=1,table.getn(units)do
			if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
				if Logic.IsLeader(units[i])== 1 then
					Logic.DestroyGroupByLeader( units[i] )
				else
					Logic.DestroyEntity( units[i] )
				end
			end
		end
		Display.SetRenderFogOfWar(1)
		InitialisizePrison()
		gvMission.Olaf = true
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function EndQuestEdwinKilled()
	if IsDeadWrapper( "edwin" )then
		Briefing_EdwinDied()
	return true
	end
end
function Briefing_EdwinDied()
	BRIEFING_DISTANCE1()
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	ASP("sammelplatz5",tEdw,"Bitte, t�tet mich nicht. Ich habe... Informationen, wichtige Informationen... Aber"..
					" bitte... "..Grau.." (weinerlich) "..Weiss.." lasst mich leben!", false)
	if IsExisting( "HQOlav" )then
		ASP("sammelplatz5",tOlaf,mEdw.." - ein weiterer Schw�chling - versauert nun im Kerker, ha!", false)
	else
		ASP("sammelplatz5",tMat,"Edwin, ich nehme Euch unter Arrest.", false)
	end
	
	briefing.finished = function()
		local units = SucheAufDerWelt( 5, 0 )
		for i=1,table.getn(units)do
			if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
				if Logic.IsLeader(units[i])== 1 then
					Logic.DestroyGroupByLeader( units[i] )
				else
					Logic.DestroyEntity( units[i] )
				end
			end
		end
		Display.SetRenderFogOfWar(1)
		gvMission.Edwin = true
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function EndQuest4()
	if gvMission.Edwin == true and gvMission.Olaf == true then
		PrisonScene()
		Explore.Show( "ShowHunter", "hunterf", 2000 )
		Explore.Show( "ShowApple", "applef", 2000 )
		Explore.Show( "ShowCloister", "cloisterf", 2000 )
		AddFlag( {"hunterf",1,0} )
		AddFlag( {"applef",1,0} )
		AddFlag( {"cloisterf",0,1} )
	return true
	end
end

function PrisonScene()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cam3",""," ", true)
	briefing.finished = function()
		local cutscene={
		StartPosition={ zoom = 1800,rotation = -1,angle = 8,position = GetPosition( "cam3" ),},
		Flights={
			{
			position = GetPosition( "cam3" ),angle = 10,zoom = 1800,rotation = 1,duration = 10,delay = 1,
			title = tMat,
			text = "William, das ist der heruntergekommenste Kerker, den ich je zu Gesicht bekommen habe...",
			action = function()
				StartMusic("20_Evelance_Summer2.mp3", 153)
			end
			},
			{
			position = GetPosition( "p_wil_pos" ),angle = 15,zoom = 900,rotation = -35,duration = 10,delay = 1,
			title = tWil,
			text = "Hab Dank f�r dies Kompliment, Matthew! @cr Ihr seid ein wahrer Freund.",
			action = function()
				Move( "p_wil", "p_wil_pos" );Move( "p_mat", "p_mat_pos" )
			end
			},
			{
			position = GetPosition( "p_edw" ),angle = 9,zoom = 1100,rotation = 45,duration = 0,delay = 5,
			title = tEdw,
			text = "Pa, Freundschaft...",
			action = function()
				LookAt( "p_wil", "p_edw" );LookAt( "p_mat", "p_edw" );
			end
			},
			{
			position = GetPosition( "p_edw" ),angle = 9,zoom = 1100,rotation = 45,duration = 0,delay = 0,
			title = "",
			text = "",
			},
			{
			position = GetPosition( "p_edw" ),angle = 12,zoom = 1100,rotation = -45,duration = 15,delay = 0,
			title = tWil,
			text = mEdw.." Ihr sagtet, Ihr h�ttet Informationen. Also: Wo ist der K�nig?",
			},
			{
			position = GetPosition( "p_edw" ),angle = 45,zoom = 900,rotation = -15,duration = 0,delay = 0,
			title = "",
			text = "",
			},
			{
			position = GetPosition( "cam4" ),angle = 25,zoom = 1800,rotation = -20,duration = 15,delay = 1,
			title = tEdw,
			text = "Ihr habt ganz andere Probleme: @cr "..mBarc2.." hat einige Verb�ndete gesammelt, w�hrend Ihr mit der"..
					" Suche nach Eurem teuren K�nig besch�ftigt wart.",
			},
			{
			position = GetPosition( "cam5" ),angle = 12,zoom = 1000,rotation = -90,duration = 0,delay = 20,
			title = tEdw,
			text = "Zerfrisst es nicht Euer Gem�t, dass sowohl "..mSer.." , Eure Verlobte, als auch Euer �lterer Halbbruder"..
					" Graf "..mDev2.." sich mit dem Hammer gegen Euren geliebten K�nig verb�ndet haben?",
			},
			{
			position = GetPosition( "p_wil_pos" ),angle = 40,zoom = 800,rotation = 70,duration = 0,delay = 15,
			title = tWil,
			text = "Haltet Euer sch�ndliches Maul! @cr Matthew, verlasst das Verlie� und k�mmert Euch um Eure Siedlung."..
					" Ich m�chte ungest�rt sein mit diesem Verr�ter...",
			},
		},
		Callback=function()
			Briefing_Betrail()
		end,
	 }
	 StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end
function Briefing_Betrail()
	BRIEFING_CAMERA_FLYTIME = 14
	BRIEFING_ZOOMDISTANCE = 4500
	BRIEFING_ZOOMANGLE = 10
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ReplaceEntity("d_mat",Entities.PU_Hero4)
	ReplaceEntity("d_dev",Entities.PU_Hero10); LookAt("d_dev","d_mat")
	ReplaceEntity("d_barc",Entities.CU_BlackKnight); LookAt("d_barc","d_mat")
	ReplaceEntity("d_ser",Entities.CU_Princess); LookAt("d_ser","d_mat")
	
	AP{	
		title = "",
		text = "",
		position = GetPosition("cam6"),
		dialogCamera = false,
		action = function()
			StartMusic("20_Evelance_Summer2.mp3", 153)
			BRIEFING_ZOOMDISTANCE = 2500
			BRIEFING_ZOOMANGLE = 17
			Move( "d_mat","d_mat_pos" )
		end
	}
	AP{	
		title = tErz,
		text = "Auf dem R�ckweg in meine Festung traf ich auf Barcley, der mir ein Angebot machen wollte...",
		position = GetPosition("cam6"),
		dialogCamera = false,
		action = function()
			BRIEFING_CAMERA_FLYTIME = 0
			BRIEFING_TIMER_PER_CHAR = 1
			BRIEFING_DISTANCE1()
		end
	}
	ASP("d_barc",tBarc,"Ihr seid also dieser \"Matthew\". Ich h�tte gedacht, Ihr seid gr��er... @cr "..Mint.." HARRR"..
					" HARRR...", true)
	ASP("d_mat_pos",tMat,"Was will "..mBarc1.." von mir? Wollt Ihr mich meucheln?", true)
	ASP("d_barc",tBarc,"Nein, darum sind wir nicht hier. Aber warum fragt Ihr denn nicht "..mSer.." warum wir hier sind.", true)
	ASP("d_ser",tSer,"Nein, William ist dumm. Er steht auf der falschen Seite. Auf kurz oder lang werden die K�nigstreuen"..
					" besiegt...", true)
	ASP("d_dev",tDev,Grau.." franz�sischer Akzent "..Weiss.." @cr In der Tat und deshalb hat uns dieses Weibsbild �beredet Euch auf"..
					" unsere Seite zu ziehen.", true)
	ASP("d_ser",tSer,"Ihr seid wie ein Sohn f�r William. Wenn Ihr Euch uns anschlie�t, dann wird er erkennen, dass die"..
					" Treue zu einem \"unsichtbaren\" K�nig der falsche Weg ist.", true)
	ASP("d_barc",tBarc,"Wenn Ihr Euch MIR anschlie�t, winken Euch Titel und Macht in meinem neuen Reich. Also werdet Ihr"..
					" Euch uns anschlie�en?", true)
	ASP("d_mat_pos","Siedler Team",Gelb.." "..gvMission.Player.." "..Weiss.." , Ihr habt nun 30 Sekunden Zeit das Spiel zu"..
					" speichern. Wenn der Balken am linken Bildschirmrand abgelaufen ist, m�sst Ihr Eure Wahl treffen.", true)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		gvMission.InfoText1 = "Verbleibende Zeit"
		gvMission.Value1 = 30
		StartSimpleJob( "Briefing_Decide_Counter" )
		local pos = GetPosition( "matthew" )
		Camera.ScrollSetLookAt(pos.X,pos.Y)
		ReplaceEntity("d_mat",Entities.XD_ScriptEntity); ReplaceEntity("d_dev",Entities.XD_ScriptEntity)
		ReplaceEntity("d_barc",Entities.XD_ScriptEntity); ReplaceEntity("d_ser",Entities.XD_ScriptEntity)
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

DECIDECOUNTER = 30
function Briefing_Decide_Counter()
	DECIDECOUNTER = DECIDECOUNTER - 1
	Show_Infoline( 1, gvMission.InfoText1, DECIDECOUNTER, gvMission.Value1 )
	if DECIDECOUNTER == 0 then
		Briefing_Decide()
		Hide_Infoline( 1 )
	return true
	end
end

function Briefing_Decide()
	BRIEFING_DISTANCE1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ReplaceEntity("d_mat",Entities.PU_Hero4)
	ReplaceEntity("d_dev",Entities.PU_Hero10); LookAt("d_dev","d_mat")
	ReplaceEntity("d_barc",Entities.CU_BlackKnight); LookAt("d_barc","d_mat")
	ReplaceEntity("d_ser",Entities.CU_Princess); LookAt("d_ser","d_mat")
	
	local Spielverlauf = AP { 
		mc = {
			title   = "Siedler Team", 
			text   = Gelb.." "..gvMission.Player.." "..Weiss.." , f�r welchen Weg wollt Ihr Euch entscheiden? W�hlt weise,"..
						" denn Eure Entscheidung k�nnt Ihr nicht mehr R�ckg�ngig machen.", 
			firstText  = "Der Weg der "..Gelb.." Treue "..Weiss.." (William folgen)", 
			secondText = "Der Weg des "..Gelb.." Verrats "..Weiss.." (Barcley folgen)", 
			firstSelected = 2, 
			secondSelected = 4,  
		},
		position = GetPosition( "d_mat_pos" ),
		dialogCamera = true,
	}
	ASP("d_barc",tBarc,"Ihr habt soeben Eurer Todesurteil unterschrieben. Wenn wir uns das n�chste mal gegen�ber stehen,"..
						" wird mein Schwert Eure Brust aufrei�en!", true)
	
	AP()
	
	ASP("d_barc",tBarc,"Hervorragend, ich melde mich, sobald ich einen Auftrag f�r Euch habe.", true)	
	
	briefing.finished = function()
		DestroyEntity("d_mat");DestroyEntity("d_ser");DestroyEntity("d_barc");DestroyEntity("d_dev")
		MakeVulnerable( "bridge3" )
		if GetSelectedBriefingMCButton( Spielverlauf ) == 1 then 
			StartChapter7()
		else
			StartChapter10()
		end
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

-- # # # # # # # # # # # # # # # # # # # # # # # # # # --
-- Armeen vor der gesplitteten Handlung initialisieren
-- # # # # # # # # # # # # # # # # # # # # # # # # # # --

-- Barcley

function Defender_Barcley()
	local B_Army1 = {
	player = 4,					
	erstehungsPunkt = "Bspawn5", 
	ziel = {"Bspawn5","Bspawn6","Bspawn7"},
	lebensFaden = "Bgenerator1",
	tod = true,					
	zeit = B_Army1_Time,					 
	type = {29}, 	
	menge = B_Army1_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army1 = CreateRobArmee(B_Army1)
	StartArmee(B_Army1)
	
	local B_Army2 = {
	player = 4,					
	erstehungsPunkt = "Bspawn7", 
	ziel = {"Bspawn5","Bspawn6","Bspawn7"},
	lebensFaden = "Bgenerator3",
	tod = true,					
	zeit = B_Army2_Time,					 
	type = {29}, 	
	menge = B_Army2_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army2 = CreateRobArmee(B_Army2)
	StartArmee(B_Army2)
	
	local B_Army3 = {
	player = 4,					
	erstehungsPunkt = "Bspawn6", 
	ziel = {"Bspawn5","Bspawn6","Bspawn7"},
	lebensFaden = "Bgenerator2",
	tod = true,					
	zeit = B_Army3_Time,					 
	type = {29}, 	
	menge = B_Army3_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army3 = CreateRobArmee(B_Army3)
	StartArmee(B_Army3)
	
	local B_Army4 = {
	player = 4,					
	erstehungsPunkt = "Bspawn2", 
	ziel = {"Blife2","B_patrol2"},
	lebensFaden = "Blife2",
	tod = true,					
	zeit = B_Army4_Time,					 
	type = {13}, 	
	menge = B_Army4_Strength,					
	erfahrung = 0,				
	refresh = 3,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army4 = CreateRobArmee(B_Army4)
	StartArmee(B_Army4)
	
	local B_Army5 = {
	player = 4,					
	erstehungsPunkt = "Bspawn2", 
	ziel = {"Blife2","B_patrol2"},
	lebensFaden = "Blife2",
	tod = true,					
	zeit = B_Army5_Time,					 
	type = {18}, 	
	menge = B_Army5_Strength,					
	erfahrung = 0,				
	refresh = 2,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army5 = CreateRobArmee(B_Army5)
	StartArmee(B_Army5)
	
	local B_Army6 = {
	player = 4,					
	erstehungsPunkt = "BCspawn1", 
	ziel = {"BClife1","B_patrol3"},
	lebensFaden = "BClife1",
	tod = true,					
	zeit = B_Army6_Time,					 
	type = {34}, 	
	menge = B_Army6_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army6 = CreateRobArmee(B_Army6)
	StartArmee(B_Army6)
	
	local B_Army7 = {
	player = 4,					
	erstehungsPunkt = "Bspawn3", 
	ziel = {"Bspawn3","B_patrol1","mainspawn4"},
	lebensFaden = "Bstable1",
	tod = true,					
	zeit = B_Army7_Time,					 
	type = {8}, 	
	menge = B_Army7_Strength,					
	erfahrung = 0,				
	refresh = 3,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army7 = CreateRobArmee(B_Army7)
	StartArmee(B_Army7)
	
	local B_Army8 = {
	player = 4,					
	erstehungsPunkt = "BCspawn2", 
	ziel = {"BClife2","B_patrol2"},
	lebensFaden = "BClife2",
	tod = true,					
	zeit = B_Army8_Time,					 
	type = {34}, 	
	menge = B_Army8_Strength,					
	erfahrung = 0,				
	refresh = 2,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	B_Army8 = CreateRobArmee(B_Army8)
	StartArmee(B_Army8)
	
	--MachKumpel(K_Army1,K_Army2)
end

-- Deveraux

function Defender_Deveraux()
	local D_Army1 = {
	player = 3,					
	erstehungsPunkt = "Dspawn1", 
	ziel = {"Dspawn1"},
	lebensFaden = "Dbarracks1",
	tod = true,					
	zeit = D_Army1_Time,		 
	type = {12}, 	
	menge = D_Army1_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army1 = CreateRobArmee(D_Army1)
	StartArmee(D_Army1)
	
	local D_Army2 = {
	player = 3,					
	erstehungsPunkt = "Dspawn2", 
	ziel = {"Dspawn2"},
	lebensFaden = "Dbarracks2",
	tod = true,					
	zeit = D_Army2_Time,		 
	type = {18}, 	
	menge = D_Army2_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army2 = CreateRobArmee(D_Army2)
	StartArmee(D_Army2)
	
	local D_Army3 = {
	player = 3,					
	erstehungsPunkt = "Dspawn2", 
	ziel = {"Dspawn2"},
	lebensFaden = "Dbarracks2",
	tod = true,					
	zeit = D_Army3_Time,		 
	type = {12}, 	
	menge = D_Army3_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army3 = CreateRobArmee(D_Army3)
	StartArmee(D_Army3)
	
	local D_Army4 = {
	player = 3,					
	erstehungsPunkt = "Dspawn1", 
	ziel = {"Dspawn1"},
	lebensFaden = "Dbarracks1",
	tod = true,					
	zeit = D_Army4_Time,		 
	type = {4}, 	
	menge = D_Army4_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army4 = CreateRobArmee(D_Army4)
	StartArmee(D_Army4)
	
	local D_Army5 = {
	player = 3,					
	erstehungsPunkt = "Dspawn1", 
	ziel = {"Dspawn1"},
	lebensFaden = "Dbarracks1",
	tod = true,					
	zeit = D_Army5_Time,		 
	type = {14}, 	
	menge = D_Army5_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army5 = CreateRobArmee(D_Army5)
	StartArmee(D_Army5)
	
	local D_Army6 = {
	player = 3,					
	erstehungsPunkt = "Dspawn2", 
	ziel = {"Dspawn2"},
	lebensFaden = "Dbarracks2",
	tod = true,					
	zeit = D_Army6_Time,		 
	type = {14}, 	
	menge = D_Army6_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army6 = CreateRobArmee(D_Army6)
	StartArmee(D_Army6)
	
	local D_Army7 = {
	player = 3,					
	erstehungsPunkt = "DCspawn1", 
	ziel = {"DCspawn1"},
	lebensFaden = "Darchery1",
	tod = true,					
	zeit = D_Army7_Time,		 
	type = {33}, 	
	menge = D_Army7_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army7 = CreateRobArmee(D_Army7)
	StartArmee(D_Army7)
	
	local D_Army8 = {
	player = 3,					
	erstehungsPunkt = "DCspawn2", 
	ziel = {"DCspawn2"},
	lebensFaden = "Darchery2",
	tod = true,					
	zeit = D_Army8_Time,		 
	type = {33}, 	
	menge = D_Army8_Strength,					
	erfahrung = 3,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 4000,		
	endAktion = function()
    end
	}
	D_Army8 = CreateRobArmee(D_Army8)
	StartArmee(D_Army8)
	
	for i = 1,5 do
		local pos = GetPosition("DevDeffer"..i)
		SetEntityName(Tools.CreateGroup(3, Entities.PU_LeaderRifle1, 8, pos.X, pos.Y, 180.00 ),"dDeff"..i)
	end
	function DeverauxWallDefender()
		if IsExisting("Dbarracks1") and IsExisting("HQFalcon")then
			for i= 1,5 do
				if IsDeadWrapper("dDeff"..i)then
					local pos = GetPosition("Dspawn1")
					SetEntityName(Tools.CreateGroup(3, Entities.PU_LeaderRifle1, 8, pos.X, pos.Y, 180.00 ),"dDeff"..i)
					Move( "dDeff"..i,"DevDeffer"..i )
				end
			end
		else
			return true
		end
	end
	StartSimpleJob("DeverauxWallDefender")
end

-- Seren

function Defender_King()
	local K_Army1 = {
	player = 2,					
	erstehungsPunkt = "Kspawn1", 
	ziel = {"K_patrol1"},
	lebensFaden = "Kbarracks1",
	tod = true,					
	zeit = K_Army1_Time,					 
	type = {14}, 	
	menge = K_Army1_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	K_Army1 = CreateRobArmee(K_Army1)
	StartArmee(K_Army1)
	
	local K_Army2 = {
	player = 2,					
	erstehungsPunkt = "Kspawn1", 
	ziel = {"K_patrol2"},
	lebensFaden = "Kbarracks1",
	tod = true,					
	zeit = K_Army2_Time,					 
	type = {12}, 	
	menge = K_Army2_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	K_Army2 = CreateRobArmee(K_Army2)
	StartArmee(K_Army2)
	
	local K_Army3 = {
	player = 2,					
	erstehungsPunkt = "Kspawn3", 
	ziel = {"Kspawn3", "Kspawn4", },
	lebensFaden = "Kbarracks2",
	tod = true,					
	zeit = K_Army3_Time,					 
	type = {14}, 	
	menge = K_Army3_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	K_Army3 = CreateRobArmee(K_Army3)
	StartArmee(K_Army3)
	
	local K_Army4 = {
	player = 2,					
	erstehungsPunkt = "Kspawn3", 
	ziel = {"Kspawn3", "Kspawn4", },
	lebensFaden = "Kbarracks2",
	tod = true,					
	zeit = K_Army4_Time,					 
	type = {8}, 	
	menge = K_Army4_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	K_Army4 = CreateRobArmee(K_Army4)
	StartArmee(K_Army4)
	
	local K_Army5 = {
	player = 2,					
	erstehungsPunkt = "Kspawn2", 
	ziel = {"K_patrol1","K_patrol2",},
	lebensFaden = "Karchery1",
	tod = true,					
	zeit = K_Army5_Time,					 
	type = {34}, 	
	menge = K_Army5_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	K_Army5 = CreateRobArmee(K_Army5)
	StartArmee(K_Army5)
	
	local K_Army6 = {
	player = 2,					
	erstehungsPunkt = "Kspawn4", 
	ziel = {"Kspawn3","Kspawn4",},
	lebensFaden = "Karchery2",
	tod = true,					
	zeit = K_Army6_Time,					 
	type = {34}, 	
	menge = K_Army6_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 5000,		
	endAktion = function()
    end
	}
	K_Army6 = CreateRobArmee(K_Army6)
	StartArmee(K_Army6)
	
	MachKumpel(K_Army1,K_Army2)
	MachKumpel(K_Army1,K_Army5)
	MachKumpel(K_Army4,K_Army3)
	MachKumpel(K_Army3,K_Army6)
end

function Defender_Seren()
	local S_Army1 = {
	player = 2,					
	erstehungsPunkt = "mainspawnS", 
	ziel = {"S_patrol1","S_patrol2","S_patrol3","S_patrol4"},
	lebensFaden = "HQSeren",
	tod = true,					
	zeit = S_Army1_Time,					 
	type = {6}, 	
	menge = S_Army1_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 1500,		
	endAktion = function()
    end
	}
	S_Army1 = CreateRobArmee(S_Army1)
	StartArmee(S_Army1)
	
	local S_Army2 = {
	player = 2,					
	erstehungsPunkt = "mainspawnS", 
	ziel = {"S_patrol1","S_patrol2","S_patrol3","S_patrol4"},
	lebensFaden = "HQSeren",
	tod = true,					
	zeit = S_Army2_Time,					 
	type = {6}, 	
	menge = S_Army2_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 1500,		
	endAktion = function()
    end
	}
	S_Army2 = CreateRobArmee(S_Army2)
	StartArmee(S_Army2)
	
	local S_Army3 = {
	player = 2,					
	erstehungsPunkt = "mainspawnS", 
	ziel = {"S_patrol1","S_patrol2","S_patrol3","S_patrol4"},
	lebensFaden = "HQSeren",
	tod = true,					
	zeit = S_Army3_Time,					 
	type = {18}, 	
	menge = S_Army3_Strength,					
	erfahrung = 0,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 1500,		
	endAktion = function()
    end
	}
	S_Army3 = CreateRobArmee(S_Army3)
	StartArmee(S_Army3)
	
	MachKumpel(S_Army1,S_Army2)
	MachKumpel(S_Army1,S_Army3)
	MachKumpel(S_Army2,S_Army3)
	
	for i = 1,8 do
		local pos = GetPosition("sdefpos"..i)
		SetEntityName(Tools.CreateGroup(2, Entities.PU_LeaderBow2, 8, pos.X, pos.Y, 180.00 ),"sdef"..i)
	end
	function SerenWallDefender()
		if IsExisting("lifeSeren") and IsExisting("HQSeren")then
			for i= 1,8 do
				if IsDeadWrapper("sdef"..i)then
					local pos = GetPosition("Se_spawn1")
					SetEntityName(Tools.CreateGroup(2, Entities.PU_LeaderBow2, 4, pos.X, pos.Y, 180.00 ),"sdef"..i)
					Move( "sdef"..i,"sdefpos"..i )
				end
			end
		else
			return true
		end
	end
	StartSimpleJob("SerenWallDefender")
end

-- William

function Defender_William()
	local W_Army1 = {
	player = 2,					
	erstehungsPunkt = "Wspawn3", 
	ziel = {"Wpatrol2_1","Wpatrol2_2"},
	lebensFaden = "Wbarracks1",
	tod = true,					
	zeit = W_Army1_Time,					 
	type = {11}, 	
	menge = W_Army1_Strength,					
	erfahrung = 2,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	W_Army1 = CreateRobArmee(W_Army1)
	StartArmee(W_Army1)
	
	local W_Army2 = {
	player = 2,					
	erstehungsPunkt = "Wspawn1", 
	ziel = {"Wpatrol1_2","Wpatrol1_1"},
	lebensFaden = "Warchery2",
	tod = true,					
	zeit = W_Army2_Time,					 
	type = {32}, 	
	menge = W_Army2_Strength,					
	erfahrung = 2,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	W_Army2 = CreateRobArmee(W_Army2)
	StartArmee(W_Army2)
	
	local W_Army3 = {
	player = 2,					
	erstehungsPunkt = "Wspawn2", 
	ziel = {"Wpatrol2_2","Wpatrol2_1"},
	lebensFaden = "Wbarracks1",
	tod = true,					
	zeit = W_Army3_Time,					 
	type = {2}, 	
	menge = W_Army3_Strength,					
	erfahrung = 2,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	W_Army3 = CreateRobArmee(W_Army3)
	StartArmee(W_Army3)
	
	local W_Army4 = {
	player = 2,					
	erstehungsPunkt = "Wspawn4", 
	ziel = {"Wpatrol1_2","Wpatrol1_1"},
	lebensFaden = "Wbarracks2",
	tod = true,					
	zeit = W_Army4_Time,					 
	type = {18}, 	
	menge = W_Army4_Strength,					
	erfahrung = 2,				
	refresh = 1,				
	scharf = true,				
	kriegRadius = 2000,		
	endAktion = function()
    end
	}
	W_Army4 = CreateRobArmee(W_Army4)
	StartArmee(W_Army4)
	
	MachKumpel(W_Army1,W_Army3)
	MachKumpel(W_Army2,W_Army4)
	
	for i = 1,4 do
		local pos = GetPosition("Wdef"..i)
		SetEntityName(Tools.CreateGroup(2, Entities.PU_LeaderBow3, 8, pos.X, pos.Y, 180.00 ),"Wwalldef"..i)
	end
	function WilliamWallDefender()
		if IsExisting("Wbarracks2") and IsExisting("HQWilliam")then
			for i= 1,4 do
				if IsDeadWrapper("Wwalldef"..i)then
					local pos = GetPosition("Wspawn4")
					SetEntityName(Tools.CreateGroup(2, Entities.PU_LeaderBow3, 8, pos.X, pos.Y, 180.00 ),"Wwalldef"..i)
					Move( "Wwalldef"..i,"Wdef"..i )
				end
			end
		else
			return true
		end
	end
	StartSimpleJob("WilliamWallDefender")
end

-- # # # # # # # # # # # # # # # # # # # # # # # # # # --
-- Gleichbleibende Cams und Functions
-- # # # # # # # # # # # # # # # # # # # # # # # # # # --

function CombatScene()
	local pos = GetPosition("bc_barc")
	SetEntityName(Tools.CreateGroup(4, Entities.CU_BlackKnight, 0, pos.X, pos.Y, 270.00 ),"cambarc")
	local pos = GetPosition("bc_dev_pos1")
	SetEntityName(Tools.CreateGroup(3, Entities.PU_Hero10, 0, pos.X, pos.Y, 180.00 ),"camdev")
	Move("camdev","bc_dev_pos2")
	for i=1,12 do
		local pos = GetPosition("bc_bupos"..i)
		SetEntityName(Tools.CreateGroup(4, Entities.PU_LeaderHeavyCavalry2, 3, pos.X, pos.Y, 270.00 ),"bc_bu"..i)
		GUI.LeaderChangeFormationType( GetEntityId("bc_bu"..i), 4 )
	end
	for j=1,12 do
		CreateMilitaryGroup	( 3,Entities.PU_LeaderRifle2,8,GetPosition("bc_dev_pos1"),"bc_du"..j )
		GUI.LeaderChangeFormationType(GetEntityId("bc_du"..j), 4 )
		Move("bc_du"..j,"bc_dupos"..j)
	end
	Display.SetPlayerColorMapping(6,6)
	Display.GfxSetSetSkyBox(1, 1.0, 1.0, "YSkyBox04")
	Display.GfxSetSetRainEffectStatus(1, 1, 1, 1)
	Display.GfxSetSetFogParams(1, 0, 1, 1, 102, 132, 142, 3000, 8000)
	Display.GfxSetSetLightParams(1, 0, 1, 40, -15, -50, 120, 110, 110, 205, 204, 180)
	SetHostile( 6, 3 ) SetHostile( 6, 4 )
	
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_ZOOMDISTANCE = 2100
	BRIEFING_ZOOMANGLE = 10
	AP{	
		title = tErz,
		text = "Die Feinde des K�nigs trafen sich, um einen vernichtenden Schlag gegen die K�nigstreuen vorzubereiten...",
		position = GetPosition("bc_bupos4"),
		dialogCamera = false,
		action = function()
			BRIEFING_DISTANCE1()
			Display.SetRenderFogOfWar(0)
		end
	}
	
	briefing.finished = function()
		local cutscene={
		StartPosition={ zoom = 1700,rotation = -74,angle = 23,position = GetPosition( "bc_dupos10" ),},
		Flights={
			{
			position = GetPosition( "bc_dev_pos2" ),angle = 12,zoom = 1000,rotation = -100,duration = 15,delay = 1,
			title = tDev,
			text = "Hier bin ich, du alter Hexer. @cr Wo ist dieses Weibsbild? Hatte sie nicht versprochen, uns ihre Truppen"..
					" zu stellen, damit wir meinen l�stigen Bruder umbringen k�nnen?",
			action = function()
				LookAt("cambarc","camdev") LookAt("camdev","cambarc")
			end
			},
			{
			position = GetPosition( "bc_bupos1" ),angle = 9,zoom = 3000,rotation = 80,duration = 0,delay = 0,
			title = tBarc,
			text = "Warum seid IHR so hei� drauf, William zu erledigen? Euren Besitz hat er doch niemals angetastet."..
					" Oder ist es vielleicht, weil Ihr die Verlobte Eures Bruders als Euer wissen wollt? Ist das nicht"..
					" gegen irgend so ein Gebot? @cr "..Mint.." HARRR HARRR...",
			},
			{
			position = GetPosition( "bc_barc" ),angle = 9,zoom = 1000,rotation = 70,duration = 22,delay = 0,
			title = tBarc,
			text = "Warum seid IHR so hei� drauf, William zu erledigen? Euren Besitz hat er doch niemals angetastet."..
					" Oder ist es vielleicht, weil Ihr die Verlobte Eures Bruders als Euer wissen wollt? Ist das nicht"..
					" gegen irgend so ein Gebot? @cr "..Mint.." HARRR HARRR...",
			action = function()
				StartSimpleJob("TheLightning1") StartSimpleJob("TheLightning2") StartSimpleJob("TheLightning3")
			end
			},
			{
			position = GetPosition( "bc_dev_pos2" ),angle = 11,zoom = 500,rotation = -140,duration = 0,delay = 5,
			title = tDev,
			text = "Haltet Euer Maul, oder ich lasse Euch auf dem "..Gruen.." Scheiterhaufen "..Weiss.." verbrennen.",
			},
			{
			position = GetPosition( "bc_bupos1" ),angle = 8,zoom = 2400,rotation = 115,duration = 0,delay = 0,
			title = "",
			text = "",
			},
			{
			position = GetPosition( "bc_barc" ),angle = 31,zoom = 900,rotation = 170,duration = 12,delay = 1,
			title = tBarc,
			text = "Ruhig, Froschfresser. Wir sind nicht hier um zu streiten. @cr Wo bleibt Lady Seren? Hat sie in ihrer"..
					" geliebten Abtei noch nicht genug gebetet? @cr "..Mint.." HARRR HARRR...",
			action = function()
			end
			},
			{
			position = GetPosition( "bc_dev_pos2" ),angle = 23,zoom = 1100,rotation = -45,duration = 0,delay = 5,
			title = tDev,
			text = "Was ist das? @cr Ich h�re Hufe auf den Boden schlagen...",
			action = function()
				LookAt( "camdev","bc_ser_pos1" ) LookAt( "cambarc","bc_ser_pos1" )
			end
			},
			{
			position = GetPosition( "bc_dupos12" ),angle = 73,zoom = 1500,rotation = -45,duration = 0,delay = 0,
			title = "",
			text = "",
			action = function()
				for i= 1,12 do
					local pos = GetPosition("bc_ser_pos1")
					SetEntityName(Tools.CreateGroup(6, Entities.PU_LeaderCavalry2, 3, pos.X, pos.Y, 180.00 ),"bc_su"..i)
					Attack( "bc_su"..i,"bc_bupos"..i )
					Attack( "bc_bu"..i,"bc_ser_pos1" )
					Logic.SetGlobalInvulnerability(0)
				end
			end
			},
			{
			position = GetPosition( "bc_ser_pos1" ),angle = 24,zoom = 2000,rotation = -45,duration = 7,delay = 8,
			title = tBarc,
			text = "Verrat!!! @cr Wir werden angegriffen! Lady Seren will nun doch William in den Tod folgen."..
					" KANN SIE HABEN...",
			},
		},
		Callback=function()
			DestroyEntity( "cambarc" ) DestroyEntity( "camdev" )
			for i= 1,12 do DestroyEntity( "bc_bu"..i ) end
			for j= 1,12 do DestroyEntity( "bc_du"..j ) end
			for k= 1,12 do DestroyEntity( "bc_su"..k ) end
			SetupNormalWeatherGfxSet()
			Display.SetPlayerColorMapping(6,9)
			SetNeutral( 6, 3 ) SetNeutral( 6, 4 )
			Hide_Infoline( 1 )
			if gvMission.WayChosed == 1 then
				Briefing_NachBarcleyInvasion()
			elseif gvMission.WayChosed == 2 then
				Briefing_NachWilliamInvasion()
			end
		end,
	 }
	 StartCutscene(cutscene)
	 StartMusic("03_CombatEurope1.mp3", 117)
	end
	StartBriefing(briefing)
end
function TheLightning1()
	if Counter.Tick2("TheLightning1",3)then
		local pos = GetPosition("lightning1")
		Logic.CreateEffect( GGL_Effects.FXLightning, pos.X, pos.Y, 1 )
		Sound.PlayGUISound( Sounds.Military_SO_CannonHit_rnd_1, 40 )
	return true
	end
end
function TheLightning2()
	if Counter.Tick2("TheLightning2",5)then
		local pos = GetPosition("lightning2")
		Logic.CreateEffect( GGL_Effects.FXLightning, pos.X, pos.Y, 1 )
		Sound.PlayGUISound( Sounds.Military_SO_CannonHit_rnd_1, 40 )
	return true
	end
end
function TheLightning3()
	if Counter.Tick2("TheLightning3",6)then
		local pos = GetPosition("lightning3")
		Logic.CreateEffect( GGL_Effects.FXLightning, pos.X, pos.Y, 1 )
		Sound.PlayGUISound( Sounds.Military_SO_CannonHit_rnd_1, 40 )
	return true
	end
end

function InitialisizePrison()
	local IO = {
		Name 		 = "prison1",
		Type 		 = 3,
		Range		 = 700,
		Button		 = "Research_Banking",
		WinSize		 = "normal",
		Title		 = "Plumpsklo",
		Text		 = "Eine arme Seele wurde von dem b�sen Wikinger Olaf Grimzahn in diesem Plumpsklo eingeschlossen. Schnell, eilt Euch,"..
						" Ihr k�nnt den armen Mann nicht l�nger diesem Gestank aussetzen.",
		Callback	 = function()
			local pos = GetPosition("scholarPos1")			
			Logic.CreateEffect( GGL_Effects.FXKalaPoison, pos.X, pos.Y, 1 )
			SetEntityName(Tools.CreateGroup(8, Entities.CU_GCScholar, 0, pos.X, pos.Y, 225.00 ),"scholar1")
			Briefing_ScholarFree()
		end,
	}
	Interactive_Setup( IO )
end
function Briefing_ScholarFree()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	local pos = GetPosition("scholar1")
	local hero = {Logic.GetPlayerEntitiesInArea( 1, 0, pos.X, pos.Y, 1000, 16 )}
	Logic.SetTaskList( GetEntityId("scholar1"), TaskLists.TL_GC_SCHOLAR_TALK2 )
	table.remove(hero, 1)
	for i=1,table.getn(hero)do
		if Logic.IsHero(hero[i])== 1 then
			Logic.EntityLookAt(GetEntityId("scholar1"),hero[i])
			Logic.EntityLookAt(hero[i],GetEntityId("scholar1"))
		end
	end
	
	ASP("scholar1",tGut,"Danke, Ihr habt mich befreit. Tage sa� ich da in diesem Mief. Ihr fragt Euch jetzt sicher, wie ich darin"..
						" gelandet bin? Nun ja, das war so:", true)
	ASP("scholar1",tGut,"Ich bin ein vielbesch�ftigter, junger Familienvater. Leider hatte ich vielzu hohe"..
						" Selbstanspr�che. Deshalb habe ich meine Doktorarbeit via "..Gelb.." Wikipedia "..Weiss.." zusammengesetzt und"..
						" gehofft, dass es keiner merkt. Aber leider bin ich aufgeflogen nachdem ich von Barcley in den"..
						" Wissenschaftsstab berufen wurde.", true)
	ASP("scholar1",tGut,"Barcley wollte mich mit einer Kanone t�ten, aber ich schlug ihm ein Schnippchen und "..Gelb.." ritt "..Weiss..""..
						" auf der Kugel davon. Und dann landete ich hier. So ein mieser Wikinger hat mich dann auf seinem Plumpsklo"..
						" eingesperrt...", true)
	ASP("scholar1",tGut,"Aber nun bin ich ja frei.", true)
	
	briefing.finished = function()
		ReplaceEntity("scholar1",Entities.CU_GCScholar)
		gvMission.ScholarFree = true
	end
	StartBriefing(briefing)
end

-- # # # # # # # # # # # # # # # # # # # # # # # # # # --
-- WEG DER TREUE
-- # # # # # # # # # # # # # # # # # # # # # # # # # # --

-- # # # # # # # # # # CHAPTER 7 # # # # # # # # # # --

function StartChapter7()
	SetFriendly( 1, 2)
	SetHostile( 1, 4 )
	SetHostile( 1, 3 )
	gvMission.WayChosed = 1
	ReplaceEntity( "sperre1", Entities.XD_Rock7 ) ReplaceEntity( "sperre9", Entities.XD_Rock7 )
	ReplaceEntity( "sperre10", Entities.XD_Rock7 )
	Logic.RemoveQuest( 1, 1 ) Logic.RemoveQuest( 1, 2 ) Logic.RemoveQuest( 1, 3 ) Logic.RemoveQuest( 1, 4 )
	
	Briefing_Chapter7()
	for i=1,15 do DestroyEntity("KEtower"..i)end
	S_Army1_Strength = S_Army1_Strength/3; S_Army2_Strength = S_Army2_Strength/3; S_Army3_Strength = S_Army3_Strength/3
	K_Army1_Strength = K_Army1_Strength/3; K_Army2_Strength = K_Army2_Strength/3; K_Army3_Strength = K_Army3_Strength/3
	K_Army4_Strength = K_Army4_Strength/3; K_Army5_Strength = K_Army5_Strength/3; K_Army6_Strength = K_Army6_Strength/3
	W_Army1_Strength = W_Army1_Strength/3; W_Army2_Strength = W_Army2_Strength/3; W_Army3_Strength = W_Army3_Strength/3 
	W_Army4_Strength = W_Army4_Strength/3
	
	Defender_Barcley()
	Defender_Deveraux()
	Defender_Seren()
	Defender_William()
end

-- #### QUESTS #### --

function Briefing_Chapter7()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cloister",""," ", true)
	briefing.finished = function()
		local cutscene={
		StartPosition={ zoom = 4200,rotation = -30,angle = 11,position = GetPosition( "cloister" ),},
		Flights={
			{
			position = GetPosition( "cloister" ),angle = 12,zoom = 2500,rotation = 5,duration = 10,delay = 5,
			title = Gruen.." KAPITEL VII:",
			text = Gelb.." DIE VERTEIDIGUNG DER ABTEI",
			},
		},
		Callback=function()
			BRIEFING_DISTANCE1()
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			
			ASP("HQHammer",tBarc,"Ihr habt Euch mir nicht angeschlossen und damit Euren letzten Fehler begangen. "..mMat.." , ich"..
								" Ich werde Euch h�uten und Euer geg�rbtes Leder vor Williams Schloss aufh�ngen... @cr "..Mint..""..
								" HARRR HARRR...", false)
			ASP("HQSteele",tSim,"Master Steele, gebt acht vor den Rittern Barcleys. Sie gelten als unbesiegbar... Wir mussen uns"..
							" etwas einfallen lassen oder wir werden unter den Hufen der Pferde zermalmt.", false)
			ASP("HQSteele",tSim,"Soll ich einen Boten zu "..mWil.." schicken, damit er uns Hilfe sendet?", false)
			local Hilfe = AP { 
				mc = {
					title   = "Siedler Team", 
					text   = Gelb.." "..gvMission.Player.." "..Weiss.." , jetzt m�sst Ihr entscheiden. Denkt Ihr, "..mBarc1..""..
								" k�nnte Euch gef�hrlich werden?", 
					firstText  = "Nein, den schaffe ich mit Links.", 
					secondText = "Ja, ich k�nnte Hilfe gebrauchen.", 
					firstSelected = 7, 
					secondSelected = 10,  
				},
				position = GetPosition( "matthew" ),
				dialogCamera = true,
			}
			
			ASP("matthew",tMat,"Nein, meine Leute werden Barcleys Reiter schon aufhalten...", true)
			ASP("HQSteele",tSim,"Seid Ihr Euch sicher? Nun gut. Wir m�ssen Barcley aufhalten. Wir m�ssen seine Leute stoppen.", false)
			
			AP()
			
			ASP("matthew",tMat,"Sendet den Boten. Noch bin ich nicht stark genug, mich "..mBarc3.." entgegenzustellen.", true)
			ASP("HQSteele",tSim,"Der Bote ist auf dem Weg. Unsere Aufgabe ist es, den feindlichen Angriffen standzuhalten."..
								" Williams Leute werden uns das �BERleben leichter machen.", false)
			
			briefing.finished = function()
				Write_Quest5() Quest5()
				if GetSelectedBriefingMCButton( Hilfe ) == 2 then 
					CreateEntity( 8, Entities.PU_LeaderCavalry1, GetPosition("doorpos"), "bote1" )
					Move("bote1","william",400)
					local quest = {
					EntityName = "bote1",TargetName = "william",Distance = 1000,
					Callback = function(_Quest)
						LookAt("william","bote1"); LookAt("bote1","william")
						BRIEFING_DISTANCE1()
						local briefing = {restoreCamera = true}
						local AP, ASP = AddPages(briefing)
						
						ASP("william",tBot1,mMat.." sandte mich zu Euch. Barcley will ihn belagern. Matthew l�sst fragen ob Ihr"..
										" ihm helfen werdet.", true)
						ASP("william",tWil,"Wie k�nnte ich seine Bitte verweigern? Ich werde ihm Truppen schicken.", true)
						
						briefing.finished = function()
							Display.SetRenderFogOfWar(1)
							gvMission.SupPos = "conversation"
							gvMission.SupType = Entities.PU_LeaderPoleArm3
							gvMission.Support = true
							gvMission.SAmount = 8
							Wsupp = StartSimpleJob("CheckWilliamSupport")
							DestroyEntity("bote1")
						end
						StartBriefing(briefing)
					end
					}
					SetupExpedition(quest)
				end
			end
			StartBriefing(briefing)
			Display.SetRenderFogOfWar(0)
		end,
	 }
	 StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end
function Write_Quest5()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL VII: Die Verteidigung der Abtei"
	local questtext	 =	mOlaf.." war tot, "..mEdw.." in Williams Kerker. "..mBarc2.." hatte zwar versucht, mich auf seine"..
						" Seite zu ziehen, aber Versprechen wie Titel, Macht und Ruhm konnten mich nicht beeindrucken."..
						" Ehre ist alles was z�hlt und jemand der seine Fahne in den Wind h�ngt, die am st�rksten weht,"..
						" der hat keine Ehre. @cr Lord Barcley und seine Anh�ngerschaft versuchten nun mich ins Jenseits"..
						" zu bef�rdern. Eine gewaltige Invasion stand mir bevor. @cr @cr "..NZ.." "..
						" - TOD: "..mMat.." @cr - GEB�UDE: - Bergfried verlieren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Barcleys Invasion"
	local questtext	 =	" Ich verrate meine Leute nicht. Deshalb sah ich mich einem Angriff Barcleys ausgesetzt..."..
						" @cr @cr "..SZ.." - BESIEGEN: Alle feindlichen Invasoren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end
function Quest5()
	local pos = GetPosition( "matthew" )
	Camera.ScrollSetLookAt(pos.X,pos.Y)
	gvMission.InfoText1 = "Verbleibende Invasionen"
	gvMission.Value1 = 6
	StartSimpleJob( "StopBarcleyInvasion" )
	Invasion_Barcley()
end

-- +++ Invasion Barcley Start +++ --

BARCLAYINVASIONCOUNTER = 7

function Invasion_Barcley()
	BarcleyTable = {}
	BarcleyTime = BarcIn_Time
	BARCLAYINVASIONCOUNTER = BARCLAYINVASIONCOUNTER - 1
	if BARCLAYINVASIONCOUNTER > 0 then
		for i=1,BarcIn_Strength do
			CreateMilitaryGroup( 4,Entities.PU_LeaderHeavyCavalry2,3,GetPosition("invasion1"),"BarcleyAttacker"..i )
			GUI.LeaderChangeFormationType(GetEntityId("BarcleyAttacker"..i), 4 )
			table.insert(BarcleyTable,GetEntityId("BarcleyAttacker"..i))
		end
		StartSimpleJob( "Invasion_Barcley_Control" )
	end
end
function Invasion_Barcley_Control()
	if AreDead( BarcleyTable )then
		if BARCLAYINVASIONCOUNTER > 1 then
			BarcleyTime = BarcleyTime -1
			if BarcleyTime == 0 then
				BarcIn_Strength = BarcIn_Strength + BarcIn_Addition
				Invasion_Barcley()
				return true
			end
		else
			Invasion_Barcley()
		return true
		end
	else
		if Counter.Tick2("Invasion_Barcley_Control",5)then
			for i=1,table.getn( BarcleyTable )do
				if AreEnemiesInArea( 4, GetPosition(BarcleyTable[i]), 2000 )then
					Attack(BarcleyTable[i], "HQSteele" )
				else
					Move(BarcleyTable[i], "HQSteele" )
				end
			end
		end
	end
end
function StopBarcleyInvasion()
	if BARCLAYINVASIONCOUNTER > 0 then
		Show_Infoline( 1, gvMission.InfoText1, BARCLAYINVASIONCOUNTER-1, gvMission.Value1 )
	elseif BARCLAYINVASIONCOUNTER == 0 then
		if Wsupp then EndJob(Wsupp)end
		CombatScene()
	return true
	end
end

-- +++ Invasion Barcley Ende +++ --

-- +++ William Support Start +++ --

function CheckWilliamSupport()
	local nachschub = true
	for i=1,gvMission.SAmount do
		if not(IsExisting("williSupporter"..i))then
			if IsExisting("HQWilliam") and gvMission.Support == true and nachschub == true then
				CreateMilitaryGroup( 1,gvMission.SupType,8,GetPosition("mainspawnW"),"williSupporter"..i )
				GUI.LeaderChangeFormationType(GetEntityId("williSupporter"..i), 4 )
				Move( "williSupporter"..i,gvMission.SupPos )
				nachschub = false
			end
		end
	end
end

-- +++ William Support Ende +++ --

function Briefing_NachBarcleyInvasion()
	BRIEFING_DISTANCE3()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	AP{	
		title = tBarc,
		text = Mint.." ARRR... "..Weiss.." @cr Ich bin nur von unf�higen T�lpeln umgeben...",
		position = GetPosition("HQHammer"),
		dialogCamera = false,
		action = function()
			BRIEFING_DISTANCE1()
		end
	}
	ASP("matthew",tSim,"Mein Herr, Ihr habt die Invasion �berlebt... @cr Ihr solltet jetzt mit "..mWil.." sprechen."..
					" Er hat einen wichtigen Auftrag f�r Euch.",true)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		WriteQuest6()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function WriteQuest6()
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Barcleys Invasion"
	local questtext	 =	"Ich verrate meine Leute nicht. Deshalb sah ich mich einem Angriff Barcleys ausgesetzt..."..
						" @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Audienz"
	local questtext	 =	"Nachdem die Truppen des Hammers zur�ckgeschlagen wurden, lie� mich William rufen. Ich z�gerte"..
						" nicht diese Audienz wahrzunehmen... @cr @cr "..SZ.." - sprecht mit Sir William"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	BriefingWilliam1()
end

function BriefingWilliam1()
	EnableNpcMarker(GetEntityId("william"))
	local quest = {
	EntityName = "matthew",TargetName = "william",Distance = 500,
	Callback = function(_Quest)
		DisableNpcMarker(GetEntityId("william")); LookAt("william","matthew"); LookAt("matthew","william");
		BRIEFING_DISTANCE1()
		local briefing = {restoreCamera = true}
		local AP, ASP = AddPages(briefing)
		
		ASP("matthew",tMat,"Ihr lie�et mich rufen, "..Gelb.." Master "..Weiss.." William?",true)
		ASP("william",tWil,"Jetzt unterlasst endlich dieses Mastergerede... @cr Ja ich lie� Euch rufen. Meine Spione berichten,"..
							" dass Barcley einen Angriff auf das Kloster von Lady Seren plant.",true)
		ASP("matthew",tMat,"Aber sie geh�rt zu denen die versuchen...",true)
		ASP("william",tWil,"... uns f�r ihren unehrenhaften Kampf zu gewinnen. Ich wei�. Aber Lady Seren interessierte von"..
							" Anfang an nur mein Wohl. Sie wollte den K�nig nie verraten, sie wollte nur das ich �berlebe.",true)
		ASP("matthew",tMat,"Was soll ich tun?",true)
		ASP("cloister",tWil,"Lady Seren besch�tzt die Abtei, in der sie aufgewachsen ist. Ich habe den M�nchen geholfen"..
							" eine heilige Reliquie wiederzubeschaffen.",false)
		ASP("william",tWil,"Und genau das ist es, was "..mBarc1.." in seine Finger bekommen will. Deshalb war er auch so entz�ckt"..
							" Lady Seren scheinbar f�r seinen Verrat eingenommen zu haben.",true)
		ASP("matthew",tMat,"Was ist das f�r eine Reliquie?",true)
		ASP("william",tWil,"Das "..Gruen.." Heilige Zepter "..Weiss.." . @cr Nur mit dieser Reliquie kann ein neuer K�nig"..
							" eingesetzt werden. Deshalb darf Barcley "..Grau.." NIEMALS "..Weiss.." in den Besitz der"..
							" Reliquie kommen!",true)
		ASP("cloisterf",tWil,"Die Provinz darf nicht in die H�nde der Feinde fallen. "..Grau.." Weder "..Weiss.." Barcley"..
							" "..Grau.." noch "..Weiss.." Deveraux d�rfen hier ihre Flagge hissen. Wenn doch, habt Ihr nicht"..
							" viel Zeit die Flagge zur�ckzuhohlen.",false)
		ASP("matthew",tMat,"Wer ist dieser Deveraux?",true)
		ASP("william",tWil,"Deveraux wird auch "..mDev1.." genannt. Er ist Franzose und, wie Ihr wisst, mein Halbbruder. Aber er wurde"..
							" von seiner Mutter zu einem Franzosen erzogen. Und Franzosen sind ehrlose Verr�ter die nichts"..
							" besseres zu tun haben als uns Engl�nder pausenlos zu provozieren...",true)
		ASP("matthew",tMat,"Hasst Ihr ihn so, weil er den K�nig absetzen will?",true)
		ASP("william",tWil,"Nicht nur deshalb. Seit dem er wusste, dass ich mich verloben will, versuchte er mir Lady Seren"..
							" auszuspannen. Doch er hat sicherlich nicht sein Herz an sie verloren, denn er hat keins. Er tut"..
							" das nur, weil er mir kein Gl�ck g�nnt.",true)
		ASP("HQSeren",tWil,"Beinah verga� ich, dass kein Feind handanlegen darf an diese Festung. F�llt sie, ist meine"..
							" Geliebte des Todes. Lasst es nicht so weit kommen.",false)

		briefing.finished = function()
			WriteQuest7()
			Quest7()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(quest)
end

function WriteQuest7()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL VII: Die Verteidigung der Abtei"
	local questtext	 =	mOlaf.." war tot, "..mEdw.." in Williams Kerker. "..mBarc2.." hatte zwar versucht mich auf seine"..
						" Seite zu ziehen, aber Versprechen wie Titel, Macht und Ruhm konnten mich nicht beeindrucken."..
						" Ehre ist alles was z�hlt und jemand der seine Fahne in den Wind h�ngt, die am st�rksten weht,"..
						" der hat keine Ehre."..
						" @cr @cr Um sein Ziel - K�nig will er werden - zu erreichen, braucht "..mBarc1.." das "..Gelb..""..
						" heilige Zepter "..Weiss.." welches in einer Abtei aufbewahrt wird, die von Sir Williams Verlobten"..
						" besch�tzt wird. Doch unter diesem Ansturm hat sie alleine keine Chance. @cr @cr "..SZ.." - "..
						" Abtei verteidigen @cr @cr "..NZ.." "..
						" - TOD: "..mMat.." @cr - GEB�UDE: - Bergfried verlieren @cr "..Trans.." ________ "..Weiss.." @cr "..
						" - Lady Serens Festung zerst�rt @cr - EROBERUNG: - Der Feind erobert die Abtei"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Audienz"
	local questtext	 =	"Nachdem die Truppen des Hammers zur�ckgeschlagen wurden, lie� mich William rufen. Ich z�gerte"..
						" nicht diese Audienz wahrzunehmen... @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Die �bergabe"
	local questtext	 =	"Um das heilige Zepter vor dem Zugriff durch die Verr�ter an der Krone zu sch�tzen, sollte die Abtei"..
						" unter meine Obhut gestellt werden. Dazu geh�rte auch, dass ich die heiligen Manuskripte einsehen"..
						" konnte, die dort angefertigt werden. Das sollte mir einen gewaltigen Bonus Ehre verschaffen. Aber"..
						" zuerst musste ich mit dem Bischof sprechen. @cr @cr "..SZ.." - Sprecht mit dem Bischof"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end
function Quest7()
	BriefingBishop1()
	for i=1,2 do
		local IO = {
			Name 		 = "Stower"..i,
			Type 		 = 2,
			Range		 = 400,
			Endless 	 = true,
			Callback	 = function()
			end,
		}
		Interactive_Setup( IO )
	end
end

function BriefingBishop1()
	EnableNpcMarker(GetEntityId("bishop"))
	local quest = {
	EntityName = "matthew",TargetName = "bishop",Distance = 500,
	Callback = function(_Quest)
		DisableNpcMarker(GetEntityId("bishop")); LookAt("matthew","bishop"); LookAt("bishop","matthew");
		BRIEFING_DISTANCE1()
		local briefing = {restoreCamera = true}
		local AP, ASP = AddPages(briefing)
		
		ASP("bishop",tBish,"Sch�n, dass Ihr endlich da seid. Wir sind in Bedr�ngniss geraten.",true)
		ASP("matthew",tMat,"Das wurde mir bereits zugetragen. Ich muss diese Abtei verteidigen.",true)
		ASP("bishop",tBish,"Ich werde dir meine Abtei �bergeben. Verwalte und sch�tze sie gut vor dem Feind. Gebt acht"..
							" vor Barcleys und Deveraux hinterh�ltigen Tricks.",true)

		briefing.finished = function()
			Quest8()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(quest)
end

-- +++ Invasion Kloster Start +++ --

function Quest8()
	ChangePlayer( "cloisterf", 1 )
	Logic.SetModelAndAnimSet( GetEntityId("cloisterf"),Models.Banners_XB_LargeOccupied )
	SetHostile( 2, 3 ); SetHostile( 2, 4 )
	gvMission.Value1 = 360
	gvMission.InfoText1 = "Zeit bis zum Angriff"
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Die �bergabe"
	local questtext	 =	"Um das heilige Zepter vor dem Zugriff durch die Verr�ter an der Krone zu sch�tzen, sollte"..
						" die Abtei unter meine Obhut gestellt werden. Dazu geh�rte auch, dass ich die heiligen"..
						" Manuskripte einsehen konnte, die dort angefertigt werden. Das sollte mir einen gewaltigen"..
						" Bonus Ehre verschaffen. Aber zuerst musste ich mit dem Bischof sprechen. @cr @cr "..Mint..""..
						" Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	StartSimpleJob("Treue_StartInvasion")
end

KLOSTERINVASIONCOUNTER = 360
KLOSTERFLAGCOUNTER = 60

function Treue_StartInvasion()
	KLOSTERINVASIONCOUNTER = KLOSTERINVASIONCOUNTER - 1
	Show_Infoline( 1, gvMission.InfoText1, KLOSTERINVASIONCOUNTER, gvMission.Value1 )
	if KLOSTERINVASIONCOUNTER == 0 then
		CCId = StartSimpleJob("Treue_CloisterCaptured")
		StartSimpleJob("Treue_CastleFalls")
		gvMission.CloisterTable = {}
		gvMission.CloisterWave = 0
		Treue_Invasion()
		Hide_Infoline(1)
	return true
	end
end

function Treue_Invasion()
	local zufall = GetRandom(1,10)
	local position = ""
	position = "invasion4"
	for i =1,CloisterIn_Strength do
		CreateMilitaryGroup(3,Entities.PU_LeaderSword4,8,GetPosition(position),"DC_Sword"..i)
		local ID = GetEntityId("DC_Sword"..i)
		GUI.LeaderChangeFormationType(ID, 4 )
		table.insert(gvMission.CloisterTable,ID)
		
		CreateMilitaryGroup(3,Entities.PU_LeaderRifle2,8,GetPosition(position),"DC_Rifle"..i)
		local ID = GetEntityId("DC_Rifle"..i)
		GUI.LeaderChangeFormationType(GetEntityId(ID), 4 )
		table.insert(gvMission.CloisterTable,ID)
		
		CreateMilitaryGroup(3,Entities.PU_LeaderCavalry2,3,GetPosition(position),"DC_Cavalry"..i)
		local ID = GetEntityId("DC_Cavalry"..i)
		GUI.LeaderChangeFormationType(ID, 4 )
		table.insert(gvMission.CloisterTable,ID)
	end
	position = "invasion3"
	for i =1,CloisterIn_Strength do
		CreateMilitaryGroup(4,Entities.CU_VeteranMajor,4,GetPosition(position),"BC_Mace"..i)
		local ID = GetEntityId("BC_Mace"..i)
		GUI.LeaderChangeFormationType(ID, 4 )
		table.insert(gvMission.CloisterTable,ID)
		
		CreateMilitaryGroup(4,Entities.PU_LeaderRifle1,4,GetPosition(position),"BC_Rifle"..i)
		local ID = GetEntityId("BC_Rifle"..i)
		GUI.LeaderChangeFormationType(ID, 4 )
		table.insert(gvMission.CloisterTable,ID)
		
		CreateMilitaryGroup(4,Entities.PU_LeaderHeavyCavalry2,3,GetPosition(position),"BC_Cavalry"..i)
		local ID = GetEntityId("BC_Cavalry"..i)
		GUI.LeaderChangeFormationType(ID, 4 )
		table.insert(gvMission.CloisterTable,ID)
	end
	CloisterIn_Strength = CloisterIn_Strength + CloisterIn_Addition
	gvMission.CloisterWave = gvMission.CloisterWave + 1
	gvMission.CloisterTime = CloisterIn_Time
	gvMission.Value1 = CloisterIn_Time
	gvMission.InfoText1 = Umlaute("Zeit bis zur n�chsten Welle")
	gvMission.Value2 = KLOSTERFLAGCOUNTER
	gvMission.InfoText2 = "Zeit bis zur Niederlage"
	StartSimpleJob("Treue_ControlInvasion")
end
function Treue_ControlInvasion()
	if AreDead(gvMission.CloisterTable)then
		for i= 1,table.getn(gvMission.CloisterTable) do table.remove(gvMission.CloisterTable,i)end
		if gvMission.CloisterWave == 4 then
			Briefing_Chapter8()
		return true
		elseif gvMission.CloisterWave == 3 then
			gvMission.CloisterTime = gvMission.CloisterTime - 1
			Show_Infoline( 1, gvMission.InfoText1, gvMission.CloisterTime, gvMission.Value1 )
			if gvMission.CloisterTime == 0 then
				WallBreakScene()
				Treue_Invasion()
				Hide_Infoline(1)
			return true
			end
		else
			gvMission.CloisterTime = gvMission.CloisterTime - 1
			Show_Infoline( 1, gvMission.InfoText1, gvMission.CloisterTime, gvMission.Value1 )
			if gvMission.CloisterTime == 0 then
				Treue_Invasion()
				Hide_Infoline(1)
			return true
			end
		end
	else
		if Counter.Tick2("Treue_ControlInvasion",5)then
			for i= 1,table.getn(gvMission.CloisterTable)do
				if AreEnemiesInArea( Logic.EntityGetPlayer(gvMission.CloisterTable[i]), GetPosition(gvMission.CloisterTable[i]), 2000 )then
					Attack(gvMission.CloisterTable[i], "cloisterf" )
				else
					Move(gvMission.CloisterTable[i], "cloisterf" )
				end
			end
		end
	end
end

function Briefing_EnemyCaptureCloister()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	ASP("cloisterf",tSim,"Der Feind konnte Das "..Gruen.." heilige Zepter "..Weiss.." stehlen. Wir haben versagt. Nun kann sich Barcley zum K�nig"..
							" kr�nen.", false)
	ASP("cloisterf",tErz,"Wer h�tte gedacht, das unser Kampf am Ende nur vergebene Liebesm�h sein sollte. William wollte das nicht akzeptieren"..
							" und k�mpfte weiter gegen Barcley, bis er den Tod fand. Ich bin seit dem auf der Flucht. Nur Gott wei�, was die"..
							" Zukunft noch f�r mich bereit h�lt...", false)
	briefing.finished = function()
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
	end
	StartBriefing(briefing)
end
function Briefing_CastleFalls1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	ASP("mainspawnS",tSim,"Die Festung von "..mSer.." ist gefallen. Der Feind hat sie zerst�rt. Wir haben versagt. Nun wird sich Barcley"..
							" zum K�nig kr�nen lassen.", false)
	ASP("mainspawnS",tErz,"Wer h�tte gedacht, das unser Kampf am Ende nur vergebene Liebesm�h sein sollte. William wollte das nicht akzeptieren"..
							" und k�mpfte weiter gegen Barcley, bis er den Tod fand. Ich bin seit dem auf der Flucht. Nur Gott wei�, was die"..
							" Zukunft noch f�r mich bereit h�lt...", false)
	briefing.finished = function()
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
	end
	StartBriefing(briefing)
end
function WallBreakScene()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cam17",""," ", true)
	briefing.finished = function()
		ToggleBriefingBar(0)
		local pos = GetPosition("CW1")
		CreateEntity(8,Entities.PU_Thief,pos,"CW_Thief"); pos.X = pos.X + 160
		CreateEntity(0,Entities.XD_Rock1,pos,"CWBomb1"); pos.Y = pos.Y + 400
		CreateEntity(0,Entities.XD_Rock1,pos,"CWBomb2"); pos.Y = pos.Y - 800
		CreateEntity(0,Entities.XD_Rock1,pos,"CWBomb3")
		Logic.SetModelAndAnimSet( GetEntityId("CWBomb1"),Models.XD_ThiefBomb )
		Logic.SetModelAndAnimSet( GetEntityId("CWBomb2"),Models.XD_ThiefBomb )
		Logic.SetModelAndAnimSet( GetEntityId("CWBomb3"),Models.XD_ThiefBomb )
		Move("CW_Thief","CW2")
		local cutscene={
		StartPosition={ zoom = 3500,rotation = -98,angle = 11,position = GetPosition( "cam17" ),},
		Flights={
			{
			position = GetPosition( "cam17" ),angle = 11,zoom = 3500,rotation = -94,duration = 1,delay = 0,
			title = "",
			text = "",
			},
			{
			position = GetPosition( "cam17" ),angle = 11,zoom = 3500,rotation = -90,duration = 1,delay = 0,
			title = "",
			text = "",
			action = function()
				SetHealth("brakewall_2",0); SetHealth("brakewall_4",0); SetHealth("brakewall_6",0)
				local pos = GetPosition("CWBomb1")
				Logic.CreateEffect( GGL_Effects.FXExplosionPilgrim, pos.X, pos.Y, 1 )
				DestroyEntity("CWBomb1")
			end
			},
			{
			position = GetPosition( "cam17" ),angle = 11,zoom = 3500,rotation = -86,duration = 1,delay = 0,
			title = "",
			text = "",
			action = function()
				SetHealth("brakewall_3",0); SetHealth("brakewall_1",0)
				local pos = GetPosition("CWBomb2")
				Logic.CreateEffect( GGL_Effects.FXExplosionPilgrim, pos.X, pos.Y, 1 )
				DestroyEntity("CWBomb2")
			end
			},
			{
			position = GetPosition( "cam17" ),angle = 11,zoom = 3500,rotation = -82,duration = 1,delay = 3,
			title = "",
			text = "",
			action = function()
				SetHealth("brakewall_5",0); SetHealth("brakewall_7",0)
				local pos = GetPosition("CWBomb3")
				Logic.CreateEffect( GGL_Effects.FXExplosionPilgrim, pos.X, pos.Y, 1 )
				DestroyEntity("CWBomb3")
			end
			},
		},
		Callback=function()
			DestroyEntity("CW_Thief"); ToggleBriefingBar(1)
		end,
	 }
	 StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end

function Treue_CastleFalls()
	if IsDeadWrapper("HQSeren")then
		Briefing_CastleFalls1()
	return true
	end
end

function Treue_CloisterCaptured()
	if GetPlayer("cloisterf")== 3 or GetPlayer("cloisterf")== 4 then
	KLOSTERFLAGCOUNTER = KLOSTERFLAGCOUNTER - 1
	Show_Infoline( 1, gvMission.InfoText2, KLOSTERFLAGCOUNTER, gvMission.Value2 )
		if KLOSTERFLAGCOUNTER == 0 then
			Briefing_EnemyCaptureCloister()
		return true
		end
	else
		KLOSTERFLAGCOUNTER = 60
		Hide_Infoline(1)
	end
end

-- +++ Invasion Kloster Ende +++ --

-- # # # # # # # # # # CHAPTER 8 # # # # # # # # # # --

function StartChapter8()
	ReplaceEntity( "sperre3", Entities.XD_Rock7 ) ReplaceEntity( "sperre5", Entities.XD_Rock7 )
	Logic.RemoveQuest( 1, 1 ) Logic.RemoveQuest( 1, 2 ) Logic.RemoveQuest( 1, 3 ) Logic.RemoveQuest( 1, 4 )
	ChangePlayer( "cloisterf", 1 )
	Logic.SetModelAndAnimSet( GetEntityId("cloisterf"),Models.Banners_XB_LargeOccupied )
	local pos = GetPosition( "HQSteele" )
	Camera.ScrollSetLookAt(pos.X,pos.Y)
	EndJob(CCId)
	WriteQuest9()
	Quest9()
end

-- #### ARMIES #### --

function CreateDeverauxAttacker()
	ArmyOne = {
		player 				= 3,
		id 					= 1,
		strength 			= 4,
		position 			= GetPosition("Dspawn2"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn2"),
		spawnGenerator 		= "Dbarracks2",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("HQSteele"),
			GetPosition("obstf"),
		},
	}
	SetupArmy( ArmyOne )
	ConrtolArmy1 = StartSimpleJob("ConrtolArmyOne")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy1", ArmyOne)
	
	ArmyTwo = {
		player 				= 3,
		id 					= 2,
		strength 			= 4,
		position 			= GetPosition("Dspawn2"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow4, 8},
			{Entities.PU_LeaderRifle2, 8},
			{Entities.PU_LeaderRifle2, 8},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn2"),
		spawnGenerator 		= "Dbarracks2",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( ArmyTwo )
	ConrtolArmy2 = StartSimpleJob("ConrtolArmyTwo")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy2", ArmyTwo)
	
	ArmyThree = {
		player 				= 3,
		id 					= 3,
		strength 			= 4,
		position 			= GetPosition("DCspawn2"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PV_Cannon3, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("DCspawn2"),
		spawnGenerator 		= "Darchery2",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( ArmyThree )
	ConrtolArmy3 = StartSimpleJob("ConrtolArmyThree")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy3", ArmyThree)
	
	ArmyFour = {
		player 				= 3,
		id 					= 4,
		strength 			= 4,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderCavalry2, 3},
			{Entities.PU_LeaderCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 1,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("Wpatrol1_2"),
		},
	}
	SetupArmy( ArmyFour )
	ConrtolArmy4 = StartSimpleJob("ConrtolArmyFour")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy4", ArmyFour)
	AI.Army_AddWaypoint( 3, 4, GetEntityId("DCspawn1") )
	
	ArmyFive = {
		player 				= 3,
		id 					= 5,
		strength 			= 4,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow4, 8},
			{Entities.PU_LeaderRifle2, 8},
			{Entities.PU_LeaderRifle2, 8},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 1,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("Wpatrol1_2"),
		},
	}
	SetupArmy( ArmyFive )
	ConrtolArmy5 = StartSimpleJob("ConrtolArmyFive")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy5", ArmyFive)
	
	ArmySix = {
		player 				= 3,
		id 					= 6,
		strength 			= 4,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 1,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("Wpatrol1_2"),
		},
	}
	SetupArmy( ArmySix )
	ConrtolArmy6 = StartSimpleJob("ConrtolArmySix")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy6", ArmySix)
	
	ArmySeven = {
		player 				= 3,
		id 					= 7,
		strength 			= 4,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 1,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("Wpatrol1_2"),
		},
	}
	SetupArmy( ArmySeven )
	ConrtolArmy7 = StartSimpleJob("ConrtolArmySeven")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy7", ArmySeven)
	
	ArmyAight = {
		player 				= 3,
		id 					= 8,
		strength 			= 4,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PV_Cannon3, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= 300,
		refresh 			= true,
		maxSpawnAmount 		= 1,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 1,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("Wpatrol1_2"),
		},
	}
	SetupArmy( ArmyAight )
	ConrtolArmy8 = StartSimpleJob("ConrtolArmyAight")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy8", ArmyAight)
end

function ConrtolArmyOne()
	if IsAlive(ArmyOne) then
        TickOffensiveAIController(ArmyOne)
		Synchronize(ArmyOne,ArmyTwo)
		Synchronize(ArmyOne,ArmyThree)
    elseif IsAITroopGeneratorDead(ArmyOne) then
        return true
    end
end
function ConrtolArmyTwo()
	if IsAlive(ArmyTwo) then
        TickOffensiveAIController(ArmyTwo)
    elseif IsAITroopGeneratorDead(ArmyTwo) then
        return true
    end
end
function ConrtolArmyThree()
	if IsAlive(ArmyThree) then
        TickOffensiveAIController(ArmyThree)
    elseif IsAITroopGeneratorDead(ArmyThree) then
        return true
    end
end
function ConrtolArmyFour()
	if IsAlive(ArmyFour) then
        TickOffensiveAIController(ArmyFour)
    elseif IsAITroopGeneratorDead(ArmyFour) then
        return true
    end
end
function ConrtolArmyFive()
	if IsAlive(ArmyFive) then
        TickOffensiveAIController(ArmyFive)
    elseif IsAITroopGeneratorDead(ArmyFive) then
        return true
    end
end
function ConrtolArmySix()
	if IsAlive(ArmySix) then
        TickOffensiveAIController(ArmySix)
    elseif IsAITroopGeneratorDead(ArmySix) then
        return true
    end
end
function ConrtolArmySeven()
	if IsAlive(ArmySeven) then
        TickOffensiveAIController(ArmySeven)
    elseif IsAITroopGeneratorDead(ArmySeven) then
        return true
    end
end
function ConrtolArmyAight()
	if IsAlive(ArmyAight) then
        TickOffensiveAIController(ArmyAight)
    elseif IsAITroopGeneratorDead(ArmyAight) then
        return true
    end
end

-- +++ Attacker from William Start +++ --

function CreateWilliamTributAttacker()
	
	local Description1 = {maxNumberOfSoldiers = 8,minNumberOfSoldiers = 4,experiencePoints = 3,leaderType = Entities.PU_LeaderSword4}
	local Description2 = {maxNumberOfSoldiers = 8,minNumberOfSoldiers = 4,experiencePoints = 3,leaderType = Entities.PU_LeaderBow3}
	
	WTributeOne = {
		player = 2,
		id = 1,
		rodeLength = 3000,
		strength = 5,
		position = GetPosition("mainspawnW"),
		}
    SetupArmy(WTributeOne)
    for i = 1,3  do EnlargeArmy(WTributeOne,Description1) end
	for i = 1,2  do EnlargeArmy(WTributeOne,Description2) end
	
	WTributeTwo = {
		player = 2,
		id = 2,
		rodeLength = 3000,
		strength = 5,
		position = GetPosition("mainspawnW"),
		}
    SetupArmy(WTributeTwo)
    for i = 1,2  do EnlargeArmy(WTributeTwo,Description1) end
	for i = 1,3  do EnlargeArmy(WTributeTwo,Description2) end
	
	WTributeThree = {
		player = 2,
		id = 3,
		rodeLength = 3000,
		strength = 5,
		position = GetPosition("mainspawnW"),
		}
    SetupArmy(WTributeThree)
    for i = 1,3  do EnlargeArmy(WTributeThree,Description1) end
	for i = 1,2  do EnlargeArmy(WTributeThree,Description2) end
	
	WTributeFour = {
		player = 2,
		id = 4,
		rodeLength = 3000,
		strength = 5,
		position = GetPosition("mainspawnW"),
		}
    SetupArmy(WTributeFour)
    for i = 1,2  do EnlargeArmy(WTributeFour,Description1) end
	for i = 1,3  do EnlargeArmy(WTributeFour,Description2) end
	
	WTribute1 = StartSimpleJob("ControlWTribute")
	--StartSimpleJob("ReloadTributeAttacker")
end

function ControlWTribute()
	if Counter.Tick2("ControlWTributeOne",10)then
		Advance( WTributeOne )
		Synchronize(WTributeOne,WTributeTwo)
		Synchronize(WTributeOne,WTributeThree)
		Synchronize(WTributeOne,WTributeFour)
	end
end
function ReloadTributeAttacker()
	if IsDeadWrapper(WTributeOne)and IsDeadWrapper(WTributeTwo)and IsDeadWrapper(WTributeThree)and IsDeadWrapper(WTributeFour)then
		Briefing_WilliamForceDead()
	return true
	end
end

-- +++ Attacker from William End +++ --

-- #### QUESTS #### --

function Briefing_Chapter8()
	for i=1,5 do
		local pos = GetPosition("c_bK"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.CU_VeteranMajor, 3, pos.X, pos.Y, 270.00 ),"c_bK"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_bK"..i), 4 )
		local pos = GetPosition("c_R"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.PU_LeaderRifle1, 3, pos.X, pos.Y, 270.00 ),"c_R"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_R"..i), 4 )
	end
	for i=6,10 do
		local pos = GetPosition("c_bK"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.CU_VeteranMajor, 3, pos.X, pos.Y, 90.00 ),"c_bK"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_bK"..i), 4 )
		local pos = GetPosition("c_R"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.PU_LeaderRifle1, 3, pos.X, pos.Y, 90.00 ),"c_R"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_R"..i), 4 )
	end
	
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cam18",""," ", true)
	briefing.finished = function()
		SetPosition("matthew",GetPosition("matthewpos1"))
		LookAt("matthew","william");LookAt("william","matthew");
		local cutscene={
		StartPosition={ zoom = 5200,rotation = -8,angle = 32,position = GetPosition( "cam18" ),},
		Flights={
			{
			position = GetPosition( "cam18" ),angle = 30,zoom = 5200,rotation = 28,duration = 10,delay = 5,
			title = Gruen.." KAPITEL VIII:",
			text = Gelb.." DAS NEST DES FALKEN",
			},
		},
		Callback=function()
			BRIEFING_ZOOMDISTANCE = 5000
			BRIEFING_ZOOMANGLE = 15
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			
			ASP("william",tErz,"Nachdem die letzte Welle der Angreifer zur�ckgeschlagen wurde, lie� Sir William erneut nach mir rufen. Es gab"..
								" viel zu besprechen. Wir mussten uns nun entscheiden, wie wir weiter vorgehen wollten.", true)
			ASP("william",tWil,mMat.." die Abtei ist nun sicher. Die Feinde werden sie nun nicht mehr angreifen, weil sie wissen,"..
								" dass die Abtei unter unserem Schutz steht. @cr Die Abtei bleibt unter Eurer Fahne.", true)
			ASP("matthew",tMat,"Wenn der Feind nun begriffen hat, dass wir das Zepter besch�tzen, hei�t das dann nicht, dass sie "..Gelb..""..
								" uns "..Weiss.." als Bedrohung wahrnehmen und "..Gelb.." uns "..Weiss.." nun angreifen werden?", true)
			ASP("william",tWil,"Was scheut Ihr Euch so? Wir haben nun mehrfach bewiesen, dass wir ein "..Gruen.." ernstzunehmender "..Weiss..""..
								" Gegner sind. Lasst uns nun den Beweis erbringen, dass die einzige Tugend, die Treue zum K�nig, immer"..
								" �ber jeden Feind siegt.", true)
			ASP("HQFalcon",tWil,"Es wird Zeit meinen Bruder die Konsequenz seines Handelns zu zeigen. Das ist das "..Gruen.." Nest des Falken."..
								" "..Weiss.." Sein "..Gelb.." Prachtschloss "..Weiss.." Kaloix ist sein ganzer Stolz. Es ist seine prunkvollste"..
								" Burg au�erhalb Frankreichs und zudem sein Ferienhaus.", false)
			ASP("matthew",tMat,"Statten wir dem Falken einen Besuch ab?", true)
			ASP("william",tWil,"Nein, mein Freund. Ich bef�rchte, dass er uns besuchen kommt. Rechnet mit Massenangriffen von Bastardschwert"..
								"k�mpfern, Scharfsch�tzen und seinen m�chtigen Aventuriern. Diese Soldaten k�mpfen mit einer gewaltigen"..
								"Armbrust.", true)
			ASP("william",tWil,"Desweiteren mag er Eisenkannonen und leichte Kavalerie. Er ist ein verdammt reicher "..Gruen.." Baguettefresser"..
								" "..Weiss.." bei dem man mit allem rechnen muss.", true)
			ASP("matthew",tMat,"Also soll ich wieder in meiner Burg hocken und seine Angriffe aushalten?", true)
			ASP("william",tWil,"Er hat unglaublich viele M�nner. Aussitzen, so wie wir es bisher immer taten, wird nun nicht mehr funktionieren!"..
								" Wir m�ssen vorsto�en und meinem sch�ndlichen Bruder von seinen Machtpl�nen abbringen.", true)
			ASP("matthew",tMat,"Machtpl�ne? Ich dachte er w�re ein Lakei von Barcley.", true)
			ASP("william",tWil,"Er? Er hat doch schon den Finger am Abzug. Er wartet doch nur auf eine Gelegenheit, um Barcley zu meucheln"..
								" und selbst den Thron zu besteigen...", true)
			ASP("c_barc",tBarc,"Er wird es fr�her oder sp�ter ausnutzen, dass Lord Barcley sich f�r unantastbar h�lt...", true)
			
			briefing.finished = function()				
					local cutscene={
					StartPosition={ zoom = 2200,rotation = -70,angle = 14,position = GetPosition( "cam10" ),},
					Flights={
						{
						position = GetPosition( "cam10" ),angle = 10,zoom = 2200,rotation = -56,duration = 10,delay = 5,
						title = tErz,
						text = "In der Zwischenzeit trafen sich die �brigen Verschw�rer",
						action = function()
							StartMusic("20_Evelance_Summer2.mp3", 153)
							Move("c_dev","c_dev_pos1")
						end
						},
					},
				Callback=function()
					SetPosition("matthew",GetPosition("doorpos"))
					LookAt("c_dev","c_barc")
					BRIEFING_DISTANCE1()
					local briefing = {}
					local AP, ASP = AddPages(briefing)
					
					ASP("c_barc",tBarc,"Ich hasse es, wenn ein Plan fehlschl�gt...", true)
					ASP("c_dev_pos1",tDev,"Mein d�mlicher Bruder und sein h�sslicher, dummer Lakei sind unerwartet zu einer m�chtigen"..
											" Bedrohung f�r meine... �hm... ich meine unsere Pl�ne geworden! Wir sollten etwas"..
											" gegen sie tun.", true)
					ASP("c_barc",tBarc,"Ihr habt Recht, Graf Deveraux. Ich schlage vor, dass Ihr Euch endlich einen alten Traum erf�llt."..
										" Nehmt Eure Truppen und t�tet meine Feinde. Franz�sische Soldaten sind doch die besten Soldaten"..
										" Der Welt!? Dann sollte das doch kein Problem f�r Euch darstellen.", true)
					ASP("HQSteele",tSim,"Mein Herr, mir wurde von gewaltigen franz�sischen Armeen berichtet. Offenbar haben sie vor, sich"..
										" aufzuteilen. Sie wollen Sir William und uns zugleich angreifen.", false)
					ASP("HQWilliam",tSim,"Der weitaus gewaltigere Teil Deveraux\' Streitm�chte marschiert zu Sir William auf. Offenbar will"..
										" der Graf seinen verhassten Bruder endlich tot sehen. Das wollt Ihr doch nicht etwa erlauben?"..
										" Wir m�ssen den Feind aufhalten. Sir William darf nicht sterben.", false)
					ASP("HQSteele",tSim,"Wir k�nnen Truppen abstellen, um Sir Williams Festung zu bewachen. Doch auf kurz oder lang m�ssen"..
										" wir zu Deveraux vorsto�en. Sir William l�sst ausrichten, dass Ihr ihm Rohstoffe zusenden sollt,"..
										" wenn er sich ebenfalls am Angriff beteiligen soll.", false)
					
					briefing.finished = function()
						StartChapter8()
					end,
					StartBriefing(briefing)
				end,
				}
				StartCutscene(cutscene)
			end
			StartBriefing(briefing)
		end,
	}
	StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end

function WriteQuest9()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL VIII: Das Nest des Falken"
	local questtext	 =	"Nach der erfolgreichen Verteidigung der Abtei und dem "..Gruen.." Heiligen Zepter "..Weiss.." hatte sich der Feind"..
						" auf mich und "..mWil.." fokussiert. Gewaltige Armeen marschieren nun auf und es war an mir, Sir William zu sch�tzen"..
						" und den franz�sischen Grafen zu vernichten. William wollte selbst Truppen ausbilden, doch dazu fehlen ihm die n�tigen"..
						" finanziellen Mittel. @cr @cr Unser Zier war markiert. Der Graf musste entmachtet werden. und wenn es n�tig war auch"..
						" ihn zu t�ten, um die Krone zu sch�tzen, dann soll es eben so sein. Doch durften wir unser Ziel nicht aus den Augen"..
						" verlieren. Der K�nig musste gefunden werden. @cr @cr "..SZ.." - TOD: "..mDev2.." "..mDev1.." (Drake) @cr "..
						" - Den K�nig finden. @cr @cr "..NZ.." - GEB�UDE: - Bergfried verlieren @cr - Tod eines der guten Hauptcharaktere @cr "..
						" (\"Matthew Steele\", \"Sir William\", \"Lady Seren\")"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Unterst�tzung f�r Sir William"
	local questtext	 =	"Sir William wollte selbst in die Schlacht gegen seinen franz�sischen Halbbruder ziehen, doch ermangelte es ihm an"..
						" Geld und Rohstoffen. Er bat mich um Unterst�tzung, damit er eigene Angriffstruppen auftellen konnte. @cr @cr "..
						" "..Orange.." Bezahlt die Tribute, damit Sir William Euch im Kampf unterst�tzt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end
function Quest9()
	Tools.GiveResouces( 3, 100000000, 10000, 50000, 50000, 10000, 50000 )
	SetupPlayerAi( 3, {serfLimit = 12,constructing = false,repairing = true,extracting = 0,} )
	CreateDeverauxAttacker()
	Init_Tributes()
	StartSimpleJob( "Treue_WilliamDies" )
	StartSimpleJob( "EndQuest9" )
end

-- +++ Tributes William Start +++ --

ENOUGHTGOLD_COUNTER = 1
ENOUGHTIRON_COUNTER = 1

function Init_Tributes()
	gvMission.TradeCarts1 = {}
	gvMission.TradeCartsCounter = 0
	gvMission.Value1 = 0
	gvMission.Value2 = 0
	Treue_TributGold()
	Treue_TributIron()
end
function Treue_TributGold()
	if gvMission.Value1 < ENOUGHTGOLD_COUNTER then
		local tribute1 = {
			playerId = 1,
			text = Umlaute("Zahlt 10000 Taler an William, damit er seine Armeen aufr�sten kann."),
			cost = {Gold = 10000},
			Callback = function()
				gvMission.TradeCartsCounter = gvMission.TradeCartsCounter + 1
				local name = "deliverer"..gvMission.TradeCartsCounter
				CreateEntity( 2, Entities.PU_Travelling_Salesman, GetPosition("doorpos"),name )
				Move(name,"mainspawnW")
				table.insert( gvMission.TradeCarts1, { name, "gold" })
				if not gvMission.Deliver1 then
					gvMission.Deliver1 = StartSimpleJob("ControlDeliverToWilliam")
				end
			return true
			end, }
		TrinutID1 = AddTribute(tribute1)
	end
end
function Treue_TributIron()
	if gvMission.Value2 < ENOUGHTIRON_COUNTER then
		local tribute1 = {
			playerId = 1,
			text = Umlaute("Zahlt 6000 Eisen an William, damit er seine Armeen aufr�sten kann."),
			cost = {Iron = 6000},
			Callback = function()
				gvMission.TradeCartsCounter = gvMission.TradeCartsCounter + 1
				local name = "deliverer"..gvMission.TradeCartsCounter
				CreateEntity( 2, Entities.PU_Travelling_Salesman, GetPosition("doorpos"),name )
				Move(name,"mainspawnW")
				table.insert( gvMission.TradeCarts1, { name, "iron" })
				if not gvMission.Deliver1 then
					gvMission.Deliver1 = StartSimpleJob("ControlDeliverToWilliam")
				end
			return true
			end, }
		TrinutID2 = AddTribute(tribute1)
	end
end

function ControlDeliverToWilliam()
	if table.getn(gvMission.TradeCarts1)>0 then
		for i=1,table.getn(gvMission.TradeCarts1)do
			if IsDeadWrapper(gvMission.TradeCarts1[i])then
				Message( "Eine Lieferung wurde abgefangen!" )
				Sound.PlayQueuedFeedbackSound( Sounds.OnKlick_Select_kerberos, 100 )
				if gvMission.TradeCarts1[i][2] == "gold" then
					Treue_TributGold()
					table.remove(gvMission.TradeCarts1, i)
					return
				elseif gvMission.TradeCarts1[i][2] == "iron" then
					Treue_TributIron()
					table.remove(gvMission.TradeCarts1, i)
					return
				end
			end
			if Logic.IsEntityMoving(GetEntityId(gvMission.TradeCarts1[i][1]))== 0 then
				Move(gvMission.TradeCarts1[i][1],"mainspawnW")
			end
			if IsNear( gvMission.TradeCarts1[i][1], "mainspawnW", 400 )then
				Message( "Eine Lieferung ist angekommen!" )
				if gvMission.TradeCarts1[i][2] == "gold" then
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_TRADE_SendResourcesGold, 100 )
					gvMission.Value1 = 1
					DestroyEntity(gvMission.TradeCarts1[i][1])
					table.remove(gvMission.TradeCarts1, i)
					Treue_TributGold()
					return
				elseif gvMission.TradeCarts1[i][2] == "iron" then
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_TRADE_SendResourcesIron, 100 )
					gvMission.Value2 = 1
					DestroyEntity(gvMission.TradeCarts1[i][1])
					table.remove(gvMission.TradeCarts1, i)
					Treue_TributIron()
					return
				end
			end
		end
	end
	if IsAlive("HQFalcon")then
		if gvMission.Value1 == ENOUGHTGOLD_COUNTER and gvMission.Value2 == ENOUGHTIRON_COUNTER then
			Logic.RemoveTribute( 1, TrinutID1 ); Logic.RemoveTribute( 1, TrinutID2 )
			Briefing_WilliamForceAttack()
		return true
		end
	else
		Logic.RemoveTribute( 1, TrinutID1 ); Logic.RemoveTribute( 1, TrinutID2 )
		for j=1,table.getn(gvMission.TradeCarts1) do
			DestroyEntity(gvMission.TradeCarts1[j][1])
			table.remove(gvMission.TradeCarts1, j)
		return true
		end
	end
end
function Briefing_WilliamForceAttack()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE1()
	
	ASP("mainspawnW",tWil,"Ich habe die ben�tigten Waren erhalten. Ich werde nun den Grafen angreifen. Matthew, schlie�t Euch mir an!", false)
	
	briefing.finished = function()
		CreateWilliamTributAttacker()
	end
	StartBriefing(briefing)
end
function Briefing_WilliamForceDead()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE1()
		
	ASP("mainspawnW",tWil,"Meine Soldaten wurden geschlagen!", false)
		
	briefing.finished = function()
		Init_Tributes()
	end
	StartBriefing(briefing)
end

-- +++ Tributes William End +++ --

function Treue_WilliamDies()
	if IsDeadWrapper("william")then
		Briefing_WilliamDies1()
	return true
	end
end
function Briefing_WilliamDies1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	
	ASP("mainspawnW",tSim,mWil.." wurde erschlagen! Ohne ihn ist der Wiederstand verloren.", false)
	ASP("mainspawnS",tErz,"Wer h�tte gedacht, das unser Kampf am Ende nur vergebene Liebesm�h sein sollte. Ich wollte das nicht akzeptieren,"..
							" doch welche Wahl bliebt mir noch?. Seit dem bin ich auf der Flucht. Nur Gott wei�, was die Zukunft noch f�r mich"..
							" bereit h�lt...", false)
	
	briefing.finished = function()
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
	end
	StartBriefing(briefing)
end

function EndQuest9()
	if GetHealth( "deveraux" )<1 then
		Briefing_DeverauxDies()
	return true
	end
end

function Briefing_DeverauxDies()
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	ASP("deveraux",tDev,"Geschlagen von einem nichtsnutzigen T�lpel... Ich sterbe in Schande...", true)
	ASP("HQSteele",tSim,"Das ist ein gro�er Tag f�r uns! Mit dem Tod des Falken gibt es nur noch einen Feind unserer Sache, Sire.", false)
	ASP("HQSteele",tSim,"Die Soldaten haben Deveraux Schloss auf den Kopf gestellt. Dabei haben sie sein Tagebuch gefunden. Er hat"..
						" notiert, dass er eine hei�e Spur verfolgen wolle. Der Weg f�hrt offenbar in die n�rdlichen Berge.", false)
	
	briefing.finished = function()
		local questid	 = 	2
		local questtype	 = 	SUBQUEST_CLOSED
		local questtitle =	"Unterst�tzung f�r Sir William"
		local questtext	 =	"Sir William wollte selbst in die Schlacht gegen seinen franz�sischen Halbbruder ziehen, doch ermangelte es ihm an"..
							" Geld und Rohstoffen. Er bat mich um Unterst�tzung, damit er eigene Angriffstruppen auftellen k�nne. @cr @cr "..
							" "..Mint.." Diese Aufgabe wurde erf�llt."
		Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
		
		Quest10()
		Briefing_ConnorMacClaud1()
		Briefing_Wartender()
		local units = SucheAufDerWelt( 3, 0 )
		for i=1,table.getn(units)do
			if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
				if Logic.IsLeader(units[i])== 1 then
					Logic.DestroyGroupByLeader( units[i] )
				else
					Logic.DestroyEntity( units[i] )
				end
			end
		end
	end
	StartBriefing(briefing)
end

function Briefing_ConnorMacClaud1()
	EnableNpcMarker(GetEntityId("connor"))
	local quest = {
	    EntityName = "matthew",
	    TargetName = "connor",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","connor")
			LookAt("connor","matthew")
			DisableNpcMarker(GetEntityId("connor"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()
			
			ASP("matthew",tMat,"Wer seid Ihr?", true)
			ASP("connor",tMac,tMac.." "..Weiss.." vom Clan der MacClauds. Und ich bin unsterblich.", true)
			ASP("matthew",tMat,"Aha Achso? Wisst Ihr zuf�llig wo der K�nig ist?", true)
			ASP("connor",tMac,"Ja, nat�rlich. Ich bin der Highlander. Ich wei� alles! Und ich bin unsterblich. Ich bin der H�ter des Orakels"..
								" von... hab ich vergessen...", true)
			ASP("connor",tMac,"Auf jeden Fall kannst du nur von mir die Schl�ssel bekommen, mit denen du die Br�cke herunterlassen kannst."..
								" Aber die bekommst du nicht. Du bist nicht der Erste, der sie haben wollte. Der letzte hat geschlagene 24 Mal"..
								" versucht mich zu erschie�en, bis er entnerft abgehauen ist.", true)
			ASP("connor",tMac,"Und desshalb bekommst du den Schl�ssel nicht. Der w�rde dir sowieso nichts n�tzen, denn du m�sstest eh erst"..
								" die Passworte der Tore knacken.", true)
			ASP("matthew",tMat,"Ich sehe, an dir bei� ich mir die Z�hne aus. Was mach ich jetzt?", true)
			
			briefing.finished = function()
				ActiveMacClaudNonsins()
				Quest10_2()
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end
function ActiveMacClaudNonsins()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "activeMac",
	    Distance = 1000,
	    Callback = function( _Quest )
			EnableNpcMarker(GetEntityId("connor"))
			MacClaudNonsins()
	    end
	}
	SetupExpedition( quest )
end
function MacClaudNonsins()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "connor",
	    Distance = 500,
	    Callback = function( _Quest )
			local zahl = GetRandom(1,3)
			if zahl == 1 then
				Message(tMac.." "..Weiss.." @cr Es kann nur "..Gelb.." EINEN "..Weiss.." geben!")
			elseif zahl == 2 then
				Message(tMac.." "..Weiss.." @cr Es ist die "..Gelb.." G�TTLICHE KRAFT "..Weiss.." die mich durchdringt!")
			elseif zahl == 3 then
				Message(tMac.." "..Weiss.." @cr Ich bin der "..Gelb.." HIGHLANDER!")
			end
			DisableNpcMarker(GetEntityId("connor"))
			ActiveMacClaudNonsins()
	    end
	}
	SetupExpedition( quest )
end
function Briefing_Wartender()
	EnableNpcMarker(GetEntityId("wartender"))
	local quest = {
	    EntityName = "matthew",
	    TargetName = "wartender",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","wartender")
			Message(Orange.." Wartender @cr "..Weiss.." Seit stunden blockiert der das Klo...")
			DisableNpcMarker(GetEntityId("wartender"))
		end
	}
	SetupExpedition( quest )
end

function Briefing_Smelter()
	ReplaceEntity("smelter",Entities.CU_SmelterIdle)
	EnableNpcMarker(GetEntityId("smelter"))
	local pos = GetPosition("smelter")
	GUI.CreateMinimapMarker(pos.X,pos.Y)
	local quest = {
	    EntityName = "matthew",
	    TargetName = "smelter",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","smelter")
			LookAt("smelter","matthew")
			local pos = GetPosition("smelter")
			GUI.DestroyMinimapPulse(pos.X,pos.Y)
			DisableNpcMarker(GetEntityId("smelter"))
			local briefing = {restoreCamera = true}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()
			
			ASP("smelter",Orange.." Kanonengie�er","Seht ihr diesen fetten Brocken? Fr�her arbeitete ich f�r den K�nig, doch seit einem Erdrutsch"..
								" komme ich nicht mehr zu meinem Arbeitsplatz. Wenn den doch einer Wegsprengen k�nnte.", true)
			ASP("HQSteele",tSim,"Sire, Ich h�rte von einem L�genbaron, der in der Lage ist Bomben zu bauen. Man sagt, Barcley h�tte ihn raus"..
								" geschmissen, nachdem eine seiner L�gen aufflog. Vielleicht habt Ihr den Mann sogar schon getroffen."..
								" Er soll sich angeblich irgend wo in den �berresten von Olafs Holzburg befinden.", false)
			ASP("HQSteele",tSim,"Ihr erinnert Euch doch noch wo das war, oder? Na ja, sollte das nicht der Fall sein, markiere ich es"..
								" Euch einfach auf der Karte.", false)
			
			briefing.finished = function()
				local pos = GetPosition("prison1")
				GUI.CreateMinimapMarker(pos.X,pos.Y)
				MoveAndVanish("smelter","barc_WP3")
				Quest11()
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end

function Quest10()
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Die Festung des K�nigs"
	local questtext	 =	"Nach dem Tod des Falken gab es nur noch eine Aufgabe f�r mich zu erf�llen. Ich musste den K�nig finden. Doch wo sollte."..
						" ich anfangen zu suchen? @cr @cr "..SZ.." - Sprecht mit dem K�nig"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end
function Quest10_2()
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Die Festung des K�nigs"
	local questtext	 =	"Nach dem Tod des Falken gab es nur noch eine Aufgabe f�r mich zu erf�llen. Ich musste den K�nig finden. Doch wo sollte."..
						" ich anfangen zu suchen? @cr @cr Der W�chter des Orakels, dessen Name er vergessen hat, war keine gro�e Hilfe. Er behielt"..
						" seine Geheimnisse f�r sich und ich sah keine M�glichkeit sie ihm zu entlocken. Ich musste einen anderen Weg zum K�nig"..
						" finden, denn der direkte blieb mir verwehrt. @cr @cr "..SZ.." - Sprecht mit dem K�nig"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	Briefing_Smelter()
	StartSimpleJob("Treue_BombTheStone")
end
function Quest10_3()
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Die Festung des K�nigs"
	local questtext	 =	"Der Weg war nun frei. Jetzt konnte ich endlich mit dem K�nig sprechen, den wir nun schon so lange suchten."..
						" @cr @cr "..SZ.." - Sprecht mit dem K�nig"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)

	Tools.GiveResouces( 2, 100000000, 10000, 50000, 50000, 10000, 50000 )
	SetupPlayerAi( 2, {serfLimit = 0,constructing = false,repairing = true,extracting = 0,} )
	StartSimpleJob( "Treue_KingSerfs" )
	Briefing_Treue_King1()
end
function Quest11()
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Der L�genbaron"
	local questtext	 =	"Endlich hatte ich einen Weg zum K�nig gefunden, da war er aber auch schon von einem Erdrutsch versch�ttet. Der einzige Weg"..
						" den Brocken aus dem Weg zu r�umen war ihn zu sprengen. Doch ich konnte keine Bomben bauen. Mein Berater erz�hlte mir"..
						" von einem L�genbaron, der mich das lehren k�nnte. @cr @cr "..SZ.." - Findet den L�genbaron"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	StartSimpleJob("Treue_IsScholarFree")
end
function Quest12()
	local questid	 = 	5
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Ein Lehrstul f�r den Plagiator"
	local questtext	 =	"Damit mir Guttenplag das Bombenbauen beibrachte, musste ich ihm einen neuen Lehrstuhl besorgen. @cr @cr "..SZ..""..
						" - Lasst f�r Guttenplag ein Podium errichten."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local tribute = {
		playerId = 1,
		text = Umlaute("Baut f�r 500 Holz ein Podium von dem aus Guttenplag unterrichten kann."),
		cost = {Wood = 500},
		Callback = function()
			Logic.SetModelAndAnimSet( GetEntityId("podium"),Models.XD_GCPodium )
			ReplaceEntity("scholar2", Entities.CU_GCScholar); ReplaceEntity("schueler1", Entities.CU_SettlerIdle)
			ReplaceEntity("schueler2", Entities.CU_SettlerIdle); ReplaceEntity("schueler3", Entities.CU_SettlerIdle)
			Logic.SetTaskList( GetEntityId( "scholar2" ), TaskLists.TL_GC_SCHOLAR_TALK3 )
			LookAt("scholar1","prison1")
			
			local briefing = {restoreCamera = true}
			local AP, ASP = AddPages(briefing)
			BRIEFING_ZOOMDISTANCE = 2000
			BRIEFING_ZOOMANGLE = 7
			
			ASP("scholar1",tGut,"Jetzt kommen wir zu dir... Schei�haus...", false)
			AP{	
				title = tGut,
				text = "Hahahaha! Burn baby, burn!",
				position = GetPosition("scholar1"),
				dialogCamera = false,
				action = function()
					local pos = GetPosition("prison1")
					Logic.CreateEffect( GGL_Effects.FXExplosionPilgrim, pos.X, pos.Y, 1 )
					DestroyEntity("prison1")
					Display.SetRenderFogOfWar(0)
				end
			}
			ASP("scholar1",tGut,"Kommt zu mir, wenn Ihr des Bomben bauen m�chtig werden wollt, Sir Steele.", false)
			
			briefing.finished = function()
				Display.SetRenderFogOfWar(1)
				DestroyEntity("scholar1")
				Quest12End()
			end
			StartBriefing(briefing)
			
			EnableNpcMarker(GetEntityId("scholar2"))
			local IO = {
				Name 		 = "scholar2",
				Type 		 = 3,
				Range		 = 500,
				Costs 		= { 1000, 0, 0, 0, 500, 500, 100, },
				Title		 = "Lehre: Bomben bauen",
				Text		 = "Erlernt das Bombenbauen von Klaus von und zu Guttenplag.",
				Button		 = "Build_University",
				WinSize		 = "small",
				Callback	 = function()
					gvMission.CanBuildBombs = true
					Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
					Message(tMat.." "..Weiss.." @cr Jetzt kann ich endlich den Weg frei machen!")
					DisableNpcMarker(GetEntityId("scholar2"))
					local pos = GetPosition("scholar2")
					GUI.DestroyMinimapPulse(pos.X,pos.Y)
				end,
			}
			Interactive_Setup( IO )
			
		return true
		end, }
	AddTribute(tribute)
end

function Treue_IsScholarFree()
	if gvMission.ScholarFree == true then
		EnableNpcMarker(GetEntityId("scholar1"))
		local quest = {
		    EntityName = "matthew",
		    TargetName = "scholar1",
		    Distance = 500,
		    Callback = function( _Quest )
				LookAt("matthew","scholar1")
				LookAt("scholar1","matthew")
				local pos = GetPosition("prison1")
				GUI.DestroyMinimapPulse(pos.X,pos.Y)
				DisableNpcMarker(GetEntityId("scholar1"))
				Logic.SetTaskList( GetEntityId("scholar1"), TaskLists.TL_GC_SCHOLAR_TALK1 )
				local briefing = {restoreCamera = true}
				local AP, ASP = AddPages(briefing)
				BRIEFING_DISTANCE1()
				
				ASP("scholar1",tGut,"Seid Ihr gekommen, um mir einen neuen Lehrstuhl anzubieten?", true)
				ASP("matthew",tMat,"Eigentlich wollte ich lernen wie man Bomben baut. Ich h�hrte, von Euch kann ich es lernen.", true)
				ASP("scholar1",tGut,"Kann das nicht einer Eurer Diebe erledigen?", true)
				ASP("matthew",tMat,"Ich will ja kein Geb�ude sprengen sondern einen Felsen.", true)
				ASP("scholar1",tGut,"Und Ihr wollt nicht, dass es zu einem Erdrutsch kommt. Gut, ich werde es Euch lehren. Aber nur, wenn Ihr"..
									" mir ein Podium errichtet, von dem aus ich die Unterrichtsstunden abhalten kann.", true)
				ASP("scholar1",tGut,"Aber ich will ein Podium aus feinstem Edelholz aus dem "..Gelb.." REGENWALD.", true)
				ASP("HQSteele",tSim,"Holz aus dem Regenwald... Wo bekommt man das her? Vielleicht bei "..Gelb.." Amazon? "..Weiss.." @cr "..
									" Halt! Wieso jubelt Ihr ihm nicht ein Plagiat aus Eichenholz unter. Ich bin mir sicher den Unterschied"..
									" wird er nicht merken!", false)
				ASP("HQSteele",tSim,"Schaut in Euer Tributmen�.", false)
				
				briefing.finished = function()
					local questid	 = 	4
					local questtype	 = 	SUBQUEST_CLOSED
					local questtitle =	"Der L�genbaron"
					local questtext	 =	"Endlich hatte ich einen Weg zum K�nig gefunden, da war er aber auch von einem Erdrutsch versch�ttet."..
										" Der einzige Weg den Brocken aus dem Weg zu r�umen war ihn zu sprengen. Doch ich konnte keine Bomben"..
										" bauen. Mein Berater erz�hlte mir von einem L�genbaron, der mich das lehren k�nnte. @cr @cr "..Mint..""..
										" Diese Ausgabe wurde erf�llt."
					Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
					ReplaceEntity("scholar1",Entities.CU_GCScholar)
					Quest12()
				end
				StartBriefing(briefing)
		    end
		}
		SetupExpedition( quest )
	return true
	end
end

function Treue_BombTheStone()
	if gvMission.CanBuildBombs == true then
		ActiveInteractiveStone()
	return true
	end
end
function ActiveInteractiveStone()
	local pos = GetPosition("bombsperre4")
	GUI.CreateMinimapPulse(pos.X,pos.Y)
	local IO = {
		Name 		 = "sperre4",
		Type 		 = 3,
		Range		 = 1000,
		Costs 		= { 0, 0, 0, 0, 0, 2000, 0, },
		Title		 = "Stein sprengen",
		Text		 = "Legt eine Bombe um den Stein zu sprengen.",
		Button		 = "Hero2_PlaceBomb",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("bombsperre4",Entities.XD_Bomb1)
			local pos = GetPosition("bombsperre4")
			GUI.DestroyMinimapPulse(pos.X,pos.Y)
			local quest = {
				Target = "sperre4",
			    Callback = function( _Quest )
			        Quest10_3()
					Defender_King()
				end
			}
			SetupDestroy( quest )
		end,
	}
	Interactive_Setup( IO )
end

function Quest12End()
	local questid	 = 	5
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Ein Lehrstul f�r den Plagiator"
	local questtext	 =	"Damit mir Guttenplag das Bombenbauen beibrachte, musste ich ihm einen neuen Lehrstuhl besorgen. @cr @cr "..Mint..""..
						" Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local pos = GetPosition("scholar2")
	GUI.CreateMinimapPulse(pos.X,pos.Y)
end

function Briefing_Treue_King1()
	EnableNpcMarker(GetEntityId("king"))
	local quest = {
	    EntityName = "matthew",
	    TargetName = "king",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","king")
			LookAt("king","matthew")
			DisableNpcMarker(GetEntityId("king"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()
			
			ASP("king",tKing,"Seid Ihr es, "..mWil.." ?", true)
			ASP("matthew",tMat,"Nein, mein Name ist "..mMat.." . Wieso fragt Ihr? Erinnert Euch meine Erscheinung an ihn?", true)
			ASP("king",tKing,"Ihr seid ihm wie aus dem Gesicht geschnitten. Ihr habt sogar den gleichen ungepflegten Bart wie er. Aber es sind"..
							" nun schon viele Jahre ins Land gezogen, in denen ich William nicht mehr gesehen habe.", true)
			ASP("matthew",tMat,"Stimmt, der ungepflegte Bart ist ab und er sitzt jetzt hoch zu Ross.", true)
			ASP("king",tKing,"Ist aus ihm doch noch ein echter Ritter geworden? Doch ich h�tte erwartet "..Gelb.." ER "..Weiss.." w�rde mich"..
							" finden. Ihr seid also auch ein getreuer "..mEdt.." oder irre ich?", true)
			ASP("matthew",tMat,"Sir Edward ist an der Pest gestorben.", true)
			ASP("king",tKing,"Das ist ein Schlag mitten in mein Gesicht. Gott im Himmel, warum tut Ihr das? Ist dies eine Pr�fung unseres"..
							" Glaubens? So seid versichert, mein Glaube ist stets aufrichtig und erfordert keine Pr�fungen.", true)
			ASP("matthew",tMat,"Nicht nur wir Suchen nach Euch, "..mDev1.." war Euch auch auf der Spur.", true)
			ASP("king",tKing,"Was ist mit ihm?", true)
			ASP("matthew",tMat,"Er wurde erschlagen.", true)
			ASP("king",tKing,"Dies frohe Kunde stimmt mich freudig. Doch sagt, was ist mit "..mBarc3.." geschehen? Weilt er noch unter uns?", true)
			ASP("matthew",tMat,"Ja, und er w�nscht Euren Tod. Lasst mich Euch helfen, lasst mich Euch sch�tzen.", true)
			ASP("matthew",tKing,"Habt Dank, ich nehme gerne an. Doch wird Barcley es niemals schaffen die Tore zu �ffnen. Ein getreuer Recke"..
							" bewacht den Schl�ssel und die Parolen. Solange der Feind nicht Euer Schlupfloch entdeckt, bin ich absolut sicher.", true)
			
			briefing.finished = function()
				StartChapter9()
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end
-- # # # # # # # # # # CHAPTER 10 # # # # # # # # # # --

function StartChapter9()
	Briefing_Chapter9()
	ReplaceEntity("sperre6", Entities.XD_Rock7); ReplaceEntity("sperre7", Entities.XD_Rock7); ReplaceEntity("sperre8", Entities.XD_Rock7)
	Logic.RemoveQuest( 1, 1 ) Logic.RemoveQuest( 1, 2 ) Logic.RemoveQuest( 1, 3 ) Logic.RemoveQuest( 1, 4 )
	Logic.RemoveQuest( 1, 5 )
	
	Tools.GiveResouces( 4, 100000000, 10000, 50000, 50000, 10000, 50000 )
	SetupPlayerAi( 4, {serfLimit = 12,constructing = false,repairing = true,extracting = 0,} )
end

-- #### ARMIES #### --

function Treue_KingSerfs()
	if IsExisting("Kkeep") and IsExisting("HQKing")then
		if Logic.GetNumberOfEntitiesOfTypeOfPlayer( 2, Entities.PU_Serf )< 10 then
			CreateEntity(2,Entities.PU_Serf,GetPosition("serfspawn2"))
		end
	else
		return true
	end
end

function CreateBarcAttackerToKing()
	SetFriendly( 3, 5); SetFriendly( 3, 7); SetFriendly( 7, 5)
	local B_Army9 = {
	player = 5,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","barc_WP3","mainspawnK",},
	lebensFaden = "Blife1",
	tod = true,					
	zeit = 200,					 
	type = {2}, 	
	menge = 4,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army9 = CreateRobArmee(B_Army9)
	StartArmee(B_Army9)
	
	local B_Army10 = {
	player = 5,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","barc_WP3","mainspawnK",},
	lebensFaden = "Blife1",
	tod = true,					
	zeit = 200,					 
	type = {9}, 	
	menge = 4,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army10 = CreateRobArmee(B_Army10)
	StartArmee(B_Army10)
	
	local B_Army11 = {
	player = 7,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","barc_WP3","mainspawnK",},
	lebensFaden = "Blife1",
	tod = true,					
	zeit = 200,					 
	type = {23}, 	
	menge = 9,					
	erfahrung = 3,				
	refresh = 8,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army11 = CreateRobArmee(B_Army11)
	StartArmee(B_Army11)
	
	local B_Army12 = {
	player = 3,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","barc_WP3","mainspawnK",},
	lebensFaden = "Blife1",
	tod = true,					
	zeit = 200,					 
	type = {14}, 	
	menge = 6,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army12 = CreateRobArmee(B_Army12)
	StartArmee(B_Army12)
	
	local B_Army13 = {
	player = 3,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","barc_WP3","mainspawnK",},
	lebensFaden = "Blife1",
	tod = true,					
	zeit = 200,					 
	type = {18}, 	
	menge = 6,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army13 = CreateRobArmee(B_Army13)
	StartArmee(B_Army13)
	
	MachKumpel(B_Army9,K_Army10)
	MachKumpel(B_Army9,K_Army11)
	MachKumpel(B_Army9,K_Army12)
	MachKumpel(B_Army9,K_Army13)
end

function CreateBarcAttackerToSteele()
	ArmyNine = {
		player 				= 4,
		id 					= 1,
		strength 			= B_Treue_Strength,
		position 			= GetPosition("Bspawn3"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderHeavyCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Bspawn3"),
		spawnGenerator 		= "Bstable1",
		respawnTime 		= B_Treue_Time,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("HQSteele"),
			GetPosition("HQSeren"),
			GetPosition("HQWilliam"),
		},
	}
	SetupArmy( ArmyNine )
	ConrtolArmy9 = StartSimpleJob("ConrtolArmyNine")
	SetupAITroopSpawnGenerator("BarcleySpawnArmy1", ArmyNine)
	
	ArmyTen = {
		player 				= 4,
		id 					= 1,
		strength 			= B_Treue_Strength,
		position 			= GetPosition("Bspawn3"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderHeavyCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Bspawn3"),
		spawnGenerator 		= "Bstable1",
		respawnTime 		= B_Treue_Time,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("HQSteele"),
			GetPosition("HQSeren"),
			GetPosition("HQWilliam"),
		},
	}
	SetupArmy( ArmyTen )
	ConrtolArmy10 = StartSimpleJob("ConrtolArmyTen")
	SetupAITroopSpawnGenerator("BarcleySpawnArmy2", ArmyTen)
	
	ArmyEleven = {
		player 				= 4,
		id 					= 1,
		strength 			= B_Treue_Strength,
		position 			= GetPosition("Bspawn3"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderHeavyCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Bspawn3"),
		spawnGenerator 		= "Bstable1",
		respawnTime 		= B_Treue_Time,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("HQSteele"),
			GetPosition("HQSeren"),
			GetPosition("HQWilliam"),
		},
	}
	SetupArmy( ArmyEleven )
	ConrtolArmy11 = StartSimpleJob("ConrtolArmyEleven")
	SetupAITroopSpawnGenerator("BarcleySpawnArmy3", ArmyEleven)
	
	ArmyTwelve = {
		player 				= 4,
		id 					= 1,
		strength 			= B_Treue_Strength,
		position 			= GetPosition("Bspawn3"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderHeavyCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Bspawn3"),
		spawnGenerator 		= "Bstable1",
		respawnTime 		= B_Treue_Time,
		refresh 			= true,
		maxSpawnAmount 		= 2,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		AttackPos           = {
			GetPosition("HQSteele"),
			GetPosition("HQSeren"),
			GetPosition("HQWilliam"),
		},
	}
	SetupArmy( ArmyTwelve )
	ConrtolArmy9 = StartSimpleJob("ConrtolArmyTwelve")
	SetupAITroopSpawnGenerator("BarcleySpawnArmy4", ArmyTwelve)
end
function ConrtolArmyNine()
	if IsAlive(ArmyNine) then
        TickOffensiveAIController(ArmyNine)
    elseif IsAITroopGeneratorDead(ArmyNine) then
        return true
    end
end
function ConrtolArmyTen()
	if IsAlive(ArmyTen) then
        TickOffensiveAIController(ArmyTen)
    elseif IsAITroopGeneratorDead(ArmyTen) then
        return true
    end
end
function ConrtolArmyEleven()
	if IsAlive(ArmyEleven) then
        TickOffensiveAIController(ArmyEleven)
    elseif IsAITroopGeneratorDead(ArmyEleven) then
        return true
    end
end
function ConrtolArmyTwelve()
	if IsAlive(ArmyTwelve) then
        TickOffensiveAIController(ArmyTwelve)
    elseif IsAITroopGeneratorDead(ArmyTwelve) then
        return true
    end
end

-- #### QUESTS #### --

function Briefing_Chapter9()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("c_barc_pos1",""," ", true)
	briefing.finished = function()
		CreateEntity(8,Entities.PU_Scout,GetPosition("scout_pos1"),"c_scout")
		Move("c_scout","scout_pos2")
		SetPosition("c_barc", GetPosition("c_barc_pos1"))
		LookAt("c_barc","scout_pos2")
		DestroyEntity("c_dev")
		local cutscene={
		StartPosition={ zoom = 2100,rotation = 90,angle = 12,position = GetPosition( "c_barc_pos1" ),},
		Flights={
			{
			position = GetPosition( "c_barc_pos1" ),angle = 8,zoom = 1500,rotation = 100,duration = 10,delay = 3,
			title = Gruen.." KAPITEL IX:",
			text = Gelb.." DIE R�CKKEHR DES K�NIGS",
			},
		},
		Callback=function()
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			Display.SetRenderFogOfWar(0)
			BRIEFING_DISTANCE1()
			
			ASP("c_barc_pos1",tBarc,"Sprech, was hast du zu berichten, Kundschafter?", true)
			ASP("scout_pos2",tBot2,mMat.." hat den K�nig gefunden.", true)
			ASP("nameBridge2",tBot2,"Offenbar gelangt man �ber diese Br�cke zum K�nig. Doch muss Steele einen anderen Weg gefunden"..
									" haben. Vielleicht solltet Ihr den suchen.", false)
			ASP("c_barc_pos1",tBarc,"Seh ich aus wie ein F�hrtenleser? "..Mint.." HARRR HARRR... @cr "..Weiss.." Ich werde diese Tore knacken"..
									" und wenn es das letzte ist was ich tue! Meiner finsteren Macht kann sich niemand entgegen stellen.", true)
			ASP("ratetor1",tBarc,"Weder so ein d�mliches Tor...", false)
			AP{	
				title = tBarc,
				text = "... ...                                       ",
				position = GetPosition("ratetor1"),
				dialogCamera = false,
				action = function()
					local pos = GetPosition("ratetor1")
					Logic.CreateEffect( GGL_Effects.FXKerberosFear, pos.X, pos.Y, 1 )
					ReplaceEntity("ratetor1",Entities.XD_PalisadeGate2)
				end
			}
			AP{	
				title = tBarc,
				text = "... ...                                       ",
				position = GetPosition("ratetor2"),
				dialogCamera = false,
				action = function()
					local pos = GetPosition("ratetor2")
					Logic.CreateEffect( GGL_Effects.FXKerberosFear, pos.X, pos.Y, 1 )
					ReplaceEntity("ratetor2",Entities.XD_PalisadeGate2)
				end
			}
			AP{	
				title = tBarc,
				text = "... noch so eine poblige Br�cke...             ",
				position = GetPosition("bridge2"),
				dialogCamera = false,
				action = function()
					ReplaceEntity("bridge2",Entities.PB_DrawBridgeClosed2)
					MakeInvulnerable("bridge2")
				end
			}
			ASP("c_barc_pos1",tBarc,"Ihr Toten dieser Welt, erhebt euch! Trachtet nach dem Leben des Mannes, wegen dem ihr alle gestorben"..
									" seid. Hohlt Euch das Fleisch des K�nigs, mag es auch noch so z�h sein. @cr @cr "..Mint..""..
									" HARRR HARRR...", true)
			ASP("c_barc_pos1",tBarc,"Der K�nig wird sterben. DAS IST SO SICHER WIE... @cr "..Gelb.." SCHNEE IN DER ARKTIS.", true)
			ASP("HQSteele",tSim,"Ihr m�sst den K�nig sch�tzen. Barcley wird versuchen mit allem was er hat in die Burg einzumarschieren."..
								" Das m�sst Ihr verhindern! Wenn der K�nig "..Grau.." ODER "..Weiss.." seine Burg fallen, dann ist"..
								" alles verloren. All die M�hen vergebens...", false)
			ASP("HQSteele",tSim,"Doch Ihr m�sst auch acht auf Euer eigenes Leben geben. Barcley wird versuchen "..Gelb.." Alles und"..
								" Jeden "..Weiss.." von seinen Reitern und den Schwarzen Rittern in Grund und Boden stampfen zu lassen.", false)
			ASP("HQSteele",tSim,"Und nicht nur das. Ihr m�sst damit rechnen, dass seine Armeen voll sind mit "..Gelb.." DEN TOTEN DES"..
								" LANDES. "..Weiss.." Was das auch immer bedeuten mag.", false)
			
			briefing.finished = function()
				CreateBarcAttackerToKing()
				CreateBarcAttackerToSteele()
				Display.SetRenderFogOfWar(1)
				Quest13()
			end
			StartBriefing(briefing)
		end,
	}
	StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end

function Quest13()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL IX: Die R�ckkehr des K�nigs"
	local questtext	 =	"Endlich war der K�nig gefunden! Nach Jahren die wir nun schon nach ihm suchten. Doch war er die ganze Zeit so nah."..
						" Warum hat er sich uns nie gezeigt? War seine Angst vor Ergreifung so gro� oder f�rchtete er nur den Moment herbei"..
						" der nun gekommen war? @cr @cr Barcley hatte erfahren, dass ich den K�nig gefunden habe und seine finstere"..
						" Macht dazu eingesetzt den Weg freizur�umen. Desweiteren beschwor er eine Armee der Untoten, deren einziges Begehr"..
						" es war den K�nig zu fressen. Diese Armee bestand aus den Soldaten aller bisher besiegten Gegner. @cr @cr "..SZ..""..
						" - TOD: "..mBarc2.." (Kerberos). @cr @cr "..NZ.." - GEB�UDE: - Bergfried verlieren @cr - Tod eines"..
						" der guten Hauptcharakter @cr (\"Matthew Steele\", \"Sir William\", \"Lady Seren\", \"Der K�nig\")"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	StartSimpleJob("Quest13End")
end

function Treue_KingDies()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	
	ASP("mainspawnK",tSim,"Der K�nig wurde erschlagen. Der Feind hat gesiegt. Wir haben versagt. Nun wird sich Barcley zum K�nig"..
							" kr�nen lassen.", false)
	ASP("mainspawnK",tErz,"Wer h�tte gedacht, das unser Kampf am Ende nur vergebene Liebesm�h sein sollte. William wollte das nicht akzeptieren"..
							" und k�mpfte weiter gegen Barcley, bis er den Tod fand. Ich bin seit dem auf der Flucht. Nur Gott wei�, was die"..
							" Zukunft noch f�r mich bereit h�lt...", false)
							
	briefing.finished = function()
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
	end
	StartBriefing(briefing)
end

function Quest13End()
	if GetHealth("king") <1 then
		Logic.RemoveQuest( 1,1 )
		Treue_KingDies()
	return true
	end
	if GetHealth("barcley") <1 then
		Logic.RemoveQuest( 1,1 )
		Outro_King()
	return true
	end
end

function Outro_King()
	for i=1,3 do
		local pos = GetPosition("c_e_king"..i)
		SetEntityName(Tools.CreateGroup(8, Entities.PU_LeaderPoleArm4, 8, pos.X, pos.Y, 270.00 ),"c_eK"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_eK"..i), 4 )
	end
	for i=4,6 do
		local pos = GetPosition("c_e_king"..i)
		SetEntityName(Tools.CreateGroup(8, Entities.PU_LeaderPoleArm4, 8, pos.X, pos.Y, 90.00 ),"c_eK"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_eK"..i), 4 )
	end
	SetPosition("bishop",GetPosition("bis_pos_e")); LookAt("bishop","e_ser2")
	ReplaceEntity("e_king2",Entities.PU_Hero6); ReplaceEntity("e_wil2",Entities.PU_LeaderHeavyCavalry1);
	ReplaceEntity("e_ser2",Entities.CU_Princess); ReplaceEntity("e_mat2_good",Entities.PU_Hero4);
	
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("barcley",""," ", true)
	briefing.finished = function()
		local cutscene={
		StartPosition={ zoom = 3000,rotation = -85,angle = 40,position = GetPosition( "cam11" ),},
		Flights={
			{
			position = GetPosition( "cam12" ),angle = 30,zoom = 3500,rotation = -35,duration = 10,delay = 0,
			title = tErz,
			text = "Und das war das Ende des Hammers...",
			},
			{
			position = GetPosition( "cam13" ),angle = 20,zoom = 4500,rotation = 90,duration = 20,delay = 3,
			title = tErz,
			text = "All seine finstere Kraft hatte ihm nichts gen�tzt. Mit dem Sieg �ber ihn besiegte ich auch den Teufel, an den Barcley"..
					" seine Seele verkauft hatte, um seine unheilige Macht zu bekommen.",
			},
		},
		Callback=function()
			local units = SucheAufDerWelt( 4, 0 )
			for i=1,table.getn(units)do
				if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
					if Logic.IsLeader(units[i])== 1 then
						Logic.DestroyGroupByLeader( units[i] )
					else
						Logic.DestroyEntity( units[i] )
					end
				end
			end
			
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			ASP("cam15",""," ", true)
			Move("e_mat_good","e_mat_pos"); Move("e_wil","e_will_pos")
			briefing.finished = function()
				local cutscene={
				StartPosition={ zoom = 3200,rotation = 90,angle = 6,position = GetPosition( "cam14" ),},
				Flights={
					{
					position = GetPosition( "cam15" ),angle = 10,zoom = 1500,rotation = 95,duration = 10,delay = 0,
					title = tErz,
					text = "Als bald darauf traten wir vor den K�nig. Ich und Sir William hatten viel mit ihm zu besprechen.",
					},
				},
				Callback=function()
					local briefing = {}
					local AP, ASP = AddPages(briefing)
					
					ASP("e_king",tKing,"Treue Recken, der Krone: Wir haben gesiegt.", true)
					ASP("e_wil",tWil,"Wo wart Ihr all die Jahre in denen ich so verzweifelt nach Euch gesucht habe?", true)
					ASP("e_king",tKing,"Asche �ber mein Haupt. Ich habe Verb�ndete gesucht, wo es eigentlich keine gab. Ich war nach Schottland"..
										" gereist, in der Hoffnung "..Gruen.." den Wolf "..Weiss.." f�r meine Sache zu gewinnen.", true)
					ASP("e_wil",tWil,Gruen.." Angus MacClaud "..Weiss.." sollte f�r England k�mpfen? Wieso, habt Ihr mir etwa nicht vertraut?", true)
					ASP("e_king",tKing,"Ich dachte dem Wolf w�rde es nicht gefallen, wenn ein englischer Lord den zarten Frieden gef�hrden"..
										" und in das Land der Clans einfallen w�rde. Mit seinen Truppen wollte ich "..Gelb.." UNS "..Weiss..""..
										" einen Vorteil verschaffen.", true)
					ASP("e_king",tKing,"Er hat mir Fu�truppen der "..Gruen.." Schottische Garde "..Weiss.." entsandt.", true)
					ASP("e_mat_pos",tMat,"Wir sollten uns nicht gegenseitig unsere Fehler vorhalten, und froh sein "..Gelb.." ALLE "..Weiss..""..
										" Feinde des Reiches vernichtet zu haben.", true)
					ASP("e_king",tKing,"Lasst mich Euch alle f�r eure treuen Dienste f�rstlich entlohnen.", true)
					ASP("e_ser",tSer,"William. Es wird Zeit, dass ihr das versprechen, welches Ihr mir gabt, einl�st und mich ehelicht.", true)
					AP{	
						title = tWil,
						text = "So sei es. Lasst uns so bald wie m�glich vor den Altar treten.",
						position = GetPosition("e_wil"),
						dialogCamera = true,
						action = function()
							Display.SetRenderFogOfWar(0)
							Explore.Show( "ShowCloisterFinal", "cloister", 5000 )
							BRIEFING_ZOOMDISTANCE = 5000
							BRIEFING_ZOOMANGLE = 18
						end
					}
					AP{	
						title = tErz,
						text = "William und Lady Seren heirateten in der Abtei des Bischofs und sowohl ich als auch der K�nig wohnten dem bei.",
						position = GetPosition("cloister"),
						dialogCamera = false,
						action = function()
							Display.SetRenderFogOfWar(1)
							local pos = GetPosition("cloister")
							Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, pos.X-500, pos.Y, 1 )
							Logic.CreateEffect( GGL_Effects.FXYukiFireworksFear, pos.X+700, pos.Y-500, 1 )
							Logic.CreateEffect( GGL_Effects.FXYukiFireworksJoy, pos.X-600, pos.Y-900, 1 )
							BRIEFING_DISTANCE3()
						end
					}
					ASP("HQSteele",tErz,"Der K�nig schenkte mir eine prunkvolle Residenz in Schottland. So konne ich endlich Abstand nehmen"..
										" von all dem Stress, den das Burgleben so mit sich f�hrte.", false)
					ASP("HQSteele",tErz,"Bald schon machte ich mich auf den Weg. Es waren alle Feinde besiegt... @cr "..Orange.." WIRKLICH"..
									" ALLE?", false)
					
					briefing.finished = function()
						Display.SetRenderFogOfWar(1)
						Logic.PlayerSetGameStateToWon( 1 )
						Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveWon_rnd_01, 100 )
					end
					StartBriefing(briefing)
				end,
			 }
			 StartCutscene(cutscene)
			end
			StartBriefing(briefing)
		end,
	 }
	 StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end
-- # # # # # # # # # # # # # # # # # # # # # # # # # # --
-- WEG DES VERRAT
-- # # # # # # # # # # # # # # # # # # # # # # # # # # --

-- # # # # # # # # # # CHAPTER 10 # # # # # # # # # # --

function StartChapter10()
	SetHostile( 1, 2 )
	SetFriendly( 1, 3 )
	SetFriendly( 1, 4 )
	SetNeutral( 1, 5 )
	SetNeutral( 1, 7 )
	SetNeutral( 5, 7 )
	Defender_Barcley()
	Defender_Deveraux()
	Defender_Seren()
	gvMission.WayChosed = 2
	Briefing_Chapter10()
	ReplaceEntity( "sperre3", Entities.XD_Rock7 ); ReplaceEntity( "sperre5", Entities.XD_Rock7 )
	ReplaceEntity( "sperre6", Entities.XD_Rock7 ); ReplaceEntity( "sperre7", Entities.XD_Rock7 )
	ReplaceEntity( "sperre8", Entities.XD_Rock7 )
	ReplaceEntity("Stower1", Entities.PB_Tower3); ChangePlayer("Stower1", 2)
	ReplaceEntity("Stower2", Entities.PB_Tower3); ChangePlayer("Stower2", 2)
	Logic.RemoveQuest( 1, 1 ) Logic.RemoveQuest( 1, 2 ) Logic.RemoveQuest( 1, 3 ) Logic.RemoveQuest( 1, 4 )
end

-- #### QUESTS #### --

function Briefing_Chapter10()
	for i=1,5 do
		local pos = GetPosition("c_bK"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.CU_VeteranMajor, 3, pos.X, pos.Y, 270.00 ),"c_bK"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_bK"..i), 4 )
		local pos = GetPosition("c_R"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.PU_LeaderRifle1, 3, pos.X, pos.Y, 270.00 ),"c_R"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_R"..i), 4 )
	end
	for i=6,10 do
		local pos = GetPosition("c_bK"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.CU_VeteranMajor, 3, pos.X, pos.Y, 90.00 ),"c_bK"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_bK"..i), 4 )
		local pos = GetPosition("c_R"..i.."pos")
		SetEntityName(Tools.CreateGroup(8, Entities.PU_LeaderRifle1, 3, pos.X, pos.Y, 90.00 ),"c_R"..i)
		GUI.LeaderChangeFormationType( GetEntityId("c_R"..i), 4 )
	end
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cloister",""," ", true)
	briefing.finished = function()
		ReplaceEntity( "betrail_mat", Entities.PU_Hero4 )
		ReplaceEntity( "betrail_wil", Entities.PU_LeaderHeavyCavalry1 )
		SetPosition("c_dev", GetPosition("c_dev_pos1"))
		LookAt("c_dev","c_barc")
		local cutscene={
		StartPosition={ zoom = 2500,rotation = 5,angle = 12,position = GetPosition( "cloister" ),},
		Flights={
			{
			position = GetPosition( "cloister" ),angle = 11,zoom = 4200,rotation = -30,duration = 10,delay = 5,
			title = Gruen.." KAPITEL X:",
			text = Gelb.." DIE EROBERUNG DER ABTEI",
			},
		},
		Callback=function()
			BRIEFING_ZOOMDISTANCE = 2000
			BRIEFING_ZOOMANGLE = 13
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			
			ASP("c_barc",tErz,"Und so nahm ich das Angebot des Hammers an. Nicht ahnend welch faustischen Pakt ich einging...", true)
			ASP("c_dev",tDev,"Sagt jetzt nicht, dass dieser ehemalige Bedienstete Euer angebot angenommen hat...", true)
			ASP("c_barc",tBarc,"Doch, das hat er...", true)
			ASP("c_dev",tDev,"William hat die Dummheit seines Vaters geerbt und ist au�er Stande ordentliches Personal einzustellen.", true)
			ASP("c_dev",tDev,"Unser Vater hatte n�mlich einen Privatkredit verheimlicht und musste in dessen Folge abdanken, sodass sein"..
							" Sohn Page statt Burgherr wurde. Gottseidank hat ihn meine Mutter schon lange vorher verjagt.", true)
			ASP("c_barc",tBarc,Mint.." HARRR HARRR... @cr "..Weiss.." Gutes Personal ist aber heutzutage schwer zu finden"..
							" auf dem Arbeitsmarkt.", true)
			ASP("betrail_wil",tWil,mMat.." , Euer Verrat erz�rnt mich sehr! Wie k�nnt Ihr es wagen euch Barcley anzuschlie�en.", false)
			ASP("betrail_mat",tMat,"So versteht doch! Der K�nig ist schwach. Wenn er denn �berhaupt noch lebt. Habt Ihr ihn gesehen, William?"..
								" Seitdem Ihr mich zu einem Adligen machtet, habe ich nicht mal den Zipfel seines Umhangs gesehen.", true)
			ASP("betrail_wil",tWil,"Der K�nig tr�gt keinen Umhang, sondern eine Kutte...", true)
			ASP("betrail_mat",tMat,"Versteht Ihr was ich meine. Schlie�t Euch mir an, dann wird Euch nichts geschehen. Gemeinsam k�nnen wir"..
									" uns die Herrschaft teilen, sobald die anderen aus dem Weg ger�umt sind.", true)
			AP{	
				title = tWil,
				text = "Verschwindet von hier, oder ich vernichte das Monster welches ich selbst einst schuf!",
				position = GetPosition("betrail_wil"),
				dialogCamera = false,
				action = function()
					BRIEFING_CAMERA_FLYTIME = 3
					BRIEFING_TIMER_PER_CHAR = 4
					BRIEFING_ZOOMDISTANCE = 3500
					BRIEFING_ZOOMANGLE = 18
				end
			}
			AP{	
				title = "",
				text = "                    ",
				position = GetPosition("betrail_wil"),
				dialogCamera = false,
				action = function()
					Move("betrail_wil","betrail_wilPos")
					Move("betrail_mat","betrail_matPos")
					BRIEFING_CAMERA_FLYTIME = 0
					BRIEFING_TIMER_PER_CHAR = 1
					BRIEFING_DISTANCE1()
					ToggleBriefingBar(0)
				end
			}
			AP{	
				title = tSim,
				text = "Auch wenn Ihr William und damit den K�nig hintergangen habt, werde ich Euch weiterhin treu sein. Ich habe es geschworen"..
						" und ich breche niemals mein Wort, egal was mein Herr auch tun mag.",
				position = GetPosition("HQSteele"),
				dialogCamera = false,
				action = function()
					ToggleBriefingBar(1)
				end
			}
			ASP("HQWilliam",tWil,"Ihr habt mich verraten, nachdem "..Gelb.." ICH "..Weiss.." euch wie meinen "..Gelb.." EIGENEN "..Weiss..""..
								" Sohn behandelt habe. @cr "..Rot.." SP�RT MEINEN ZORN!", false)
			ASP("HQSteele",tSim,mWil.." ist ein m�chtiger Gegner. Vermutlich alle verbleibenden K�nigstreuen unterstehen seinem Befehl. Er wird"..
								" euch bestimmt mit Schwertk�mpfern, leichten Kanonen und Armbrustsch�tzen angreifen. Seid auf der Hut!", false)
			ASP("HQSteele",tSim,"Soll ich einen Boten zu Lord Barcley entsenden, damit er uns Hilfe sendet?", false)
								
			local Hilfe = AP { 
				mc = {
					title   = "Siedler Team", 
					text   = Gelb.." "..gvMission.Player.." "..Weiss.." , jetzt m�sst Ihr entscheiden. Denkt Ihr, "..mWil..""..
								" k�nnte Euch gef�hrlich werden?", 
					firstText  = "Nein, den schaffe ich mit Links.", 
					secondText = "Ja, ich k�nnte Hilfe gebrauchen.", 
					firstSelected = 18, 
					secondSelected = 20,  
				},
				position = GetPosition( "matthew" ),
				dialogCamera = true,
			}
			ASP("HQSteele",tSim,"Na wenn das mal gut geht...", false)
			
			AP()
			
			ASP("HQHammer",tBarc,"Ihr erwartet doch nicht etwa Unterst�tzung? Seht es als Vertrauensbeweis an. Ich vertraue darauf, dass"..
								" Ihr Euch nicht gleich von Eurem ehemaligen Meister ins Boxhorn jagen lasst... @cr "..Mint.." HARRR HARRR...", false)
			ASP("HQSteele",tSim,"Das h�ttet Ihr Euch doch denken k�nnen, dass Ihr von DEM keine Hilfe erwarten k�nnt. Barcley wird sicherlich"..
								" seinen Spa� dabei haben, die M�hen eines anderen zu beobachten!", false)
			
			briefing.finished = function()
				Display.SetRenderFogOfWar(1)
				DestroyEntity("betrail_wil"); DestroyEntity("betrail_mat")
				local pos = GetPosition( "matthew" )
				Camera.ScrollSetLookAt(pos.X,pos.Y)
				gvMission.InfoText1 = "Verbleibende Invasionen"
				gvMission.Value1 = 6
				StartSimpleJob( "StopWilliamInvasion" )
				Invasion_William()
				Write_Quest14()
			end
			StartBriefing(briefing)
			Display.SetRenderFogOfWar(0)
		end,
	}
	StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end
function Write_Quest14()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL X: Die Eroberung der Abtei"
	local questtext	 =	" Lord Barcley und die anderen hatten mit allem Recht. Sie waren keine Verschw�rer, sondern die Retter unserer stolzen"..
						" Nation. Das Reich hatte viele Feinde und unser schwacher K�nig, der sich lieber irgendwo versteckt hielt, als wie ein Mann"..
						" zu k�mpfen, war nicht in der Lage, uns vor dem Feind zu bewahren @cr Sir William und seine Anh�ngerschaft versuchten"..
						" nun, mich ins Jenseits zu bef�rdern. Eine gewaltige Invasion stand mir bevor. @cr @cr "..NZ.." "..
						" - TOD: "..mMat.." @cr - GEB�UDE: - Bergfried verlieren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Williams Invasion"
	local questtext	 =	"William startet einen Angriff auf mich, anstatt mein Angebot anzunehmen und sich ebenfalls Barcley anzuschlie�en..."..
						" @cr @cr "..SZ.." - BESIEGEN: Alle feindlichen Invasoren @cr @cr "..NZ.." "..
						" - TOD: "..mMat.." @cr - GEB�UDE: - Bergfried verlieren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

-- +++ Invasion William Start +++ --

WILLIAMINVASIONCOUNTER = 7

function Invasion_William()
	WilliamTable = {}
	WilliamTime = WilIn_Time
	WILLIAMINVASIONCOUNTER = WILLIAMINVASIONCOUNTER - 1
	if WILLIAMINVASIONCOUNTER > 0 then
		for i=1,WilIn_Strength do
			CreateMilitaryGroup( 2,Entities.PU_LeaderSword4,8,GetPosition("invasion2"),"WilliamAttackerSword"..i )
			GUI.LeaderChangeFormationType(GetEntityId("WilliamAttackerSword"..i), 4 )
			table.insert(WilliamTable,GetEntityId("WilliamAttackerSword"..i))
			
			CreateMilitaryGroup( 2,Entities.PU_LeaderBow3,8,GetPosition("invasion2"),"WilliamAttackerBow"..i )
			GUI.LeaderChangeFormationType(GetEntityId("WilliamAttackerBow"..i), 4 )
			table.insert(WilliamTable,GetEntityId("WilliamAttackerBow"..i))
			
			CreateMilitaryGroup( 2,Entities.PU_LeaderPoleArm3,8,GetPosition("invasion2"),"WilliamAttackerSpear"..i )
			GUI.LeaderChangeFormationType(GetEntityId("WilliamAttackerSpear"..i), 4 )
			table.insert(WilliamTable,GetEntityId("WilliamAttackerSpear"..i))
		end
		StartSimpleJob( "Invasion_William_Control" )
	end
end
function Invasion_William_Control()
	if AreDead( WilliamTable )then
		if WILLIAMINVASIONCOUNTER > 1 then
			WilliamTime = WilliamTime -1
			if WilliamTime == 0 then
				WilIn_Strength = WilIn_Strength + WilIn_Addition
				Invasion_William()
				return true
			end
		else
			Invasion_William()
		return true
		end
	else
		if Counter.Tick2("Invasion_William_Control",5)then
			for i=1,table.getn( WilliamTable )do
				if AreEnemiesInArea( 2, GetPosition(WilliamTable[i]), 2000 )then
					Attack(WilliamTable[i], "HQSteele" )
				else
					Move(WilliamTable[i], "HQSteele" )
				end
			end
		end
	end
end
function StopWilliamInvasion()
	if WILLIAMINVASIONCOUNTER > 0 then
		Show_Infoline( 1, gvMission.InfoText1, WILLIAMINVASIONCOUNTER-1, gvMission.Value1 )
	elseif WILLIAMINVASIONCOUNTER == 0 then
		CombatScene()
	return true
	end
end

-- +++ Invasion William End +++ --

function Briefing_NachWilliamInvasion()
	BRIEFING_DISTANCE1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	
	AP{	
		title = tWil,
		text = "Diese Schlacht mag an Euch gehen, den Krieg werdet Ihr aber nicht gewinnen!",
		position = GetPosition("HQWilliam"),
		dialogCamera = false,
		action = function()
			BRIEFING_DISTANCE1()
		end
	}
	ASP("matthew",tSim,"Mein Herr, Ihr habt die Invasion �berlebt... @cr Ihr solltet jetzt mit "..mBarc2.." sprechen."..
					" Er hat einen wichtigen Auftrag f�r Euch.",true)
	
	briefing.finished = function()
		Display.SetRenderFogOfWar(1)
		WriteQuest15()
	end
	StartBriefing(briefing)
	Display.SetRenderFogOfWar(0)
end

function WriteQuest15()
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Williams Invasion"
	local questtext	 =	"William startet einen Angriff auf mich, anstatt mein Angebot anzunehmen und sich ebenfalls Barcley anzuschlie�en..."..
						" @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Audienz"
	local questtext	 =	"Nachdem die Truppen Sir Williams zur�ckgeschlagen wurden, lie� mich der Hammer rufen. Ich z�gerte"..
						" nicht diese Audienz wahrzunehmen... @cr @cr "..SZ.." - sprecht mit Barcley"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	BriefingBarcley1()
end

function BriefingBarcley1()
	EnableNpcMarker(GetEntityId("barcley"))
	local quest = {
	EntityName = "matthew",TargetName = "barcley",Distance = 500,
	Callback = function(_Quest)
		DisableNpcMarker(GetEntityId("barcley")); LookAt("barcley","matthew"); LookAt("matthew","barcley");
		BRIEFING_DISTANCE1()
		local briefing = {restoreCamera = true}
		local AP, ASP = AddPages(briefing)
		
		ASP("matthew",tMat,"Ihr lie�et mich rufen, "..Gelb.." Master "..Weiss.." Barcley?",true)
		ASP("barcley",tBarc,"So ist es, so ist es. Ihr habt mich wohl zufrieden gestellt mit Euer Wehrhaftigkeit gegen Sir William,"..
							" "..Gruen.." dem Ehrlichen. "..Weiss.." Doch ich habe ein wichtigeres Anliegen:",true)
		ASP("cloisterf",tBarc,"Diese Abtei stellt nicht nur Manuskripte her, die die Ehre desjenigen erh�hen, der sie lie�t, nein sie"..
							" beherbergt auch ein wichtiges Utensil, ohne das wir den alten K�nig nicht absetzen k�nnen.",false)
		ASP("matthew",tMat,"Was f�r ein Utensil soll das sein?",true)
		ASP("barcley",tBarc,"Eine "..Gelb.." Reliquie "..Weiss.." genannt das "..Gruen.." Heilige Zepter. "..Weiss.." Nur mit seiner Hilfe"..
							" kann ein neuer K�nig eigesetzt werden. @cr ICH WILL DIESES ZEPTER!",true)
		ASP("HQSeren",tBarc,"Diese Abtei wird jedoch bewacht von dieser Hexe, die sich meinem Willen nur f�gte, solange ich garantiere, dass"..
							" Ihr, William, nicht in Gefahr geraten w�rdet. Lady Seren hat uns verraten! @cr ICH WILL IHREN KOPF, IST DAS KLAR?!",false)
		ASP("barcley",tBarc,"Damit h�tten wir auch schon alles beisammen! @cr 1. Hisst Eure Flagge auf der Plazza des Klosters @cr 2."..
							" Zerst�rt die Festung der Lady.",true)
		ASP("barcley",tBarc,"Noch irgendwelche Fragen?",true)
		ASP("matthew",tMat,"Nein",true)
		ASP("brakewall_4",tBarc,"Gut. Meine Statiker behaupten, hier sei eine schwache Stelle in der Mauer. Vielleicht k�nnt ihr so die"..
							" Verteidigung zu umgehen." ,false)
		ASP("HQSteele",tSim,"Lasst uns einen Dieb ausbilden und ihm die Sabotage erlernen. So bekommen wir die Mauer bestimmt klein." ,false)

		briefing.finished = function()
			WriteQuest16()
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(quest)
end

function WriteQuest16()
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Audienz"
	local questtext	 =	"Nachdem die Truppen Sir Williams zur�ckgeschlagen wurden, lie� mich der Hammer rufen. Ich z�gerte"..
						" nicht diese Audienz wahrzunehmen... @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL X: Die Eroberung der Abtei"
	local questtext	 =	" Lord Barcley und die anderen hatten mit allem Recht. Sie waren keine Verschw�rer, sondern die Retter unserer stolzen"..
						" Nation. Das Reich hatte viele Feinde und unser schwacher K�nig, der sich lieber irgendwo versteckt hielt, als wie ein Mann"..
						" zu k�mpfen, war nicht in der Lage uns vor dem Feind zu bewahren @cr Lady Seren hatte uns Verraten. Sie hielt lieber"..
						" zu William anstatt zu unserer Natrion. Ihre Abtei beherbergt eine wichtige Reliquie, die Master Barcley ben�tigt um"..
						" den schwachen K�nig abzusetzen. Ich muss ihm diese Reliquie beschaffen. @cr @cr "..SZ.." - ZERST�REN: Festung von"..
						" Lady Seren @cr - EROBERUNG: Das Kloster @cr @cr "..NZ.."  - TOD: "..mMat.." @cr - GEB�UDE: - Bergfried verlieren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Explosive Alternative"
	local questtext	 =	"Barcley er�ffnete mir, dass die Mauer der Abtei an einer Stelle besonders schwach sei. Daraufhin gab mir mein Berater den"..
						" Tipp sie an dieser Stelle von einem Dieb zerst�ren zu lassen. @cr @cr "..SZ.." - ERFORSCHEN: Sabotage @cr - Einen Dieb"..
						" vor der Mauer in Stellung bringen."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	VMBid = StartSimpleJob("Verrat_Mauerbrecher")
	StartSimpleJob("Quest16End")
	ReplaceEntity( "sperre1", Entities.XD_Rock7 )
end

function Verrat_Mauerbrecher()
	local thief = SucheAufDerWelt( 1, Entities.PU_Thief, 300, GetPosition("CW1"))
	if table.getn(thief) >0 and Logic.IsTechnologyResearched( 1, Technologies.T_ThiefSabotage )== 1 then
		for i=1,table.getn(thief)do SetPosition(thief[i],GetPosition("CW2"))end
		WallBreakScene()
		
		local questid	 = 	4
		local questtype	 = 	SUBQUEST_CLOSED
		local questtitle =	"Explosive Alternative"
		local questtext	 =	"Barcley er�ffnete mir, dass die Mauer der Abtei an einer Stelle besonders schwach sei. Daraufhin gab mir mein Berater den"..
							" Tipp sie an dieser Stelle von einem Dieb zerst�ren zu lassen. @cr @cr "..Mint.." Dieser Auftrag wurde erf�llt."
		Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	return true
	end
end
function Quest16End()
	if GetPlayer("cloisterf")== 1 and IsDeadWrapper("HQSeren")then
		StartChapter11()
		EndJob(VMBid)
	return true
	end
end

-- # # # # # # # # # # CHAPTER 11 # # # # # # # # # # --

function StartChapter11()
	Briefing_Chapter11()
	Defender_William()
	StartSimpleJob( "EndChapter11" )
	SetPosition("william",GetPosition("willpos4")); ChangePlayer("william",8)
	ReplaceEntity( "sperre9", Entities.XD_Rock7 ); ReplaceEntity( "sperre10", Entities.XD_Rock7 )
	Logic.RemoveQuest( 1, 1 ) Logic.RemoveQuest( 1, 2 ) Logic.RemoveQuest( 1, 3 ) Logic.RemoveQuest( 1, 4 )
end

-- #### ARMIES #### --

function CreateWilliamAttacker1()
	WAttOne = {
		player 				= 2,
		id 					= 1,
		strength 			= W_Verrat_Strength,
		position 			= GetPosition("Wspawn4"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PV_Cannon2, 0},
			{Entities.PV_Cannon2, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Wspawn4"),
		spawnGenerator 		= "Wbarracks2",
		respawnTime 		= W_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 3,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( WAttOne )
	ConrtolWAtt1 = StartSimpleJob("ControlWAttacker1")
	SetupAITroopSpawnGenerator("WilliamSpawnArmy1", WAttOne)
	
	WAttTwo = {
		player 				= 2,
		id 					= 2,
		strength 			= W_Verrat_Strength,
		position 			= GetPosition("Wspawn4"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PV_Cannon2, 0},
			{Entities.PV_Cannon2, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Wspawn4"),
		spawnGenerator 		= "Wbarracks2",
		respawnTime 		= W_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 3,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( WAttTwo )
	ConrtolWAtt2 = StartSimpleJob("ControlWAttacker2")
	SetupAITroopSpawnGenerator("WilliamSpawnArmy2", WAttTwo)
	
	WAttThree = {
		player 				= 2,
		id 					= 3,
		strength 			= W_Verrat_Strength,
		position 			= GetPosition("Wspawn4"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PV_Cannon2, 0},
			{Entities.PV_Cannon2, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Wspawn4"),
		spawnGenerator 		= "Wbarracks2",
		respawnTime 		= W_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 3,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( WAttThree )
	ConrtolWAtt3 = StartSimpleJob("ControlWAttacker3")
	SetupAITroopSpawnGenerator("WilliamSpawnArmy3", WAttThree)
	
	WAttFour = {
		player 				= 2,
		id 					= 4,
		strength 			= W_Verrat_Strength,
		position 			= GetPosition("Wspawn4"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PV_Cannon2, 0},
			{Entities.PV_Cannon2, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Wspawn4"),
		spawnGenerator 		= "Wbarracks2",
		respawnTime 		= W_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 3,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( WAttFour )
	ConrtolWAtt4 = StartSimpleJob("ControlWAttacker4")
	SetupAITroopSpawnGenerator("WilliamSpawnArmy4", WAttFour)
	
	WAttFive = {
		player 				= 2,
		id 					= 5,
		strength 			= W_Verrat_Strength,
		position 			= GetPosition("Wspawn4"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PU_LeaderBow3, 8},
			{Entities.PV_Cannon2, 0},
			{Entities.PV_Cannon2, 0},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Wspawn4"),
		spawnGenerator 		= "Wbarracks2",
		respawnTime 		= W_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 3,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 2,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( WAttFive )
	ConrtolWAtt5 = StartSimpleJob("ControlWAttacker5")
	SetupAITroopSpawnGenerator("WilliamSpawnArmy5", WAttFive)
end

function ControlWAttacker1()
	if IsAlive(WAttOne) then
        TickOffensiveAIController(WAttOne)
		Synchronize(WAttOne,WAttTwo)
		Synchronize(WAttOne,WAttThree)
		Synchronize(WAttOne,WAttFour)
		Synchronize(WAttOne,WAttFive)
    elseif IsAITroopGeneratorDead(WAttOne) then
        return true
    end
end
function ControlWAttacker2()
	if IsAlive(WAttTwo) then
        TickOffensiveAIController(WAttTwo)
    elseif IsAITroopGeneratorDead(WAttTwo) then
        return true
    end
end
function ControlWAttacker3()
	if IsAlive(WAttThree) then
        TickOffensiveAIController(WAttThree)
    elseif IsAITroopGeneratorDead(WAttThree) then
        return true
    end
end
function ControlWAttacker4()
	if IsAlive(WAttFour) then
        TickOffensiveAIController(WAttFour)
    elseif IsAITroopGeneratorDead(WAttFour) then
        return true
    end
end
function ControlWAttacker5()
	if IsAlive(WAttFive) then
        TickOffensiveAIController(WAttFive)
    elseif IsAITroopGeneratorDead(WAttFive) then
        return true
    end
end

function CreatePrivinzDefender()
	
	local Description1 = {maxNumberOfSoldiers = 8,minNumberOfSoldiers = 4,experiencePoints = 3,leaderType = Entities.PU_LeaderSword4}
	local Description2 = {maxNumberOfSoldiers = 8,minNumberOfSoldiers = 4,experiencePoints = 3,leaderType = Entities.PU_LeaderBow3}
	local Description3 = {maxNumberOfSoldiers = 8,minNumberOfSoldiers = 4,experiencePoints = 3,leaderType = Entities.PU_LeaderPoleArm3}
	local Description4 = {maxNumberOfSoldiers = 0,minNumberOfSoldiers = 0,experiencePoints = 0,leaderType = Entities.PV_Cannon2}
	
	ProDefOne = {
		player = 2,
		id = 6,
		rodeLength = 1000,
		strength = 8,
		position = GetPosition("provinzdeff1"),
		}
    SetupArmy(ProDefOne)
    for i=1,3 do EnlargeArmy(ProDefOne,Description1)end
	for i=1,3 do EnlargeArmy(ProDefOne,Description2)end
	for i=1,2 do EnlargeArmy(ProDefOne,Description4)end
	
	ProDefTwo = {
		player = 2,
		id = 7,
		rodeLength = 1000,
		strength = 8,
		position = GetPosition("provinzdeff2"),
		}
    SetupArmy(ProDefTwo)
	for i=1,2 do EnlargeArmy(ProDefTwo,Description2)end
	for i=1,4 do EnlargeArmy(ProDefTwo,Description3)end
	for i=1,2 do EnlargeArmy(ProDefTwo,Description4)end
	
	DefOne1 = StartSimpleJob("ControlProDefOne")
	DefOne2 = StartSimpleJob("ControlProDefTwo")
end

function ControlProDefOne()
	if Counter.Tick2("ControlProDefOne",10)then
		Defend( ProDefOne )
	end
	if IsDeadWrapper(ProDefOne)then
		return true
	end
end
function ControlProDefTwo()
	if Counter.Tick2("ControlProDefTwo",10)then
		Defend( ProDefTwo )
	end
	if IsDeadWrapper(ProDefTwo)then
		return true
	end
end

-- #### QUESTS #### --

function Briefing_Chapter11()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	ASP("mainspawnS",tSer,Grau.."sterbend "..Weiss.." @cr Sagt Sir William... dass... ich ihn... liebe... ", false)
	ASP("HQWilliam",""," ", true)
	briefing.finished = function()
		local units = SucheAufDerWelt( 2, 0, 14000, GetPosition( "S_patrol1" ) )
		for i=1,table.getn(units)do
			if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
				if Logic.IsLeader(units[i])== 1 then
					Logic.DestroyGroupByLeader( units[i] )
				else
					Logic.DestroyEntity( units[i] )
				end
			end
		end
		
		local cutscene={
		StartPosition={ zoom = 6000,rotation = -160,angle = 8,position = GetPosition( "HQWilliam" ),},
		Flights={
			{
			position = GetPosition( "HQWilliam" ),angle = 9,zoom = 6000,rotation = -140,duration = 10,delay = 3,
			title = Gruen.." KAPITEL XI:",
			text = Gelb.." DER VERRAT",
			},
		},
		Callback=function()
			ReplaceEntity( "b_c_mat", Entities.PU_Hero4 )
			BRIEFING_ZOOMDISTANCE = 1500
			BRIEFING_ZOOMANGLE = 5
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			
			ASP("c_barc",tBarc,"Ich bin mehr als zufrieden mit Euch, "..Gelb.." Sir Steele. "..Weiss.." Mit dem Tod der Hexe habt Ihr dem"..
								" Feind einen schweren Schlag versetzt.", true)
			ASP("c_dev",tDev,"Aber noch viel erfreulicher ist, dass das Herz meines Bruders nun unwiderruflich in 1000 Fetzen zerrissen"..
								" wurde. Und "..Gelb.." DAS "..Weiss.." freut mich so sehr, dass ich Euch ein Geschenk machen werde...", true)
			ASP("b_c_mat",tMat,"Was ist mit der "..Gelb.." Macht "..Weiss.." und dem "..Gelb.." Ruhm "..Weiss.." den Ihr mir versprochen"..
								" habt. Ich sehe keinen Ruhm darin, Frauen umzubringen.", true)
			ASP("c_barc",tBarc,"Sie mag eine Frau gewesen sein, aber sie war eine "..Gelb.." hinterh�ltige "..Weiss.." Verr�terin. Eine"..
								" Gefahr, die es galt auszumerzen. Gerade aufregend genug, zu testen, wie Ernst es Euch ist. Aber jetzt"..
								" warten gr��ere Aufgaben auf Euch. Ihr werdet "..mWil.." erschlagen und Euch f�r immer Eurer Vergangenheit"..
								" als sein Knecht entledigen.", true)
			ASP("c_barc",tBarc,"Au�erdem erwarte ich, dass Ihr seine L�ndereien f�r unsere Sache beansprucht!", true)
			AP{	
				title = tMat,
				text = "Ja, My Lord. @cr Ich werde Euch nicht entt�uschen.",
				position = GetPosition("cam10"),
				dialogCamera = false,
				action = function()
					Move("b_c_mat","b_c_mat_pos")
					BRIEFING_DISTANCE2()
				end
			}
			ASP("c_barc",tBarc,"So, das sollte ihn eine Weile besch�ftigen, w�hrend wir weiterhin alles in Bewegung setzen, um den K�nig zu"..
								" finden. Wenn Steele zur�ck kommt, brauchen wir ihn vielleicht nicht mehr... @cr "..Mint.." HARRR HARRR...", true)
			AP{	
				title = tWil,
				text = "IHR HABT MEINE GELIEBTE ERMORDET! @cr "..Gelb.." DAS WIRD EUCH NIEMALS VERGEBEN! @cr "..Rot.." ICH WERDE"..
						" EUCH BIS ANS ENDE MEINER TAGE JAGEN!",
				position = GetPosition("HQWilliam"),
				dialogCamera = false,
				action = function()
					BRIEFING_DISTANCE3()
				end
			}
			ASP("HQSteele",tSim,"Sire, begeht nicht den Fehler, den Zorn eines Mannes zu untersch�tzen, dessen Liebe Ihr auf dem"..
								" Gewissen habt!", false)
			
			briefing.finished = function()
				Display.SetRenderFogOfWar(1)
				WriteQuest17()
				Quest17()
			end
			StartBriefing(briefing)
			Display.SetRenderFogOfWar(0)
		end,
	}
	StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end

function WriteQuest17()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL XI: Der Verrat"
	local questtext	 =	"Nachdem ich die Abtei erobert hatte, war Master Barcley gar entz�ckt von meiner Leistung. Er vertraute mir die heikle"..
						" Mission an, Sir William, meinen ehemaligen Master, den Garaus zu machen. Doch Sir William schwor mir blutige Rache,"..
						" weil seine Geliebte auf mein Gehei� hin erschlagen wurde. Doch h�tten sie sich alle Master Barcley angeschlossen, so"..
						" wie ich es von Anfang an gewollt hatte, w�re doch niemand zuschaden gekommen."..
						" @cr @cr "..SZ.." - TOD: - "..mWil.." (Kavalerist) @cr - EROBERUNG: - 2 Provinzen Sir Williams erobern @cr @cr "..NZ..""..
						" - TOD: "..mMat.." @cr - GEB�UDE: - Bergfried verlieren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

function Quest17()
	Sound.PlayGUISound( VoicesMentor_TRADE_SendResourcesSulfur, 100 )
	Message("Ihr habt ein Geschenk in H�he von 5000 Schwefel erhalten.")
	Tools.GiveResouces( 1, 0, 0, 0, 0, 0, 5000 )
	CreateWilliamAttacker1()
	CreatePrivinzDefender()
	
	local quest = {
		Target = "HQWilliam",
	    Callback = function( _Quest )
	        Briefing_WilliamFortressDestroyed()
		end
	}
	SetupDestroy( quest )
end

function Briefing_WilliamFortressDestroyed()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	local units = SucheAufDerWelt( 2, 0, 14500, GetPosition( "Wpatrol1_2" ) )
	for i=1,table.getn(units)do
		if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
			if Logic.IsLeader(units[i])== 1 then
				Logic.DestroyGroupByLeader( units[i] )
			else
				Logic.DestroyEntity( units[i] )
			end
		end
	end
		
	BRIEFING_DISTANCE1()
	ASP("mainspawnW",tSim,"Merkw�rdig. @cr Wo ist Sir William? Ihr solltet ihn suchen!", false)
	briefing.finished = function()
		Quest18()
	end
	StartBriefing(briefing)
end

function Quest18()
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Wo ist Sir william"
	local questtext	 =	"Ich hatte die Festung zerst�rt, konnte ihre Bewohner aber nirgends finden. Wohl oder �bel, die Spurensuche"..
						" hatte begonnen. @cr @cr "..SZ.." - Findet heraus wo sich Sir William versteckt"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	BriefingWatcher1()
end

function BriefingWatcher1()
	EnableNpcMarker(GetEntityId("watcher1"))
	local quest = {
	EntityName = "matthew",TargetName = "watcher1",Distance = 500,
	Callback = function(_Quest)
		DisableNpcMarker(GetEntityId("watcher1"))
		BRIEFING_DISTANCE1()
		local briefing = {restoreCamera = true}
		local AP, ASP = AddPages(briefing)
		
		ASP("matthew",Orange.." W�chter","Du willst vorbei? Nur �ber meine Leiche!",true)

		briefing.finished = function()
			ChangePlayer("watcher1", 2)
			local quest = {
				Target = "watcher1",
			    Callback = function( _Quest )
					ReplaceEntity("bridge1",Entities.PB_DrawBridgeClosed1)
					ReplaceEntity("door_wv",Entities.XD_WallStraightGate)
	
					local briefing = {restoreCamera = true}
					local AP, ASP = AddPages(briefing)
					
					ASP("bridge1",tSim,"Sir William wird doch nicht etwa...",false)
					ASP("matthew",tMat,"Er wird doch nicht etwa WAS?",false)
					ASP("williamsversteck",tSim,"In die Katakomben gegangen sein. Es ist ein gef�hrliches Gangsystem, in dem viele Fallen"..
										" versteckt sind. Dort k�nnt Ihr nur hindurch gelangen, wenn Ihr die Fallen �berlistet und die"..
										" versteckten Schl�ssel an Euch nehmt.",false)
					ASP("matthew","Siedler Team",Gelb.." "..gvMission.Player.." "..Weiss.." , wir empfehlen Euch, ab sofort �fters zu speichern."..
										" Wenn etwas schief geht, ist das dann weniger schlimm.",false)
					ASP("matthew","Siedler Team","Au�erdem ist es ziemlich dunkel da unten. Ihr werdet n�her an Euren Helden heranzoomen"..
										" m�ssen, um ihn zu sehen.",false)

					briefing.finished = function()
						Quest19()
					end
					StartBriefing(briefing)
				end
			}
			SetupDestroy( quest )
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(quest)
end

function Quest19()
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Wo ist Sir william"
	local questtext	 =	"Ich hatte die Festung zerst�rt, konnte ihre Bewohner aber nirgends finden. Wohl oder �bel, die Spurensuche"..
						" hatte begonnen. @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt."
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	local questid	 = 	3
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Die Katakomben"
	local questtext	 =	"Die Offerte an geheimen R�umen und G�ngen, �ber die Sir William gebot, war wirklich beeindruckend. Jetzt zauberte"..
						" er sogar mit Fallen bew�hrte Katakomben aus dem Hut. Doch damit konnte er mich nicht aufhalten. @cr @cr "..SZ..""..
						" - Durchquert die Katakomben"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	BriefingWilliam2()
	StartCatacombs()
	Quest20()
end

function Quest20()
	local quest = {
	EntityName = "matthew",TargetName = "Aus_pos2",Distance = 500,
	Callback = function(_Quest)
		local questid	 = 	3
		local questtype	 = 	SUBQUEST_CLOSED
		local questtitle =	"Die Katakomben"
		local questtext	 =	"Die Offerte an geheimen R�umen und G�ngen, �ber die Sir William gebot, war wirklich beeindruckend. Jetzt zauberte"..
							" er sogar mit Fallen bew�hrte Katakomben aus dem Hut. Doch damit konnte er mich nicht aufhalten. @cr @cr "..
							" "..Mint.." Diese Aufgabe wurde erf�llt."
		Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	end
	}
	SetupExpedition(quest)
end

function BriefingWilliam2()
	EnableNpcMarker(GetEntityId("william"))
	local quest = {
	EntityName = "matthew",TargetName = "william",Distance = 500,
	Callback = function(_Quest)
		DisableNpcMarker(GetEntityId("william")); LookAt("william","matthew"); LookAt("matthew","william")
		BRIEFING_DISTANCE1()
		local briefing = {}
		local AP, ASP = AddPages(briefing)
		
		ASP("william",tWil,"Ihr habt also meine Fallen �berlebt? Und Ihr habt das "..Gruen.." Nachtschattengew�chs "..Weiss.." besiegt, welches"..
							" ich durch den "..Gelb.." Generalschl�ssel "..Weiss.." bewachen lie�? @cr Richtig, sonst w�hrt Ihr nicht hier.",true)
		ASP("william",tWil,"Was ist nun. Wollt Ihr es nicht hinter Euch bringen und zu Eurem neuen Master zur�ckkehren?",true)

		briefing.finished = function()
			ChangePlayer("william", 2)
			
			local quest = {
				Target = "william",
			    Callback = function( _Quest )	
					local briefing = {restoreCamera = true}
					local AP, ASP = AddPages(briefing)
					
					ASP("HQSteele",tSim,"Sire, Ihr m�sst nun aber auch noch den R�ckweg �berleben. Es gibt leider keinen anderen Weg zur�ck."..
										" Aber Ihr habt ja den "..Gelb.." Generalschl�ssel "..Weiss.." mit dem Ihr alle Tore �ffnen k�nnt.",false)

					briefing.finished = function()
						Quest21()
					end
					StartBriefing(briefing)
				end
			}
			SetupDestroy( quest )
		end
		StartBriefing(briefing)
	end
	}
	SetupExpedition(quest)
end

function Quest21()
	local questid	 = 	4
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Der R�ckweg"
	local questtext	 =	"Nach Sir Williams Tod musste ich abermals durch die Katakomben. @cr @cr "..
						" "..SZ.." - Die Katakomben erneut durchqueren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

function EndChapter11()
	if gvMission.Chapter11 and IsDeadWrapper("william") and GetPlayer("applef")== 1 and GetPlayer("hunterf")== 1 then
		StartChapter12()
	return true
	end
end

-- +++ Catacombs Start +++ --

function StartCatacombs()
	Catacombs = {
		Key1 = 0,
		Key2 = 0,
		Key3 = 0,
	}
	Catacombs_Eingang3()
	Catacombs_Ausgang1()
	Inizalisize_Gates()
	Inizalisize_KeyChests()
	StartSimpleJob("StartFireTrap")
	StartSimpleJob("StartHumanTrap")
	EnableNpcMarker(GetEntityId("edward"))
	Briefing_CatacombsEdward()
	gvMission.Ambient = StartSimpleHiResJob("CaveAmbient")
	DefeatJob3 = StartSimpleJob("HeroDiesInCatacombs")
	EndJob(DefeatJob2)
end

-- ** Portals

function Catacombs_Eingang1()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "Eingang",
	    Distance = 100,
	    Callback = function( _Quest )
			local pos = GetPosition("cave_entry1")
	        SetPosition("matthew",pos)
			Camera.ScrollSetLookAt( pos.X, pos.Y )
			Move("matthew","entry1_active")
			Catacombs_Eingang2()
	    end
	}
	SetupExpedition( quest )
end
function Catacombs_Eingang2()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "entry1_active",
	    Distance = 200,
	    Callback = function( _Quest )
			if IsAlive("william")then
				Catacombs_Eingang3()
			else
				EndJob(gvMission.Ambient)
				SetupNormalWeatherGfxSet()
				gvMission.Chapter11 = true
			end
	    end
	}
	SetupExpedition( quest )
end
function Catacombs_Eingang3()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "cave_entry1",
	    Distance = 100,
	    Callback = function( _Quest )
			local pos = GetPosition("Eingang")
	        SetPosition("matthew",pos)
			Camera.ScrollSetLookAt( pos.X, pos.Y )
			Move("matthew","Ein_pos1")
			Catacombs_Eingang4()
	    end
	}
	SetupExpedition( quest )
end
function Catacombs_Eingang4()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "Ein_pos1",
	    Distance = 200,
	    Callback = function( _Quest )
			Catacombs_Eingang1()
	    end
	}
	SetupExpedition( quest )
end

function Catacombs_Ausgang1()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "Ausgang",
	    Distance = 100,
	    Callback = function( _Quest )
			local pos = GetPosition("Ausgang2")
	        SetPosition("matthew",pos)
			Camera.ScrollSetLookAt( pos.X, pos.Y )
			Move("matthew","Aus_pos2")
			Catacombs_Ausgang2()
	    end
	}
	SetupExpedition( quest )
end
function Catacombs_Ausgang2()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "Aus_pos2",
	    Distance = 200,
	    Callback = function( _Quest )
			Catacombs_Ausgang3()
	    end
	}
	SetupExpedition( quest )
end
function Catacombs_Ausgang3()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "Ausgang2",
	    Distance = 100,
	    Callback = function( _Quest )
			local pos = GetPosition("Ausgang")
	        SetPosition("matthew",pos)
			Camera.ScrollSetLookAt( pos.X, pos.Y )
			Move("matthew","Aus_pos1")
			Catacombs_Ausgang4()
	    end
	}
	SetupExpedition( quest )
end
function Catacombs_Ausgang4()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "Aus_pos1",
	    Distance = 200,
	    Callback = function( _Quest )
			Catacombs_Ausgang1()
	    end
	}
	SetupExpedition( quest )
end

-- ** Gates

function Inizalisize_Gates()
	Inizalisize_GateOpen1(); Inizalisize_GateOpen2(); Inizalisize_GateOpen3(); Inizalisize_GateOpen4(); Inizalisize_GateOpen5()
	Inizalisize_GateOpen6(); Inizalisize_GateOpen7(); Inizalisize_GateOpen8(); Inizalisize_GateOpen9(); Inizalisize_GateOpen10()
end

function Inizalisize_GateOpen1()
	local IO = {
		Name 		 = "cata_gate1",
		Type 		 = 3,
		Range		 = 400,
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate1",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen2()	
	local IO = {
		Name 		 = "cata_gate2",
		Type 		 = 3,
		Range		 = 400,
		Triggers	= { {FoundKey1, "Ihr m�sst zuerst den passenden Schl�ssel besorgen."} },
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate2",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen3()	
	local IO = {
		Name 		 = "cata_gate3",
		Type 		 = 3,
		Range		 = 400,
		Triggers	= { {FoundKey1, "Ihr m�sst zuerst den passenden Schl�ssel besorgen."} },
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate3",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen4()	
	local IO = {
		Name 		 = "cata_gate4",
		Type 		 = 3,
		Range		 = 400,
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate4",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
			for i=1,11 do Logic.SetModelAndAnimSet( GetEntityId("T1_waterfall"..i),Models.XD_Waterfall2 )end
			StartSimpleHiResJob("FloatTheCave")
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen5()
	local IO = {
		Name 		 = "cata_gate5",
		Type 		 = 3,
		Range		 = 400,
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate5",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen6()
	local IO = {
		Name 		 = "cata_gate6",
		Type 		 = 3,
		Range		 = 400,
		Triggers	= { {FoundKey3, "Ihr m�sst zuerst den passenden Schl�ssel besorgen."} },
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate6",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen7()
	local IO = {
		Name 		 = "cata_gate7",
		Type 		 = 3,
		Range		 = 400,
		Triggers	= { {FoundKey2, "Ihr m�sst zuerst den passenden Schl�ssel besorgen."} },
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate7",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen8()
	local IO = {
		Name 		 = "cata_gate8",
		Type 		 = 3,
		Range		 = 400,
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate8",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
			Inizalisize_GateClosed8()
		end,
	}
	Interactive_Setup( IO )
end
function Inizalisize_GateClosed8()
	local IO = {
		Name 		 = "cata_gate8",
		Type 		 = 3,
		Range		 = 400,
		Title		 = "Offenes Tor",
		Text		 = "Schlie�t dieses Tor hinter Euch ab.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate8",Entities.XD_WallStraightGate_Closed)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
			Inizalisize_GateOpen8()
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen9()
	local IO = {
		Name 		 = "cata_gate9",
		Type 		 = 3,
		Range		 = 400,
		Triggers	= { {FoundKey3, "Ihr m�sst zuerst den passenden Schl�ssel besorgen."} },
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate9",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function Inizalisize_GateOpen10()
	local IO = {
		Name 		 = "cata_gate10",
		Type 		 = 3,
		Range		 = 400,
		Triggers	= { {FoundKey2, "Ihr m�sst zuerst den passenden Schl�ssel besorgen."} },
		Title		 = "Verschlossenes Tor",
		Text		 = "Ein verschlossenes Tor wartet darauf, von Euch ge�ffnet zu werden.",
		Button		 = "Research_Banking",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("cata_gate10",Entities.XD_WallStraightGate)
			Sound.PlayGUISound( Sounds.OnKlick_PB_ClayMine3, 100 )
		end,
	}
	Interactive_Setup( IO )
end

function FoundKey1()
	return Catacombs.Key1
end
function FoundKey2()
	return Catacombs.Key2
end
function FoundKey3()
	return Catacombs.Key3
end

-- ** Keys

function Inizalisize_KeyChests()
	local IO = {
		Name 		 = "keybox1",
		Type 		 = 3,
		Range		 = 200,
		Title		 = "Schatztruhe",
		Text		 = "Brecht diese Truhe auf. Darin befindet sich bestimmt ein Schl�ssel.",
		Button		 = "MultiSelectionSource_Thief",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("keybox1",Entities.XD_ChestOpen)
			Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
			Message(tMat.." "..Weiss.." @cr Na also. Hier ist ein Schl�ssel!")
			Catacombs.Key1 = 1
		end,
	}
	Interactive_Setup( IO )
	
	local IO = {
		Name 		 = "keybox2",
		Type 		 = 3,
		Range		 = 200,
		Title		 = "Schatztruhe",
		Text		 = "Brecht diese Truhe auf. Darin befindet sich bestimmt ein Schl�ssel.",
		Button		 = "MultiSelectionSource_Thief",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("keybox2",Entities.XD_ChestOpen)--Buildings_SO_ClaymineBigwheel_rnd_1
			Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
			Message(tMat.." "..Weiss.." @cr Was soll ich mit einer alten Autogrammkarte von David Saufdichdoof?")
		end,
	}
	Interactive_Setup( IO )
	
	local IO = {
		Name 		 = "keybox3",
		Type 		 = 3,
		Range		 = 200,
		Title		 = "Schatztruhe",
		Text		 = "Brecht diese Truhe auf. Darin befindet sich bestimmt ein Schl�ssel.",
		Button		 = "MultiSelectionSource_Thief",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("keybox3",Entities.XD_ChestOpen)
			Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
			Message(tMat.." "..Weiss.." @cr Endlich, der n�chste Schl�ssel.")
			Catacombs.Key2 = 1
		end,
	}
	Interactive_Setup( IO )
end

-- ** Traps

ABSOLUTWATERHIGHT = 2760
RELATIVWATERHIGHT = 2440
function FloatTheCave()
	if RELATIVWATERHIGHT < ABSOLUTWATERHIGHT then
		local waterpos1 = GetPosition("wasser1")
		local waterpos2 = GetPosition("wasser2")
		RELATIVWATERHIGHT = RELATIVWATERHIGHT + 0.75
		if RELATIVWATERHIGHT > ABSOLUTWATERHIGHT then RELATIVWATERHIGHT = ABSOLUTWATERHIGHT end
		Logic.WaterSetAbsoluteHeight( waterpos1.X/100, waterpos1.Y/100, waterpos2.X/100, waterpos2.Y/100, RELATIVWATERHIGHT )
		Logic.UpdateBlocking( waterpos1.X/100, waterpos1.Y/100, waterpos2.X/100, waterpos2.Y/100 )
		if GetHealth("matthew") < 1 then
			Logic.PlayerSetGameStateToLost( 1 )
			Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
		end
	else
		for i=1,11 do Logic.SetModelAndAnimSet( GetEntityId("T1_waterfall"..i),Models.XD_PlantDecalTideland5 )end
		DestroyEntity("SoundWaterfall1");DestroyEntity("SoundWaterfall2");DestroyEntity("SoundWaterfall3")
		return true
	end
end

function StartHumanTrap()
	if GetDistance("matthew","T3_spear1") < 350 or GetDistance("matthew","T3_spear2") < 350 or GetDistance("matthew","T3_spear3") < 350 then
		HumanTrap( "T3_spear1" ); HumanTrap( "T3_spear2" ); HumanTrap( "T3_spear3" )
		BriefingDefeat()
	return true
	end
end

function StartFireTrap()
	if Counter.Tick2("StartFireTrap",2)then
		if GetDistance("matthew","T3_pech1") < 200 or GetDistance("matthew","T3_pech2") < 200 or GetDistance("matthew","T3_pech3") < 200
		or GetDistance("matthew","T3_pech4") < 200 or GetDistance("matthew","T3_pech5") < 200 or GetDistance("matthew","T3_pech6") < 200
		or GetDistance("matthew","T3_pech7") < 200 or GetDistance("matthew","T3_pech8") < 200 or GetDistance("matthew","T3_pech9") < 200
		or GetDistance("matthew","T3_pech10") < 200 or GetDistance("matthew","T3_pech11") < 200 or GetDistance("matthew","T3_pech12") < 200
		or GetDistance("matthew","T3_pech13") < 200 or GetDistance("matthew","T3_pech14") < 200 or GetDistance("matthew","T3_pech15") < 200
		or GetDistance("matthew","T3_pech16") < 200 or GetDistance("matthew","T3_pech17") < 200 or GetDistance("matthew","T3_pech18") < 200
		or GetDistance("matthew","T3_pech19") < 200 or GetDistance("matthew","T3_pech20") < 200 then
			FireTrap( "T3_pech1" );FireTrap( "T3_pech2" );FireTrap( "T3_pech3" );FireTrap( "T3_pech4" );FireTrap( "T3_pech5" );
			FireTrap( "T3_pech6" );FireTrap( "T3_pech7" );FireTrap( "T3_pech8" );FireTrap( "T3_pech9" );FireTrap( "T3_pech10" );
			FireTrap( "T3_pech11" );FireTrap( "T3_pech12" );FireTrap( "T3_pech13" );FireTrap( "T3_pech14" );FireTrap( "T3_pech15" );
			FireTrap( "T3_pech16" );FireTrap( "T3_pech17" );FireTrap( "T3_pech18" );FireTrap( "T3_pech19" );FireTrap( "T3_pech20" );
			BriefingDefeat()
		return true
		end
	end
end

function HeroDiesInCatacombs()
	if GetHealth( "matthew" ) < 1 then
		
	return true
	end
end

-- ** Briefings

function Briefing_CatacombsEdward()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "edward",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","edward")
			LookAt("edward","matthew")
			DisableNpcMarker(GetEntityId("edward"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()
			
			ASP("matthew",tMat,"Hey, wer seid Ihr denn?", true)
			ASP("edward",tVamp,"Mein Name ist "..mVamp.." und ich stamme aus dem verregneten St�dtchen "..Gelb.." Forks.", true)
			ASP("matthew",tMat,"Und wieso seid Ihr hier in diesem menschenverlassenen Loch?", true)
			ASP("edward",tVamp,"Meine Aufgabe ist es, hier Wache zu halten.", true)
			ASP("matthew",tMat,"Und wieso gerade hier unten?", true)
			ASP("edward",tVamp,"Drau�en an der Sonne, fange ich immer an zu glitzern.", true)
			ASP("edward",tVamp,"F�r dich ist jetzt hier schluss! Du willst den Schl�ssel, stimmts? Dazu musst du mir aber erst den"..
								" wahren Tod bringen, Sterblicher!", true)
			
			briefing.finished = function()
				ChangePlayer("edward", 2)
				local quest = {
					Target = "edward",
			        Callback = function( _Quest )
			            Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
						Message(tMat.." "..Weiss.." @cr Hoffentlich der letzte Schl�ssel, den ich brauchen werde.")
						Catacombs.Key3 = 1
					end
				}
				SetupDestroy( quest )
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end

-- ** Ambient

function CaveAmbient()
	local Camera = {Camera.ScrollGetLookAt()}
	SetEntityName( Tools.CreateGroup( 1, Entities.XD_ScriptEntity, 0, Camera[1], Camera[2], 0.00), "CameraPos" )
	
	if GetDistance( "CameraPos", "darkness1" ) <= 3500
	or GetDistance( "CameraPos", "darkness2" ) <= 5000
	or GetDistance( "CameraPos", "darkness3" ) <= 4000
	or GetDistance( "CameraPos", "darkness4" ) <= 6500 then
		SetupCaveRPGGfxSet()
	else
		SetupNormalWeatherGfxSet()
	end
end

-- +++ Catacombs End +++ --

-- # # # # # # # # # # CHAPTER 12 # # # # # # # # # # --

function StartChapter12()
	Briefing_Chapter12()
	Defender_King()
	Logic.RemoveQuest( 1, 1 ) Logic.RemoveQuest( 1, 2 ) Logic.RemoveQuest( 1, 3 ) Logic.RemoveQuest( 1, 4 )
	Tools.GiveResouces( 2, 100000000, 10000, 10000, 10000, 10000, 10000 )
	SetupPlayerAi( 2, {serfLimit = 12,constructing = false,repairing = true,extracting = 0,} )
	DefeatJob2 = StartSimpleJob( "HeroReanimationCooldown" )
	EndJob(DefeatJob3)
end

-- #### ARMIES #### --

function VerratAttackerToKing()
	SetHostile( 2, 3 ); SetHostile( 2, 4 ); SetHostile( 2, 5 ); SetHostile( 2, 7 )
	SetFriendly( 3, 5); SetFriendly( 3, 7); SetFriendly( 7, 5)
	local B_Army14 = {
	player = 5,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","mainspawnK",},
	lebensFaden = "HQKing",
	tod = true,					
	zeit = 200,					 
	type = {2}, 	
	menge = 8,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army14 = CreateRobArmee(B_Army14)
	StartArmee(B_Army14)
	
	local B_Army15 = {
	player = 5,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","mainspawnK",},
	lebensFaden = "HQKing",
	tod = true,					
	zeit = 200,					 
	type = {9}, 	
	menge = 8,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army15 = CreateRobArmee(B_Army15)
	StartArmee(B_Army15)
	
	local B_Army16 = {
	player = 7,					
	erstehungsPunkt = "Bspawn1", 
	ziel = {"barc_WP1","barc_WP2","mainspawnK",},
	lebensFaden = "HQKing",
	tod = true,					
	zeit = 200,					 
	type = {23}, 	
	menge = 16,					
	erfahrung = 3,				
	refresh = 8,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	B_Army16 = CreateRobArmee(B_Army16)
	StartArmee(B_Army16)
	
	local D_Army9 = {
	player = 3,					
	erstehungsPunkt = "Dspawn1", 
	ziel = {"mainspawnK",},
	lebensFaden = "HQKing",
	tod = true,					
	zeit = 200,					 
	type = {14}, 	
	menge = 8,					
	erfahrung = 0,				
	refresh = 4,				
	scharf = true,				
	kriegRadius = 3000,		
	endAktion = function()
    end
	}
	D_Army9 = CreateRobArmee(D_Army9)
	StartArmee(D_Army9)
	
	MachKumpel(B_Army14,K_Army15)
	MachKumpel(B_Army14,K_Army16)
end

function VerratAttackerEveryoneVSEveryone()
	ArmyVerrat1 = {
		player 				= 4,
		id 					= 1,
		strength 			= 8,
		position 			= GetPosition("Bspawn3"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderHeavyCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Bspawn3"),
		spawnGenerator 		= "Bstable1",
		respawnTime 		= B_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 4,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 4,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		
	}
	SetupArmy( ArmyVerrat1 )
	ConrtolVerrat1 = StartSimpleJob("ConrtolArmyVerrat1")
	SetupAITroopSpawnGenerator("BarcleySpawnArmy5", ArmyVerrat1)
	
	ArmyVerrat2 = {
		player 				= 4,
		id 					= 2,
		strength 			= 8,
		position 			= GetPosition("Bspawn3"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderHeavyCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Bspawn3"),
		spawnGenerator 		= "Bstable1",
		respawnTime 		= B_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 4,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 4,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
		
	}
	SetupArmy( ArmyVerrat2 )
	ConrtolVerrat2 = StartSimpleJob("ConrtolArmyVerrat2")
	SetupAITroopSpawnGenerator("BarcleySpawnArmy6", ArmyVerrat2)
	
	ArmyVerrat3 = {
		player 				= 3,
		id 					= 1,
		strength 			= 8,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PV_Cannon3, 0},
			{Entities.PU_LeaderRifle2, 8},
			{Entities.PU_LeaderSword4, 8},
			{Entities.PU_LeaderSword4, 8},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= D_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 4,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 4,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( ArmyVerrat3 )
	ConrtolVerrat3 = StartSimpleJob("ConrtolArmyVerrat3")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy9", ArmyVerrat3)
	
	ArmyVerrat4 = {
		player 				= 3,
		id 					= 2,
		strength 			= 8,
		position 			= GetPosition("Dspawn1"),
		rodeLength 			= 1500,	
		spawnTypes 			= {
			{Entities.PU_LeaderCavalry2, 3},
		},
		endless 			= true,
		spawnPos 			= GetPosition("Dspawn1"),
		spawnGenerator 		= "Dbarracks1",
		respawnTime 		= D_Verrat_Time,
		refresh 			= true,
		maxSpawnAmount 		= 4,
		noEnemy 			= true,
		noEnemyDistance 	= 500,
		retreatStrength     = 4,
		baseDefenseRange    = 1000,
		outerDefenseRange   = 3000,
		AttackAllowed       = true,
	}
	SetupArmy( ArmyVerrat4 )
	ConrtolVerrat4 = StartSimpleJob("ConrtolArmyVerrat4")
	SetupAITroopSpawnGenerator("DeverauxSpawnArmy10", ArmyVerrat4)
end

function ConrtolArmyVerrat1()
	if IsAlive(ArmyVerrat1) then
        TickOffensiveAIController(ArmyVerrat1)
		Synchronize(ArmyVerrat1,ArmyVerrat2)
    elseif IsAITroopGeneratorDead(ArmyVerrat1) then
        return true
    end
end
function ConrtolArmyVerrat2()
	if IsAlive(ArmyVerrat2) then
        TickOffensiveAIController(ArmyVerrat2)
    elseif IsAITroopGeneratorDead(ArmyVerrat2) then
        return true
    end
end
function ConrtolArmyVerrat3()
	if IsAlive(ArmyVerrat3) then
        TickOffensiveAIController(ArmyVerrat3)
		Synchronize(ArmyVerrat3,ArmyVerrat4)
    elseif IsAITroopGeneratorDead(ArmyVerrat3) then
        return true
    end
end
function ConrtolArmyVerrat4()
	if IsAlive(ArmyVerrat4) then
        TickOffensiveAIController(ArmyVerrat4)
    elseif IsAITroopGeneratorDead(ArmyVerrat4) then
        return true
    end
end

-- #### QUESTS #### --

function Briefing_Chapter12()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	ASP("HQKing",""," ", true)
	briefing.finished = function()
		local cutscene={
		StartPosition={ zoom = 2000,rotation = -90,angle = 10,position = GetPosition( "HQKing" ),},
		Flights={
			{
			position = GetPosition( "HQKing" ),angle = 20,zoom = 3000,rotation = -90,duration = 10,delay = 3,
			title = Gruen.." KAPITEL XII:",
			text = Gelb.." DIE ERGREIFUNG DES K�NIGS",
			},
		},
		Callback=function()
			BRIEFING_DISTANCE3()
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			
			ASP("deveraux",tDev,"Endlich ist mein h�sslicher Halbbruder tot! Gott m�ge sich seiner Seele erbarmen, denn William wird diese"..
								" Gnade n�tig haben, hahaha!", true)
			ASP("HQKing",tDev,"Doch genug der Freude! @cr Ich habe den K�nigssitz gefunden! Wir wollen ihn angreifen, doch der feige Hund hat"..
								" seine Festung besser gesichert als die "..Gelb.." Bank of Scottland.", false)
			ASP("connor",tDev,"Dieser Kerl bewacht die Schl�ssel zum Ruhm. Aber leider habe ich nichts aus ihm herausbekommen. Offenbar muss"..
								" jemand seine �nigma aufkl�ren. "..mBarc1.." und ich sind uns einig, dass Ihr der Richtige daf�r seid.", true)
			
			briefing.finished = function()
				Quest22()
			end
			StartBriefing(briefing)
		end,
	}
	StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end

function Quest22()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL XII: Die Ergreifung des K�nigs"
	local questtext	 =	"Jetzt, wo alle seine Getreuen durch mich den Tod gefunden hatten, zeigte sich der K�nig endlich. So lange suchten beide"..
						" Seiten nach ihm. Jetzt hatte "..mDev1.." seinen Aufentaltsort herausgefunden. Doch feige wie der alte Sack, der unser"..
						" K�nig sein will, nun mal ist, versteckt er sich hinter seinen Mauern und versucht, die ganze Sache auszusitzen. @cr @cr "..
						" Ich erhielt den Auftrag, den Weg frei zu machen, damit wir das Land retten konnten. Doch ich war dazu verdammt, die"..
						" Fragen eines Orakels zu beantworten. @cr @cr "..SZ.." - TOD: - "..Gruen.." Der K�nig "..Weiss.." (Helias)"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)

	local pos = GetPosition( "matthew" )
	Camera.ScrollSetLookAt(pos.X,pos.Y)
	Explore.Show( "ShowMacClaud", "connor", 600 )
	Explore.Show( "ShowTor1", "ratetor1", 600 )
	Explore.Show( "ShowTor2", "ratetor2", 600 )
	Briefing_ConnorMacClaud2()
	Briefing_Wartender()
	gvMission.BridgeKey = 0
	Inizalisize_InteractiveBridge()
	StartSimpleJob("Quest22End")
end

function Briefing_ConnorMacClaud2()
	EnableNpcMarker(GetEntityId("connor"))
	local quest = {
	    EntityName = "matthew",
	    TargetName = "connor",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","connor")
			LookAt("connor","matthew")
			DisableNpcMarker(GetEntityId("connor"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()
			
			ASP("matthew",tMat,"Wer seit Ihr?", true)
			ASP("connor",tMac,tMac.." "..Weiss.." vom Clan der MacClauds. Und ich bin unsterblich.", true)
			ASP("matthew",tMat,"Was tut Ihr hier?", true)
			ASP("connor",tMac,"Ich bewache das Orakel dessen Name ich vergessen habe. Und damit den Weg zum K�nig.", true)
			ASP("matthew",tMat,"Lasst Ihr mich durch?", true)
			ASP("connor",tMac,"Ihr wollt den K�nig t�ten.", true)
			ASP("matthew",tMat,"Ist das ein NEIN?", true)
			ASP("connor",tMac,"Ihr m�sst die Fragen beantworten, die auf den Toren eingraviert sind, dann werde ich Euch den"..
								" Schl�ssel f�r die Br�cke geben.", true)
			
			briefing.finished = function()
				Quest23()
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end

function Quest23()
	StartSimpleJob("StartConnorMacClaud3")
	Explore.Hide( "ShowMacClaud" )
	StartEingabeTor1()
	StartEingabeTor2()
	
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_OPEN
	local questtitle =	"Die Fragen an den Toren"
	local questtext	 =	"Die gut gesicherten Tore des K�nigs lie�en sich mit der richtigen Parole entsperren. Die Parole war die Antwort auf"..
						" eine im Holz eingravierte Frage."..
						" @cr @cr "..SZ.." - Parolen herausfinden @cr - Brucke herunterlassen"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
end

function StartEingabeTor1()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "ratetor1",
	    Distance = 1000,
	    Callback = function( _Quest )
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()

			ASP("ratetor1","GRAVUR","Wie wurde eine Katze im Mittelalter vom Volksmund noch genannt?", true)
			ASP("matthew",tMat,"Hm... auf jeden fall irgend was mit Maus...", true)
			
			briefing.finished = function()
				StartSimpleJob("RestartEingabeTor1")
				XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "ChatInput" ), 1 )
				GameCallback_GUI_ChatStringInputDone = function(_M)
					if string.upper(_M)== "MAUSHUND" then
						Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
						Message(tMat.." "..Weiss.." @cr Das Tor ist offen.")
						ReplaceEntity("ratetor1", Entities.XD_PalisadeGate2 )
						Explore.Hide( "ShowTor1" )
						gvMission.Tor1Offen = true
					else
						local briefing = {}
						local AP, ASP = AddPages(briefing)
						BRIEFING_DISTANCE1()

						ASP("matthew",tMat,"Das war wohl falsch. Ich muss sp�ter wieder kommen und es noch mal versuchen.", true)
						
						briefing.finished = function()
						end
						StartBriefing(briefing)
					end
				end
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end
function RestartEingabeTor1()
	if GetDistance("matthew","ratetor1") > 1200 and not(gvMission.Tor1Offen)then
		StartEingabeTor1()
		return true
	elseif gvMission.Tor1Offen then
		return true
	end
end

function StartEingabeTor2()
	local quest = {
	    EntityName = "matthew",
	    TargetName = "ratetor2",
	    Distance = 1000,
	    Callback = function( _Quest )
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()

			ASP("ratetor2","GRAVUR",Grau.." In jedem rechtwinkligen Dreieck ist ein Kathetenquadrat fl�chengleich zu dem Rechteck aus"..
								" Hypotenuse und dem entsprechenden Hypotenusenabschnitt. "..Weiss.." @cr @cr Wer hat dies festgestellt?", true)
			ASP("matthew",tMat,"Ist das nicht der Kathetensatz des ...", true)
			
			briefing.finished = function()
				StartSimpleJob("RestartEingabeTor2")
				XGUIEng.ShowWidget( XGUIEng.GetWidgetID( "ChatInput" ), 1 )
				GameCallback_GUI_ChatStringInputDone = function(_M)
					if string.upper(_M)== "EUKLID" then
						Sound.PlayGUISound( Sounds.Misc_Chat, 300 )
						Message(tMat.." "..Weiss.." @cr Das Tor ist offen.")
						ReplaceEntity("ratetor2", Entities.XD_PalisadeGate2 )
						Explore.Hide( "ShowTor2" )
						gvMission.Tor2Offen = true
					else
						local briefing = {}
						local AP, ASP = AddPages(briefing)
						BRIEFING_DISTANCE1()

						ASP("matthew",tMat,"Das war wohl falsch. Ich muss sp�ter wieder kommen und es noch mal versuchen.", true)
						
						briefing.finished = function()
						end
						StartBriefing(briefing)
					end
				end
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end
function RestartEingabeTor2()
	if GetDistance("matthew","ratetor2") > 1200 and not(gvMission.Tor2Offen)then
		StartEingabeTor1()
		return true
	elseif gvMission.Tor2Offen then
		return true
	end
end

function StartConnorMacClaud3()
	if gvMission.Tor1Offen and gvMission.Tor2Offen then
		Briefing_ConnorMacClaud3()
	return true
	end
end

function Briefing_ConnorMacClaud3()
	EnableNpcMarker(GetEntityId("connor"))
	local quest = {
	    EntityName = "matthew",
	    TargetName = "connor",
	    Distance = 500,
	    Callback = function( _Quest )
			LookAt("matthew","connor")
			LookAt("connor","matthew")
			DisableNpcMarker(GetEntityId("connor"))
			local briefing = {}
			local AP, ASP = AddPages(briefing)
			BRIEFING_DISTANCE1()
			
			ASP("matthew",tMat,"Ich habe Eure Fragen beantwortet. Bekomme ich nun den Schl�ssel?", true)
			ASP("connor",tMac,"In der Tat, das habt Ihr. Ich gebe Euch nun die Schl�ssel. Nicht weil ich das will, sondern weil ich das"..
								" muss. Tut mir einen Gefallen. Lasst den alten Mann nicht leiden!", true)
			
			briefing.finished = function()
				gvMission.BridgeKey = 1
			end
			StartBriefing(briefing)
	    end
	}
	SetupExpedition( quest )
end

function Inizalisize_InteractiveBridge()
	local IO = {
		Name 		 = "bridge2",
		Type 		 = 3,
		Range		 = 1200,
		Triggers	= { {Brueckenschluessel, "Ihr m�sst zuerst die Schl�ssel besorgen."} },
		Title		 = "Br�cke herunterlassen",
		Text		 = "Lasst diese Br�cke herunter, damit Ihr das andere Ufer erreichen k�nnt.",
		Button		 = "Build_Bridge",
		WinSize		 = "small",
		Callback	 = function()
			ReplaceEntity("bridge2",Entities.PB_DrawBridgeClosed2)
			Sound.PlayGUISound( Sounds.Buildings_SO_SawmillWaterWheel_rnd_2, 100 )
			BriefingBarcley2()
		end,
	}
	Interactive_Setup( IO )
end
function Brueckenschluessel()
	return gvMission.BridgeKey
end

function BriefingBarcley2()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE1()
	
	ASP("bridge2",tBarc,"Endlich ist das verdammte Tor offen!", false)
	ASP("c_dev",tDev,"Lasst uns den K�nig vernichten! ich sende meine Truppen.", true)
	ASP("c_barc",tBarc,"Halt, ich habe eine Bessere Idee!", true)
	ASP("c_barc",tBarc,"O, ihr Toten des Landes. Erh�rt meinen Ruf. Steigt aus euren Gr�bern und gehorcht meinem Befehl. Leiht mir"..
						" die Kraft euer rachs�chtigen Seelen. Ich befehle Euch: Kommt und t�tet den K�nig.", true)
	ASP("HQSteele",tSim,"Ihr solltet Euch an diesem Mordkommando beteiligen, Sire.", false)
	
	briefing.finished = function()
		Quest23End()
	end
	StartBriefing(briefing)
end

function Quest23End()
	local questid	 = 	2
	local questtype	 = 	SUBQUEST_CLOSED
	local questtitle =	"Die Fragen an den Toren"
	local questtext	 =	"Die gut gesicherten Tore des K�nigs lie�en sich mit der richtigen Parole entsperren. Die Parole war die Antwort auf"..
						" eine im Holz eingravierte Frage."..
						" @cr @cr "..Mint.." Diese Aufgabe wurde erf�llt"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	
	VerratAttackerToKing()
end

function Quest22End()
	if GetHealth("king") <1 then
		Verrat_KingDies()
	return true
	end
end

function Verrat_KingDies()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE3()
	
	SetHealth("king",0)
	ASP("king",tKing,"Verdammt seid Ihr, Verr�ter! Erstickt an meiner Krone!", true)
	ASP("king",tSim,"Der K�nig ist tot. Aber wer hat ihn erschlagen?", false)
	ASP("HQFalcon",tDev,"Na ich, wer sonst?", false)
	ASP("HQHammer",tBarc,"Halt die Schnauze du franz�sisches Warzenschwein! Meine Soldaten erschlugen den K�nig zuerst.", false)
	ASP("HQFalcon",tDev,"Untersteh dich zu behaupten, deine Bauern w�ren meinen "..Gelb.." franz�sischen "..Weiss.." Soldaten"..
						" derart �berlegen, du englische Pestbeule!", false)
	ASP("matthew",tMat,"Meine Soldaten haben den K�nig erschlagen.", true)
	ASP("HQHammer",tBarc,"Was mischst du dich ein, du Wicht?", false)
	ASP("HQFalcon",tDev,"Warum hast du nicht den Anstand bessessen, zu sterben?", false)
	ASP("matthew",tErz,"Und so entbrannte der Kampf um die Krone. Es hie� nun Jeder gegen Jeden. Der Burgherr, der zum Schluss noch"..
						" �berlebte, sollte die K�nigsw�rden erhalten.", true)
	
	briefing.finished = function()
		Quest24()
	end
	StartBriefing(briefing)
end

function Quest24()
	local questid	 = 	1
	local questtype	 = 	MAINQUEST_OPEN
	local questtitle =	"KAPITEL XII: Die Ergreifung des K�nigs"
	local questtext	 =	"Der K�nig ist tot. Es lebe der K�nig. Doch wer sollte es werden? Wessen Soldaten hatten den K�nig erschlagen?"..
						" Es war unm�glich nachzuweisen. Deshalb hie� es nun \"Jeder gegen Jeden\". Doch wer w�rde aus diesem erbitterten Kampf"..
						" um die Krone, dem K�nigsmacher, siegreich hervorgehen? @cr F�r mich bedeutete es, dass sowohl Graf Deveraux als auch"..
						" Lord Barcley durch meine Hand oder die meiner Soldaten sterben mussten. @cr @cr "..SZ.." - TOD: "..mBarc2..""..
						" "..mBarc1.." (Kerberos) @cr - TOD: "..mDev2.." "..mDev1.." (Drake) @cr @cr "..NZ.." - TOD: "..mMat.." (Erec) @cr "..
						" - GEB�UDE: - Bergfried verlieren"
	Logic.AddQuest(1, questid, questtype, Umlaute(questtitle), Umlaute(questtext),1)
	VerratAttackerEveryoneVSEveryone()
	StartSimpleJob("Quest24End")
	StartSimpleJob("IsHammerBroken")
	StartSimpleJob("IsFalconDown")
	
	SetHostile( 1, 5 ); SetHostile( 1, 7 )
	SetHostile(1,3); SetHostile(1,4); SetHostile(3,4)
	local units = SucheAufDerWelt( 2, 0 )
	for i=1,table.getn(units)do
		if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
			if Logic.IsLeader(units[i])== 1 then
				Logic.DestroyGroupByLeader( units[i] )
			else
				Logic.DestroyEntity( units[i] )
			end
		end
	end
end

function IsHammerBroken()
	if GetHealth("barcley") <1 then
		Briefing_BarcleyDies()
	return true
	end
end

function Briefing_BarcleyDies()
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	ASP("barcley",tBarc,"Du nichtsnutziger Wicht wagst es... "..Mint.." ARRRR.... ", false)
	ASP("matthew",tMat,"Der Hammer wurde zerbrochen.", true)
	if GetHealth("deveraux") >0 then
		ASP("matthew",tMat,"Zieht nur Eure Bahnen am Himmel, Deveraux. Ich werde Euch schon herunter hohlen!", true)
	else
		ASP("matthew",tMat,"Jetzt sind sie alle tot!", true)
	end
	
	briefing.finished = function()
		gvMission.BarcleyDead = true
		local units = SucheAufDerWelt( 4, 0 )
		for i=1,table.getn(units)do
			if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
				if Logic.IsLeader(units[i])== 1 then
					Logic.DestroyGroupByLeader( units[i] )
				else
					Logic.DestroyEntity( units[i] )
				end
			end
		end
	end
	StartBriefing(briefing)
end

function IsFalconDown()
	if GetHealth("deveraux") <1 then
		Briefing_DeverauxDies2()
	return true
	end
end

function Briefing_DeverauxDies2()
	local briefing = {restoreCamera = true}
	local AP, ASP = AddPages(briefing)
	
	ASP("deveraux",tDev,"Geschlagen von einem nichtsnutzigen T�lpel... Ich sterbe in Schande...", true)
	ASP("matthew",tMat,"Der Falke wurde vom Himmel geholt.", true)
	if GetHealth("barcley") >0 then
		ASP("matthew",tMat,"Barcley, nehmt Euch in acht! Ihr seid der N�chste!", true)
	else
		ASP("matthew",tMat,"Jetzt sind sie alle tot!", true)
	end
	
	briefing.finished = function()
		gvMission.DeverauxDead = true
		local units = SucheAufDerWelt( 3, 0 )
		for i=1,table.getn(units)do
			if not(Logic.GetEntityType(units[i])== Entities.XD_StandartePlayerColor)then
				if Logic.IsLeader(units[i])== 1 then
					Logic.DestroyGroupByLeader( units[i] )
				else
					Logic.DestroyEntity( units[i] )
				end
			end
		end
	end
	StartBriefing(briefing)
end

function Quest24End()
	if gvMission.BarcleyDead and gvMission.DeverauxDead then
		Outro_Matthew()
	return true
	end
end

function Outro_Matthew()
	BRIEFING_DISTANCE1()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	ASP("cam16","","              ", false)
	ToggleBriefingBar(0)
	briefing.finished = function()
		ToggleBriefingBar(1)
		local cutscene={
		StartPosition={ zoom = 3300,rotation = -45,angle = 36,position = GetPosition( "cam16" ),},
		Flights={
			{
			position = GetPosition( "cam16" ),angle = 10,zoom = 5000,rotation = -145,duration = 20,delay = 2,
			title = tErz,
			text = "Und so besiegte ich alle meine Feinde. Keiner war mehr �brig und ich konnte den Thron besteigen. Ich hatte die"..
					" "..Gelb.." absolute "..Weiss.." Macht erlangt, doch musste ich daf�r Alles und Jeden verraten. Einsamkeit war der Preis,"..
					" den ich zahlen musste.",
			},
		},
		Callback=function()
			Logic.PlayerSetGameStateToWon( 1 )
			Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveWon_rnd_01, 100 )
		end,
	 }
	 StartCutscene(cutscene)
	end
	StartBriefing(briefing)
end
-- # # # # # # # # # # ENEMY STRONGHOLDERS # # # # # # # # # # --

function ImmortalbilityForCharackter()
	-- Olaf
	if GetHealth( "olaf" )> 0 then
		if IsExisting( "HQOlav" )then
			MakeInvulnerable( "olaf" )
			if GetDistance( "olaf", "HQOlav")> 3000 then
				Move( "olaf", "HQOlav")
			end
			if not(string.find(Logic.GetCurrentTaskList(GetEntityId("olaf")),"BATTLE"))
			and not(string.find(Logic.GetCurrentTaskList(GetEntityId("olaf")),"WALK"))
			and GetDistance( "olaf", "HQOlav")> 1000 then
				Move( "olaf", "HQOlav")
			end
		else
			MakeVulnerable( "olaf" )
		end
	end
	-- Edwin
	if IsExisting( "edwin" )then
		if IsExisting( "HQEdwin" )then
			MakeInvulnerable( "edwin" )
			if GetDistance( "edwin", "HQEdwin")> 3000 then
				Move( "edwin", "HQEdwin")
			end
			if not(string.find(Logic.GetCurrentTaskList(GetEntityId("edwin")),"BATTLE"))
			and not(string.find(Logic.GetCurrentTaskList(GetEntityId("edwin")),"WALK"))
			and GetDistance( "edwin", "HQEdwin")> 1000 then
				Move( "edwin", "HQEdwin")
			end
		else
			MakeVulnerable( "edwin" )
		end
	end
	-- Barcley
	if GetHealth( "barcley" )> 0 then
		if IsExisting( "HQHammer" )then
			MakeInvulnerable( "barcley" )
			if GetDistance( "barcley", "HQHammer")> 5000 then
				Move( "barcley", "HQHammer")
			end
			if not(string.find(Logic.GetCurrentTaskList(GetEntityId("barcley")),"BATTLE"))
			and not(string.find(Logic.GetCurrentTaskList(GetEntityId("barcley")),"WALK"))
			and GetDistance( "barcley", "HQHammer")> 2500 then
				Move( "barcley", "HQHammer")
			end
		else
			MakeVulnerable( "barcley" )
		end
	end
	-- Deveraux
	if GetHealth( "deveraux" )> 0 then
		if IsExisting( "HQFalcon" )then
			MakeInvulnerable( "deveraux" )
			if GetDistance( "deveraux", "HQFalcon")> 5000 then
				Move( "deveraux", "mainspawnD")
			end
			if not(string.find(Logic.GetCurrentTaskList(GetEntityId("deveraux")),"BATTLE"))
			and not(string.find(Logic.GetCurrentTaskList(GetEntityId("deveraux")),"WALK"))
			and GetDistance( "deveraux", "HQFalcon")> 2000 then
				Move( "deveraux", "mainspawnD")
			end
		else
			MakeVulnerable( "deveraux" )
		end
	end
	-- William
	if IsExisting( "william" ) then
		if IsExisting( "HQWilliam" )then
			MakeInvulnerable( "william" )
			if GetDistance( "william", "HQWilliam")> 3000 then
				Move( "william", "HQWilliam")
			end
			if not(string.find(Logic.GetCurrentTaskList(GetEntityId("william")),"BATTLE"))
			and not(string.find(Logic.GetCurrentTaskList(GetEntityId("william")),"WALK"))
			and GetDistance( "william", "HQWilliam")> 1000 then
				Move( "william", "HQWilliam")
			end
		else
			MakeVulnerable( "william" )
		end
	end
	-- King
	if GetHealth( "king" )> 0 then
		if IsExisting( "HQKing" )then
			MakeInvulnerable( "king" )
			if GetDistance( "king", "HQKing")> 5000 then
				Move( "king", "HQKing")
			end
			if not(string.find(Logic.GetCurrentTaskList(GetEntityId("king")),"BATTLE"))
			and not(string.find(Logic.GetCurrentTaskList(GetEntityId("king")),"WALK"))
			and GetDistance( "king", "HQKing")> 2000 then
				Move( "king", "HQKing")
			end
		else
			MakeVulnerable( "king" )
		end
	end
	if IsDeadWrapper( "edwin" ) and GetHealth( "olaf" )< 1 and GetHealth( "barcley" )< 1
	and GetHealth( "king" )< 1 and GetHealth( "deveraux" )< 1 and IsDeadWrapper( "william" )then
		return true
	end
end

-- # # # # # # # # # # DEFEAT # # # # # # # # # # --

function MainDefeatConstitution()
	if IsDeadWrapper( "HQSteele" )then
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
	return true
	end
end
HEROCOOLDOWN = 180
function HeroReanimationCooldown()
	if GetHealth( "matthew" )< 1 then
		HEROCOOLDOWN = HEROCOOLDOWN - 1
		Show_Infoline( 3, gvMission.InfoText3, HEROCOOLDOWN, gvMission.Value3 )
		if HEROCOOLDOWN == 0 then
			BriefingDefeat()
			return true
		end
	else
		HEROCOOLDOWN = gvMission.Value3
		Hide_Infoline( 3 )
	end
end

function BriefingDefeat()
	local briefing = {}
	local AP, ASP = AddPages(briefing)
	BRIEFING_DISTANCE2()
	ToggleBriefingBar(0)
	ASP("matthew","Mission Verloren",Trans.." _________________________________________________", false)
	briefing.finished = function()
		Logic.PlayerSetGameStateToLost( 1 )
		Sound.PlayGUISound( Sounds.VoicesMentor_VC_YouHaveLost_rnd_01, 100 )
		ToggleBriefingBar(1)
		Hide_Infoline( 3 )
	end
	StartBriefing(briefing)
end

-- # # # # # # # # # # COMFORT # # # # # # # # # # --

function HumanTrap( _pos )
	local pos = GetPosition(_pos)
	Logic.CreateEffect( GGL_Effects.FXMaryPoison, pos.X, pos.Y, 1 )
	for j=-400,400,100 do
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X-400, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X-300, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X-200, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X-100, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X+400, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X+300, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X+200, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X+100, pos.Y+j, GetRandom(0,359) )
		Tools.CreateGroup(0, Entities.XD_Evil_Camp03, 0, pos.X, pos.Y+j, GetRandom(0,359) )
	end
end

function FireTrap( _pos )
	local pos = GetPosition(_pos)
	Logic.CreateEffect( GGL_Effects.FXFireLo, pos.X+100, pos.Y+100, 1 )
	Logic.CreateEffect( GGL_Effects.FXFireLo, pos.X-100, pos.Y-100, 1 )
	Logic.CreateEffect( GGL_Effects.FXFireLo, pos.X+100, pos.Y-100, 1 )
	Logic.CreateEffect( GGL_Effects.FXFireLo, pos.X-100, pos.Y+100, 1 )
	Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, 1 )
	Logic.CreateEffect( GGL_Effects.FXFireLo, pos.X, pos.Y, 1 )
end

function AddTribute( _tribute )
	assert( type( _tribute ) == "table" );
	assert( type( _tribute.text ) == "string" );
	assert( type( _tribute.cost ) == "table" );
	assert( type( _tribute.playerId ) == "number" );
	assert( not _tribute.Tribute );
	uniqueTributeCounter = uniqueTributeCounter or 1;
	_tribute.Tribute = uniqueTributeCounter;
	uniqueTributeCounter = uniqueTributeCounter + 1;
	local tResCost = {};
	for k, v in pairs( _tribute.cost ) do
		assert( ResourceType[k] );
		assert( type( v ) == "number" );
		table.insert( tResCost, ResourceType[k] );
		table.insert( tResCost, v );
	end
	Logic.AddTribute( _tribute.playerId, _tribute.Tribute, 0, 0, _tribute.text, unpack( tResCost ) );
	SetupTributePaid( _tribute );
	return _tribute.Tribute;
end

function Init_InfoLines()
	Reload_Window()
	
	Mission_OnSaveGameLoaded_OrigINFO = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_OrigINFO()
		Reload_Window()
	end
	
	GUIUpdate_GetTeamPoints = function()
	end
	GUIUpdate_VCTechRaceProgress = function()
	end
	GUIUpdate_VCTechRaceColor = function()
	end
end
function Reload_Window()
	XGUIEng.ShowWidget( "VCMP_Window", 1 )
	XGUIEng.SetWidgetPosition( "VCMP_Window", 5, 100 )
	XGUIEng.SetWidgetPosition( "NotesWindow", 270, 150 )
	for i=1,8 do
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player1", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player2", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player3", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player4", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player5", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player6", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player7", 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."Player8", 0 )
		XGUIEng.SetWidgetSize( "VCMP_Team"..i, 250, 10 )
		XGUIEng.SetWidgetPositionAndSize( "VCMP_Team"..i.."Name", 5, 0, 250, 4 )
		XGUIEng.SetWidgetPositionAndSize( "VCMP_Team"..i.."Shade", 5, 0, 250, 4 )
		XGUIEng.SetWidgetPositionAndSize( "VCMP_Team"..i.."Points", 5, 0, 250, 0 )
		XGUIEng.SetWidgetPositionAndSize( "VCMP_Team"..i.."PointGame", 5, 5, 250, 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i, 0 )
		XGUIEng.ShowWidget( "VCMP_Team"..i.."_Shade", 0 )
	end
end

function Show_Infoline( _count, _title, _state, _max )
	XGUIEng.ShowWidget( "VCMP_Team".._count, 1 )
	XGUIEng.SetText( "VCMP_Team".._count.."Points", _title )
	XGUIEng.SetText( "VCMP_Team".._count.."Name", "" )
	XGUIEng.ShowWidget( "VCMP_Team".._count.."PointGame", 1 )
	XGUIEng.ShowWidget( "VCMP_Team".._count.."_Shade", 1 )
	
	local percent1 = (_state/_max)*100
	local percent2 = (250/100)*round(percent1)
	if percent2 > 250 then percent2 = 250 end
	XGUIEng.SetWidgetSize( "VCMP_Team".._count.."Name", percent2, 4 )
	XGUIEng.SetWidgetSize( "VCMP_Team".._count.."_Shade", 250, 4 )
end
function Hide_Infoline( _count )
	XGUIEng.ShowWidget( "VCMP_Team".._count, 0 )
	XGUIEng.ShowWidget( "VCMP_Team".._count.."PointGame", 0 )
	XGUIEng.ShowWidget( "VCMP_Team".._count.."_Shade", 0 )
end

function CreateArmyTroops( _player, _position, _leaderType, _numberOfSoldiers, _troops, _experience, _move )
    local army = {
        player     = _player,
    }
    local tD = {
        maxNumberOfSoldiers = _numberOfSoldiers,
        minNumberOfSoldiers = 0,
        experiencePoints    = _experience,
        leaderType          = _leaderType,
        position            = _position,
    }
    for i = 1,_troops do
        army[i] = CreateTroop( army , tD )
    end
    if _move ~= nil then
        for i = 1,_troops do
            Move( army[i], _move )
        end
    end
    return unpack(army);
end

function CreateWoodPile( _posEntity, _resources )
    assert( type( _posEntity ) == "string" );
    assert( type( _resources ) == "number" );
    gvWoodPiles = gvWoodPiles or {
        JobID = StartSimpleJob("ControlWoodPiles"),
    };
    local pos = GetPosition( _posEntity );
    local pile_id = Logic.CreateEntity( Entities.XD_SingnalFireOff, pos.X, pos.Y, 0, 0 );
    SetEntityName( pile_id, _posEntity.."_WoodPile" );
    ReplaceEntity( _posEntity, Entities.XD_ResourceTree );
    Logic.SetResourceDoodadGoodAmount( GetEntityId( _posEntity ), _resources*10 );
    table.insert( gvWoodPiles, { ResourceEntity = _posEntity, PileEntity = _posEntity.."_WoodPile", ResourceLimit = _resources*9 } );
end
function ControlWoodPiles()
    for i = table.getn( gvWoodPiles ),1,-1 do
        if Logic.GetResourceDoodadGoodAmount( GetEntityId( gvWoodPiles[i].ResourceEntity ) ) <= gvWoodPiles[i].ResourceLimit then
            DestroyWoodPile( gvWoodPiles[i], i );
        end
    end
end
function DestroyWoodPile( _piletable, _index )
    local pos = GetPosition( _piletable.ResourceEntity );
    DestroyEntity( _piletable.ResourceEntity );
    DestroyEntity( _piletable.PileEntity );
    Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, 0 );
    table.remove( gvWoodPiles, _index )
end

NPCCharackter = {
	Create = function( _type,_name,_player, _pos, _angle )
		local pos = GetPosition(_pos)
		SetEntityName(Logic.CreateEntity(_type,pos.X,pos.Y,_angle,_player),_name)
		Logic.SetTaskList( GetEntityId(_name), TaskLists.TL_NPC_IDLE )
	end,	
}

function round( _n )
    return math.floor( _n + 0.5 )
end

function GetRandom(_min,_max)
	if not _max then
		_max = _min;
		_min = 1;
	end
	assert( (type(_min) == "number" and type(_max) == "number"), "GetRandom: Invalid Input!" )
	_min = round(_min);
	_max = round(_max);
	if not gvRandomseed then
		local seed = "";
		gvRandomseed = true;
		if XNetwork and XNetwork.Manager_DoesExist() == 1 then
			local humanPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer();
			for i = 1, humanPlayer do
				if XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( i ) == 1 then
					seed = seed .. tostring(XNetwork.GameInformation_GetLogicPlayerUserName( i ));
				end
			end
		else
			seed = XGUIEng.GetSystemTime();
		end
		math.randomseed(seed);
	end
	if _min >= _max then
		return _min;
	else
		return math.random(_min, _max);
	end
end
function MyBriefingsExpansion()
	function Umlaute(_text)
		local texttype = type(_text)
		if texttype == "string" then
			_text = string.gsub( _text, "�", "\195\164" )
			_text = string.gsub( _text, "�", "\195\182" )
			_text = string.gsub( _text, "�", "\195\188" )
			_text = string.gsub( _text, "�", "\195\159" )
			_text = string.gsub( _text, "�", "\195\132" )
			_text = string.gsub( _text, "�", "\195\150" )
			_text = string.gsub( _text, "�", "\195\156" )
		return _text
		elseif texttype == "table" then
			for k, v in _text do _text[k] = Umlaute( v ) end
			return _text
		else
			return _text
		end
	end
	Briefing_ExtraOrig = Briefing_Extra
	EndBriefingOrig = EndBriefing
	StartCutsceneOrig = StartCutscene
    StartBriefingOrig = StartBriefing
    MessageOrig = Message
    Briefing_Extra = function( _v1, _v2 )
        for i = 1, 2 do
        local theButton = "CinematicMC_Button" .. i
        XGUIEng.DisableButton(theButton, 1)
        XGUIEng.DisableButton(theButton, 0)
		end
        if _v1.action then
        assert( type(_v1.action) == "function" )
            if type(_v1.parameters) == "table" then 
                _v1.action(unpack(_v1.parameters))
			else
                _v1.action(_v1.parameters)
            end
        end         
        Briefing_ExtraOrig( _v1, _v2 )
    end
	StartBriefing = function(_briefing)
        assert(type(_briefing) == "table")
        if _briefing.noEscape then
            GameCallback_Escape = function() end
            briefingState.noEscape = true
        end
		Game.GameTimeReset()
		gvMission.GameTime = 1
        StartBriefingOrig(Umlaute(_briefing))
    end
    EndBriefing = function()
        if briefingState.noEscape then
            GameCallback_Escape = GameCallback_EscapeOrig
            briefingState.noEscape = nil
        end
        EndBriefingOrig()
    end
	if StartCutscene then StartCutscene_Orig = StartCutscene end
	if StartCutscene then
        StartCutscene = function( _Cutscene, _EscapeMode )
			Game.GameTimeReset()
			gvMission.GameTime = 1
            StartCutscene_Orig( _Cutscene, _EscapeMode )
        end
    end
    Message = function(_text)
        MessageOrig(Umlaute(tostring(_text)))
    end
	StartCutscene = function(_Cutscene)
		StartCutsceneOrig(Umlaute(_Cutscene))
	end
	function ToggleBriefingBar( _count )
		XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar01"), _count)
		XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicBar02"), _count)
	end
	function BRIEFING_DISTANCE1()
		BRIEFING_ZOOMDISTANCE = 3300
		BRIEFING_ZOOMANGLE = 36
	end
	function BRIEFING_DISTANCE2()
		BRIEFING_ZOOMDISTANCE = 4000
		BRIEFING_ZOOMANGLE = 36
	end
	function BRIEFING_DISTANCE3()
		BRIEFING_ZOOMDISTANCE = 3800
		BRIEFING_ZOOMANGLE = 15
	end
	function DIALOG_DISTANCE()
		DIALOG_ZOOMDISTANCE = 1000
		DIALOG_ZOOMANGLE = 22
	end
	StartSimpleHiResJob( "ShowMC_Buttons" )
end
function ShowMC_Buttons()
	if ShowTheButton == 0 then
		XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMC_Button2"),0)
		XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),325,800,425,33)
	elseif ShowTheButton == 1 then
		XGUIEng.ShowWidget(XGUIEng.GetWidgetID("CinematicMC_Button2"),1)
		XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button1"),100,800,425,33)
		XGUIEng.SetWidgetPositionAndSize(XGUIEng.GetWidgetID("CinematicMC_Button2"),550,800,425,33)
	end
end

function AddPages( _briefing )
    local AP = function(_page) table.insert(_briefing, _page) return _page end
    local ASP = function(_entity, _title, _text, _dialog, _explore) return AP(CreateShortPage(_entity, _title, _text, _dialog, _explore)) end
    return AP, ASP
end
function CreateShortPage( _entity, _title, _text, _dialog, _explore) 
    local page = {
        title = _title,
        text = _text,
        position = GetPosition( _entity ),
		action = function ()Display.SetRenderFogOfWar(0) end
    };
    if _dialog then 
            if type(_dialog) == "boolean" then
                  page.dialogCamera = true
            elseif type(_dialog) == "number" then
                  page.explore = _dialog
            end
      end
    if _explore then 
            if type(_explore) == "boolean" then
                  page.dialogCamera = true
            elseif type(_explore) == "number" then
                  page.explore = _explore
            end
      end
    return page
end

function StartCutscene(_Cutscene)
  local length = 0
  local i
  for i = 1, table.getn(_Cutscene.Flights) do
    length = length + _Cutscene.Flights[i].duration + (_Cutscene.Flights[i].delay or 0)
  end
  gvCutscene = {
    Page      = 1,
    Flights   = _Cutscene.Flights,
    EndTime   = Logic.GetTime() + length,
    Callback  = _Cutscene.Callback,
    Music     = Music.GetVolumeAdjustment(),
    }
  cutsceneIsActive = true
  Logic.SetGlobalInvulnerability(1)
  Interface_SetCinematicMode(1)
  Display.SetFarClipPlaneMinAndMax(0, 14000)
  Music.SetVolumeAdjustment(gvCutscene.Music * 0.5)
  Sound.PlayFeedbackSound(0,0)
  GUI.SetFeedbackSoundOutputState(0)
  Sound.StartMusic(1,1)
  Camera.StopCameraFlight()
  Camera.ZoomSetDistance(_Cutscene.StartPosition.zoom)
  Camera.RotSetAngle(_Cutscene.StartPosition.rotation) 
  Camera.ZoomSetAngle(_Cutscene.StartPosition.angle)         
  Camera.ScrollSetLookAt(_Cutscene.StartPosition.position.X,_Cutscene.StartPosition.position.Y)  
  Counter.SetLimit("Cutscene", -1)
  StartSimpleJob("ControlCutscene")
end
function ControlCutscene()
  if not gvCutscene then return true end
    if Logic.GetTime() >= gvCutscene.EndTime then
      CutsceneDone()
      return true
    else
     if Counter.Tick("Cutscene") then
        local page = gvCutscene.Flights[gvCutscene.Page]
          if not page then CutsceneDone() return true end
             Camera.InitCameraFlight()
             Camera.ZoomSetDistanceFlight(page.zoom, page.duration)
             Camera.RotFlight(page.rotation, page.duration)
             Camera.ZoomSetAngleFlight(page.angle, page.duration)
             Camera.FlyToLookAt(page.position.X, page.position.Y, page.duration)
            if page.title ~= nil then
               PrintBriefingHeadline("@color:255,250,200 " .. page.title)
            end
            if page.text ~= nil then
               PrintBriefingText(page.text)
            end
            if page.action ~= nil then
               page.action()
            end
            Counter.SetLimit("Cutscene", page.duration + (page.delay or 0))
            gvCutscene.Page = gvCutscene.Page + 1
          end
        end
end
function CutsceneDone()
	if not gvCutscene then return true end
    Logic.SetGlobalInvulnerability(0)
    Interface_SetCinematicMode(0)
	Display.SetFarClipPlaneMinAndMax(0, 0)
	Music.SetVolumeAdjustment(gvCutscene.Music)
    GUI.SetFeedbackSoundOutputState(1)
    if gvCutscene.Callback ~= nil then
        gvCutscene.Callback()
    end
    Counter.Cutscene = nil
    gvCutscene = nil
    cutsceneIsActive = false
end
function CutsceneCallParameter(_zoomdistance,_angle,_zoomangle,_backup)
	Interface_SetCinematicMode(1)
	Display.SetRenderFogOfWar(3)
	Camera.StopCameraFlight()
	Camera.ZoomSetDistance(_zoomdistance)
	Camera.RotSetAngle(_angle)
	Camera.ZoomSetAngle(_zoomangle)
	if _backup then
		MapLocal_CameraPositionBackup()
		backup_cs = 1
	end
end
function CutsceneRecallOrig()
	Interface_SetCinematicMode(0)
	Display.SetRenderFogOfWar(0)
	Camera.FollowEntity(0)
	if backup_cs == 1 then
		MapLocal_CameraPositionRestore()
        backup_cs = nil
	end
end

function StartMusic(_song, _length)
    Sound.StartMusic(Folders.Music .. _song, 127)
    LocalMusic.SongLength = Logic.GetTime() + _length + 2
end

function IsDeadWrapper(_input)
    if type(_input) == "table" and not _input.created then
        _input.created = not IsDeadOrig(_input)
        return false
    end
    return IsDeadOrig(_input)
end
IsDeadOrig = IsDead
IsDead = IsDeadWrapper
function AreDead(_entities)
    for i =1,table.getn(_entities) do
        if IsAlive(_entities[i]) then return false end
    end 
    return true
end

function AreEnemiesInArea( _player, _position, _range)
    return AreEntitiesOfDiplomacyStateInArea( _player, _position, _range, Diplomacy.Hostile )
end
function AreEntitiesOfDiplomacyStateInArea( _player, _position, _range, _state )
    for i = 1,8 do
        if Logic.GetDiplomacyState( _player, i) == _state then
            if AreEntitiesInArea( i, 0, _position, _range, 1) then
                return true
            end
        end
    end
    return false
end
function IsArmyNear(_Army, _Target, _Distance)
    local LeaderID = 0
    if not _Distance then
        _Distance = _Army.rodeLength
    end
    local NumberOfLeader = Logic.GetNumberOfLeader(_Army.player)
    for i = 1, NumberOfLeader do
        LeaderID = Logic.GetNextLeader(_Army.player, LeaderID)
        local ArmyID = AI.Entity_GetConnectedArmy(LeaderID)
        if ArmyID == _Army.id then
            if IsNear(LeaderID, _Target, _Distance) then
                return true
            end
        end
    end
    return false
end
function CreateRobArmee(_player, _ePos, _Type, _erfahrung, _ziel, _menge, _lebensFaden, _zeit, _tod, _kriegRadius, _refresh, _scharf)
	--Message(_refresh) NUR HIER SONST NIL BEI DIESER ARMEE
	local lvmaxS = 8 
	local lvminS = 0
	local lvmessageBeginn   = ""
	local lvmessageZwischen = ""
	local lvmessageEnde     = ""
	local lvendAktion
	local lvloeschen = false
	local lvnummer
	local lvLFFaktor  = 1
	local lvLFHeilung = 0
	local lvLVOldHealth
	_kriegRadius = _kriegRadius or 2000
	if type(_Type) == "table" then
		lvnummer = {}
		for i = 1, table.getn(_Type) do 
			table.insert(lvnummer,CreateRobArmee(_player, _ePos, _Type[i], _erfahrung, _ziel, _menge, _lebensFaden, _zeit, _tod, _kriegRadius, _refresh, _scharf))
		end
		return lvnummer
	elseif type(_player) == "table" and type(_player.type) =="table" then
		lvnummer = {}
		typeTable = _player.type
		for i = 1, table.getn(typeTable) do
			_player.type = typeTable[i]
			table.insert(lvnummer,CreateRobArmee(_player))
		end
		return lvnummer
	end
	lvnummer = ArmeeNummer()
	if type(_player) == "table" then
		if type(_player.erstehungsPunkt)     == "number" or type(_player.erstehungsPunkt) == "string" then
			_ePos = GetPosition(_player.erstehungsPunkt)
		elseif type(_player.erstehungsPunkt) == "table" then
			_ePos=_player.erstehungsPunkt
		else
		assert(false,"_player.erstehungsPunkt ist falsch")
		end
		_tod = _player.tod
		_erfahrung = _player.erfahrung 
		_lebensFaden = _player.lebensFaden
		lvmessageBeginn = _player.messageBeginn
		--lvmessageZwischen = _player.messageZwischen NUR HIER SONST NIL BEI DIESER ARMEE
		lvmessageEnde = _player.messageEnde
		lvendAktion = _player.endAktion
		lvLFFaktor  = _player.LFFaktor or 1
		lvLFHeilung = _player.LFHeilung or 0
		_menge = _player.menge
		_refresh = _player.refresh
		_scharf = _player.scharf
		if _player.maxS then lvmaxS = _player.maxS end
		if _player.minS then lvmaxS = _player.minS end
		_Type = _player.type
		_ziel = _player.ziel
		_zeit = _player.zeit
		lvloeschen = _player.loeschen
		if _player.player then _player = _player.player else _player = 1 end
	else
		if type(_ePos) == "number" or type(_ePos) == "string" then
			_ePos=GetPosition(_ePos)
		elseif type(_player.erstehungsPunkt) == "table" then
			_ePos=_ePos
		else
			assert(false,"_player.erstehungsPunkt ist falsch")
		end
	end
	if type(_lebensFaden)== "table" then
		lvLVOldHealth = {}
		for i = 1, table.getn(_lebensFaden) do
			if type(_lebensFaden[i])== "number" then
				table.insert(lvLVOldHealth,Logic.GetEntityMaxHealth(_lebensFaden[i]))
			elseif type(_lebensFaden[i])== "string" then
				table.insert(lvLVOldHealth,Logic.GetEntityMaxHealth(GetEntityId(_lebensFaden[i])))
			end
		end
	elseif type(_lebensFaden)== "number" then
		lvLVOldHealth=Logic.GetEntityMaxHealth(_lebensFaden)
	elseif type(_lebensFaden)== "string" then
		lvLVOldHealth=Logic.GetEntityMaxHealth(GetEntityId(_lebensFaden))
	end
	_erfahrung = _erfahrung or HIGH_EXPERIENCE
	_menge = _menge or 1
	if _Type then
	    if _Type < 37 then
	         _Type = Entities[armeeTable[_Type]]
		end
	else
		_Type = Entities.PU_LeaderSword1
	end
	if not robArmee then
		robArmee = {}
		StartSimpleJob("LebensFaden")
	end
	tLebensFaden[lvnummer]={
	endAktion=lvendAktion,
	messageBeginn=lvmessageBeginn,
	messageEnde=lvmessageEnde,
	faden=_lebensFaden
	}
	for i = 1, _menge do
		table.insert(robArmee, {
								player = _player, 
								Erfahrung=_erfahrung , 
								ePos=_ePos, 
								MaxS=lvmaxS, 
								minS=lvminS, 
								Type=_Type, 
								Ziel=_ziel, 
								loeschen = lvloeschen,
								messageZwischen = lvmessageZwischen,  
								lebensFaden = _lebensFaden, 
								zeit=_zeit, 
								zaehler = 0, 
								nachSchub = 0,
								nummer = lvnummer, 
								LFFaktor = lvLFFaktor,
								LFHeilung = lvLFHeilung,
								LVOldHealth = lvLVOldHealth,
								refresh = -1, --_refresh,
								scharf = true, --_scharf,
								tod = _tod,
								kriegRadius = _kriegRadius,
								aktiv = true
								}
					)
	end
	return lvnummer
end
function StartArmee(nArmee, _kumpel)
	local myKumpel 
	if type(nArmee)=="table" then
		for i = 1, table.getn(nArmee) do
			StartArmee(nArmee[i],nArmee)
		end
		return
	end
	if type(_kumpel) == "table" then
		myKumpel = {}
		for i = 1, table.getn(_kumpel) do
			if _kumpel[i] ~= nArmee then
				table.insert(myKumpel,_kumpel[i])
			end
		end
	end
	for i = 1 , table.getn(robArmee) do
		if robArmee[i].nummer == nArmee then
			robArmee[i].kumpel = myKumpel
			robArmee[i].aktion = 
			function(i)
				robArmee[i].ID = CreateTroop({player = robArmee[i].player}, {
				maxNumberOfSoldiers = robArmee[i].MaxS,
				minNumberOfSoldiers = robArmee[i].minS,
				experiencePoints    = robArmee[i].Erfahrung,
				leaderType          = robArmee[i].Type,
				position            = robArmee[i].ePos,
			}) 
			robArmee[i].MaxS=Logic.LeaderGetNumberOfSoldiers(robArmee[i].ID)
			if robArmee[i].Ziel then
				if type(robArmee[i].Ziel) =="table" then
					if table.getn(robArmee[i].Ziel) > 1 then
						robArmee[i].naechster = robArmee[i].Ziel[1]
						robArmee[i].warteZeit = 8
						robArmee[i].zaehler2 = 8
						robArmee[i].aktuell = 1
						robArmee[i].gesamt=table.getn(robArmee[i].Ziel)
						Move(robArmee[i].ID, robArmee[i].Ziel[1])
					else
						Move(robArmee[i].ID, robArmee[i].Ziel[1])
					end
				else
					Move(robArmee[i].ID, robArmee[i].Ziel)
				end
			end
		end
		local lf = tLebensFaden[robArmee[i].nummer].faden
		for i, v in tLebensFaden do
			if tLebensFaden[i].faden == lf then
				tLebensFaden[i].messageBeginn = nil
			end
		end
		if robArmee[i].zeit then
			robArmee[i].aktiv = true
		end
		robArmee[i].aktion(i)
		end
			-- Versuch
			robArmee[i].ersatzKrieger = function(i)
				if IsAlive(robArmee[i].ID) then
					local task = Logic.GetCurrentTaskList(robArmee[i].ID)
					if not string.find(task, "BATTLE") then
						CreateEntity(robArmee[i].player,Logic.LeaderGetSoldiersType(robArmee[i].ID),GetPosition(robArmee[i].ID))
						Tools.AttachSoldiersToLeader(robArmee[i].ID,robArmee[i].MaxS)
						robArmee[i].refresh = robArmee[i].refresh - 1
						if robArmee[i].refresh == 0 then
							robArmee[i].refresh = nil
						end
					end
				end
			end
			-- ende Versuch
	end
end
function ArmeeNummer()
	armeeNummer = armeeNummer or 0
	armeeNummer = armeeNummer + 1
	tLebensFaden = tLebensFaden or {}
	return armeeNummer
end
function MachKumpel(_k1,_k2)
	if type(_k1) == "table" then
		for i = 1, table.getn(_k1) do
			MachKumpel(_k1[i],_k2)
		end
		return
	end if type(_k2) == "table" then
		for i = 1, table.getn(_k2) do
			MachKumpel(_k1,_k2[i])
		end
		return
	end
	for i = 1, table.getn(robArmee) do
		if robArmee[i].nummer == _k1 then
			if robArmee[i].kumpel then
				local addieren = true
				for j = 1,table.getn(robArmee[i].kumpel) do
					if robArmee[i].kumpel[j] == _k2 then
						addieren = false
						break
					end
				end
				if addieren then
					table.insert(robArmee[i].kumpel,_k2)
				end
			else
				robArmee[i].kumpel={_k2}
			end
		end
		if robArmee[i].nummer == _k2 then
			if robArmee[i].kumpel then
				local addieren = true
				for j = 1,table.getn(robArmee[i].kumpel) do
					if robArmee[i].kumpel[j] == _k1 then
						addieren = false
						break
					end
				end
				if addieren then
					table.insert(robArmee[i].kumpel,_k1)
				end
			else
				robArmee[i].kumpel={_k1}
			end
		end
	end
end
function LebensFaden()
	for i = table.getn(robArmee), 1, -1 do
		if robArmee[i].aktiv then
			if type(robArmee[i].lebensFaden) == "table" then
				if table.getn(robArmee[i].lebensFaden) == 1 then
					robArmee[i].lebensFaden=robArmee[i].lebensFaden[1]
					robArmee[i].lvLVOldHealth=robArmee[i].LVOldHealth[1]
				else
					for j = table.getn(robArmee[i].lebensFaden), 1, -1 do
						if not IsAlive(robArmee[i].lebensFaden[j]) then
							table.remove(robArmee[i].lebensFaden,j)
							table.remove(robArmee[i].LVOldHealth,j)
						else
							if robArmee[i].LVHeilung ~=0 then
								local LVmaxHealth = Logic.GetEntityMaxHealth(robArmee[i].lebensFaden[j])
								local LVHealth = Logic.GetEntityHealth(robArmee[i].lebensFaden[j])
								if LVmaxHealth > LVHealth then
									Logic.HealEntity(robArmee[i].lebensFaden[j],robArmee[i].LVHeilung)
								end
							end
							if robArmee[i].LFFaktor ~= 1 then
								local LVHealth = Logic.GetEntityHealth(robArmee[i].lebensFaden[j])
								local diff = robArmee[i].LVOldHealth[j] - LVHealth
								if  diff > 0  then
									local dazu = diff / robArmee[i].LFFaktor * (robArmee[i].LFFaktor - 1)
									Logic.HealEntity(robArmee[i].lebensFaden[j],dazu)
								end
							end
						end
					end
				end
			else
				if not IsAlive(robArmee[i].lebensFaden) then 
					local lf=tLebensFaden[robArmee[i].nummer].faden
					if tLebensFaden[robArmee[i].nummer].endAktion then
						tLebensFaden[robArmee[i].nummer].endAktion()
						tLebensFaden[robArmee[i].nummer].endAktion= nil
					end
					if tLebensFaden[robArmee[i].nummer].messageEnde then
						Message(tLebensFaden[robArmee[i].nummer].messageEnde)
						tLebensFaden[robArmee[i].nummer].messageEnde= nil
					end
					for i, v in tLebensFaden do
						if tLebensFaden[i].faden==lf then
							tLebensFaden[i].faden= nil
							tLebensFaden[i].endAktion= nil
							tLebensFaden[i].messageEnde= nil
						end
					end
					robArmee[i].zaehler = 0
					robArmee[i].aktiv = false
					robArmee[i].lebensFaden=nil
				else
					if robArmee[i].LVHeilung ~=0 then
						local LVmaxHealth = Logic.GetEntityMaxHealth(robArmee[i].lebensFaden)
						local LVHealth = Logic.GetEntityHealth(robArmee[i].lebensFaden)
						if LVmaxHealth > LVHealth then
							Logic.HealEntity(robArmee[i].lebensFaden,robArmee[i].LVHeilung)
						end
					end
					if robArmee[i].LFFaktor ~= 1 then
						local LVHealth = Logic.GetEntityHealth(robArmee[i].lebensFaden)
						local diff = robArmee[i].LVOldHealth - LVHealth
						if  diff > 0  then
							local dazu = diff / robArmee[i].LFFaktor * (robArmee[i].LFFaktor - 1)
							Logic.HealEntity(robArmee[i].lebensFaden,dazu)
						end
					end
				end															
			end
		end
		if robArmee[i].aktiv then
			-- hier schauen ob welche fehlen.
			robArmee[i].zaehler=robArmee[i].zaehler + 1
			if robArmee[i].tod then
				if not IsAlive(robArmee[i].ID) then
					if  robArmee[i].zaehler >= robArmee[i].zeit then
						robArmee[i].zaehler = 0
						robArmee[i].aktion(i)
						Message(robArmee[i].messageZwischen)
					end
				end
			else
				if  robArmee[i].zaehler >= robArmee[i].zeit then
					robArmee[i].zaehler = 0
					robArmee[i].aktion(i)
					Message(robArmee[i].messageZwischen)
				end
			end
		end
	if  robArmee[i].refresh and (Logic.LeaderGetNumberOfSoldiers(robArmee[i].ID) < robArmee[i].MaxS) then
		robArmee[i].ersatzKrieger(i)
	end
--[[ ab hier scharf ]]
	if robArmee[i].scharf then
		local lvFeinde = AreEnemiesInArea( robArmee[i].player, GetPosition(robArmee[i].ID), robArmee[i].kriegRadius)
		if lvFeinde and not robArmee[i].krieg then
--Message("Krieg"..i)
			robArmee[i].krieg = true
			robArmee[i].pause = true
			robArmee[i].begannKampf = true
			Move(robArmee[i].ID, robArmee[i].ID)
			if robArmee[i].kumpel then
				for m = 1, table.getn(robArmee[i].kumpel) do
--Message(table.getn(robArmee[i].kumpel))
					for n = 1, table.getn(robArmee) do
						if not robArmee[n].krieg and (robArmee[n].nummer == robArmee[i].kumpel[m]) then
							robArmee[n].krieg = true
							robArmee[n].pause = true
							robArmee[n].FIN = robArmee[i].ID
							Move(robArmee[n].ID, robArmee[i].ID)
--Message("Krieg....2 "..robArmee[n].nummer)
						end
					end
				end
			end
		elseif not lvFeinde and robArmee[i].krieg then
			if not robArmee[i].FIN then
				robArmee[i].krieg = false
				robArmee[i].pause = false
				if robArmee[i].naechster then
					Move(robArmee[i].ID, robArmee[i].naechster)
				elseif robArmee[i].Ziel then
					if type(robArmee[i].Ziel) =="table" then
						Move(robArmee[i].ID, robArmee[i].Ziel[1])
					else
						Move(robArmee[i].ID, robArmee[i].Ziel)
					end
				else 
					Move(robArmee[i].ID, robArmee[i].ePos)
				end
			end
		end
		if robArmee[i].FIN then
			if IsAlive(robArmee[i].FIN) then
				if not IsNear(robArmee[i].ID ,robArmee[i].FIN, 500) then
					local task = Logic.GetCurrentTaskList(robArmee[i].ID)
					if task then
						if string.find (task,"IDLE") then
--Message("Freund in Not 2")
							Move(robArmee[i].ID, robArmee[i].FIN)
						end
					end
				else
					if not lvFeinde then
						robArmee[i].krieg = false
						robArmee[i].pause = false
						robArmee[i].FIN = false
						if robArmee[i].naechster then
							Move(robArmee[i].ID, robArmee[i].naechster)
						elseif robArmee[i].Ziel then
							if type(robArmee[i].Ziel) =="table" then
								Move(robArmee[i].ID, robArmee[i].Ziel[1])
							else
								Move(robArmee[i].ID, robArmee[i].Ziel)
							end
						else 
							Move(robArmee[i].ID, robArmee[i].ePos)
						end
					end
				end
			else
				if not lvFeinde then
--Message("ELSE")
			-- Ist anderer in Not?
					local sprung
					for m = 1, table.getn(robArmee[i].kumpel) do
						if robArmee[i].kumpel[m] ~= robArmee[i].FIN then
							for n = 1, table.getn(robArmee) do
								if robArmee[n].krieg and (robArmee[n].nummer == robArmee[i].kumpel[m]) then
									robArmee[i].FIN = robArmee[n].ID 
									sprung = true
								end
							end
						end
					end
					if not sprung then
						robArmee[i].krieg = false
						robArmee[i].pause = false
						robArmee[i].FIN = false
						if robArmee[i].naechster then
							Move(robArmee[i].ID, robArmee[i].naechster)
						elseif robArmee[i].Ziel then
							if type(robArmee[i].Ziel) =="table" then
								Move(robArmee[i].ID, robArmee[i].Ziel[1])
							else
								Move(robArmee[i].ID, robArmee[i].Ziel)
							end
						else 
							Move(robArmee[i].ID, robArmee[i].ePos)
						end
					end
				end
			end
		end
	end
-- bis hier scharf
		if robArmee[i].naechster and (not robArmee[i].pause) then
			local task = Logic.GetCurrentTaskList(robArmee[i].ID)
			if task then
				if string.sub (task, 1, 9) ~= "TL_BATTLE" and task ~= "TL_START_BATTLE" then
					if IsNear(robArmee[i].ID, robArmee[i].naechster, 1000 ) then -- habe ich erh�ht
						if robArmee[i].zaehler2 == 0 then
							robArmee[i].zaehler2 = robArmee[i].warteZeit
							if robArmee[i].aktuell == robArmee[i].gesamt then
								robArmee[i].aktuell = 1 
							else
								robArmee[i].aktuell = robArmee[i].aktuell + 1
							end
							robArmee[i].naechster = robArmee[i].Ziel[robArmee[i].aktuell]
							Move (robArmee[i].ID,robArmee[i].naechster)
						end
						robArmee[i].zaehler2 = robArmee[i].zaehler2 - 1
					elseif string.find(task,"IDLE") then
						Move (robArmee[i].ID,robArmee[i].naechster)
					end
				end 
			end
		end
	end
	for i = table.getn(robArmee), 1, -1 do
		if IsDead(robArmee[i].ID) then
			if not robArmee[i].lebensFaden then
				table.remove(robArmee,i)
			end
		end
	end
	if table.getn(robArmee) == 0 then
		robArmee = nil
		armeeNummer = nil
		return true
	end
end
armeeTable={
	"PU_LeaderBow1",				--  1
	"PU_LeaderBow2",				--  2
	"PU_LeaderBow3",				--  3
	"PU_LeaderBow4",				--  4
	"PU_LeaderCavalry1",			--  5
	"PU_LeaderCavalry2",			--  6
	"PU_LeaderHeavyCavalry1",		--  7
	"PU_LeaderHeavyCavalry2",		--  8
	"PU_LeaderPoleArm1",			--  9
	"PU_LeaderPoleArm2",			-- 10
	"PU_LeaderPoleArm3",			-- 11
	"PU_LeaderPoleArm4",			-- 12
	"PU_LeaderRifle1",				-- 13
	"PU_LeaderRifle2",				-- 14
	"PU_LeaderSword1",				-- 15
	"PU_LeaderSword2",				-- 16
	"PU_LeaderSword3",				-- 17
	"PU_LeaderSword4",				-- 18
	"CU_BanditLeaderBow1",			-- 19
	"CU_BanditLeaderSword1",		-- 20
	"CU_BanditLeaderSword2",		-- 21
	"CU_Barbarian_LeaderClub1",		-- 22
	"CU_Barbarian_LeaderClub2",		-- 23
	"CU_BlackKnight_LeaderMace1",	-- 24
	"CU_BlackKnight_LeaderMace2",	-- 25
	"CU_Evil_LeaderBearman1",		-- 26	
	"CU_Evil_LeaderSkirmisher1", 	-- 27
	"CU_VeteranCaptain",			-- 28
	"CU_VeteranMajor",				-- 29
	"CU_VeteranLieutenant",			-- 30
	"PV_Cannon1",					-- 31
	"PV_Cannon2",					-- 32
	"PV_Cannon3",					-- 33
	"PV_Cannon4",					-- 34
	"CU_AggressiveWolf",			-- 35
	"CU_Barbarian_Hero_wolf"		-- 36
	}
	
function Test1()
	if jKR_ME_Running == nil then
		Message(TestText2, "Lauf")
		return true
	end
end
function jKR_ActivateMessageExpansion() -- Neu
	jKR_ME_Count = 0	-- Weil maximal 10 Messages gezeigt wird
	jKR_ME_Table = {}	-- Initialise Tabelle
	jKR_ME_Running = nil
	jKR_ME_ID = 0
	jKR_ME_Status = "Simple"

	-- �berschreibe normale Message funktion
	jKR_ME_orig = Message
    Message = function(_varA, _varB, _varC, _varD, _varE, _varF)
		local _ID
		_ID = jKR_ME_Add(_varA, _varB, _varC, _varD, _varE, _varF)
		return _ID
	end
end
function jKR_ME_Add(_varA, _varB, _varC, _varD, _varE, _varF) -- Diese Funktion wird gerufen statt nomale Message funktion
	jKR_ME_ID = jKR_ME_ID +1
	local x, total, NextChar
	if type(_varA) ~= "string" and type(_varA) ~= "number" then _varA = "" end
	local data = { -- Default Werte
		ID = jKR_ME_ID,
		text = _varA,
		Text = _varA,
		Type = _varB or "",
		TypeNumber = 1,
		Zeit = _varC or 15,
		Color = _varD or "@color:255,255,255 ", --Weiss 
		Color1 = _varD or "@color:255,255,255 ", --Weiss 
		Color2 = _varE or "@color:255,255,255 ", --Weiss
		counter = _varF or 1,		
		counter2 = 0,		-- gebraucht f�r Flash funktion
		counter3 = 0,		-- gebraucht f�r Scroll funktion
	}
	if _varB =="Lauf" then
		data.Zeit = (string.len(_varA)/10) +5
		if data.Zeit < 15 then data.Zeit = 15 end
		data.TypeNumber = 11
		data.Text = ""
	end
	
	if _varB =="Flash" then
		data.TypeNumber = 11
	end
	
	if _varB =="Ticker" then
		data.counter = _varD or 40
		data.Color = "@color:0,0,0,0 "
		data.Text = "@color:0,0,0,0 "..string.rep(". ", data.counter).."@color:255,255,255 "
		data.TypeNumber = 11
	end
	
	if _varB =="Scroll" then
		data.Color = "@color:0,0,0,0 "
		data.counter2 = 0
		repeat
			NextChar = jKR_ME_GetNextChar(data.text)
			data.text = string.sub(data.text, (string.len(NextChar)+1))
			data.counter2 = data.counter2 + 1
		until data.text == ""
		data.Text = "@color:255,255,255 "..data.Text
		data.text = "rechts"
		data.counter3 = (_varD or 40) - data.counter2
		data.counter2 = 0
		data.TypeNumber = 11
	end

	jKR_ME_Count = jKR_ME_Count + 1
	table.insert(jKR_ME_Table, jKR_ME_Count, data)

	total = 0
	for x = 1, table.getn(jKR_ME_Table) do
		total = total + jKR_ME_Table[x].TypeNumber
	end
	if total>10 then 
		jKR_ME_Status_Neu = "HiRes"
		jKR_ME_modifier = 0.1
		if jKR_ME_Status == "Simple" and jKR_ME_Running then
			EndJob( jKR_ME_Running ) 	-- Stoppt Job
			jKR_ME_Running = nil
		end
	else
		jKR_ME_Status_Neu = "Simple"
		jKR_ME_modifier = 1
	end
	jKR_ME_Status = jKR_ME_Status_Neu
	if not jKR_ME_Running then
		if jKR_ME_Status == "Simple" then
			jKR_ME_Running = StartSimpleJob("jKR_Message_Run")
		else
			jKR_ME_Running = StartSimpleHiResJob("jKR_Message_Run")
		end
	end
	return data.ID
end
function jKR_Message_Run()
	local x,j, data={}

-- Delete Messages if abgelaufen
	for x = jKR_ME_Count, 1, -1 do
		jKR_ME_Table[x].Zeit = jKR_ME_Table[x].Zeit - jKR_ME_modifier
		if jKR_ME_Table[x].Zeit <= 0 then	--Message abgelaufen
			table.remove(jKR_ME_Table, x)
			jKR_ME_Count = jKR_ME_Count - 1
		end
	end

-- Tabelle muss 10 Eintr�ge haben um vertikale Scrollen zu verhindern	
	data={
		ID = 0,
		Text = "\a",
		Color = "@color:255,255,255 ", --Weiss 
		TypeNumber = 0,
	}
	if jKR_ME_Count > 10 then 	-- Erste Eintrag entfernen
		table.remove(jKR_ME_Table, 1)
		jKR_ME_Count = jKR_ME_Count - 1
	else 
		x = table.getn(jKR_ME_Table) + 1
		if x<11 then  		-- Extra Eintr�ge zufugen
			for j = 10, x, -1  do
				table.insert(jKR_ME_Table, data)
			end
		end
	end

--Messages falls n�tig �ndern
	for x = 1,10 do
		if jKR_ME_Table[x].Type == "Lauf" then -- Lauf-funktion von aCid entwickelt ****optimiert und ge�ndert bei Kingsia um mit den anderen Erweiterungen zu funktionierien
			NextChar = jKR_ME_GetNextChar(jKR_ME_Table[x].text)
			if string.len(NextChar) > 0 then
				jKR_ME_Table[x].Text = jKR_ME_Table[x].Text..NextChar
				jKR_ME_Table[x].text = string.sub(jKR_ME_Table[x].text, (string.len(NextChar)+1))
			end
		end
		if jKR_ME_Table[x].Type == "Flash" then -- Flash-funktion von Kingsia
			jKR_ME_Table[x].counter2 = jKR_ME_Table[x].counter2 + jKR_ME_modifier
			if jKR_ME_Table[x].counter2 >= jKR_ME_Table[x].counter then
				if jKR_ME_Table[x].Color == jKR_ME_Table[x].Color1 then 
					jKR_ME_Table[x].Color = jKR_ME_Table[x].Color2
				else
					jKR_ME_Table[x].Color = jKR_ME_Table[x].Color1
				end
				jKR_ME_Table[x].counter2 = 0
			end
		end
		if jKR_ME_Table[x].Type == "Ticker" then -- Ticker-funktion von Kingsia
			NextChar = jKR_ME_GetNextChar(jKR_ME_Table[x].Text)
			if string.len(NextChar) > 5 then
				jKR_ME_Table[x].Color = NextChar
			end
			jKR_ME_Table[x].text = jKR_ME_Table[x].text..NextChar
			jKR_ME_Table[x].Text = string.sub(jKR_ME_Table[x].Text, (string.len(NextChar)+1))
			NextChar = jKR_ME_GetNextChar(jKR_ME_Table[x].text)
			jKR_ME_Table[x].Text = jKR_ME_Table[x].Text..NextChar
			jKR_ME_Table[x].text = string.sub(jKR_ME_Table[x].text, (string.len(NextChar)+1))
		end
		if jKR_ME_Table[x].Type == "Scroll" then -- Scroll-funktion von Kingsia
			if jKR_ME_Table[x].text == "rechts" then
				jKR_ME_Table[x].Text = ". "..jKR_ME_Table[x].Text
				jKR_ME_Table[x].counter2 = jKR_ME_Table[x].counter2 + 1
				if jKR_ME_Table[x].counter2 == jKR_ME_Table[x].counter3 then
					jKR_ME_Table[x].text = "links"
				end
			else
				jKR_ME_Table[x].Text = string.sub(jKR_ME_Table[x].Text, 3)
				jKR_ME_Table[x].counter2 = jKR_ME_Table[x].counter2 - 1
				if jKR_ME_Table[x].counter2 == 0 then
					jKR_ME_Table[x].text = "rechts"
				end
			end
		end
	end

	for x = 1,10 do -- Zeige Messages	
		AngezeigteText = jKR_ME_Table[x].Color..jKR_ME_Table[x].Text
		jKR_ME_orig(AngezeigteText)
	end
	
	if jKR_ME_Count == 0 then --Alle messages abgelaufen
		jKR_ME_Running = nil
		return true -- Job beenden
	end
end
function jKR_ME_GetNextChar(_Text) 
	local text = _Text
	local NextChar = ""
	local NextZeichen
	if text ~= "" then
		if string.len(text) > 2 then
			NextChar = string.sub(text, 1, 3) --check f�r @cr
			if NextChar == "@cr" then 
				return NextChar
			elseif string.len(text) > 5 then --check f�r @color
				NextChar = string.sub(text, 1, 6)
				if NextChar == "@color" then
					text = string.sub(text, 7)
					repeat
						NextZeichen = string.sub(text, 1, 1)
						NextChar = NextChar..NextZeichen
						text = string.sub(text, 2)
					until NextZeichen == " "
					return NextChar
				end
			end
		end
		NextChar = string.sub(text, 1, 1)
		return NextChar
	end
	return NextChar
end

function StartCountdown(_Limit, _Callback, _Show)
    assert(type(_Limit) == "number")
    assert( not _Callback or type(_Callback) == "function" )
    Counter.Index = (Counter.Index or 0) + 1
    if _Show and CountdownIsVisisble() then
        assert(false, "StartCountdown: A countdown is already visible")
    end
    Counter["counter" .. Counter.Index] = {Limit = _Limit, TickCount = 0, Callback = _Callback, Show = _Show, Finished = false}
    if _Show then
        MapLocal_StartCountDown(_Limit)
    end
    if Counter.JobId == nil then
        Counter.JobId = StartSimpleJob("CountdownTick")
    end
    return Counter.Index
end
function StopCountdown(_Id)
    if Counter.Index == nil then
        return
    end
    if _Id == nil then
        for i = 1, Counter.Index do
            if Counter.IsValid("counter" .. i) then
                if Counter["counter" .. i].Show then
                    MapLocal_StopCountDown()
                end
                Counter["counter" .. i] = nil
            end
        end
    else
        if Counter.IsValid("counter" .. _Id) then
            if Counter["counter" .. _Id].Show then
                MapLocal_StopCountDown()
            end
            Counter["counter" .. _Id] = nil
        end
    end
end
function CountdownTick()
    local empty = true
    for i = 1, Counter.Index do
        if Counter.IsValid("counter" .. i) then
            if Counter.Tick("counter" .. i) then
                Counter["counter" .. i].Finished = true
            end
            if Counter["counter" .. i].Finished and not IsBriefingActive() then
                if Counter["counter" .. i].Show then
                    MapLocal_StopCountDown()
                end
                if type(Counter["counter" .. i].Callback) == "function" then
                    Counter["counter" .. i].Callback()
                end
                Counter["counter" .. i] = nil
            end
            empty = false
        end
    end
    if empty then
        Counter.JobId = nil
        Counter.Index = nil
        return true
    end
end
function CountdownIsVisisble()
    for i = 1, Counter.Index do
        if Counter.IsValid("counter" .. i) and Counter["counter" .. i].Show then
            return true
        end
    end
    return false
end

-- ++++++++++++++++++++++++++++++++++++++++ --
-- ++++++++++++Stronghold Start++++++++++++++ --
-- ++++++++++++++++++++++++++++++++++++++++ --
-- Ver. 3.0
	
function Init_Stronghold( _hero, _HQ, _dName, _dType )

	Stronghold = {
		AttractionMax = 0,AttractionMulti = 1,AttractionLimit = 0,Income = 0,
		Sold = 0,TaxHight = 1,FoodKinds = 0,Serfs = 0,
		Hero = _hero, HQ = _HQ, DamselName = _dName, DamselType = _dType,
		Rank = 0, LockRank = 8, RankName = { "Edelmann","Ritter","Edler Ritter","Reichsritter","Streiter des K�nigs","F�rst","Baron","Graf","Herzog", },

		Motivation = 80,MotiPlus = 0,MotiMinus = 0,Ehre = 0,EhrePlus = 0,Cloisters = 0,
		Kitchen = {0, 250, 200, 150,},
		LawAndOrder = {0, 150, 50, 50, 50,},
		TidyUp = {0, 800,},
		Treasury = {0, 100,150,},
		DamselRoom = {0, 200, 200, 200,},
		
		Spear = { 15, true },Bow = { 40, true },Lance = { 70, true },Crossbow = { 80, true },
		Rifle1 = { 120, true },Sword = { 120, true },Knight = { 150, true },Rifle2 = { 150, true },
		Cannons	= {60,100,160,200},
	}
	
	GUIAction_SetTaxes( 0 )
	Init_Attraction();Init_GUI_Hacks()
	
	Stronghold.Pay = StartSimpleHiResJob( "OnPayday" )
	Stronghold.Worker = StartSimpleJob( "CreateWorker" )
	
	XGUIEng.TransferMaterials( "Buy_LeaderSword", "Research_Debenture" )
	XGUIEng.TransferMaterials( "Buy_LeaderSpear", "Research_BookKeeping" )
	XGUIEng.TransferMaterials( "Buy_LeaderBow", "Research_PickAxe" )
	XGUIEng.TransferMaterials( "Buy_LeaderRifle", "Research_LightBricks" )
	XGUIEng.TransferMaterials( "Formation04", "Research_Coinage" )
	XGUIEng.TransferMaterials( "Research_Laws", "Research_Tracking" )

	Stronghold_Recover()
end

function OnPayday()
   timeOut = timeOut or false
   bezahlt = bezahlt or false
   
   if Logic.GetPlayerPaydayTimeLeft(1) < 1000  then
	timeOut = true
   elseif Logic.GetPlayerPaydayTimeLeft(1) > 118000 then
	   timeOut = false
	   bezahlt = false
   end
   if timeOut and not bezahlt then
		Tools.GiveResouces( 1, Logic.GetNumberOfLeader(1)*20, 0, 0, 0, 0, 0 )
		Tools.GiveResouces( 1, Stronghold.Income, 0, 0, 0, 0, 0 )
		AddGold( 1, -Stronghold.Sold )
		
		Stronghold.Ehre = Stronghold.Ehre + Stronghold.EhrePlus
		Stronghold.Motivation = Stronghold.Motivation + Stronghold.MotiPlus
		Stronghold.Motivation = Stronghold.Motivation + Stronghold.MotiMinus
		if Stronghold.Motivation == 100 then
			GUI.ClearNotes(); Message( "Das Volk liebt Euch, Sire." )
		elseif Stronghold.Motivation < 66 then
			GUI.ClearNotes(); Message( "Man ist sich Eurer nicht sicher." )
		elseif Stronghold.Motivation < 50 then
			GUI.ClearNotes(); Message( "Die Untertanen verlassen die Burg." )
		end
		if Stronghold.Motivation < 0 then Stronghold.Motivation = 0 end
		if Stronghold.Motivation > 100 then Stronghold.Motivation = 100 end
		bezahlt = true
   end
end

function Init_Attraction()

-- # # # # # # # # # # LOGIC # # # # # # # # # # --
	
	GetPlayerAttractionLimit_OrigSH = Logic.GetPlayerAttractionLimit
	Logic.GetPlayerAttractionLimit = function( _player )
		if _player == 1 then
			return Stronghold.AttractionMax
		else
			GetPlayerAttractionLimit_OrigSH( _player )
		end
	end
	GetPlayerAttractionUsage_OrigSH = Logic.GetPlayerAttractionUsage
	Logic.GetPlayerAttractionUsage = function( _player )
		if _player == 1 then
			local worker = Logic.GetNumberOfAttractedWorker( 1 )
			local agents = Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Scout )+(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Thief )*5)
			return worker+agents
		else
			GetPlayerAttractionUsage_OrigSH( _player )
		end
	end
end

function Init_GUI_Hacks()

-- # # # # # # # # # # ACTION # # # # # # # # # # --
	
	GUIAction_SetTaxes = function( _count )
		if _count == 0 then
			Stronghold.TaxHight = 0
		elseif _count == 1 then
			Stronghold.TaxHight = 1
		elseif _count == 2 then
			Stronghold.TaxHight = 2
		elseif _count == 3 then
			Stronghold.TaxHight = 3
		elseif _count == 4 then
			Stronghold.TaxHight = 4
		end
	end
	
	GUIAction_BuySerf = function()
		if GetGold(1) >= 50 then
			if Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Serf )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_BattleSerf )< Stronghold.Serfs then
				AddGold( 1, -50 )
				local pos = GetPosition("sammelplatz")
				Move( CreateEntity(1,Entities.PU_Serf,GetPosition("doorpos")), pos )
			else
				Message( "Ihr k�nnt keine weiteren Leibeigenen haben, Sire." )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesSerf_SERF_No_rnd_01)
			end
		else
			Message( 50-GetGold(1).." Taler fehlen im Stadts�ckel." )
			Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnoughGold_rnd_01)
		end
	end
	
	GUIAction_ReserachTechnology_OrigSH = GUIAction_ReserachTechnology
	GUIAction_ReserachTechnology = function( _tech )
		local sel = GUI.GetSelectedEntity()
		local X,Y = Logic.EntityGetPos( sel )
		if _tech == Technologies.T_Tracking then
			if Stronghold.LawAndOrder[1]== 0 then
				if GetGold(1)>= Stronghold.LawAndOrder[2] and GetClay(1)>= Stronghold.LawAndOrder[3] and GetWood(1)>= Stronghold.LawAndOrder[4] and GetStone(1)>= Stronghold.LawAndOrder[5] then
					AddGold( 1, -Stronghold.LawAndOrder[2] )
					AddClay( 1, -Stronghold.LawAndOrder[3] )
					AddWood( 1, -Stronghold.LawAndOrder[4] )
					AddStone( 1, -Stronghold.LawAndOrder[5] )
					Stronghold.LawAndOrder[1] = 1
					BurgMenu()
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeSword1 then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 600 and GetWood(1)>= 400 and Stronghold.Ehre >= 10 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderPoleArm3,8,X,Y,180 )
					AddGold(1, -600); AddWood(1, -400); Stronghold.Ehre = Stronghold.Ehre - 10
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 200 and GetWood(1)>= 80 and Stronghold.Ehre >= 10 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderPoleArm3,0,X,Y,180 )
					AddGold(1, -200); AddWood(1, -80); Stronghold.Ehre = Stronghold.Ehre - 10
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeSword2 then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 650 and GetIron(1)>= 70 and Stronghold.Ehre >= 12 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderBow3,8,X,Y,180 )
					AddGold(1, -650); AddIron(1, -470); Stronghold.Ehre = Stronghold.Ehre - 12
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 250 and GetIron(1)>= 70 and Stronghold.Ehre >= 12 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderBow3,X,Y,180,1)
					AddGold(1, -250); AddIron(1, -70); Stronghold.Ehre = Stronghold.Ehre - 12
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeSword3 then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 730 and GetIron(1)>= 490 and Stronghold.Ehre >= 25 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderSword4,8,X,Y,180 )
					AddGold(1, -730); AddIron(1, -490); Stronghold.Ehre = Stronghold.Ehre - 25
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 250 and GetIron(1)>= 90 and Stronghold.Ehre >= 25 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderSword4,X,Y,180,1)
					AddGold(1, -250); AddIron(1, -90); Stronghold.Ehre = Stronghold.Ehre - 25
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeSpear1 then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 660 and GetSulfur(1)>= 360 and Stronghold.Ehre >= 20 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderRifle1,4,X,Y,180 )
					AddGold(1, -660); AddSulfur(1, -360); Stronghold.Ehre = Stronghold.Ehre - 20
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 180 and GetSulfur(1)>= 40 and Stronghold.Ehre >= 20 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderRifle1,X,Y,180,1)
					AddGold(1, -180); AddSulfur(1, -40); Stronghold.Ehre = Stronghold.Ehre - 20
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeSpear2 then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 660 and GetIron(1)>= 260 and Stronghold.Ehre >= 35 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderHeavyCavalry2,3,X,Y,180 )
					AddGold(1, -660); AddIron(1, -260); Stronghold.Ehre = Stronghold.Ehre - 35
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 300 and GetIron(1)>= 120 and Stronghold.Ehre >= 35 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderHeavyCavalry2,X,Y,180,1)
					AddGold(1, -300); AddIron(1, -120); Stronghold.Ehre = Stronghold.Ehre - 35
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeSpear3 then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 940 and GetSulfur(1)>= 720 and Stronghold.Ehre >= 35 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderRifle2,8,X,Y,180 )
					AddGold(1, -940); AddSulfur(1, -720); Stronghold.Ehre = Stronghold.Ehre - 35
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 300 and GetSulfur(1)>= 80 and Stronghold.Ehre >= 35 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderRifle1,X,Y,180,1)
					AddGold(1, -300); AddSulfur(1, -80); Stronghold.Ehre = Stronghold.Ehre - 35
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif _tech == Technologies.T_UpgradeBow1 then
			X = X - 800; Y = Y + 400
			if GetGold(1)>= 300 and GetIron(1)>= 100 and GetSulfur(1)>= 150 and Stronghold.Ehre >= 25 then
				local unit = Logic.CreateEntity(Entities.PV_Cannon3,X,Y,270,1)
				AddGold(1, -300); AddIron(1, -100); AddSulfur(1, -150); Stronghold.Ehre = Stronghold.Ehre - 25
				Logic.MoveSettler( unit, X, Y )
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		elseif _tech == Technologies.T_UpgradeBow2 then
			X = X - 800; Y = Y + 400
			if GetGold(1)>= 300 and GetIron(1)>= 200 and GetSulfur(1)>= 200 and Stronghold.Ehre >= 30 then
				local unit = Logic.CreateEntity(Entities.PV_Cannon4,X,Y,270,1)
				AddGold(1, -300); AddIron(1, -200); AddSulfur(1, -200); Stronghold.Ehre = Stronghold.Ehre - 30
				Logic.MoveSettler( unit, X, Y )
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		else
			GUIAction_ReserachTechnology_OrigSH( _tech )
		end
	end
	GUIAction_CallMilitia = function()
		if Stronghold.Kitchen[1]== 0 then
			if GetGold(1)>= Stronghold.Kitchen[2] and GetClay(1)>= Stronghold.Kitchen[3] and GetWood(1)>= Stronghold.Kitchen[4] then
				AddGold( 1, -Stronghold.Kitchen[2] )
				AddClay( 1, -Stronghold.Kitchen[3] )
				AddWood( 1, -Stronghold.Kitchen[4] )
				Stronghold.Kitchen[1] = 1
				BurgMenu()
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		end
	end
	GUIAction_BackToWork = function()
		if Stronghold.TidyUp[1]== 0 then
			if GetGold(1)>= Stronghold.TidyUp[2]then
				AddGold( 1, -Stronghold.TidyUp[2] )
				Stronghold.TidyUp[1] = 1
				BurgMenu()
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		end
	end
	GUIAction_ToggleMenu_OrigSH = GUIAction_ToggleMenu
	GUIAction_ToggleMenu = function( a,b )
		if a == gvGUI_WidgetID.BuyHeroWindow then
			if Stronghold.Treasury[1]== 0 then
				if GetGold(1)>= Stronghold.Treasury[2] and GetStone(1)>= Stronghold.Treasury[3]then
					AddGold( 1, -Stronghold.Treasury[2] )
					AddStone( 1, -Stronghold.Treasury[3] )
					Stronghold.Treasury[1] = 1
					BurgMenu()
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		else
			GUIAction_ToggleMenu_OrigSH( a,b )
		end
	end
	GUIAction_LevyTaxes = function()
		if Stronghold.DamselRoom[1]== 0 then
			if GetGold(1)>= Stronghold.DamselRoom[2] and GetClay(1)>= Stronghold.DamselRoom[3] and GetStone(1)>= Stronghold.DamselRoom[4] then
				local pos = GetPosition("doorpos")
				SetEntityName(Tools.CreateGroup(1, Stronghold.DamselType, 0, pos.X, pos.Y, 180.00 ),Stronghold.DamselName)
				Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_PB_Monastery3)
				AddGold( 1, -Stronghold.DamselRoom[2] )
				AddClay( 1, -Stronghold.DamselRoom[3] )
				AddStone( 1, -Stronghold.DamselRoom[4] )
				Stronghold.DamselRoom[1] = 1
				BurgMenu()
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		end
	end
	
	GUIAction_BuyMilitaryUnit = function( a )
		local sel = GUI.GetSelectedEntity()
		local X,Y = Logic.EntityGetPos( sel )
		if a == UpgradeCategories.LeaderSword then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 200 and GetWood(1)>= 120 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderPoleArm1,4,X,Y,180 )
					AddGold(1, -200); AddWood(1, -120)
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 80 and GetWood(1)>= 40 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderPoleArm1,X,Y,180,1)
					AddGold(1, -80); AddWood(1, -40)
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif a == UpgradeCategories.LeaderPoleArm then
			X = X - 800; Y = Y - 300
			if Logic.IsAutoFillActive( sel )== 1 then
				if GetGold(1)>= 280 and GetWood(1)>= 220 and Stronghold.Ehre >= 6 then
					local unit = Tools.CreateGroup( 1,Entities.PU_LeaderBow2,4,X,Y,180 )
					AddGold(1, -280); AddWood(1, -220); Stronghold.Ehre = Stronghold.Ehre - 6
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			else
				if GetGold(1)>= 120 and GetWood(1)>= 60 and Stronghold.Ehre >= 6 then
					local unit = Logic.CreateEntity(Entities.PU_LeaderBow2,X,Y,180,1)
					AddGold(1, -80); AddWood(1, -40); Stronghold.Ehre = Stronghold.Ehre - 6
					Logic.MoveSettler( unit, X, Y )
				else
					Message( "Ihr habt nicht genug Rohstoffe!" )
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
				end
			end
		elseif a == UpgradeCategories.LeaderBow then
			X = X - 800; Y = Y + 400
			if GetGold(1)>= 150 and GetIron(1)>= 50 and GetSulfur(1)>= 100 and Stronghold.Ehre >= 10 then
				local unit = Logic.CreateEntity(Entities.PV_Cannon1,X,Y,270,1)
				AddGold(1, -150); AddIron(1, -50); AddSulfur(1, -100); Stronghold.Ehre = Stronghold.Ehre - 10
				Logic.MoveSettler( unit, X, Y )
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		elseif a == UpgradeCategories.LeaderRifle then
			X = X - 800; Y = Y + 400
			if GetGold(1)>= 200 and GetIron(1)>= 50 and GetSulfur(1)>= 120 and Stronghold.Ehre >= 15 then
				local unit = Logic.CreateEntity(Entities.PV_Cannon2,X,Y,270,1)
				AddGold(1, -200); AddIron(1, -50); AddSulfur(1, -120); Stronghold.Ehre = Stronghold.Ehre - 15
				Logic.MoveSettler( unit, X, Y )
			else
				Message( "Ihr habt nicht genug Rohstoffe!" )
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
			end
		elseif a == UpgradeCategories.Scout then
			X = X - 600; Y = Y - 350
			if Logic.GetPlayerAttractionUsage(1) < Logic.GetPlayerAttractionLimit(1)then
				if Logic.GetBuildingWorkPlaceUsage( sel )>0 then
					if GetGold(1)>= 100 and GetIron(1)>= 50 then
						local unit = Logic.CreateEntity(Entities.PU_Scout,X,Y,180,1)
						AddGold(1, -100); AddIron(1, -50)
						Logic.MoveSettler( unit, X, Y )
					else
						Message( "Ihr habt nicht genug Rohstoffe!" )
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
					end
				else
					Message( "Dieses Geb�ude hat keine Arbeitskr�fte, Sire." )
					Sound.PlayQueuedFeedbackSound(Sounds.AOVoicesScout_Scout_NO_rnd_01)
				end
			else
				Message( "Ihr k�nnt keine weiteren Kundschafter rekrutieren." )
				Sound.PlayQueuedFeedbackSound(Sounds.AOVoicesScout_Scout_NO_rnd_01)
			end
		elseif a == UpgradeCategories.Thief then
			X = X - 600; Y = Y - 350
			if Logic.GetPlayerAttractionUsage(1) < (Logic.GetPlayerAttractionLimit(1)-4)then
				if Logic.GetBuildingWorkPlaceUsage( sel )>0 then
					if GetGold(1)>= 300 and GetIron(1)>= 100 and Stronghold.Ehre >= 30 then
						local unit = Logic.CreateEntity(Entities.PU_Thief,X,Y,180,1)
						AddGold(1, -300); AddIron(1, -100); Stronghold.Ehre = Stronghold.Ehre - 30
						Logic.MoveSettler( unit, X, Y )
					else
						Message( "Ihr habt nicht genug Rohstoffe!" )
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
					end
				else
					Message( "Dieses Geb�ude hat keine Arbeitskr�fte, Sire." )
					Sound.PlayQueuedFeedbackSound(Sounds.AOVoicesThief_Thief_NO_rnd_01)
				end
			else
				Message( "Ihr k�nnt keine weiteren Diebe rekrutieren." )
				Sound.PlayQueuedFeedbackSound(Sounds.AOVoicesThief_Thief_NO_rnd_01)
			end
		end
	end
	
	GUIAction_BlessSettlers_OrigSH = GUIAction_BlessSettlers
	GUIAction_BlessSettlers = function(a)
		local faith = Logic.GetPlayersGlobalResource( 1, ResourceType.Faith )
		local need = Logic.GetMaximumFaith( 1 )
		local sel = GUI.GetSelectedEntity()
		local ERROR = "Die Priester sind noch nicht so weit."
		local ERROR2 = "Dieses Geb�ude hat keine Arbeitskr�fte, Sire."
		if Logic.GetAttachedWorkersToBuilding(sel)> 0 then
			if a == BlessCategories.Construction then
				if faith >= need then
					Sound.PlayGUISound( Sounds.Buildings_Monastery , 100 )
					Logic.SubFromPlayersGlobalResource( 1, ResourceType.Faith, faith )
					Message( "Eure Priester leuten die Glocke zum Gebet.")
					Stronghold.Motivation = Stronghold.Motivation + 6
					if Stronghold.Motivation > 100 then Stronghold.Motivation = 100 end
				else
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01)
					Message( ERROR )
				end
			elseif a == BlessCategories.Research then
				if faith >= need then
					Sound.PlayGUISound( Sounds.Buildings_Monastery , 100 )
					Logic.SubFromPlayersGlobalResource( 1, ResourceType.Faith, faith )
					Message( "Eure Priester vergeben die S�nden Eurer Arbeiter.")
					Stronghold.Ehre = Stronghold.Ehre + 6
				else
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01)
					Message( ERROR )
				end
			elseif a == BlessCategories.Weapons then
				if faith >= need then
					Sound.PlayGUISound( Sounds.Buildings_Monastery , 100 )
					Logic.SubFromPlayersGlobalResource( 1, ResourceType.Faith, faith )
					Message( "Eure Priester predigen Bibeltexte zu ihrer Gemeinde.")
					Stronghold.Motivation = Stronghold.Motivation + 12
					if Stronghold.Motivation > 100 then Stronghold.Motivation = 100 end
				else
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01)
					Message( ERROR )
				end
			elseif a == BlessCategories.Financial then
				if faith >= need then
					Sound.PlayGUISound( Sounds.Buildings_Monastery , 100 )
					Logic.SubFromPlayersGlobalResource( 1, ResourceType.Faith, faith )
					Message( "Eure Priester rufen auf zur Kollekte.")
					Stronghold.Ehre = Stronghold.Ehre + 12
				else
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01)
					Message( ERROR )
				end
			elseif a == BlessCategories.Canonisation then
				if faith >= need then
					Sound.PlayGUISound( Sounds.Buildings_Monastery , 100 )
					Logic.SubFromPlayersGlobalResource( 1, ResourceType.Faith, faith )
					Message( "Eure Priester sprechen Eure Taten heilig.")
					Stronghold.Motivation = Stronghold.Motivation + 8
					if Stronghold.Motivation > 100 then Stronghold.Motivation = 100 end
					Stronghold.Ehre = Stronghold.Ehre + 8
				else
					Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_MonksNeedMoreTime_rnd_01)
					Message( ERROR )
				end
			end
		else
			Message(ERROR2)
			Sound.PlayQueuedFeedbackSound(Sounds.VoicesWorker_WORKER_FunnyNo_rnd_01)
		end
	end
	
	GUIAction_BuySoldier_OrigSH = GUIAction_BuySoldier
	GUIAction_BuySoldier = function()
		local sel = GUI.GetSelectedEntity()
		local X,Y = Logic.EntityGetPos( sel )
		if string.find(Logic.GetCurrentTaskList(sel),"BATTLE")then
			Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01)
		elseif Logic.LeaderGetNumberOfSoldiers(sel) == Logic.LeaderGetMaxNumberOfSoldiers(sel)then
			Sound.PlayQueuedFeedbackSound(Sounds.VoicesLeader_LEADER_NO_rnd_01)
		else
			if Logic.GetEntityType(sel) == Entities.PU_LeaderPoleArm1
			or Logic.GetEntityType(sel) == Entities.PU_LeaderPoleArm2
			or Logic.GetEntityType(sel) == Entities.CU_Evil_LeaderSkirmisher1 then
				if GetGold(1)>= 30 and GetWood(1)>= 20 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-30 ); AddWood( 1,-20 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderBow1
			or Logic.GetEntityType(sel) == Entities.PU_LeaderBow2
			or Logic.GetEntityType(sel) == Entities.CU_BanditLeaderBow1 then
				if GetGold(1)>= 40 and GetWood(1)>= 40 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-40 ); AddWood( 1,-40 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderPoleArm3
			or Logic.GetEntityType(sel) == Entities.PU_LeaderPoleArm4 
			or Logic.GetEntityType(sel) == Entities.PU_LeaderCavalry1
			or Logic.GetEntityType(sel) == Entities.PU_LeaderCavalry2 then
				if GetGold(1)>= 50 and GetWood(1)>= 40 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-50 ); AddWood( 1,-40 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderBow3
			or Logic.GetEntityType(sel) == Entities.PU_LeaderBow4 then
				if GetGold(1)>= 50 and GetIron(1)>= 50 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-50 ); AddIron( 1,-50 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderSword1
			or Logic.GetEntityType(sel) == Entities.PU_LeaderSword2
			or Logic.GetEntityType(sel) == Entities.CU_BanditLeaderSword2
			or Logic.GetEntityType(sel) == Entities.CU_BanditLeaderSword1
			or Logic.GetEntityType(sel) == Entities.CU_BlackKnight_LeaderMace1
			or Logic.GetEntityType(sel) == Entities.CU_BlackKnight_LeaderMace2
			or Logic.GetEntityType(sel) == Entities.CU_Barbarian_LeaderClub1
			or Logic.GetEntityType(sel) == Entities.CU_Barbarian_LeaderClub2
			or Logic.GetEntityType(sel) == Entities.CU_Evil_LeaderBearman1 then
				if GetGold(1)>= 40 and GetIron(1)>= 30 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-40 ); AddIron( 1,-30 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderSword3
			or Logic.GetEntityType(sel) == Entities.PU_LeaderSword4 then
				if GetGold(1)>= 60 and GetIron(1)>= 50 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-60 ); AddIron( 1,-50 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderRifle1 then
				if GetGold(1)>= 50 and GetSulfur(1)>= 40 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-50 ); AddSulfur( 1,-40 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderHeavyCavalry1
			or Logic.GetEntityType(sel) == Entities.PU_LeaderHeavyCavalry2 then
				if GetGold(1)>= 120 and GetIron(1)>= 80 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-120 ); AddIron( 1,-80 )
				end
			elseif Logic.GetEntityType(sel) == Entities.PU_LeaderRifle2 then
				if GetGold(1)>= 80 and GetSulfur(1)>= 80 then
					Logic.CreateEntity(Logic.LeaderGetSoldiersType(sel),X,Y,0,1)
					Tools.AttachSoldiersToLeader(sel,1)
					AddGold( 1,-80 ); AddSulfur( 1,-80 )
				end
			else
				GUIAction_BuySoldier_OrigSH()
			end
		end
	end
	
	GUIAction_ChangeFormation_OrigSH = GUIAction_ChangeFormation
	GUIAction_ChangeFormation = function(a)
		local ERROR = "Ihr habt nicht genug Ehre, Sire!"
		local ERROR2 = "Ihr habt die erforderliche Bedingung noch nicht erf�llt."
		if IsEntitySelected(Stronghold.Hero) and IsAloneInSelection()then
			if a == 4 then
				if Stronghold.Rank == 0 then
					if Logic.IsTechnologyResearched( 1, Technologies.GT_Construction )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Literacy )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Alchemy )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Mercenaries )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Mathematics )== 1 then
						if Stronghold.Ehre >= 10 then
							Message( "Erhebt Euch "..Orange.." Ritter!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 10
							Stronghold.Rank = 1
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 1 then
					if Logic.GetNumberOfAttractedWorker( 1 )>= 50 then
						if Stronghold.Ehre >= 25 then
							Message( "Erhebt Euch "..Orange.." Edler Ritter!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 25
							Stronghold.Rank = 2
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 2 then
					if Logic.GetEntityType(GetEntityId(Stronghold.HQ))== Entities.PB_Headquarters2
					or Logic.GetEntityType(GetEntityId(Stronghold.HQ))== Entities.PB_Headquarters3 then
						if Stronghold.Ehre >= 50 then
							Message( "Erhebt Euch "..Orange.." Reichsritter!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 50
							Stronghold.Rank = 3
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 3 then
					if Logic.IsTechnologyResearched( 1, Technologies.GT_GearWheel )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Trading )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Alloying )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_StandingArmy )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Binocular )== 1 then
						if Stronghold.Ehre >= 100 then
							Message( "Erhebt Euch "..Orange.." Streiter des K�nigs!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 100
							Stronghold.Rank = 4
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 4 then
					if Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PB_Blacksmith2 )>0
					or Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PB_Blacksmith3 )>0 then
						if Stronghold.Ehre >= 150 then
							Message( "Erhebt Euch "..Orange.." F�rst!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 150
							Stronghold.Rank = 5
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 5 then
					if Logic.IsTechnologyResearched( 1, Technologies.GT_ChainBlock )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Printing )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Metallurgy )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Tactics )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Matchlock )== 1 then
						if Stronghold.Ehre >= 200 then
							Message( "Erhebt Euch "..Orange.." Baron!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 200
							Stronghold.Rank = 6
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 6 then
					if Logic.GetEntityType(GetEntityId(Stronghold.HQ))== Entities.PB_Headquarters3 then
						if Stronghold.Ehre >= 250 then
							Message( "Erhebt Euch "..Orange.." Graf!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 250
							Stronghold.Rank = 7
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				elseif Stronghold.Rank == 7 then
					if Logic.IsTechnologyResearched( 1, Technologies.GT_Architecture )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Library )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Chemistry )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_Strategies )== 1
					or Logic.IsTechnologyResearched( 1, Technologies.GT_PulledBarrel )== 1 then
						if Stronghold.Ehre >= 300 then
							Message( "Erhebt Euch "..Orange.." Herzog!" )
							Sound.PlayQueuedFeedbackSound(Sounds.OnKlick_Select_dario)
							Stronghold.Ehre = Stronghold.Ehre - 300
							Stronghold.Rank = 8
						else
							Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_INFO_NotEnough)
							Message(ERROR)
						end
					else
						Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_COMMENT_BadPlay_rnd_01)
						Message(ERROR2)
					end
				end
			else
				GUIAction_ChangeFormation_OrigSH(a)
			end
		else
			GUIAction_ChangeFormation_OrigSH(a)
		end
	end

-- # # # # # # # # # # TOOLTIP # # # # # # # # # # --
	
	GUITooltip_Payday_OrigSH = GUITooltip_Payday
	GUITooltip_Payday = function()
		local payday = round(Logic.GetPlayerPaydayTimeLeft(1)/1000)
		local moti = Stronghold.MotiPlus+Stronghold.MotiMinus
		local moticolor = Gruen
		if moti < 0 then moticolor = Rot end
		XGUIEng.SetText( "TooltipTopText", Umlaute(Grau.." Abrechnung @cr "..Weiss.." "..payday.." Sekunden bis zur n�chsten"..
										" Abrechnung. @cr Ihr erhaltet: @cr "..moticolor.." "..moti.." "..Weiss.." "..
										" Beliebtheit @cr "..Gruen.." "..Stronghold.EhrePlus.." "..Weiss.." Ehre"))
	end
	
	GUITooltip_LevyTaxes = function()
		if XGUIEng.IsButtonDisabled( "Levy_Duties" )== 1 and Stronghold.DamselRoom[1]== 0 and Stronghold.Kitchen[1]== 0 then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgfr�uleingemarch @cr "..Weiss.." "..
							" "..Gelb.." ben�tigt: "..Weiss.." Festung @cr "..
							" "..Gelb.." erm�glicht: "..Weiss.." +4 Beliebtheit +6 Ehre +Burgfr�ulein als weiterer Held @cr "..
							" Verhindert den Bau von "..Blau.." Burgk�che"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
							" Taler: "..GibTTGold(Stronghold.DamselRoom[2]).." @cr "..
							" Lehm: "..GibTTLehm(Stronghold.DamselRoom[3]).." @cr "..
							" Stein: "..GibTTStein(Stronghold.DamselRoom[4])))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif XGUIEng.IsButtonDisabled( "Levy_Duties" )== 0 and Stronghold.DamselRoom[1]== 0 and Stronghold.Kitchen[1]== 0 then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgfr�uleingemarch @cr "..Weiss.." "..
							" "..Gelb.." erm�glicht: "..Weiss.." +4 Beliebtheit +6 Ehre +Burgfr�ulein als weiterer Held @cr "..
							" Verhindert den Bau von "..Blau.." Burgk�che"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
							" Taler: "..GibTTGold(Stronghold.DamselRoom[2]).." @cr "..
							" Lehm: "..GibTTLehm(Stronghold.DamselRoom[3]).." @cr "..
							" Stein: "..GibTTStein(Stronghold.DamselRoom[4])))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif Stronghold.DamselRoom[1]== 0 and Stronghold.Kitchen[1]== 1 then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgfr�uleingemarch @cr "..Weiss.." "..
							" Durch den Bau des Burgfr�uleingemarchs habt Ihr keinen Platz mehr f�r die Burgk�che."))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif Stronghold.DamselRoom[1]== 1 then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgfr�uleingemarch @cr "..Weiss.." "..
							" "..Weiss.." Eine Frau am Hofe erh�ht die Beliebt- und Ehrenhaftigkeit Eures Burgherren, solange"..
							" sie bei Bewusstsein ist. das Burgfr�ulein besitzt �hnliche Rechte wie der Burgherr."))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		end
	end
	GUITooltip_Generic_OrigWP = GUITooltip_Generic;
    GUITooltip_Generic = function(a)
        GUITooltip_Generic_OrigWP(a)
		local maximum = Stronghold.AttractionLimit*Stronghold.AttractionMulti
        if a == "MenuResources/Motivation" then
            XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." "..Stronghold.RankName[Stronghold.Rank+1].." @cr "..Weiss..""..
							" Euer Burgherr hat den Rang \" "..Stronghold.RankName[Stronghold.Rank+1].." \" inne."))
		elseif a == "MenuResources/population" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bev�lkerung @cr "..Weiss.." "..
							" Hier seht Ihr die Anzahl Eurer Arbeiter und die Gesamtzahl der "..
							" verf�gbaren Pl�tze. @cr Bevolkerungsgenze: "..Blau.." "..round(maximum)..""))
		elseif a == "MenuHeadquarter/buy_hero" then
			if XGUIEng.IsButtonHighLighted( "Buy_Hero" )== 0 and Stronghold.Treasury[1]== 0 and Stronghold.LawAndOrder[1]== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schatzkammer @cr "..Weiss.." "..
								" "..Gelb.." erm�glicht: "..Weiss.." -4 Beliebtheit +9 Ehre @cr "..
								" Verhindert den Bau von "..Blau.." Rechtskammer"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(Stronghold.Treasury[2]).." @cr "..
								" Stein: "..GibTTStein(Stronghold.Treasury[3])))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif Stronghold.Treasury[1]== 0 and Stronghold.LawAndOrder[1]== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schatzkammer @cr "..Weiss.." "..
								" Durch den Bau des Gerichts habt Ihr keinen Platz mehr f�r die Schatzkammer."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif Stronghold.Treasury[1]== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schatzkammer @cr "..Weiss.." "..
								" "..Weiss.." Durch Eure Eroberungsfeldz�ge sammelt Ihr Reichtum an, der in diesem"..
								" Raum gelagert wird. Beim Volke kommt diese Sammelwut aber nicht gut an."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		elseif a == "MenuHeadquarter/CallMilitia" then
			if XGUIEng.IsButtonDisabled( "HQ_CallMilitia" )== 1 and Stronghold.Kitchen[1]== 0 and Stronghold.DamselRoom[1]== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgk�che @cr "..Weiss.." "..
								" "..Gelb.." ben�tigt: "..Weiss.." Festung @cr "..
								" "..Gelb.." erm�glicht: "..Weiss.." -6 Beliebtheit +12 Ehre @cr "..
								" Verhindert den Bau von "..Blau.." Burgfr�uleingemarch"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(Stronghold.Kitchen[2]).." @cr "..
								" Lehm: "..GibTTLehm(Stronghold.Kitchen[3]).." @cr "..
								" Holz: "..GibTTHolz(Stronghold.Kitchen[4])))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif XGUIEng.IsButtonDisabled( "HQ_CallMilitia" )== 0 and Stronghold.Kitchen[1]== 0 and Stronghold.DamselRoom[1]== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgk�che @cr "..Weiss.." "..
								" "..Gelb.." erm�glicht: "..Weiss.." -6 Beliebtheit +12 Ehre @cr "..
								" Verhindert den Bau von "..Blau.." Burgfr�uleingemarch"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(Stronghold.Kitchen[2]).." @cr "..
								" Lehm: "..GibTTLehm(Stronghold.Kitchen[3]).." @cr "..
								" Holz: "..GibTTHolz(Stronghold.Kitchen[4])))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif Stronghold.Kitchen[1]== 0 and Stronghold.DamselRoom[1]== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgk�che @cr "..Weiss.." "..
								" Durch den Bau des Burgfr�uleingemarchs habt Ihr keinen Platz mehr f�r die Burgk�che."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif Stronghold.Kitchen[1]== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Burgk�che @cr "..Weiss.." "..
								" "..Weiss.." Ihr k�nnt nun Speisen wie Gott in Frankreich, G�ste einladen und"..
								" rauschende Feste feiern. Euch macht das ehrenhafter, Sire, dem P�bel gef�llt"..
								" diese Verschwendung aber nicht!"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		elseif a == "MenuHeadquarter/BackToWork" then
			if XGUIEng.IsButtonDisabled( "HQ_BackToWork" )== 1 and XGUIEng.IsButtonHighLighted( "HQ_BackToWork" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stadtreinigung @cr "..
							" "..Gelb.." ben�tigt: "..Weiss.." Zitadelle @cr "..Gelb.." erm�glicht: "..Weiss..""..
							" +6 Beliebtheit +6 Ehre"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
							" Taler: "..GibTTGold(Stronghold.TidyUp[2])))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif XGUIEng.IsButtonDisabled( "HQ_BackToWork" )== 0 and XGUIEng.IsButtonHighLighted( "HQ_BackToWork" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stadtreinigung @cr "..
							" "..Gelb.." erm�glicht: "..Weiss.." +6 Beliebtheit +6 Ehre"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
							" Taler: "..GibTTGold(Stronghold.TidyUp[2])))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif XGUIEng.IsButtonDisabled( "HQ_BackToWork" )== 0 and XGUIEng.IsButtonHighLighted( "HQ_BackToWork" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stadtreinigung @cr "..
							" "..Weiss.." Die Stadtreinigung wird nun die Jauche entfernen und Falken auf Ratten"..
							"jagt schicken. Durch die neue Sauberkeit sind Euch Eure Untertanen mehr zugetan."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		elseif a == "MenuHeadquarter/SetVeryLowTaxes" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Keine Steuern @cr "..
							" "..Weiss.." Eure Untertanen zahlen keine Steuern. @cr "..Gelb.." bewirkt:"..
							" "..Weiss.." + 8 Beliebtheit + 10 Ehre"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == "MenuHeadquarter/SetLowTaxes" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Geringe Steuern @cr "..
							" "..Weiss.." Eine kleine Steuer wird von den Untertanen verlangt. @cr "..Gelb..""..
							" bewirkt: "..Weiss.." - 3 Beliebtheit"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == "MenuHeadquarter/SetNormalTaxes" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Faire Steuern @cr "..
							" "..Weiss.." Der Steuersatz ist fair bemmessen. @cr "..Gelb.." bewirkt:"..
							" "..Weiss.." - 6 Beliebtheit"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == "MenuHeadquarter/SetHighTaxes" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Hohe Steuern @cr "..
							" "..Weiss.." Die Steuerschraube wird angezogen. @cr "..Gelb.." bewirkt:"..
							" "..Weiss.." - 9 Beliebtheit"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == "MenuHeadquarter/SetVeryHighTaxes" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Grausame Steuern @cr "..
							" "..Weiss.." Ihr zieht Euren Untertanen das letzte Hemd aus. @cr "..Gelb.." bewirkt:"..
							" "..Weiss.." - 12 Beliebtheit"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
        end
    end
	
	GUITooltip_ResearchTechnologies_OrigSH = GUITooltip_ResearchTechnologies
	GUITooltip_ResearchTechnologies = function( a, b, c )
		local Not = ""..Weiss.." Diese Einheit ist zur Zeit nicht verf�gbar."
		local sel = GUI.GetSelectedEntity()
		local head2 = NumberOfCompleteBuildings( Entities.PB_Headquarters2 )
		local head3 = NumberOfCompleteBuildings( Entities.PB_Headquarters3 )
		local smith2 = NumberOfCompleteBuildings( Entities.PB_Blacksmith2 )
		local smith3 = NumberOfCompleteBuildings( Entities.PB_Blacksmith3 )
		local gsmith1 = NumberOfCompleteBuildings( Entities.PB_GunsmithWorkshop1 )
		local gsmith2 = NumberOfCompleteBuildings( Entities.PB_GunsmithWorkshop2 )
		local stable1 = NumberOfCompleteBuildings( Entities.PB_Stable1 )
		local stable2 = NumberOfCompleteBuildings( Entities.PB_Stable2 )
		if a == Technologies.T_Tracking then
			if Stronghold.LawAndOrder[1] == 0 and Stronghold.Treasury[1] == 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Rechtskammer @cr "..
							" "..Gelb.." erm�glicht: "..Weiss.." +3 Beliebtheit + 5 Ehre @cr "..
								" Verhindert den Bau von "..Blau.." Schatzkammer"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
							" Taler: "..GibTTGold(Stronghold.LawAndOrder[2]).." @cr "..
							" Lehm: "..GibTTLehm(Stronghold.LawAndOrder[3]).." @cr "..
							" Holz: "..GibTTHolz(Stronghold.LawAndOrder[4]).." @cr "..
							" Stein: "..GibTTStein(Stronghold.LawAndOrder[5])))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif Stronghold.LawAndOrder[1] == 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Rechtskammer @cr "..
							" "..Weiss.." Ihr habt ein Gericht in Eurem Bergfried gebaut. Ein Richter verurteilt"..
							" nun Verbrecher, was Eure Ehre und Eure Beliebtheit erh�ht, Sire."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			elseif Stronghold.LawAndOrder[1] == 0 and Stronghold.Treasury[1] == 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Rechtskammer @cr "..
							" "..Weiss.." Durch den Bau der Schatzkammer habt Ihr keinen Platz mehr f�r ein Gericht."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		elseif a == Technologies.T_UpgradeSword1 then
			if not(Stronghold.Lance[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streitlanzentr�ger @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Research_UpgradeSword1" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streitlanzentr�ger @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Reichsritter"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Research_UpgradeSword1" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streitlanzentr�ger @cr "..
									" "..Weiss.." Streitlanzentr�ger bewachen den Burgherren und sind gut ausgebildete"..
									", reiche B�rger die sich eine gute Ausr�stung leisten k�nnen. Sie sind besonders"..
									"stark gegen Kavaliere."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(200).." @cr "..
								" Holz: "..GibTTHolz(80).." @cr "..
								" Ehre: "..GibTTEhre(10)).." @cr "..
								" Sold: "..Stronghold.Lance[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(600).." @cr "..
								" Holz: "..GibTTHolz(400).." @cr "..
								" Ehre: "..GibTTEhre(10)).." @cr "..
								" Sold: "..Stronghold.Lance[1])
				end
			end
		elseif a == Technologies.T_UpgradeSword2 then
			if not(Stronghold.Crossbow[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Armbrustsch�tze @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Research_UpgradeSword2" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Armbrustsch�tze @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Streiter des K�nigs"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Research_UpgradeSword2" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Armbrustsch�tze @cr "..
									" "..Weiss.." Armbrustsch�tzen benutzen eine starke Waffe, die Effektiv gegen"..
									" leichte und mittlelschwer gepanzerte Truppen ist. Es sind loyale und gut"..
									" ausgebildete K�mpfer, die Euer Heer erg�nzen, My Lord."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(250).." @cr "..
									" Eisen: "..GibTTEisen(70).." @cr "..
									" Ehre: "..GibTTEhre(12)).." @cr "..
								" Sold: "..Stronghold.Crossbow[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(650).." @cr "..
								" Eisen: "..GibTTEisen(470).." @cr "..
								" Ehre: "..GibTTEhre(12)).." @cr "..
								" Sold: "..Stronghold.Crossbow[1])
				end
			end
		elseif a == Technologies.T_UpgradeSword3 then
			if not(Stronghold.Sword[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bastardschwertk�mpfer @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Research_UpgradeSword3" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bastardschwertk�mpfer @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: F�rst, Garnison"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Research_UpgradeSword3" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bastardschwertk�mpfer @cr "..
									" "..Weiss.." Bastardschwertk�mpfer sind Eure schwerste Infanterie, mit der es"..
									" nur wenige aufnehmen k�nnen. Sie sind stark gegen Fernk�mpfer und Speertr�ger"..
									" m�ssen sich jedoch vor der Kavaliere in acht nehmen."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(250).." @cr "..
								" Eisen: "..GibTTEisen(90).." @cr "..
								" Ehre: "..GibTTEhre(25)).." @cr "..
								" Sold: "..Stronghold.Sword[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(730).." @cr "..
								" Eisen: "..GibTTEisen(490).." @cr "..
								" Ehre: "..GibTTEhre(25)).." @cr "..
								" Sold: "..Stronghold.Sword[1])
				end
			end
		elseif a == Technologies.T_UpgradeSpear1 then
			if not(Stronghold.Rifle1[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Leichter Scharfsch�tze @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Research_UpgradeSpear1" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Leichter Scharfsch�tze @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Baron, Garnison, B�chsenmacherei"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Research_UpgradeSpear1" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Leichter Scharfsch�tze @cr "..
									" "..Weiss.." Ausgestattet mit den neuen Feuerwaffen stellen sie sich den"..
									" feindlichen Fernk�mpfern in den Weg. Sie sind schwach gegen Nahk�mpfer."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(180).." @cr "..
									" Schwefel: "..GibTTSchwefel(40).." @cr "..
									" Ehre: "..GibTTEhre(20)).." @cr "..
								" Sold: "..Stronghold.Rifle1[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(660).." @cr "..
								" Schwefel: "..GibTTSchwefel(360).." @cr "..
								" Ehre: "..GibTTEhre(20)).." @cr "..
								" Sold: "..Stronghold.Rifle1[1])
				end
			end
		elseif a == Technologies.T_UpgradeSpear2 then
			if not(Stronghold.Knight[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streitaxtk�mpfer @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Research_UpgradeSpear2" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streitaxtk�mpfer @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Graf, Stall, Feinschmiede, Garnision"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Research_UpgradeSpear2" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streitaxtk�mpfer @cr "..
									" "..Weiss.." Treue Ritter, die fast jeden Gegner nieder m�hen, der sich ihnen in"..
									" den Weg stellt. Sie sind aber anf�llig gegen Fernkampfangriffe und sollten sich von"..
									" Lanzentr�gern fernhalten."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				local knightsold = 0; if NumberOfCompleteBuildings( Entities.PB_Stable2 ) > 0 then knightsold = 50 else knightsold = 0 end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(300).." @cr "..
									" Eisen: "..GibTTEisen(120).." @cr "..
									" Ehre: "..GibTTEhre(35)).." @cr "..
								" Sold: "..Stronghold.Knight[1]-knightsold)
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(660).." @cr "..
								" Eisen: "..GibTTEisen(260).." @cr "..
								" Ehre: "..GibTTEhre(35)).." @cr "..
								" Sold: "..Stronghold.Knight[1]-knightsold)
				end
			end
		elseif a == Technologies.T_UpgradeSpear3 then
			if not(Stronghold.Rifle1[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schwerer Scharfsch�tze @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Research_UpgradeSpear3" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schwerer Scharfsch�tze @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Herzog, Garnison, B�chsenmanufaktur"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Research_UpgradeSpear3" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schwerer Scharfsch�tze @cr "..
									" "..Weiss.." Die Musketen dieser M�nner besitzen die gr��te Reichweite. Keine"..
									" Waffe der bekannten Welt trifft �ber diese Distanz. Leider sind diese Waffen"..
									" nur gegen unbewegliche Ziele wie Fernk�mpfer oder Geb�ude effektiv."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(300).." @cr "..
									" Schwefel: "..GibTTSchwefel(80).." @cr "..
									" Ehre: "..GibTTEhre(35)).." @cr "..
								" Sold: "..Stronghold.Rifle2[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(940).." @cr "..
								" Schwefel: "..GibTTSchwefel(720).." @cr "..
								" Ehre: "..GibTTEhre(35)).." @cr "..
								" Sold: "..Stronghold.Rifle2[1])
				end
			end
		elseif a == Technologies.T_UpgradeBow1 then
			if XGUIEng.IsButtonDisabled( "Research_UpgradeBow1" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Eisenkanone @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Herzog, Schie�anlage, Chemie"))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Eisenkanone @cr "..
									" "..Weiss.." Diese gro�e Kanone ist zum vernichten von Truppen gedacht."..
									" @cr "..Gelb.." stark gegen Einheiten"))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Taler: "..GibTTGold(300).." @cr "..
							" Eisen: "..GibTTEisen(100).." @cr Schwefel: "..GibTTSchwefel(150).." @cr "..
							" Ehre: "..GibTTEhre(25)).." @cr Sold: "..Stronghold.Cannons[3])
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == Technologies.T_UpgradeBow2 then
			if XGUIEng.IsButtonDisabled( "Research_UpgradeBow2" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Belagerungskanone @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Herzog, Schie�anlage, Chemie"))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Belagerungskanone @cr "..
									" "..Weiss.." Eine schwere Kanone deren Aufgabe es ist Befestigungen zu "..
									" zerst�ren. @cr "..Gelb.." stark gegen Geb�ude"))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Taler: "..GibTTGold(300).." @cr "..
							" Eisen: "..GibTTEisen(200).." @cr Schwefel: "..GibTTSchwefel(200).." @cr "..
							" Ehre: "..GibTTEhre(30)).." @cr Sold: "..Stronghold.Cannons[4])
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == Technologies.T_UpgradeRifle1 then
			if XGUIEng.IsButtonDisabled( "Research_UpgradeRifle1" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Besseres Fahrgestell @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Schie�anlage @cr "..Gelb.." erm�glicht:"..
									" "..Weiss.." Kanonen bewegen sich schneller."))
			elseif XGUIEng.IsButtonDisabled( "Research_UpgradeRifle1" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Besseres Fahrgestell @cr "..
									" "..Gelb.." erm�glicht:"..
									" "..Weiss.." Kanonen bewegen sich schneller."))
			elseif XGUIEng.IsButtonHighLighted( "Research_UpgradeRifle1" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Besseres Fahrgestell @cr "..
									" "..Weiss.." Eure Kanonen sind jetzt schneller."))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Holz: "..GibTTHolz(200).." @cr "..
							" Eisen: "..GibTTEisen(200)))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == Technologies.T_BetterTrainingArchery then
			if XGUIEng.IsButtonDisabled( "Research_BetterTrainingArchery" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Meistersch�tze @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Schie�anlage @cr "..Gelb.." erm�glicht:"..
								" "..Weiss.." Sch�tzen schie�en schneller und treffen besser"))
			elseif XGUIEng.IsButtonDisabled( "Research_BetterTrainingArchery" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Meistersch�tze @cr "..
								" "..Gelb.." erm�glicht:"..
								" "..Weiss.." Sch�tzen schie�en schneller und treffen besser"))
			elseif XGUIEng.IsButtonHighLighted( "Research_BetterTrainingArchery" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Meistersch�tze @cr "..
									" "..Weiss.." Eure Sch�tzen schie�en nun schneller und treffen auch besser."))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Taler: "..GibTTGold(200).." @cr "..
							" Eisen: "..GibTTEisen(200)))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == Technologies.T_BetterTrainingBarracks then
			if XGUIEng.IsButtonDisabled( "Research_BetterTrainingBarracks" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Marschieren @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Garnision @cr "..Gelb.." erm�glicht:"..
								" "..Weiss.." Infanterie bewegt sich schneller"))
			elseif XGUIEng.IsButtonDisabled( "Research_BetterTrainingBarracks" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Marschieren @cr "..
								" "..Gelb.." erm�glicht:"..
								" "..Weiss.." Infanterie bewegt sich schneller"))
			elseif XGUIEng.IsButtonHighLighted( "Research_BetterTrainingBarracks" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Marschieren @cr "..
									" "..Weiss.." Eure Infanterie kann nun schneller laufen."))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Taler: "..GibTTGold(200).." @cr "..
							" Eisen: "..GibTTEisen(200)))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == Technologies.GT_ChainBlock then
			GUITooltip_ResearchTechnologies_OrigSH( a,b,c )
			if XGUIEng.IsButtonDisabled( "Research_ChainBlock" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Flaschenzug @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Zahnrad, Universit�t @cr "..Gelb.." "..
								" erm�glicht: "..Weiss.." Ausbau von S�gem�hlen und Steinmetzh�tten"))
			elseif XGUIEng.IsButtonDisabled( "Research_ChainBlock" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Metallurgie @cr "..
								" "..Gelb.." erm�glicht: "..Weiss.." Ausbau von S�gem�hlen und Steinmetzh�tten" ))
			elseif XGUIEng.IsButtonHighLighted( "Research_ChainBlock" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Metallurgie @cr "..
									" "..Weiss.." Jetzt seit Ihr in der Lage S�gem�hlen und Steinmetzh�tten auszubauen"..
									" um ihre Produktivit�t zu steigern."))
			end
		elseif a == Technologies.GT_Metallurgy then
			GUITooltip_ResearchTechnologies_OrigSH( a,b,c )
			if XGUIEng.IsButtonDisabled( "Research_Metallurgy" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Metallurgie @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Legierungen, Universit�t @cr "..Gelb.." "..
								" erm�glicht: "..Weiss.." Bombarde, Bronzekanone, Ausbau von Balistat�rmen,"..
								" Grobschmieden, Alchemistenh�tten"))
			elseif XGUIEng.IsButtonDisabled( "Research_Metallurgy" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Metallurgie @cr "..
								" "..Gelb.." erm�glicht: "..Weiss.." Bombarde, Bronzekanone, Ausbau von"..
								" Balistat�rmen, Grobschmieden, Alchemistenh�tten" ))
			elseif XGUIEng.IsButtonHighLighted( "Research_Metallurgy" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Metallurgie @cr "..
									" "..Weiss.." Mein Herr, durch die Metallurgie k�nnt Ihr nun Kanonen"..
									" bauen lassen, Balistat�rme, Grobschmieden und Alchimistenh�tten"..
									" ausbauen."))
			end
		elseif a == Technologies.GT_Chemistry then
			GUITooltip_ResearchTechnologies_OrigSH( a,b,c )
			if XGUIEng.IsButtonDisabled( "Research_Chemistry" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Chemie @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Metallurgie, Universit�t, Zitadelle"..
								" @cr "..Gelb.." erm�glicht: "..Weiss.." Eisenkanone, Belagerungskanone"))
			elseif XGUIEng.IsButtonDisabled( "Research_Chemistry" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Chemie @cr "..
								" "..Gelb.." erm�glicht: "..Weiss.." Eisenkanone, Belagerungskanone"))
			elseif XGUIEng.IsButtonHighLighted( "Research_Chemistry" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Chemie @cr "..
									" "..Weiss.." Nun k�nnt Ihr die m�chtigtsten Kanonen bauen, Sire. Bravo."))
			end
		elseif a == Technologies.GT_StandingArmy then
			GUITooltip_ResearchTechnologies_OrigSH( a,b,c )
			if XGUIEng.IsButtonDisabled( "Research_StandingArmy" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stehendes Herr @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Wehrpflicht, Festung @cr "..Gelb.." "..
								" erm�glicht: "..Weiss.." "))
			elseif XGUIEng.IsButtonDisabled( "Research_StandingArmy" )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stehendes Heer @cr "..
								" "..Gelb.." erm�glicht: "..Weiss.." Kampfformationen, Schie�platz" ))
			elseif XGUIEng.IsButtonHighLighted( "Research_StandingArmy" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stehendes Heer @cr "..
									" "..Weiss.." Nun k�nnt Ihr Schie�pl�tze bauen und Belagerungswaffen herstellen."..
									" Benutzt die Formationen um in der Schlacht erfolgreich zu seien."))
			end
		else
			GUITooltip_ResearchTechnologies_OrigSH( a,b,c )
		end
	end
	
	GUITooltip_BuySerf_OrigSH = GUITooltip_BuySerf
	GUITooltip_BuySerf = function()
		GUITooltip_BuySerf_OrigSH()
		local serf = Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Serf )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_BattleSerf )
		XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Leibeigenen kaufen @cr "..Weiss.." "..
						" Kauft einen Leibeigenen. @cr Ihr k�nnt noch "..Blau.." "..Stronghold.Serfs-serf..""..
						" "..Weiss.." Leibeigene anwerben."))
	end
	
	GUITooltip_ConstructBuilding_OrigSH = GUITooltip_ConstructBuilding
	GUITooltip_ConstructBuilding = function(a,b,c,d,e,f)
		local Not = Grau.." Nicht verf�gbar @cr "..Weiss.." Dieses Geb�ude ist noch nicht verf�gbar."
		if a == UpgradeCategories.Residence then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Residence )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Wohnhaus @cr "..Weiss.." "..
								" In einem Wohnhaus erhohlen sich Eure Arbeiter. @cr "..Gelb.." erm�glicht:"..
								" "..Weiss.." +6 Bev�lkerung."))
			end
		elseif a == UpgradeCategories.Barracks then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Barracks )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kaserne @cr "..Weiss.." "..
								" In einer Kasserne werden Soldaten angeheuert. @cr "..
								" "..Gelb.." ben�tig: "..Weiss.." Wehrpflicht"))
			end
		elseif a == UpgradeCategories.Archery then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Archery )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schie�platz @cr "..Weiss.." "..
								" Auf dem Schie�platz werden Belagerungswaffen gebaut und Sch�tzen verbessert. @cr "..
								" "..Gelb.." ben�tig: "..Weiss.." Stehendes Heer"))
			end
		elseif a == UpgradeCategories.Stable then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Stables )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Stall @cr "..Weiss.." "..
								" Ein Stall wird ben�tigt um in der Kasserne Streitaxtk�mpfer-Hauptm�nner"..
								" ausbilden zu k�nnen."..
								" @cr "..Gelb.." ben�tig: "..Weiss.." Taktiken"))
			end
		elseif a == UpgradeCategories.Beautification04 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification04 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kameraden @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Wehrpflicht "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 5)"))
			end
		elseif a == UpgradeCategories.Beautification06 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification06 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Astrolabium @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Bildung "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 5)"))
			end
		elseif a == UpgradeCategories.Beautification09 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification09 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Blumen @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Konstruktion "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 5)"))
			end
		elseif a == UpgradeCategories.Beautification02 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification02 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Brunnen @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Handelswesen "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 4)"))
			end
		elseif a == UpgradeCategories.Beautification12 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification12 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Windrad @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Zahnr�der "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 4)"))
			end
		elseif a == UpgradeCategories.Beautification05 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification05 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Obelisk @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Taktiken "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 2)"))
			end
		elseif a == UpgradeCategories.Beautification07 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification07 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Mechanische Uhr @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Buchdruck "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 2)"))
			end
		elseif a == UpgradeCategories.Beautification03 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification03 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Reiterstatue @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Pferdezucht "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 1)"))
			end
		elseif a == UpgradeCategories.Beautification10 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification10 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Teleskop @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." B�chereien "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 1)"))
			end
		elseif a == UpgradeCategories.Beautification11 then
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
			if Logic.GetTechnologyState( 1, Technologies.B_Beautification11 )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kapelle Uhr @cr "..Weiss.." "..
								" "..Gelb.." ben�tig: "..Weiss.." Architektur "..Gelb.." @cr erm�glicht:"..
								" "..Weiss.." +1 Ehre @cr (maximal 1)"))
			end
		else
			GUITooltip_ConstructBuilding_OrigSH(a,b,c,d,e,f)
		end
	end
	
	GUITooltip_UpgradeBuilding_OrigSH = GUITooltip_UpgradeBuilding
	GUITooltip_UpgradeBuilding = function( a,b,c,d )
		local Not = Grau.." Nicht verf�gbar @cr "..Weiss.." Dieses Geb�ude kann nicht ausgebaut werden."
		if a == Entities.PB_Residence1 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP1_Residence )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Mittleres Wohnhaus @cr "..Weiss..""..
								" Baut das kleine Wohnhaus aus, um mehr Siedlern Unterschlupf zu geben. @cr "..
								""..Gelb.." ben�tigt: "..Weiss.." Konstruktion @cr "..Gelb.." erm�glicht: "..
								" "..Weiss.." +3 Bev�lkerung"))
			end
		elseif a == Entities.PB_Residence2 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP2_Residence )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Mittleres Wohnhaus @cr "..Weiss..""..
								" Baut das mittlere Wohnhaus aus, um mehr Siedlern Unterschlupf zu geben. @cr "..
								""..Gelb.." ben�tigt: "..Weiss.." Architektur @cr "..Gelb.." erm�glicht: "..
								" "..Weiss.." +3 Bev�lkerung"))
			end
		elseif a == Entities.PB_Barracks1 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP1_Barracks )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Garnision @cr "..Weiss..""..
								" Baut eure Kaserne aus um bessere Truppen anheuern zu k�nnen. @cr "..
								""..Gelb.." ben�tigt: "..Weiss.." Zahnr�der @cr "..Gelb.." erm�glicht: "..
								" "..Weiss.." Bessere Millit�reinheiten"))
			end
		elseif a == Entities.PB_Archery1 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP1_Archery )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Schie�anlage @cr "..Weiss.." "..
								" Wird der Schie�platz ausgebaut, k�nnen bessere Belagerungswaffen gebaut werden."..
								" @cr "..Gelb.." ben�tigt: "..Weiss.." Zahnr�der @cr "..Gelb.." erm�glicht: "..
								" "..Weiss.." Meistersch�tze, Besseres Fahrgestell"))
			end
		elseif a == Entities.PB_Stable1 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP1_Stables )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Reitanlage @cr "..Weiss..""..
								""..Gelb.." ben�tigt: "..Weiss.." Pferdezucht @cr "..Gelb.." erm�glicht: "..
								" "..Weiss.." Hufbeschl�ge, Reduziert Sold von Kavallerie"))
			end
		elseif a == Entities.PB_Headquarters1 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP1_Headquarter )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Festung @cr "..Weiss..""..
								" Wundervoll, Ihr k�nnt nun Eure Burg zur Festung ausbauen. @cr "..
								" "..Gelb.." erm�glicht: "..Weiss.." neue Technologien, Bev�lkerungsgenze x 2,"..
								" Burgk�che, Burgfr�uleingemach"))
			end
		elseif a == Entities.PB_Headquarters2 then
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
			if Logic.GetTechnologyState( 1, Technologies.UP2_Headquarter )== 0 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Not))
			elseif Logic.GetTechnologyState( 1, Technologies.UP2_Headquarter )~= 0
			and XGUIEng.IsButtonDisabled( "Upgrade_Headquarter2" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Zitadelle @cr "..Weiss..""..
								""..Gelb.." ben�tigt: "..Weiss.." 3 verschiedene Veredeler @cr "..Gelb.." "..
								" erm�glicht: "..Weiss.." modernste Technologien, Bev�lkerungsgenze x 3"))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Zitadelle @cr "..Weiss..""..
								" Eure Festung kann nun zur Zitadelle ausgebaut werden. @cr "..Gelb.." "..
								" erm�glicht: "..Weiss.." modernste Technologien, Bev�lkerungsgenze x 3,"..
								" Stadtreinigung"))
			end
		else
			GUITooltip_UpgradeBuilding_OrigSH( a,b,c,d )
		end
	end
	
	GUITooltip_BuyMilitaryUnit_OrigSH = GUITooltip_BuyMilitaryUnit
	GUITooltip_BuyMilitaryUnit = function( a,b,c,d,e )
		local Not = ""..Weiss.." Diese Einheit ist zur Zeit nicht verf�gbar."
		local sel = GUI.GetSelectedEntity()
		if a == UpgradeCategories.LeaderSword then
			if not(Stronghold.Spear[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Langspeertr�ger @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Buy_LeaderSword" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Langspeertr�ger @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Ritter"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Buy_LeaderSword" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Langspeertr�ger @cr "..
									" "..Weiss.." Das Gesindel des Landes zum Krieg zusammengekehrt wartet auf"..
									" Euren Befehl, Sire. Sie taugen eigentlich nur als Kanonenfutter."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(80).." @cr Holz: "..GibTTHolz(40)) .." @cr "..
								" Sold: "..Stronghold.Spear[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(200).." @cr Holz: "..GibTTHolz(120)).." @cr "..
								" Sold: "..Stronghold.Spear[1])
				end
			end
		elseif a == UpgradeCategories.LeaderPoleArm then
			if not(Stronghold.Bow[2]) then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Langbogensch�tze @cr "..Not))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				if XGUIEng.IsButtonDisabled( "Buy_LeaderSpear" )== 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Langbogensch�tze @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Edler Ritter"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif XGUIEng.IsButtonDisabled( "Buy_LeaderSpear" )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Langbogensch�tze @cr "..
									" "..Weiss.." Bogensch�tzen sind vorallem gegen schlecht gepanzerte Milizen"..
									" und Langspeertr�ger effektiv. Sind mit Armbrustsch�tzen aber nicht zu"..
									" vergleichen."))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
				if Logic.IsAutoFillActive( sel )== 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
									" Taler: "..GibTTGold(120).." @cr Holz: "..GibTTHolz(60).." @cr "..
									" Ehre: "..GibTTEhre(6)).." @cr Sold: "..Stronghold.Bow[1])
				else
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(280).." @cr Holz: "..GibTTHolz(220).." @cr "..
									" Ehre: "..GibTTEhre(6)).." @cr Sold: "..Stronghold.Bow[1])
				end
			end
		elseif a == UpgradeCategories.Scout then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kundschafter @cr "..
							" "..Weiss.." Kundschafter erkunden die Umgebung und finden Rohstoffe."))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
							" Taler: "..GibTTGold(100).." @cr "..
							" Holz: "..GibTTEisen(50).." @cr "..
							" Pl�tze: 1"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [A]")
		elseif a == UpgradeCategories.Thief then
			if XGUIEng.IsButtonDisabled( "Buy_Thief" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Dieb @cr "..
								" "..Gelb.." ben�tigt: "..Weiss.." Wirtshaus"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(300).." @cr "..
								" Holz: "..GibTTEisen(30).." @cr "..
								" Ehre: "..GibTTEhre(30).." @cr "..
								" Pl�tze: 5"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kundschafter @cr "..
								" "..Weiss.." Kundschafter erkunden die Umgebung und finden Rohstoffe."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute(""..
								" Taler: "..GibTTGold(300).." @cr "..
								" Holz: "..GibTTEisen(30).." @cr "..
								" Ehre: "..GibTTEhre(30).." @cr "..
								" Pl�tze: 5"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [A]")
			end
		elseif a == UpgradeCategories.LeaderBow then
			if XGUIEng.IsButtonDisabled( "Buy_LeaderBow" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bombarde @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Baron, Metallurgie"))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bombarde @cr "..
									" "..Weiss.." Die kleinste Kanone. Sie wird gegen Soldaten verwendet, ist"..
									" aber nicht nennenswert effektiv. @cr "..Gelb.." stark gegen Einheiten"))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Taler: "..GibTTGold(150).." @cr "..
							" Eisen: "..GibTTEisen(50).." @cr Schwefel: "..GibTTSchwefel(100).." @cr "..
							" Ehre: "..GibTTEhre(10)).." @cr Sold: "..Stronghold.Cannons[1])
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif a == UpgradeCategories.LeaderRifle then
			if XGUIEng.IsButtonDisabled( "Buy_LeaderRifle" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bronzekanone @cr "..
									" "..Gelb.." ben�tigt: "..Weiss.." Titel: Baron, Metallurgie"))
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bronzekanone @cr "..
									" "..Weiss.." Die h�figste Kanone des sp�ten Mittelalter. Sie wird gegen"..
									" Bef�stigungen eingesetzt. @cr "..Gelb.." stark gegen Geb�ude"))
			end
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, Umlaute("Taler: "..GibTTGold(200).." @cr "..
							" Eisen: "..GibTTEisen(50).." @cr Schwefel: "..GibTTSchwefel(120).." @cr "..
							" Ehre: "..GibTTEhre(15)).." @cr Sold: "..Stronghold.Cannons[2])
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		else
			GUITooltip_BuyMilitaryUnit_OrigSH( a,b,c,d,e )
		end
	end
	
	GUITooltip_BlessSettlers_OrigSH = GUITooltip_BlessSettlers
	GUITooltip_BlessSettlers = function( a,b,c,d )
		if b == "AOMenuMonastery/BlessSettlers1_normal" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Leutet die Glocke @cr "..
			""..Gelb.." erm�glicht: "..Weiss.." +6 zur aktuellen Beliebtheit"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif b == "AOMenuMonastery/BlessSettlers2_normal" then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Ablassbriefe @cr "..
			""..Gelb.." erm�glicht: "..Weiss.." +6 zur aktuellen Ehre"))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		elseif b == "AOMenuMonastery/BlessSettlers3_normal" then
			if XGUIEng.IsButtonDisabled( "BlessSettlers3" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bibeln @cr "..
				""..Gelb.." ben�tigt: "..Weiss.." Kirche @cr "..Gelb.." erm�glicht: "..Weiss..""..
				" +12 zur aktuellen Beliebtheit"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Bibeln @cr "..
				""..Gelb.." erm�glicht: "..Weiss.." +12 zur aktuellen Beliebtheit"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		elseif b == "AOMenuMonastery/BlessSettlers4_normal" then
			if XGUIEng.IsButtonDisabled( "BlessSettlers4" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kollekte @cr "..
				""..Gelb.." ben�tigt: "..Weiss.." Kirche @cr "..Gelb.." erm�glicht: "..Weiss..""..
				" +12 zur aktuellen Ehre"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Kollekte @cr "..
				""..Gelb.." erm�glicht: "..Weiss.." +12 zur aktuellen Ehre"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		elseif b == "AOMenuMonastery/BlessSettlers5_normal" then
			if XGUIEng.IsButtonDisabled( "BlessSettlers5" )== 1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Heiligsprechung @cr "..
				""..Gelb.." ben�tigt: "..Weiss.." Kathedrale @cr "..Gelb.." erm�glicht: "..Weiss..""..
				" +8 zur aktuellen Beliebtheit @cr +8 zur aktuellen Ehre"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			else
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Heiligsprechung @cr "..
				""..Gelb.." erm�glicht: "..Weiss.." +8 zur aktuellen Beliebtheit @cr +8 zur aktuellen Ehre"))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
			end
		end
	end
	
	GUITooltip_BuySoldier_OrigSH = GUITooltip_BuySoldier
	GUITooltip_BuySoldier = function( a,b,c )
		local sel = Logic.GetEntityType(GUI.GetSelectedEntity())
		if XGUIEng.IsButtonDisabled( "Buy_Soldier_Button" )== 1 then
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
			""..Weiss.." Ihr m�sst diesen Hauptmann zuerst zur n�chsten Kaserne bewegen, Sire."))
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "")
			XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
		else
			if sel == Entities.PU_LeaderPoleArm1 or sel == Entities.PU_LeaderPoleArm2
			or sel == Entities.CU_Evil_LeaderSkirmisher1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(30).." @cr "..
								" Holz: "..GibTTHolz(20))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderBow1 or sel == Entities.PU_LeaderBow2
			or sel == Entities.CU_BanditLeaderBow1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(40).." @cr "..
								" Holz: "..GibTTHolz(40))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderPoleArm3 or sel == Entities.PU_LeaderPoleArm4
			or sel == Entities.PU_LeaderCavalry1 or sel == Entities.PU_LeaderCavalry2 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(50).." @cr "..
								" Holz: "..GibTTHolz(40))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderBow3 or sel == Entities.PU_LeaderBow4 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(50).." @cr "..
								" Eisen: "..GibTTEisen(50))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderSword1 or sel == Entities.PU_LeaderSword2
			or sel == Entities.CU_BanditLeaderSword2 or sel == Entities.CU_BanditLeaderSword1
			or sel == Entities.CU_BlackKnight_LeaderMace1 or sel == Entities.CU_BlackKnight_LeaderMace2
			or sel == Entities.CU_Barbarian_LeaderClub1 or sel == Entities.CU_Barbarian_LeaderClub2
			or sel == Entities.CU_Evil_LeaderBearman1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(40).." @cr "..
								" Eisen: "..GibTTEisen(30))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderSword3 or sel == Entities.PU_LeaderSword4 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(60).." @cr "..
								" Eisen: "..GibTTEisen(50))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderRifle1 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(50).." @cr "..
								" Schwefel: "..GibTTSchwefel(40))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderHeavyCavalry1 or sel == Entities.PU_LeaderHeavyCavalry2 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(50).." @cr "..
								" Eisen: "..GibTTEisen(50))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			elseif sel == Entities.PU_LeaderRifle2 then
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Soldat rekrutieren @cr "..
								""..Weiss.." Rekrutiert einen Soldaten f�r diesen Hauptmann."))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Taler: "..GibTTGold(80).." @cr "..
								" Schwefel: "..GibTTSchwefel(80))
				XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "Taste: [Q]")
			end
		end
	end
	GUITooltip_NormalButton_OrigHS = GUITooltip_NormalButton
	GUITooltip_NormalButton = function( a,b )
		if IsEntitySelected(Stronghold.Hero)and IsAloneInSelection()then
			if a == "MenuCommandsGeneric/Formation_fight" then
				if Stronghold.Rank == 0 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Ritter @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines Ritters. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." 1 Technologie der 1 Stufe"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(10))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 1 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Edler Ritter @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines Edlen Ritters. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." 50 Arbeiter"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(25))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 2 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Reichsritter @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines Reichsritters. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." Festung"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(50))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 3 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Streiter des K�nigs @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang Streiter des K�nigs. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." 1 Technologie der 2 Stufe"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(100))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 4 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." F�rst @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines F�rsten. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." Grobschmiede"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(150))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 5 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Baron @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines Baron. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." 1 Technologie der 3 Stufe"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(200))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 6 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Graf @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines Grafen. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." Zitadelle"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(250))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				elseif Stronghold.Rank == 7 then
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomText, Umlaute(Grau.." Herzog @cr "..
										""..Weiss.." Erhebt Euren Burgherrn in den Rang eines Herzog. @cr "..
										""..Gelb.." ben�tigt: "..Weiss.." 1 Technologie der 4 Stufe"))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomCosts, "Ehre: "..GibTTEhre(300))
					XGUIEng.SetText( gvGUI_WidgetID.TooltipBottomShortCut, "")
				end
			else
				GUITooltip_NormalButton_OrigHS( a,b )
			end
		else
			GUITooltip_NormalButton_OrigHS( a,b )
		end
	end

-- # # # # # # # # # # UPDATE # # # # # # # # # # --
	
	function GUIUpdate_AverageMotivation()
		XGUIEng.ShowWidget( "IconMotivation", 0 )
		XGUIEng.SetText( "AverageMotivation", "Rang")
	end
		
	function GUIUpdate_TaxPaydayIncome()
		if Stronghold.Income - Stronghold.Sold < 0 then
			XGUIEng.SetText( "SumOfPayday", Rot.." "..Stronghold.Income-Stronghold.Sold)
			XGUIEng.SetText( "TaxSumOfPayday", Rot.." "..Stronghold.Income-Stronghold.Sold)
		else
			XGUIEng.SetText( "SumOfPayday", Gruen.." +"..Stronghold.Income-Stronghold.Sold)
			XGUIEng.SetText( "TaxSumOfPayday", Gruen.." "..Stronghold.Income-Stronghold.Sold)
		end
	end
	function GUIUpdate_TaxSumOfTaxes()
		XGUIEng.SetText( "TaxWorkerSumOfTaxes", Stronghold.Income)
	end
	function GUIUpdate_TaxLeaderCosts()
		XGUIEng.SetText( "TaxLeaderSumOfPay", Rot.." "..Stronghold.Sold)
	end
	GUIUpdate_TaxesButtons = function()
		XGUIEng.HighLightButton( "SetVeryLowTaxes", 0 )
		XGUIEng.HighLightButton( "SetLowTaxes", 0 )
		XGUIEng.HighLightButton( "SetNormalTaxes", 0 )
		XGUIEng.HighLightButton( "SetHighTaxes", 0 )
		XGUIEng.HighLightButton( "SetVeryHighTaxes", 0 )
		
		if Stronghold.TaxHight == 0 then
			XGUIEng.HighLightButton( "SetVeryLowTaxes", 1 )
		elseif Stronghold.TaxHight == 1 then
			XGUIEng.HighLightButton( "SetLowTaxes", 1 )
		elseif Stronghold.TaxHight == 2 then
			XGUIEng.HighLightButton( "SetNormalTaxes", 1 )
		elseif Stronghold.TaxHight == 3 then
			XGUIEng.HighLightButton( "SetHighTaxes", 1 )
		elseif Stronghold.TaxHight == 4 then
			XGUIEng.HighLightButton( "SetVeryHighTaxes", 1 )
		end
	end

	GUIUpdate_SettlersUpgradeButtons_OrigSH = GUIUpdate_SettlersUpgradeButtons
	GUIUpdate_SettlersUpgradeButtons = function( _button, _tech )
		if _button == "Research_UpgradeSword1" then
			XGUIEng.ShowWidget( "Research_UpgradeSword1", 1 )
		elseif _button == "Research_UpgradeSword2" then
			XGUIEng.ShowWidget( "Research_UpgradeSword2", 1 )
		elseif _button == "Research_UpgradeSword3" then
			XGUIEng.ShowWidget( "Research_UpgradeSword3", 1 )
		elseif _button == "Research_UpgradeSpear1" then
			XGUIEng.ShowWidget( "Research_UpgradeSpear1", 1 )
		elseif _button == "Research_UpgradeSpear2" then
			XGUIEng.ShowWidget( "Research_UpgradeSpear2", 1 )
		elseif _button == "Research_UpgradeSpear3" then
			XGUIEng.ShowWidget( "Research_UpgradeSpear3", 1 )
		elseif _button == "Research_UpgradeBow1" then
			XGUIEng.ShowWidget( "Research_UpgradeBow1", 1 )
		elseif _button == "Research_UpgradeBow2" then
			XGUIEng.ShowWidget( "Research_UpgradeBow2", 1 )
		elseif _button == "Research_UpgradeBow3" then
			XGUIEng.ShowWidget( "Research_UpgradeBow3", 0 )
		elseif _button == "Research_UpgradeRifle1" then
			XGUIEng.ShowWidget( "Research_UpgradeRifle1", 1 )
			if Logic.GetEntityType(GUI.GetSelectedEntity()) == Entities.PB_Archery2 then
				XGUIEng.DisableButton( "Research_UpgradeRifle1", 0 )
				if Logic.IsTechnologyResearched( 1, Technologies.T_BetterChassis )== 1 then
					XGUIEng.HighLightButton( "Research_UpgradeRifle1", 1 )
				else
					XGUIEng.HighLightButton( "Research_UpgradeRifle1", 0 )
				end
			else
				XGUIEng.DisableButton( "Research_UpgradeRifle1", 1 )	
			end
		elseif _button == "Research_UpgradeCavalryLight1" then
			XGUIEng.ShowWidget( "Research_UpgradeCavalryLight1", 0 )
		elseif _button == "Research_UpgradeCavalryHeavy1" then
			XGUIEng.ShowWidget( "Research_UpgradeCavalryHeavy1", 1 )
		else
			GUIUpdate_SettlersUpgradeButtons( _button, _tech )
		end
	end
	
	GUIUpdate_BuySoldierButton = function()
		local sel = GUI.GetSelectedEntity()
		local pos = GetPosition(sel)
		local barracks1 = {Logic.GetPlayerEntitiesInArea( 1, Entities.PB_Barracks1, pos.X, pos.Y, 3000, 1 )}
		local barracks2 = {Logic.GetPlayerEntitiesInArea( 1, Entities.PB_Barracks2, pos.X, pos.Y, 3000, 1 )}
		if Logic.IsLeader(sel)== 1 then
			if IsAloneInSelection() then
				XGUIEng.ShowWidget( "Buy_Soldier_Button", 1 )
				if barracks1[1]> 0 then
					if Logic.IsConstructionComplete(barracks1[2])== 1 then
						XGUIEng.DisableButton( "Buy_Soldier_Button", 0 )
					else
						XGUIEng.DisableButton( "Buy_Soldier_Button", 1 )
					end
				elseif barracks2[1]> 0 then
					if Logic.IsConstructionComplete(barracks2[2])== 1 then
						XGUIEng.DisableButton( "Buy_Soldier_Button", 0 )
					else
						XGUIEng.DisableButton( "Buy_Soldier_Button", 1 )
					end
				else
					XGUIEng.DisableButton( "Buy_Soldier_Button", 1 )
				end
			else
				XGUIEng.ShowWidget( "Buy_Soldier_Button", 0 )
			end
		end
	end

	GUIUpdate_FindView = function()
		XGUIEng.ShowWidget( "FindView", 1 );
		XGUIEng.ShowWidget( "FindSpearmen", 1 );XGUIEng.ShowWidget( "FindSwordmen", 1 );
		XGUIEng.ShowWidget( "FindBowmen", 1 );XGUIEng.ShowWidget( "FindCannon", 1 );
		XGUIEng.ShowWidget( "FindLightCavalry", 1 );XGUIEng.ShowWidget( "FindHeavyCavalry", 1 );
		XGUIEng.ShowWidget( "FindRiflemen", 1 );XGUIEng.ShowWidget( "FindScout", 1 );
		XGUIEng.ShowWidget( "FindThief", 1 );XGUIEng.ShowWidget( "Find_IdleSerf", 1 );
		UpdateValues(); EhreMenu(); SerfMenu() BuildingMenu(); BurgMenu(); LeaderMenu()
	end
	
	GUIUpdate_SelectionName_OrigSH = GUIUpdate_SelectionName
	GUIUpdate_SelectionName = function()
		GUIUpdate_SelectionName_OrigSH()
		if IsEntitySelected(Stronghold.DamselName)then
			XGUIEng.SetText("Selection_Name", Umlaute("Burgfr�ulein"))
		elseif IsEntitySelected(Stronghold.Hero)then
			XGUIEng.SetText("Selection_Name", Umlaute(Stronghold.RankName[Stronghold.Rank+1]))
		end
	end
end

function UpdateValues()
	local spear = Stronghold.Spear[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderPoleArm1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderPoleArm2 ))
	local bow = Stronghold.Bow[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderBow2 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderBow1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderSword2 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderSword1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_BanditLeaderSword2 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_BanditLeaderSword1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_BlackKnight_LeaderMace1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_BlackKnight_LeaderMace2 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_Barbarian_LeaderClub1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_Barbarian_LeaderClub2 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_Evil_LeaderBearman1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_BanditLeaderBow1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.CU_Evil_LeaderSkirmisher1 ))
	local lance = Stronghold.Lance[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderPoleArm3 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderPoleArm4 ))
	local crossbow = Stronghold.Crossbow[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderBow3 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderBow4 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderRifle1 ))
	local sword = Stronghold.Sword[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderSword4 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderSword3 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderHeavyCavalry1 ))
	local knightsold = 0; if NumberOfCompleteBuildings( Entities.PB_Stable2 ) > 0 then knightsold = 50 else knightsold = 0 end
	local cav = ((Stronghold.Knight[1]-knightsold)*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderHeavyCavalry1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderHeavyCavalry2 )))+((Stronghold.Crossbow[1]-knightsold)*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderCavalry1 )+Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderCavalry2 )))
	local rifle1 = Stronghold.Rifle1[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderRifle1 ))
	local rifle2 = Stronghold.Rifle2[1]*(Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_LeaderRifle2 ))
	local cannons = (Stronghold.Cannons[1]*Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PV_Cannon1 ))+(Stronghold.Cannons[2]*Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PV_Cannon2 ))+(Stronghold.Cannons[3]*Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PV_Cannon3 ))+(Stronghold.Cannons[4]*Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PV_Cannon4 ))
	local beauty = NumberOfCompleteBuildings( Entities.PB_Beautification04 )+NumberOfCompleteBuildings( Entities.PB_Beautification06 )+NumberOfCompleteBuildings( Entities.PB_Beautification09 )+NumberOfCompleteBuildings( Entities.PB_Beautification02 )+NumberOfCompleteBuildings( Entities.PB_Beautification12 )+NumberOfCompleteBuildings( Entities.PB_Beautification05 )+NumberOfCompleteBuildings( Entities.PB_Beautification07 )+NumberOfCompleteBuildings( Entities.PB_Beautification03 )+NumberOfCompleteBuildings( Entities.PB_Beautification10 )+NumberOfCompleteBuildings( Entities.PB_Beautification11 )
	Stronghold.Income = (Logic.GetNumberOfAttractedWorker( 1 )*5)*Stronghold.TaxHight
	Stronghold.Sold = spear+bow+lance+crossbow+sword+cav+rifle1+rifle2+cannons
	
	-- Beliebtheit und Ehre
	local dEhre, dRepu = 0, 0
	if IsExisting(Stronghold.DamselName)then
		if Logic.GetEntityHealth( GetEntityId(Stronghold.DamselName) )>0 then
			dEhre = 6; dRepu = 6
		else
			dEhre = 0; dRepu = 0
		end
	end
	if Stronghold.TaxHight > 0 then
		Stronghold.MotiPlus = (2*Stronghold.FoodKinds)+(3*Stronghold.LawAndOrder[1])+(6*Stronghold.TidyUp[1])+dRepu
	elseif Stronghold.TaxHight == 0 then
		Stronghold.MotiPlus = (2*Stronghold.FoodKinds)+(3*Stronghold.LawAndOrder[1])+(6*Stronghold.TidyUp[1])+dRepu+8
	end
	if Logic.GetNumberOfAttractedWorker( 1 ) > 0 and Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Farmer ) > 0 then
		Stronghold.MotiMinus = (-3*Stronghold.TaxHight)-Logic.GetNumberOfWorkerWithoutEatPlace(1)-(6*Stronghold.Kitchen[1])-(4*Stronghold.Treasury[1])
	elseif Logic.GetNumberOfAttractedWorker( 1 ) > 0 and Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Farmer ) == 0 then
		Stronghold.MotiMinus = (-3*Stronghold.TaxHight)-(6*Stronghold.Kitchen[1])-(4*Stronghold.Treasury[1])-Logic.GetNumberOfWorkerWithoutEatPlace(1)
	end
	if Logic.GetNumberOfAttractedWorker( 1 ) > 0 and Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Farmer ) > 0 and Stronghold.TaxHight > 0 then
		Stronghold.EhrePlus = ((2*Stronghold.FoodKinds)+(25*Stronghold.Cloisters)+(12*Stronghold.Kitchen[1])+(5*Stronghold.LawAndOrder[1])+(9*Stronghold.Treasury[1])+dEhre+(6*Stronghold.TidyUp[1]))+beauty
	elseif Logic.GetNumberOfAttractedWorker( 1 ) > 0 and Logic.GetNumberOfEntitiesOfTypeOfPlayer( 1, Entities.PU_Farmer ) > 0 and Stronghold.TaxHight == 0 then
		Stronghold.EhrePlus = ((2*Stronghold.FoodKinds)+(25*Stronghold.Cloisters)+(12*Stronghold.Kitchen[1])+(5*Stronghold.LawAndOrder[1])+(9*Stronghold.Treasury[1])+dEhre+(6*Stronghold.TidyUp[1]))+beauty+10
	end
	
	-- Bev�lkerung
	local Etype = Logic.GetEntityType( GetEntityId(Stronghold.HQ) )
	if Etype == Entities.PB_Headquarters1 then
		Stronghold.Serfs = 18
		Stronghold.AttractionLimit = 60
	elseif Etype == Entities.PB_Headquarters2 then
		Stronghold.Serfs = 32
		Stronghold.AttractionLimit = 120
	elseif Etype == Entities.PB_Headquarters3 then
		Stronghold.Serfs = 48
		Stronghold.AttractionLimit = 180
	end
	local small	= NumberOfCompleteBuildings( Entities.PB_Residence1 )
	local middle = NumberOfCompleteBuildings( Entities.PB_Residence2 )
	local large	= NumberOfCompleteBuildings( Entities.PB_Residence3 )
	Stronghold.AttractionMax = (6*small)+(9*middle)+(12*large)
		if Stronghold.AttractionMax > round(Stronghold.AttractionLimit*Stronghold.AttractionMulti) then
			Stronghold.AttractionMax = round(Stronghold.AttractionLimit*Stronghold.AttractionMulti)
		end
end

function CreateWorker()
	local buildings = SucheAufDerWelt(1, 0)
	local create = true
	local leave = true
	for i=1,table.getn(buildings) do
		if create then
			if Stronghold.Motivation > 49 then
				if Logic.IsBuilding(buildings[i])== 1 and Logic.IsConstructionComplete(buildings[i])== 1 then
					if Logic.GetBuildingWorkPlaceUsage(buildings[i]) < Logic.GetBuildingWorkPlaceLimit(buildings[i])then
						if Logic.GetPlayerAttractionUsage(1) < Logic.GetPlayerAttractionLimit(1) then
							local workertype = Logic.GetWorkerTypeByBuilding(buildings[i])
							CreateEntity(1,workertype,GetPosition("doorpos"))
							create = false
						end
					end
				end
			end
		end
		if leave then
			if Stronghold.Motivation < 50 then
				if Logic.GetNumberOfAttractedWorker(1)>0 then
					if Logic.IsWorker(buildings[i])== 1 then
						if Counter.Tick2("CreateWorker",5) then
							Logic.SetTaskList( buildings[i], TaskLists.TL_WORKER_LEAVE )
							leave = false
						end
					end
				end
			end
		end
	end
end

function SerfMenu()
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification04", 4, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification06", 38, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification09", 72, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification02", 106, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification12", 139, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification05", 172, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification07", 206, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification03", 240, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification10", 274, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Build_Beautification11", 307, 4, 31, 31 )
	XGUIEng.ShowWidget( "Build_Beautification08", 0 )
	XGUIEng.ShowWidget( "Build_Beautification01", 0 )
	XGUIEng.ShowWidget( "Build_Village", 0 )
	XGUIEng.ShowWidget( "Build_Foundry", 0 )
	
	BuildingsLimit( Technologies.GT_Tactics, Technologies.B_Stables, {Entities.PB_Stable1,Entities.PB_Stable2}, "Build_Stables", 1, 1 )
	BuildingsLimit( Technologies.GT_Mercenaries, Technologies.B_Beautification04, {Entities.PB_Beautification04}, "Build_Beautification04", 1, 5 )
	BuildingsLimit( Technologies.GT_Literacy, Technologies.B_Beautification06, {Entities.PB_Beautification06}, "Build_Beautification06", 1, 5 )
	BuildingsLimit( Technologies.GT_Construction, Technologies.B_Beautification09, {Entities.PB_Beautification09}, "Build_Beautification09", 1, 5 )
	BuildingsLimit( Technologies.GT_Trading, Technologies.B_Beautification02, {Entities.PB_Beautification02}, "Build_Beautification02", 1, 4 )
	BuildingsLimit( Technologies.GT_GearWheel, Technologies.B_Beautification12, {Entities.PB_Beautification12}, "Build_Beautification12", 1, 4 )
	BuildingsLimit( Technologies.GT_Tactics, Technologies.B_Beautification05, {Entities.PB_Beautification05}, "Build_Beautification05", 1, 2 )
	BuildingsLimit( Technologies.GT_Printing, Technologies.B_Beautification07, {Entities.PB_Beautification07}, "Build_Beautification07", 1, 2 )
	BuildingsLimit( Technologies.GT_Strategies, Technologies.B_Beautification03, {Entities.PB_Beautification03}, "Build_Beautification03", 1, 1 )
	BuildingsLimit( Technologies.GT_Library, Technologies.B_Beautification10, {Entities.PB_Beautification10}, "Build_Beautification10", 1, 1 )
	BuildingsLimit( Technologies.GT_Architecture, Technologies.B_Beautification11, {Entities.PB_Beautification11}, "Build_Beautification11", 1, 1 )
end

function LeaderMenu()
	local sel = GUI.GetSelectedEntity()
	local sel2 = Logic.GetEntityType(GUI.GetSelectedEntity())
	if sel2 == Entities.PU_BattleSerf or sel2 == CU_VeteranCaptainthen then
		XGUIEng.ShowWidget( "Commands_Leader", 0 ); XGUIEng.ShowWidget( "Selection_Leader", 0 )
	elseif IsEntitySelected(Stronghold.Hero)and IsAloneInSelection() then
		XGUIEng.ShowWidget( "Commands_Leader", 1 ); XGUIEng.ShowWidget( "Selection_Leader", 1 )
		if Stronghold.Rank == 8 or Stronghold.Rank >= Stronghold.LockRank then
			XGUIEng.ShowWidget( "Formation01", 0 ); XGUIEng.ShowWidget( "Formation02", 0 )
			XGUIEng.ShowWidget( "Formation03", 0 ); XGUIEng.ShowWidget( "Formation04", 0 )
		else
			XGUIEng.ShowWidget( "Formation01", 0 ); XGUIEng.ShowWidget( "Formation02", 0 )
			XGUIEng.ShowWidget( "Formation03", 0 ); XGUIEng.ShowWidget( "Formation04", 1 )
			XGUIEng.TransferMaterials( "Upgrade_Foundry1", "Formation04" )
			XGUIEng.DisableButton( "Formation04", 0 )
		end
	else
		if Logic.IsEntityInCategory( sel, EntityCategories.Bow )== 1 
		or Logic.IsEntityInCategory( sel, EntityCategories.Sword )== 1
		or Logic.IsEntityInCategory( sel, EntityCategories.Spear )== 1
		or Logic.IsEntityInCategory( sel, EntityCategories.CavalryHeavy )== 1
		or Logic.IsEntityInCategory( sel, EntityCategories.CavalryLight )== 1
		or Logic.IsEntityInCategory( sel, EntityCategories.Rifle )== 1
		or Logic.IsEntityInCategory( sel, EntityCategories.EvilLeader )== 1
		or sel2 == Entities.CU_BanditLeaderSword1 or sel2 == Entities.CU_BanditLeaderSword2 then
			XGUIEng.ShowWidget( "Commands_Leader", 1 )
			XGUIEng.ShowWidget( "Selection_Leader", 1 )
			XGUIEng.ShowWidget( "Formation01", 1 ); XGUIEng.ShowWidget( "Formation02", 1 )
			XGUIEng.ShowWidget( "Formation03", 1 ); XGUIEng.ShowWidget( "Formation04", 1 )
			XGUIEng.TransferMaterials( "Research_Coinage", "Formation04" )
			if Logic.IsTechnologyResearched( 1, Technologies.GT_StandingArmy )== 0 then
				XGUIEng.DisableButton( "Formation01", 1 ); XGUIEng.DisableButton( "Formation02", 1 )
				XGUIEng.DisableButton( "Formation03", 1 ); XGUIEng.DisableButton( "Formation04", 1 )
			elseif Logic.IsTechnologyResearched( 1, Technologies.GT_StandingArmy )== 1 then
				XGUIEng.DisableButton( "Formation01", 0 ); XGUIEng.DisableButton( "Formation02", 0 )
				XGUIEng.DisableButton( "Formation03", 0 ); XGUIEng.DisableButton( "Formation04", 0 )
			end
		else
			XGUIEng.ShowWidget( "Commands_Leader", 0 ); XGUIEng.ShowWidget( "Selection_Leader", 0 )
		end
	end
end

function BuildingMenu()
	local sel = Logic.GetEntityType(GUI.GetSelectedEntity())
	if sel == Entities.PB_Barracks1 or sel == Entities.PB_Barracks2 then
		XGUIEng.DisableButton( "Buy_LeaderSword", 0 )
		XGUIEng.DisableButton( "Buy_LeaderSpear", 0 )
		XGUIEng.SetWidgetPositionAndSize( "Buy_LeaderSword", 4, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Buy_LeaderSpear", 38, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeSword1", 72, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeSword2", 106, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeSword3", 140, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeSpear1", 174, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeSpear2", 208, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeSpear3", 242, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_BetterTrainingBarracks", 4, 38, 31, 31 )
		XGUIEng.TransferMaterials( "Research_BookKeeping", "Buy_LeaderSword" )
		XGUIEng.TransferMaterials( "Research_PickAxe", "Buy_LeaderSpear" )
		XGUIEng.TransferMaterials( "Research_BookKeeping", "Research_UpgradeSword1" )
		XGUIEng.TransferMaterials( "Research_PickAxe", "Research_UpgradeSword2" )
		XGUIEng.TransferMaterials( "Research_Debenture", "Research_UpgradeSword3" )
		XGUIEng.TransferMaterials( "Research_LightBricks", "Research_UpgradeSpear1" )
		XGUIEng.TransferMaterials( "Buy_LeaderCavalryHeavy", "Research_UpgradeSpear2" )
		XGUIEng.TransferMaterials( "Research_LightBricks", "Research_UpgradeSpear3" )
		
		local head2 = NumberOfCompleteBuildings( Entities.PB_Headquarters2 )
		local head3 = NumberOfCompleteBuildings( Entities.PB_Headquarters3 )
		local smith2 = NumberOfCompleteBuildings( Entities.PB_Blacksmith2 )
		local smith3 = NumberOfCompleteBuildings( Entities.PB_Blacksmith3 )
		local gsmith1 = NumberOfCompleteBuildings( Entities.PB_GunsmithWorkshop1 )
		local gsmith2 = NumberOfCompleteBuildings( Entities.PB_GunsmithWorkshop2 )
		local stable1 = NumberOfCompleteBuildings( Entities.PB_Stable1 )
		local stable2 = NumberOfCompleteBuildings( Entities.PB_Stable2 )
		
		
		if Stronghold.Rank >= 1 and Stronghold.Spear[2] then
			XGUIEng.DisableButton( "Buy_LeaderSword", 0 )
		else
			XGUIEng.DisableButton( "Buy_LeaderSword", 1 )
		end
		
		if Stronghold.Rank >= 2 and Stronghold.Bow[2] then
			XGUIEng.DisableButton( "Buy_LeaderSpear", 0 )
		else
			XGUIEng.DisableButton( "Buy_LeaderSpear", 1 )
		end
		
		if Stronghold.Rank >= 3 and Stronghold.Lance[2] then
			XGUIEng.DisableButton( "Research_UpgradeSword1", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeSword1", 1 )
		end
		
		if Stronghold.Rank >= 4 and Stronghold.Crossbow[2] then
			XGUIEng.DisableButton( "Research_UpgradeSword2", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeSword2", 1 )
		end
		
		if sel == Entities.PB_Barracks2 and Stronghold.Rank >= 5 and Stronghold.Sword[2] then
			XGUIEng.DisableButton( "Research_UpgradeSword3", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeSword3", 1 )
		end
		
		if Stronghold.Rank >= 6 and (gsmith1 >= 1 or gsmith2 >= 1) and sel == Entities.PB_Barracks2 and Stronghold.Rifle1[2] then
			XGUIEng.DisableButton( "Research_UpgradeSpear1", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeSpear1", 1 )
		end
		
		if sel == Entities.PB_Barracks2 and Stronghold.Rank >= 7 and (stable1 >= 1 or stable2 >= 1) and smith3 >= 1 and Stronghold.Knight[2] then
			XGUIEng.DisableButton( "Research_UpgradeSpear2", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeSpear2", 1 )
		end
		
		if sel == Entities.PB_Barracks2 and Stronghold.Rank == 8 and gsmith2 >= 1 and Stronghold.Rifle2[2] then
			XGUIEng.DisableButton( "Research_UpgradeSpear3", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeSpear3", 1 )
		end
		
		if Logic.IsConstructionComplete( GUI.GetSelectedEntity() )== 1 then
			XGUIEng.ShowWidget( "ToggleRecruitGroups", 1 )
		else
			XGUIEng.ShowWidget( "ToggleRecruitGroups", 0 )
		end
		
	elseif sel == Entities.PB_Archery1 or sel == Entities.PB_Archery2 then
	
		XGUIEng.ShowWidget( "ToggleRecruitGroups", 0 )
		XGUIEng.ShowWidget( "Research_UpgradeRifle1", 0 )
		XGUIEng.TransferMaterials( "Buy_Cannon1", "Buy_LeaderBow" )
		XGUIEng.TransferMaterials( "Buy_Cannon2", "Buy_LeaderRifle" )
		XGUIEng.TransferMaterials( "Buy_Cannon3", "Research_UpgradeBow1" )
		XGUIEng.TransferMaterials( "Buy_Cannon4", "Research_UpgradeBow2" )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeBow1", 75, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_UpgradeBow2", 109, 4, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "Research_BetterTrainingArchery", 4, 40, 31, 31 )

		if Stronghold.Rank >= 6 and Logic.IsTechnologyResearched( 1, Technologies.GT_Metallurgy )== 1 then
			XGUIEng.DisableButton( "Buy_LeaderBow", 0 ); XGUIEng.DisableButton( "Buy_LeaderRifle", 0 )
		else
			XGUIEng.DisableButton( "Buy_LeaderBow", 1 ); XGUIEng.DisableButton( "Buy_LeaderRifle", 1 )
		end
		
		if Stronghold.Rank >= 8 and Logic.IsTechnologyResearched( 1, Technologies.GT_Chemistry )== 1 
		and sel == Entities.PB_Archery2 then
			XGUIEng.DisableButton( "Research_UpgradeBow1", 0 ); XGUIEng.DisableButton( "Research_UpgradeBow2", 0 )
		else
			XGUIEng.DisableButton( "Research_UpgradeBow1", 1 ); XGUIEng.DisableButton( "Research_UpgradeBow2", 1 )
		end
		
	elseif sel == Entities.PB_Stable1 or sel == Entities.PB_Stable2 then
		
		XGUIEng.ShowWidget( "ToggleRecruitGroups", 0 )
		XGUIEng.ShowWidget( "Buy_LeaderCavalryLight", 0 )
		XGUIEng.ShowWidget( "Research_UpgradeCavalryLight1", 0 )
		XGUIEng.ShowWidget( "Buy_LeaderCavalryHeavy", 0 )
		XGUIEng.ShowWidget( "Research_UpgradeCavalryHeavy1", 0 )
		XGUIEng.SetWidgetPositionAndSize( "Research_Shoeing", 4, 4, 31, 31 )
		
	elseif sel == Entities.PB_Foundry1  or sel == Entities.PB_Foundry2 then
	
		XGUIEng.SetWidgetPositionAndSize( "Research_BetterChassis", 4, 4, 31, 31 )
		XGUIEng.ShowWidget( "Buy_Cannon1", 0 )
		XGUIEng.ShowWidget( "Buy_Cannon2", 0 )
		XGUIEng.ShowWidget( "Buy_Cannon3", 0 )
		XGUIEng.ShowWidget( "Buy_Cannon4", 0 )
		
	end
end

function BurgMenu()
	XGUIEng.ShowWidget( "HQ_Militia", 1 )
	XGUIEng.ShowWidget( "HQ_BackToWork", 1 )
	XGUIEng.ShowWidget( "Buy_Hero", 1 )
	XGUIEng.ShowWidget( "Levy_Duties", 1 )
	XGUIEng.SetWidgetPosition( "HQTaxes", 180, 4 )
	XGUIEng.TransferMaterials( "Research_Scale", "HQ_CallMilitia" )
	XGUIEng.TransferMaterials( "Statistics_SubSettlers_Serfs", "HQ_BackToWork" )
	XGUIEng.TransferMaterials( "Statistics_SubSettlers_Motivation", "Levy_Duties" )
	XGUIEng.TransferMaterials( "Build_Bank", "Buy_Hero" )
	XGUIEng.SetWidgetPosition( "TaxesAndPayStatistics", 140, 34 )
	XGUIEng.SetWidgetPositionAndSize( "Research_Tracking", 40, 4, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "HQ_Militia", 74, 4, 66, 32 )
	XGUIEng.SetWidgetPositionAndSize( "HQ_CallMilitia", 0, 0, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "HQ_BackToWork", 34, 0, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Buy_Hero", 40, 36, 31, 31 )
	XGUIEng.SetWidgetPositionAndSize( "Levy_Duties", 74, 36, 31, 31 )
	function GUIUpdate_BuyHeroButton()end
	
	local Etype = Logic.GetEntityType( GetEntityId(Stronghold.HQ) )
	if Etype == Entities.PB_Headquarters1 then
		XGUIEng.DisableButton( "HQ_CallMilitia", 1 ); XGUIEng.DisableButton( "Levy_Duties", 1 )
		XGUIEng.DisableButton( "HQ_BackToWork", 1 )
		
		if Stronghold.Treasury[1]<= 0 and Stronghold.LawAndOrder[1]<= 0 then
			XGUIEng.DisableButton( "Research_Tracking", 0 ); XGUIEng.DisableButton( "Buy_Hero", 0 )
		elseif Stronghold.Treasury[1]== 1 and Stronghold.LawAndOrder[1]<= 0 then
			XGUIEng.HighLightButton( "Research_Tracking", 0 ); XGUIEng.HighLightButton( "Buy_Hero", 1 )
			XGUIEng.DisableButton( "Research_Tracking", 1 )
		elseif Stronghold.Treasury[1]<= 0 and Stronghold.LawAndOrder[1]== 1 then
			XGUIEng.HighLightButton( "Research_Tracking", 1 ); XGUIEng.HighLightButton( "Buy_Hero", 0 )
			XGUIEng.DisableButton( "Buy_Hero", 1 )
		end
	elseif Etype == Entities.PB_Headquarters2 then
		XGUIEng.DisableButton( "HQ_BackToWork", 1 )
		
		if Stronghold.Treasury[1]<= 0 and Stronghold.LawAndOrder[1]<= 0 then
			XGUIEng.DisableButton( "Research_Tracking", 0 ); XGUIEng.DisableButton( "Buy_Hero", 0 )
		elseif Stronghold.Treasury[1]== 1 and Stronghold.LawAndOrder[1]<= 0 then
			XGUIEng.HighLightButton( "Research_Tracking", 0 ); XGUIEng.HighLightButton( "Buy_Hero", 1 )
			XGUIEng.DisableButton( "Research_Tracking", 1 )
		elseif Stronghold.Treasury[1]<= 0 and Stronghold.LawAndOrder[1]== 1 then
			XGUIEng.HighLightButton( "Research_Tracking", 1 ); XGUIEng.HighLightButton( "Buy_Hero", 0 )
			XGUIEng.DisableButton( "Buy_Hero", 1 )
		end
		
		if Stronghold.DamselRoom[1]<= 0 and Stronghold.Kitchen[1]<= 0 then
			XGUIEng.DisableButton( "HQ_CallMilitia", 0 ); XGUIEng.DisableButton( "Levy_Duties", 0 )
		elseif Stronghold.DamselRoom[1]== 1 and Stronghold.Kitchen[1]<= 0 then
			XGUIEng.HighLightButton( "HQ_CallMilitia", 0 ); XGUIEng.HighLightButton( "Levy_Duties", 1 )
			XGUIEng.DisableButton( "HQ_CallMilitia", 1 )
		elseif Stronghold.DamselRoom[1]<= 0 and Stronghold.Kitchen[1]== 1 then
			XGUIEng.HighLightButton( "HQ_CallMilitia", 1 ); XGUIEng.HighLightButton( "Levy_Duties", 0 )
			XGUIEng.DisableButton( "Levy_Duties", 1 )
		end
	elseif Etype == Entities.PB_Headquarters3 then
		if Stronghold.Treasury[1]<= 0 and Stronghold.LawAndOrder[1]<= 0 then
			XGUIEng.DisableButton( "Research_Tracking", 0 ); XGUIEng.DisableButton( "Buy_Hero", 0 )
		elseif Stronghold.Treasury[1]== 1 and Stronghold.LawAndOrder[1]<= 0 then
			XGUIEng.HighLightButton( "Research_Tracking", 0 ); XGUIEng.HighLightButton( "Buy_Hero", 1 )
			XGUIEng.DisableButton( "Research_Tracking", 1 )
		elseif Stronghold.Treasury[1]<= 0 and Stronghold.LawAndOrder[1]== 1 then
			XGUIEng.HighLightButton( "Research_Tracking", 1 ); XGUIEng.HighLightButton( "Buy_Hero", 0 )
			XGUIEng.DisableButton( "Buy_Hero", 1 )
		end
		
		if Stronghold.DamselRoom[1]<= 0 and Stronghold.Kitchen[1]<= 0 then
			XGUIEng.DisableButton( "HQ_CallMilitia", 0 ); XGUIEng.DisableButton( "Levy_Duties", 0 )
		elseif Stronghold.DamselRoom[1]== 1 and Stronghold.Kitchen[1]<= 0 then
			XGUIEng.HighLightButton( "HQ_CallMilitia", 0 ); XGUIEng.HighLightButton( "Levy_Duties", 1 )
			XGUIEng.DisableButton( "HQ_CallMilitia", 1 )
		elseif Stronghold.DamselRoom[1]<= 0 and Stronghold.Kitchen[1]== 1 then
			XGUIEng.HighLightButton( "HQ_CallMilitia", 1 ); XGUIEng.HighLightButton( "Levy_Duties", 0 )
			XGUIEng.DisableButton( "Levy_Duties", 1 )
		end
		
		if Stronghold.TidyUp[1]== 1 then
			XGUIEng.HighLightButton( "HQ_BackToWork", 1 )
		elseif Stronghold.TidyUp[1]== 0 then
			XGUIEng.DisableButton( "HQ_BackToWork", 0 )
		end
	end
end

function EhreMenu()
	local size = {GUI.GetScreenSize()}
	XGUIEng.ShowWidget( "GCWindow", 1 )
	XGUIEng.ShowWidget( "GCWindowPicture1", 0 )
	XGUIEng.ShowWidget( "GCWindowPicture2", 0 )
	XGUIEng.ShowWidget( "GCWindowPicture4", 0 )
	XGUIEng.ShowWidget( "GCWindowPicture3", 0 )
	XGUIEng.ShowWidget( "GCWindowBG", 0 )
	XGUIEng.ShowWidget( "GCWindowBG_Complete", 1 )
	XGUIEng.ShowWidget( "GCWindowHint1", 0 )
	XGUIEng.ShowWidget( "GCWindowHint2", 0 )
	XGUIEng.ShowWidget( "GCWindowHint3", 0 )
	XGUIEng.ShowWidget( "GCWindowHint4", 0 )
	XGUIEng.ShowWidget( "GCWindowText1", 0 )
	XGUIEng.ShowWidget( "GCWindowText2", 0 )
	XGUIEng.ShowWidget( "GCWindowText3", 0 )
	XGUIEng.ShowWidget( "GCWindowText4", 0 )
	XGUIEng.ShowWidget( "GCWindowCloseButton", 0 )
	XGUIEng.SetWidgetPositionAndSize( "GCWindow", size[1], 0, 160, 45 )
	XGUIEng.SetWidgetPositionAndSize( "GCWindowWelcome", 3, 5, 160, 0 )
	XGUIEng.SetText("GCWindowWelcome", " Ehre: "..Stronghold.Ehre.." @cr "..
										" Beliebtheit: "..Stronghold.Motivation)
end

function Stronghold_Recover()
	Mission_OnSaveGameLoaded_OrigSH = Mission_OnSaveGameLoaded
	Mission_OnSaveGameLoaded = function()
		Mission_OnSaveGameLoaded_OrigSH()
		Init_Attraction()
		XGUIEng.TransferMaterials( "Buy_LeaderSword", "Research_Debenture" )
		XGUIEng.TransferMaterials( "Buy_LeaderSpear", "Research_BookKeeping" )
		XGUIEng.TransferMaterials( "Research_Laws", "Research_Tracking" )
		XGUIEng.TransferMaterials( "Buy_LeaderBow", "Research_PickAxe" )
		XGUIEng.TransferMaterials( "Buy_LeaderRifle", "Research_LightBricks" )
		XGUIEng.TransferMaterials( "Formation04", "Research_Coinage" )
	end
end

function NumberOfCompleteBuildings( _type )
	local building = SucheAufDerWelt(1, _type)
	local output = 0
	if table.getn(building)> 0 then
		for i=1,table.getn(building)do
			if Logic.IsConstructionComplete(building[i])== 1 then
				output = output + 1
			end
		end
		return output
	end
	return 0
end

function GibTTGold( _amount, _id )
	if not type(_id) == "number" then
		_id = 1;
	end
	local da = GetGold(_id)
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function GibTTLehm( _amount, _id )
	if not type(_id) == "number" then
		_id = 1;
	end
	local da = GetClay(_id)
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function GibTTHolz( _amount, _id )
	if not type(_id) == "number" then
		_id = 1;
	end
	local da = GetWood(_id)
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function GibTTStein( _amount, _id )
	if not type(_id) == "number" then
		_id = 1;
	end
	local da = GetStone(_id)
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function GibTTEisen( _amount, _id )
	if not type(_id) == "number" then
		_id = 1;
	end
	local da = GetIron(_id)
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function GibTTSchwefel( _amount, _id )
	if not type(_id) == "number" then
		_id = 1;
	end
	local da = GetSulfur(_id)
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function GibTTEhre( _amount )
	local da = Stronghold.Ehre
	if da < _amount then
		return " @color:255,32,32 ".._amount.." @color:255,255,255 "
	end
	return tostring(_amount)
end

function IsAloneInSelection()
	local sel = {GUI.GetSelectedEntities()}
	if table.getn( sel )< 2 and table.getn( sel )> 0 then
		return true
	else
		return false
	end
end

function SucheAufDerWelt(_player, _entity, _groesse, _punkt)
	local punktX1, punktX2, punktY1, punktY2, data
	local gefunden = {}
	local rueck
	if not _groesse then
		_groesse = Logic.WorldGetSize() 
	end
	if not _punkt then
		_punkt = {X = _groesse/2, Y = _groesse/2}
	end
	if _player == 0 then
		data ={Logic.GetEntitiesInArea(_entity, _punkt.X, _punkt.Y, math.floor(_groesse * 0.71), 16)}
	else
		data ={Logic.GetPlayerEntitiesInArea(_player,_entity, _punkt.X, _punkt.Y, math.floor(_groesse * 0.71), 16)}
	end
	if data[1] >= 16 then -- Aufteilen angesagt
		local _klgroesse = _groesse / 2 
		-- Ausgangspunkt ist _punkt
		-- _punkt verteilen
		local punktX1 = _punkt.X - _groesse / 4
		local punktX2 = _punkt.X + _groesse / 4
		local punktY1 = _punkt.Y - _groesse / 4
		local punktY2 = _punkt.Y + _groesse / 4
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX1,Y=punktY1})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX1,Y=punktY2})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX2,Y=punktY1})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
		rueck = SucheAufDerWelt(_player, _entity, _klgroesse, {X=punktX2,Y=punktY2})
		for i = 1, table.getn(rueck) do
			if not IstDrin(rueck[i], gefunden) then
				table.insert(gefunden, rueck[i])
			end
		end
	else
		table.remove(data,1)
		for i = 1, table.getn(data) do
			if not IstDrin(data[i], gefunden) then
				table.insert(gefunden, data[i])
			end
		end
	end
	return gefunden
end
function IstDrin(_wert, _table)
	for i = 1, table.getn(_table) do
		if _table[i] == _wert then 
			return true 
		end 
	end
	return false
end

function round( _n )
    return math.floor( _n + 0.5 )
end

function GetRandom(_min,_max)
	if not _max then
		_max = _min;
		_min = 1;
	end
	assert( (type(_min) == "number" and type(_max) == "number"), "GetRandom: Invalid Input!" )
	_min = round(_min);
	_max = round(_max);
	if not gvRandomseed then
		local seed = "";
		gvRandomseed = true;
		if XNetwork and XNetwork.Manager_DoesExist() == 1 then
			local humanPlayer = XNetwork.GameInformation_GetMapMaximumNumberOfHumanPlayer();
			for i = 1, humanPlayer do
				if XNetwork.GameInformation_IsHumanPlayerAttachedToPlayerID( i ) == 1 then
					seed = seed .. tostring(XNetwork.GameInformation_GetLogicPlayerUserName( i ));
				end
			end
		else
			seed = XGUIEng.GetSystemTime();
		end
		math.randomseed(seed);
	end
	if _min >= _max then
		return _min;
	else
		return math.random(_min, _max);
	end
end

function BuildingsLimit( _tech, _tech2 , _buildings, _button, _player, _max )
	if Logic.IsTechnologyResearched( _player, _tech )== 1 then
		local disable = false
		for i =1,table.getn(_buildings) do
			if Logic.GetNumberOfEntitiesOfTypeOfPlayer( _player, _buildings[i] )>= _max 
			or Logic.GetTechnologyState( 1, _tech2 )== 0 then
				disable = true
			end
		end
		if disable then
			XGUIEng.DisableButton( _button, 1 )
		else
			XGUIEng.DisableButton( _button, 0 )
		end
	else
		XGUIEng.DisableButton( _button, 1 )
	end
end

-- ++++++++++++++++++++++++++++++++++++++++ --
-- ++++++++++++Stronghold End++++++++++++++ --
-- ++++++++++++++++++++++++++++++++++++++++ --

-- ++++++++++++++++++++++++++++++++++++++++ --
-- ++++++++++Interactive Objects+++++++++++ --
-- ++++++++++++++++++++++++++++++++++++++++ --
-- 		VERSION: 12. 2011
function Interactive_Setup( _table )
	IO_INTERACTIVES = IO_INTERACTIVES or {}
	table.insert( IO_INTERACTIVES, _table )
	
	if not IO_ID then
		IO_ID = StartSimpleHiResJob( "Interactive_Control" )
	end
	if not IO_Existing then
		IO_Existing = StartSimpleHiResJob( "Interactive_ExistingControl" )
	end
end

Interactive_CostsWatch = {200, 200}
Interactive_CostsBallista = {400, 500}
Interactive_CostsCannon = {400, 700, 200}


function Interactive_Control()
	Interactive_HideButton()
	for i= table.getn( IO_INTERACTIVES ), 1, -1 do
		if not IO_INTERACTIVES[i].Used then
			local sel = GUI.GetSelectedEntity()
			if sel then
				if GetDistance( sel, IO_INTERACTIVES[i].Name )<= IO_INTERACTIVES[i].Range then
					if Logic.IsHero( sel )==1 then
						Interactive_ShowButton(IO_INTERACTIVES[i])
					end
				end
			end
		else
			table.remove( IO_INTERACTIVES, i )
			Interactive_HideButton()
		end
	end
	if table.getn( IO_INTERACTIVES ) == 0 then
		IO_ID = nil
	    return true
	end
end
function Interactive_ExistingControl()
	if IO_INTERACTIVES_watch then
		for i= 1,table.getn( IO_INTERACTIVES_watch ) do
			if IsDead( IO_INTERACTIVES_watch[i].Name ) then
				local name = IO_INTERACTIVES_watch[i]
				table.remove( IO_INTERACTIVES_watch, i )
				local pos = name.Position
				Logic.CreateEffect( GGL_Effects.FXCrushBuilding, pos.X, pos.Y, 1 )
				CreateEntity( 0, Entities.XD_RuinSmallTower3, pos, name.Name )
				Interactive_Setup( {Name = name.Name, Type = 2, Range = 400,Endless = true,Callback = function()end} )
				return
			end
			if table.getn( IO_INTERACTIVES_watch ) == 0 then
				IO_INTERACTIVES_watch = nil
			end
		end
	end
end

function Interactive_ShowButton( _table )
	XGUIEng.ShowWidget( "BuyHeroWindow", 1)
	XGUIEng.ShowWidget( "TutorialMessageBG", 1)
	if _table.Type == 1 then
		for i= 2,12,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 0 )end
		XGUIEng.ShowWidget( "BuyHeroWindowBackGround", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowCloseButton", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowHeadline", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowInfoLine", 0 )
		XGUIEng.SetWidgetPositionAndSize( "TutorialMessageBG", 460, 445, 170, 50 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindow", 284, 355, 450, 50 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero1", 180, 5, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowHeadline", 0, 0, 300, 40 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowInfoLine", 40, 25, 360, 180 )
		XGUIEng.TransferMaterials( "Research_Taxation", "BuyHeroWindowBuyHero1" )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero1", 0 )
		
		BuyHeroWindow_Action_BuyHero = function( _hero )
			if _hero == Entities.PU_Hero1c then
				GUIAction_ToggleMenu( "BuyHeroWindow",_0)
				Message( " @color:244,184,0 Ihr habt einen Schatz gefunden:" )
				if _table.Rewards[1]> 0 then
					Tools.GiveResouces( 1, _table.Rewards[1], 0, 0, 0, 0, 0 )
					Message( _table.Rewards[1].." Taler" )
				end
				if _table.Rewards[2]> 0 then
					Tools.GiveResouces( 1, 0, _table.Rewards[2], 0, 0, 0, 0 )
					Message( _table.Rewards[2].." Lehm" )
				end
				if _table.Rewards[3]> 0 then
					Tools.GiveResouces( 1, 0, 0, _table.Rewards[3], 0, 0, 0 )
					Message( _table.Rewards[3].." Holz" )
				end
				if _table.Rewards[4]> 0 then
					Tools.GiveResouces( 1, 0, 0, 0, _table.Rewards[4], 0, 0 )
					Message( _table.Rewards[4].." Stein" )
				end
				if _table.Rewards[5]> 0 then
					Tools.GiveResouces( 1, 0, 0, 0, 0, _table.Rewards[5], 0 )
					Message( _table.Rewards[5].." Eisen" )
				end
				if _table.Rewards[6]> 0 then
					Tools.GiveResouces( 1, 0, 0, 0, 0, 0, _table.Rewards[6] )
					Message( _table.Rewards[6].." Schwefel" )
				end
				Sound.PlayQueuedFeedbackSound(Sounds.VoicesMentor_CHEST_FoundTreasureChest_rnd_01)
				_table.Callback()
				_table.Used = true
			end
		end
	elseif _table.Type == 2 then
		for i= 1,3,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 1 )end
		for i= 4,12,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 0 )end
		XGUIEng.ShowWidget( "BuyHeroWindowBackGround", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowCloseButton", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowHeadline", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowInfoLine", 1 )
		XGUIEng.SetWidgetPositionAndSize( "TutorialMessageBG", 320, 365, 470, 130 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindow", 270, 345, 450, 135 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero1", 160, 0, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero2", 195, 0, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero3", 229, 0, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowHeadline", 0, 0, 360, 40 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowInfoLine", 0, 35, 450, 100 )
		XGUIEng.TransferMaterials( "Build_Tower", "BuyHeroWindowBuyHero1" )
		XGUIEng.TransferMaterials( "Hero10_LongRangeAura", "BuyHeroWindowBuyHero2" )
		XGUIEng.TransferMaterials( "Build_Foundry", "BuyHeroWindowBuyHero3" )
		if Logic.GetTechnologyState( 1, Technologies.GT_Construction ) == 4 then XGUIEng.DisableButton( "BuyHeroWindowBuyHero1", 0 )else XGUIEng.DisableButton( "BuyHeroWindowBuyHero1", 1 )end
		if Logic.GetTechnologyState( 1, Technologies.UP1_Tower ) == 2 or Logic.GetTechnologyState( 1, Technologies.UP1_Tower ) == 4 then XGUIEng.DisableButton( "BuyHeroWindowBuyHero2", 0 )else XGUIEng.DisableButton( "BuyHeroWindowBuyHero2", 1 )end
		if Logic.GetTechnologyState( 1, Technologies.UP2_Tower ) == 2 or Logic.GetTechnologyState( 1, Technologies.UP2_Tower ) == 4 then XGUIEng.DisableButton( "BuyHeroWindowBuyHero3", 0 )else XGUIEng.DisableButton( "BuyHeroWindowBuyHero3", 1 )end
		
		BuyHeroWindow_Action_BuyHero = function( _hero )
			if _hero == Entities.PU_Hero1c then
				if GetWood(1)>= Interactive_CostsWatch[1] and GetStone(1)>= Interactive_CostsWatch[2]then
					GUIAction_ToggleMenu( "BuyHeroWindow",_0)
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_UPGRADE_UpgradeReady_rnd_01 )
					AddWood( 1, -Interactive_CostsWatch[1] )
					AddStone( 1, -Interactive_CostsWatch[1] )
					ReplaceEntity( _table.Name, Entities.PB_Tower1 )
					ProtectEntity( _table.Name )
					if _table.Endless then
						_table.Position = GetPosition( _table.Name )
						IO_INTERACTIVES_watch = IO_INTERACTIVES_watch or {}
						table.insert( IO_INTERACTIVES_watch, _table )
					end
					_table.Callback()
					_table.Used = true
				else
					Message( "Ihr habt nicht genug Ressourcen." )
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_INFO_NotEnough )
				end
			elseif _hero == Entities.PU_Hero5 then
				if GetWood(1)>= Interactive_CostsBallista[1] and GetStone(1)>= Interactive_CostsBallista[2]then
					GUIAction_ToggleMenu( "BuyHeroWindow",_0)
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_UPGRADE_UpgradeReady_rnd_01 )
					AddWood( 1, -Interactive_CostsBallista[1] )
					AddStone( 1, -Interactive_CostsBallista[2] )
					ReplaceEntity( _table.Name, Entities.PB_Tower2 )
					ProtectEntity( _table.Name )
					if _table.Endless then
						_table.Position = GetPosition( _table.Name )
						IO_INTERACTIVES_watch = IO_INTERACTIVES_watch or {}
						table.insert( IO_INTERACTIVES_watch, _table )
					end
					_table.Callback()
					_table.Used = true
				else
					Message( "Ihr habt nicht genug Ressourcen." )
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_INFO_NotEnough )
				end
			elseif _hero == Entities.PU_Hero4 then
				if GetWood(1)>= Interactive_CostsCannon[1] and GetStone(1)>= Interactive_CostsCannon[2] and GetSulfur(1)>= Interactive_CostsCannon[3] then
					GUIAction_ToggleMenu( "BuyHeroWindow",_0)
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_UPGRADE_UpgradeReady_rnd_01 )
					AddWood( 1, -Interactive_CostsCannon[1] )
					AddStone( 1, -Interactive_CostsCannon[2] )
					AddSulfur( 1, -Interactive_CostsCannon[3] )
					ReplaceEntity( _table.Name, Entities.PB_Tower3 )
					ProtectEntity( _table.Name )
					if _table.Endless then
						_table.Position = GetPosition( _table.Name )
						IO_INTERACTIVES_watch = IO_INTERACTIVES_watch or {}
						table.insert( IO_INTERACTIVES_watch, _table )
					end
					_table.Callback()
					_table.Used = true
				else
					Message( "Ihr habt nicht genug Ressourcen." )
					Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_INFO_NotEnough )
				end
			end
		end
	elseif _table.Type == 3 then
		for i= 2,12,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 0 )end
		XGUIEng.ShowWidget( "BuyHeroWindowBackGround", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowCloseButton", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowHeadline", 1 )
		XGUIEng.ShowWidget( "BuyHeroWindowInfoLine", 1 )
		XGUIEng.TransferMaterials( _table.Button, "BuyHeroWindowBuyHero1" )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero1", 0 )
		if _table.WinSize == "small" then
			XGUIEng.SetWidgetPositionAndSize( "TutorialMessageBG", 330, 350, 470, 140 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindow", 280, 265, 450, 100 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero1", 415, 5, 31, 31 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowHeadline", 5, 5, 450, 65 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowInfoLine", 0, 36, 450, 65 )
		elseif _table.WinSize == "normal" or not(_table.WinSize)then
			XGUIEng.SetWidgetPositionAndSize( "TutorialMessageBG", 330, 300, 470, 210 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindow", 280, 325, 450, 200 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero1", 415, 5, 31, 31 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowHeadline", 5, 5, 450, 165 )
			XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowInfoLine", 0, 36, 450, 65 )
		end
		
		BuyHeroWindow_Action_BuyHero = function( _hero )
			if _hero == Entities.PU_Hero1c then
				local trigger = true
				if _table.Triggers then
					for i= table.getn( _table.Triggers ),1,-1 do
						if _table.Triggers[i][1]() == 0 then
							trigger = false
							if _table.Triggers[i][2] then Message( _table.Triggers[i][2] ) end
						end
					end
				end
				if trigger == true then
					if _table.Costs then
						if GetGold(1)>= _table.Costs[1] and GetClay(1)>= _table.Costs[2]
						and GetWood(1)>= _table.Costs[3] and GetStone(1)>= _table.Costs[4]
						and GetIron(1)>= _table.Costs[5] and GetSulfur(1)>= _table.Costs[6]
						and Stronghold.Ehre >= _table.Costs[7] then
							GUIAction_ToggleMenu( "BuyHeroWindow",_0)
							AddGold( 1, -_table.Costs[1] )
							AddClay( 1, -_table.Costs[2] )
							AddWood( 1, -_table.Costs[3] )
							AddStone( 1, -_table.Costs[4] )
							AddIron( 1, -_table.Costs[5] )
							AddSulfur( 1, -_table.Costs[6] )
							Stronghold.Ehre = Stronghold.Ehre - _table.Costs[7]
							if _table.Rewards then
								Tools.GiveResouces( 1, _table.Rewards[1], _table.Rewards[2], _table.Rewards[3], _table.Rewards[4], _table.Rewards[5], _table.Rewards[6] )
							end
							_table.Callback()
							_table.Used = true
						else
							Sound.PlayQueuedFeedbackSound( Sounds.VoicesMentor_INFO_NotEnough )
							Message( "Ihr habt nicht genug Ressourcen." )
						end
					else
						if _table.Rewards then
							Tools.GiveResouces( 1, _table.Rewards[1], _table.Rewards[2], _table.Rewards[3], _table.Rewards[4], _table.Rewards[5], _table.Rewards[6] )
						end
						_table.Callback()
						_table.Used = true
					end
				end
			end
		end
	elseif _table.Type == 4 then
		for i= 2,12,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 0 )end
		XGUIEng.ShowWidget( "BuyHeroWindowBackGround", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowCloseButton", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowHeadline", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowInfoLine", 0 )
		XGUIEng.SetWidgetPositionAndSize( "TutorialMessageBG", 460, 445, 170, 50 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindow", 280, 355, 450, 50 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero1", 180, 5, 31, 31 )
		
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero1", 0 )
		
		BuyHeroWindow_Action_BuyHero = function( _hero )
			if _hero == Entities.PU_Hero1c then
				if Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_DarkWallStraightGate_Closed then
					ReplaceEntity( _table.Name, Entities.XD_DarkWallStraightGate )
				elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_WallStraightGate_Closed then
					ReplaceEntity( _table.Name, Entities.XD_WallStraightGate )
				elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_PalisadeGate1 then
					ReplaceEntity( _table.Name, Entities.XD_PalisadeGate2 )
				elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_DarkWallStraightGate then
					ReplaceEntity( _table.Name, Entities.XD_DarkWallStraightGate_Closed )
				elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_WallStraightGate then
					ReplaceEntity( _table.Name, Entities.XD_WallStraightGate_Closed )
				elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_PalisadeGate2 then
					ReplaceEntity( _table.Name, Entities.XD_PalisadeGate1 )
				end
				Interactive_Setup( {Name = _table.Name, Type = 4, Range = _table.Range, Callback = function()end} )
				_table.Callback()
				_table.Used = true
				GUIAction_ToggleMenu( "BuyHeroWindow",_0)
			end
		end
	elseif _table.Type == 5 then
		for i= 1,5,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 1 )end
		for i= 6,12,1 do XGUIEng.ShowWidget( "BuyHeroWindowBuyHero"..i, 0 )end
		XGUIEng.ShowWidget( "BuyHeroWindowBackGround", 0 )
		XGUIEng.ShowWidget( "BuyHeroWindowCloseButton", 0 )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero1", 0 )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero2", 0 )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero3", 0 )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero4", 0 )
		XGUIEng.DisableButton( "BuyHeroWindowBuyHero5", 0 )
		XGUIEng.SetWidgetPositionAndSize( "TutorialMessageBG", 430, 425, 250, 70 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindow", 285, 325, 450, 60 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero1", 126, 30, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero2", 160, 30, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero3", 195, 30, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero4", 229, 30, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowBuyHero5", 263, 30, 31, 31 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowHeadline", 0, 0, 450, 40 )
		XGUIEng.SetWidgetPositionAndSize( "BuyHeroWindowInfoLine", 0, 65, 450, 40 )
		XGUIEng.TransferMaterials( "Statistics_SubSettlers_Worker", "BuyHeroWindowBuyHero1" )
		XGUIEng.TransferMaterials( "Hero12_PoisonRange", "BuyHeroWindowBuyHero2" )
		XGUIEng.TransferMaterials( "WeatherTower_MakeSummer", "BuyHeroWindowBuyHero3" )
		XGUIEng.TransferMaterials( "Research_Banking", "BuyHeroWindowBuyHero4" )
		XGUIEng.TransferMaterials( "Research_WeatherForecast", "BuyHeroWindowBuyHero5" )--Weather_EnergyIcon
		
		BuyHeroWindow_Action_BuyHero = function( _hero )
			if _hero == Entities.PU_Hero1c then
				_table.Button1()
			elseif _hero == Entities.PU_Hero5 then
				_table.Button2()
			elseif _hero == Entities.PU_Hero4 then
				_table.Button3()
			elseif _hero == Entities.PU_Hero3 then
				_table.Button4()
			elseif _hero == Entities.PU_Hero2 then
				_table.Button5()
			end
			_table.Used = true
		end
	end
	BuyHeroWindow_UpdateInfoLine = function()
		if _table.Type == 1 then
			XGUIEng.SetText( "BuyHeroWindowHeadline", " @center Versteckter Schatz" )
			XGUIEng.SetText( "BuyHeroWindowInfoLine", " @cr @color:255,255,255 Schatz bergen." )
		elseif _table.Type == 2 then
			XGUIEng.SetText( "BuyHeroWindowHeadline", "")
			XGUIEng.SetText( "BuyHeroWindowInfoLine", ""..
							" @color:180,180,180 Aussichtsturm @color:255,255,255 Holz: "..GibTTHolz( Interactive_CostsWatch[1], 1).." Stein: "..GibTTStein( Interactive_CostsWatch[2], 1).." @cr "..
							" @color:180,180,180 Ballistaturm @color:255,255,255 Holz: "..GibTTHolz( Interactive_CostsBallista[1], 1).." Stein: "..GibTTStein( Interactive_CostsBallista[2], 1).." @cr "..
							" @color:180,180,180 Kannonenturm @color:255,255,255 Holz: "..GibTTHolz( Interactive_CostsCannon[1], 1).." Stein: "..GibTTStein( Interactive_CostsCannon[2], 1).." Schwefel: "..GibTTSchwefel( Interactive_CostsCannon[3], 1))
		elseif _table.Type == 3 then
			local text = ""
			local title = ""
			if _table.Text then text = _table.Text.." @cr @cr " end
			if _table.Title then title = _table.Title end
			if _table.Costs then
				local costs = {"","","","","","","",}
				if _table.Costs[1]>0 then costs[1] = "Taler: "..GibTTGold( _table.Costs[1] )end
				if _table.Costs[2]>0 then costs[2] = "Lehm: "..GibTTLehm( _table.Costs[2] )end
				if _table.Costs[3]>0 then costs[3] = "Holz: "..GibTTHolz( _table.Costs[3] )end
				if _table.Costs[4]>0 then costs[4] = "Stein: "..GibTTStein( _table.Costs[4] )end
				if _table.Costs[5]>0 then costs[5] = "Eisen: "..GibTTEisen( _table.Costs[5] )end
				if _table.Costs[6]>0 then costs[6] = "Schwefel: "..GibTTSchwefel( _table.Costs[6] )end
				if _table.Costs[7]>0 then costs[7] = "Ehre: "..GibTTEhre( _table.Costs[7] )end
				XGUIEng.SetText( "BuyHeroWindowHeadline", Umlaute(title) )
				XGUIEng.SetText( "BuyHeroWindowInfoLine", Umlaute(text.." @color:180,180,180 Kosten: @color:255,255,255 "..
									" "..costs[1].." "..costs[2].." "..costs[3].." "..costs[4].." "..costs[5].." "..costs[6].." "..costs[7]))
			else
				XGUIEng.SetText( "BuyHeroWindowHeadline", Umlaute(title) )
				XGUIEng.SetText( "BuyHeroWindowInfoLine", Umlaute(text) )
			end
		elseif _table.Type == 4 then
			if Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_DarkWallStraightGate_Closed
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_WallStraightGate_Closed
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_PalisadeGate1 then
				XGUIEng.SetText( "BuyHeroWindowHeadline", "" )
				XGUIEng.SetText( "BuyHeroWindowInfoLine", "")
				XGUIEng.TransferMaterials( "ActivateAlarm", "BuyHeroWindowBuyHero1" )
			elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_DarkWallStraightGate
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_WallStraightGate
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_PalisadeGate2 then
				XGUIEng.SetText( "BuyHeroWindowHeadline", "" )
				XGUIEng.SetText( "BuyHeroWindowInfoLine", "")
				XGUIEng.TransferMaterials( "QuitAlarm", "BuyHeroWindowBuyHero1" )
			end
		elseif _table.Type == 5 then
			XGUIEng.SetText( "BuyHeroWindowHeadline", Umlaute(""))
			XGUIEng.SetText( "BuyHeroWindowInfoLine", Umlaute(""))
		end	
	end
	BuyHeroWindow_Update_BuyHero = function()
		if _table.Type == 4 then
			if Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_DarkWallStraightGate_Closed
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_WallStraightGate_Closed
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_PalisadeGate1 then
				XGUIEng.TransferMaterials( "QuitAlarm", "BuyHeroWindowBuyHero1" )
			elseif Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_DarkWallStraightGate
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_WallStraightGate
			or Logic.GetEntityType( GetEntityId(_table.Name)) == Entities.XD_PalisadeGate2 then
				XGUIEng.TransferMaterials( "Research_Banking", "BuyHeroWindowBuyHero1" )
			end
		end
	end
end

function Interactive_HideButton()
	XGUIEng.ShowWidget( "BuyHeroWindow", 0)
	XGUIEng.ShowWidget( "TutorialMessageBG", 0)
end

function SetupProtectedEntities()
    gvProtectedUnits = {};
    gvProtectedBuildings = {};
    GameCallback_GUI_SelectionChanged_OrigProtected = GameCallback_GUI_SelectionChanged;
    GameCallback_GUI_SelectionChanged = function()
        GameCallback_GUI_SelectionChanged_OrigProtected()
		for i = table.getn(gvProtectedUnits),1,-1 do
			if GUI.GetSelectedEntity() == Logic.GetEntityIDByName( gvProtectedUnits[i] ) then
	            XGUIEng.ShowWidget( gvGUI_WidgetID.ExpelSettler, 0 )
	            return
			else
				XGUIEng.ShowWidget( gvGUI_WidgetID.ExpelSettler, 1 )
	        end
		end
        for i = table.getn(gvProtectedBuildings),1,-1 do
            if GUI.GetSelectedEntity() == Logic.GetEntityIDByName( gvProtectedBuildings[i] )then
                XGUIEng.ShowWidget( gvGUI_WidgetID.DestroyBuilding, 0 )
                return
			elseif IsEntitySelected("HQSteele")then
				XGUIEng.ShowWidget( gvGUI_WidgetID.DestroyBuilding, 0 )
                return
            else
                XGUIEng.ShowWidget( gvGUI_WidgetID.DestroyBuilding, 1 )
            end
        end
    end
    ProtectEntity = function( _entity )
        assert( type( _entity ) == "string" , "ProtectedEntities ERROR: Name of entity must be a string!" );
        if Logic.IsBuilding( GetEntityId( _entity ) ) == 1 then
            table.insert( gvProtectedBuildings, _entity );
        else
            table.insert( gvProtectedUnits, _entity );
        end
    end
end

function GetDistance( _pos1, _pos2 )
    if (type(_pos1) == "string") or (type(_pos1) == "number") then
        _pos1 = GetPosition(_pos1);
    end
    if (type(_pos2) == "string") or (type(_pos2) == "number") then
        _pos2 = GetPosition(_pos2);
    end
	assert(type(_pos1) == "table");
	assert(type(_pos2) == "table");
    local xDistance = (_pos1.X - _pos2.X);
    local yDistance = (_pos1.Y - _pos2.Y);
    return math.sqrt((xDistance^2) + (yDistance^2));
end

function GetHealth( _entity )
    local entityID = GetEntityId( _entity );
    if not Tools.IsEntityAlive( entityID ) then
        return 0;
    end
    local MaxHealth = Logic.GetEntityMaxHealth( entityID );
    local Health = Logic.GetEntityHealth( entityID );
    return ( Health / MaxHealth ) * 100;
end

-- ++++++++++++++++++++++++++++++++++++++++ --
-- ++++++++Interactive Objects End+++++++++ --
-- ++++++++++++++++++++++++++++++++++++++++ --