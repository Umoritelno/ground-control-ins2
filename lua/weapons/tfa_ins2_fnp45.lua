SWEP.Base					= ( TFA and DVL ) and "tfa_devl_base" or "tfa_gun_base"                    -- Weapon Base
SWEP.Category				= ( TFA and TFA.Yankys_Custom_Weapon_Pack_Categories ) and "[TFA] [AT] [ Pistols ]" or "TFA Insurgency" 
SWEP.PrintName				= ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "FN FNP-45" or "FNP-45"   		           
SWEP.Type                   = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "Type: Semi-Automatic Pistol - Caliber: .45 ACP - Muzzle Velocity: 330 m/s" or "Pistol"
SWEP.Manufacturer 			= "FN Herstal"                      -- Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Purpose				= "A .45 ACP Special Pistol."       -- Purpose Tooltip
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
 
--[[ WEAPON HANDLING ]]--

SWEP.Primary.Sound          = Sound("TFA_INS2.FNP45.Fire")            -- This is the sound of the weapon, when you shoot.
SWEP.Primary.SilencedSound  = Sound("TFA_INS2.FNP45.Fire_Suppressed") -- This is the sound of the weapon, when silenced.

SWEP.Primary.SoundEchoTable = {
	[0]   = Sound("TFA_MWR_PIST.TailInside"), 
	[256] = Sound("TFA_MWR_USP45.TailOutside")
}

SWEP.Primary.Damage                = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and 62 * TFA.Yankys_Custom_Weapon_Pack.DamageMultiplier or 42
SWEP.Primary.DamageTypeHandled     = true                       -- true will handle damagetype in base
SWEP.Primary.DamageType            = nil                        -- See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect.  DMG_AIRBOAT opens doors.
SWEP.Primary.PenetrationMultiplier = 0.965                      -- Change the amount of something this gun can penetrate through
SWEP.Primary.Velocity              = 330                        -- Bullet Velocity in m/s
SWEP.Primary.NumShots              = 1                          -- The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.

SWEP.Primary.Automatic             = false                      -- Automatic/Semi Auto
SWEP.Primary.RPM                   = 420                        -- This is in Rounds Per Minute / RPM

SWEP.Primary.Force                 = nil                        -- Force value, leave nil to autocalc
SWEP.Primary.Knockback             = nil                        -- Autodetected if nil; this is the velocity kickback
SWEP.Primary.HullSize              = 0                          -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.

-- Miscelaneous Sounds
SWEP.IronInSound                   = nil                        -- Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound                  = nil                        -- Sound to play when ironsighting out?  nil for default

--[[ Ammo Related ]]--

SWEP.Primary.ClipSize              = 15                         -- This is the size of a clip
SWEP.Primary.DefaultClip           = SWEP.Primary.ClipSize * 13  -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo                  = "pistol"                   -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption       = 1                          -- Ammo consumed per shot
SWEP.DisableChambering             = false                      -- Disable round-in-the-chamber
SWEP.CanJam                        = true

--[[ Selective Fire Stuff ]]--

SWEP.SelectiveFire               = false                        -- Allow selecting your firemode?
SWEP.DisableBurstFire            = false                        -- Only auto/single?
SWEP.OnlyBurstFire               = false                        -- No auto, only burst/single?
SWEP.DefaultFireMode             = ""                           -- Default to auto or whatev
SWEP.FireModeName                = nil                          -- Change to a text value to override it

--[[ Recoil Related ]]--

SWEP.Primary.KickUp              = 0.6                          -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown            = 0.605                        -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal      = 0.315                        -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor  = 0.715                        -- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

--[[ Firing Cone Related ]]--

SWEP.Primary.Spread              = .013                         -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy        = .0044                        -- Ironsight accuracy, should be the same for shotguns

-- Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.

SWEP.Primary.SpreadMultiplierMax = 4.9                          -- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     = 1.5                          -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      = 5.45                         -- How much the spread recovers, per second. Example val: 3

--[[ Movespeed ]]--

