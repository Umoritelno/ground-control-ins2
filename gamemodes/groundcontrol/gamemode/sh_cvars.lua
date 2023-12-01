AddCSLuaFile()

GM.AutoUpdateConVars = {}

function GM:registerAutoUpdateConVar(cvarName, onChangedCallback)
	self.AutoUpdateConVars[cvarName] = onChangedCallback
	
	cvars.AddChangeCallback(cvarName, onChangedCallback)
end

function GM:performOnChangedCvarCallbacks()
	for cvarName, callback in pairs(self.AutoUpdateConVars) do
		local curValue = GetConVar(cvarName)
		local finalValue = curValue:GetFloat() or curValue:GetString() -- we don't know whether the callback wants a string or a number, so if we can get a valid number from it, we will use that if we can't, we will use a string value
		
		callback(cvarName, finalValue, finalValue,true)
	end
end

local sharedCVar = FCVAR_ARCHIVE + FCVAR_NOTIFY + FCVAR_REPLICATED

CreateConVar("gc_lean_enable",1,sharedCVar,"Enable leaning?")
CreateConVar("gc_lean_delay",1.75,sharedCVar,"Delay after leaning",0)
CreateConVar("gc_ammotextOverride_enable",1,sharedCVar,"Override ammo text for CW 2.0 weapons?")
CreateConVar("gc_ammotextHide_enable",0,sharedCVar,"Hide ammo text for weapons?")
CreateConVar("gc_crosshair_sv_enable",0,sharedCVar,"Draw crosshair for CW 2.0 Default & TFA weapons?")
CreateConVar("gc_specround_enable",1,sharedCVar,"Will special rounds work?")
CreateConVar("gc_crippling", 1, sharedCVar, "is the crippling gameplay mechanic enabled?")
CreateConVar("gc_round_prep_time", GM.RoundPreparationTime, sharedCVar, "how much time players spend in the preparation stage of the new round")
CreateConVar("gc_round_restart_time", GM.RoundRestartTime, sharedCVar, "amount of time before the next round starts")
CreateConVar("gc_walkspeedmult", GM.BaseWalkSpeedMult, sharedCVar, "player walk speed mult (ONLY ON NEXT SPAWN)",0)
CreateConVar("gc_runspeedmult", GM.BaseRunSpeedMult, sharedCVar, "player run speed mult (ONLY ON NEXT SPAWN)",0)
CreateConVar("gc_damagemult", GM.DamageMultiplier, sharedCVar, "multiplier for dealt weapon damage")
CreateConVar("gc_damage_scale", GM.DefaultDamageScale, sharedCVar, "multiplier for all weapon damage")
CreateConVar("gc_wepbase",GM.DefBase,sharedCVar,"What weapon base we will use?")
CreateConVar("gc_roles_enable",1,sharedCVar,"Will roles and work?")
CreateConVar("gc_abil_enable",1,sharedCVar,"Will abilities work?")
CreateConVar("gc_nvg_enable",1,sharedCVar,"Will NVG work?")
CreateConVar("gc_stun_enable",1,sharedCVar,"Will stun work?")
CreateConVar("gc_commander_visibility",0,sharedCVar,"Give only the commander the opportunity to distinguish allies?")
CreateConVar("gc_vmanip_enable",1,sharedCVar,"Enable VManip animations?")

--GM.CurWepBase = GetConVar("gc_wepbase"):GetInt() or 1
if GM.WepBases[GetConVar("gc_wepbase"):GetInt()] then
	GM.CurWepBase = GetConVar("gc_wepbase"):GetInt()
else
	print("invalid weapon base. Using default")
	if SERVER then
		game.ConsoleCommand("gc_wepbase 2\n")
	end
	GM.CurWepBase = 2
end

local function getCvarNumber(new, old)
	return tonumber(new) and new or old
end

