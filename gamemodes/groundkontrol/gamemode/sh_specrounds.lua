AddCSLuaFile()

if SERVER then
    util.AddNetworkString("SpecRoundUpdate")
end

GM.DefaultSpecRoundDelay = 4 -- in rounds
GM.GlobalSpecRound = GM.DefaultSpecRoundDelay
GM.SpecRounds = {}

function GM:AddSpecRound(data)
    self.SpecRounds[table.Count(GM.SpecRounds) + 1] = data 
end 

function GM:GetSpecRound()
   return self.CurSpecRound
end 

GM:AddSpecRound(
	{
		name = "Перевертыш",
		description = "Что за хуйня здесь происходит?",
	}
)

GM:AddSpecRound(
	{
		name = "Баланс",
		description = "Что с уроном?",
	}
)