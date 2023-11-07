local radioMaterial = Material("ground_control/hud/radio")
local equipRenderEnable = CreateClientConVar("gc_3dequip_enable","1",true,false,"Render other players equipment?",0,1)

local equiptypes = {
	["pistol"] = {bone = "ValveBiped.Bip01_L_Thigh",offsetvec = Vector(0,0,0),offsetang = Angle(0,0,0)},
	["smg"] = {bone = "ValveBiped.Bip01_Spine1",offsetvec = Vector(0,0,0),offsetang = Angle(0,0,0)},
	["rifle"] = {bone = "ValveBiped.Bip01_Spine2",offsetvec = Vector(0,0,0),offsetang = Angle(0,0,0)},
}

function GM:PreDrawOpaqueRenderables(depthDraw, skyboxDraw)
	-- grab whether the maine menu is visible
	self.gameUIVis = gui.IsGameUIVisible()
	return false
end

function GM:PostPlayerDraw(ply)
	--[[if ply:Alive() and equipRenderEnable:GetBool() then
		if !ply.CSents then ply.CSents = {} end
		local usedholdtypes = {}
		local curwep = ply:GetActiveWeapon()
		for _,wep in ipairs(ply:GetWeapons()) do
			if wep == curwep then
				continue 
			end

			local tbl = wep.gc3d
			if tbl then
				if tbl.type and !usedholdtypes[tbl.type] then
					local modelname = wep:GetWeaponWorldModel()
					if !ply.CSents[modelname] then
						ply.CSents[modelname] = ClientsideModel(modelname)
					end
					local model = ply.CSents[modelname]

					usedholdtypes[tbl.type] = true
				end
			end
		end
	end--]]

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