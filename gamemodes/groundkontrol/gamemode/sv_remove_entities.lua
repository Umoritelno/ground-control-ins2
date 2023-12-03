-- add entity classes to this table to remove them from the map on round start
GM.RemoveEntities = {
	item_box_buckshot = true,
	item_ammo_smg1 = true,
	item_ammo_smg1_grenade = true,
	item_battery = true,
	item_suitcharger = true,
	item_ammo_357 = true,
	item_ammo_ar2 = true,
	item_ammo_ar2_altfire = true,
	combine_mine = true,
	item_ammo_crossbow = true,
	item_healthcharger = true,
	item_healthkit = true,
	item_healthvial = true,
	grenade_helicopter = true,
	item_ammo_pistol = true,
	item_rpg_round = true,
	
	weapon_357 = true,
	weapon_ar2 = true,
	weapon_bugbait = true,
	weapon_crossbow = true,
	weapon_crowbar = true,
	weapon_frag = true,
	weapon_physcannon = true,
	weapon_pistol = true,
	weapon_rpg = true,
	weapon_shotgun = true,
	weapon_slam = true,
	weapon_smg1 = true,
	weapon_stunstick = true}
	
GM.RemoveEntitiesByIndex = {
	--[[cs_siege_2010 = {
		{id = 232, oneTime = true} -- if oneTime is true, it'll remove that entity only once, upon map start
	},]]
	
	ph_skyscraper_construct = {
		373,
		447,
		397
	},
	
	cs_drugbust = {
		187
	}
}

function GM:addAutoRemoveEntity(class)
	self.RemoveEntities[class] = true
end

CreateConVar("gc_trashprop_mass_threshold", 20, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- props with a weight <= this much move on to the AABB check step
CreateConVar("gc_trashprop_aabb_size_threshold", 55, {FCVAR_ARCHIVE, FCVAR_NOTIFY}) -- props with an AABB size <= this much will have their collision set to debris


function GM:addAutoRemoveEntityIndex(map, index)
	self.RemoveEntitiesByIndex[map] = GM.RemoveEntitiesByIndex[map] or {}
	self.RemoveEntitiesByIndex[map][index] = true
end

function GM:autoRemoveEntities()
	local maxPlayers = game.MaxPlayers()
	
	if self.RemoveEntitiesByIndex[self.CurrentMap] then
		for key, index in ipairs(self.RemoveEntitiesByIndex[self.CurrentMap]) do
			local id = nil
			
			if type(index) == "number" then
				id = index
			else
				if index.oneTime and not index.removed then
					id = index.id
					index.removed = true
				end
			end
		
			if id then
				local entity = ents.GetByIndex(id + maxPlayers)
				
				if IsValid(entity) then
					entity:Remove()
				end
			end
		end
	end
	
	local massThreshold = GetConVar("gc_trashprop_mass_threshold"):GetInt()
	local sizeThreshold = GetConVar("gc_trashprop_aabb_size_threshold"):GetInt()
	
	-- remove trash props
	for key, obj in ipairs(ents.GetAll()) do
		if obj:GetClass():find("prop_physics") then
			local phys = obj:GetPhysicsObject()
			
			if IsValid(phys) and phys:GetMass() <= massThreshold then
				local min, max = phys:GetAABB()
				local vecDist = min:Distance(max)
				
				if vecDist < sizeThreshold then
					obj:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					--print("yep", obj:GetModel(), phys:GetMass(), vecDist)
				end
			end
		end
	end
	
	for class, state in pairs(self.RemoveEntities) do
		for key, obj in ipairs(ents.GetAll()) do
			if self.RemoveEntities[obj:GetClass()] then
				SafeRemoveEntity(obj)
			end
		end
	end
	
	-- just to be safe - iterate over all the spawn points and remove them if their contents are anything but CONTENTS_EMPTY
	self:removeBlockedSpawnPoints("info_player_counterterrorist")
	self:removeBlockedSpawnPoints("info_player_terrorist")
end

function GM:removeBlockedSpawnPoints(class)
	local entList = ents.FindByClass(class)
	
	-- reverse loop just in case
	for i = #entList, 1, -1 do
		local obj = entList[i]
		
		-- something blocking the spawn point? GET RID OF IT!!!
		if bit.band(util.PointContents(obj:GetPos()), CONTENTS_SOLID) ~= 0 then
			obj:Remove()
		end
	end
end