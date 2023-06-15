AddCSLuaFile()
if SERVER then
    util.AddNetworkString("SpecRoundUpdate")
end

GM.DefaultSpecRoundDelay = 4 -- in rounds
GM.GlobalSpecRound = GM.DefaultSpecRoundDelay
GM.SpecRounds = {}

function GM:AddSpecRound(data)
    self.SpecRounds[table.Count(GM.SpecRounds) + 1] = data 
end 

function GM:GetSpecRound()
   return self.CurSpecRound
end 

if CLIENT then
    net.Receive("SpecRoundUpdate",function()
        local roundid = net.ReadInt(32)
        local roundcount = net.ReadInt(31)
        if not GAMEMODE.specRoundEnabled then
            GAMEMODE.specRoundEnabled = true 
        end
        GAMEMODE.GlobalSpecRound = roundcount
        if roundid != -1 then
            print("Spec Round Time")
            GAMEMODE.CurSpecRound = roundid
        else 
            GAMEMODE.CurSpecRound = nil 
        end
    end)

    hook.Add( "CalcView", "PerevertishCalcView", function( ply, pos, angles, fov )
        if GAMEMODE.CurSpecRound == 1 then
            local view = {
                origin = origin,
                angles = angles,
                fov = fov,
                drawviewer = false
            }
            angles.r = 180 -- hehe
        
            return view
        end
    end )
end

GM:AddSpecRound(
	{
		name = "Перевертыш",
		description = "Что за хуйня здесь происходит?",
	}
)

function GM:parseTFAWeapon(data)
    local walkSpeed = self.BaseRunSpeed
    local output = {
        Shots = data.Primary.NumShots,
        Damage = data.Primary.Damage,
        GCRecoil = data.Primary.StaticRecoilFactor,
        AimSpread = data.Primary.IronAccuracy,
        FireDelay = data.Primary.RPM,
        HipSpread = data.Primary.Spread,
        SpreadPerShot = data.Primary.SpreadIncrement,
        VelocitySensitivity = 1,
        MaxSpreadInc = data.Primary.SpreadMultiplierMax,
        SpeedDec = 25,
        weight = data.weight
    }
    return output
end

function GM:parseARC9Weapon(data)
    local walkSpeed = self.BaseRunSpeed
    local output = {
        Shots = 1,  -- data.Num
        Damage = data.DamageMax,
        GCRecoil = data.RecoilPatternDrift,
        AimSpread = 5,
        FireDelay = data.RPM,
        HipSpread = data.Spread,
        SpreadPerShot = 2.5,  --data.SpreadAddRecoil
        VelocitySensitivity = 1,
        MaxSpreadInc = 25,
        SpeedDec = 25,
        weight = data.weight
    }
    return output
end

GM.NewGolosArgs = {"gc_roles_enable","gc_crippling"}

--[[
	if you wish to setup specific things for the gamemode SHARED (clientside and serverside), you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--