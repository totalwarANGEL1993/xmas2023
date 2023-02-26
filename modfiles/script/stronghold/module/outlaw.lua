--- 
--- 
--- 

Stronghold = Stronghold or {};

Stronghold.Outlaw = {
    Data = {},
    Config = {},
}

function Stronghold.Outlaw:Install()
    for i= 1, table.getn(Score.Player) do
        self.Data[i] = {};
    end
end

function Stronghold.Outlaw:OnSaveGameLoaded()
end

