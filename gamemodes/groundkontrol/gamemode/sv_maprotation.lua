GM.MapRotation = {}

function GM:registerMapRotation(name, maps)
	self.MapRotation[name] = maps
end

function GM:getMapRotation(name)
	return self.MapRotation[name]
end

function GM:filterExistingMaps(list)
	local newList = {}
	
	for key, mapName in ipairs(list) do
		if self:hasMap(mapName) then
			newList[#newList + 1] = mapName
		end
	end
	
	return newList
end

function GM:addMapToMapRotationList(mapRotationList, mapName)
	if not self.MapRotation[mapRotationList] then
		self.MapRotation[mapRotationList] = {}
		print("[GROUND CONTROL] - attempt to add a map to a non-existant map rotation list, creating list")
	end
		
	if not table.HasValue(self.MapRotation[mapRotationList], mapName) then
		table.insert(self.MapRotation[mapRotationList], mapName)
	end
end

function GM:hasMap(mapName)
	return file.Exists("maps/" .. mapName .. ".bsp", "GAME")
end

GM:registerMapRotation("one_side_rush", {"de_dust", "de_dust2", "cs_assault", "cs_compound", "cs_havana", "de_cbble", "de_inferno", "de_nuke", "de_port", "de_tides", "de_aztec", "de_chateau", "de_piranesi", "de_prodigy", "de_train", "de_secretcamp"})

GM:registerMapRotation("ghetto_drug_bust_maps", {"cs_assault", "cs_compound", "cs_havana", "cs_militia", "de_chateau", "de_inferno", "de_shanty_v3_fix", "cs_backalley2", "cs_drugbust", "cs_christbust", "cs_christalley", "de_christshanty"})

GM:registerMapRotation("assault_maps", {"cs_siege_2010", "de_desert_atrocity_v3", "cs_jungle"}) -- "rp_downtown_v2", "cs_siege_pcs"

GM:registerMapRotation("urbanwarfare_maps", {"ph_skyscraper_construct", "de_desert_atrocity_v3"})

if GetConVarNumber("gc_ghetto_backcompat_maps") > 0 then
	-- add ALL THE CS_ and DE_ maps to GDB
	local mapFolder = "maps/*"
	local fileList, folderList = file.Find(mapFolder, "GAME")

	for key, mapName in ipairs(fileList) do
		local fragment = mapName:sub(1, 3)
		
		if (fragment == "cs_" or fragment == "de_") and mapName:find(".bsp") then
			GM:addMapToMapRotationList("ghetto_drug_bust_maps", mapName:gsub(".bsp", ""))
		end
	end
end