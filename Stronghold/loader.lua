local LibPath = "maps\\user\\cerberus\\loader.lua";
-- local LibPath = "maps\\externalmap\\cerberus\\loader.lua";
Script.Load(LibPath);
assert(Lib ~= nil);

Lib.Require("comfort/KeyOf");
Lib.Require("comfort/GetAllWorker");
Lib.Require("comfort/GetAllWorkplaces");
Lib.Require("comfort/GetPlayerEntities");
Lib.Require("comfort/GetSeparatedTooltipText");
Lib.Require("comfort/GetValidEntitiesOfType");
Lib.Require("comfort/IsBuildingBeingUpgraded");
Lib.Require("comfort/IsValidEntity");

Lib.Require("module/buyhero/BuyHero");
Lib.Require("module/entitytracker/EntityTracker");
Lib.Require("module/svlib/SVLib");
Lib.Require("module/syncer/Syncer");
Lib.Require("module/uihacker/UiHacker");

-- ---------- --

DetectStronghold = function()
    return false;
end

gvBasePath = gvBasePath or "maps/user/Stronghold/";
Script.Load(gvBasePath.. "detecter.lua");
if not DetectStronghold() then
    GUI.AddStaticNote("@color:255,0,0 ERROR: Can not find Stronghold!");
    return false;
end

-- ---------- --

Script.Load(gvBasePath.. "main.lua");

Script.Load(gvBasePath.. "script/utils.lua");
Script.Load(gvBasePath.. "script/economy.lua");
Script.Load(gvBasePath.. "script/construction.lua");
Script.Load(gvBasePath.. "script/building.lua");
Script.Load(gvBasePath.. "script/unit.lua");
Script.Load(gvBasePath.. "script/hero.lua");
Script.Load(gvBasePath.. "script/province.lua");

Script.Load(gvBasePath.. "script/ai_army.lua");
Script.Load(gvBasePath.. "script/ai_camp.lua");
Script.Load(gvBasePath.. "script/ai_player.lua");

