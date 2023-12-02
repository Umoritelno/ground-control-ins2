SWEP.Base					= ( TFA and DVL ) and "tfa_devl_base" or "tfa_gun_base"                    -- Weapon Base
SWEP.Category               = ( TFA and TFA.Yankys_Custom_Weapon_Pack_Categories ) and "[TFA] [AT] [ Pistols ]" or "TFA Insurgency"   
SWEP.PrintName				= ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "S&W M500" or "S&W 500"   		           
SWEP.Manufacturer           = "Smith & Wesson"                  -- Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Purpose				= "A overpowered .500 S&W Magnum Double Action Revolver."
SWEP.Instructions			= ""              

SWEP.Author				    = "XxyanKy700xX"                    -- Author Tooltip
SWEP.Contact				= "https://steamcommunity.com/profiles/76561198296543672/" 

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true                              -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		                        -- Draw the crosshair?
SWEP.DrawCrosshairIS		= false                             -- Draw the crosshair in ironsights?

SWEP.Slot					= 1			                        -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			                    -- Position in the slot
SWEP.AutoSwitchTo			= true		                        -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		                        -- Auto switch from if you pick up a better weapon
SWEP.Weight					= 30			                    -- This controls how "good" the weapon is for autopickup.
SWEP.Type                   = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "Type: Double-Action Revolver - Caliber: .500 S&W Magnum - Muzzle Velocity: 632 m/s" or "Revolver"

--[[WEAPON HANDLING]]--

SWEP.Primary.Sound          = Sound("TFA_INS2.SW500.Fire") -- This is the sound of the weapon, when you shoot.

SWEP.Primary.SoundEchoTable = {
	[0]   = Sound("TFA_MWR_PIST.TailInside"), 
	[256] = Sound("TFA_MWR_MAGNUM.TailOutside") 
}

SWEP.Primary.Damage                = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and 185 * TFA.Yankys_Custom_Weapon_Pack.DamageMultiplier or 180
SWEP.Primary.DamageTypeHandled     = true                       -- true will handle damagetype in base
SWEP.Primary.DamageType            = nil                        -- See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect.  DMG_AIRBOAT opens doors.
SWEP.Primary.PenetrationMultiplier = 0.85                       -- Change the amount of something this gun can penetrate through
SWEP.Primary.Velocity              = 632                        -- Bullet Velocity in m/s
SWEP.Primary.NumShots              = 1                          -- The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.

SWEP.Primary.Automatic             = false                      -- Automatic/Semi Auto
SWEP.Primary.RPM                   = 150                        -- This is in Rounds Per Minute / RPM

SWEP.Primary.Force                 = nil                        -- Force value, leave nil to autocalc
SWEP.Primary.Knockback             = nil                        -- Autodetected if nil; this is the velocity kickback
SWEP.Primary.HullSize              = 0                          -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.

-- Miscelaneous Sounds --

SWEP.IronInSound                 = nil                          -- Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound                = nil                          -- Sound to play when ironsighting out?  nil for default

-- Ammo Related
SWEP.Primary.ClipSize            = 5                            -- This is the size of a clip
SWEP.Primary.DefaultClip         = SWEP.Primary.ClipSize * 13 
SWEP.Primary.Ammo                = "357"                        -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption     = 1                            -- Ammo consumed per shot

-- Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets
SWEP.DisableChambering           = true                         -- Disable round-in-the-chamber
SWEP.CanJam                      = true

-- Selective Fire Stuff
SWEP.SelectiveFire               = false                        -- Allow selecting your firemode?
SWEP.DisableBurstFire            = false                        -- Only auto/single?
SWEP.OnlyBurstFire               = false                        -- No auto, only burst/single?
SWEP.DefaultFireMode             = "Double-Action"              -- Default to auto or whatev
SWEP.FireModeName                = "Double-Action"              -- Change to a text value to override it

-- Recoil Related
SWEP.Primary.KickUp              = 2.32                         -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown            = 1.80                         -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal      = 1.80                         -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor  = 0.65                         -- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

