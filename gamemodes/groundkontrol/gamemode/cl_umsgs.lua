local function GC_BleedState(data)
	local ent = net.ReadEntity()
	
	if not IsValid(ent) then
		return
	end
	
	local bleed = net.ReadBool()
	local bleedGrade = net.ReadUInt(8)
	
	if ent == LocalPlayer() then
		if bleed then
			GAMEMODE.tipController:handleEvent("BEGIN_BLEEDING")
		else
			GAMEMODE.tipController:handleEvent("STOPPED_BLEEDING")
		end
	end
	
	ent:setBleeding(bleed, bleedGrade)
end

net.Receive("GC_BLEEDSTATE", GC_BleedState)

local function GC_HealState(data)
	local plyObj = net.ReadEntity()
	local healGrade = net.ReadUInt(8)
	
	plyObj:setHealGrade(healGrade)
end

net.Receive("GC_HEALSTATE", GC_HealState)

local function GC_Bandages(data)
	LocalPlayer():setBandages(data:ReadShort())
end

usermessage.Hook("GC_BANDAGES", GC_Bandages)

local function GC_Adrenaline(data)
	LocalPlayer():setAdrenaline(data:ReadFloat())
end

usermessage.Hook("GC_ADRENALINE", GC_Adrenaline)

local function GC_Stamina(data)
	local stamina = data:ReadFloat()
	
	LocalPlayer():setStamina(stamina)
end

usermessage.Hook("GC_STAMINA", GC_Stamina)

local function GC_RetryTeamSelection()
	GAMEMODE:openTeamSelection(true)
end

usermessage.Hook("GC_RETRYTEAMSELECTION", GC_RetryTeamSelection)

local function GC_RetryTeamSelection(data)
	local teamId = data:ReadChar()
	
	RunConsoleCommand("gc_desired_team", teamId)
end

usermessage.Hook("GC_TEAM_SELECTION_SUCCESS", GC_RetryTeamSelection)

local function GC_Cash(data)
	local cash = data:ReadLong()
	
	LocalPlayer():setCash(cash)
end

usermessage.Hook("GC_CASH", GC_Cash)

local function GC_NotEnoughCash(data)
	local required = data:ReadLong()
	
	chat.AddText(GAMEMODE.HUDColors.white, "Not enough cash! You need ", GAMEMODE.HUDColors.blue, tostring(required) .. "$", GAMEMODE.HUDColors.white, " whereas you have ", GAMEMODE.HUDColors.blue, tostring(LocalPlayer().cash) .. "$")
	surface.PlaySound("buttons/combine_button7.wav")
end

usermessage.Hook("GC_NOT_ENOUGH_CASH", GC_NotEnoughCash)

net.Receive("GC_ROUND_OVER", function()
	local winningTeam = net.ReadInt(8)
	local actionType = net.ReadInt(8)
	
	GAMEMODE:resetRoundData()
	GAMEMODE:createRoundOverDisplay(winningTeam, actionType)
end)

local function GC_GameBegin(data)
	GAMEMODE:resetRoundData()
	GAMEMODE:createRoundOverDisplay(nil)
end

usermessage.Hook("GC_GAME_BEGIN", GC_GameBegin)

local function GC_RoundPreparation(data)
	local preparationTime = net.ReadFloat()
	
	GAMEMODE:roundPreparation(preparationTime)
end

net.Receive("GC_ROUND_PREPARATION", GC_RoundPreparation)

local function GC_SpectateTarget(data)
	local target = data:ReadEntity()
	
	LocalPlayer():setSpectateTarget(target)
end

usermessage.Hook("GC_SPECTATE_TARGET", GC_SpectateTarget)

local function GC_NewRound(data)
	local target = data:ReadEntity()
	
	LocalPlayer():spawn(target)
end

usermessage.Hook("GC_NEW_ROUND", GC_NewRound)

local function GC_Unlocked_Slots(data)
	local slots = data:ReadChar()
	
	LocalPlayer():setUnlockedAttachmentSlots(slots)
end

usermessage.Hook("GC_UNLOCKED_SLOTS", GC_Unlocked_Slots)

local function GC_Experience(data)
	local exp = data:ReadLong()
	
	LocalPlayer():setExperience(exp)
end

usermessage.Hook("GC_EXPERIENCE", GC_Experience)

local function GC_LastManStanding()
	GAMEMODE:createLastManStandingDisplay()
end

usermessage.Hook("GC_LAST_MAN_STANDING", GC_LastManStanding)

local function GC_NOTIFICATION(um)
	chat.AddText(Color(150, 197, 255, 255), "[GROUND CONTROL] ", Color(255, 255, 255, 255), um:ReadString())
end

usermessage.Hook("GC_NOTIFICATION", GC_NOTIFICATION)

