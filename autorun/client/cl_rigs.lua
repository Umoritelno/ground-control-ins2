net.Receive("RigChange",function()
    local rigid = net.ReadInt(16)
    RunConsoleCommand("cw_kk_ins2_rig",rigid )
    --RunConsoleCommand("cw")
end)