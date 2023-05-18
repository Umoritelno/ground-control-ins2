AddCSLuaFile()

GM.Achievements = {}

GM.Achievements["headshot"] = {
    Name = "В яблочко",
    Desc = "Убейте человека в голову(в игре)",
    Reward = 50000
}

-- Cache count, to not call table.Count again
GM.AchievementsCount = table.Count(GM.Achievements)