-- Firing Cone Related
SWEP.Primary.Spread              = .0156                        -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy        = .0022                        -- Ironsight accuracy, should be the same for shotguns

-- Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.

SWEP.Primary.SpreadMultiplierMax = 10.05                        -- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     = 8.2                          -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      = 20                           -- How much the spread recovers, per second. Example val: 3

-- Range Related
SWEP.Primary.Range               = 0.5 * (3280.84 * 16)         -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff        = 0.70                         -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.


SWEP.Primary.RangeFalloffLUT = {
	bezier     = true,
	
	range_func = "quintic",
	units      = "meters",
	
	lut = {
		{range = 0, damage = 1},
		{range = 100, damage = 1},
		{range = 150, damage = 1},
		{range = 200, damage = 1},
		{range = 250, damage = 1},
		{range = 500, damage = 1},
		{range = 600, damage = 0.80},
		{range = 800, damage = 0.50},
	}
}

-- Penetration Related
SWEP.MaxPenetrationCounter       = 3                            -- The maximum number of ricochets.  To prevent stack overflows.

-- Misc
SWEP.IronRecoilMultiplier        = 0.8                          -- Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier    = 0.8                          -- Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

-- Movespeed
SWEP.MoveSpeed                   = 0.95                         -- Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed         = 0.90                         -- Multiply the player's movespeed by this when sighting.

--[[EFFECTS]]--

-- Attachments
SWEP.MuzzleFlashEnabled          = true                         -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw         = nil                          -- This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.MuzzleFlashEffect           = "tfa_muzzleflash_revolver"   -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.

SWEP.MuzzleAttachment			 = "muzzle" 		            -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			 = "shell" 		                -- Should be "2" for CSS models or "shell" for hl2 models

SWEP.AutoDetectMuzzleAttachment  = false                        -- For multi-barrel weapons, detect the proper attachment?
SWEP.SmokeParticle               = nil                          -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled        = false                        -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject               = false                        -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay          = 0                            -- The delay to actually eject things
SWEP.LuaShellEffect              = "ShellEject"                 -- The effect used for shell ejection; Defaults to that used for blowback
SWEP.LuaShellModel               = "models/hdweapons/shell.mdl"

-- Tracer Stuff
SWEP.TracerName 		         = nil 	                        -- Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		         = 1	                        -- 0 disables, otherwise, 1 in X chance

--[[VIEWMODEL]]--

SWEP.ViewModel		= "models/weapons/c_ins2_revolver_sw500.mdl"

SWEP.VMPos          = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and Vector(-0.75, 0, -0.25) or Vector(-0.32, 0, -0.25)
SWEP.VMAng          = Vector(0.3, 0, 0)                         -- The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false                                     -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.ViewModelFOV	= 70		                                -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip	= false		                                -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands       = true                                      -- Use gmod c_arms system.

SWEP.CenteredPos    = nil                                       -- The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng    = nil                                       -- The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.

SWEP.Bodygroups_V   = {}

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.AllowViewAttachment        = true                          -- Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.

--[[ANIMATION]]--

SWEP.StatusLengthOverride    = {
	[ACT_VM_RELOAD]          = 100 / 30,
	[ACT_VM_RELOAD_DEPLOYED] = 100 / 30,
} -- Changes the status delay of a given animation; only used on reloads.  Otherwise, use SequenceLengthOverride or one of the others

SWEP.SequenceLengthOverride     = {}                            -- Changes both the status delay and the nextprimaryfire of a given animation
SWEP.SequenceRateOverride       = {}                            -- Like above but changes animation length to a target
SWEP.SequenceRateOverrideScaled = {}                            -- Like above but scales animation length rather than being absolute

SWEP.ProceduralHoslterEnabled   = nil
SWEP.ProceduralHolsterTime      = 0.3
SWEP.ProceduralHolsterPos       = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng       = Vector(-40, -30, 10)

SWEP.Sights_Mode                = TFA.Enum.LOCOMOTION_HYBRID                -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation

SWEP.Sprint_Mode                = TFA.Enum.LOCOMOTION_ANI                   -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult              = 0.35
SWEP.SprintFOVOffset            = 5

