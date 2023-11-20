local leftvignette = Material("vgui/gradient-l")
local rightvignette = Material("vgui/gradient-r")
local bluecolor = Color(GM.TeamBlueColor2.r,GM.TeamBlueColor2.g,GM.TeamBlueColor2.b,120)
local redcolor = Color(GM.TeamRedColor2.r,GM.TeamRedColor2.g,GM.TeamRedColor2.b,120)

function GM:drawTimeLimit()
	if self.TimeLimit then
		local lply = LocalPlayer()
		local teamplayercount = self.aliveTeamPlayersCount
		local x = _SCRW
		local midX = x * 0.5
		local y = _S(10)
		
		if not LocalPlayer():Alive() then
			y = y + _S(75)
		end
		
		self.HUDColors.white.a, self.HUDColors.black.a = 255, 255
		
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(midX - _S(50), y, _S(100), _S(30))
		draw.ShadowText(string.ToMinutesSeconds(math.max(self.RoundTime - CurTime(), 0)), self.ObjectiveFont, midX, y + _S(15), self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if !self.curGameType.playerAmountOverride then
			surface.SetDrawColor(redcolor:Unpack())
			surface.SetMaterial(leftvignette)
			surface.DrawTexturedRect(midX + _S(50),y,_S(150),_S(30))
			draw.ShadowText(lply:Team() == TEAM_RED and teamplayercount or self.AlivePlayers[TEAM_RED],self.ObjectiveFont,midX + _S(65),y + _S(15),self.HUDColors.white,self.HUDColors.black,1,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
			surface.SetDrawColor(bluecolor:Unpack())
			surface.SetMaterial(rightvignette)
			surface.DrawTexturedRect(midX - _S(200),y,_S(150),_S(30))
			draw.ShadowText(lply:Team() == TEAM_BLUE and teamplayercount or self.AlivePlayers[TEAM_BLUE],self.ObjectiveFont,midX - _S(65),y + _S(15),self.HUDColors.white,self.HUDColors.black,1,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
		end
		
	end
end

function GM:setTimeLimit(start, duration)
	self.TimeLimit = duration
	self.RoundStart = start
	self.RoundTime = start + duration
end

local function GC_TimeLimit(data)
	local start = data:ReadFloat()
	local duration = data:ReadFloat()
	
	GAMEMODE:setTimeLimit(start, duration)
end

usermessage.Hook("GC_TIMELIMIT", GC_TimeLimit)