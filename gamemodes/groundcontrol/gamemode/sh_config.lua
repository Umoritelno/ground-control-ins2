AddCSLuaFile()

GM.CurSpecRound = "None"

function GM:AddSpecRound(data)
    self.SpecRounds[table.Count(GM.SpecRounds) + 1] = data 
end 

function GM:GetSpecRound()
   return self.CurSpecRound
end 

GM:AddSpecRound(
	{
		name = "WW2 TDM",
		description = "Что за хуйня здесь происходит?",
        weapontable = {
			"cw_kk_ins2_mp40",
			"cw_kk_ins2_mosin",
			"cw_kk_ins2_cstm_m14",
		},
		postLoadout = function(ply)
			ply:RemoveAllAmmo()
			ply:StripWeapons()
			ply:Give(self:GetSpecRound().weapontable[math.random(1,table.Count(self:GetSpecRound().weapontable))])
		end,
		giveloadout = true,
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

--[[GM.Roles = {
	["Soldier"] = {
		Description = "You are soldier. Stay close to the squad and follow the orders of the commander."
	},
	["Specialist"] = {
		Description = "You are specialist. Use your gear to complete the task."
	},
	["Commander"] = {
      Description = "You are commander of your squad. Lead your squad."
	},
	["Demoman"] = {
		Description = "You are demoman. Use your weapons to wipe enemies off the face of the earth"
	},
}
--]]

GM.NewGolosArgs = {"gc_roles_enable","gc_crippling"}

--[[
	if you wish to setup specific things for the gamemode SHARED (clientside and serverside), you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--