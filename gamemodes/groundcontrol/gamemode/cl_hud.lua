local noDraw = {CHudAmmo = true,
	CHudSecondaryAmmo = true,
	CHudHealth = true,
	CHudBattery = true,
	CHudWeaponSelection = true,
	CHudDamageIndicator = true}

local string_format = string.format

function GM:HUDShouldDraw(n)
	if noDraw[n] then
		return false
	end
	
	return true
end

GM.Markers = {}

function GM:AddMarker(position, text, color, displayTime)
	table.insert(self.Markers, {position = position, text = text, color = color, displayTime = CurTime() + displayTime})
end

GM.HUDColors = {white = Color(255, 255, 255, 255),
	black = Color(0, 0, 0, 255),
	blue = Color(122, 168, 255, 255),
	lightRed = Color(255, 137, 119, 255),
	red = Color(255, 100, 86, 255),
	green = Color(190, 255, 190, 255),
	limeYellow = Color(220, 255, 165, 255)
}

GM.Vignette = surface.GetTextureID("ground_control/hud/vignette")
GM.MarkerTexture = surface.GetTextureID("ground_control/hud/marker")
GM.LoadoutAvailableTexture = surface.GetTextureID("ground_control/hud/purchase_available")
GM.WholeScreenAlpha = 0
GM.teamMateMarkerDisplayDistance = 256
GM.markerTime = 0
GM.markerSpeed = 6

GM.traceResultOutput = {}

local traceData = {output = GM.traceResultOutput}
traceData.mask = bit.bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER) -- ignores transparent stuff

GM.BaseHUDX = 80
GM.eventElemDisplayCount = 6
GM.eventSoundDelay = 1
GM.teamPlayers = {}

local gradient = surface.GetTextureID("cw2/gui/gradient")