SWEP.Idle_Mode                  = TFA.Enum.IDLE_BOTH                        -- TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend                 = 0.25                                      -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth                = 0.05                                      -- Start an idle this far early into the end of another animation

-- MDL Animations Below --

SWEP.IronAnimation = {
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT,                      -- Sequence or act
		["value"] = ACT_VM_PRIMARYATTACK_1,                     -- Number for act, String/Number for sequence
		["value_empty"] = ACT_VM_PRIMARYATTACK_3
	}
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,                      -- Sequence or act
		["value"] = "base_sprint",                              -- Number for act, String/Number for sequence
		["is_idle"] = true
	}
}

--[[EVENT TABLE]]--

SWEP.EventTable = {}                                            -- Event Table, used for custom events when an action is played.  This can even do stuff like playing a pump animation after shooting.

--[[WORLDMODEL]]--

SWEP.WorldModel		= "models/weapons/w_ins2_revolver_sw500.mdl"
SWEP.HoldType       = "revolver" 
SWEP.Bodygroups_W   = nil

-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { -- Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -1.35,
		Right = 1.5,
		Forward = 4
	},
	Ang = {
		Up = 0,
		Right = -2,
		Forward = 178
	},
	Scale = 1.1
} 

SWEP.ThirdPersonReloadDisable = false 

--[[IRONSIGHTS]]--

SWEP.data = {}
SWEP.data.ironsights   = 1  -- Enable Ironsights
SWEP.Secondary.IronFOV = 70 -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsReloadEnabled = true
SWEP.IronSightsReloadLock    = false

SWEP.IronSightsPos     = Vector(-2.0055, 0, 0.1)
SWEP.IronSightsAng     = Vector(-0.25, 0.025, 4.5)

SWEP.IronSightsPos_Point_Shooting = Vector(-4, -1, -1)
SWEP.IronSightsAng_Point_Shooting = Vector(0, 0, -30)
SWEP.Secondary.Point_Shooting_FOV = 70 

SWEP.IronSightsPos_Kobra       = Vector(-1.95, -0.5, -0.7)
SWEP.IronSightsAng_Kobra       = Vector(-0.4, 0.035, 4.5)

-- SWEP.IronSightsPos_EOTech   =  Vector(-4.28, -0.5, 0.68)
-- SWEP.IronSightsAng_EOTech   = Vector(-0.36, -0.025, 0)

SWEP.IronSightsPos_RDS         = Vector(-1.974, -1, -0.82)  
SWEP.IronSightsAng_RDS         = Vector(-0.5, -0.05, 4.5)

SWEP.IronSightsPos_2XRDS       = Vector(-1.944, -2.5, -0.915)
SWEP.IronSightsAng_2XRDS       = Vector(-0.62, 0, 4.5)
SWEP.Secondary.IronFOV_2XRDS   = 65
SWEP.RTScopeFOV_2XRDS          = 20
SWEP.RTOverlayTransforms_2XRDS = { 0, -0.35 }

SWEP.IronSightsPos_C79         = Vector(-1.96, -1.5, -0.745)
SWEP.IronSightsAng_C79         = Vector(-0.62, 0, 4.5)
SWEP.Secondary.IronFOV_C79     = 65
SWEP.RTScopeFOV_C79            = 25
SWEP.RTOverlayTransforms_C79   = { 0, -0.35 }

SWEP.IronSightsPos_MX4         = Vector(-1.97, 0, -0.75)
SWEP.IronSightsAng_MX4         = Vector(-0.58, 0, 4.5)
SWEP.Secondary.IronFOV_MX4     = 55
SWEP.RTScopeFOV_MX4            = 45
SWEP.RTOverlayTransforms_MX4   = { 0.0, -0.45 }

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(1.25, -6, -6)
SWEP.RunSightsAng = Vector(50, 0, 0)

--[[ CROUCHING ]] --

SWEP.CrouchPos    = Vector(-1.9, -1.5, -1.5)
SWEP.CrouchAng    = Vector(0, 0, -20)

--[[INSPECTION]]--

