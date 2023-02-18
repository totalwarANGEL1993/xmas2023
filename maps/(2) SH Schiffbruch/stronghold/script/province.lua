--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.Province = {
    Data = {},
    Config = {},
}

function Stronghold.Province:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end
end

function Stronghold.Province:OnSaveGameLoaded()
end

