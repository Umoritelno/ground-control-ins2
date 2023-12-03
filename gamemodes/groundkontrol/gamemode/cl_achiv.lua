local achivchatcolors = {
    ["nick"] = Color(63,48,150),
    ["standard"] = Color(150, 197, 255, 255),
    ["achivname"] =  Color(125, 255, 125),
}

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
    if !ply or !ply:IsPlayer() or !IsValid(ply) then
        return
    end
    local id = net.ReadString()
    local localizedversion = GetCurLanguage().achivs[id]
    local finalname = GAMEMODE.Achievements[id] and GAMEMODE.Achievements[id].Name or "ERROR"
    if localizedversion and localizedversion.Name then
        finalname = localizedversion.Name
    end
    -- Chat
    chat.AddText(achivchatcolors.standard, "[Ground Control] ",achivchatcolors.nick, ply , achivchatcolors.standard, " has earned ", achivchatcolors.achivname, finalname , achivchatcolors.standard, ".")
end)