DetectStronghold = function()
    return false;
end

gvBasePath = gvBasePath or "maps/user/Stronghold/";
Script.Load(gvBasePath.. "detecter.lua");
if not DetectStronghold() then
    GUI.AddStaticNote("@color:255,0,0 ERROR: Can not find Stronghold!");
    return false;
end

Script.Load(gvBasePath.. "script/lib/comforts.lua");
Script.Load(gvBasePath.. "script/lib/syncer.lua");
Script.Load(gvBasePath.. "script/lib/entitytracker.lua");

Script.Load(gvBasePath.. "script/stronghold/main.lua");

Script.Load(gvBasePath.. "script/stronghold/mod/utils.lua");
Script.Load(gvBasePath.. "script/stronghold/mod/economy.lua");
Script.Load(gvBasePath.. "script/stronghold/mod/construction.lua");
Script.Load(gvBasePath.. "script/stronghold/mod/building.lua");
Script.Load(gvBasePath.. "script/stronghold/mod/unit.lua");
Script.Load(gvBasePath.. "script/stronghold/mod/hero.lua");
Script.Load(gvBasePath.. "script/stronghold/mod/province.lua");

Script.Load(gvBasePath.. "script/stronghold/ai/ai_army.lua");
Script.Load(gvBasePath.. "script/stronghold/ai/ai_camp.lua");
Script.Load(gvBasePath.. "script/stronghold/ai/ai_player.lua");

