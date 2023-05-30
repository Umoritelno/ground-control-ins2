AddCSLuaFile()
util.AddNetworkString("classinfo")
local pl = FindMetaTable("Player")

function pl:ResetClassInfo()
   self.plclass = player_manager.GetPlayerClasses()[player_manager.GetPlayerClass(self)]
   if GAMEMODE.abilityEnabled then
	 if self.plclass.DisplayName == "Commander" then
		self:GiveAbility(1)
	   elseif self.plclass.DisplayName == "Specialist" then 
		self:GiveAbility(math.random(2,table.Count(abilities)))
	 end
	else
		self:DeathAbility(true)
   end
   net.Start("classinfo")
   net.Send(self)
end 
--[[util.AddNetworkString("NewVote_Get")
util.AddNetworkString("NewVote_Start")

GM.NewVotedPlayers = {}
GM.NewOption = {}

--GM:ClearNewOption()

function GM:ClearNewOption()
    for k,v in pairs(GM.NewGolosArgs) do
		GM.NewOption[table.Count(GM.NewOption) + 1] = 0
	end
end 

function GM:StartNewVote()
   for k,v in pairs(player.GetAll()) do
      net.Start("NewVote_Start")
	  net.Send(v)
   end 
   --[[timer.Create("VoteTimer",30,1,function()
	self:ClearNewOption()
   end)
   
end 


net.Receive("NewVote_Get",function(ply,len)
	local cvrs = net.ReadTable()
	if not GM.NewVotedPlayers[ply:SteamID64()] then
		GM.NewVotedPlayers[ply:SteamID64()] = true 
        for k,v in pairs(cvrs) do
			if v == true then
				GM.NewOption[k] = GM.NewOption[k] + 1
				print(GM.NewOption[k])
			end
		end
	end
end)
--]]


--[[
	if you wish to setup specific things for the gamemode ON THE SERVER, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--