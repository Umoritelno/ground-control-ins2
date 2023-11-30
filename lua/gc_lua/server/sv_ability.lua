--resource.AddWorkshop("2943924106")

local plym = FindMetaTable("Player")
util.AddNetworkString("AbilityHUD")
util.AddNetworkString("HUDRemove")
util.AddNetworkString("AbilityDebug")
util.AddNetworkString("AbilityUse")
util.AddNetworkString("InitPost")
util.AddNetworkString("ClientUse")
util.AddNetworkString("ActiveState")


function AbilityDebug(ply)
    for k,v in pairs(debugtable) do
        if timer.Exists(v..ply:SteamID64()) then
            timer.Remove(v..ply:SteamID64())
        end
    end
    net.Start("AbilityDebug")
    net.Send(ply)
end

function plym:GiveAbility(skillid) 
    self:DeathAbility(true)
    local abilreqtbl = GAMEMODE:getGametype().AbilityGive
    if abilreqtbl and !abilreqtbl[self:Team()] then return end
    if !self:Alive() then return end 
    if abilities[skillid] != nil then
       local origAbility = table.Copy(abilities[skillid])
       self.Ability = origAbility
       self.Ability.PlyCooldown = 0
       self.Ability.PlyUseCD = 0
       self.Ability.FirstUsed = false
       net.Start("AbilityHUD")
       net.WriteString(self.Ability.id)
       net.Send(self)
    end 
end 

function plym:DeathAbility(silentbool)
    if self.Ability and self.Ability.death then
        self.Ability.death(self,silentbool)
    end
    AbilityDebug(self)
    self.Ability = nil 
    --self.Cooldown = 0
    net.Start("HUDRemove")
    net.Send(self)
end

function plym:UseAbilityServer()
    if not self.Ability or !self.Ability.id then return end 
    if not self:Alive() then self:DeathAbility(true) return end -- idk if it was causing problems but why not?
    --local origAbility = abilities[self.Ability.id]
    --if !origAbility then return end 
    if self.Ability.UsesCount and self.Ability.UsesCount <= 0 then
        return 
    end
    if self.Ability.passive then return end 
 if not self.Ability.customUse then 
    if self.Ability.PlyCooldown <= CurTime() then
        hook.Call("PlayerAbilityUse",nil,self)
        print("Ability Activated")
        self.Ability.use(self)
        self.Ability.active = true
        net.Start("ActiveState")
        net.WriteBool(true)
        net.Send(self)
        timer.Create("AbilityUse"..self:SteamID64(),self.Ability.usetime,1,function()
            self.Ability.active = false 
            net.Start("ActiveState")
            net.WriteBool(false)
            net.Send(self)
        end)
        if self.Ability.FirstUsed == true then
            self.Ability.FirstUsed = false
        else 
            self.Ability.FirstUsed = true
        end
        self.Ability.PlyCooldown = CurTime() + self.Ability.cooldown
        self.Ability.PlyUseCD = CurTime() + self.Ability.usetime
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
    self.Ability.use(self)
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
    --local origAbility = abilities[target.Ability.id]
        if target.Ability.id == "berserk" and target.Ability.active then
            dmg:ScaleDamage(0.3)
        end
        if target.Ability.id == "swansong" and !target.Ability.SwanCD then
            target.Ability.use(target)
            return true 
        end
    end
end)

hook.Add("PlayerShouldTakeDamage","AbilityShouldTakeDamage",function(ply,attacker)
    if ply.Ability then
        if ply.Ability.id == "swansong" and ply.Ability.SwanCD then
            return false 
        end
    end
end)

hook.Add("FinishMove","AbilityFinishMove",function(ply,mv)
    if ply.Ability then
        if ply.Ability.id == "swansong" and ply.Ability.SwanCD and ply.Ability.SwanCD <= CurTime() then
            ply:Kill()
        end
    end

end)

hook.Add("DoPlayerDeath","AbilityPlayerDeath",function(ply,attacker,dmg)
    if attacker:IsPlayer() and ply != attacker then
        if attacker.Ability and attacker.Ability.id == "swansong" then
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
