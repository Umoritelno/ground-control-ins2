--resource.AddWorkshop("2943924106")

local plym = FindMetaTable("Player")
util.AddNetworkString("AbilityHUD")
util.AddNetworkString("HUDRemove")
util.AddNetworkString("HUDDestroy")
util.AddNetworkString("AbilityUse")
util.AddNetworkString("InitPost")
util.AddNetworkString("ClientUse")
util.AddNetworkString("ActiveState")


function AbilityDebug(ply)
    for k,v in pairs(debugtable) do
        if timer.Exists(v..ply:EntIndex()) then
            timer.Remove(v..ply:EntIndex())
        end
    end
end

function plym:GiveAbility(int) 
    AbilityDebug(self)
    if abilities[int] != nil then
       self.Cooldown = 0
       self.Ability = abilities[int]
       self.Ability.PlyCooldown = 0
       self.Ability.PlyUseCD = 0
       self.Ability.FirstUsed = false
       net.Start("AbilityHUD")
       net.WriteString(self.Ability.description)
       net.WriteString(self.Ability.name)
       net.WriteString(self.Ability.icon)
       net.WriteFloat(self.Ability.usetime)
       net.Send(self)
    end 
end 

function plym:DeathAbility(silentbool)
    if self.Ability then
        self.Ability.death(self,silentbool)
    end
    AbilityDebug(self)
    self.Ability = nil 
    --self.Cooldown = 0
    net.Start("HUDRemove")
    net.Send(self)
end

function plym:UseAbilityServer()
    if not self.Ability then return end 
    if not self:Alive() then self:DeathAbility(true) return end -- idk if it was causing problems but why not?
    if self.Ability.UsesCount then
        if self.Abiltiy.UsesCount <= 0 then
            return 
        end
    end
    if self.Ability.passive then return end 
 if not self.Ability.customUse then 
    if self.Ability.PlyCooldown <= CurTime() then
        print("Ability Activated")
        self.Ability.use(self)
        self.Ability.active = true
        net.Start("ActiveState")
        net.WriteBool(true)
        net.Send(self)
        timer.Create("AbilityUse"..self:EntIndex(),self.Ability.usetime,1,function()
            self.Ability.active = false 
            net.Start("ActiveState")
            net.WriteBool(false)
            net.Send(self)
        end)
        self.Ability.FirstUsed = true 
        self.Ability.PlyCooldown = CurTime() + self.Ability.cooldown
        self.Ability.PlyUseCD = CurTime() + self.Ability.usetime
        net.Start("AbilityUse")
        net.WriteFloat(self.Ability.PlyCooldown)
        net.WriteFloat(self.Ability.PlyUseCD)
        net.Send(self)
    else
        print("Ability is reloading")
    end
else 
    self.Ability.use(self)
 end 
end

net.Receive("ClientUse",function(len,ply)
    ply:UseAbilityServer()
end)



hook.Add("PlayerButtonDown","AbilityActivate",function(ply,button)
    if button != KEY_H then return end
    ply:UseAbilityServer()
end)

hook.Add("EntityTakeDamage","AbilityDamage",function(target,dmg)
    if target:IsPlayer() then
        if target.Ability and target.Ability.name == "Berserk" and target.Ability.active then
            dmg:ScaleDamage(0.65)
        end
    end
end)

hook.Add("PlayerHurt","PlayerHurtAbility",function(victim,attacker,healthRemaining,damageTaken)
    if victim.Ability then
        if victim.Ability.name == "Swan Song" and not victim.Ability.SwanCD and healthRemaining <= 0 and not victim:IsBot() then
            victim:SetHealth(victim.plclass.MaxHealth or 100)
            --victim.Ability.use(victim)
            victim.Ability.active = true 
            victim.Ability.SwanCD = CurTime() + victim.Ability.usetime
            victim:ScreenFade( SCREENFADE.IN, Color( 0, 140, 255, 100), victim.Ability.usetime, 0 )
        end
    end
end)

hook.Add("FinishMove","AbilityFinishMove",function(ply,mv)
    --[[if ply.Ability then
        if ply.Ability.name == "Berserk" and ply.Ability.PlyUseCD and ply.Ability.PlyUseCD <= CurTime() and ply.Ability.PlyUseCD != 0 then
            ply:Kill()
        end
    end
    --]]

end)

hook.Add("DoPlayerDeath","AbilityPlayerDeath",function(ply,attacker,dmg)
    if attacker:IsPlayer() and ply != attacker then
        if attacker.Ability and attacker.Ability.name == "Swan Song" then
            if attacker.Ability.SwanCD then
                attacker.Ability.SwanCD = attacker.Ability.SwanCD + 5
            end
        end
    end
end)

--[[net.Receive("BerserkKill",function(len,ply)
    if ply.Ability != nil and ply.Ability.name == "Berserk" and ply.Ability.FirstUsed == true then
        ply:Kill() 
    end
end)
--]]
