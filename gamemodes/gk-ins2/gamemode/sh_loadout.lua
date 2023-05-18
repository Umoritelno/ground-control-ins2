AddCSLuaFile()
AddCSLuaFile("cl_loadout.lua")

GM.DefaultPrimaryIndex = 1 -- default indexes for primary and secondary weapons in case we fail to get the number
GM.DefaultSecondaryIndex = 1
GM.DefaultTertiaryIndex = 1

GM.DefaultPrimaryMagCount = 3
GM.DefaultSecondaryMagCount = 3

GM.DefaultSpareAmmoCount = 0
GM.MaxSpareAmmoCount = 200

GM.MaxPrimaryMags = 5
GM.MaxSecondaryMags = 5

--[[ why the M203 and C-Mags are removed from all weapons:
M203:
	* the maps Ground Control is played on (so, counter-strike maps) were not designed with an "explode on impact" weapon/gameplay mechanics
	* the M203 therefore allowed people to:
		1. completely lock off map choke points
		2. get cheap kills, since the M203, unlike the AWP in counter-strike, allows for a great degree of margin of error, since even if you're not dead on target, you will still kill the person who's shooting at you
		
	* increasing M203 projectile spread did not help
	* removing M203 changed the gameplay dynamics drastically, for the better, since players now have to rely exclusively on frag grenades for explosive kills, and can not rely on the M203 for cheap kills
	
BETA C-Mags:
	* the inclusion of these magazines was to give players the ability to pair them with a bipod and be capable of laying down suppressive fire
	* the debuffs present on the attachment were added to specifically promote this idea
	* in practice, people picked the C-Mags to have 100 rounds in their mag, in order to be able to either mag-dump or turn corners while pre-firing without being afraid of running out of ammo
	* removing this attachment improved gameplay, since players can't rely on a huge magazine in close quarters anymore
	* the M249 is not subject to this, since it's got plenty of it's own downsides that makes it unsatisfying to use on close range (great movement penalty, inaccurate, lower rate of fire than AR-15, slow reload)
]]

GM.RemoveAttachments = {"md_m203", "md_cmag_556_official"} -- list of attachments to remove from weapons

-- override the attachFunc method on these attachments to enforce a lower viewmodel FOV when using these attachments to compensate for the reduction in aiming FOV change
GM.ModifyViewmodelFOVAttachments = {
	{"md_schmidt_shortdot", 45},
	{"md_pso1", 45},
	{"md_nightforce_nxs", 45},
	{"md_acog", 45},
}

GM.RemoveWeaponAttachments = {}
--[[GM.RemoveWeaponAttachments = {
	cw_famasg2_official = {"md_cmag_556_official"}
}]]

if CLIENT then
	include("cl_loadout.lua")
end

GM.RegisteredWeaponData = {}

GM.PrimaryWeapons = GM.PrimaryWeapons or {}
GM.SecondaryWeapons = GM.SecondaryWeapons or {}
GM.TertiaryWeapons = GM.TertiaryWeapons or {}
GM.CaliberWeights = GM.CaliberWeights or {}
GM.zoomFOV = 3

BestPrimaryWeapons = BestPrimaryWeapons or {damage = -math.huge, recoil = -math.huge, aimSpread = math.huge, firerate = math.huge, hipSpread = math.huge, spreadPerShot = -math.huge, velocitySensitivity = math.huge, maxSpreadInc = -math.huge, speedDec = math.huge, weight = -math.huge, magWeight = -math.huge, penetrationValue = -math.huge}
BestSecondaryWeapons = BestSecondaryWeapons or {damage = -math.huge, recoil = -math.huge, aimSpread = math.huge, firerate = math.huge, hipSpread = math.huge, spreadPerShot = -math.huge, velocitySensitivity = math.huge, maxSpreadInc = -math.huge, speedDec = math.huge, weight = -math.huge, magWeight = -math.huge, penetrationValue = -math.huge}

local PLAYER = FindMetaTable("Player")

function PLAYER:getDesiredPrimaryMags()
	return math.Clamp(self:GetInfoNum("gc_primary_mags", GAMEMODE.DefaultPrimaryIndex), 1, GAMEMODE.MaxPrimaryMags)
end

function PLAYER:getDesiredSecondaryMags()
	return math.Clamp(self:GetInfoNum("gc_secondary_mags", GAMEMODE.DefaultPrimaryIndex), 1, GAMEMODE.MaxSecondaryMags)
end

