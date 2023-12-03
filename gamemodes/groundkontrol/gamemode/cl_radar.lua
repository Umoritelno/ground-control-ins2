gameevent.Listen("player_connect") -- radar render in cl_hud.lua
GM.RadarStrelka = Material("strelka.png")

hook.Add("player_connect","PlayerConnectRadar",function(data)
    --if data.bot == 1 then return end
    timer.Simple(1,function()
        GAMEMODE:AddRadarMarker({origin = Player(data.userid),color = Color(0,255,255),texture = GAMEMODE.RadarStrelka,
            filter = function(self)
            if !IsValid(self.origin) then
                return "delete"
            end

            return LocalPlayer():Team() == self.origin:Team() and self.origin:Alive()
        end,})
    end)
end)

net.Receive("AddRadarMarker",function()
    local data = net.ReadTable() -- error with functions
    if !data then
        return
    end
    GAMEMODE:AddRadarMarker(data)
end)

--[[for k,v in pairs(player.GetAll()) do
    print(v:UserID())
end--]]