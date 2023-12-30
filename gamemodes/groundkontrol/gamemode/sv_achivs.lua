local PLAYER = FindMetaTable("Player")
-- Create SQL table

util.AddNetworkString("GetAchiv")
util.AddNetworkString("AchievementsMaster")
util.AddNetworkString("AchievementsProgress")
sql.Query("CREATE TABLE IF NOT EXISTS gc_achievements_onetime (SteamID STRING, AchievementID STRING)")
sql.Query("CREATE TABLE IF NOT EXISTS gc_achievements_progress (SteamID STRING, AchievementID STRING, Progress INT)")

function GM:PlayerNotifyAchievement(ply, id)
    net.Start("GetAchiv")
    net.WriteEntity(ply)
    net.WriteString(id)
    net.Broadcast()
end

-- Get player achievements from SQL (I'd say this is fairly expensive to do)
function PLAYER:ProcessAchievements()
    self.Achs = {}
    -- Store count
    local completed = 0

    -- Get from SQL
    for id, ach in pairs(GAMEMODE.Achievements) do
        local result = sql.Query("SELECT * FROM gc_achievements_" .. (ach.Goal and "progress" or "onetime") .. " WHERE SteamID = '" .. self:SteamID() .. "' AND AchievementID = '" .. id .. "'")

        -- Result will return nil if there's no sql entry
        if result then
            -- If we have a goal, we'll check for progress
            if ach.Goal then
                result = result[1]
                result.Progress = tonumber(result.Progress)
                -- Store progress
                self.Achs[id] = result.Progress

                -- Check for completion
                if self.Achs[id] >= ach.Goal then
                    completed = completed + 1
                end
            else
                -- If we get a result on an achievement with no goal, achievement was achieved
                self.Achs[id] = true
                completed = completed + 1
            end
        end
    end

    -- Check for all achievements completion
    if completed >= GAMEMODE.AchievementsCount then
        self.AchMaster = true
        -- Network
        net.Start("AchievementsMaster")
        net.WriteEntity(self) -- Remember that self is PLAYER
        net.Broadcast()
    end

    -- Send achievements progress
    net.Start("AchievementsProgress")
    net.WriteString(util.TableToJSON(self.Achs))
    net.Send(self)
end

-- For one time achievements
function PLAYER:GiveAchievement(id)
    if not self.Achs then
        self:ProcessAchievements()
    end
    -- Check if achievement was already earned
    if self.Achs[id] then return end
    -- Insert into SQL
    sql.Query("INSERT INTO gc_achievements_onetime VALUES('" .. self:SteamID() .. "', '" .. id .. "')")
    -- Process achievements
    self:ProcessAchievements()
    -- Notify
    GAMEMODE:PlayerNotifyAchievement(self, id)
    -- Log
    --print(string.format("[LHNS] Player %s (%s) earned achievement %s (%s)", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id))
    -- Call hook
    hook.Run("AchievementEarned", self, id)
end

-- For progressiv eachievements
function PLAYER:GiveAchievementProgress(id, count)
    -- Check if achievement was already earned
    if count == 0 or (self.Achs[id] or 0) >= GAMEMODE.Achievements[id].Goal then return end
    -- Make sure this exists for calculation
    self.Achs[id] = self.Achs[id] or 0

    -- Update or insert values
    if self.Achs[id] > 0 then
        sql.Query("UPDATE gc_achievements_progress SET SteamID = SteamID, AchievementID = AchievementID, Progress = " .. math.Clamp(self.Achs[id] + count, 0, GAMEMODE.Achievements[id].Goal) .. " WHERE SteamID = '" .. self:SteamID() .. "' AND AchievementID = '" .. id .. "'")
    else
        sql.Query("INSERT INTO gc_achievements_progress VALUES('" .. self:SteamID() .. "', '" .. id .. "', " .. math.Clamp(count, 0, GAMEMODE.Achievements[id].Goal) .. ")")
    end

    -- Cache
    self.Achs[id] = self.Achs[id] + count
    -- Log
    --print(string.format("[LHNS] Player %s (%s) has new achievement progress on %s (%s): %s/%s", self:Name(), self:SteamID(), GAMEMODE.Achievements[id].Name, id, self.Achs[id], GAMEMODE.Achievements[id].Goal))

    -- If we earned the achievement
    if self.Achs[id] >= GAMEMODE.Achievements[id].Goal then
        GAMEMODE:PlayerNotifyAchievement(self, id)
        -- Run hook
        hook.Run("AchievementEarned", self, id)
    end

    -- Update
    self:ProcessAchievements()
end

hook.Add("AchievementEarned","GroundControl_AchievmentEarned",function(ply,id)
    local reward = GAMEMODE.Achievements[id].Reward
    ply:addCash(reward.cash)
    ply:addExperience(reward.exp,nil,true)
    GAMEMODE:sendEvent(ply, "ACHIV_EARNED", reward)
end)

hook.Add("PlayerAbilityUse","AchivsAbilityUse",function(ply)
    ply:GiveAchievementProgress("spec",1)
end)

--[[hook.Add( "DoPlayerDeath", "GlobalDeathMessage", function(ply,attacker,dmginfo )
    local infl = dmginfo:GetInflictor()
    if IsValid(infl) and IsValid(attacker) and attacker:IsPlayer() and ply != attacker and ply:Team() != attacker:Team() and infl:GetClass() == "cw_kk_ins2_projectile_rpg" then
        attacker:GiveAchievement("dlan")
    end
end )--]]

