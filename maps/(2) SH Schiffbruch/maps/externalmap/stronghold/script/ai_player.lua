--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.AiPlayer = {
    Data = {},
    Config = {},
}

function Stronghold.AiPlayer:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end
end

function Stronghold.AiPlayer:OnSaveGameLoaded()
end

