AddCSLuaFile()
AddCSLuaFile("cl_player_gadgets.lua")

if CLIENT then
	include("cl_player_gadgets.lua")
end

GM.Gadgets = {}
GM.GadgetsById = {}

GM.MaxSpareAmmo = 150
GM.MinSpareAmmo = 0

function GM:registerGadget(data)
	if CLIENT then
		data.icon = surface.GetTextureID(data.texture)
	end
	
	self.GadgetsById[data.id] = data
	self.Gadgets[#self.Gadgets + 1] = data
end

function GM:getSpareAmmoWeight(amount)
	return self.GadgetsById.spareammo.weight * amount
end

local PLAYER = FindMetaTable("Player")

function PLAYER:getSpecificGadget(id)
	for key, value in ipairs(self.gadgets) do
		if value.id == id then
			return value
		end
	end
end

function PLAYER:resetGadgetData()
	self.gadgets = self.gadgets or {}
	table.clear(self.gadgets)
end

function PLAYER:getDesiredAmmoCount()
	return math.Clamp(self:GetInfoNum("gc_spare_ammo", 0), GAMEMODE.MinSpareAmmo, GAMEMODE.MaxSpareAmmo)
end

function PLAYER:getWeaponAmmoLimit(wep)
	local magCount = wep.isPrimaryWeapon and GAMEMODE.MaxPrimaryMags or GAMEMODE.MaxSecondaryMags
	
	if not magCount then
		return 0
	end
	
	return wep.Primary.ClipSize_Orig * magCount
end

function PLAYER:getRemainingResupplyAmmo(wep)	
	return math.max(0, self:getWeaponAmmoLimit(wep) - self:GetAmmoCount(wep:GetPrimaryAmmoType()))
end

function PLAYER:addGadget(gadgetData)
	if CLIENT then
		local baseData = GAMEMODE.GadgetsById[gadgetData.id]
		setmetatable(gadgetData, {__index = baseData})
	end
	
	table.insert(self.gadgets, gadgetData)
end

local spareAmmo = {}
spareAmmo.display = "RESUPPLY"
spareAmmo.useKey = "slot0"
spareAmmo.maxAmmoPerResupply = 50 -- maximum ammo we can give away in 1 resupply action
spareAmmo.invisible = true
spareAmmo.id = "spareammo"
spareAmmo.texture = "ground_control/hud/gadgets/ammo"
spareAmmo.resupplyTime = 1
spareAmmo.onDemandGadgetNetwork = false -- it defaults to false, so don't worry about not defining it
spareAmmo.weight = 0.015

local traceData = {}

function spareAmmo:canResupply(target, weaponObject)
	weaponObject = weaponObject or target:GetActiveWeapon()
	
	if weaponObject.noResupply then
		return false
	end
		
	return target:getRemainingResupplyAmmo(weaponObject) > 0
end

function spareAmmo:canUse(ply, gadgetData)
	local wep = ply:GetActiveWeapon()
	if !wep.CW20Weapon then return end 
	
	if IsValid(wep) and CurTime() < wep.GlobalDelay then
		return false
	end
	
	return true
end

function spareAmmo:use(ply, gadgetData)
	local availableAmmo = math.Clamp(gadgetData.uses, 0, self.maxAmmoPerResupply)

	traceData.start = ply:GetShootPos()
	traceData.endpos = traceData.start + ply:GetAimVector() * 50
	traceData.filter = ply
	
	local trace = util.TraceLine(traceData)
	local target = ply
	
	local ent = trace.Entity
	
	if IsValid(ent) and ent:IsPlayer() and ent:Alive() and ent:Team() == ply:Team() then
		local wep = ent:GetActiveWeapon()
		
		if IsValid(wep) and wep.CW20Weapon then
			--if ent:GetAmmoCount(wep.Primary.Ammo) < wep.Primary.ClipSize_Orig * magCount then -- if this target has some ammo we could resupply him with, then select him as the target
			if self:canResupply(ent, wep) then
				target = ent
			end
		end
	end
	
	if target == ply then
		if not self:canResupply(ply, ply:GetActiveWeapon()) then
			return
		end
	end
	
	self:resupply(ply, target, availableAmmo, gadgetData)
	ply:setWeight(ply:calculateWeight())
end

function spareAmmo:resupply(resuppliedBy, target, availableAmmo, gadgetData)
	local wep = target:GetActiveWeapon()
	local lackingAmmo = target:getRemainingResupplyAmmo(wep)
	local givenAmmo = math.Clamp(lackingAmmo, 0, math.min(availableAmmo, wep.Primary.ClipSize_Orig))
	
	if givenAmmo > 0 then
		target:GiveAmmo(givenAmmo, wep.Primary.Ammo)
		gadgetData.uses = gadgetData.uses - givenAmmo
		
		if resuppliedBy ~= target then
			local percentage = givenAmmo / wep.Primary.ClipSize_Orig
			resuppliedBy:addCurrency(math.ceil(percentage * GAMEMODE.CashPerResupply), math.ceil(percentage * GAMEMODE.ExpPerResupply), "TEAMMATE_RESUPPLIED")
			GAMEMODE:trackRoundMVP(resuppliedBy, "resupply", 1)
		end
		
		resuppliedBy:sendGadgets()
		--resuppliedBy:GetActiveWeapon().GlobalDelay = self.resupplyTime + 0.3
		if resuppliedBy:GetActiveWeapon().CW20Weapon then
			resuppliedBy:GetActiveWeapon():setGlobalDelay(self.resupplyTime + 0.3, true, CW_ACTION, self.resupplyTime)
		end
		--resuppliedBy:calculateWeight()
	end
end

function spareAmmo:prepareObject(ply, ammoAmount)
	local newData = {uses = ammoAmount, id = self.id}
	
	return newData
end

function spareAmmo:getWeight(ply, gadgetData)
	return gadgetData.uses * self.weight
end

function spareAmmo:shouldRemove(ply, gadgetData)
	if gadgetData.uses <= 0 then
		return true
	end
	
	return false
end

function spareAmmo:draw(x, y)
	local lang = GetCurLanguage().gadgets["spareammo"]
	local offseterinos = _S(50)
	
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(self.icon)
	surface.DrawTexturedRect(x, y - offseterinos, offseterinos, offseterinos)
	
	local textXOff = _S(25)
	
	draw.ShadowText(GAMEMODE:getKeyBind(self.useKey) .. " " .. lang.Display, GAMEMODE.GadgetDisplayFont, x + textXOff, y, GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.ShadowText("x" .. self.uses, GAMEMODE.GadgetDisplayFont, x + textXOff, y + _S(15), GAMEMODE.HUDColors.white, GAMEMODE.HUDColors.black, 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

GM:registerGadget(spareAmmo)