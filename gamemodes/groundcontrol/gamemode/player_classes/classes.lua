AddCSLuaFile()
DEFINE_BASECLASS("player_default")

local PLAYER = {}
--[[PLAYER.DisplayName = "GC_BASE"
PLAYER.SlowWalkSpeed		= 100		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed			= 130		-- How fast to move when not running
PLAYER.RunSpeed				= 280		-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.6		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to duckingPLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 220		-- How powerful our jump should be
PLAYER.CanUseFlashlight		= true		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
--PLAYER.MaxArmor				= 100		-- Max armor we can have
PLAYER.StartHealth			= 100		-- How much health we start with
--PLAYER.StartArmor			= 0			-- How much armour we start with
--]]
PLAYER.UseVMHands			= true		-- Uses viewmodel hands
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide	= false		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= false 		-- Automatically swerves around other players

player_manager.RegisterClass("gc_base",PLAYER,"player_default")

local PLAYER = {}
PLAYER.DisplayName = "Soldier"
PLAYER.Desc = "You are soldier. Stay close to the squad and follow the orders of the commander."
PLAYER.SlowWalkSpeed		= 100		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed			= 130		-- How fast to move when not running
PLAYER.RunSpeed				= 280		-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.6		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to duckingPLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 220		-- How powerful our jump should be
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.MaxStamina           = 100
PLAYER.StartHealth			= 100		-- How much health we start with

player_manager.RegisterClass("soldier",PLAYER,"gc_base")	

local PLAYER = {}
PLAYER.DisplayName = "Specialist"
PLAYER.Desc = "You are specialist. Use your gear to complete the task."
PLAYER.SlowWalkSpeed		= 100		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed			= 145		-- How fast to move when not running
PLAYER.RunSpeed				= 315	-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.6		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to duckingPLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 220		-- How powerful our jump should be
PLAYER.MaxHealth			= 120	
PLAYER.MaxStamina           = 105	
PLAYER.StartHealth			= 120		-- How much health we start with
PLAYER.RandomAbility = true 

player_manager.RegisterClass("spec",PLAYER,"gc_base")

local PLAYER = {}
PLAYER.DisplayName = "Commander"
PLAYER.Desc = "You are commander of your squad. Lead your squad."
PLAYER.SlowWalkSpeed		= 100		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed			= 140		-- How fast to move when not running
PLAYER.RunSpeed				= 300	-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.6		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to duckingPLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 220		-- How powerful our jump should be
PLAYER.MaxHealth			= 110	
PLAYER.MaxStamina           = 120	
PLAYER.StartHealth			= 110		-- How much health we start with
PLAYER.AbilityTable = {"skan"}

player_manager.RegisterClass("cmd",PLAYER,"gc_base")	

local PLAYER = {}
PLAYER.DisplayName = "Demoman"
PLAYER.Desc = "You are demoman. Use your weapon to wipe enemies off the face of the earth"
PLAYER.SlowWalkSpeed		= 100		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed			= 120		-- How fast to move when not running
PLAYER.RunSpeed				= 250	-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.6		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to duckingPLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 215		-- How powerful our jump should be
PLAYER.MaxHealth			= 105		-- Max health we can have
PLAYER.MaxStamina           = 75
PLAYER.StartHealth			= 105		-- How much health we start with
player_manager.RegisterClass("demo",PLAYER,"gc_base")	

local PLAYER = {}
PLAYER.DisplayName = "Rookie"
PLAYER.Desc = "You are rookie. You have been demoted and have been stripped of your equipment"
PLAYER.SlowWalkSpeed		= 70		-- How fast to move when slow-walking (+WALK)
PLAYER.WalkSpeed			= 100		-- How fast to move when not running
PLAYER.RunSpeed				= 200	-- How fast to move when running
PLAYER.CrouchedWalkSpeed	= 0.4		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to duckingPLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 150		-- How powerful our jump should be
PLAYER.MaxHealth			= 70		-- Max health we can have
PLAYER.MaxStamina           = 50
PLAYER.StartHealth			= 70		-- How much health we start with
player_manager.RegisterClass("rookie",PLAYER,"gc_base")

