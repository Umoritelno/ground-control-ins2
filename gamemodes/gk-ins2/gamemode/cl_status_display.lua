-- displays icons related to the state of the player (crippled arms, bleeding, etc.)

GM.IconSize = 64
GM.IconSpacing = 15
GM.IconScaleStart = 2
GM.SmallScale = 1
GM.BigScaleTime = 0.5
GM.SmallScaleApproachRate = 2
GM.StatusEffectsPlayerDist = 128

function GM:resetAllStatusEffects() -- on absolutely everyone (ie on round end)
	for key, ply in ipairs(player.GetAll()) do -- on other players
		ply:resetStatusEffects()
	end
	
	self:removeAllStatusEffects() -- on self
end

function GM:showStatusEffect(id) -- on self
	if self:isRoundOverTime() then
		return
	end
	
	--[[if not LocalPlayer():Alive() then -- should not have status effects added if we're dead
		return
	end]]
	
	for key, effect in ipairs(self.ActiveStatusEffects) do
		if effect.id == id then
			effect.removed = false
			return
		end
	end
	
	table.insert(self.ActiveStatusEffects, {id = id, scale = self.IconScaleStart, bigScaleTime = CurTime() + self.BigScaleTime})
end

function GM:removeStatusEffect(id) -- on self
	for key, effect in ipairs(self.ActiveStatusEffects) do
		if effect.id == id then
			effect.removed = true
		end
	end
	
	return false
end	

function GM:removeAllStatusEffects() -- on self
	if IsValid(LocalPlayer()) then
		LocalPlayer():resetStatusEffects()
	end
	
	table.clear(self.ActiveStatusEffects)
end

GM.BaseStatusEffectX = GM.BaseHUDX + 80
GM.BaseStatusEffectY = 190

function GM:drawStatusEffects(w, h)
	if #self.ActiveStatusEffects > 0 then
		local xPos = ScrW() - _S(self.BaseStatusEffectX)
		local yPos = h - _S(self.BaseStatusEffectY)
		local curTime = CurTime()
		local frameTime = FrameTime()
		
		local curIndex = 1
		local scaleXOff = _S(1)
		local scaleTextYOff = _S(10)
		local iconSpace = _S(self.IconSpacing)
		local iconSize = _S(self.IconSize)
		local ply = LocalPlayer()
		
		for i = 1, #self.ActiveStatusEffects do
			local effect = self.ActiveStatusEffects[curIndex]
			
			if effect.removed then
				effect.scale = math.Approach(effect.scale, 0, frameTime * self.SmallScaleApproachRate)
				
				if effect.scale == 0 then
					table.remove(self.ActiveStatusEffects, curIndex)
					continue
				end
			else
				if curTime > effect.bigScaleTime then
					effect.scale = math.Approach(effect.scale, self.SmallScale, frameTime * self.SmallScaleApproachRate)
				end
			end
			
			local effectData = self.StatusEffects[effect.id]
			local height = iconSize * effect.scale
			local iconSizeOffset = iconSize * 0.5 - height * 0.5
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(effectData.texture)
			surface.DrawTexturedRect(xPos + scaleXOff + iconSizeOffset, yPos - height + scaleXOff, height, height)
			
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(xPos + iconSizeOffset, yPos - height, height, height)
			
			draw.ShadowText(effectData:getText(ply), self.StatusEffectFont, xPos + iconSize * 0.5, yPos + scaleTextYOff, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			xPos = xPos - height - iconSpace
			curIndex = curIndex + 1
		end
	end
end

local PLAYER = FindMetaTable("Player")

function PLAYER:drawStatusEffectsText(target)
	if self.statusEffects then
		local list = self.statusEffects.numeric
		
		if #list > 0 then
			local x, y = _SCRW * 0.5 + _S(150), _SCRH * 0.5
			local datas = GAMEMODE.StatusEffects
			local hudColors = GAMEMODE.HUDColors
			local font = GAMEMODE.StatusEffectFont
			
			hudColors.white.a = 255
			hudColors.black.a = 255
			local scaledSize = _S(32)
			local halfSize = scaledSize * 0.5
			local iconOffset = _S(36)
			local shadowOffset = _S(37)
			local shadowOffsetY = halfSize + _S(1)
			local scaleText = _S(36)
			
			local totalHeight = #list * scaleText + _S(6)
			
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(x - iconOffset - _S(4), y - totalHeight + halfSize + _S(3), _S(120), totalHeight)
			
			for i = 1, #list do
				local this = list[i]
				local data = datas[this]
				
				surface.SetTexture(data.texture)
				
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawTexturedRect(x - iconOffset, y - halfSize, scaledSize, scaledSize)
				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(x - shadowOffset, y - shadowOffsetY, scaledSize, scaledSize)
				
				draw.ShadowText(data:getText(self), font, x, y, hudColors.white, hudColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
				y = y - scaleText
			end
		end
	end
end

-- received status effect on a specific player (not us)
net.Receive("GC_STATUS_EFFECT_ON_PLAYER", function(a, b)
	local playerObject = net.ReadEntity()
	local statusID = net.ReadString()
	local state = net.ReadBool()
	
	if IsValid(playerObject) and playerObject:Alive() then
		playerObject:setStatusEffect(statusID, state)
	end
end)

net.Receive("GC_STATUS_EFFECT", function(a, b)
	local statusID = net.ReadString()
	local state = net.ReadBool()
	
	LocalPlayer():setStatusEffect(statusID, state)
end)