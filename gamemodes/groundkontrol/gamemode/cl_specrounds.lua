function GM:SpecRoundCalcView(ply, eyePos, eyeAng, fov, nearZ, farZ)
    if GAMEMODE.CurSpecRound == "perevorot" then
        local view = {
            origin = eyePos,
            angles = eyeAng,
            fov = fov,
            drawviewer = false
        }
        view.angles.r = 180 -- hehe
    
        return view
    end
    return false
end

net.Receive("SpecRoundUpdate",function()
    local roundid = net.ReadString()
    local roundcount = net.ReadInt(31)

    GAMEMODE.GlobalSpecRound = roundcount

    if roundid != "None" then
        print("Spec Round Time")
        GAMEMODE.CurSpecRound = roundid
    else 
        GAMEMODE.CurSpecRound = nil 
    end
end)