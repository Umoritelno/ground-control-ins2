SWEP.Base					= ( TFA and DVL ) and "tfa_devl_base" or "tfa_gun_base"                   -- Weapon Base
SWEP.Category               = ( TFA and TFA.Yankys_Custom_Weapon_Pack_Categories ) and "[TFA] [AT] [ SMGs ]" or "TFA Insurgency"   
SWEP.PrintName				= ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "KBP SR-2M Veresk" or "SR-2M Veresk"   		           
SWEP.Manufacturer 			= "TsNIITochMash"                  -- Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Purpose				= "A 9x21mm High Penetration Submachine Gun."
SWEP.Instructions			= ""              

SWEP.Author				    = "XxYanKy700xX"    
SWEP.Contact				= "https://steamcommunity.com/profiles/76561198296543672/" 

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true                             -- Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		                       -- Draw the crosshair?
SWEP.DrawCrosshairIS		= false                            -- Draw the crosshair in ironsights?

SWEP.Slot					= 2			                       -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			                   -- Position in the slot
SWEP.AutoSwitchTo			= true		                       -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		                       -- Auto switch from if you pick up a better weapon
SWEP.Weight					= 30			                   -- This controls how "good" the weapon is for autopickup.
SWEP.Type                   = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "Type: Submachine Gun - Caliber: 9x21mm - Muzzle Velocity: 450 m/s" or "Submachine Gun"

SWEP.ViewModelPunch_VertialMultiplier            = 0.82        -- Default value is 1
SWEP.ViewModelPunch_MaxVertialOffset             = 2.25        -- Default value is 3
SWEP.ViewModelPunchPitchMultiplier               = 0.3         -- Default value is 0.5

--[[WEAPON HANDLING]]--

SWEP.Primary.Sound          = Sound("TFA_INS2.SR2M_Veresk.Fire")            -- This is the sound of the weapon, when you shoot.
SWEP.Primary.SilencedSound  = Sound("TFA_INS2.SR2M_Veresk.Fire_Suppressed") -- This is the sound of the weapon, when silenced.

SWEP.Primary.SoundEchoTable = {
	[0]   = Sound("TFA_MWR_SMG.TailInside"), 
	[256] = Sound("TFA_MWR_MP5.TailOutside")
}

SWEP.Primary.Damage                = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and 45 * TFA.Yankys_Custom_Weapon_Pack.DamageMultiplier or 32
SWEP.Primary.DamageTypeHandled     = true                      -- true will handle damagetype in base
SWEP.Primary.DamageType            = nil                       -- See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect.  DMG_AIRBOAT opens doors.
SWEP.Primary.PenetrationMultiplier = 0.8                       -- Change the amount of something this gun can penetrate through
SWEP.Primary.Velocity              = 450                       -- m/s
SWEP.Primary.NumShots              = 1                         -- The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.

SWEP.Primary.Automatic             = true                      -- Automatic/Semi Auto
SWEP.Primary.RPM                   = 900                       -- This is in Rounds Per Minute / RPM

SWEP.Primary.Force                 = nil                       -- Force value, leave nil to autocalc
SWEP.Primary.Knockback             = nil                       -- Autodetected if nil; this is the velocity kickback
SWEP.Primary.HullSize              = 0                         -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.

SWEP.FiresUnderwater               = true

-- Miscelaneous Sounds

SWEP.IronInSound                   = nil                       -- Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound                  = nil                       -- Sound to play when ironsighting out?  nil for default

-- Selective Fire Stuff
SWEP.SelectiveFire                 = true                      -- Allow selecting your firemode?
SWEP.DisableBurstFire              = true                      -- Only auto/single?
SWEP.OnlyBurstFire                 = false                     -- No auto, only burst/single?
SWEP.FireModeName                  = nil                       -- Change to a text value to override it
SWEP.DefaultFireMode               = ""

-- Ammo Related
SWEP.Primary.ClipSize              = 30                        -- This is the size of a clip
SWEP.Primary.DefaultClip           = SWEP.Primary.ClipSize * 13 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo                  = "smg1"                    -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption       = 1                         -- Ammo consumed per shot

SWEP.DisableChambering             = false                     -- Disable round-in-the-chamber
SWEP.CanJam                        = true

