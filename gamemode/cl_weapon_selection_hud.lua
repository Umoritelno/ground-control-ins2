GM.desiredWeaponToDraw = nil
GM.weaponSelectionAlpha = 0
GM.weaponSelectionTime = 0
GM.weaponSelectionElementWidth = 200
GM.weaponSelectionDesiredElementHeight = 100
GM.weaponSelectionDesiredElementHeightNoAmmoUse = GM.weaponSelectionDesiredElementHeight - 18
GM.weaponSelectionElementHeight = 46
GM.weaponSelectionElementHeightNoAmmoUse = GM.weaponSelectionElementHeight - 18
GM.lastWeaponSelectIndex = 0

local PLAYER = FindMetaTable("Player")

function PLAYER:selectWeaponNicely(weaponObj)
	self.selectWeaponTarget = weaponObj
	GAMEMODE.weaponSelectionTime = 0 -- make it fade out
end

function GM:showWeaponSelection(desiredWeapon)
	local ply = LocalPlayer()
	local tbl = self:getWeaponSelectionTable()
	
	self:setDesiredWeaponToDraw(tbl[desiredWeapon], desiredWeapon)
	return true
end

function GM:cycleWeaponSelection(offset)
	local tbl, gunCount = self:getWeaponSelectionTable()
	
	if gunCount == 0 then
		return
	end
	
	local idx = self.lastWeaponSelectIndex
	
	while true do
		idx = idx + offset
		
		if tbl[idx] then
			break
		else
			if idx > 9 then
				idx = 1
			elseif idx <= 0 then
				idx = 9
			end
		end
	end
	
	if self:setDesiredWeaponToDraw(tbl[idx], idx) then
		self:hideRadio()
	end
end

function GM:hideWeaponSelection()
	self.weaponSelectionTime = 0
	self.lastWeaponSelectIndex = 0
	self.desiredWeaponToDraw = nil
end

function GM:setDesiredWeaponToDraw(weaponObj, lastIndex)
	if CurTime() < self.weaponSelectionTime and (IsValid(self.desiredWeaponToDraw) and self.desiredWeaponToDraw == weaponObj) then
		LocalPlayer():selectWeaponNicely(weaponObj)
		self.lastWeaponSelectIndex = 0
		return true
	end
		
	if self.lastWeaponSelectIndex ~= lastIndex or self.weaponSelectionAlpha == 0 then
		if IsValid(weaponObj) then
			surface.PlaySound("ground_control/weapon_selection/switch" .. math.random(1, 6) .. ".wav")
		end
		
		self.desiredWeaponToDraw = weaponObj
		self.weaponSelectionTime = CurTime() + 3
		self.lastWeaponSelectIndex = lastIndex
		return true
	end
end

function GM:canSelectDesiredWeapon()
	return IsValid(self.desiredWeaponToDraw) and CurTime() < self.weaponSelectionTime
end

local insertLast = {} -- list of weapons we will insert to the tail of the table

function GM:getWeaponSelectionTable(output)
	local ply = LocalPlayer()
	output = output or {}
	
	local weapons = ply:GetWeapons()
	local lastKey = -math.huge
	local gunCount = 0
	
	for key, weaponObj in pairs(weapons) do
		if IsValid(weaponObj) then
			if weaponObj.selectSortWeight then
				if not output[weaponObj.selectSortWeight] then -- weapon of this sort weight not added yet? ok, put it there
					output[weaponObj.selectSortWeight] = weaponObj
				else -- already placed? put it after this one
					table.insert(output, weaponObj.selectSortWeight + 1, weaponObj)
				end
			else -- no sort weight value assigned? insert at the tail end of the weapon list
				table.insert(insertLast, weaponObj)
			end
			
			lastKey = math.max(lastKey, key)
			gunCount = gunCount + 1
		end
	end
	
	for key, obj in ipairs(insertLast) do
		table.insert(output, lastKey, obj)
		insertLast[key] = nil
	end
	
	return output, gunCount
end

local filteredWeapons = {}

