AddCSLuaFile()

GM.Achievements = {}

GM.Achievements["headshot"] = {
    Name = "В яблочко",
    Desc = "Убейте человека в голову",
    Reward = {cash = 1000,exp = 50}
}

GM.Achievements["dlan"] = {
    Name = "Неотвратимость карающей длани",
    Desc = "Заставьте врага познать неотвратимость карающей длани с помощью РПГ-7",
    Reward = {cash = 2500,exp = 150}
}

GM.Achievements["spec"] = {
    Name = "Специалист",
    Desc = "Используйте свою способность 25 раз",
    Goal = 25,
    Reward = {cash = 3000,exp = 300}
}

-- Cache count, to not call table.Count again
GM.AchievementsCount = table.Count(GM.Achievements)