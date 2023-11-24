GM.BleedData = {alpha = 0, targetAlpha = 8, alphaPerGrade = 12, approachRate = 200, lastPulse = 0, pulsePerGrade = math.pi * 0.2, pulseSpeed = math.pi}
GM.AdrenalineData = {currentVal = 0, soundTime = 0, approachRate = 0.25, soundDelay = 1}
GM.StaminaData = {alpha = 0, approachRate = 10, soundTime = 0, minSoundTime = 1.2, maxSoundTime = 1.5, minVolume = 30, maxVolume = 60}
GM.DeadPeriodState = 0
GM.DeadState = 0
GM.ObjectiveEntities = {}
GM.DrawEntities = {}

--CreateConVar("gc_hud_scale", 1, {FCVAR_ARCHIVE}, "controls the size of the HUD")
CreateConVar("gc_crosshair_enable", 1, {FCVAR_ARCHIVE}, "Enable crosshair for CW 2.0?")

GM.Fonts = {}
GM.DefFonts = {}

function GM:AddFontReplaceable(font)
	self.Fonts[font] = font 
	self.DefFonts[font] = font 
end 

GM:AddFontReplaceable("CW_HUD12")
GM:AddFontReplaceable("CW_HUD14")
GM:AddFontReplaceable("CW_HUD16")
GM:AddFontReplaceable("CW_HUD20")
GM:AddFontReplaceable("CW_HUD22")
GM:AddFontReplaceable("CW_HUD24")
GM:AddFontReplaceable("CW_HUD28")
GM:AddFontReplaceable("CW_HUD32")
GM:AddFontReplaceable("CW_HUD36")
GM:AddFontReplaceable("CW_HUD38")
GM:AddFontReplaceable("CW_HUD40")
GM:AddFontReplaceable("CW_HUD48")
GM:AddFontReplaceable("CW_HUD52")
GM:AddFontReplaceable("CW_HUD60")
GM:AddFontReplaceable("CW_HUD72")

-- GC-specific fonterinos
local fontDims = {{40, "HealthDisplayFont"}, {32, "BandageDisplayFont"}, {24, "ActionDisplayFont", "DeadFont", "KeyBindsFont", "VoteAnnounceFont", "PopupFont"}, {14, "GadgetDisplayFont", "MarkerFont"}, {20, "AttachmentSlotDisplayFont", "EventFontBig", "SpectateFont", "WeaponFont"}, {16, "EventFont", "StatusEffectFont", "RadioFont", "VoteFont", "TipFont"}, {28, "ObjectiveFont"}, {72, "BigObjectiveFont"}}
local fontPrefix = "GC_HUD"

function GM:initFonts()
	for i = 1, #fontDims do
		local data = fontDims[i]
		local fontName = fontPrefix .. data[1]
		surface.CreateFont(fontName, {font = "Prototype", size = _S(data[1]), weight = 700, blursize = 0, antialias = true, shadow = false})
		surface.CreateFont(fontName.."Replace", {font = "Roboto", size = _S(data[1]), weight = 700, blursize = 0, antialias = true, shadow = false})
		self:AddFontReplaceable(fontName)
		
		for i = 2, #data do
			self[data[i]] = fontName
		end
	end	
	
	surface.CreateFont("GroundControl_SelectIcons", {font = "csd", size = _S(100), weight = 500, blursize = 0, antialias = true, shadow = false})
end

local funcCopy = draw.ShadowText

function draw.ShadowTextReplaceable(str,font,x,y,defcol,shadcol,bold,xalign,yalign)
	if GAMEMODE.Fonts[font] then
		font = GAMEMODE.Fonts[font]
	end
    funcCopy(str,font,x,y,defcol,shadcol,bold,xalign,yalign)
end 

-- pre-requisite UI scaling methods
function GM:OnScreenSizeChanged(oldW, oldH)
	self:setupScaling()
	self:initFonts()
	self:setupScoreboardSizes()
end

local scaleRatio = 1

function GM:setupScaling()
	_SCRW = ScrW() -- globals for your triggering pleasure :=)
	_SCRH = ScrH()
	scaleRatio = _SCRH / 1080 * self:getHUDScaleValue()
end

function GM:getHUDScaleValue()
	return math.min(2, math.max(0.5, 1))
end

-- scales a given size by the screen res
function _S(size)
	return math.ceil(size * scaleRatio)
end

GM:setupScaling()
GM:initFonts()

