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
    local localizedversion = GetCurLanguage().achivs[id]
    local finalname = GAMEMODE.Achievements[id].Name
    if localizedversion and localizedversion.Name then
        finalname = localizedversion.Name
    end
    -- Chat
    chat.AddText(Color(150, 197, 255, 255), "[", "Ground Control", "] ",Color(25,0,255), ply, COLOR_WHITE, " has earned ", Color(125, 255, 125), finalname, COLOR_WHITE, ".")
    -- Sound
    --ply:EmitSound("misc/achievement_earned.wav")
    -- Create particles
    --ParticleEffectAttach("bday_confetti", PATTACH_ABSORIGIN_FOLLOW, ply, 0)
    --local data = EffectData()
    --data:SetOrigin(ply:GetPos())
    --util.Effect("PhyscannonImpact", data)

end)