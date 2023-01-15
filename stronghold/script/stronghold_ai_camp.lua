--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.AiCamp = {
    Data = {},
    Config = {},
}

function Stronghold.AiCamp:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end
end

function Stronghold.AiCamp:OnSaveGameLoaded()
end

