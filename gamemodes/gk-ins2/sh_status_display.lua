-- status effects don't affect the player, these are only used for displaying them on the HUD

AddCSLuaFile()
AddCSLuaFile("cl_status_display.lua")

GM.StatusEffects = {}
GM.ActiveStatusEffects = {}

if CLIENT then
	local statusEffectClass = {}
	
	function statusEffectClass:getText(target)
		return self.text
	end
	
	GM.statusEffectClass = statusEffectClass
end

function GM:registerStatusEffect(data, clientRegisterMethod)
	self.StatusEffects[data.id] = data
	
	if CLIENT then		
		if clientRegisterMethod then
			clientRegisterMethod(data)
		end
	
		data.texture = surface.GetTextureID(data.icon)
		
		setmetatable(data, {__index = GM.statusEffectClass})
	end
end

GM:registerStatusEffect({
	id = "bleeding",
	icon = "ground_control/hud/status/bleeding_icon",
	text = "BLEED"
}, function(data)
	function data:getText(target)
		return self.text .. " X" .. target.bleedGrade
	end
end)

GM:registerStatusEffect({
	id = "crippled_arm",
	icon = "ground_control/hud/status/crippled_arm",
	text = "CRIPPLED"
})

GM:registerStatusEffect({
	id = "healing",
	icon = "ground_control/hud/status/healing",
	text = "RECOVERY",
	dontSend = true
})

-- after getting healed by the M.E.A.D.K.E.A.T.
GM:registerStatusEffect({
	id = "healed",
	icon = "ground_control/hud/status/healed",
	text = "HEALED",
	dontSend = true
}, function(data)
	function data:getText(target)
		return self.text .. " X" .. target.healGrade
	end
end)

-- add a status effect indicating that we're a medic
-- this is so that other people see who the medics are, to promote being healed by a medic over just bandaging yourself
GM:registerStatusEffect({
	id = "medic",
	icon = "ground_control/hud/status/medic",
	text = "MEDIC"
})

local PLAYER = FindMetaTable("Player")

function PLAYER:initStatusEffects()
	-- numeric for rendering (clientside), map for quick checks		
	self.statusEffects = self.statusEffects or {numeric = {}, map = {}}
end

-- set status effects for display on other players (not yourself), to see what's going on with your friends
function PLAYER:setStatusEffect(statusEffect, state) -- on other players
	if CLIENT then -- skip adding status effects on the client if the round is over and we'll be moving on to a new one soon anyway
		if GAMEMODE:isRoundOverTime() then
			return
		end
	end
	
	self:initStatusEffects()
	
	if CLIENT and LocalPlayer() == self then
		if state then
			GAMEMODE:showStatusEffect(statusEffect)
		else
			GAMEMODE:removeStatusEffect(statusEffect)
		end
	end
		
	if not state then
		for key, otherStatusEffect in ipairs(self.statusEffects.numeric) do
			if otherStatusEffect == statusEffect then
				table.remove(self.statusEffects.numeric, key)
				break
			end
		end
		
		self.statusEffects.map[statusEffect] = nil
	else		
		-- make sure this effect is not present yet
		if not self.statusEffects.map[statusEffect] then
			table.insert(self.statusEffects.numeric, statusEffect)
			self.statusEffects.map[statusEffect] = true
		end
	end
	
	if SERVER then
		self:sendStatusEffect(statusEffect, state)
	end
end

function PLAYER:resetStatusEffects() -- on other players
	if not self.statusEffects then
		return
	end
	
	table.Empty(self.statusEffects.numeric)
	table.Empty(self.statusEffects.map)
end

function PLAYER:hasStatusEffect(statusEffect)
	return self.statusEffects and self.statusEffects.map[statusEffect]
end

if SERVER then
	util.AddNetworkString("GC_STATUS_EFFECT_ON_PLAYER")
	util.AddNetworkString("GC_STATUS_EFFECT")
end