include('shared.lua')

surface.CreateFont("CumBombFont", {
	font = "Roboto Cn", 
	size = ScreenScale(8),
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("CumBombFont_Blur", {
	font = "Roboto Cn", 
	size = ScreenScale(8),
	weight = 500,
	blursize = 4,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

SWEP.blurTextColor = Color(0, 0, 0, 255)
SWEP.textColor = Color(255, 255, 255, 255)

function SWEP:DrawHUD()
	local cBall = self:GetCumball()
	
	local w = ScreenScale(60)
	local h = ScreenScale(4)
	
	local wCenter = ScrW() * 0.5
	local cX, cY = wCenter - w * 0.5, ScrH() * 0.5
	cY = cY + ScreenScale(70)
	
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(cX, cY, w, h)
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawRect(cX - ScreenScale(1), cY - ScreenScale(1), w * (cBall / self.CumBombCoolDown), h)
	
	local text = self:getCumBombChargeText()
	
	for i = 1, 2 do
		draw.SimpleText(text, "CumBombFont_Blur", wCenter, cY - ScreenScale(6), self.blurTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
	
	draw.SimpleText(text, "CumBombFont", wCenter, cY - ScreenScale(6), self.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
end

function SWEP:getCumBombChargeText()
	return "Cum Bomb " .. math.floor(self:GetCumball() / self.CumBombCoolDown * 100) .. "%"
end