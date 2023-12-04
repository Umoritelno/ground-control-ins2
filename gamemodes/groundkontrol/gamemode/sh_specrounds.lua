AddCSLuaFile()

if SERVER then
    util.AddNetworkString("SpecRoundUpdate")
end

GM.DefaultSpecRoundDelay = 4 -- in rounds
GM.GlobalSpecRound = GM.DefaultSpecRoundDelay
GM.SpecRounds = {}

function GM:AddSpecRound(data)
    self.SpecRounds[data.id] = data 
end 

function GM:GetSpecRound()
   return self.CurSpecRound
end 

GM:AddSpecRound(
	{
		id = "perevorot",
		name = "Перевертыш",
		description = "Что за хуйня здесь происходит?",
	}
)

GM:AddSpecRound(
	{
		id = "balance",
		name = "Баланс",
		description = "Что с уроном?",
	}
)