SWEP.MoveSpeed                = 1                               -- Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed      = 0.965                           -- Multiply the player's movespeed by this when sighting.

--[[ Range Related ]]--

SWEP.Primary.Range            = 0.25 * (3280.84 * 16)           -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff     = 0.85                            -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

SWEP.Primary.RangeFalloffLUT = {
	bezier     = true,
	
	range_func = "quintic",
	units      = "meters",
	
	lut = {
		{range = 0, damage = 1},
		{range = 100, damage = 1},
		{range = 150, damage = 1},
		{range = 200, damage = 0.90},
		{range = 250, damage = 0.85},
		{range = 300, damage = 0.75},
		{range = 400, damage = 0.65},
	}
}

--[[ Penetration Related ]]--

SWEP.MaxPenetrationCounter    = 3                               -- The maximum number of ricochets.  To prevent stack overflows.

--[[ Misc ]]--

SWEP.IronRecoilMultiplier     = 0.82                            -- Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 0.75                            -- Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

--[[EFFECTS]]--

-- Attachments
SWEP.MuzzleFlashEnabled          = true                         -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw         = nil                          -- This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.MuzzleFlashEffect           = ( TFA and TFA.YanKys_Realistic_Muzzleflashes ) and "tfa_muzzleflash_m1911" or "tfa_muzzleflash_pistol"     -- Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.

SWEP.MuzzleAttachment			 = "muzzle" 		            -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			 = "shell" 		                -- Should be "2" for CSS models or "shell" for hl2 models

SWEP.AutoDetectMuzzleAttachment  = false                        -- For multi-barrel weapons, detect the proper attachment?
SWEP.SmokeParticle               = nil                          -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled        = false                        -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject               = true                         -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay          = 0                            -- The delay to actually eject things
SWEP.LuaShellEffect              = "ShellEject"                 -- The effect used for shell ejection; Defaults to that used for blowback

-- Tracer Stuff
SWEP.TracerName 		         = nil 	                        -- Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		         = 1 	                        -- 0 disables, otherwise, 1 in X chance

--[[ VIEWMODEL ]]--

SWEP.ViewModel		= "models/weapons/c_ins2_pist_fnp45.mdl"    -- Viewmodel path

SWEP.VMPos          = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and Vector(-0.85, 0, -0.05) or Vector(-0.15, 0, -0.1)
SWEP.VMAng          = Vector(0.1, 0, 0)
SWEP.VMPos_Additive = false                                     -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.ViewModelFOV   = 70		                                -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip  = false		                                -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands       = true                                      -- Use gmod c_arms system.
  
SWEP.CenteredPos    = nil                                       -- The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng    = nil                                       -- The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.Bodygroups_V   = {}

--[ ANIMATION ]--

SWEP.StatusLengthOverride   = {
	[ACT_VM_RELOAD]         = 61 / 30,
	[ACT_VM_RELOAD_EMPTY]   = 72.5 / 30
} -- Changes the status delay of a given animation; only used on reloads.  Otherwise, use SequenceLengthOverride or one of the others

SWEP.SequenceLengthOverride = {
	[ACT_VM_RELOAD]         = 78 / 30,
	[ACT_VM_RELOAD_EMPTY]   = 78 / 30
} -- Changes both the status delay and the nextprimaryfire of a given animation

SWEP.SequenceRateOverride   = {	
    [ACT_VM_RELOAD]         = 1.05,
	[ACT_VM_RELOAD_EMPTY]   = 1.05
} 

SWEP.ProceduralHoslterEnabled = nil
SWEP.ProceduralHolsterTime    = 0.3
SWEP.ProceduralHolsterPos     = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng     = Vector(-40, -30, 10)

SWEP.Sights_Mode              = TFA.Enum.LOCOMOTION_HYBRID     -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation

SWEP.Sprint_Mode              = TFA.Enum.LOCOMOTION_ANI        -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult            = 0.35
SWEP.SprintFOVOffset          = 5

