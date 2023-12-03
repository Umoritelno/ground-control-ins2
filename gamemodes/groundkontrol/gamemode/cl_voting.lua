net.Receive("GC_VOTE", function(a, b)
	local title = net.ReadString()
	local voteStartTime = net.ReadFloat()
	local voteTime = net.ReadFloat()
	local data = net.ReadTable()
	GAMEMODE:setVotes(title, voteStartTime, voteTime, data)
end)

net.Receive("GC_PLAYER_VOTED", function(a, b)
	GAMEMODE.HasVoted = true
end)


local function GC_Vote_Update(data)
	local index = data:ReadChar()
	local value = data:ReadChar()
	
	GAMEMODE:updateVote(index, value)
end

usermessage.Hook("GC_VOTE_UPDATE", GC_Vote_Update)

function GM:updateVote(index, value)
	self.VoteOptions[index].votes = value
end

GM.VoteOptionSpacing = 20
GM.VoteStartTime = 0
GM.VoteDuration = 0
GM.VoteTitle = nil
GM.VoteTextWidth = nil -- the widest vote text
GM.BaseVotePanelWidth = 250

function GM:setVotes(title, startTime, voteDuration, data)
	self.VoteStartTime = startTime + self.VotePrepTime
	self.VoteDuration = startTime + voteDuration
	self.VoteTitle = title
	self.VoteOptions = data
	self.VoteTextWidth = math.max(self:getWidestVoteText() + _S(10), _S(self.BaseVotePanelWidth))
	self.HasVoted = false
	
	self:hideWeaponSelection()
	self:hideRadio()
end

function GM:drawVotePanel()
	local curTime = CurTime()

	if curTime > self.VoteStartTime then
		if curTime < self.VoteDuration then
			local totalOptions = #self.VoteOptions
			local voteSpacing = _S(self.VoteOptionSpacing)
			
			local voteX = _SCRW - _S(50) - self.VoteTextWidth
			local halfOptions = totalOptions * 0.5 * voteSpacing
			local halfSpace = voteSpacing * 0.5
			local scrH = _SCRH
			local panelY, curY
			local midY = scrH * 0.5
			
			if self.HasVoted then
				panelY = _S(120)
				curY = _S(130)
			else
				panelY = midY - halfOptions - _S(20)
				curY = midY - halfOptions - _S(10)
			end
			
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(voteX, panelY, self.VoteTextWidth, totalOptions * voteSpacing + _S(20))
			
			self.HUDColors.white.a, self.HUDColors.black.a = 255, 255
			local textX = voteX + _S(5)
			
			draw.ShadowText(self:getVoteTitle(), self.VoteFont, textX, curY, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			curY = curY + voteSpacing
			
			for key, data in ipairs(self.VoteOptions) do
				draw.ShadowText(self:getVoteText(key, data), self.VoteFont, textX, curY, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				curY = curY + voteSpacing
			end
			
			return true
		end
	else
		local midY = _SCRH * 0.5
		local voteX = _SCRW - _S(50) - self.VoteTextWidth
		
		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(voteX, midY - _S(12), _S(250), _S(24))
		
		self.HUDColors.white.a, self.HUDColors.black.a = 255, 255
		
		draw.ShadowText("A vote will begin soon.", self.VoteAnnounceFont, voteX + _S(5), midY, self.HUDColors.white, self.HUDColors.black, 1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
	
	return false
end

function GM:getVoteTitle()
	return self.VoteTitle .. " - " .. math.ceil(self.VoteDuration - CurTime()) .. " second(s) left"
end

function GM:getVoteText(key, data)
	return key .. ". " .. data.option .. " - " .. data.votes .. " votes"
end

function GM:getTextSize(font, text)
	surface.SetFont(font)
	return surface.GetTextSize(text)
end

function GM:getWidestVoteText()
	local titleW = self:getTextSize(self.VoteFont, self:getVoteTitle())
	local optionW = -math.huge
	
	for key, data in ipairs(self.VoteOptions) do
		local w = self:getTextSize(self.VoteFont, self:getVoteText(key, data))
		
		if w > optionW then
			optionW = w
		end
	end
	
	return math.max(titleW, optionW)
end

function GM:isVoteActive()
	return CurTime() < self.VoteDuration
end

function GM:isVoteBlocking()
	return CurTime() < self.VoteDuration and not self.HasVoted
end

function GM:canVote()
	local curTime = CurTime()
	return curTime > self.VoteStartTime and curTime < self.VoteDuration
end

function GM:attemptVote(selection)
	if self:canVote() and self.VoteOptions[selection] then
		RunConsoleCommand("gc_vote", selection)
		return true
	end
	
	return false
end