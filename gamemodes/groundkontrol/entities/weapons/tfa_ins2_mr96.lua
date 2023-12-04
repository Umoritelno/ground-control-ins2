SWEP.Base					= ( TFA and DVL ) and "tfa_devl_base" or "tfa_gun_base"                    -- Weapon Base
SWEP.Category               = ( TFA and TFA.Yankys_Custom_Weapon_Pack_Categories ) and "[TFA] [AT] [ Pistols ]" or "TFA Insurgency"   
SWEP.PrintName				= ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "Manurhin MR-96" or "MR-96"   		           
SWEP.Manufacturer           = "Manurhin"                        -- Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Purpose				= "A accurate light weight Double Action Revolver." 
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
SWEP.Type                   = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "Type: Double-Action Revolver - Caliber: .357 Magnum - Muzzle Velocity: 520 m/s" or "Revolver"

--[[WEAPON HANDLING]]--

SWEP.Primary.Sound          = Sound("TFA_INS2.MR96.Fire") -- This is the sound of the weapon, when you shoot.

SWEP.Primary.SoundEchoTable = {
	[0]   = Sound("TFA_MWR_PIST.TailInside"), 
	[256] = Sound("TFA_MWR_MAGNUM.TailOutside") 
}

SWEP.Primary.Damage                = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and 125 * TFA.Yankys_Custom_Weapon_Pack.DamageMultiplier or 80
SWEP.Primary.DamageTypeHandled     = true                       -- true will handle damagetype in base
SWEP.Primary.DamageType            = nil                        -- See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect.  DMG_AIRBOAT opens doors.
SWEP.Primary.PenetrationMultiplier = 0.96                       -- Change the amount of something this gun can penetrate through
SWEP.Primary.Velocity              = 520                        -- Bullet Velocity in m/s
SWEP.Primary.NumShots              = 1                          -- The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.

SWEP.Primary.Automatic             = false                      -- Automatic/Semi Auto
SWEP.Primary.RPM                   = 270                        -- This is in Rounds Per Minute / RPM

SWEP.Primary.Force                 = nil                        -- Force value, leave nil to autocalc
SWEP.Primary.Knockback             = nil                        -- Autodetected if nil; this is the velocity kickback
SWEP.Primary.HullSize              = 0                          -- Big bullets, increase this value.  They increase the hull size of the hitscan bullet.

--[[SHOTGUN CODE]]--

SWEP.Shotgun                     = true                         -- Enable shotgun style reloading.
SWEP.ShotgunEmptyAnim            = false                        -- Enable emtpy reloads on shotguns?
SWEP.ShotgunEmptyAnim_Shell      = true                         -- Enable insertion of a shell directly into the chamber on empty reload?
SWEP.ShellTime                   = nil                          -- For shotguns, how long it takes to insert a shell.

-- Miscelaneous Sounds
SWEP.IronInSound                 = nil                          -- Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound                = nil                          -- Sound to play when ironsighting out?  nil for default

-- Ammo Related
SWEP.Primary.ClipSize            = 6                            -- This is the size of a clip
SWEP.Primary.DefaultClip         = SWEP.Primary.ClipSize * 13   -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo                = "357"                        -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption     = 1                            -- Ammo consumed per shot

-- Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets
SWEP.DisableChambering           = true                         -- Disable round-in-the-chamber
SWEP.CanJam                      = true

--[[ Selective Fire Stuff ]]--

SWEP.SelectiveFire               = false                        -- Allow selecting your firemode?
SWEP.DisableBurstFire            = false                        -- Only auto/single?
SWEP.OnlyBurstFire               = false                        -- No auto, only burst/single?
SWEP.DefaultFireMode             = "Double-Action"              -- Default to auto or whatev
SWEP.FireModeName                = "Double-Action"              -- Change to a text value to override it

-- Recoil Related
SWEP.Primary.KickUp              = 1.2                          -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown            = 1.2                          -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal      = 0.72                         -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor  = 0.66                         -- Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

-- Firing Cone Related
SWEP.Primary.Spread              = .0162                        -- This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy        = .0025                        -- Ironsight accuracy, should be the same for shotguns

-- Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 5.2                          -- How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement     = 5.2                          -- What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery      = 8                            -- How much the spread recovers, per second. Example val: 3

-- Range Related
SWEP.Primary.Range               = 0.05 * (3280.84 * 16)        -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff        = 0.75                         -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

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
		{range = 500, damage = 0.80},
		{range = 600, damage = 0.70},
		{range = 800, damage = 0.57},
	}
}

-- Penetration Related
SWEP.MaxPenetrationCounter       = 4                            -- The maximum number of ricochets.  To prevent stack overflows.