function GM:HUDPaint()
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	local lang = GetCurLanguage()
	local scrW, scrH = _SCRW, _SCRH
	
	local healthText = nil
	local alive = ply:Alive()
	local curTime = CurTime()
	local frameTime = FrameTime()
	
	if self.DeadState ~= 3 then
		local staminaData = self.StaminaData
		local staminaAlphaTarget = alive and 255 * (1 - ply.stamina / 100) or 255
		staminaData.alpha = Lerp(frameTime * staminaData.approachRate, staminaData.alpha, staminaAlphaTarget)
		
		if staminaData.alpha > 0 then
			surface.SetDrawColor(0, 0, 0, staminaData.alpha)
			surface.SetTexture(self.Vignette)
			surface.DrawTexturedRect(0, 0, scrW, scrH)
		end
		
		local bleedData = self.BleedData
		local targetAlpha = 0
		
		if alive then
			if ply.bleeding then
				if bleedData.lastPulse > math.pi * 2 then
					bleedData.lastPulse = 0
				else
					bleedData.lastPulse = bleedData.lastPulse + frameTime * (bleedData.pulseSpeed + ply.bleedGrade * bleedData.pulsePerGrade)
				end
				
				targetAlpha = bleedData.targetAlpha + bleedData.alphaPerGrade * ply.bleedGrade * math.abs(math.sin(bleedData.lastPulse))
			end
		end
		
		bleedData.alpha = math.Approach(bleedData.alpha, targetAlpha, frameTime * bleedData.approachRate)
		
		if bleedData.alpha > 0 then
			surface.SetDrawColor(255, 0, 0, bleedData.alpha)
			surface.SetTexture(self.Vignette)
			surface.DrawTexturedRect(0, 0, scrW, scrH)
		end
	end
	
	local midX, midY = scrW * 0.5, scrH * 0.5

	if alive then
		local hpPerc = (ply:Health()/ply:GetMaxHealth() * 100)
		healthText = math.max(0, hpPerc) .. "% HEALTH"
		
		surface.SetFont(self.HealthDisplayFont)
		local xSize, ySize = surface.GetTextSize(healthText)
		
		surface.SetFont(self.BandageDisplayFont)
		local bandageText = (ply.bandages or 0) .. "x BANDAGES"
		local bandageX = surface.GetTextSize(bandageText)


		
		xSize = math.max(bandageX, xSize) -- get the biggest text size for the semi-transparent rectangle
		
		local bandageOff = _S(32)
		local baseOffset = _S(82)
		local textX = _S(self.BaseHUDX + 5)
		
		local overallTextHeight = ySize - _S(7) + bandageOff
		surface.SetDrawColor(0, 0, 0, 150)
		local underW = xSize + _S(10)
		surface.DrawRect(scrW - _S(self.BaseHUDX) - underW, scrH - _S(100) - overallTextHeight, xSize + _S(10), overallTextHeight)
		
		draw.ShadowText(healthText, self.HealthDisplayFont, scrW - textX, scrH - baseOffset - overallTextHeight, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw.ShadowText(bandageText, self.BandageDisplayFont, scrW - textX, scrH - baseOffset + bandageOff - overallTextHeight, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		if self.specRoundEnabled then
			local font = "SpecRoundReplace"
			if self.Language == "english" then
				font = "CW_HUD20"
			end
		    local SpecCountText = string_format(lang.specRoundCount,self.GlobalSpecRound)

            local CurSpecRound

		    if self.CurSpecRound then
			 CurSpecRound = self.SpecRounds[self.CurSpecRound].name
		    else 
			 CurSpecRound = "None"
		    end

		    local CurSpecRoundText = string_format(lang.curSpecRound,CurSpecRound)

			draw.ShadowText(CurSpecRoundText, font, scrW * 0.055, scrH * 0.12, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.ShadowText(SpecCountText, font, scrW * 0.054, scrH * 0.1, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		--draw.ShadowText(ply.stamina, self.BandageDisplayFont, 55, scrH - 200, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		local baseX = scrW - _S(145)
		local offset = _S(90)
		local baseY = scrH - _S(50)
		baseX = baseX + self:drawArmor(ply, baseX, baseY)
		
		for key, data in ipairs(ply.gadgets) do
			local posX, posY = baseX, baseY
			data:draw(posX, posY)
			
			baseX = baseX + key * offset
		end
		
		if #self.Markers > 0 then
			local removeIndex = 1
			
			local midX, midY = scrW * 0.5, scrH * 0.5
			local maxXOff, maxYOff = scrW * 0.4, scrH * 0.4
			local scaledSize = _S(12)
			local scaledYOff = _S(16)
			local scaledXOff = _S(6)
			local scaledXOffText = _S(3)
			
			if self.markerTime > math.pi * 2 then
				self.markerTime = math.pi
			else
				self.markerTime = self.markerTime + frameTime * self.markerSpeed
			end
			
			local markerValue = math.abs(math.sin(self.markerTime))
			local markerAlphaValue = 0.5 + 0.5 * markerValue
			local markerYOffset = markerValue * _S(6)
			
			for i = 1, #self.Markers do
				local data = self.Markers[removeIndex]
				
				if curTime > data.displayTime then
					table.remove(self.Markers, removeIndex)
				else
					local coords = data.position:ToScreen()
					local ang = math.atan2(coords.y - midY, coords.x - midX)
					local cos, sin = math.cos(ang), math.sin(ang)
					
					local cX, cY = math.min(midX + maxXOff, math.max(midX - maxXOff, coords.x)), math.min(scrH - 180, math.max(midY - maxYOff, coords.y))
					
					local dist = math.Dist(coords.x, coords.y, midX, midY)
					local alpha = math.Clamp(dist, 30 * markerAlphaValue, 255 * markerAlphaValue)
					
					surface.SetDrawColor(data.color.r, data.color.g, data.color.b, alpha)
					surface.SetTexture(self.MarkerTexture)
					surface.DrawTexturedRect(cX - scaledXOff, cY - scaledYOff - markerYOffset, scaledSize, scaledSize)
					
					self.HUDColors.white.a = alpha
					self.HUDColors.black.a = alpha
					draw.ShadowText(data.text, self.MarkerFont, cX - scaledXOffText, cY, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				
					removeIndex = removeIndex + 1
				end
			end
		end
		
		self.HUDColors.white.a = 255
		self.HUDColors.black.a = 255
		
		self:drawWeaponSelection(scrW, scrH, curTime)
		self:drawStatusEffects(scrW, scrH)
		self:drawLoadoutAvailability(_S(200), scrH)
	end
	
	self.tipController:draw(scrW, scrH)
	
	if not self:isVoteBlocking() then
		self:drawRadioDisplay(frameTime)
	end
	
	self:drawVotePanel()
	
	local elems = self.EventElements
	local cnt = #elems
	
	self.eventSoundTime = math.max(0, self.eventSoundTime - frameTime)
	
	if cnt > 0 then
		local iterRange = math.min(self.eventElemDisplayCount, cnt)
		local rIdx = 1
		local elemYSpace = _S(20)
		local textXOff = _S(2)
		
		for i = 1, iterRange do
			local yPos = _S(75) + elemYSpace * rIdx
			local elemData = elems[rIdx]
			
			if not elemData.displayed then
				if self.eventSoundTime <= 0 then
					surface.PlaySound("ground_control/misc/notify.mp3")
					elemData.displayed = true
					self.eventSoundTime = self.eventSoundDelay
				else
					elemData.displayed = true
				end
			end
			
			local curAlpha = elemData.alpha
			
			self.HUDColors.white.a = curAlpha * 255
			self.HUDColors.black.a = curAlpha * 255
				
			draw.ShadowText(elemData.topText, self.EventFontBig, midX - textXOff, midY + yPos + elemData.yOffset, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			
			if elemData.bottomText then
				local targetColor = nil
				
				if elemData.positive then
					targetColor = self.HUDColors.green
				else
					targetColor = self.HUDColors.red
				end
				
				targetColor.a = curAlpha * 255
				draw.ShadowText(elemData.bottomText, self.EventFontBig, midX + textXOff, midY + yPos + elemData.yOffset, targetColor, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				targetColor.a = 255
			end
			
			elemData.yOffset = Lerp(frameTime * 10, elemData.yOffset, 0)
			elemData.displayTime = elemData.displayTime - frameTime
			
			if elemData.displayTime <= 0 then
				elemData.alpha = math.Approach(elemData.alpha, 0, frameTime * 7)
				
				if elemData.alpha == 0 then
					table.remove(self.EventElements, 1)
				else
					rIdx = rIdx + 1
				end
			else
				elemData.alpha = Lerp(frameTime * 20, elemData.alpha, 1)
				rIdx = rIdx + 1
			end
		end
		
		self.HUDColors.white.a = 255
		self.HUDColors.black.a = 255
	end
	
	if self.DeadState == 1 then
		self.WholeScreenAlpha = math.Approach(self.WholeScreenAlpha, 1, frameTime * 8)
	elseif self.DeadState == 3 or self.DeadState == 0 then
		self.WholeScreenAlpha = math.Approach(self.WholeScreenAlpha, 0, frameTime * 8)
	end
	
	if self.WholeScreenAlpha > 0 then
		surface.SetDrawColor(0, 0, 0, 255 * self.WholeScreenAlpha)
		surface.DrawRect(0, 0, scrW, scrH)
	end
	
	if self.DeadState == 3 then
		local barHeight = _S(50)
		local bindlang = lang.binds 
		
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, scrW, barHeight)
		surface.DrawRect(0, scrH - barHeight, scrW, barHeight)
		
		if IsValid(ply.currentSpectateEntity) then
			draw.ShadowText(string_format(lang.spectating,ply.currentSpectateEntity:Nick()), self.SpectateFont, midX, scrH - _S(35), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		draw.ShadowText(string_format(bindlang.SpectateBind,self:getKeyBind("+attack")), self.DeadFont, midX, scrH - _S(15), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		--[[draw.ShadowText(self:getKeyBind(self.TeamSelectionKey) .. " - team selection menu", "CW_HUD24", 5, 45, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.ShadowText(self:getKeyBind(self.LoadoutMenuKey) .. " - loadout menu", "CW_HUD24", midX, 45, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		draw.ShadowText(self:getKeyBind(self.RadioMenuKey) .. " - voice selection menu", "CW_HUD24", scrW - 5, 45, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)]]--
		
		local xOff = _S(5)
		local font = self.KeyBindsFont
		
		draw.ShadowText(string_format(bindlang.TeamBind,self:getKeyBind(self.TeamSelectionKey)), font, xOff, _S(55), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.ShadowText(string_format(bindlang.LoadoutBind,self:getKeyBind(self.LoadoutMenuKey)), font, xOff, _S(80), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		draw.ShadowText(string_format(bindlang.VoiceBind,self:getKeyBind(self.RadioMenuKey)), font, xOff, _S(105), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		
		if self.curGametype.deadDraw then
			self.curGametype:deadDraw(scrW, scrH)
		end
	end
	
	local teamMateMarkerDisplayDistance = GAMEMODE.teamMateMarkerDisplayDistance
	
	local ourShootPos = ply:GetShootPos()
	local ourAimVec = ply:GetAimVector()
	
	traceData.start = ourShootPos
	traceData.filter = ply
	
	self.canTraceForBandaging = false
	
	-- instead of blasting team.GetPlayers every frame, just use the table that gets filled in cl_render.lua
	for key, obj in ipairs(self.teamPlayers) do
		--if obj.withinPVS then -- only draw the player if we can see him, GMod has no clientside ways of checking whether the player is in PVS, check cl_render.lua for the second part of this
		if self.rolesenable then
			if obj ~= ply and obj:Alive() and ply.plclass and ply.plclass.DisplayName == "Commander" then
				local pos = obj:GetBonePosition(obj:LookupBone("ValveBiped.Bip01_Head1"))
				
				if pos:Distance(ourShootPos) <= teamMateMarkerDisplayDistance then
					self:drawPlayerMarker(pos, obj, midX, midY)
				else
					local direction = (pos - ourShootPos):GetNormal()
					local dotToGeneralDirection = ourAimVec:DotProduct(direction)
					
					if dotToGeneralDirection >= 0.9 then
						traceData.endpos = traceData.start + direction * 4096
						
						local trace = util.TraceLine(traceData)
						local ent = trace.Entity
						
						if IsValid(ent) then
							if ent == obj then
								self:drawPlayerMarker(pos, obj, midX, midY)
							end
						end
					end
				end
			end
		else 
            if obj ~= ply and obj:Alive() then
				local pos = obj:GetBonePosition(obj:LookupBone("ValveBiped.Bip01_Head1"))
				
				if pos:Distance(ourShootPos) <= teamMateMarkerDisplayDistance then
					self:drawPlayerMarker(pos, obj, midX, midY)
				else
					local direction = (pos - ourShootPos):GetNormal()
					local dotToGeneralDirection = ourAimVec:DotProduct(direction)
					
					if dotToGeneralDirection >= 0.9 then
						traceData.endpos = traceData.start + direction * 4096
						
						local trace = util.TraceLine(traceData)
						local ent = trace.Entity
						
						if IsValid(ent) then
							if ent == obj then
								self:drawPlayerMarker(pos, obj, midX, midY)
							end
						end
					end
				end
			end
		end
		
			--obj.withinPVS = false
		--end
		
		-- clear the table each frame, since we don't know when more team mates will become present
		-- this is a quick and dirty alternative to not calling team.GetPlayers every single frame
		-- in order to reduce garbage collector pressure
		self.teamPlayers[key] = nil
	end
	
	if alive then
		self.HUDColors.white.a = 255
		self.HUDColors.black.a = 255
	
		if IsValid(wep) and wep:GetClass() ~= self.MedkitClass then
			local medlang = lang.binds.Medkit
			if ply.bleeding then
				local bnd = string_format(medlang.SwitchYourself,self:getKeyBind(self:getActionKey("bandage")))
				draw.ShadowText(bnd, self.ActionDisplayFont, scrW * 0.5, scrH * 0.5 + _S(50), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				--draw.ShadowText(self:getKeyBind(self:getActionKey("bandage")) .. " - apply bandage", self.ActionDisplayFont, scrW * 0.5, scrH * 0.5 + _S(50), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				--draw.ShadowText(self:getKeyBind(self:getActionKey("bandage")) .. " - switch to medkit", self.ActionDisplayFont, scrW * 0.5, scrH * 0.5 + _S(50), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if self.canTraceForBandaging then -- only trace for bandage validity if we have drawn the marker of another player
					local bandageTarget = ply:getBandageTarget()
					
					if bandageTarget then
						local bind = string_format(medlang.SwitchMate,"KEY")
						draw.ShadowText(string.easyformatbykeys(bind, "KEY", self:getKeyBind(self:getActionKey("bandage")), "PLAYER", bandageTarget:Nick()), self.ActionDisplayFont, scrW * 0.5, scrH * 0.5 + _S(50), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end
			end
		end
		
		local trace = ply:GetEyeTrace()
		
		if trace.Entity and trace.Entity:IsPlayer() and trace.Entity:EyePos():Distance(EyePos()) <= self.StatusEffectsPlayerDist then
			trace.Entity:drawStatusEffectsText()
		end
	end
	
	if ply:Team() ~= TEAM_SPECTATOR then
		for key, obj in ipairs(self.ObjectiveEntities) do
			if IsValid(obj) then
				obj:drawHUD()
			end
		end
		
		for key, obj in ipairs(self.DrawEntities) do
			if IsValid(obj) then
				obj:drawHUD()
			end
		end
	end
	
	self:drawTimeLimit()
	
	self.HUDColors.white.a = 255
	self.HUDColors.black.a = 255
end

GM.LoadoutElementSize = 96
GM.LoadoutElementSizeSpacing = 32
GM.LoadoutFadingOutTimeLeft = 5 -- when time left is less than this until loadout period is over we start fading the icon out
GM.LoadoutFlashTime = 0.5

function GM:drawLoadoutAvailability(w, h)
	--self.loadoutPosition = position
	--self.loadoutDuration = maxDuration
		
	local curTime = CurTime()
	
	if self.loadoutPosition and curTime < self.loadoutDuration then
		local pos = LocalPlayer():GetPos()
		
		if pos:Distance(self.loadoutPosition) <= self.LoadoutDistance then
			local delta = self.loadoutDuration - curTime
			local alpha = 1
			
			if delta <= self.LoadoutFadingOutTimeLeft then
				alpha = math.flash(delta, 1 / self.LoadoutFlashTime)
			end
			
			surface.SetDrawColor(255, 255, 255, 255 * alpha)
			surface.SetTexture(self.LoadoutAvailableTexture)
			
			local elemSize = _S(self.LoadoutElementSize)
			local elemSizeHalf = elemSize * 0.5
			local elemSizeSpacing = _S(self.LoadoutElementSizeSpacing)
			
			surface.DrawTexturedRect(w - elemSize - elemSizeSpacing, h * 0.5 - elemSizeHalf, elemSize, elemSize)
			
			self.HUDColors.white.a, self.HUDColors.black.a = 255 * alpha, 255 * alpha
			
			draw.ShadowText(self:getKeyBind(self.LoadoutMenuKey) .. " - LOADOUT", self.AttachmentSlotDisplayFont, w - elemSizeHalf - elemSizeSpacing, h * 0.5 + elemSizeHalf, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.ShadowText(os.date("%M:%S", delta), self.AttachmentSlotDisplayFont, w - elemSizeHalf - elemSizeSpacing, h * 0.5 + elemSizeHalf + _S(20), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	self.HUDColors.white.a, self.HUDColors.black.a = 255, 255
end

function GM:drawPlayerMarker(pos, obj, midX, midY)
	local coords = pos:ToScreen()
	
	if coords.visible then
		pos.z = pos.z + _S(8)
		surface.SetTexture(self.MarkerTexture)
		local nickXOff = _S(4)
		local nickYOff = _S(10)
		local nameDorito = _S(8)
		
		local dist = math.Dist(coords.x, coords.y, midX, midY)
		local alpha = math.Clamp(dist, 30, 255)
		
		self.HUDColors.white.a = alpha
		self.HUDColors.black.a = alpha
		
		draw.ShadowText(obj:Nick(), self.MarkerFont, coords.x + nickXOff, coords.y - nickYOff, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local healthColor = 1 - (obj:Health() / 100)
		surface.SetDrawColor(200 + healthColor * 255, 255 - healthColor * 155, 200 - healthColor * 100, alpha)
		surface.DrawTexturedRect(coords.x, coords.y, nameDorito, nameDorito)
		
		if obj.statusEffects then
			local statusEffects = GAMEMODE.StatusEffects
			local statEffXOff = _S(13)
			local xPos = coords.x + statEffXOff
			local oneOff = _S(1)
			local size = nickYOff
			
			for key, statusEffectID in ipairs(obj.statusEffects.numeric) do
				local data = statusEffects[statusEffectID]
				
				surface.SetTexture(data.texture)
				
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawTexturedRect(xPos, coords.y, size, size)
				
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(xPos - oneOff, coords.y - oneOff, size, size)
				
				xPos = xPos + statEffXOff
			end
			
			if obj.statusEffects.map.bleeding or obj.statusEffects.map.crippled_arm then -- if the target is bleeding and we can draw his coords, we can then run a trace to check whether we can bandage him
				self.canTraceForBandaging = true
			end
		end
	end
end

function GM:createRoundOverDisplay(winTeam, actionType)
	local lang = GetCurLanguage()
	self.roundOverTime = CurTime() + GAMEMODE.RoundRestartTime - 1
	
	local popup = vgui.Create("GCRoundOver")
	popup:SetSize(_S(350), _S(50))
	popup:SetRestartTime(GAMEMODE.RoundRestartTime)
	
	if winTeam then
		popup:SetWinningTeam(winTeam)
		
		if actionType == self.RoundOverAction.RANDOM_MAP_AND_GAMETYPE then
			popup:SetBottomText(lang.round_switch)
		end
		
		local retVal
		
		if self.curGametype.modulateRoundEndMusic then
			retVal = self.curGametype:modulateRoundEndMusic(winTeam)
		end
		
		if retVal then
			self:playMusic(retVal, nil, self.RoundEndTrackVolume)
		else
			if winTeam == LocalPlayer():Team() then			
				self:playMusic(self.RoundEndMusicObjects[math.random(1, #self.RoundEndMusicObjects)], nil, self.RoundEndTrackVolume)
			end
		end
	else
		popup:SetTopText(lang.match_start)
		
		if actionType == self.RoundOverAction.NEW_ROUND then
			popup:SetBottomText(lang.round_end)
		elseif actionType == self.RoundOverAction.RANDOM_MAP_AND_GAMETYPE then
			popup:SetBottomText(lang.round_switch)
		end
	end
	
	popup:Center()
	
	local x, y = popup:GetPos()
	popup:SetPos(x, y - _S(200))
	
	self:clearObjectiveEntities()
	self:clearDrawEntities()
	
	self.lastPopup = popup
end

function GM:createRoundPreparationDisplay(preparationTime)
	self:resetVisualAdrenaline()
	self:resetVisualStamina()
		
	local result = vgui.Create("GCRoundPreparation")
	result:SetPrepareTime(preparationTime - CurTime())
	result:SetSize(_S(310), _S(50))
	result:Center()
	
	local x, y = result:GetPos()
	result:SetPos(x, y - _S(200))
	
	self.PreparationTime = preparationTime
	
	local retVal

	if self.curGametype.modulateRoundStartMusic then
		retVal = self.curGametype:modulateRoundStartMusic()
	end
	
	if retVal then
		self:playMusic(retVal, nil, self.RoundStartTrackVolume)
	else
		self:playMusic(self.RoundStartMusicObjects[math.random(1, #self.RoundStartMusicObjects)], nil, self.RoundStartTrackVolume)
	end
	
	if self.curGametype.roundStart then
		self.curGametype:roundStart()
	end
	
	self.tipController:handleEvent("WEAPON_CUSTOMIZATION")
	
	self.lastPopup = result
end

function GM:createLastManStandingDisplay()
	local lang = GetCurLanguage()
	local popup = vgui.Create("GCGenericPopup")
	popup:SetSize(_S(310), _S(50))
	popup:SetText(lang.lastManStatus, table.Random(lang.lastManPhrases))
	popup:SetExistTime(5)
	popup:Center()
	
	local x, y = popup:GetPos()
	popup:SetPos(x, y - 200)
	
	surface.PlaySound("ground_control/misc/last_man_standing.mp3")
	
	self.lastPopup = popup
end

GM.KilledByPanelWidth = 400
GM.KilledByEntryBaseYPos = 26
GM.KilledByBaseSize = 28
GM.KilledByEntrySize = 52

function GM:createKilledByDisplay(killerPlayer, entClassString)
	local lang = GetCurLanguage().death
	if self.KilledByPanel and self.KilledByPanel:IsValid() then
		self.KilledByPanel:Remove()
		self.KilledByPanel = nil
	end
	
	local entClass = weapons.Get(entClassString) or scripted_ents.Get(entClassString)
	
	local baseHeight = _S(self.KilledByEntrySize + self.KilledByBaseSize)
	local panel = vgui.Create("GCPanel") 
	panel:SetFont("GC_HUD20")
	panel:SetText(lang.KilledBy)
	panel:SetSize(_S(self.KilledByPanelWidth), baseHeight)
	panel:CenterHorizontal()

	local x, y = panel:GetPos()
	panel:SetPos(x, math.min(_SCRH * 0.5 + baseHeight * 2, _SCRH - panel:GetTall()))
	
	self.KilledByPanel = panel
	
	local mvp = vgui.Create("GCKillerDisplay", panel)
	mvp:SetPos(_S(2), _S(self.KilledByEntryBaseYPos))
	mvp:SetSize(_S(self.KilledByPanelWidth - 4), _S(self.KilledByEntrySize))
	mvp:SetKillData(killerPlayer, entClass or entClassString)
	
	timer.Simple(5, function()
		panel:Remove()
	end)
end