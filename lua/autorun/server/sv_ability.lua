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
    self:DeathAbility(true)
    if abilities[int] != nil then
       local origAbility = abilities[int]
       self.Ability = {}
       self.Ability.id = origAbility.id
       self.Ability.PlyCooldown = 0
       self.Ability.PlyUseCD = 0
       self.Ability.FirstUsed = false
       self.Ability.UsesCount = origAbility.UsesCount
       self.Ability.passive = origAbility.passive
       net.Start("AbilityHUD")
       net.WriteInt(self.Ability.id,32)
       net.Send(self)
    end 
end 

function plym:DeathAbility(silentbool)
    if self.Ability then
        abilities[self.Ability.id].death(self,silentbool)
    end
    AbilityDebug(self)
    self.Ability = nil 
    --self.Cooldown = 0
    net.Start("HUDRemove")
    net.Send(self)
end

function plym:UseAbilityServer()
    if not self.Ability or not self.Ability.id then return end 
    if not self:Alive() then self:DeathAbility(true) return end -- idk if it was causing problems but why not?
    local origAbility = abilities[self.Ability.id]
    if not origAbility then return end 
    if self.Ability.UsesCount and self.Ability.UsesCount <= 0 then
        return 
    end
    if self.Ability.passive then return end 
 if not origAbility.customUse then 
    if self.Ability.PlyCooldown <= CurTime() then
        print("Ability Activated")
        origAbility.use(self)
        self.Ability.active = true
        net.Start("ActiveState")
        net.WriteBool(true)
        net.Send(self)
        timer.Create("AbilityUse"..self:EntIndex(),origAbility.usetime,1,function()
            self.Ability.active = false 
            net.Start("ActiveState")
            net.WriteBool(false)
            net.Send(self)
        end)
        self.Ability.FirstUsed = true 
        self.Ability.PlyCooldown = CurTime() + origAbility.cooldown
        self.Ability.PlyUseCD = CurTime() + origAbility.usetime
        net.Start("AbilityUse")
        net.WriteFloat(self.Ability.PlyCooldown)
        net.WriteFloat(self.Ability.PlyUseCD)
        if self.Ability.UsesCount then
            self.Ability.UsesCount = self.Ability.UsesCount - 1
            net.WriteInt(self.Ability.UsesCount,16)
        end
        net.Send(self)
    else
        print("Ability is reloading")
    end
else 
    origAbility.use(self)
 end 
end

net.Receive("ClientUse",function(len,ply)
    ply:UseAbilityServer()
end)

concommand.Add("+ability_use",function(ply)
    if !ply then return end 
    ply:UseAbilityServer()
end)



hook.Add("PlayerButtonDown","AbilityActivate",function(ply,button)
    if button != ply:GetInfoNum("ability_key",18) then return end
    ply:UseAbilityServer()
end)

hook.Add("EntityTakeDamage","AbilityDamage",function(target,dmg)
    if target:IsPlayer() and target.Ability then
    local origAbility = abilities[target.Ability.id]
        if target.Ability.id == 4 and target.Ability.active then
            dmg:ScaleDamage(0.65)
        end
        if target.Ability.id == 6 and !target.Ability.SwanCD then
            origAbility.use(target)
            return true 
        end
    end
end)

hook.Add("PlayerHurt","PlayerHurtAbility",function(victim,attacker,healthRemaining,damageTaken)
    if victim.Ability then
        --local origAbility = abilities[victim.Ability.id]
        --[[if victim.Ability.id == 6 and not victim.Ability.SwanCD and healthRemaining <= 0 then
           origAbility.use(victim)
        end]]
    end
end)

hook.Add("PlayerShouldTakeDamage","AbilityShouldTakeDamage",function(ply,attacker)
    if ply.Ability then
        if ply.Ability.id == 6 and ply.Ability.SwanCD then
            return false 
        end
    end
end)

hook.Add("FinishMove","AbilityFinishMove",function(ply,mv)
    if ply.Ability then
        if ply.Ability.id == 6 and ply.Ability.SwanCD and ply.Ability.SwanCD <= CurTime() then
            ply:Kill()
        end
    end

end)

hook.Add("DoPlayerDeath","AbilityPlayerDeath",function(ply,attacker,dmg)
    if attacker:IsPlayer() and ply != attacker then
        if attacker.Ability and attacker.Ability.id == 6 then
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
