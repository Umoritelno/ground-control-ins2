surface.CreateFont("AchievsTitle",{
    font = "Roboto lt",
	extended = false,
	size = 17.5,
	weight = 500,
	blursize = 0.25,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = true,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont("MMSimple",{
    font = "Roboto lt",
	extended = false,
	size = 13,
	weight = 500,
	blursize = 0.25,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local golova = CreateClientConVar("VGOLOVU",0,true,false,"",0,1)
 -- I moved filter convar creation to cl_config

hook.Add( "InitPostEntity", "Ready", function()
        net.Start( "cool_addon_client_ready" )
        net.SendToServer()
end )

net.Receive("Golova",function()
    if golova:GetBool() == true then
        surface.PlaySound("golova.mp3")
    end
end)

function OpenMainMenu()
    if MainMenu then
        MainMenu:Remove()
        MainMenu = nil
    else 
        MainMenu = vgui.Create("DMainMenu")
    end
end

hook.Add("PlayerBindPress","MainMenuClose",function(ply,bind,pr,cd)
    if bind == GAMEMODE.MainMenuKey then
        OpenMainMenu()
    end
end)


--[[hook.Add("ShowSpare2","MainMenu",function(ply)
    print("hehe")
    OpenMainMenu()
end)
--]]

net.Receive( "SpawnMainMenu", function()
	OpenMainMenu()
end )