function PLAYER:getDesiredPrimaryWeapon()
	local primary = math.Clamp(self:GetInfoNum("gc_primary_weapon", GAMEMODE.DefaultPrimaryIndex), 0, #GAMEMODE.PrimaryWeapons) -- don't go out of bounds
	return GAMEMODE.PrimaryWeapons[primary], primary
end

function PLAYER:getDesiredSecondaryWeapon()
	local secondary = math.Clamp(self:GetInfoNum("gc_secondary_weapon", GAMEMODE.DefaultSecondaryIndex), 0, #GAMEMODE.SecondaryWeapons)
	return GAMEMODE.SecondaryWeapons[secondary], secondary
end

function PLAYER:getDesiredTertiaryWeapon()
	local tertiary = math.Clamp(self:GetInfoNum("gc_tertiary_weapon", GAMEMODE.DefaultTertiaryIndex), 0, #GAMEMODE.TertiaryWeapons)
	return GAMEMODE.TertiaryWeapons[tertiary], tertiary
end

function PLAYER:adjustMagCount(weaponData, desiredMags)
	if not weaponData then
		return 0
	end
	
	if weaponData.magOverride then
		return weaponData.magOverride
	end
	
	if weaponData.maxMags then
		desiredMags = math.min(desiredMags, weaponData.maxMags)
	end
	
	return desiredMags
end

function GM:applyWeaponDataToWeaponClass(weaponData, primaryWeapon, slot)
	local wepClass = weapons.GetStored(weaponData.weaponClass)
	wepClass.weight = weaponData.weight -- apply weight to the weapon class
	wepClass.isPrimaryWeapon = primaryWeapon
	wepClass.Slot = slot
	wepClass.penetrationValue = weaponData.penetration
	wepClass.selectSortWeight = weaponData.selectSortWeight
	wepClass.stun = weaponData.stun 
	wepClass.Damage = weaponData.damage or wepClass.Damage
	wepClass.Primary.ClipSize_Orig = wepClass.Primary.ClipSize or wepClass.ClipSize

	weaponData.weaponObject = wepClass
	weaponData.processedWeaponObject = weapons.Get(weaponData.weaponClass)
end

function GM:setWeaponWeight(wepClass, weight)
	local wepObj = weapons.GetStored(wepClass)
	wepObj.weight = weight
end

function GM:disableDropsForWeapon(wepClass)
	local wepObj = weapons.GetStored(wepClass)
	wepObj.dropsDisabled = true
end

function GM:registerPrimaryWeapon(weaponData)
	weaponData.id = weaponData.id or weaponData.weaponClass
	self.RegisteredWeaponData[weaponData.id] = weaponData
	
	weaponData.selectSortWeight = 1
	
	if not weaponData.maxAmmo then
		weaponData.maxAmmo = math.huge
	end
	if not string.find(weapons.Get(weaponData.weaponClass).Base,self:GetBaseClassByID(GetConVar("gc_wepbase"):GetInt())) then -- weapons.Get(weaponData.weaponClass).Base != self:GetBaseClassByID(GetConVar("gc_wepbase"):GetInt())
		return 
	end
	
	self:applyWeaponDataToWeaponClass(weaponData, true, 0)
	self.PrimaryWeapons[#self.PrimaryWeapons + 1] = weaponData
	--print(weapons.Get(weaponData.weaponClass).Base)
end

function GM:registerSecondaryWeapon(weaponData)
	weaponData.id = weaponData.id or weaponData.weaponClass
	self.RegisteredWeaponData[weaponData.id] = weaponData
	
	weaponData.selectSortWeight = 2
	
	if not weaponData.maxAmmo then
		weaponData.maxAmmo = math.huge
	end
	if not string.find(weapons.Get(weaponData.weaponClass).Base,self:GetBaseClassByID(GetConVar("gc_wepbase"):GetInt())) then -- weapons.Get(weaponData.weaponClass).Base != self:GetBaseClassByID(GetConVar("gc_wepbase"):GetInt())
		return 
	end
	
	self:applyWeaponDataToWeaponClass(weaponData, false, 1)
	self.SecondaryWeapons[#self.SecondaryWeapons + 1] = weaponData
end

function GM:registerTertiaryWeapon(weaponData)
	weaponData.id = weaponData.id or weaponData.weaponClass
	self.RegisteredWeaponData[weaponData.id] = weaponData
	
	weaponData.selectSortWeight = 3
	
	if not weaponData.maxAmmo then
		weaponData.maxAmmo = math.huge
	end
	
	self:applyWeaponDataToWeaponClass(weaponData, false, 2)
	weapons.GetStored(weaponData.weaponClass).isTertiaryWeapon = true
	self.TertiaryWeapons[#self.TertiaryWeapons + 1] = weaponData
end

-- 1 grain = 0.06479891 gram
function GM:registerCaliberWeight(caliberName, grams) -- when registering a caliber's weight, the caliberName value should be the ammo type that the weapon uses
	self.CaliberWeights[caliberName] = grams / 1000 -- convert grams to kilograms in advance
end

function GM:findBestWeapons(lookInto, output)
	for key, weaponData in ipairs(lookInto) do

		local wepObj = weaponData.weaponObject
		if string.find(wepObj.Base,"tfa") then --wepObj.Base == "tfa_devl_base" or wepObj.Base == "tfa_gun_base" or
            wepObj = table.Merge(wepObj, self:parseTFAWeapon(wepObj))
			--PrintTable(wepObj)
		elseif string.find(wepObj.Base,"arc9") then
			wepObj = table.Merge(wepObj, self:parseARC9Weapon(wepObj))
			--PrintTable(self:parseARC9Weapon(wepObj))
		end 
		
		output.damage = math.max(output.damage, wepObj.Damage * wepObj.Shots )
		output.recoil = math.max(output.recoil, wepObj.GCRecoil or wepObj.Recoil)
		output.aimSpread = math.min(output.aimSpread, wepObj.AimSpread)
		output.firerate = math.min(output.firerate, wepObj.FireDelay)
		output.hipSpread = math.min(output.hipSpread, wepObj.HipSpread)
		output.spreadPerShot = math.max(output.spreadPerShot, wepObj.SpreadPerShot)
		output.velocitySensitivity = math.min(output.velocitySensitivity, wepObj.VelocitySensitivity)
		output.maxSpreadInc = math.max(output.maxSpreadInc, wepObj.MaxSpreadInc)
		output.speedDec = math.min(output.speedDec, wepObj.SpeedDec)
		output.weight = math.max(output.weight, wepObj.weight)
		output.penetrationValue = math.max(output.penetrationValue, wepObj.penetrationValue)
		
		local magWeight = self:getAmmoWeight(wepObj.Primary.Ammo, wepObj.Primary.ClipSize)
		wepObj.magWeight = magWeight
		
		output.magWeight = math.max(output.magWeight, magWeight)
	end
end

function GM:getAmmoWeight(caliber, roundCount)
	roundCount = roundCount or 1
	return self.CaliberWeights[caliber] and self.CaliberWeights[caliber] * roundCount or 0
end

-- this function gets called in InitPostEntity for both the client and server, this is where we register a bunch of stuff
function GM:postInitEntity()
	-- cw 2.0 orig start 

	local g3a3 = {}
	g3a3.weaponClass = "cw_g3a3"
	g3a3.weight = 4.1
	g3a3.penetration = 18
	g3a3.stun = 1.7

	self:registerPrimaryWeapon(g3a3)

	local scarH = {}
	scarH.weaponClass = "cw_scarh"
	scarH.weight = 3.72
	scarH.penetration = 18
	scarH.stun = 1.35
	
	self:registerPrimaryWeapon(scarH)
	
	local m14 = {}
	m14.weaponClass = "cw_m14"
	m14.weight = 5.1
	m14.penetration = 18
	m14.stun = 1 
	
	self:registerPrimaryWeapon(m14)
	
	-- assault rifles
	local ak74 = {}
	ak74.weaponClass = "cw_ak74"
	ak74.weight = 3.07
	ak74.penetration = 17
	ak74.stun = 1.35
	
	self:registerPrimaryWeapon(ak74)

	local ar15 = {}
	ar15.weaponClass = "cw_ar15"
	ar15.weight = 2.88
	ar15.penetration = 16
	ar15.maxAmmo = 100
	ar15.stun = 1.25
	
	self:registerPrimaryWeapon(ar15)
	
	local g36c = {}
	g36c.weaponClass = "cw_g36c"
	g36c.weight = 2.82
	g36c.penetration = 16
	g36c.stun = 1.4
	
	self:registerPrimaryWeapon(g36c)
	
	local famas = {}
	famas.weaponClass = "cw_famasg2_official"
	famas.weight = 2.82
	famas.penetration = 16
	famas.stun = 0.9
	
	self:registerPrimaryWeapon(famas)
	
	local l852a2 = {}
	l852a2.weaponClass = "cw_l85a2"
	l852a2.weight = 3.82
	l852a2.penetration = 16
	l852a2.stun = 1.5
	
	self:registerPrimaryWeapon(l852a2)
	
	local vss = {}
	vss.weaponClass = "cw_vss"
	vss.weight = 2.6
	vss.penetration = 15
	vss.stun = 0.5
	
	self:registerPrimaryWeapon(vss)
	
	-- sub-machine guns
	local mp5 = {}
	mp5.weaponClass = "cw_mp5"
	mp5.weight = 2.5
	mp5.penetration = 9
	mp5.stun = 0.75
	
	self:registerPrimaryWeapon(mp5)
	
	local mp9 = {}
	mp9.weaponClass = "cw_mp9_official"
	mp9.weight = 1.4
	mp9.penetration = 9
	mp9.stun = 0.5
	
	self:registerPrimaryWeapon(mp9)
	
	local mp7 = {}
	mp7.weaponClass = "cw_mp7_official"
	mp7.weight = 1.7
	mp7.penetration = 12
	mp7.stun = 1.2
	
	self:registerPrimaryWeapon(mp7)
	
	local mac11 = {}
	mac11.weaponClass = "cw_mac11"
	mac11.weight = 1.59
	mac11.penetration = 6
	mac11.stun = 1.8
	
	self:registerPrimaryWeapon(mac11)
	
	local ump45 = {}
	ump45.weaponClass = "cw_ump45"
	ump45.weight = 2.5
	ump45.penetration = 9
	ump45.stun = 2.25
	
	self:registerPrimaryWeapon(ump45)
	
	local m249 = {}
	m249.weaponClass = "cw_m249_official"
	m249.weight = 7.5
	m249.penetration = 16
	m249.maxMags = 2
	m249.maxAmmo = 200
	m249.stun = 2.5
	
	self:registerPrimaryWeapon(m249)
	
	-- shotguns
	local m3super90 = {}
	m3super90.weaponClass = "cw_m3super90"
	m3super90.weight = 3.27
	m3super90.penetration = 5
	m3super90.stun = 0.1
	
	self:registerPrimaryWeapon(m3super90)
	
	local m1014 = {}
	m1014.weaponClass = "cw_xm1014_official"
	m1014.weight = 3.84
	m1014.penetration = 5
	m1014.stun = 0.1
	
	self:registerPrimaryWeapon(m1014)
	
	local saiga = {}
	saiga.weaponClass = "cw_saiga12k_official"
	saiga.weight = 3.5
	saiga.penetration = 5
	saiga.maxMags = 4
	saiga.startAmmo = 20
	saiga.stun = 0.1
	
	self:registerPrimaryWeapon(saiga)
	
	local serbushorty = {}
	serbushorty.weaponClass = "cw_shorty"
	serbushorty.weight = 1.8
	serbushorty.penetration = 5
	serbushorty.startAmmo = 16
	serbushorty.stun = 0.1
	
	self:registerPrimaryWeapon(serbushorty)
	
	-- sniper rifles	
	local svd = {}
	svd.weaponClass = "cw_svd_official"
	svd.weight = 4.30
	svd.penetration = 25
	svd.stun = 3.5
	
	self:registerPrimaryWeapon(svd)
	
	local l115 = {}
	l115.weaponClass = "cw_l115"
	l115.weight = 6.5
	l115.penetration = 30
	l115.stun = 5
	
	self:registerPrimaryWeapon(l115)
	
	-- handguns
	local deagle = {}
	deagle.weaponClass = "cw_deagle"
	deagle.weight = 1.998
	deagle.penetration = 17
	deagle.stun = 0.35
	
	self:registerSecondaryWeapon(deagle)
	
	local mr96 = {}
	mr96.weaponClass = "cw_mr96"
	mr96.weight = 1.22
	mr96.penetration = 14
	mr96.stun = 0.4
	
	self:registerSecondaryWeapon(mr96)
	
	local m1911 = {}
	m1911.weaponClass = "cw_m1911"
	m1911.weight = 1.105
	m1911.penetration = 7
	m1911.stun = 0.175
	
	self:registerSecondaryWeapon(m1911)
	
	local fiveseven = {}
	fiveseven.weaponClass = "cw_fiveseven"
	fiveseven.weight = 0.61
	fiveseven.penetration = 11
	fiveseven.stun = 0.25
	
	self:registerSecondaryWeapon(fiveseven)
	
	local p99 = {}
	p99.weaponClass = "cw_p99"
	p99.weight = 0.63
	p99.penetration = 7
	p99.stun = 0.3
	
	self:registerSecondaryWeapon(p99)
	
	local makarov = {}
	makarov.weaponClass = "cw_makarov"
	makarov.weight = 0.63
	makarov.penetration = 6
	makarov.stun = 0.1

	self:registerSecondaryWeapon(makarov)


	-- cw 2.0 orig end
	local ebr = {}
	ebr.weaponClass = "cw_kk_ins2_m14"
	ebr.weight = 5
	ebr.penetration = 18
	ebr.stun = 2.1

	self:registerPrimaryWeapon(ebr)
	-- arc9 start 


	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak74m"
	darsuAK.weight = 6
	darsuAK.penetration = 19
	darsuAK.stun = 0.5
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)


	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak101"
	darsuAK.weight = 5.5
	darsuAK.penetration = 18.25
	darsuAK.stun = 0.25
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak102"
	darsuAK.weight = 5.75
	darsuAK.penetration = 17.1
	darsuAK.stun = 0.125
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak103"
	darsuAK.weight = 5.25
	darsuAK.penetration = 16.9
	darsuAK.stun = 0.15
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak104"
	darsuAK.weight = 5
	darsuAK.penetration = 17
	darsuAK.stun = 0.3
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak105"
	darsuAK.weight = 5.3
	darsuAK.penetration = 17.5
	darsuAK.stun = 0.4
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_ak74"
	darsuAK.weight = 4.75
	darsuAK.penetration = 16.8
	darsuAK.stun = 0.12
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_akm"
	darsuAK.weight = 4.5
	darsuAK.penetration = 16.5
	darsuAK.stun = 0.15
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_aks74u"
	darsuAK.weight = 3.5
	darsuAK.penetration = 16
	darsuAK.stun = 0.1
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_rd704"
	darsuAK.weight = 6
	darsuAK.penetration = 17.7
	darsuAK.stun = 0.5
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsuAK = {}
	darsuAK.weaponClass = "arc9_eft_rpk16"
	darsuAK.weight = 6.5
	darsuAK.penetration = 17.9
	darsuAK.stun = 0.4
	--darsuAK.maxammo = 120
	--darsuAK.startammo = 30

	self:registerPrimaryWeapon(darsuAK)

	local darsusaiga = {}
	darsusaiga.weaponClass = "arc9_eft_saiga12k"
	darsusaiga.weight = 3.5
	darsusaiga.penetration = 16
	darsusaiga.stun = 0.1
	darsusaiga.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(darsusaiga)


    local vityaz = {}
	vityaz.weaponClass = "arc9_eft_pp1901"
	vityaz.weight = 2.75
	vityaz.penetration = 15
	vityaz.stun = 0.2
	--vityaz.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(vityaz)

	local s9 = {}
	s9.weaponClass = "arc9_eft_saiga9"
	s9.weight = 2.9
	s9.penetration = 15.25
	s9.stun = 0.15
	--vityaz.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(s9)

	local ak54 = {}
	ak54.weaponClass = "arc9_eft_sag_ak545"
	ak54.weight = 5
	ak54.penetration = 17
	ak54.stun = 0.3
	--vityaz.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(ak54)

	local akshort = {}
	akshort.weaponClass = "arc9_eft_sag_ak545short"
	akshort.weight = 4.25
	akshort.penetration = 16.5
	akshort.stun = 0.25
	--vityaz.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(akshort)

	local vepr = {}
	vepr.weaponClass = "arc9_eft_vpo136"
	vepr.weight = 3.9
	vepr.penetration = 17.2
	vepr.stun = 0.4
	--vityaz.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(vepr)

	local vpo = {}
	vpo.weaponClass = "arc9_eft_vpo209"
	vpo.weight = 4.2
	vpo.penetration = 17.5
	vpo.stun = 0.75
	--vityaz.maxammo = 80
	--darsusaiga.startammo = 20 

	self:registerPrimaryWeapon(vpo)

	local glk = {}
	glk.weaponClass = "arc9_eft_glock17"
	glk.weight = 0.6
	glk.penetration = 17
	glk.stun = 2.5
	glk.maxammo = 90
	--glk.startammo = 17

	self:registerSecondaryWeapon(glk)

	local glk18 = {}
	glk18.weaponClass = "arc9_eft_glock18c"
	glk18.weight = 0.7
	glk18.penetration = 17.3
	glk18.stun = 2.6
	glk18.maxammo = 95
	--glk18.startammo = 17
	
	self:registerSecondaryWeapon(glk18)

	local glk19 = {}
	glk19.weaponClass = "arc9_eft_glock19x"
	glk19.weight = 0.9
	glk19.penetration = 17.7
	glk19.stun = 2.7
	glk19.maxammo = 90
	--glk19.startammo = 17 
	
	self:registerSecondaryWeapon(glk19)


	-- arc9 end 

	-- TFA Start

	local asval = {}
	asval.weaponClass = "devl_as_val"
	asval.weight = 3
	asval.penetration = 17.5
	asval.stun = 0.1

	self:registerPrimaryWeapon(asval)

	local dvl = {}
	dvl.weaponClass = "tfa_eft_dvl10"
	dvl.weight = 7.5
	dvl.penetration = 21
	dvl.stun = 2.5

	self:registerPrimaryWeapon(dvl)

	local ump = {}
	ump.weaponClass = "tfa_hkump45"
	ump.weight = 2
	ump.penetration = 15
	ump.stun = 0.2

	self:registerPrimaryWeapon(ump)

	local m5 = {}
	m5.weaponClass = "tfa_eft_mp5"
	m5.weight = 2.75
	m5.penetration = 15.5
	m5.stun = 0.2

	self:registerPrimaryWeapon(m5)

	local m7 = {}
	m7.weaponClass = "tfa_eft_mp7a1"
	m7.weight = 2.75
	m7.penetration = 15.5
	m7.stun = 0.2

	self:registerPrimaryWeapon(m7)

	local mpx = {}
	mpx.weaponClass = "tfa_eft_mpx"
	mpx.weight = 3.75
	mpx.penetration = 17
	mpx.stun = 0.3

	self:registerPrimaryWeapon(mpx)

	local Sig = {}
	Sig.weaponClass = "tfa_eft_mcx"
	Sig.weight = 3.75
	Sig.penetration = 17
	Sig.stun = 0.5

	self:registerPrimaryWeapon(Sig)

	local t5 = {}
	t5.weaponClass = "devl_t5000"
	t5.weight = 6
	t5.penetration = 22
	t5.stun = 2.5

	self:registerPrimaryWeapon(t5)

	local snapa = {}
	snapa.weaponClass = "devl_mjolnir"
	snapa.weight = 5
	snapa.penetration = 20
	snapa.stun = 2.5

	self:registerPrimaryWeapon(snapa)

	local geroin = {}
	geroin.weaponClass = "tfa_rtx_hk416d"
	geroin.weight = 4.5
	geroin.penetration = 18
	geroin.stun = 3

	self:registerPrimaryWeapon(geroin)

	local alpha = {}
	alpha.weaponClass = "devl_kalashnikov_alpha"
	alpha.weight = 5
	alpha.penetration = 18
	alpha.stun = 0.25

	self:registerPrimaryWeapon(alpha)

	local m4 = {}
	m4.weaponClass = "tfa_eft_m4a1"
	m4.weight = 4.25
	m4.penetration = 15.5
	m4.stun = 0.3

	self:registerPrimaryWeapon(m4)

	local m9 = {}
	m9.weaponClass = "eft_m9a3"
	m9.weight = 1.105
	m9.penetration = 12
	m9.stun = 1.1
    self:registerSecondaryWeapon(m9)

	local rook = {}
	rook.weaponClass = "devl_rook"
	rook.weight = 1.5
	rook.penetration = 14
	rook.stun = 1
    self:registerSecondaryWeapon(rook)

	local sr = {}
	sr.weaponClass = "devl_sr1mp"
	sr.weight = 1.25
	sr.penetration = 13
	sr.stun = 0.9
    self:registerSecondaryWeapon(sr)

	-- TFA End

	local mini14 = {}
	mini14.weaponClass = "cw_kk_ins2_mini14"
	mini14.weight = 3.5
	mini14.penetration = 16.5
	mini14.stun = 1.65

	self:registerPrimaryWeapon(mini14)


	local ak74 = {}
	ak74.weaponClass = "cw_kk_ins2_ak74"
	ak74.weight = 4.17
	ak74.penetration = 16
	ak74.stun = 1.75

	self:registerPrimaryWeapon(ak74)

	local akm = {}
	akm.weaponClass = "cw_kk_ins2_akm"
	akm.weight = 4
	akm.penetration = 16.25
	akm.stun = 1.85

	self:registerPrimaryWeapon(akm)

	local fnfal = {}
	fnfal.weaponClass = "cw_kk_ins2_fnfal"
	fnfal.weight = 4.5
	fnfal.penetration = 17.5
	fnfal.stun = 2

	self:registerPrimaryWeapon(fnfal)

	local galil = {}
	galil.weaponClass = "cw_kk_ins2_galil"
	galil.weight = 5.5
	galil.penetration = 17
	galil.stun = 0.9

	self:registerPrimaryWeapon(galil)

	local mp40 = {}
	mp40.weaponClass = "cw_kk_ins2_mp40"
	mp40.weight = 3.25
	mp40.penetration = 16.5
	mp40.stun = 1.1

	self:registerPrimaryWeapon(mp40)

	local l1 = {}
	l1.weaponClass = "cw_kk_ins2_l1a1"
	l1.weight = 4.75
	l1.penetration = 17.75
	l1.stun = 3

	self:registerPrimaryWeapon(l1)

	local m1 = {}
	m1.weaponClass = "cw_kk_ins2_m1a1"
	m1.weight = 3.5
	m1.penetration = 19
	m1.stun = 2

	self:registerPrimaryWeapon(m1)

	local m16 = {}
	m16.weaponClass = "cw_kk_ins2_m16a4"
	m16.weight = 5.5
	m16.penetration = 18
	m16.stun = 1.35

	self:registerPrimaryWeapon(m16)

	local m249 = {}
	m249.weaponClass = "cw_kk_ins2_m249"
	m249.weight = 8.5
	m249.penetration = 16.5
	m249.stun = 1.75

	self:registerPrimaryWeapon(m249)

	local m40 = {}
	m40.weaponClass = "cw_kk_ins2_m40a1"
	m40.weight = 4.5
	m40.penetration = 20
	m40.stun = 1.25

	self:registerPrimaryWeapon(m40)

	local m4 = {}
	m4.weaponClass = "cw_kk_ins2_m4a1"
	m4.weight = 5.25
	m4.penetration = 17.25
	m4.stun = 1.5

	self:registerPrimaryWeapon(m4)

	local m590 = {}
	m590.weaponClass = "cw_kk_ins2_m590"
	m590.weight = 4.25
	m590.penetration = 18.1
	m590.stun = 0.1

	self:registerPrimaryWeapon(m590)

	local mk18 = {}
	mk18.weaponClass = "cw_kk_ins2_mk18"
	mk18.weight = 6
	mk18.penetration = 16.9
	mk18.stun = 1.75

	self:registerPrimaryWeapon(mk18)

	local nagant = {}
	nagant.weaponClass = "cw_kk_ins2_mosin"
	nagant.weight = 5.5
	nagant.penetration = 19.25
	nagant.stun = 15

	self:registerPrimaryWeapon(nagant)

	local rpk = {}
	rpk.weaponClass = "cw_kk_ins2_rpk"
	rpk.weight = 7.75
	rpk.penetration = 17.35
	rpk.stun = 2.1

	self:registerPrimaryWeapon(rpk)

	local sks = {}
	sks.weaponClass = "cw_kk_ins2_sks"
	sks.weight = 4.75
	sks.penetration = 18
	sks.stun = 3

	self:registerPrimaryWeapon(sks)

	--[[local sterling = {}
	sks.weaponClass = "cw_kk_ins2_sterling"
	sks.weight = 3.5
	sks.penetration = 16.1

	self:registerPrimaryWeapon(sterling)
	--]]

	local toz = {}
	toz.weaponClass = "cw_kk_ins2_toz"
	toz.weight = 5
	toz.penetration = 18
	toz.stun = 0.1

	self:registerPrimaryWeapon(toz)

	local scarH = {}
	scarH.weaponClass = "cw_kk_ins2_cstm_scar"
	scarH.weight = 3.72
	scarH.penetration = 18
	scarH.stun = 2.05
	
	self:registerPrimaryWeapon(scarH)
	
	-- assault rifles
	local famas = {}
	famas.weaponClass = "cw_kk_ins2_cstm_famas"
	famas.weight = 4.2
	famas.penetration = 17.25
	famas.stun = 2.5
	
	self:registerPrimaryWeapon(famas)

	local colt = {}
	colt.weaponClass = "cw_kk_ins2_cstm_colt"
	colt.weight = 4.1
	colt.penetration = 17.5
	colt.stun = 2.15

	self:registerPrimaryWeapon(colt)

	local kriss = {}
	kriss.weaponClass = "cw_kk_ins2_cstm_kriss"
	kriss.weight = 3
	kriss.penetration = 14.5
	kriss.stun = 1.5

	self:registerPrimaryWeapon(kriss)

	local g36 = {}
	g36.weaponClass = "cw_kk_ins2_cstm_g36c"
	g36.weight = 2.97
	g36.penetration = 16.5
	g36.stun = 1.35

	self:registerPrimaryWeapon(g36)

	local mp7 = {}
	mp7.weaponClass = "cw_kk_ins2_cstm_mp7"
	mp7.weight = 3.25
	mp7.penetration = 15
	mp7.stun = 0.75

	self:registerPrimaryWeapon(mp7)

	local mp5 = {}
	mp5.weaponClass = "cw_kk_ins2_cstm_mp5a4"
	mp5.weight = 2.5
	mp5.penetration = 14
	mp5.stun = 0.5

	self:registerPrimaryWeapon(mp5)

	local ksg = {}
	ksg.weaponClass = "cw_kk_ins2_cstm_ksg"
	ksg.weight = 5
	ksg.penetration = 16
	ksg.stun = 0.15

	self:registerPrimaryWeapon(ksg)

	local m14 = {}
	m14.weaponClass = "cw_kk_ins2_cstm_m14"
	m14.weight = 3.5
	m14.penetration = 15.5
	m14.stun = 2.2

	self:registerPrimaryWeapon(m14)

	local m500 = {}
	m500.weaponClass = "cw_kk_ins2_cstm_m500"
	m500.weight = 3.45
	m500.penetration = 16
	m500.stun = 0.12

	self:registerPrimaryWeapon(m500)

	local spas = {}
	spas.weaponClass = "cw_kk_ins2_cstm_spas12"
	spas.weight = 3.65
	spas.penetration = 16
	spas.stun = 0.17

	self:registerPrimaryWeapon(spas)


	local aug = {}
	aug.weaponClass = "cw_kk_ins2_cstm_aug"
	aug.weight = 5
	aug.penetration = 17
	aug.stun = 2.25

	self:registerPrimaryWeapon(aug)
	
	-- handguns
	
	local mr96 = {}
	mr96.weaponClass = "cw_kk_ins2_revolver"
	mr96.weight = 1.22
	mr96.penetration = 18
	mr96.stun = 7.5
	
	self:registerSecondaryWeapon(mr96)
	
	local m1911 = {}
	m1911.weaponClass = "cw_kk_ins2_m1911"
	m1911.weight = 1.105
	m1911.penetration = 12
	m1911.stun = 3.5
	
	self:registerSecondaryWeapon(m1911)

	local m45 = {}
	m45.weaponClass = "cw_kk_ins2_m45"
	m45.weight = 1.105
	m45.penetration = 10
	m45.stun = 3.6
	self:registerSecondaryWeapon(m45)
--
--
	

	local g19 = {}
	g19.weaponClass = "cw_kk_ins2_cstm_g19"
	g19.weight = 1.105
	g19.penetration = 11
	g19.stun = 4.1
	
	self:registerSecondaryWeapon(g19)
	
	local mp5k = {}
	mp5k.weaponClass = "cw_kk_ins2_mp5k"
	mp5k.weight = 2.5
	mp5k.penetration = 10
	mp5k.stun = 0.9
	
	self:registerSecondaryWeapon(mp5k)

	local uzi = {}
	uzi.weaponClass = "cw_kk_ins2_cstm_uzi"
	uzi.weight = 3.25
	uzi.penetration = 12
	uzi.stan = 0.75
	
	self:registerSecondaryWeapon(uzi)
	
	local m9 = {}
	m9.weaponClass = "cw_kk_ins2_m9"
	m9.weight = 0.63
	m9.penetration = 9.5
	m9.stun = 3.1
	
	self:registerSecondaryWeapon(m9)
	
	local makarov = {}
	makarov.weaponClass = "cw_kk_ins2_makarov"
	makarov.weight = 0.63
	makarov.penetration = 8
	makarov.stun = 1.6
	
	self:registerSecondaryWeapon(makarov)
	

	local flash = {}
	flash.weaponClass = "cw_kk_ins2_nade_m84"
	flash.weight = 0.5
	flash.startAmmo = 2
	flash.hideMagIcon = true -- whether the mag icon and text should be hidden in the UI for this weapon
	flash.description = {{t = "Flashbang", font = "CW_HUD24", c = Color(255, 255, 255, 255)},
		{t = "Blinds nearby enemies facing the grenade upon detonation.", font = "CW_HUD20", c = Color(255, 255, 255, 255)},
		{t = "2x grenades.", font = "CW_HUD20", c = Color(255, 255, 255, 255)}
	}
		
	
	self:registerTertiaryWeapon(flash)
	
	local smoke = {}
	smoke.weaponClass = "cw_kk_ins2_nade_m18"
	smoke.weight = 0.5
	smoke.startAmmo = 2
	smoke.hideMagIcon = true
	smoke.description = {{t = "Smoke grenade", font = "CW_HUD24", c = Color(255, 255, 255, 255)},
		{t = "Provides a smoke screen to deter enemies from advancing or pushing through.", font = "CW_HUD20", c = Color(255, 255, 255, 255)},
		{t = "2x grenades.", font = "CW_HUD20", c = Color(255, 255, 255, 255)}
	}
	
	self:registerTertiaryWeapon(smoke)

	local f1gren = {}
	f1gren.weaponClass = "cw_kk_ins2_nade_m67"
	f1gren.weight = 0.5
	f1gren.amountToGive = 2
	f1gren.hideMagIcon = true
	f1gren.skipWeaponGive = true
	f1gren.description = {{t = "Spare Grenade", font = "CW_HUD24", c = Color(255, 255, 255, 255)},
		{t = "2x grenades.", font = "CW_HUD20", c = Color(255, 255, 255, 255)}
	}

	function f1gren:postGive(ply)
		ply:GiveAmmo(self.amountToGive, "Frag Grenades")
	end 


	self:registerTertiaryWeapon(f1gren)
	

    local incendiary = {}
	incendiary.weaponClass = "cw_kk_ins2_nade_anm14"
	incendiary.weight = 0.5
	incendiary.startAmmo = 2
	incendiary.hideMagIcon = true
	incendiary.description = {{t = "Incendiary Grenade", font = "CW_HUD24", c = Color(255, 255, 255, 255)},
		{t = "Incendiary", font = "CW_HUD20", c = Color(255, 255, 255, 255)},
		{t = "2x grenades.", font = "CW_HUD20", c = Color(255, 255, 255, 255)}
	}

    self:registerTertiaryWeapon(incendiary)
	
	--[[local medkit = {}
	medkit.weaponClass = "gc_medkit"
	medkit.weight = 0.5
	medkit.amountToGive = 1
	medkit.skipWeaponGive = false
	medkit.hideMagIcon = true
	medkit.description = {
		{t = "Heal up to 40 health on friendlies and 20 on self.", font = "CW_HUD20", c = Color(255, 255, 255, 255)},
		{t = "Stops bleeding and uncripples heal targets.", font = "CW_HUD20", c = Color(255, 255, 255, 255)},
		{t = "Uses bandages for healing.", font = "CW_HUD20", c = Color(255, 255, 255, 255)}
	}
	
	self:registerTertiaryWeapon(medkit)]]
	
	--[[local spare40MM = {}
	spare40MM.weaponClass = "cw_frag_grenade"
	spare40MM.display = "Spare 40MM round"
	spare40MM.weight = 0.5
	spare40MM.amountToGive = 1
	spare40MM.skipWeaponGive = true
	spare40MM.hideMagIcon = true
	spare40MM.description = {{t = "Spare 40MM round", font = "CW_HUD24", c = Color(255, 255, 255, 255)},
		{t = "Worthless if no weapon with M203 is present.", font = "CW_HUD20", c = Color(255, 255, 255, 255)},
		{t = "No frag grenades will be given with this equipped, unless there is no weapon with M203.", font = "CW_HUD20", c = Color(255, 200, 200, 255)}
	}
	
	function spare40MM:postGive(ply)
		local weps = ply:GetWeapons()
		local m203Present = false
		
		-- try to find the M203 attachment
		for i = 1, #weps do
			local wep = weps[i]
			
			if wep.CW20Weapon and wep:isAttachmentActiveReal("md_m203") then
				m203Present = true
				break
			end
		end
		
		-- m203 present? strip the frag grenade, give the 40MM round
		if m203Present then
			-- give the grenade
			ply:GiveAmmo(self.amountToGive, "40MM")
			-- remove the frag grenade
			ply:SetAmmo(0, "Frag Grenades")
		else
			-- m203 present? give another spare frag grenade
			ply:GiveAmmo(spareGrenade.amountToGive, "Frag Grenades")
		end
	end
	
	self:registerTertiaryWeapon(spare40MM)]]
	
	-- KNIFE, give it 0 weight and make it undroppable (can't shoot out of hand, can't drop when dying)
	local wepObj = weapons.GetStored(self.KnifeWeaponClass)
	wepObj.weight = 0
	wepObj.dropsDisabled = true
	wepObj.isKnife = true
	wepObj.selectSortWeight = 4
	
	local wepObj = weapons.GetStored("cw_kk_ins2_rpg")
	wepObj.weight = 0.5
	wepObj.dropsDisabled = true
	wepObj.isKnife = false
	wepObj.selectSortWeight = 6
    
	local wepObj = weapons.GetStored(self.MedkitClass)
	wepObj.weight = 10
	wepObj.dropsDisabled = true
	wepObj.isKnife = false
	wepObj.selectSortWeight = 5
	
	-- MP9, remove the meme ammo type
	local mp9Wep = weapons.GetStored("cw_mp9_official")
	table.Exclude(mp9Wep.Attachments["+reload"].atts, "am_ultramegamatchammo")
	
	-- M4 Super 90, remove the M203 from it, shit's too OP LOL
	local m4super90 = weapons.GetStored("cw_xm1014_official")
	table.Exclude(m4super90.Attachments[4].atts, "md_m203")
	
	local wepList = weapons.GetList()
	
	if self.RemoveAttachments then
		-- remove M203 from all weapons
		
		for i = 1, #wepList do
			local className = wepList[i].ClassName
			local data = weapons.GetStored(className)
			
			if weapons.Get(className).CW20Weapon and data.Attachments then
				local attList = self.RemoveWeaponAttachments[className]
				
				-- remove all the attachments that we want to remove
				for k, v in pairs(data.Attachments) do
					for i = 1, #self.RemoveAttachments do
						table.Exclude(v.atts, self.RemoveAttachments[i])
					end
					
					-- remove specific attachments from weapons if we should
					if attList then
						for i = 1, #attList do
							table.Exclude(v.atts, attList[i])
						end
					end
				end
			end
		end
	end
	
	local zoomFov = self.zoomFOV
	
	-- set SpeedDec to 0 on all CW20 weapons
	-- also set their zoom amount to just 3
	for i = 1, #wepList do
		local className = wepList[i].ClassName
		local data = weapons.GetStored(className)
		
		if weapons.Get(className).CW20Weapon then
			data.SpeedDec = 0
			data.NearWallEnabled = false
			data.NearWallDistance = 0
			data.ZoomAmount = zoomFov
		end
	end
	
	for k, data in ipairs(CustomizableWeaponry.registeredAttachments) do
		data.SpeedDec = false -- remove that shit
		
		if data.FOVModifier then
			data.FOVModifier = zoomFov
		end
		
		-- rebuild the stat text table
		if CLIENT then
			CustomizableWeaponry:createStatText(data)
		end
	end
	
	for key, data in ipairs(self.ModifyViewmodelFOVAttachments) do
		local attData = CustomizableWeaponry.registeredAttachmentsSKey[data[1]]
		local oldAttachFunc = attData.attachFunc
		
		if oldAttachFunc then
			function attData.attachFunc(this)
				oldAttachFunc(this)
				this.AimViewModelFOV = data[2]
			end
		end
	end
	
	self:registerCaliberWeight("7.62x51MM", 25.4)
	self:registerCaliberWeight("7.62x39MM", 16.3)
	self:registerCaliberWeight("5.45x39MM", 10.7)
	self:registerCaliberWeight("5.56x45MM", 11.5)
	self:registerCaliberWeight("9x19MM", 8.03)
	self:registerCaliberWeight(".50 AE", 22.67)
	self:registerCaliberWeight(".44 Magnum", 16)
	self:registerCaliberWeight(".45 ACP", 15)
	self:registerCaliberWeight("12 Gauge", 50)
	self:registerCaliberWeight(".338 Lapua", 46.2)
	self:registerCaliberWeight("9x39MM", 24.2)
	self:registerCaliberWeight("9x17MM", 7.5)
	self:registerCaliberWeight("5.7x28MM", 6.15)
	self:registerCaliberWeight("9x18MM", 8)
	self:registerCaliberWeight("4.6x30MM", 6.5)
	
	hook.Call("GroundControlPostInitEntity", nil)
	
	self:findBestWeapons(self.PrimaryWeapons, BestPrimaryWeapons)
	self:findBestWeapons(self.SecondaryWeapons, BestSecondaryWeapons)
	
	local cw20base = weapons.GetStored("cw_base")
	cw20base.AddSafeMode = false -- disable safe firemode
	
	if CLIENT then
		function cw20base:getFragText(grenades)		
			return "x" .. grenades .. " FRAG " .. GAMEMODE:getKeyBind(GAMEMODE.NadeActionKey)
		end	
	
		self:createMusicObjects()
	end
	
	-- override some cw_dropped_weapon functionality since it has some sandbox-related functionality that we don't need/want in GC
	local dWep = scripted_ents.GetStored("cw_dropped_weapon").t
	
	function dWep:canPickup(activator)
		-- can ALWAYS pick up, whether we actually physically can is up to other factors
		return true, true
	end
	
	if SERVER then
		-- largely a copy-paste of the code in CW 2.0, but with two important differences: 
		-- 1. we will drop our weapon of the same class if we have it
		-- 2. we'll grab the ammo off it
		-- 3. we'll make use of some gamemode methods for this purpose
		
		function dWep:Use(activator)
			if hook.Call("CW20_PreventCWWeaponPickup", nil, self, activator) then
				return
			end
			
			local pos = self:GetPos() - activator:GetShootPos()
			local pickupDotProduct = activator:EyeAngles():Forward():Dot(pos) / pos:Length()
				
			if pickupDotProduct < self.pickupDotProduct then
				return
			end
			
			
			-- if use key is down we restrict picking the weapon up, because we might be wanting to throw a grenade, and if we throw + pick up the weapon - nothing will happen, because weapons will be switched
			if CurTime() < self.useDelay then
				return
			end
			
			local curWep = activator:GetActiveWeapon()
			
			-- can't pick up a weapon if we're performing an action of some kind
			if IsValid(curWep) and curWep.CW20Weapon and curWep.dt.State == CW_ACTION then
				return
			end
			
			-- we've got the same weapon? grab ammo off it, create a dropped weapon variant of it
			local wepClass = self:GetWepClass()
			local ownWep = activator:GetWeapon(wepClass)
			
			if IsValid(ownWep) then
				local wepAmmo = ownWep:Clip1()
				local giveAmmo = math.min(wepAmmo, activator:getRemainingResupplyAmmo(ownWep))
				
				if giveAmmo > 0 then
					activator:GiveAmmo(giveAmmo, ownWep:GetPrimaryAmmoType())
					ownWep:SetClip1(wepAmmo - giveAmmo)
				end
				
				activator:dropWeaponNicely(ownWep, VectorRand() * 20, VectorRand() * 200)
			end
			
			local wep = activator:Give(wepClass)
			hook.Call("CW20_PickedUpCW20Weapon", nil, activator, self, wep)
			wep.disableDropping = true -- we set this variable to true so that the player can not drop the weapon using the cw_dropweapon command until attachments are applied
			
			CustomizableWeaponry.giveAttachments(activator, self.stringAttachmentIDs)
			
			local attachments = self.containedAttachments
			local magSize = self.magSize
			local m203Chamber = self.M203Chamber
			
			if wep then -- if we were given a weapon, load up the attachments on it
				timer.Simple(0.3, function()
					if not IsValid(wep) then
						return
					end
					
					wep:SetClip1(0) -- set magsize to 0 before loading attachments, because some of them unload the mag and that way we can cheat ammo (by dropping and picking up again)
					
					CustomizableWeaponry.preset.load(wep, attachments, "DroppedWeaponPreset") -- the preset system is super flexible and can easily be used for such purposes
					
					wep:SetClip1(magSize) -- set the mag size only after we've attached everything
					wep:setM203Chamber(m203Chamber)
					wep.disableDropping = false -- set it to false, now we can drop it
					
					hook.Call("CW20_FinishedPickingUpCW20Weapon", nil, activator, wep)
				end)
			end
			
			self:Remove()
		end
	end
end

local concommandName = CLIENT and "gc_quickgrenade" or "gc_quickgrenade_sv"
	
concommand.Add(concommandName, function(ply, com, args)
	if not IsValid(ply) or CurTime() < GAMEMODE.PreparationTime then return end
	
	local wep = ply:GetActiveWeapon()
	
	if IsValid(wep) and wep.CW20Weapon then
		if CustomizableWeaponry.quickGrenade.canThrow(wep) then
			CustomizableWeaponry.quickGrenade.throw(wep, true)
			
			if CLIENT then
				RunConsoleCommand("gc_quickgrenade_sv")
			end
		end
	end
end, nil, nil, FCVAR_CLIENTCMD_CAN_EXECUTE + FCVAR_SERVER_CAN_EXECUTE)