-- Misc
SWEP.IronRecoilMultiplier        = 0.8                          -- Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier    = 0.8                          -- Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

-- Movespeed
SWEP.MoveSpeed                   = 1                            -- Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed         = 0.95                         -- Multiply the player's movespeed by this when sighting.
 
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

SWEP.ViewModel		= "models/weapons/c_ins2_revolver_mr96.mdl" -- Viewmodel path
SWEP.VMPos          = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and Vector(-0.8, 0, 0.1) or Vector(-0.45, 0, 0.1)
SWEP.VMAng          = Vector(0.60, 0.5, 0)                     -- The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false                                     -- Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.ViewModelFOV	= 70                                		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip	= false                          		    -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands       = true                                      -- Use gmod c_arms system.

SWEP.CenteredPos    = nil                                       -- The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng    = nil                                       -- The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.

SWEP.Bodygroups_V = {
	[1] = 6,
	[2] = 6,
}

--[[ANIMATION]]--

SWEP.StatusLengthOverride    = {
	[ACT_VM_RELOAD]          = 12 / 34.6,
	[ACT_VM_RELOAD_DEPLOYED] = 118 / 33.5,
} -- Changes the status delay of a given animation; only used on reloads.  Otherwise, use SequenceLengthOverride or one of the others

SWEP.SequenceLengthOverride     = {}                            -- Changes both the status delay and the nextprimaryfire of a given animation
SWEP.SequenceRateOverride       = {}                            -- Like above but changes animation length to a target
SWEP.SequenceRateOverrideScaled = {}                            -- Like above but scales animation length rather than being absolute

SWEP.ProceduralHoslterEnabled   = nil
SWEP.ProceduralHolsterTime      = 0.3
SWEP.ProceduralHolsterPos       = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng       = Vector(-40, -30, 10)

SWEP.Sights_Mode                = TFA.Enum.LOCOMOTION_HYBRID    -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation

SWEP.Sprint_Mode                = TFA.Enum.LOCOMOTION_ANI       -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.SprintBobMult              = 0.35
SWEP.SprintFOVOffset            = 5

SWEP.Idle_Mode                  = TFA.Enum.IDLE_BOTH            -- TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend                 = 0.25                          -- Start an idle this far early into the end of a transition
SWEP.Idle_Smooth                = 0.05                          -- Start an idle this far early into the end of another animation

--MDL Animations Below
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

SWEP.EventTable = {
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			wep.Bodygroups_V[1] = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1())
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_PRIMARYATTACK_1] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			wep.Bodygroups_V[1] = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1())
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_SHOTGUN_RELOAD_START] = {
		{ ["time"] = 58 / 33.5, ["type"] = "lua", ["value"] = function(wep, vm)
			if wep.EventShell then
				for i = 1, wep.Bodygroups_V[2] do
					wep:EventShell()
				end
				wep.Bodygroups_V[2] = 0
			end
			wep:Unload()
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function(wep, vm)
			local clip = math.Clamp(wep:Clip1() + 1, 0, wep:GetMaxClip1())
			wep.Bodygroups_V[1] = clip
			wep.Bodygroups_V[2] = clip
		end, ["client"] = true, ["server"] = true},
	},
	[ACT_VM_RELOAD_DEPLOYED] = {
		{ ["time"] = 58 / 33.5, ["type"] = "lua", ["value"] = function(wep, vm)
			if wep.EventShell then
				for i = 1, wep.Bodygroups_V[2] do
					wep:EventShell()
				end
			end
			wep:Unload()
		end, ["client"] = true, ["server"] = true},
		{ ["time"] = 65 / 33.5, ["type"] = "lua", ["value"] = function(wep, vm)
			local ammo = math.Clamp(wep:Ammo1(), 0, wep:GetMaxClip1())
			wep.Bodygroups_V[1] = ammo
			wep.Bodygroups_V[2] = ammo
		end, ["client"] = true, ["server"] = true},
	},
} -- Event Table, used for custom events when an action is played.  This can even do stuff like playing a pump animation after shooting.

--[[VIEWMODEL ANIMATION HANDLING]]--

SWEP.AllowViewAttachment = true                                 -- Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.

--[[WORLDMODEL]]--

SWEP.WorldModel		= "models/weapons/w_ins2_revolver_mr96.mdl" -- Weapon world model path
SWEP.HoldType       = "revolver" 
SWEP.Bodygroups_W   = nil

-- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.Offset = { -- Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
		Up = -1.25,
		Right = 1.5,
		Forward = 4
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
	},
	Scale = 1
} 

SWEP.ThirdPersonReloadDisable = false -- Disable third person reload?  True disables.