local function GC_AUTOBALANCED_TO_TEAM(um)
	if GAMEMODE.teamSwitchPopup then
		GAMEMODE.teamSwitchPopup:Remove()
		GAMEMODE.teamSwitchPopup = nil
	end
	
	local popup = vgui.Create("GCGenericPopup")
	popup:SetSize(_S(310), _S(50))
	popup:SetText("You've been autobalanced to " .. team.GetName(um:ReadShort()), "Don't shoot your new team mates.")
	popup:SetExistTime(7)
	popup:Center()
	
	local x, y = popup:GetPos()
	popup:SetPos(x, y - 140)
	
	GAMEMODE.teamSwitchPopup = popup
end

usermessage.Hook("GC_AUTOBALANCED_TO_TEAM", GC_AUTOBALANCED_TO_TEAM)

local function GC_NEW_TEAM(um)
	local lang = GetCurLanguage()
	if GAMEMODE.teamSwitchPopup then
		GAMEMODE.teamSwitchPopup:Remove()
		GAMEMODE.teamSwitchPopup = nil
	end
	
	local popup = vgui.Create("GCGenericPopup")
	popup:SetSize(_S(310), _S(50))--
	popup:SetText(string.format(lang.round_new_team_title,team.GetName(um:ReadShort())), lang.round_new_team_subtitle)
	popup:SetExistTime(7)
	popup:Center()
	
	local x, y = popup:GetPos()
	popup:SetPos(x, y - _S(140))
	
	GAMEMODE.teamSwitchPopup = popup
end

usermessage.Hook("GC_NEW_TEAM", GC_NEW_TEAM)

local function GC_NEW_WAVE(um)
	local lostTickets = um:ReadShort()
	
	if GAMEMODE.teamSwitchPopup then
		GAMEMODE.teamSwitchPopup:Remove()
		GAMEMODE.teamSwitchPopup = nil
	end
	
	local popup = vgui.Create("GCGenericPopup")
	
	local bottomText = lostTickets > 0 and ("Lost " .. lostTickets .. " tickets last wave.") or "No ticket loss."
	popup:SetSize(_S(310), _S(50))
	popup:SetText("New wave.", bottomText)
	popup:SetExistTime(7)
	popup:Center()
	
	local x, y = popup:GetPos()
	popup:SetPos(x, y - 140)
	
	GAMEMODE.teamSwitchPopup = popup
end

usermessage.Hook("GC_NEW_WAVE", GC_NEW_WAVE)

local function GC_GOT_DRUGS(um)
	if GAMEMODE.teamSwitchPopup then
		GAMEMODE.teamSwitchPopup:Remove()
		GAMEMODE.teamSwitchPopup = nil
	end
	
	local gametype = GAMEMODE.curGametype
	local bottomText = LocalPlayer():Team() == gametype.regularTeam and "Now bring them back to the base!" or "Now deliver them to the secure point!"
	
	local popup = vgui.Create("GCGenericPopup")
	popup:SetSize(_S(330), _S(50))
	popup:SetText("You picked up the drugs!", bottomText)
	popup:SetExistTime(7)
	popup:Center()
	
	local x, y = popup:GetPos()
	popup:SetPos(x, y - 140)
	
	GAMEMODE.teamSwitchPopup = popup
	
	LocalPlayer().hasDrugs = true
end

usermessage.Hook("GC_GOT_DRUGS", GC_GOT_DRUGS)

local function GC_DRUGS_REMOVED()
	LocalPlayer().hasDrugs = false
end

usermessage.Hook("GC_DRUGS_REMOVED", GC_DRUGS_REMOVED)

local function GC_CARRIED_DRUGS_POSITION(um)
	-- we're being sent 3 individual floats because vectors are compressed and that results in inaccuracy
	local x, y, z = um:ReadFloat(), um:ReadFloat(), um:ReadFloat()
	
	GAMEMODE:AddMarker(Vector(x, y, z), "Taken drugs", GAMEMODE.HUDColors.red, GAMEMODE.curGametype.bugMarkerDuration)
end

usermessage.Hook("GC_CARRIED_DRUGS_POSITION", GC_CARRIED_DRUGS_POSITION)

local function GC_ResetStatusEffects(data)
	GAMEMODE:removeAllStatusEffects()
end

usermessage.Hook("GC_RESET_STATUS_EFFECTS", GC_ResetStatusEffects)

-- receives loadout position and duration
local function GC_LoadoutPosition(um)
	local vector = um:ReadVector()
	local duration = um:ReadFloat()
	
	GAMEMODE:setLoadoutAvailabilityInfo(vector, duration)
end

usermessage.Hook("GC_LOADOUTPOSITION", GC_LoadoutPosition)

net.Receive("GC_KILLED_BY", function()
	local killerPlayer = net.ReadEntity()
	local killerEntClass = net.ReadString() -- the sent inflictor is not an entity, but is instead the entity class
	
	if IsValid(killerPlayer) and killerEntClass then
		GAMEMODE:createKilledByDisplay(killerPlayer, killerEntClass)
	end
end)