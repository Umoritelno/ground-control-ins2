util.AddNetworkString("StunReplace")
local explosionDistance = 65000 -- Max distance for explosion stun
local bulletDistance = 7000 -- Max distance for bullet stun 
local explosionStun = 50 -- Max stun from explosion
local explosionStunDelay = 25 -- Time for explosion stun delay regen
local bulletStunDelay = 6.5 -- Time for bullet stun delay regen

local pl = FindMetaTable("Player")

function pl:AddStun(stun,regendelay)
    if not self.stun then return end 
    local helmetProt = GAMEMODE:getHelmetStunReduce(self:getDesiredHelmet())
    if stun > 0 then
        stun = stun * helmetProt
    end
    self.stun.stunamount = math.Clamp(self.stun.stunamount + stun,0,maxStun)
    self:SetNWFloat("stunamount",self.stun.stunamount)
    if regendelay and self.stun.regendelay - CurTime() <= regendelay then
        self.stun.regendelay = CurTime() + regendelay
    end
end 

hook.Add("PlayerSpawn","SetStun",function(ply,trans)
    ply.stun = {}
    ply.stun.stunamount = 0
    ply.stun.regendelay = CurTime()
    ply.stun.regentimer = 0
    ply:SetNWFloat("stunamount",ply.stun.stunamount)
end)

hook.Add("EntityFireBullets","Stun",function(ent,bl)
    if !ent:IsPlayer() or !ent.stun then return end
    if !GetGlobalBool("StunEnabled") then
        net.Start("StunReplace")
        net.Send(ent)
        return 
    end 
    local weap = ent:GetActiveWeapon()
    local activestun = weap.stun
    if !activestun then return end 
    local suppressed = weap.Suppressed or weap.dt.Suppressed
    if suppressed then
        activestun = activestun * 0.65
    end
    ent:AddStun(activestun,bulletStunDelay)
    for k,v in pairs(ents.FindInSphere(bl.Src,350)) do
        if v == ent then continue end
        local entpos,sourcepos = v:GetPos(),bl.Src
        local distance = sourcepos:DistToSqr(entpos)
        if v:IsPlayer() and v.stun and distance <= bulletDistance then
            local percent = 1 -(distance / bulletDistance)
            v:AddStun(activestun * percent,bulletStunDelay * percent)
        end
    end
end) 

hook.Add("FinishMove","StunController",function(ply,mv) 
    if !ply.stun or !GetGlobalBool("StunEnabled") then return end 
    if ply.stun.stunamount < 25 then 
        ply:SetDSP(1,false)
    elseif ply.stun.stunamount <= 50 then
        ply:SetDSP(30,false)
    elseif ply.stun.stunamount <= 75 then 
        ply:SetDSP(31,false)
    --[[elseif ply.stun.stunamount >= 75 then 
        ply:SetDSP(16,false )--]]
    end
    if ply.stun.regendelay < CurTime() and ply.stun.regentimer < CurTime() then
     ply.stun.regentimer = CurTime() + 0.01
     ply:AddStun(-0.5)
    end 
end)

hook.Add("OnDamagedByExplosion", "StunExplosion", function(ply,dmginfo)
    if !GetGlobalBool("StunEnabled") then return end 
	local dmgsrc = dmginfo:GetDamagePosition()
    local dist = dmgsrc:DistToSqr(ply:GetPos())
    if dist <= explosionDistance then
        local stunperc = 1 - (dist / explosionDistance)
        ply:AddStun(explosionStun * stunperc,explosionStunDelay * stunperc)
    end
end )