--[[IRONSIGHTS]]--

SWEP.data = {}
SWEP.data.ironsights   = 1  -- Enable Ironsights
SWEP.Secondary.IronFOV = 80 -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.

SWEP.IronSightsReloadEnabled = true
SWEP.IronSightsReloadLock    = false

SWEP.IronSightsPos     = Vector(-1.85, 0, 1.1025)
SWEP.IronSightsAng     = Vector(-1.75, 0, 0)

SWEP.IronSightsPos_RMR = Vector(-1.85, -1, 0.77)
SWEP.IronSightsAng_RMR = Vector(-1.75, 0, 0)

SWEP.IronSightsPos_Point_Shooting = Vector(-2.85, -1, 0)
SWEP.IronSightsAng_Point_Shooting = Vector(0, 0, -35)
SWEP.Secondary.Point_Shooting_FOV = 70 

--[[SPRINTING]]--

SWEP.RunSightsPos = Vector(1.25, -6, -6)
SWEP.RunSightsAng = Vector(50, 0, 0)

--[[ CROUCHING ]] --

SWEP.CrouchPos    = Vector(-1.88, -1.5, -0.65)
SWEP.CrouchAng    = Vector(0, 0, -20)

--[[INSPECTION]]--

SWEP.InspectPos   = Vector(6, -6, -2.241) 
SWEP.InspectAng   = Vector(27, 42, 15.477)

--[[ATTACHMENTS]]--

SWEP.Attachments = {
	[1] = { atts = { "ins2_eft_rmr" } },
	[2] = { atts = { "ins2_br_heavy", "r6s_h_barrel", "r6s_muzzle_2", "r6s_flashhider_2", "bo2_longbarrel" } },
	[3] = { atts = { "ins2_ub_laser", "ins2_ub_flashlight" } },
	[4] = { atts = { "ins2_mag_speedloader" } },
 	[5] = { atts = { "tfa_tactical_point_shooting" } },
    [6] = { atts = { "tfa_yanks_wpn_pack_sleight_of_hand", "tfa_yanks_wpn_pack_quick_draw", "bo2_rapidfire", "bo2_quickdraw" }},
	[7] = { atts = { "am_match", "am_magnum", "am_gib", "tfa_mb_penrnd" } },
}

SWEP.AttachmentDependencies = {}
SWEP.AttachmentExclusions   = {}

SWEP.ViewModelBoneMods = {
--	["A_Underbarrel"] = { scale = Vector(1, 1, 1), pos = Vector(1, 0, 0), angle = Angle(0, 0, 0) },
	["A_Muzzle"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0, 0), angle = Angle(0, 0, -90) },
	["R UpperArm"] = { scale = Vector(0.86, 0.86, 0.86), pos = Vector(-0.05, 0, -0.08), angle = Angle(0, 0, 0) },
	["L UpperArm"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["L Finger22"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(-2, 15, 0)  },
	["L Finger21"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0)	},
	["R Finger11"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(5, -5, 0)	},
	["R Finger12"] = { scale = Vector(0.85, 0.85, 0.85), pos = Vector(0, 0, 0), angle = Angle(0, 30, 0)	}
}

SWEP.VElements = {
	["sight_rmr"] = { type = "Model", model = "models/weapons/tfa_eft/upgrades/v_rmr.mdl", bone = "weapon", rel = "", pos = Vector(0, -0.585, 1.85), angle = Angle(0, 180, 0), size = Vector(0.5, 0.6, 0.675), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["sight_rmr_lens"] = (TFA.EFTC and TFA.EFTC.GetHoloSightReticle) and TFA.EFTC.GetHoloSightReticle("sight_rmr") or nil,
	["laser"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail.mdl", bone = "Weapon", rel = "", pos = Vector(0, 2.92, 1.1), angle = Angle(0, -90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["laser_beam"] = { type = "Model", model = "models/tfa/lbeam.mdl", bone = "A_Stream", rel = "laser", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(2, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
	["flashlight"] = { type = "Model", model = "models/weapons/tfa_ins2/upgrades/a_flashlight_rail.mdl", bone = "Weapon", rel = "", pos = Vector(0, 2.92, 1.1), angle = Angle(0, -90, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = false, bodygroup = {} },
}

SWEP.WElements = {}

DEFINE_BASECLASS( SWEP.Base )

if TFA.Yankys_Custom_Weapon_Pack then

    SWEP.AmmoTypeStrings = {
	    ["357"] = ".357 Magnum AP"
    }

    function SWEP:OnCustomizationOpen()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Open")
    end

    function SWEP:OnCustomizationClose()
	    self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Close")
    end

end