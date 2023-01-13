--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.AI = {
    Data = {},
    Config = {},
}

function Stronghold.AI:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end
end

function Stronghold.AI:OnSaveGameLoaded()
end

