-- 
-- 
-- 

Stronghold = Stronghold or {};

Stronghold.Config.Upkeep = {
    Units = {
        [Entities.PU_LeaderPoleArm1] = {Gold = 10},
        [Entities.PU_LeaderPoleArm2] = {Gold = 15},
        [Entities.PU_LeaderPoleArm3] = {Gold = 35},
        [Entities.PU_LeaderPoleArm4] = {Gold = 45},
        ---
        [Entities.PU_LeaderSword1] = {Gold = 20},
        [Entities.PU_LeaderSword2] = {Gold = 30},
        [Entities.PU_LeaderSword3] = {Gold = 60},
        [Entities.PU_LeaderSword4] = {Gold = 70},
        ---
        [Entities.PU_LeaderBow1] = {Gold = 10},
        [Entities.PU_LeaderBow2] = {Gold = 15},
        [Entities.PU_LeaderBow3] = {Gold = 50},
        [Entities.PU_LeaderBow4] = {Gold = 60},
        ---
        [Entities.PV_Cannon1] = {Gold = 10},
        [Entities.PV_Cannon2] = {Gold = 30},
        [Entities.PV_Cannon3] = {Gold = 90},
        [Entities.PV_Cannon4] = {Gold = 90},
        ---
        [Entities.PU_LeaderCavalry1] = {Gold = 30},
        [Entities.PU_LeaderCavalry2] = {Gold = 50},
        ---
        [Entities.PU_LeaderHeavyCavalry1] = {Gold = 50},
        [Entities.PU_LeaderHeavyCavalry2] = {Gold = 60},
        ---
        [Entities.PU_LeaderRifle1] = {Gold = 40},
        [Entities.PU_LeaderRifle2] = {Gold = 90},
        ---
        [Entities.PU_Scout] = {Gold = 5},
        [Entities.PU_Thief] = {Gold = 25},
    },
}

-- -------------------------------------------------------------------------- --
-- Serf

function Stronghold:PrintSerfConstructionTooltip(_PlayerID, _UpgradeCategory, _KeyNormal, _KeyDisabled, _Technology, _ShortCut)
    local Text = XGUIEng.GetStringTableText(_KeyNormal);
    if XGUIEng.IsButtonDisabled(XGUIEng.GetCurrentWidgetID()) == 1 then
        Text = XGUIEng.GetStringTableText(_KeyDisabled);
    end

    local EffectText = "";
    if _UpgradeCategory == UpgradeCategories.Beautification04 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification04];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification06 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification06];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification09 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification09];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification01 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification01];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification02 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification02];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification12 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification12];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification05 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification05];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification07 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification07];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification08 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification08];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification03 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification03];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification10 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification10];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Beautification11 then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Beautification11];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Monastery then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Monastery1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    elseif _UpgradeCategory == UpgradeCategories.Tavern then
        local Effects = Stronghold.Config.Income.Buildings[Entities.PB_Tavern1];
        EffectText = " @cr @color:244,184,0 bewirkt: @color:255,255,255 ";
        if Effects.Reputation > 0 then
            EffectText = EffectText.. "+" ..Effects.Reputation.. " Beliebtheit ";
        end
        if Effects.Honor > 0 then
            EffectText = EffectText.. "+" ..Effects.Honor.." Ehre";
        end
    else
        return false;
    end

    if _Technology and Logic.GetTechnologyState(_PlayerID, _Technology) == 0 then
        Text = XGUIEng.GetStringTableText("MenuGeneric/BuildingNotAvailable");
        EffectText = "";
    end
    XGUIEng.SetText(gvGUI_WidgetID.TooltipBottomText, Text.. " " ..EffectText);
    return true;
end

