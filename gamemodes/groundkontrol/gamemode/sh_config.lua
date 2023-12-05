AddCSLuaFile()

local pl = FindMetaTable("Player")

function pl:GetSteamIDPData( name, default )

	name = Format( "%s[%s]", self:SteamID(), name )
	local val = sql.QueryValue( "SELECT value FROM playerpdata WHERE infoid = " .. SQLStr( name ) .. " LIMIT 1" )
	if ( val == nil ) then return default end

	return val

end

function pl:SetSteamIDPData( name, value )

	name = Format( "%s[%s]", self:SteamID(), name )
	return sql.Query( "REPLACE INTO playerpdata ( infoid, value ) VALUES ( " .. SQLStr( name ) .. ", " .. SQLStr( value ) .. " )" ) ~= false

end

function pl:RemoveSteamIDPData( name )

	name = Format( "%s[%s]", self:SteamID(), name )
	return sql.Query( "DELETE FROM playerpdata WHERE infoid = " .. SQLStr( name ) ) ~= false

end

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


GM.NewVoteTime = 35
GM.NewGolosArgs = {
{helptext = "Enable class system?",cvar = "gc_roles_enable"},
{helptext = "Enable crippling mechanic?",cvar = "gc_crippling"},
{helptext = "Enable NVGs?",cvar = "gc_nvg_enable"},
{helptext = "Draw ammo for CW 2.0 weapon more realistic or stupid(Wont work with holographic HUD disabled)",cvar = "gc_ammotextoverride_enable"},
{helptext = "Hide holographic ammo HUD for weapons?",cvar = "gc_ammotexthide_enable"},
{helptext = "Draw crosshair for weapons?",cvar = "gc_crosshair_sv_enable"},
{helptext = "Enable special rounds?",cvar = "gc_specround_enable"},
{helptext = "Enable abilities for classes?(Wont work without classes enable)",cvar = "gc_abil_enable"}, 
{helptext = "Enable team damage?",cvar = "gc_team_damage"},
{helptext = "Enable leaning?",cvar = "gc_lean_enable"},
{helptext = "Enable stun mechanic?",cvar = "gc_stun_enable"},
{helptext = "Give only the commander the opportunity to distinguish allies?",cvar = "gc_commander_visibility"},
{helptext = "Enable VManip animations?",cvar = "gc_vmanip_enable"},
{helptext = "Enable ability to hear only teammates?",cvar = "gc_proximity_voicechat"}, --gc_proximity_voicechat
} --

--[[
	if you wish to setup specific things for the gamemode SHARED (clientside and serverside), you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--