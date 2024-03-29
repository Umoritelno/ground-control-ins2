--[[
	if you're looking through code in hopes of finding backdoors/etc - rest assured there are none
	if you find some weird console commands that do weird stuff (like adjust health, or set a team for all players or whatever) please let me know, it's debug code that I have forgotten to remove
	thank you for understanding!
]]--

GM.currentPlayerList = {}
GM.nvgloadout = "Splinter Cell" --

GM.doorClasses = {"func_door_rotating", "prop_door_rotating"}

function GM:adjustDoorSpeeds()
	local newSpeed = GetConVar("gc_door_move_speed"):GetString()
	
	for i = 1, #self.doorClasses do
		local class = self.doorClasses[i]
		
		for key, obj in ipairs(ents.FindByClass(class)) do			
			obj:SetKeyValue("Speed", newSpeed)
		end
	end
end

include("sh_mixins.lua")

include("sv_player_bleeding.lua")
include("sv_player_adrenaline.lua")
include("sv_player_stamina.lua")
include("sv_player_health_regen.lua")
include("sv_general.lua")

include('shared.lua')

GM:registerAutoUpdateConVar("gc_door_move_speed", function(cvarName, oldValue, newValue)
	GAMEMODE:adjustDoorSpeeds()
end)

GM:registerAutoUpdateConVar("gc_rounds", function(cvarName, oldValue, newValue)
	GAMEMODE.RoundsPerMap = tonumber(newValue) or self.defaultRounds
end)

GM:registerAutoUpdateConVar("gc_crippling", function(cvarName, oldValue, newValue)
	GAMEMODE.cripplingEnabled = tonumber(newValue) > 0
end)

GM:registerAutoUpdateConVar("gc_block_wepbase_vote", function(cvarName, oldValue, newValue)
	GAMEMODE.wepbaseLocked = tonumber(newValue) > 0
end)


include("sv_player.lua")
include("sv_loop.lua")
include("sh_language.lua")
include("player_classes/classes.lua")
include("sh_keybind.lua")
include("sh_action_to_key.lua")
include("sh_events.lua")
include("sh_general.lua")
include("sv_player_weight.lua")
include("sv_player_gadgets.lua")
include("sv_player_cash.lua")
include("sh_status_display.lua")
include("sv_loadout.lua")
include("sv_attachments.lua")
include("sv_team.lua")
include("sv_starting_points.lua")
include("sv_radio.lua")
include("sv_downloads.lua")
include("sv_events.lua")
include("sv_rounds.lua")
include("sv_spectate.lua")
include("sv_player_armor.lua")
include("sv_voting.lua")
include("sv_maprotation.lua")
include("sv_gametypes.lua")
include("sv_votescramble.lua")
include("sv_player_traits.lua")
include("sv_timelimit.lua")
include("sv_custom_spawn_points.lua")
include("sv_remove_entities.lua")
include("sv_autobalance.lua")
include("sv_autodownload_map.lua")
include("sv_autopunish.lua")
include("sv_map_start_callbacks.lua")
include("sh_tip_controller.lua")
include("sh_entity_initializer.lua")
include("sh_announcer.lua")
include("sh_climbing.lua")
include("sh_footsteps.lua")
include("sh_mvp_tracking.lua")
include("sh_config.lua")
include("sv_config.lua")
include("sv_server_name_updater.lua")
include("sv_killcount.lua")
include("sh_postload.lua")
include("sv_achivs.lua")
include("sh_achiv_table.lua")
include("sv_specrounds.lua")
include("sh_specrounds.lua")
include("sv_nvgs.lua")
include("sh_nvgs.lua")
include("sh_lean.lua")
include("sv_dynamicblood.lua")
include("sv_radar.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_gui_scoreboard.lua")
AddCSLuaFile("cl_util.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_player.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_loop.lua")
AddCSLuaFile("cl_view.lua")
AddCSLuaFile("cl_umsgs.lua")
AddCSLuaFile("cl_gui.lua")
AddCSLuaFile("cl_screen.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_music_handler.lua")
AddCSLuaFile("cl_render.lua")
AddCSLuaFile("cl_voice_selection.lua")
AddCSLuaFile("cl_weapon_selection_hud.lua")
AddCSLuaFile("cl_player_counting.lua")
AddCSLuaFile("cl_config.lua")
AddCSLuaFile("cl_killcount.lua")
AddCSLuaFile("cum_splat_controller.lua")
AddCSLuaFile("cl_achiv.lua") -- achivki client
AddCSLuaFile("cl_specrounds.lua")
AddCSLuaFile("cl_nvgs.lua")
AddCSLuaFile("cl_radar.lua")
-- VGUI Start
AddCSLuaFile("vgui/dmainmenu.lua")
AddCSLuaFile("vgui/dnewvote.lua")
AddCSLuaFile("vgui/dcheckboxmanual.lua")
-- VGUI End

GM.MVPTracker = mvpTracker.new()

CustomizableWeaponry.canDropWeapon = false -- don't let the players be able to drop weapons using the cw_dropweapon console command

function GM:InitPostEntity()
	self:postInitEntity()
	self:setGametype(self:getGametypeFromConVar())
	self:autoRemoveEntities()
	self:runMapStartCallback()
	
	timer.Simple(1, function()
		self:resetStartingPoints()
	end)
	GetConVar("NVGBASE_DEFAULTLOADOUT"):SetString(self.nvgloadout)
	
	self:verifyAutoDownloadMap()
	
	self:performOnChangedCvarCallbacks()
end

local Vec0 = Vector(0, 0, 0)

function GM:EntityTakeDamage(target, dmgInfo)
	dmgInfo:SetDamageForce(dmgInfo:GetDamageForce() * 0.5)
		
	if target:IsPlayer() then
		local attacker = dmgInfo:GetAttacker()
		
		if IsValid(attacker) then
			-- no phys damage
			if dmgInfo:GetDamageType() == DMG_CRUSH then
				dmgInfo:ScaleDamage(0)
				return
			end
				
			if not attacker:IsPlayer() then
				local owner = attacker:GetOwner() -- check whether they were hurt by an entity the owner of which is a player
				
				if IsValid(owner) and owner:IsPlayer() then
					attacker = owner -- use the 'owner' as the attacker
				end
			end
			
			if self.noTeamDamage and attacker:IsPlayer() and attacker:Team() == target:Team() and (attacker ~= target or self.RoundOver) then
				dmgInfo:ScaleDamage(0)
				return
			end
		end
				
		if attacker:IsPlayer() and attacker:Team() == target:Team() and self.AutoPunishEnabled then
			self:updateTeamDamageCount(attacker, math.min(target:Health(), dmgInfo:GetDamage()))
			dmgInfo:SetDamageForce(Vec0)
		end
		
		if target.currentTraits then
			local traits = GAMEMODE.Traits
			
			for key, traitConfig in ipairs(target.currentTraits) do
				local traitData = traits[traitConfig[1]][traitConfig[2]]
				
				if traitData.onTakeDamage then
					traitData:onTakeDamage(target, dmgInfo)
				end
			end
		end
	end
end

function GM:PlayerDeathSound()
	return true
end

function GM:AllowPlayerPickup(ply, ent)
	return false
end