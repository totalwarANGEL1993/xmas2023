--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.AiArmy = {
    Data = {},
    Config = {},
}

function Stronghold.AiArmy:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end
end

function Stronghold.AiArmy:OnSaveGameLoaded()
end

