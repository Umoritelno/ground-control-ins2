AddCSLuaFile()
local LeanOffset = 16

local function CreateReplConVar(cvarname, cvarvalue, description)
	return CreateConVar(cvarname, cvarvalue, CLIENT and {FCVAR_REPLICATED} or {FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, description)
end

-- replicated only on clients, archive/notify on server
local cv_autolean = CreateReplConVar("sv_tfa_lean_automatic", 1, "Automatically lean during ADS?")

if CLIENT then
    local lean1 = CreateClientConVar("gc_lean_left","81",true,true,"Button for left lean",1,159)
    local lean2 = CreateClientConVar("gc_lean_right","82",true,true,"Button for right lean",1,159)
    --LocalPlayer():SetNWInt("leanleftKey",lean1:GetInt())
    --LocalPlayer():SetNWInt("leanrightKey",lean2:GetInt())

    GM:registerAutoUpdateConVar("gc_lean_left",function(cnv,old,new)
        LocalPlayer():SetNWInt("leanleftKey",new)
    end)
    GM:registerAutoUpdateConVar("gc_lean_right",function(cnv,old,new)
        LocalPlayer():SetNWInt("leanrightKey",new)
    end)
end

--[[Shared]]
local function MetaInitLean()
	local PlayerMeta = FindMetaTable("Player")
	PlayerMeta.LeanGetShootPosOld = PlayerMeta.LeanGetShootPosOld or PlayerMeta.GetShootPos
	PlayerMeta.LeanEyePosOld = PlayerMeta.LeanEyePosOld or PlayerMeta.GetShootPos
	PlayerMeta.GetNW2Int = PlayerMeta.GetNW2Int or PlayerMeta.GetNWFloat
	PlayerMeta.SetNW2Int = PlayerMeta.SetNW2Int or PlayerMeta.SetNWFloat

	function PlayerMeta:GetShootPos()
		if not IsValid(self) or not self.LeanGetShootPosOld then return end
		local ply = self
		local status = ply.TFALean or ply:GetNW2Int("TFALean")
		local off = Vector(0, status * -LeanOffset, 0)
		off:Rotate(self:EyeAngles())
		local gud, ret = pcall(self.LeanGetShootPosOld, self)

		if gud then
			return ret + off
		else
			return off
		end
	end

	function PlayerMeta:GetShootPos()
		if not IsValid(self) or not self.LeanGetShootPosOld then return end
		local ply = self
		local status = ply.TFALean or ply:GetNW2Int("TFALean")
		local off = Vector(0, status * -LeanOffset, 0)
		off:Rotate(self:EyeAngles())
		local gud, ret = pcall(self.LeanGetShootPosOld, self)

		if gud then
			return ret + off
		else
			return off
		end
	end

	function PlayerMeta:EyePos()
		if not IsValid(self) then return end
		local gud, pos, ang = pcall(self.GetShootPos, self)

		if gud then
			return pos, ang
		else
			return vector_origin, angle_zero
		end
	end

	hook.Add("ShutDown", "TFALeanPMetaCleanup", function()
		if PlayerMeta.LeanGetShootPosOld then
			PlayerMeta.GetShootPos = PlayerMeta.LeanGetShootPosOld
			PlayerMeta.LeanGetShootPosOld = nil
		end
	end)

	MetaOverLean = true
end

pcall(MetaInitLean)

hook.Add("PlayerSpawn", "TFALeanPlayerSpawn", function(ply)
	ply:SetNW2Int("TFALean", 0)
	ply.TFALean = 0
	ply.LeanCD = 0
end)

--[[Lean Calculations]]
local targ
local autoLeanDist = 20
local traceRes, traceResLeft, traceResRight

local traceData = {
	["mask"] = MASK_SOLID,
	["collisiongroup"] = COLLISION_GROUP_DEBRIS,
	["mins"] = Vector(-4, -4, -4),
	["maxs"] = Vector(4, 4, 4)
}

local function AngleOffset(new, old)
	local _, ang = WorldToLocal(vector_origin, new, vector_origin, old)

	return ang
end

local function RollBone(ply, bone, roll)
	ply:ManipulateBoneAngles(bone, angle_zero)

	if CLIENT then
		ply:SetupBones()
	end

	local boneMat = ply:GetBoneMatrix(bone)
	local boneAngle = boneMat:GetAngles()
	local boneAngleOG = boneMat:GetAngles()
	boneAngle:RotateAroundAxis(ply:EyeAngles():Forward(), roll)
	ply:ManipulateBoneAngles(bone, AngleOffset(boneAngle, boneAngleOG))

	if CLIENT then
		ply:SetupBones()
	end
end

function TFALeanModel()
	for k, ply in ipairs(player.GetAll()) do
		ply.TFALean = Lerp(FrameTime() * 10, ply.TFALean or 0, ply:GetNW2Int("TFALean")) --unpredicted lean which gets synched with our predicted lean status
		local lean = ply.TFALean
		local bone = ply:LookupBone("ValveBiped.Bip01_Spine")

		if bone then
			RollBone(ply, bone, lean * 15)
		end

		bone = ply:LookupBone("ValveBiped.Bip01_Spine1")

		if bone then
			RollBone(ply, bone, lean * 15)
		end
	end
end

hook.Add("Move", "TFALeanThink", function(ply)
	if not ply:Alive() then return end 
	targ = (ply.leftBool and -1 or ply.rightBool and 1 or 0)
	--autolean here(No auto lean here)
	local wep = ply:GetActiveWeapon()

	--[[if targ == 0 and cv_autolean:GetBool() and ((wep.GetIronSights and wep:GetIronSights()) or (wep.GetIronsights and wep:GetIronsights())) then
		local headpos = ply.LeanGetShootPosOld and ply:LeanGetShootPosOld() or ply:GetShootPos()
		traceData.start = headpos
		traceData.endpos = traceData.start + ply:EyeAngles():Forward() * autoLeanDist
		traceRes = util.TraceHull(traceData)

		if traceRes.Hit and traceRes.Fraction < 1 then
			traceData.start = headpos - ply:EyeAngles():Right() * LeanOffset
			traceData.endpos = traceData.start + ply:EyeAngles():Forward() * autoLeanDist * 2
			traceResLeft = util.TraceLine(traceData)
			traceData.start = headpos + ply:EyeAngles():Right() * LeanOffset
			traceData.endpos = traceData.start + ply:EyeAngles():Forward() * autoLeanDist * 2
			traceResRight = util.TraceLine(traceData)

			if traceResLeft.Fraction > 1 or not traceResLeft.Hit then
				targ = -1
			elseif traceResRight.Fraction > 1 or not traceResRight.Hit then
				targ = 1
			end
		end
	end
	--]]
    if !GAMEMODE.LeanEnabled then
		ply:SetNW2Int("TFALean", 0)
		return 
	else 
		ply:SetNW2Int("TFALean", targ)
	end

	if SERVER then
		for _, v in ipairs(player.GetAll()) do
			v.TFALean = Lerp(FrameTime() * 10, v.TFALean or 0, v:GetNW2Int("TFALean")) --unpredicted lean which gets synched with our predicted lean status
		end
	end
end)

hook.Add( "PlayerButtonUp", "ButtonUpLeanController", function( ply, button )
	--[[if button == ply:GetNWInt("leanleftKey",81) then
        ply.leftBool = false 
    end
    if button == ply:GetNWInt("leanrightKey",82) then
        ply.rightBool = false
    end
	--]]
end)

hook.Add( "PlayerButtonDown", "ButtonUpLeanController", function( ply, button )
	--[[if button == ply:GetNWInt("leanleftKey",81) then
        ply.leftBool = true 
    end
    if button == ply:GetNWInt("leanrightKey",82) then
        ply.rightBool = true
    end--]]
	if !GAMEMODE.LeanEnabled then return end 
	if (ply.LeanCD or 0) <= CurTime() then
		ply.LeanCD = CurTime() + 1.75
		if button == ply:GetNWInt("leanleftKey",81) then
			if ply.leftBool == true then
				ply.leftBool = false 
			else 
				ply.rightBool = false 
				ply.leftBool = true 
			end
		elseif button == ply:GetNWInt("leanrightKey",82) then 
			if ply.rightBool == true then
				ply.rightBool = false 
			else 
				ply.leftBool = false 
				ply.rightBool = true 
			end
		end
	end
end)

if SERVER and not game.SinglePlayer() then
	timer.Create("TFALeanSynch", 0.2, 0, function()
		for k, v in ipairs(player.GetAll()) do
			local lean = v:GetNW2Int("TFALean")
			v.OldLean = v.OldLean or lean

			if lean ~= v.OldLean then
				v.OldLean = lean
				local bone = v:LookupBone("ValveBiped.Bip01_Spine")

				if bone then
					RollBone(v, bone, lean * 15)
				end

				bone = v:LookupBone("ValveBiped.Bip01_Spine1")

				if bone then
					RollBone(v, bone, lean * 15)
				end
			end
		end
	end)
end

--[[Projectile Redirection]]
local PlayerPosEntities = {
	["rpg_missile"] = true,
	["crossbow_bolt"] = true,
	["npc_grenade_frag"] = true,
	["apc_missile"] = true,
	["viewmodel_predicted"] = true
}

hook.Add("OnEntityCreated", "TFALeanOnEntCreated", function(ent)
	local ply = ent.Owner or ent:GetOwner()
	if not IsValid(ply) or not ply:IsPlayer() then return end
	if ent:IsPlayer() then return end
	local headposold
	local gud, ret = pcall(ply.LeanGetShootPosOld, ply)

	if gud then
		headposold = ret
	else
		headposold = ply:EyePos()
	end

	local entpos
	entpos = ent:GetPos()

	if PlayerPosEntities[ent:GetClass()] or (math.floor(entpos.x) == math.floor(headposold.x) and math.floor(entpos.y) == math.floor(headposold.y) and math.floor(entpos.z) == math.floor(headposold.z)) then
		ent:SetPos(ply:EyePos())
	end
end)


local ISPATCHING = false
hook.Add("EntityFireBullets", "zzz_LeanFireBullets", function(ply, bul, ...)
	if ISPATCHING then return end
	local bak = table.Copy(bul)
	ISPATCHING = true
	local call = hook.Run("EntityFireBullets", ply, bul, ...)
	ISPATCHING = false
	if call == false then
		return false
	elseif call == nil then
		table.Empty(bul)
		table.CopyFromTo(bak,bul)
	end
	if ply:IsWeapon() and ply.Owner then
		ply = ply.Owner
	end

	if not ply:IsPlayer() then return end
	local wep = ply:GetActiveWeapon()

	if (not wep.Base) and ply.LeanGetShootPosOld and bul.Src == ply:LeanGetShootPosOld() then
		bul.Src = ply:GetShootPos()
	end

	return true
end)

--[[CLIENTSIDE]]
hook.Add("PreRender", "TFALeanPreRender", function()
	TFALeanModel()
end)

local minvec = Vector(-6, -6, -6)
local maxvec = Vector(6, 6, 6)

local function filterfunc(ent)
	if (ent:IsPlayer() or ent:IsNPC() or ent:IsWeapon() or PlayerPosEntities[ent:GetClass()]) then
		return false
	else
		return true
	end
end

local function bestcase(pos, endpos, ply)
	local off = endpos - pos
	local trace = {}
	trace.start = pos
	trace.endpos = pos + off
	trace.mask = MASK_SOLID
	trace.filter = filterfunc
	trace.ignoreworld = false
	trace.maxs = maxvec
	trace.mins = minvec
	local traceres = util.TraceHull(trace)

	return pos + off:GetNormalized() * math.Clamp(traceres.Fraction, 0, 1) * off:Length()
end

function LeanCalcView(ply, pos, angles, fov)
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	if not ply:Alive() or ply:Health() <= 0 then return view end
	local status = ply.TFALean or 0
	local off = Vector(0, status * -LeanOffset, 0)
	off:Rotate(angles)
	view.angles:RotateAroundAxis(view.angles:Forward(), status * 15)
	view.origin = bestcase(view.origin, view.origin + off, ply)

	return view
end

local ISLEANINGCV = false

hook.Add("CalcView", "TFALeanCalcView", function(ply, pos, angles, fov, ...)
	if ISLEANINGCV then return end
	if GetViewEntity() ~= ply then return end
	if not ply:Alive() then return end
	if ply:InVehicle() then return end
	ISLEANINGCV = true
	local preTable = hook.Run("CalcView", ply, pos, angles, fov) or {}
	ISLEANINGCV = false
	preTable.origin = preTable.origin or pos
	preTable.angles = preTable.angles or angles
	preTable.fov = preTable.fov or fov
	--[[
	local wep = ply:GetActiveWeapon()
	if wep.CalcView then
		local p,a,f = wep.CalcView(wep,ply,preTable.origin,preTable.angles,preTable.fov)
		preTable.origin = p or preTable.origin
		preTable.angles = a or preTable.angles
		preTable.fov = f or preTable.fov
	end
	]]
	--
	local finalTable = LeanCalcView(ply, preTable.origin, preTable.angles, preTable.fov, ...)
	for k, v in pairs(preTable) do
		if finalTable[k] == nil then
			finalTable[k] = v
		end
	end

	return finalTable
end)

local ISLEANINGCV_VM = false

function LeanCalcVMView(wep, vm, oldPos, oldAng, pos, ang, ...)
	if ISLEANINGCV_VM then return end
	local ply = LocalPlayer()
	if GetViewEntity() ~= ply then return end

	if not ply.tfacastoffset or ply.tfacastoffset <= 0.001 then
		local status = ply.TFALean or 0

		if math.abs(status) > 0.001 then
			local off = Vector(0, status * -LeanOffset, 0)
			off:Rotate(ang)
			ang:RotateAroundAxis(ang:Forward(), status * 12 * (wep.ViewModelFlip and -1 or 1))
			pos = bestcase(pos, pos + off, ply)
			ISLEANINGCV_VM = true
			local tpos, tang = hook.Run("CalcViewModelView", wep, vm, oldPos, oldAng, pos, ang, ...)
			ISLEANINGCV_VM = false

			if tpos then
				pos = tpos
			end

			if tang then
				ang = tang
			end

			return pos, ang
		end
	end
end

hook.Add("CalcViewModelView", "TFALeanCalcVMView", LeanCalcVMView)