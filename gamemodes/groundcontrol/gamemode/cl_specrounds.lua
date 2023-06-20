hook.Add( "CalcView", "PerevertishCalcView", function( ply, pos, angles, fov )
    if GAMEMODE.CurSpecRound == 1 then
        local view = {
            origin = origin,
            angles = angles,
            fov = fov,
            drawviewer = false
        }
        angles.r = 180 -- hehe
    
        return view
    end
end )

net.Receive("SpecRoundUpdate",function()
    local roundid = net.ReadInt(32)
    local roundcount = net.ReadInt(31)
    local serverbool = net.ReadBool()

    if serverbool then
        GAMEMODE.specRoundEnabled = false
    else 
        GAMEMODE.specRoundEnabled = true
    end

    GAMEMODE.GlobalSpecRound = roundcount

    if roundid != -1 then
        print("Spec Round Time")
        GAMEMODE.CurSpecRound = roundid
    else 
        GAMEMODE.CurSpecRound = nil 
    end
end)