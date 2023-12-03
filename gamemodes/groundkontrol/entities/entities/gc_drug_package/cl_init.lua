include("shared.lua")

local baseFont = "CW_HUD72"
ENT.RetrieveAndProtect = "Retrieve & protect"
ENT.ProtectText = "Protect"
ENT.AttackAndCapture = "Attack & capture"
ENT.CaptureText = "Capture"
ENT.BasicText = "Drugs"

function ENT:Initialize()
	GAMEMODE:addObjectiveEntity(self)
	surface.SetFont(baseFont)
	self.baseHorSize, self.vertFontSize = surface.GetTextSize(self.BasicText)
	self.baseHorSize = self.baseHorSize < 600 and 600 or self.baseHorSize
	self.baseHorSize = self.baseHorSize + 20
	self.halfBaseHorSize = self.baseHorSize * 0.5
	self.halfVertFontSize = self.vertFontSize * 0.5
	GAMEMODE:AddRadarMarker({origin = Entity(self:EntIndex()),color = Color(255,94,0,175),
    filter = function(self)
        if !IsValid(self.origin) then
			return "delete" 
        end

        return true
    end,
    drawoverride = function(x,y,w,h,color,ang,out)
		if out then
			surface.DrawTexturedRectRotated(x,y,w,h,ang)
		else 
			draw.RoundedBox(30,x,y,w,h,color)
		end
    end})
end

ENT.displayDistance = 128 -- the distance within which the contents of the box will be displayed

function ENT:Think()
	self.inRange = LocalPlayer():GetPos():Distance(self:GetPos()) <= self.displayDistance
end

local white, black = Color(255, 255, 255, 255), Color(0, 0, 0, 255)

function ENT:Draw()
	local lng = GetCurLanguage().gametypes.Drugbust
	self:DrawModel()
	
	local ply = LocalPlayer()
	
	if not self.inRange then
		return
	end
	
	local eyeAng = EyeAngles()
	eyeAng.p = 0
	eyeAng.y = eyeAng.y - 90
	eyeAng.r = 90
	
	local pos = self:GetPos()
	pos.z = pos.z + 30
	
	cam.Start3D2D(pos, eyeAng, 0.05)
		local clrs = CustomizableWeaponry.ITEM_PACKS_TOP_COLOR
		surface.SetDrawColor(clrs.r, clrs.g, clrs.b, clrs.a)
		surface.DrawRect(-self.halfBaseHorSize, 0, self.baseHorSize, self.vertFontSize)
		
		draw.ShadowText(lng["Drugs"], baseFont, 0, self.halfVertFontSize, white, black, 2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end

local displayFont = "GC_HUD14"
local horizontalBoundary, verticalBoundary = 75, 75
local point = surface.GetTextureID("ground_control/hud/point_of_interest")

function ENT:drawHUD()
	local lng = GetCurLanguage().gametypes.Drugbust
	if not self.inRange then
		local ply = LocalPlayer()
		
		local pos = self:GetPos()
		pos.z = pos.z + 32
		local screen = pos:ToScreen()
		local w, h = ScrW(), ScrH()
		
		local text = nil
		local gametype = GAMEMODE.curGametype
		local team = ply:Team()
		
		local alpha = ply.hasDrugs and 0.4 or 1
			
		if self.dt.Dropped then
			text = team == gametype.loadoutTeam and lng["Capture"] or lng["Retrieve&Protect"]
			alpha = alpha * (0.25 + 0.75 * math.flash(CurTime(), 1.5))
		else
			text = team == gametype.loadoutTeam and lng["Attack&Capture"] or lng["Protect"]
		end

		local baseX, baseY = math.Clamp(screen.x, _S(horizontalBoundary), w - _S(horizontalBoundary)), math.Clamp(screen.y, _S(verticalBoundary), h - _S(200))
		alpha = alpha * util.genericObjectiveMarkerAlphaScaler(baseX - _S(4), baseY - _S(12), w * 0.5, h * 0.5) -- math.max(0.1, math.min(1, math.Dist(baseX - _S(4), baseY - _S(12), w * 0.5, h * 0.5) / 300) ^ 2)
		
		surface.SetTexture(point)
		surface.SetDrawColor(255, 255, 255, 255 * alpha)
		surface.DrawTexturedRect(baseX - _S(8), baseY - _S(24), _S(16), _S(16))
		
		white.a = 255 * alpha
		black.a = 255 * alpha
				
		draw.ShadowText(text, displayFont, baseX, baseY, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end