
hook.Add("EntityTakeDamage","SpecRoundDamage",function(target,dmg)
    if target:IsPlayer() then
        if GAMEMODE.CurSpecRound == "balance" then
            dmg = dmg * math.Rand(0,2)
        end
    end
end)