-- Recoil Related
SWEP.Primary.KickUp                = 0.33                      -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown              = 0.25                      -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal        = 0.20                      -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor    = 0.25                      -- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

-- Firing Cone Related
SWEP.Primary.Spread                = 0.037                     -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy          = 0.0096                    -- Ironsight accuracy, should be the same for shotguns

-- Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax   = 2.8                       -- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement       = 0.33                      -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery        = 3.51                      -- How much the spread recovers, per second. Example val: 3

-- Range Related
SWEP.Primary.Range                = 0.25 * (3280.84 * 16)      -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff         = 0.75                       -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

SWEP.Primary.RangeFalloffLUT = {
	bezier     = true,
	
	range_func = "quintic",
	units      = "meters",
	
	lut = {
		{range = 0, damage = 1},
		{range = 100, damage = 1},
		{range = 150, damage = 1},
		{range = 200, damage = 1},
		{range = 200, damage = 1},
		{range = 250, damage = 1},
		{range = 350, damage = 0.62},		
	}
}

-- Penetration Related
SWEP.MaxPenetrationCounter      = 5                            -- The maximum number of ricochets.  To prevent stack overflows.

-- Misc
SWEP.IronRecoilMultiplier       = 0.75                         -- Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier   = 0.70                         -- Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

-- Movespeed
SWEP.MoveSpeed                  = 0.95                         -- Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed        = 0.90                         -- Multiply the player's movespeed by this when sighting.

--[[EFFECTS]]--

-- Attachments
SWEP.MuzzleFlashEnabled         = true                         -- Enable muzzle flash
SWEP.MuzzleAttachmentRaw        = nil                          -- This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.MuzzleFlashEffect          = "tfa_muzzleflash_smg"           

SWEP.MuzzleAttachment			= "muzzle" 		               -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "shell" 		               -- Should be "2" for CSS models or "shell" for hl2 models

SWEP.AutoDetectMuzzleAttachment = false                        -- For multi-barrel weapons, detect the proper attachment?
SWEP.SmokeParticle              = nil                          -- Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
SWEP.EjectionSmokeEnabled       = false                        -- Disable automatic ejection smoke

-- Shell eject override
SWEP.LuaShellEject              = true                         -- Enable shell ejection through lua?
SWEP.LuaShellEjectDelay         = 0                            -- The delay to actually eject things
SWEP.LuaShellEffect             = "ShellEject"                 -- The effect used for shell ejection; Defaults to that used for blowback

-- Tracer Stuff
SWEP.TracerName 		        = nil 	                       -- Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		        = 1  	                       -- 0 disables, otherwise, 1 in X chance

--[[VIEWMODEL]]--

SWEP.ViewModel	    = "models/weapons/c_ins2_sr2m_veresk.mdl"
SWEP.VMPos          = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and Vector(-0.65, 0, 0.25) or Vector(0, 0, 0)
SWEP.VMAng          = Vector(0, 0, 0)                          -- The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false                                    -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.ViewModelFOV	= 80		                               -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip	= false		                               -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands       = true                                     -- Use gmod c_arms system.

SWEP.CenteredPos    = nil                                      -- The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng    = nil                                      -- The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.Bodygroups_V   = nil

--[[ANIMATION]]--

SWEP.StatusLengthOverride = {
	["base_reload"]       = 62 / 30,
	["base_reload_empty"] = 110 / 30,
} -- Changes the status delay of a given animation; only used on reloads.  Otherwise, use SequenceLengthOverride or one of the others

SWEP.SequenceRateOverride = {
	["base_reload"]       = 1,
	["base_reloadempty"]  = 1,
	["empty_sprint"]      = 0.8,
} -- Like above but changes animation length to a target

SWEP.SequenceLengthOverride     = {}                           -- Changes both the status delay and the nextprimaryfire of a given animation
SWEP.SequenceRateOverrideScaled = {}                           -- Like above but scales animation length rather than being absolute

SWEP.ProceduralHoslterEnabled   = nil
SWEP.ProceduralHolsterTime      = 0.35

SWEP.ProceduralHolsterPos       = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng       = Vector(-40, -30, 10)

SWEP.Sights_Mode                = TFA.Enum.LOCOMOTION_HYBRID   -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation

