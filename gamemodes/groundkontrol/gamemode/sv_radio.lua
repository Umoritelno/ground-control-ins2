include("sh_radio.lua")

GM.RadioDelay = 2

util.AddNetworkString("GC_RADIO_MARKED") -- single vector
util.AddNetworkString("GC_RADIO_MARKERS") -- multiple vectors

local PLAYER = FindMetaTable("Player")

function PLAYER:resetRadioData()
	self.radioWait = 0
end

function GM:SendRadioCommand(ply, category, radioId, command)
	local radioDelay = self.RadioDelay
	radioDelay = command and command.radioWait or radioDelay
	
	ply.radioWait = CurTime() + radioDelay
	
	if command and command.send then
		command:send(ply, radioId, category)
	else
		for key, obj in pairs(team.GetPlayers(ply:Team())) do
			self:sendRadio(ply, obj, category, radioId)
			
			--[[umsg.Start("GC_RADIO", obj)
				umsg.Char(category)
				umsg.Char(radioId)
				umsg.Char(ply.voiceVariant)
				umsg.Entity(ply)
			umsg.End()]]--
		end
	end
end

function GM:setVoiceVariant(ply, stringID)
	ply.voiceVariant = self.VoiceVariantsById[stringID].numId
end

function GM:attemptSetMemeRadio(ply)
	if self.MemeRadio and math.random(1, 1000) <= GetConVarNumber("gc_meme_radio_chance") then
		self:setVoiceVariant(ply, "bandlet")
		return true
	end
	
	return false
end

function GM:sendRadio(ply, target, category, radioId)
	umsg.Start("GC_RADIO", target)
		umsg.Float(CurTime())
		umsg.Char(category)
		umsg.Char(radioId)
		umsg.Char(ply.voiceVariant)
		umsg.Entity(ply)
	umsg.End()
end

function GM:sendMarkedSpot(category, commandId, sender, receiver, pos)
	if type(pos) == "Vector" then
		net.Start("GC_RADIO_MARKED")
			net.WriteFloat(CurTime())
			net.WriteUInt(category, 8)
			net.WriteUInt(commandId, 8)
			net.WriteUInt(sender.voiceVariant, 8)
			net.WriteEntity(sender)
			net.WriteVector(pos)
		net.Send(receiver)
	else
		net.Start("GC_RADIO_MARKERS")
			net.WriteFloat(CurTime())
			net.WriteUInt(category, 8)
			net.WriteUInt(commandId, 8)
			net.WriteUInt(sender.voiceVariant, 8)
			net.WriteEntity(sender)
			net.WriteString(util.TableToJSON(pos))
		net.Send(receiver)
	end
end

concommand.Add("gc_radio_command", function(ply, com, args)
	local category = args[1]
	local radioId = args[2]
	
	if not category or not radioId then
		return
	end
	
	if not ply:Alive() or CurTime() < ply.radioWait then
		return
	end
	
	category = tonumber(category)
	radioId = tonumber(radioId)
	
	local desiredCategory = GAMEMODE.RadioCommands[category]
	
	if desiredCategory then
		local command = desiredCategory.commands[radioId]
		
		if command then
			GAMEMODE:SendRadioCommand(ply, category, radioId, command)
		end
	end
end)

CustomizableWeaponry.callbacks:addNew("beginThrowGrenade", "GroundControl_beginThrowGrenade", function(wep)
	GAMEMODE:SendRadioCommand(wep.Owner, 9, 1, nil)
end)