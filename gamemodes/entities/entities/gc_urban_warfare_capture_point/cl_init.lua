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
ENT.cooldownText = "Capture cooldown TIME"
ENT.barLength = 100

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
	
	local topSize = _S(self.topSize)
	local topSizeSpaced = _S(self.topSize + self.spacing)
	
	local hudPos = midX - topSizeSpaced * #GAMEMODE.ObjectiveEntities * 0.5
	hudPos = hudPos + topSizeSpaced * (self.dt.PointID - 1) + _S(self.spacing * 0.5)
	
	local fiftyScaled = _S(50)
	local twoScaled = _S(2)
	local oneScaled = _S(1)
	local sixteenScaled = _S(16)
	local fourScaled = _S(4)
	
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(hudPos, fiftyScaled, topSize, topSize)
	surface.DrawOutlinedRect(hudPos, fiftyScaled, topSize, topSize)

	local ourTeam = ply:Team()
	local sameTeam = ourTeam == self.dt.CapturerTeam
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
	
	if coords.visible then
		local ply = LocalPlayer()
		local barWidth = _S(self.barWidth)
		local barHeight = _S(self.barHeight)
		local baseX, baseY = math.Clamp(coords.x, _S(horizontalBoundary), x - _S(horizontalBoundary)), math.Clamp(math.ceil(coords.y), _S(verticalBoundary), y - _S(200))
		local alpha = util.genericObjectiveMarkerAlphaScaler(baseX, baseY, x * 0.5, y * 0.5)
		
		local barX, barY = baseX - barWidth * 0.5, baseY - _S(8)
		
		surface.SetDrawColor(0, 0, 0, 255 * alpha)
		surface.DrawOutlinedRect(barX, barY, barWidth, barHeight)
		
		surface.SetDrawColor(0, 0, 0, 200 * alpha)
		surface.DrawRect(barX + oneScaled, barY + oneScaled, barWidth - twoScaled, barHeight - twoScaled)
		
		surface.SetDrawColor(r, g, b, a * alpha)
		
		
		surface.DrawRect(barX + twoScaled, barY + twoScaled, (barWidth - fourScaled) * percentage, barHeight - fourScaled)
		
		white.a = 255 * alpha
		black.a = 255 * alpha
		draw.ShadowText("Capture " .. self.PointName[self.dt.PointID], "GC_HUD14", baseX, baseY - sixteenScaled, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		white.a = 255
		black.a = 255
	end
	
	local ply = LocalPlayer()
	
	if ply:Alive() and self:isWithinCaptureAABB(ply:GetPos()) then
		local midX, midY = x * 0.5, y * 0.5 + _S(150)
		local finalText = nil 
		
		if CurTime() < self.dt.Cooldown then
			finalText = string.easyformatbykeys(self.cooldownText, "TIME", os.date("%M:%S", self.dt.Cooldown - CurTime()))
		else
			finalText = self.captureText .. self.PointName[self.dt.PointID]
		end
		
		draw.ShadowText(finalText, "GC_HUD24", midX, midY, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		local capBarWidth = _S(self.capBarWidth)
		local capBarHeight = _S(self.capBarHeight)
		
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawOutlinedRect(midX - capBarWidth * 0.5, midY + _S(15), capBarWidth, capBarHeight)
		
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(midX + oneScaled - capBarWidth * 0.5, midY + sixteenScaled, capBarWidth - twoScaled, capBarHeight - twoScaled)
		
		surface.SetDrawColor(r, g, b, 255)
		surface.DrawRect(midX + twoScaled - capBarWidth * 0.5, midY + _S(17), (capBarWidth - fourScaled) * percentage, capBarHeight - fourScaled)
		
		if self.dt.CaptureSpeed ~= 0 then
			draw.ShadowText("SPEED: x" .. math.Round(self.dt.CaptureSpeed, 2), "GC_HUD24", midX, midY + capBarHeight + draw.GetFontHeight("GC_HUD24") + _S(5), white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
	
	local x = ScrW()
	local midX = x * 0.5
	
	GAMEMODE.HUDColors.white.a, GAMEMODE.HUDColors.black.a = 255, 255
	
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(midX - fiftyScaled, _S(10), _S(100), _S(30))
	
	draw.ShadowText(string.ToMinutesSeconds(math.max(self.dt.WaveTimeLimit - CurTime(), 0)), "GC_HUD28", midX, _S(25), GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	local ourTickets, enemyTickets = 0, 0
	
	if ourTeam == TEAM_RED then
		ourTickets = self.dt.RedTicketCount
		enemyTickets = self.dt.BlueTicketCount
	else
		ourTickets = self.dt.BlueTicketCount
		enemyTickets = self.dt.RedTicketCount
	end
	
	local baseY = _S(15)
	local barLength = _S(self.barLength)
	local scaled57 = _S(57)
	local scaled20 = _S(20)
	
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(midX - (barLength + twoScaled) - _S(55), baseY, barLength + twoScaled, scaled20)
	
	local maxTickets = self:GetMaxTickets()
	
	local length = math.ceil((barLength - twoScaled) * ourTickets / maxTickets)
	
	surface.SetDrawColor(124, 185, 255, 255)
	surface.DrawRect(midX - length - scaled57, baseY + twoScaled, length, sixteenScaled)
	
	local length = math.ceil((barLength - twoScaled) * enemyTickets / maxTickets)
	
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(midX + scaled57, baseY, barLength + twoScaled, scaled20)
	
	surface.SetDrawColor(255, 117, 99, 255)
	surface.DrawRect(midX + _S(59), baseY + twoScaled, length, sixteenScaled)
	
	local scaled25 = _S(25)
	draw.ShadowText("US: " .. ourTickets, "GC_HUD20", midX - _S(60), scaled25, GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw.ShadowText("ENEMY: " .. enemyTickets, "GC_HUD20", midX + _S(62), scaled25, GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end