local radioMaterial = Material("ground_control/hud/radio")

function GM:PreDrawOpaqueRenderables(depthDraw, skyboxDraw)
	-- grab whether the maine menu is visible
	self.gameUIVis = gui.IsGameUIVisible()
	return false
end

function GM:PostPlayerDraw(ply)
	ply.withinPVS = true -- set withinPVS to true, if this hook is called on a player object - that means he's within our PVS, meaning we can draw any text on his head we want

	if ply.radioTime and CurTime() > ply.radioTime then
		ply.radioAlpha = math.Approach(ply.radioAlpha, 0, FrameTime() * 511)
	end
	
	if ply.radioAlpha and ply:Alive() and ply.radioAlpha > 0 then
		local headBone = ply:LookupBone("ValveBiped.Bip01_Head1")
		local bonePos = ply:GetBonePosition(headBone)
		self.HUDColors.white.a = ply.radioAlpha
		
		local drawPos = bonePos
		drawPos.z = drawPos.z + 20
		
		render.SetMaterial(radioMaterial)
		render.DrawSprite(drawPos, 16, 16, self.HUDColors.white)
		self.HUDColors.white.a = 255
	end
		
	-- only insert the rendered players into the table if main menu isn't visible
	if not self.gameUIVis and ply ~= self.localPlayer and ply:Team() == self.localPlayerTeam then
		table.insert(self.teamPlayers, ply)
	end
end