SWEP.Idle_Mode                = TFA.Enum.IDLE_BOTH             -- TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend               = 0.25                           -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth              = 0.05                           -- Start an idle this far early into the end of another animation

--[ MDL Animations Below ]--

SWEP.IronAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,                      -- Sequence or act
		["value"] = "base_idle",                                -- Number for act, String/Number for sequence
		["value_empty"] = "empty_idle"
	},
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT,                      -- Sequence or act
		["value"] = ACT_VM_PRIMARYATTACK_1,                     -- Number for act, String/Number for sequence
		["value_last"] = ACT_VM_PRIMARYATTACK_2,
		["value_empty"] = ACT_VM_PRIMARYATTACK_3
	}
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,                      -- Sequence or act
		["value"] = "base_sprint",                              -- Number for act, String/Number for sequence
		["value_empty"] = "empty_sprint",
		["is_idle"] = true
	}
}

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.AllowViewAttachment    = true 

--[[ WORLDMODEL ]]--

SWEP.WorldModel	    = "models/weapons/w_ins2_pist_fnp45.mdl"    -- Weapon world model path
SWEP.Bodygroups_W   = {}                                        -- Weapon World model BodyGroups

SWEP.HoldType       = "pistol" 

-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { 
	Pos = {
		Up = -1.2,
		Right = 1.2,
		Forward = 4.5
	},
	Ang = {
		Up = -1,
		Right = -5,
		Forward = 180
	},
	Scale = 1
} -- Procedural world model animation, defaulted for CS:S purposes.

SWEP.ThirdPersonReloadDisable  = false   -- Disable third person reload?  True disables.

-- [[ IRONSIGHTS ]] --

SWEP.data = {}
SWEP.data.ironsights   = 1  -- Enable Ironsights

SWEP.Secondary.IronFOV = 80 -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsReloadEnabled = true
SWEP.IronSightsReloadLock    = false

SWEP.IronSightsPos     = Vector(-1.8565, 0, 0.32)
SWEP.IronSightsAng     = Vector(0.1, -0.01, 0)

SWEP.IronSightsPos_RMR = Vector(-1.8565, 0, 0.285)
SWEP.IronSightsAng_RMR = Vector(-0.93, -0.03, 0)

SWEP.IronSightsPos_Point_Shooting = Vector(-4, 0, -1)
SWEP.IronSightsAng_Point_Shooting = Vector(0, 0, -30)
SWEP.Secondary.Point_Shooting_FOV = 70 

--[[ SPRINTING ]]--

SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-8.5, 5, -5)

--[[ CROUCHING ]] --

SWEP.CrouchPos    = Vector(-1.82, -1, -1.2)
SWEP.CrouchAng    = Vector(0, 0, -20)

--[[ INSPECTION ]] --

SWEP.InspectPos   = Vector(4, -4, -3) 
SWEP.InspectAng   = Vector(20, 35, 0)

--[[ ATTACHMENTS ]]--

SWEP.Attachments = {
	[1] = { atts = { "ins2_eft_rmr"} },
	[2] = { atts = { "ins2_br_heavy", "r6s_h_barrel", "r6s_muzzle_2", "r6s_flashhider_2", "bo2_longbarrel", "ins2_br_supp", "ins2_eft_aac", "ins2_eft_osprey" } },
	[3] = { atts = { "ins2_ub_laser", "ins2_laser_flashlight_x400", "ins2_ub_flashlight", "ins2_eft_lastac2" } },
	[4] = { atts = { "ins2_mag_ext_fnp45" } },
	[5] = { atts = { "tfa_tactical_point_shooting" } }, 
    [6] = { atts = { "tfa_yanks_wpn_pack_sleight_of_hand", "tfa_yanks_wpn_pack_quick_draw", "bo2_rapidfire", "bo2_quickdraw" }},
	[7] = { atts = { "am_match", "am_magnum", "am_gib", "tfa_mb_penrnd" } },
}

SWEP.AttachmentDependencies = {	
    ["tfa_tactical_point_shooting"] = {"ins2_ub_laser", "ins2_laser_flashlight_x400", "ins2_ub_flashlight", "ins2_eft_lastac2"},
}

