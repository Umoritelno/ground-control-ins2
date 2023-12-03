AddCSLuaFile()

function team.GetAlivePlayers(teamId)
	local alive = 0
	
	for key, obj in ipairs(team.GetPlayers(teamId)) do
		if obj:Alive() then
			alive = alive + 1
		end
	end
	
	return alive
end

function table.sanitiseObjectList(list)
	local rIdx = 1
	
	for i = 1, #list do
		local obj = list[rIdx]
		
		if IsValid(obj) then
			rIdx = rIdx + 1
		else
			table.remove(list, rIdx)
		end
	end
end