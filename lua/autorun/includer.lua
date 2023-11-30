if engine.ActiveGamemode() == "groundcontrol" then -- dont change gamemode folder name pls :(
    AddCSLuaFile("includes/circles.lua")
    local files,dirs = file.Find("gc_lua/*","LUA")
    for _,file in pairs(files) do
        AddCSLuaFile("gc_lua/"..file)
        include("gc_lua/"..file)
    end
    for _,dir in pairs(dirs) do
        local path = file.Find("gc_lua/"..dir.."/*.lua","LUA")
        for _,file in pairs(path) do
            if dir == "client" then
                AddCSLuaFile("gc_lua/client/"..file)
                if CLIENT then
                    include("gc_lua/client/"..file)
                end
            elseif dir == "server" then 
                if SERVER then
                    include("gc_lua/server/"..file)
                end
            end
        end
    end
end