net.Receive("AchievementsMaster", function()
    local ply = net.ReadEntity()
    ply.AchMaster = true
end)

-- Receive achievements progress
net.Receive("AchievementsProgress", function()
    GAMEMODE.AchievementsProgress = util.JSONToTable(net.ReadString())

    -- Clamp progress
    for id, progress in pairs(GAMEMODE.AchievementsProgress) do
        if isnumber(progress) then
            GAMEMODE.AchievementsProgress[id] = math.Clamp(progress, 0, GAMEMODE.Achievements[id].Goal)
        end
    end
end)

-- Receive an achievement
net.Receive("GetAchiv", function()
    local ply = net.ReadEntity()
    local id = net.ReadString()
    -- Chat
    chat.AddText(COLOR_WHITE, "[", Color(125, 255, 125), "HNS", COLOR_WHITE, "] ", ply, COLOR_WHITE, " has earned ", Color(125, 255, 125), GAMEMODE.Achievements[id].Name, COLOR_WHITE, ".")
    -- Sound
    --ply:EmitSound("misc/achievement_earned.wav")
    -- Create particles
    --ParticleEffectAttach("bday_confetti", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
    --local data = EffectData()
    --data:SetOrigin(ply:GetPos())
    --util.Effect("PhyscannonImpact", data)

    -- Persistent
    --[[timer.Create("HNS.AchParticles1." .. ply:EntIndex(), 0.3, 10, function()
        if not IsValid(ply) then return end
        ParticleEffectAttach("bday_confetti", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
        local data1 = EffectData()
        data1:SetOrigin(ply:GetPos())
        util.Effect("PhyscannonImpact", data1)
    end)

    timer.Create("HNS.AchParticles2." .. ply:EntIndex(), 0.1, 50, function()
        if not IsValid(ply) then return end
        ParticleEffectAttach("bday_confetti_colors", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
        local data2 = EffectData()
        data2:SetOrigin(ply:GetPos())
        util.Effect("PhyscannonImpact", data2)
    end)
    --]]
end)