SWEP.Sprint_Mode                = TFA.Enum.LOCOMOTION_ANI      -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult              = 0.35
SWEP.SprintFOVOffset            = 5

SWEP.Idle_Mode                  = TFA.Enum.IDLE_BOTH           -- TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend                 = 0.25                         -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth                = 0.05                         -- Start an idle this far early into the end of another animation

-- MDL Animations Below

SWEP.IronAnimation = {
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT,                     -- Sequence or act
		["value"] = ACT_VM_PRIMARYATTACK_1,                    -- Number for act, String/Number for sequence
		["value_last"] = ACT_VM_PRIMARYATTACK_2,
		["value_empty"] = ACT_VM_PRIMARYATTACK_3
	} -- What do you think
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,                     -- Sequence or act
		["value"] = "base_sprint",                             -- Number for act, String/Number for sequence
		["value_empty"] = "empty_sprint",
		["is_idle"] = true
	}
}

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.AllowViewAttachment  = true                               -- Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.

--[[WORLDMODEL]]--

SWEP.WorldModel	  = "models/weapons/w_ins2_sr2m_veresk.mdl"    -- Weapon world model path
SWEP.Bodygroups_W = nil 

SWEP.HoldType     = "revolver" 

-- This is how others view you carrying the weapon. Options include:  
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = {
	Pos = {
		Up = -1.8,
		Right = 2,
		Forward = 4.75
	},
	Ang = {
		Up = 0,
		Right = -6,
		Forward = 180
	},
	Scale = 0.85
} -- Procedural world model animation, defaulted for CS:S purposes.

SWEP.ThirdPersonReloadDisable = false -- Disable third person reload?  True disables.

--[[IRONSIGHTS]]--

SWEP.data = {}

SWEP.data.ironsights   = 1    -- Enable Ironsights
SWEP.Secondary.IronFOV = 80   -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsReloadEnabled = true
SWEP.IronSightsReloadLock    = false

SWEP.IronSightsPos     = Vector(-2.1685, -2, 1.28)
SWEP.IronSightsAng     = Vector(-0.25, 0.05, 0)

SWEP.IronSightsPos_Point_Shooting = Vector(-5, -1, -1)
SWEP.IronSightsAng_Point_Shooting = Vector(0, 0, -30)
SWEP.Secondary.Point_Shooting_FOV = 70 

SWEP.IronSightsPos_Kobra  = Vector(-2.175, -3, 0.17)
SWEP.IronSightsAng_Kobra  = Vector(0, 0, 0)

SWEP.IronSightsPos_EOTech = Vector(-2.176, -3, 0.155)
SWEP.IronSightsAng_EOTech = Vector(0, 0, 0)

SWEP.IronSightsPos_RDS    = Vector(-2.175, -3, 0.15)
SWEP.IronSightsAng_RDS    = Vector(0, 0.035, 0)

SWEP.IronSightsPos_2XRDS  = Vector(-2.172, -3, 0.155)
SWEP.IronSightsAng_2XRDS  = Vector(0, 0, 0)
SWEP.Secondary.IronFOV_2XRDS = 65
SWEP.RTScopeFOV_2XRDS        = 20

SWEP.IronSightsPos_C79    =  Vector(-2.175, -3, -0.172)
SWEP.IronSightsAng_C79    = Vector(0, 0, 0)
SWEP.Secondary.IronFOV_C79 = 65
SWEP.RTScopeFOV_C79        = 50

-- SWEP.IronSightsPos_PO4X = Vector(-2.847, -1.2, -0.435)
-- SWEP.IronSightsAng_PO4X = Vector(0, 0, 0)

-- SWEP.IronSightsPos_MX4  = Vector(-2.92, -0.5, -0.675)
-- SWEP.IronSightsAng_MX4  = Vector(0, 0, 0)
-- SWEP.RTOverlayTransforms_MX4 = { -0.05, -0 }
-- SWEP.Secondary.IronFOV_MX4   = 70

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(2.5, 0.2, 0.2)
SWEP.RunSightsAng = Vector(-23, 30, -30)

--[[ CROUCHING ]] --

SWEP.CrouchPos    = Vector(-0.5, -1, -0.5) + SWEP.VMPos
SWEP.CrouchAng    = Vector(0, 0, -5) + SWEP.VMAng

