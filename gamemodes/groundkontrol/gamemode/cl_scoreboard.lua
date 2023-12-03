function GM:sortScoreboardPlayers(t, out)
	local lp = LocalPlayer()
	local ply = team.GetPlayers(t)
	local PTBL = out or {}
		
	for k, v in ipairs(ply) do
		local n1, f1, d1 = v:GetNWInt("GC_SCORE"), v:Name(), v:Deaths()
		local slot = #ply
		
		for k2, v2 in ipairs(ply) do
			if v != v2 then
				local n2, f2, d2 = v2:GetNWInt("GC_SCORE"), v2:Name(), v2:Deaths()
				
				if n1 > n2 then
					slot = slot - 1
				elseif n1 == n2 then
					if d1 < d2 then
						slot = slot - 1
					elseif d1 == d2 then
						if f1 < f2 then
							slot = slot - 1
						end
					end
				end
			end
		end
		
		PTBL[slot] = v
	end
	
	return PTBL
end

function GM:ScoreboardShow()
	if self.scoreboardPanel and self.scoreboardPanel:IsValid() then
		self.scoreboardPanel:Remove()
	end
	
	self.ShowScoreboard = true
	self:setupScoreboard()
end

function GM:ScoreboardHide()
	self.ShowScoreboard = false
	self:killScoreboard()
end

function GM:setupScoreboard()
	self.scoreboardPanel = vgui.Create("GCScoreboardPanel")
	self.scoreboardPanel:SetSize(_S(920), _S(500))
	self.scoreboardPanel:Center()
	self.scoreboardPanel:doLayout()
	
	gui.EnableScreenClicker(false)
	self.showMouseScoreboard = false
end

function GM:killScoreboard()
	if self.scoreboardPanel and self.scoreboardPanel:IsValid() then
		self.scoreboardPanel:Remove()
	end
	
	gui.EnableScreenClicker(false)
	self.showMouseScoreboard = false
end

function GM:scoreboardHandleMouse()
	if self.ShowScoreboard and not self.showMouseScoreboard then
		gui.EnableScreenClicker(true)
		self.showMouseScoreboard = true
		return true
	end
	
	return false
end

function GM:HUDDrawScoreBoard()
end