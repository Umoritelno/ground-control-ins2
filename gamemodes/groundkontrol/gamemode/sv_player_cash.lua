include("sh_player_cash.lua")

GM.StartingCashAmount = 0

local PLAYER = FindMetaTable("Player")

function PLAYER:saveCash()
	self:SetSteamIDPData("GroundControlCash", self.cash)
end

function PLAYER:loadCash()
	local cashAmount = self:GetSteamIDPData("GroundControlCash") or GAMEMODE.StartingCashAmount
	self.cash = tonumber(cashAmount)
end