--[[INSPECTION]]--

SWEP.InspectPos   = Vector(6, -2, 0.1)
SWEP.InspectAng   = Vector(13, 35, 15)

--[[ATTACHMENTS]]--

SWEP.Attachments = {
	[1] = { atts = { "ins2_si_kobra", "ins2_si_eotech", "ins2_si_rds", "ins2_si_2xrds", "ins2_si_c79" } },
	[2] = { atts = { "ins2_br_heavy", "r6s_h_barrel", "r6s_muzzle_2", "r6s_flashhider_2", "bo2_longbarrel", "ins2_br_supp", "ins2_eft_aac", "ins2_eft_osprey" } },
	[3] = { atts = { "ins2_ub_laser", "ins2_laser_anpeq15_black", "ins2_laser_anpeq15_tan", "ins2_ub_flashlight", "ins2_eft_lastac2" } },
	[4] = { atts = { "tfa_tactical_point_shooting" } },
	[5] = { atts = { "tfa_yanks_wpn_pack_heavy_stock", "tfa_yanks_wpn_pack_light_stock", "bo2_stock" } },
	[6] = { atts = { "tfa_yanks_wpn_pack_sleight_of_hand", "tfa_yanks_wpn_pack_quick_draw", "bo2_rapidfire", "bo2_quickdraw" } },
	[7] = { atts = { "am_match", "am_magnum", "am_gib", "tfa_mb_penrnd" } },
}

SWEP.AttachmentDependencies = {	
    ["tfa_tactical_point_shooting"] = {"ins2_ub_laser", "ins2_laser_anpeq15_black", "ins2_laser_anpeq15_tan", "ins2_ub_flashlight", "ins2_eft_lastac2"},
}

SWEP.AttachmentExclusions   = {}