function GM:drawWeaponSelection(w, h, curTime)
	local ply = LocalPlayer()
	
	if not ply:Alive() then
		self.weaponSelectionTime = 0
		self.weaponSelectionAlpha = 0
	end
		
	if curTime < self.weaponSelectionTime then
		self.weaponSelectionAlpha = math.Approach(self.weaponSelectionAlpha, 1, FrameTime() * 7)
	else
		self.weaponSelectionAlpha = math.Approach(self.weaponSelectionAlpha, 0, FrameTime() * 7)
	end
	
	if self.weaponSelectionAlpha > 0 then
		local totalHeight = 0
		self:getWeaponSelectionTable(filteredWeapons)
		
		-- because whoever wrote GetWeapons on the client (or maybe the same bug is serverside too), the first index of the weapon table becomes nil when a weapon is removed
		-- to top it all off, it returns a new table each time
		
		-- since the gamemode is designed around 3 weapons max, we're going to assume that players can't have a fourth weapon and assign primary to 1, secondary to 2 and tertiary weapons to 3rd index
		for key, weaponObj in pairs(filteredWeapons) do -- get total element height before beginning to draw
			local usesAmmo = weaponObj.Primary.Ammo ~= ""
			
			if weaponObj == self.desiredWeaponToDraw then
				totalHeight = totalHeight + (usesAmmo and self.weaponSelectionDesiredElementHeight or self.weaponSelectionDesiredElementHeightNoAmmoUse)
			else
				totalHeight = totalHeight + (usesAmmo and self.weaponSelectionElementHeight or self.weaponSelectionElementHeightNoAmmoUse)
			end
		end
		
		totalHeight = _S(totalHeight)
		local startY = h * 0.5 - totalHeight * 0.5
		local elemW = _S(self.weaponSelectionElementWidth)
		local startW = ScrW() - _S(50) - elemW
		
		local backColor = self.HUDColors.black
		local frontColor = self.HUDColors.white
		backColor.a = 255 * self.weaponSelectionAlpha
		frontColor.a = 255 * self.weaponSelectionAlpha
		
		local yOff = _S(57)
		local panSize = _S(80)
		local textOff, textOff2, ammoYOff, ammoYOff2, rectXOff, rectYOff, rectYOff2 = _S(5), _S(3), _S(23), _S(77), _S(4), _S(11), _S(10)
		local elemH = _S(self.weaponSelectionElementHeight)
		local weaponSelectionElementHeightNoAmmoUse = _S(self.weaponSelectionElementHeightNoAmmoUse) -- lol
		local weaponSelectionDesiredElementHeight = _S(self.weaponSelectionDesiredElementHeight)
		local weaponSelectionDesiredElementHeightNoAmmoUse = _S(self.weaponSelectionDesiredElementHeightNoAmmoUse)
		
		for i = 1, 10 do
			local weaponObj = filteredWeapons[i]
			
			if IsValid(weaponObj) then	
				local isTargetWeapon = weaponObj == self.desiredWeaponToDraw
				local drawY = startY
				local drawH = nil
				
				local usesAmmo = weaponObj.Primary.Ammo ~= ""
				
				if isTargetWeapon then
					local size = usesAmmo and weaponSelectionDesiredElementHeight or weaponSelectionDesiredElementHeightNoAmmoUse
					startY = startY + size
					drawH = size
					surface.SetDrawColor(0, 0, 0, 200 * self.weaponSelectionAlpha)
				else
					local size = usesAmmo and elemH or weaponSelectionElementHeightNoAmmoUse
					startY = startY + size
					drawH = size
					surface.SetDrawColor(0, 0, 0, 100 * self.weaponSelectionAlpha)
				end
				
				startY = startY + textOff
				surface.DrawRect(startW, drawY, elemW, drawH)
				
				local ammoCountColor = self.HUDColors.white
				
				if weaponObj.CW20Weapon and weaponObj:isLowOnTotalAmmo() then
					ammoCountColor = self.HUDColors.red
				end
				
				if isTargetWeapon then
					draw.ShadowText(weaponObj.PrintName, self.WeaponFont, startW + textOff, drawY + yOff, self.HUDColors.white, backColor, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.ShadowText("[" .. i .. "]", self.WeaponFont, elemW + startW - textOff, drawY + yOff, self.HUDColors.white, backColor, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
										
					if weaponObj.IconLetter then
						draw.ShadowText(weaponObj.IconLetter, "GroundControl_SelectIcons", startW + textOff, drawY + textOff, self.HUDColors.white, backColor, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					elseif weaponObj.SelectIcon then
						local off = _S(24)
						local halfOff = off * 0.5
						local iconSize = drawH - off
						
						surface.SetDrawColor(0, 0, 0, 255 * self.weaponSelectionAlpha)
						surface.SetTexture(weaponObj.SelectIcon)
						surface.DrawTexturedRect(startW + textOff + halfOff, drawY - rectYOff2 + halfOff, iconSize, iconSize)
						
						surface.SetDrawColor(255, 255, 255, 255 * self.weaponSelectionAlpha)
						surface.DrawTexturedRect(startW + rectXOff + halfOff, drawY - rectYOff + halfOff, iconSize, iconSize)
					end
					
					--[[if usesAmmo and weaponObj.CW20Weapon then
						draw.ShadowText(weaponObj:getMagCapacity() .. " / " .. weaponObj:getReserveAmmoText(), self.WeaponFont, startW + textOff, drawY + ammoYOff2, ammoCountColor, backColor, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					end
					--]]
				else
					draw.ShadowText(weaponObj.PrintName, self.WeaponFont, startW + textOff, drawY + textOff2, self.HUDColors.white, backColor, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					draw.ShadowText("[" .. i .. "]", self.WeaponFont, elemW + startW - textOff, drawY + textOff2, self.HUDColors.white, backColor, 1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
					
					--[[if usesAmmo and weaponObj.CW20Weapon then
						draw.ShadowText(weaponObj:getMagCapacity() .. " / " .. weaponObj:getReserveAmmoText(), self.WeaponFont, startW + textOff, drawY + ammoYOff, ammoCountColor, backColor, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					end
					--]]
				end
			end
			
			filteredWeapons[i] = nil
		end
				
		backColor.a = 255
		frontColor.a = 255
	end
end

function GM:StartChat(isTeam)
	self:hideWeaponSelection()
end
