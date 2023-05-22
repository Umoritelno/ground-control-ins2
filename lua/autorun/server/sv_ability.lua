--resource.AddWorkshop("2943924106")

local plym = FindMetaTable("Player")
util.AddNetworkString("AbilityHUD")
util.AddNetworkString("HUDRemove")
util.AddNetworkString("HUDDestroy")
util.AddNetworkString("AbilityUse")
util.AddNetworkString("InitPost")

for k,v in pairs(nets) do
    util.AddNetworkString(v)
end

function AbilityDebug(ply)
    for k,v in pairs(debugtable) do
        if timer.Exists(v..ply:EntIndex()) then
            timer.Remove(v..ply:EntIndex())
        end
    end
end

function plym:GiveAbility(int) 
    if abilities[int] != nil then
       self.Ability = abilities[int]
       self.Ability.FirstUsed = false
       net.Start("AbilityHUD")
       net.WriteString(self.Ability.description)
       net.WriteString(self.Ability.name)
       net.WriteString(self.Ability.icon)
       net.Send(self)
    end 
end 



hook.Add("PlayerSpawn","Ability",function(ply)
    --[[AbilityDebug(ply)
    net.Start("HUDRemove")
    net.Send(ply)
    ply.Cooldown = 0
    ply.Ability = nil 
    local randomability = math.random(1,8)
    --]]
    --[[if abilities[randomability] != nil then
       ply.Ability = abilities[randomability]
       ply.Ability.FirstUsed = false
       net.Start("AbilityHUD")
       net.WriteString(ply.Ability.description)
       net.WriteString(ply.Ability.name)
       net.WriteString(ply.Ability.icon)
       net.Send(ply)
    end 
    --]]
    --ply:GiveAbility(randomability)
end)

hook.Add("PlayerDeath","AbilityDelete",function(victim,inflictor,attacker)
    if victim.Ability != nil then
        victim.Ability.death(victim)
    end
    AbilityDebug(victim)
    victim.Ability = nil 
    victim.Cooldown = 0
    net.Start("HUDRemove")
    net.Send(victim)
end)

hook.Add("PlayerButtonDown","AbilityActivate",function(ply,button)
    if button != KEY_H then return end
    if not ply.Ability then return end 
    if not ply:Alive() then return end 
if not ply.Ability.customUse then 
    if ply.Cooldown <= CurTime() then
        print("Ability Activated")
        ply.Ability.use(ply)
        ply.Ability.FirstUsed = true 
        ply.Cooldown = CurTime() + ply.Ability.cooldown
        net.Start("AbilityUse")
        net.WriteInt(ply.Cooldown,32)
        net.WriteString(ply.Ability.icon)
        net.WriteString(ply.Ability.description)
        net.WriteString(ply.Ability.name)
        net.WriteInt(ply.Ability.cooldown,16)
        net.Send(ply)
    else
        print("Ability is reloading")
    end
else 
    ply.Ability.use(ply)
end 
end)

hook.Add("EntityTakeDamage","AbilityDamage",function(target,dmg)
    if target:IsPlayer() then
        if target.Ability and target.Ability.hookuse then
            target.Ability.hookuse(target,dmg)
        end
    end
end)

--[[net.Receive("BerserkKill",function(len,ply)
    if ply.Ability != nil and ply.Ability.name == "Berserk" and ply.Ability.FirstUsed == true then
        ply:Kill() 
    end
end)
--]]

--[[net.Receive("DisquiseClient",function(len,ply)
    if ply.defaultModel then 
    ply:SetModel(ply.defaultModel)
    end 
end)
--]]

concommand.Add("ability_use",function(ply)
    if not ply.Ability then return end 
    if not ply:Alive() then return end 
if not ply.Ability.customUse then 
    if ply.Cooldown <= CurTime() then
        print("Ability Activated")
        ply.Ability.use(ply)
        ply.Ability.Active = true
        ply.Cooldown = CurTime() + ply.Ability.cooldown
        net.Start("AbilityUse")
        net.WriteInt(ply.Cooldown,32)
        net.WriteString(ply.Ability.icon)
        net.WriteString(ply.Ability.description)
        net.WriteString(ply.Ability.name)
        net.WriteInt(ply.Ability.cooldown,16)
        net.Send(ply)
    else
        print("Ability is reloading")
    end
else 
    ply.Ability.use(ply)
end 
end)