if SERVER then

	GM:registerAutoUpdateConVar("gc_vmanip_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("VManipEnabled",bool)
	end)

	GM:registerAutoUpdateConVar("gc_commander_visibility", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("CommanderVisibility",bool)
	end)
	
	GM:registerAutoUpdateConVar("gc_stun_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("StunEnabled",bool)
		if !isAuto then 
		  if !bool then
			for k,v in pairs(GAMEMODE.currentPlayerList) do
				v:AddStun(-100)
			 end
		  end
		end
	end)
	
	GM:registerAutoUpdateConVar("gc_ammotextOverride_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("AmmoTextChanged",bool)
	end)

	GM:registerAutoUpdateConVar("gc_ammotextHide_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("AmmoTextDisabled",bool)
	end)

	GM:registerAutoUpdateConVar("gc_crosshair_sv_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("CrosshairEnabled",bool)
	end)
	
	GM:registerAutoUpdateConVar("gc_lean_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("LeanEnabled",bool)
	end)

	GM:registerAutoUpdateConVar("gc_lean_delay", function(name, old, new,isAuto)
		SetGlobalFloat("LeanDelay",new)
	end)
	
	GM:registerAutoUpdateConVar("gc_nvg_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("NVGEnabled",bool)
		if !isAuto and !bool then 
			for k,pl in pairs(GAMEMODE.currentPlayerList) do
			   if pl:NVGBASE_IsGoggleActive() then
	
				 local loadout = pl:NVGBASE_GetLoadout();
				 if (loadout == nil) then return; end
	
				 pl:NVGBASE_ToggleGoggle(loadout,nil)
			   end
			end
		end
	end)
	
	GM:registerAutoUpdateConVar("gc_specround_enable", function(name, old, new,isAuto)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("SpecRoundEnabled",bool)
	end)
	
	GM:registerAutoUpdateConVar("gc_abil_enable", function(name, old, new)
		GAMEMODE.abilityEnabled = tonumber(new) and tonumber(new) > 0
	end)
	
	GM:registerAutoUpdateConVar("gc_crippling", function(name, old, new)
		GAMEMODE.cripplingEnabled = tonumber(new) and tonumber(new) > 0
	end)
	
	GM:registerAutoUpdateConVar("gc_roles_enable", function(name, old, new)
		local bool = tonumber(new) and tonumber(new) > 0
		SetGlobalBool("RolesEnabled",bool)
	end)
	
	GM:registerAutoUpdateConVar("gc_round_prep_time", function(name, old, new)
		GAMEMODE.RoundPreparationTime = getCvarNumber(new, GAMEMODE.RoundPreparationTime)
	end)
	
	GM:registerAutoUpdateConVar("gc_round_restart_time", function(name, old, new)
		GAMEMODE.RoundRestartTime = getCvarNumber(new, GAMEMODE.RoundRestartTime)
	end)
	
	GM:registerAutoUpdateConVar("gc_runspeedmult", function(name, old, new)
		GAMEMODE.BaseRunSpeedMult = getCvarNumber(new, GAMEMODE.BaseRunSpeedMult)
	end)
	
	GM:registerAutoUpdateConVar("gc_walkspeedmult", function(name, old, new)
		GAMEMODE.BaseWalkSpeedMult = getCvarNumber(new, GAMEMODE.BaseWalkSpeedMult)
	end)
	
	GM:registerAutoUpdateConVar("gc_damage_scale", function(cvarName, old, new)	
		GAMEMODE.DamageMultiplier = getCvarNumber(new, GAMEMODE.defaultDamageScale)
	end)
end

if SERVER then
    GM.defaultAFKTimerValue = 240 -- default amount of time to wait before kicking someone out for AFK
    GM.defaultTeamDamageScale = 0.6 -- mult for team damage
    CreateConVar("gc_proximity_voicechat", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- if set to 1, nearby enemies will be able to hear other enemies speak
    CreateConVar("gc_proximity_voicechat_distance", 256, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- distance in source units within which players will hear other players
    CreateConVar("gc_proximity_voicechat_global", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- if set to 1, everybody, including your team mates and your enemies, will only hear each other within the distance specified by gc_proximity_voicechat_distance
    CreateConVar("gc_proximity_voicechat_directional", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- if set to 1, voice chat will be directional 3d sound (as described in the gmod wiki)
    CreateConVar("gc_invincibility_time_period", 3, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- how long should the player be invincible for after spawning (for anti spawn killing in gametypes like urban warfare)
    CreateConVar("gc_team_damage", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- whether team damage is enabled
    CreateConVar("gc_team_damage_scale", GM.defaultTeamDamageScale, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- scale the same-team damage by this much
    CreateConVar("gc_afk_timer", GM.defaultAFKTimerValue, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- time in seconds that a player can remain without any input before we kick him out

    GM:registerAutoUpdateConVar("gc_proximity_voicechat", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        GAMEMODE.proximityVoiceChat = newValue >= 1
    end)

    GM:registerAutoUpdateConVar("gc_proximity_voicechat_distance", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        GAMEMODE.proximityVoiceChatDistance = newValue
    end)

    GM:registerAutoUpdateConVar("gc_proximity_voicechat_global", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        GAMEMODE.proximityVoiceChatGlobal = newValue >= 1
    end)

    GM:registerAutoUpdateConVar("gc_proximity_voicechat_directional", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        GAMEMODE.proximityVoiceChatDirectional3D = newValue >= 1
    end)

    GM:registerAutoUpdateConVar("gc_invincibility_time_period", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        GAMEMODE.postSpawnInvincibilityTimePeriod = newValue or 3
    end)

    GM:registerAutoUpdateConVar("gc_team_damage", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        GAMEMODE.noTeamDamage = newValue <= 0
    end)

    GM:registerAutoUpdateConVar("gc_team_damage_scale", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue)
        
        GAMEMODE.teamDamageScale = newValue or GAMEMODE.defaultTeamDamageScale
    end)

    GM:registerAutoUpdateConVar("gc_afk_timer", function(cvarName, oldValue, newValue)
        newValue = tonumber(newValue) or GAMEMODE.defaultAFKTimerValue
        
        GAMEMODE.afkTime = newValue
    end)
end