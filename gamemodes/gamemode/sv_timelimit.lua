AddCSLuaFile("cl_timelimit.lua")
include("sh_timelimit.lua")

function GM:setTimeLimit(time)
	self.TimeLimit = time
	self.RoundStart = CurTime()
	self.RoundTime = CurTime() + time
end

function GM:addTimeLimit(time)
	if self.RoundOver then
		return
	end
	
	self.TimeLimit = self.TimeLimit + time
	self.RoundTime = self.RoundTime + time
	
	for key, obj in ipairs(self.currentPlayerList) do
		self:sendTimeLimit(obj)
	end
end

function GM:sendTimeLimit(target)
	if not self.TimeLimit then
		return
	end
	
	umsg.Start("GC_TIMELIMIT", target)
		umsg.Float(self.RoundStart)
		umsg.Float(self.TimeLimit)
	umsg.End()
end

function GM:hasTimeLimit()
	return self.TimeLimit ~= nil
end

function GM:hasTimeRunOut()
	return CurTime() >= self.RoundTime
end