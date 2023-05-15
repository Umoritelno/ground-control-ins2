include("sv_gametype_shuffling.lua")
include("sh_gametypes.lua")
AddCSLuaFile("cl_gametypes.lua")

CreateConVar("gc_gametype", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("gc_allow_gametype_votes", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
GM.RemovePreviousGametype = false --[[ if this is set to true, then the gametype which was played previously will not be present during the vote for the next gametype
in other words if you set it to true, people won't be able to play the same gametype 2 times in a row
this is good if you've played way too much ghetto drug bust, because despite it being a fun joke it gets old really fast and you might get pissed if every
time you log on the server all you see is ghetto drug bust being played over and over again
]]

function GM:gametypeVotesEnabled()
	return GetConVarNumber("gc_allow_gametype_votes") >= 1
end

local PLAYER = FindMetaTable("Player")

function PLAYER:sendGameType()
	umsg.Start("GC_GAMETYPE", self)
		umsg.Short(GAMEMODE.curGametypeID)
	umsg.End()
end

concommand.Add("gc_request_gametype", function(ply, com, args)
	ply:sendGameType()
end)

concommand.Add("gc_gametypelist", function(ply, com, args)
	local text = "\n[GROUND CONTROL] Gametypes list:\n"
	
	for key, data in ipairs(GAMEMODE.Gametypes) do
		text = text .. GAMEMODE:getGametypeNameData(key) .. "\n"
	end
	
	print(text)
end)

concommand.Add("gc_gametype_random", function(ply, com, args)
	-- roll a random gametype + map combo
	-- first check whether we have at least one level in each category, and pre-filter them
	local mapsByGametype = {}
	
	for key, data in ipairs(GAMEMODE.Gametypes) do
		local theseMaps = {}
		
		for key, map in ipairs(data.mapRotation) do
			if GAMEMODE:hasMap(map) then
				table.insert(theseMaps, map)
			end
		end
		
		if #theseMaps > 0 then
			table.insert(mapsByGametype, {maps = theseMaps, gametypeKey = key})
		end
	end
	
	local randomCombo = mapsByGametype[math.random(1, #mapsByGametype)]
	game.ConsoleCommand("gc_gametype " .. randomCombo.gametypeKey .. "\nchangelevel " .. randomCombo.maps[math.random(1, #randomCombo.maps)] .. "\n")
end)

concommand.Add("gc_gametype_maplist", function(ply, com, args)
	local text = "\n[GROUND CONTROL] Supported map list for gametypes:\n"
	
	for key, data in ipairs(GAMEMODE.Gametypes) do
		text = text .. GAMEMODE:getGametypeNameData(key) .. "\n"
		
		for key, map in ipairs(data.mapRotation) do
			if GAMEMODE:hasMap(map) then
				text = text .. "\t" .. map .. "\n"
			else
				text = text .. "\t" .. map .. " (not installed, workshop ID: " .. GAMEMODE:getAutoDownloadMapID(map) .. ")\n"
			end
		end
	end
	
	print(text)
end)

cvars.AddChangeCallback("gc_gametype", function(cvarName, oldValue, newValue)
	GAMEMODE:changeGametype(newValue)
end, "OnChanged_gc_gametype")