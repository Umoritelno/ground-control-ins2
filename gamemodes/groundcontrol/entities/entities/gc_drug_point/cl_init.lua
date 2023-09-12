include("shared.lua")

local baseFont = "GC_HUD72"

function ENT:Initialize()
	GAMEMODE:addObjectiveEntity(self)
	surface.SetFont(baseFont)
	self.baseHorSize, self.vertFontSize = surface.GetTextSize(self.PrintName)
	self.baseHorSize = self.baseHorSize < 600 and 600 or self.baseHorSize
	self.baseHorSize = self.baseHorSize + 20
	self.halfBaseHorSize = self.baseHorSize * 0.5
	self.halfVertFontSize = self.vertFontSize * 0.5
end

ENT.displayDistance = 256 -- the distance within which the contents of the box will be displayed
ENT.upOffset = Vector(0, 0, 30)

local white, black = Color(255, 255, 255, 255), Color(0, 0, 0, 255)
local horizontalBoundary, verticalBoundary = 75, 75
local point = surface.GetTextureID("ground_control/hud/point_of_interest")

ENT.DeliverText = "Return drugs"

function ENT:Draw()
end

function ENT:drawHUD()
	local lng = GetCurLanguage().gametypes.Drugbust
	local ply = LocalPlayer()
	
	if ply:Team() == GAMEMODE.curGametype.loadoutTeam then
		return
	end
	
	local pos = nil
	
	if not self.ownPos then -- we know that this entity's position isn't going to be changed (it's a static ent) so just get it's position once instead of spamming tables per each draw call
		self.ownPos = self:GetPos()
		self.ownPos.z = self.ownPos.z + 32
	end
	
	pos = self.ownPos
	local alpha = 1
	
	local text = nil
	
	if ply.hasDrugs and not self.dt.HasDrugs then
		text = lng["Return"]
		alpha = alpha * (0.2 + 0.8 * math.flash(CurTime(), 2))
	end
		
	if text then
		local screen = pos:ToScreen()
		local boundH, boundV = _S(horizontalBoundary), _S(verticalBoundary)
		local w, h = ScrW(), ScrH()
		local baseX, baseY = screen.x, screen.y
		
		alpha = alpha * math.max(0.1, math.min(1, math.Dist(baseX - _S(4), baseY - _S(12), w * 0.5, h * 0.5) / 300) ^ 2)
		
		white.a = 255 * alpha
		black.a = 255 * alpha
		
		screen.x = math.Clamp(screen.x, boundH, w - boundH)
		screen.y = math.Clamp(screen.y, boundV, h - boundV)
	
		surface.SetTexture(point)
		surface.SetDrawColor(255, 255, 255, 255 * alpha)
		
		local scaledSixteen = _S(16)
		local scaledEight = scaledSixteen * 0.5
		surface.DrawTexturedRect(screen.x - scaledEight, screen.y - scaledEight - scaledSixteen, scaledSixteen, scaledSixteen)
		draw.ShadowText(text, "GC_HUD20", screen.x, screen.y, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function ENT:Think()
end 