include('shared.lua')
include("sh_mixins.lua")
include("sh_language.lua")
include("player_classes/classes.lua")
include("cl_hud.lua")
include("cl_util.lua")
include("cl_weapon_selection_hud.lua")
include("cl_loop.lua")
include("cl_view.lua")
include("cl_player.lua")
include("sh_action_to_key.lua")
include("sh_keybind.lua")
include("sh_player_adrenaline.lua")
include("sh_player_bleeding.lua")
include("sh_player_stamina.lua")
include("sh_player_weight.lua")
include("sh_player_gadgets.lua")
include("sh_player_cash.lua")
include("sh_player_armor.lua")
include("cl_status_display.lua")
include("sh_status_display.lua")
include("sh_general.lua")
include("sh_attachments.lua")
include("cl_attachments.lua")
include("sh_loadout.lua")
include("sh_team.lua")
include("sh_radio.lua")
include("cl_player_adrenaline.lua")
include("cl_gui.lua")
include("cl_gui_scoreboard.lua")	
include("cl_team.lua")
include("cl_screen.lua")
include("sh_events.lua")
include("cl_scoreboard.lua")
include("cl_voting.lua")
include("sh_gametypes.lua")
include("cl_music_handler.lua")
include("sh_player_traits.lua")
include("cl_render.lua")
include("cl_voice_selection.lua")
include("sh_timelimit.lua")
include("cl_timelimit.lua")
include("sh_tip_controller.lua")
include("cl_gametypes.lua")
include("sh_announcer.lua")
include("sh_climbing.lua")
include("sh_footsteps.lua")
include("sh_mvp_tracking.lua")
include("cl_player_counting.lua")
include("cl_killcount.lua")
include("sh_config.lua")
include("cl_config.lua")
include("cum_splat_controller.lua")
include("cl_umsgs.lua")
include("cl_achiv.lua")
include("sh_achiv_table.lua")
include("cl_specrounds.lua")
include("sh_specrounds.lua")
include("cl_nvgs.lua")
include("sh_nvgs.lua")
include("sh_lean.lua")
include("cl_radar.lua")
--include("sh_postload.lua")
-- VGUI Start
include("vgui/dmainmenu.lua")
include("vgui/dnewvote.lua")
include("vgui/dcheckboxmanual.lua")
--VGUI End

--[[GM:registerAutoUpdateConVar("gc_hud_scale", function(cvarName, oldValue, newValue)
	GAMEMODE:OnScreenSizeChanged()
end)]]

GM.TeamSelectionKey = "gm_showhelp"
GM.LoadoutMenuKey = "gm_showteam"
GM.RadioMenuKey = "gm_showspare1"
GM.MainMenuKey = "gm_showspare2"

function GM:InitPostEntity()
	local ply = LocalPlayer()
	ply.cash = ply.cash or 0
	ply.bandages = ply.bandages or 0
	ply.armor = {}
	ply.gadgets = {}
	ply:spawn()
	ply:resetGadgetData()
	ply:resetAttachmentData()
	ply:resetTraitData()
	
	self:postInitEntity()
	
	--RunConsoleCommand("cw_customhud_ammo", "1")
	ply:SetHullDuck(self.DuckHullMin, self.DuckHullMax)
	ply:SetViewOffsetDucked(self.ViewOffsetDucked)
	
	self.tipController:loadShownEvents()
	self:performOnChangedCvarCallbacks()
end

function GM:Tick()
	self.localPlayer = LocalPlayer()
	
	if self.localPlayer and IsValid(self.localPlayer) then
		self.localPlayerTeam = self.localPlayer:Team()
	end
end

function GM:isRoundOverTime()
	return self.roundOverTime and CurTime() < self.roundOverTime
end

local PLAYER = FindMetaTable("Player")

function PLAYER:spawn()
	GAMEMODE.roundOverTime = nil
	local ply = LocalPlayer()
	ply:resetBleedData()
	ply:resetHealData()
	ply:resetAdrenalineData()
	ply:resetStaminaData()
	ply:resetWeightData()
	--GAMEMODE:removeAllStatusEffects()
	
	RunConsoleCommand("cw_freeaim_autocenter", 1)
	RunConsoleCommand("cw_freeaim_autocenter_time", 0.650000)
	RunConsoleCommand("cw_freeaim_center_mouse_impendance", 0.3)
	RunConsoleCommand("cw_freeaim_lazyaim", 0.03)
	RunConsoleCommand("cw_freeaim_yawlimit", 15)
	
	timer.Simple(1, function()
		for key, tipId in ipairs(GAMEMODE.tipController.genericTips) do
			local result = GAMEMODE.tipController:handleEvent(tipId)
			
			if result == false or result == true then
				break
			end
		end
	end)
end

function GM:roundPreparation(preparationTime) -- called upon the start of a new round
	LocalPlayer():spawn()
	self:createRoundPreparationDisplay(preparationTime)
	self:destroyMVPPanel()
end

function GM:resetRoundData() -- called upon the end of a round
	self:resetAllStatusEffects()
	self:resetTimeLimit()
	
	if IsValid(LocalPlayer()) then
		LocalPlayer():resetGadgetData()
	end
	
	if GAMEMODE.curGametype.resetRoundData then
		GAMEMODE.curGametype:resetRoundData()
	end
end

function GM:clearObjectiveEntities()
	table.clear(self.ObjectiveEntities)
end

function GM:onLocalPlayerHurt(data, localPlayer)
	local damage = localPlayer:Health() - data.health
	
	self:playHurtEffect(damage)
end

-- 'data' is the data provided in the entity_killed event, called when you die
function GM:onLocalPlayerDied(data)
	local ply = LocalPlayer()
	
	self:removeAllStatusEffects()
	ply:resetGadgetData()
	ply:resetBleedData()
	ply:resetHealData()
	ply:resetAdrenalineData()
	ply:resetStaminaData()
	ply:resetWeightData()
