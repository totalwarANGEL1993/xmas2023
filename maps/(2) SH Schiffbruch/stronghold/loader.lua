local LibPath = "maps\\user\\cerberus\\loader.lua";
-- local LibPath = "maps\\externalmap\\cerberus\\loader.lua";
Script.Load(LibPath);
assert(Lib ~= nil);

Lib.Require("comfort/KeyOf");
Lib.Require("comfort/GetAllCannons");
Lib.Require("comfort/GetAllLeader");
Lib.Require("comfort/GetAllWorker");
Lib.Require("comfort/GetAllWorkplaces");
Lib.Require("comfort/GetDistance");
Lib.Require("comfort/GetPlayerEntities");
Lib.Require("comfort/GetLanguage");
Lib.Require("comfort/GetSeparatedTooltipText");
Lib.Require("comfort/GetValidEntitiesOfType");
Lib.Require("comfort/IsBuildingBeingUpgraded");
Lib.Require("comfort/IsValidEntity");

Lib.Require("module/archive/Archive");
Lib.Require("module/entity/EntityTracker");
Lib.Require("module/entity/SVLib");
Lib.Require("module/lua/Overwrite");
Lib.Require("module/mp/Syncer");
Lib.Require("module/trigger/Job");
Lib.Require("module/ui/BuyHero");
Lib.Require("module/ui/Placeholder");

-- ---------- --

DetectStronghold = function()
    return false;
end

gvBasePath = gvBasePath or "stronghold/";
Script.Load(gvBasePath.. "detecter.lua");
if not DetectStronghold() then
    GUI.AddStaticNote("@color:255,0,0 ERROR: Can not find Stronghold!");
    return false;
end

-- ---------- --

Script.Load(gvBasePath.. "main.lua");

Script.Load(gvBasePath.. "script/utils.lua");
Script.Load(gvBasePath.. "script/attraction.lua");
Script.Load(gvBasePath.. "script/economy.lua");
Script.Load(gvBasePath.. "script/construction.lua");
Script.Load(gvBasePath.. "script/building.lua");
Script.Load(gvBasePath.. "script/unit.lua");
Script.Load(gvBasePath.. "script/hero.lua");
Script.Load(gvBasePath.. "script/province.lua");

Script.Load(gvBasePath.. "script/ai_army.lua");
Script.Load(gvBasePath.. "script/ai_camp.lua");
Script.Load(gvBasePath.. "script/ai_player.lua");

