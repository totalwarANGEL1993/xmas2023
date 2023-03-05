local LibPath = "maps\\user\\cerberus\\loader.lua";
-- local LibPath = "maps\\externalmap\\cerberus\\loader.lua";
-- local LibPath = "cerberus\\loader.lua";
Script.Load(LibPath);
assert(Lib ~= nil);

Lib.Require("comfort/KeyOf");
Lib.Require("comfort/GetAllCannons");
Lib.Require("comfort/GetAllLeader");
Lib.Require("comfort/GetAllWorker");
Lib.Require("comfort/GetAllWorkplaces");
Lib.Require("comfort/GetDistance");
Lib.Require("comfort/GetEnemiesInArea");
Lib.Require("comfort/GetPlayerEntities");
Lib.Require("comfort/GetLanguage");
Lib.Require("comfort/GetSeparatedTooltipText");
Lib.Require("comfort/GetValidEntitiesOfType");
Lib.Require("comfort/IsBuildingBeingUpgraded");
Lib.Require("comfort/IsInTable");
Lib.Require("comfort/IsValidEntity");

Lib.Require("module/archive/Archive");
Lib.Require("module/entity/EntityTracker");
Lib.Require("module/entity/SVLib");
Lib.Require("module/entity/Treasure");
Lib.Require("module/lua/Overwrite");
Lib.Require("module/mp/Syncer");
Lib.Require("module/trigger/Job");
Lib.Require("module/ui/BuyHero");
Lib.Require("module/ui/Placeholder");

-- ---------- --

DetectStronghold = function()
    return false;
end

gvBasePath = gvBasePath or "script/stronghold/";
Script.Load(gvBasePath.. "detecter.lua");
if not DetectStronghold() then
    GUI.AddStaticNote("@color:255,0,0 ERROR: Can not find Stronghold!");
    return false;
end

-- ---------- --

Script.Load(gvBasePath.. "main.lua");

Script.Load(gvBasePath.. "module/utils.lua");
Script.Load(gvBasePath.. "module/attraction.lua");
Script.Load(gvBasePath.. "module/economy.lua");
Script.Load(gvBasePath.. "module/construction.lua");
Script.Load(gvBasePath.. "module/building.lua");
Script.Load(gvBasePath.. "module/unitconfig.lua");
Script.Load(gvBasePath.. "module/recruitment.lua");
Script.Load(gvBasePath.. "module/unit.lua");
Script.Load(gvBasePath.. "module/hero.lua");
Script.Load(gvBasePath.. "module/spawner.lua");
Script.Load(gvBasePath.. "module/outlaw.lua");
Script.Load(gvBasePath.. "module/province.lua");
