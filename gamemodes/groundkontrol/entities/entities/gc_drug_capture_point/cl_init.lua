include("shared.lua")

local displayFont = "GC_HUD14"

function ENT:Initialize()
	GAMEMODE:addObjectiveEntity(self)
end

local white, black = Color(255, 255, 255, 255), Color(0, 0, 0, 255)
ENT.CaptureText = "Drug drop point"
ENT.DeliverText = "Capture drugs"
ENT.PreventCaptureText = "Prevent capture"

local horizontalBoundary, verticalBoundary = 75, 75
local point = surface.GetTextureID("ground_control/hud/point_of_interest")

function ENT:resetDefendersText()
	self.showDefendText = false
end

function ENT:verifyDefendersText()
	self.showDefendText = false
	
	for key, obj in ipairs(GAMEMODE.ObjectiveEntities) do
		if obj:GetClass() == "gc_drug_point" then
			if not obj.dt.HasDrugs then
				self.showDefendText = true
				break
			end
		end
	end
end

function ENT:drawHUD()
	local ply = LocalPlayer()
	local lang = GetCurLanguage().gametypes.Drugbust
	
	local pos = nil
	
	if not self.ownPos then -- we know that this entity's position isn't going to be changed (it's a static ent) so just get it's position once instead of spamming tables per each draw call
		self.ownPos = self:GetPos()
		self.ownPos.z = self.ownPos.z + 32
	end
	
	pos = self.ownPos
	
	local text = nil
	local alpha = 1
	local skipVisCheck = false
	
	if ply:Team() == GAMEMODE.curGametype.regularTeam then
		if self.showDefendText then
			text = lang["PreventCapture"]
			skipVisCheck = true
			alpha = alpha * (0.2 + 0.8 * math.flash(CurTime(), 2))
		else
			return
		end
	else
		if ply.hasDrugs then
			text = lang["Deliver"]
			skipVisCheck = true
			alpha = alpha * (0.2 + 0.8 * math.flash(CurTime(), 2))
		else
			text = lang["DrugPoint"]
		end
	end
	
	local screen = pos:ToScreen()
	
	if screen.visible or skipVisCheck then
		local boundH = _S(horizontalBoundary)
		
		screen.x = math.Clamp(screen.x, boundH, ScrW() - boundH)
		screen.y = math.Clamp(screen.y, _S(verticalBoundary), ScrH() - _S(200))
		
		alpha = alpha * util.genericObjectiveMarkerAlphaScaler(screen.x, screen.y, ScrW() * 0.5, ScrH() * 0.5)
		white.a = 255 * alpha
		black.a = 255 * alpha
		
		if skipVisCheck then
			surface.SetTexture(point)
			surface.SetDrawColor(255, 255, 255, 255 * alpha)
			surface.DrawTexturedRect(screen.x - _S(8), screen.y - _S(24), _S(16), _S(16))
		end
		
		draw.ShadowText(text, displayFont, screen.x, screen.y, white, black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function ENT:Think()
end 