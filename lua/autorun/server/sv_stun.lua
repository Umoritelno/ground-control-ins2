--Entity(1):SetModel("models/cultist/humans/goc/head/helmet_1.mdl")

--Entity(1):SetDSP(33,false )

hook.Add("PlayerSpawn","SetSuppress",function(ply,trans)
    ply.stun = {}
    ply.stun.stunamount = 0
    ply.stun.regendelay = CurTime()
    ply.stun.regentimer = 0
end)

hook.Add("EntityFireBullets","suppression",function(ent,bl)
    if not ent:IsPlayer() then return end 
    if not ent.stun then return end 
    if ent:GetActiveWeapon().isKnife then return end 
    local activestun = ent:GetActiveWeapon().stun or 0 
    --local supressed = ent:GetActiveWeapon():GetSuppressed() 
    if supressed then
        activestun = activestun / 2
    end
    ent.stun.stunamount = math.Clamp(ent.stun.stunamount + activestun,0,100)
    ent.stun.regendelay = CurTime() + 5
    for k,v in pairs(ents.FindInSphere(bl.Src,125)) do
        if v == ent then continue end
        if v:IsPlayer() and v.stun then
            v.stun.stunamount = math.Clamp(ent.stun.stunamount + (ent:GetActiveWeapon().stun / 2),0,100)
            v.stun.regendelay = CurTime() + 5
        end
    end
end) 

hook.Add("FinishMove","supressionController",function(ply,mv) 
    if not ply.stun then return end 
    if ply.stun.stunamount < 25 then 
        ply:SetDSP(1,false)
    elseif ply.stun.stunamount > 25 and ply.stun.stunamount < 50 then
        ply:SetDSP(30,false)
    elseif ply.stun.stunamount > 50 and ply.stun.stunamount < 75 then 
        ply:SetDSP(31,false)
    elseif ply.stun.stunamount > 75 then 
        ply:SetDSP(16,false )
    end
    if ply.stun.regendelay < CurTime() and ply.stun.regentimer < CurTime() then
    ply.stun.regentimer = CurTime() + 0.5
    ply.stun.stunamount = math.Clamp(ply.stun.stunamount - 5,0,100)
    end 
end)