end

-- 'data' is the same data from entity_killed, this is called when a player that dies
function GM:onPlayerDied(ply, data)
	if ply == LocalPlayer() then
		self:onLocalPlayerDied()
	else
		ply:resetStatusEffects()
		ply:resetHealData()
	end
end

function GM:addObjectiveEntity(obj)
	table.insert(self.ObjectiveEntities, obj)
end

function GM:removeObjectiveEntity(obj)
	for key, otherObj in ipairs(self.ObjectiveEntities) do
		if obj == otherObj then
			table.remove(self.ObjectiveEntities, key)
			break
		end
	end
end

function GM:clearDrawEntities()
	table.clear(self.DrawEntities)
end

function GM:addDrawEntity(obj)
	table.insert(self.DrawEntities, obj)
end

function GM:removeDrawEntity(obj)
	for key, otherObj in ipairs(self.DrawEntities) do
		if obj == otherObj then
			table.remove(self.DrawEntities, key)
			break
		end
	end
end

function GM:resetVisualAdrenaline()
	local data = self.AdrenalineData
	data.currentVal = 0
	data.soundTime = 0
end

function GM:resetVisualStamina()
	local data = self.StaminaData
	data.alpha = 0
	data.soundTime = 0
end

function GM:setLoadoutAvailabilityInfo(position, maxDuration)
	self.loadoutPosition = position
	self.loadoutDuration = maxDuration
end

function GM:PlayerBindPress(ply, bind, pressed)
	if pressed then
		if bind == "+attack" and self:scoreboardHandleMouse() then
			return true
		end
		
		if self.DeadState == 3 then
			if bind == "+attack" then
				RunConsoleCommand("gc_spectate_next")
			end
		end
		
		local wep = ply:GetActiveWeapon()
		
		if (IsValid(wep) and (not wep.CW20Weapon or wep.CW20Weapon and wep.dt.State ~= CW_CUSTOMIZE)) or not IsValid(wep) then
			if bind == self.TeamSelectionKey then
				RunConsoleCommand("gc_team_selection")
			elseif bind == self.LoadoutMenuKey then
				RunConsoleCommand("gc_loadout_menu")
			elseif bind == self.RadioMenuKey then				
				--RunConsoleCommand("gc_voice_menu")
				--ply:GetCurrentCommand():SelectWeapon(self.KnifeWeaponClass)
				--RunConsoleCommand("use", self.KnifeWeaponClass)
			end
			
			if not self:isVoteBlocking() then			
				if self.RadioSelection.active then
					if bind == "+attack2" then
						if self.RadioSelection.selectedCategory == 0 then
							self:toggleRadio()
							return true
						else
							self.RadioSelection.selectedCategory = 0
							return true
						end
					elseif bind:find("slot") then
						local selection = tonumber(bind:Right(1))
						
						if self.RadioSelection.selectedCategory == 0 then
							if self.VisibleRadioCommands[selection] then
								self.RadioSelection.selectedCategory = selection
							end
							
							return true
						else
							if self.VisibleRadioCommands[self.RadioSelection.selectedCategory].commands[selection] then
								self:SelectRadioCommand(selection)
								return true
							end
						end
					end
					
					if self:performAction(bind) then
						return true
					end
				else
					if self:performAction(bind) then
						return true
					end

					if bind:find("slot") then
						local selection = tonumber(bind:Right(1))
						
						if self:showWeaponSelection(selection) then
							return true
						else
							self:hideWeaponSelection()
						end
					else
						if bind == "invprev" then
							self:cycleWeaponSelection(-1)
						elseif bind == "invnext" then
							self:cycleWeaponSelection(1)
						elseif self:canSelectDesiredWeapon() then
							if bind == "+attack" then
								ply:selectWeaponNicely(self.desiredWeaponToDraw)
								return true
							elseif bind == "+attack2" then
								self:hideWeaponSelection()
							end
						end
					end
				end
			else
				if bind:find("slot") then
					local selection = tonumber(bind:Right(1))
					
					if self:attemptVote(selection) then
						return true
					end
				end
			end
		end
	end
end

function GM:HasDeadPeriodPassed()
	return CurTime() > self.deadPeriod
end

CustomizableWeaponry.callbacks:addNew("deployWeapon", "GroundControl_deployWeapon", function(self)
	if self.SpeedDec >= 20 then
		GAMEMODE.tipController:handleEvent("FASTER_MOVEMENT")
	end
end)

CustomizableWeaponry.callbacks:addNew("postAttachAttachment", "GroundControl_postAttachAttachment", function(self, attCategory)
	local attachmentName = self.Attachments[attCategory].atts[self.Attachments[attCategory].last]
	
	if self.BackupSights and self.BackupSights[attachmentName] then
		GAMEMODE.tipController:handleEvent("BACKUP_SIGHTS")
	end
end)

hook.Add("player_spawn", "GroundControl.player_spawn", function(data)
	local player = Player(data.userid)
	
	if IsValid(player) and player == LocalPlayer() then
		player:spawn()
	end
end)

gameevent.Listen("player_spawn")