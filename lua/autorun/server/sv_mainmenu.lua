resource.AddWorkshop( "2948456154" )

util.AddNetworkString("SpawnMainMenu")
util.AddNetworkString("Golova")
util.AddNetworkString( "cool_addon_client_ready" )

--[[hook.Add("PlayerSpawn","MainMenu",function(ply)
    net.Start("SpawnMainMenu")
    net.Send(ply)
end)
--]]

hook.Add("ShowSpare2","MainMenu",function(ply)
    net.Start("SpawnMainMenu")
    net.Send(ply)
end)

hook.Add("PlayerHurt","Hurt",function(victim,attacker,healthremaining,damagetaken)
    if healthremaining <= 0 and victim:LastHitGroup() == 1 then
        net.Start("Golova")
        net.Send(attacker)
    end
end)

net.Receive( "cool_addon_client_ready", function( len, ply )
	net.Start("SpawnMainMenu")
    net.Send(ply)
end )