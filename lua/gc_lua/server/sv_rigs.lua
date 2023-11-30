util.AddNetworkString("RigChange")

local rigtable = {
    ["models/player/urban.mdl"] = 4,
    ["models/player/swat.mdl"] = 5,
    ["models/player/riot.mdl"] = 5,
    ["models/player/gasmask.mdl"] = 5,
    ["models/player/phoenix.mdl"] = 3,
    ["models/player/guerilla.mdl"] = 3,
    ["models/player/leet.mdl"] = 6,
    ["models/player/arctic.mdl"] = 3,
    ["models/player/group01/male_01.mdl"] = 6,
    ["models/player/group01/male_03.mdl"] = 6,
}

hook.Add("PlayerSpawn","ChangeRig",function(ply)
    timer.Simple(0.5,function()
        
    if rigtable[ply:GetModel()] then
        net.Start("RigChange")
        net.WriteInt(rigtable[ply:GetModel()],16)
        net.Send(ply)
    else
        net.Start("RigChange")
        net.WriteInt(6,16)
        net.Send(ply)
    end
    end)
end)