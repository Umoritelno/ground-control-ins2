include('shared.lua')

ENT.PointName = {"A", "B", "C", "D", "E", "F"}
ENT.PointName[0] = "" -- muh lua errors

function ENT:Initialize()
	GAMEMODE:addObjectiveEntity(self)
end

function ENT:Think()
	--[[if self.lastCapture then
		if self.dt.CaptureProgress > self.lastCapture then
		
		end
	end
	
	self.lastCapture = self.dt.CaptureProgress]]--
end

ENT.barWidth = 60
ENT.barHeight = 8

ENT.capBarWidth = 100
ENT.capBarHeight = 10

ENT.topSize = 30
ENT.spacing = 10

ENT.captureText = "Capturing "
ENT.defendText = "Defending "

function ENT:getProgressColor(sameTeam)
	if sameTeam then
		return 124, 185, 255, 255
	else
		return 255, 117, 99, 255
	end
end

local horizontalBoundary, verticalBoundary = 75, 75

function ENT:drawHUD()
	local x, y = ScrW(), ScrH()
	local midX = x * 0.5
	local lang = GetCurLanguage().gametypes.Rush
	
	local topSize = _S(self.topSize)
	local topSizeSpaced = _S(self.topSize + self.spacing)
	
	local hudPos = midX - topSizeSpaced * #GAMEMODE.ObjectiveEntities * 0.5
	hudPos = hudPos + topSizeSpaced * (self.dt.PointID - 1) + _S(self.spacing * 0.5)

	local fiftyScaled = _S(50)
	local twoScaled = _S(2)
	local oneScaled = _S(1)
	
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(hudPos, fiftyScaled, topSize, topSize)
	surface.DrawOutlinedRect(hudPos, fiftyScaled, topSize, topSize)
	
	local sameTeam = ply:Team() == self.dt.CapturerTeam
	local r, g, b, a = self:getProgressColor(sameTeam)
	local percentage = self.dt.CaptureProgress / 100
	
	if percentage > 0 then
		surface.SetDrawColor(r, g, b, a)
		surface.DrawRect(hudPos + oneScaled, _S(51), (topSize - twoScaled) * percentage, topSize - twoScaled)
	end
	
	local white, black = GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black
	
	white.a = 255
	black.a = 255
		
	draw.ShadowText(self.PointName[self.dt.PointID], "GC_HUD24", hudPos + topSize * 0.5, fiftyScaled + topSize * 0.5, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local pos = self:GetPos()
	pos.z = pos.z + 32
	
	local coords = pos:ToScreen()
	
	
	--if coords.visible then
		local barWidth = _S(self.barWidth)
		local barHeight = _S(self.barHeight)
		
		local ply = LocalPlayer()
		local baseX, baseY = math.Clamp(coords.x, _S(horizontalBoundary), x - _S(horizontalBoundary)), math.Clamp(math.ceil(coords.y), _S(verticalBoundary), y - _S(200))
		local alpha = util.genericObjectiveMarkerAlphaScaler(baseX, baseY, x * 0.5, y * 0.5)
		
		local barX, barY = baseX - barWidth * 0.5, baseY - _S(8)
		
		surface.SetDrawColor(0, 0, 0, 255 * alpha)
		surface.DrawOutlinedRect(barX, barY, barWidth, barHeight)
		
		surface.SetDrawColor(0, 0, 0, 200 * alpha)
		surface.DrawRect(barX + oneScaled, barY + oneScaled, barWidth - twoScaled, barHeight - twoScaled)
		
		surface.SetDrawColor(r, g, b, a * alpha)
		
		surface.DrawRect(barX + twoScaled, barY + twoScaled, (barWidth - _S(4)) * percentage, barHeight - _S(4))
		
		white.a = 255 * alpha
		black.a = 255 * alpha
		
		draw.ShadowText(lang["Capture&Protect"][sameTeam] .. self.PointName[self.dt.PointID], "GC_HUD14", baseX, baseY - _S(16), white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		white.a = 255
		black.a = 255
	--end
	
	local ply = LocalPlayer()
	
	if ply:Alive() and ply:GetPos():Distance(pos) <= self.dt.CaptureDistance then
		local midX, midY = x * 0.5, y * 0.5 + _S(150)
		local desiredText = lang["Status"][sameTeam]
		draw.ShadowText(desiredText .. self.PointName[self.dt.PointID], "GC_HUD24", midX, midY, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local capBarWidth = _S(self.capBarWidth)
		local capBarHeight = _S(self.capBarHeight)
		local fourScaled = _S(4)
		
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(midX - capBarWidth * 0.5, midY + _S(15), capBarWidth, capBarHeight)
		
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(midX + oneScaled - capBarWidth * 0.5, midY + _S(16), capBarWidth - twoScaled, capBarHeight - twoScaled)
		
		surface.SetDrawColor(r, g, b, 255)
		surface.DrawRect(midX + twoScaled - capBarWidth * 0.5, midY + _S(17), (capBarWidth - fourScaled) * percentage, capBarHeight - fourScaled)
		
		if self.dt.CaptureSpeed ~= 0 then
			draw.ShadowText(lang["Speed"] .. math.Round(self.dt.CaptureSpeed, 2), "GC_HUD24", midX, midY + capBarHeight + draw.GetFontHeight("GC_HUD24") + _S(5), white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end