SWEP.ViewModelBoneMods = {
	["A_Muzzle"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
	["A_Optic"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0.2, 0.1, 0), angle = Angle(0, 0, 0) },
	["A_Suppressor"] = { scale = Vector(0.72, 0.72, 0.72), pos = Vector(0, -0.25, 0), angle = Angle(-90, 0, 0) },
	["A_LaserFlashlight"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0.3, 0, -0.25), angle = Angle(0, 0, 0) },
	["mp7_charger"] = { scale = Vector(1, 1, 1), pos = Vector(-2.2, 0, 0), angle = Angle(0, 0, 0) },
	["R Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(5.5, 0, 0) },
	["R Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, 0, 6) },
	["R Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10, 8) },
	["R Finger42"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 10, 0) },
	["L Finger1"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["L Finger11"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["L Finger2"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["L Finger21"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["L Finger3"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["L Finger31"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -10, 0) },
	["L Finger4"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12, 0) },
	["L Finger41"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, -12, 0) },
}

SWEP.WorldModelBoneMods = {
	["ATTACH_ModKit"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, -0.225), angle = Angle(0, 0, 0) },
	["ATTACH_Laser"] = { scale = Vector(1, 1, 1), pos = Vector(-4, 0, -0.55), angle = Angle(0, 0, -90) },
--	["A_Suppressor"] = { scale = Vector(0.9, 0.9, 0.9), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.VElements = {
--	["rail_sights"] = { type = "Model", model = "models/weapons/upgrades/a_modkit_kv_04.mdl", bone = "", rel = "", pos = Vector(0, -0.245, 0.159), angle = Angle(0, -90, 0), size = Vector(0.611, 0.611, 0.611), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false},
	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_eotech_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_eotech_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_eotech") or nil,
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimpoint_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 0, 90), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_rds_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_rds") or nil,
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_aimp2x_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_elcan_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_kobra.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
	["sight_kobra_lens"] = (TFA.INS2 and TFA.INS2.GetHoloSightReticle) and TFA.INS2.GetHoloSightReticle("sight_kobra") or nil,
--	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_po4x24_m.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = true },
--	["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_optic_m40_l.mdl", bone = "A_Optic", rel = "", pos = Vector(0, 0, 0), angle = Angle(90, 90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, active = false, bonemerge = false},
--	["scope_mx4_lens"] = { type = "Model", model = "models/rtcircle.mdl", bone = "A_Optic", rel = "", pos = Vector(-0, 1.258, -4.942), angle = Angle(-90, 0, 0), size = Vector(0.312, 0.312, 0.312), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {}, bonemerge = true, active = false },
--	["foregrip"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_foregrip_ins2.mdl", bone = "A_Foregrips", rel = "", pos = Vector(0, -0.035, -0.8), angle = Angle(0, 90, 0), size = Vector(0.5, 0.5, 0.5), color = color_white, surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 90, 0), size = Vector(0.95, 1.05, 1.05), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} , bonemerge = false, active = false },
	["suppressor_aac"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_aac.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, 0, 0.012), angle = Angle(0, 0, 0), size = Vector(1.45, 1.3, 1.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["suppressor_osprey"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_osprey.mdl", bone = "A_Suppressor", rel = "", pos = Vector(0, -0.1, 0), angle = Angle(0, 0, 0), size = Vector(1.2, 1.2, 1.2), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} , bonemerge = false, active = false },
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_rail.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(0, -0.6, 0), angle = Angle(0, 0, 90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser", pos = Vector(0, 0, 0), angle = Angle(0, -1, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["laser_anpeq15_black"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_anpeq15_rail.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1 ,1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["laser_beam_anpeq15_black"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser_anpeq15_black", pos = Vector(0, 0, 0), angle = Angle(0, -1, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["laser_anpeq15_tan"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_laser_anpeq15_rail_tan.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1 ,1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["laser_beam_anpeq15_tan"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Beam", rel = "laser_anpeq15_tan", pos = Vector(0, 0, 0), angle = Angle(0, -1, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(0, -0.6, 0), angle = Angle(0, 0, 90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["flashlight_lastac"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_lastac.mdl", bone = "A_LaserFlashlight", rel = "", pos = Vector(0.3, -0.92, 0), angle = Angle(-90, -90, 0), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
}

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
--	["rail_sights"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_modkit_6.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(-4.433, 0.041, 4.947), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_eotech"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_eotech.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_rds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_aimpoint.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_2xrds"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_magaim.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["scope_c79"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_elcan.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["sight_kobra"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_kobra.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
--	["scope_po4x"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_po.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
--	["scope_mx4"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_scope_m40.mdl", bone = "ATTACH_ModKit", rel = "ref", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
--	["foregrip"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_ins_foregrip.mdl", bone = "ATTACH_Foregrip", rel = "ref", pos = Vector(1, -0.004, -0.322), angle = Angle(0, 0, 0), size = Vector(0.8,0.8,0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["suppressor"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_sil_sec1.mdl", bone = "ATTACH_Muzzle", rel = "ref", pos = Vector(-17.8, 0, 9.2), angle = Angle(0, 0, 0), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = false, active = false },
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "ATTACH_Laser", rel = "ref", pos = Vector(20, 14, 3), angle = Angle(0, 0, -90), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/w_laser_ins.mdl", bone = "ATTACH_Laser", rel = "ref", pos = Vector(20, 14, 3), angle = Angle(0, 0, -90), size = Vector(1.299, 1.299, 1.299), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

SWEP.RTAttachment_2XRDS           = 2
SWEP.ScopeDistanceRange_2XRDS     = 50
SWEP.ScopeDistanceMin_2XRDS       = 50

SWEP.RTAttachment_C79             = 2
SWEP.ScopeDistanceRange_C79       = 50
SWEP.ScopeDistanceMin_C79         = 50

-- SWEP.RTAttachment_PO4X         = 2
-- SWEP.ScopeDistanceRange_PO4X   = 50
-- SWEP.ScopeDistanceMin_PO4X     = 50

SWEP.MuzzleAttachmentSilenced     = 1

SWEP.LaserSightModAttachment      = 1
SWEP.LaserSightModAttachmentWorld = 0
SWEP.LaserDotISMovement           = true

DEFINE_BASECLASS( SWEP.Base )

if TFA.Yankys_Custom_Weapon_Pack then
	
    SWEP.AmmoTypeStrings = {
	    smg1 = "9x21mm Gyurza AP"
    }

    function SWEP:OnCustomizationOpen()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Open")
    end

    function SWEP:OnCustomizationClose()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Close")
    end

end