SWEP.AttachmentExclusions   = {}

SWEP.ViewModelBoneMods = {
	["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
	["A_Suppressor"] = { scale = Vector(0.97, 0.97, 0.96), pos = Vector(0, -0.04, 0.05), angle = Angle(0, 0, 0) },
	["A_Underbarrel"] = { scale = Vector(1.05, 1.05, 1.05), pos = Vector(0, -1.4, -0.28), angle = Angle(0, 0, 0) },
	["R UpperArm"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0.08), angle = Angle(0, 0, 0) },	
	["Trigger"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.065, 0), angle = Angle(0, 0, 0) },
--	["R Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
--	["R Finger0"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
--	["R Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
--	["R Finger12"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

local wmscale = Vector(1 / 1.3, 1 / 1.3, 1 / 1.3)

SWEP.WorldModelBoneMods = {
	["Muzzle"] = { scale = wmscale, pos = Vector(-0.25, 0, 0), angle = Angle(0, 0, 0) },
	["ATTACH_Laser"] = { scale = wmscale, pos = Vector(-1, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.VElements = {
	["mag"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_15.mdl", bone = "Magazine", rel = "", pos = Vector(90, 0, 90), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true, bonemerge = true },
	["mag_ext"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_18.mdl", bone = "Magazine", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_cz75a.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-0.7, 0, 0.3), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(0, 0, -0.5), angle = Angle(0, 0, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["laser_x400"] = { type = "Model", model = "models/weapons/upgrades/a_laser_p320.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, active = false, bodygroup = {} },
	["laser_beam_x400"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "LaserPistol", rel = "laser_x400", pos = Vector(0, 0, -0.45), angle = Angle(0, 90, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	
	["sight_rmr"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_rmr.mdl", bone = "Slide", rel = "", pos = Vector(0, -1.35, 0.582), angle = Angle(0, 180, 0), size = Vector(0.7, 0.8, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["sight_rmr_lens"] = (TFA.EFTC and TFA.EFTC.GetHoloSightReticle) and TFA.EFTC.GetHoloSightReticle("sight_rmr") or nil,

	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-2, 0, 0.6), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["flashlight_lastac"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_lastac.mdl", bone = "A_Underbarrel", rel = "", pos = Vector(-2.75, 0, 0.2), angle = Angle(0, -90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["suppressor_osprey"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_osprey.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.85, 0.95, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["suppressor_aac"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_aac.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0.01), angle = Angle(0, 0, 0), size = Vector(1.1, 1.1, 1.1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
}

SWEP.WElements = {
	["mag"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_15.mdl", bone = "W_PIS_MAGAZINE", rel = "", pos = Vector(2.2, -13.1, 4), angle = Angle(0, -90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = true, bonemerge = false },
	["mag_ext"] = { type = "Model", model = "models/weapons/upgrades/a_magazine_fnp45_18.mdl", bone = "W_PIS_MAGAZINE", rel = "", pos = Vector(2.2, -13.1, 4), angle = Angle(0, -90, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = false },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_pistol.mdl", bone = "ATTACH_Muzzle", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, active = false, bodygroup = {} },
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_sec.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(1.2, 10.7, 0), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_sec.mdl", bone = "ATTACH_Laser", rel = "", pos = Vector(1.2, 10.7, 0), angle = Angle(180, 0, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
}

SWEP.MuzzleAttachmentSilenced     = 1

SWEP.LaserSightModAttachment      = 1
SWEP.LaserSightModAttachmentWorld = 0
SWEP.LaserDotISMovement           = true

DEFINE_BASECLASS( SWEP.Base ) -- Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.

if TFA.Yankys_Custom_Weapon_Pack then

    SWEP.AmmoTypeStrings = {
	    pistol = ".45 ACP M1911 AP"
    }

    function SWEP:OnCustomizationOpen()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Open")
    end

    function SWEP:OnCustomizationClose()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Close")
    end

end