SWEP.InspectPos   = Vector(6, -6, -2.241) 
SWEP.InspectAng   = Vector(27, 42, 15.477)

--[[ATTACHMENTS]]--

SWEP.Attachments = {
	[1] = { atts = { "ins2_si_kobra", "ins2_si_rds", "ins2_si_2xrds", "ins2_si_c79", "ins2_si_mx4" } },
	[2] = { atts = { "ins2_br_heavy", "r6s_h_barrel", "r6s_muzzle_2", "r6s_flashhider_2", "bo2_longbarrel" } },
	[3] = { atts = { "ins2_ub_laser", "ins2_ub_flashlight" } },
	[4] = { atts = { "tfa_tactical_point_shooting" } },
	[5] = { atts = { "tfa_yanks_wpn_pack_sleight_of_hand", "tfa_yanks_wpn_pack_quick_draw", "bo2_rapidfire", "bo2_quickdraw" } },
	[6] = { atts = { "am_match", "am_magnum", "am_gib", "tfa_mb_penrnd", "sw500_410_bore_gauge" } },
}

SWEP.AttachmentDependencies = {	
    ["tfa_tactical_point_shooting"] = {"ins2_ub_laser", "ins2_ub_flashlight"},
}

SWEP.AttachmentExclusions   = {}

SWEP.ViewModelBoneMods = {
	["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
	["L UpperArm"] = { scale = Vector(0.925, 0.925, 0.925), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["R UpperArm"] = { scale = Vector(0.925, 0.925, 0.925), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_Optic"] = { scale = Vector(0.65, 0.65, 0.65), pos = Vector(0, 0.2, 0), angle = Angle(0, 0, 0) },
--	["A_LaserFlashlight"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["A_Suppressor"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.VElements = {
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,
	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_eotech_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_eotech") or nil,
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, -0.85), angle = Angle(90, 0, 90), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = false },
	["sight_rds_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_rds") or nil,
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_m40_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },

	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail_sw500.mdl", bone = "sw500-gun", rel = "", pos = Vector(0.05, -2.5, 0.52), angle = Angle(0, 90, 0), size = Vector(0.65, 0.65, 0.65), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "LaserPistol", rel = "laser", pos = Vector(0, -0.05, -0.8), angle = Angle(0, 0, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail_sw500.mdl", bone = "sw500-gun", rel = "", pos = Vector(0.05, -2.5, 0.52), angle = Angle(0, 90, 0), size = Vector(0.65, 0.65, 0.65), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },

--	["500_shells"] = { type = "Model", model = "models/weapons/a_standard_sw500_shells.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
--	["410_shells"] = { type = "Model", model = "models/weapons/a_standard_sw500_410_gauges.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 0, 90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
}

SWEP.WElements = {
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_kobra.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_eotech.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_aimpoint.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magaim.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_po.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_scope_m40.mdl", bone = "ATTACH_ModKit", rel = "", pos = Vector(-5.2, 3.7, 0.7), angle = Angle(0, 0, -90), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },

	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "", rel = "", pos = Vector(15, -2.2, -8), angle = Angle(-2.5, 6.5, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "", rel = "", pos = Vector(15, -2.2, -8), angle = Angle(-2.5, 6.5, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
}

SWEP.RTAttachment_2XRDS       = 2
SWEP.ScopeDistanceMin_2XRDS   = 55
SWEP.ScopeDistanceRange_2XRDS = 55

SWEP.RTAttachment_C79         = 2
SWEP.ScopeDistanceMin_C79     = 55
SWEP.ScopeDistanceRange_C79   = 55

SWEP.RTAttachment_MX4         = 2
SWEP.ScopeDistanceMin_MX4     = 55
SWEP.ScopeDistanceRange_MX4   = 55

DEFINE_BASECLASS( SWEP.Base )

if TFA.Yankys_Custom_Weapon_Pack then
	
    SWEP.AmmoTypeStrings = {
	    ["357"] = ".500 S&W AP"
    }

    function SWEP:OnCustomizationOpen()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Open")
    end

    function SWEP:OnCustomizationClose()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Close")
    end

end