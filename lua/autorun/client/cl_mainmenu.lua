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



--local MainMenu,settings
local creditslabels = {
    ["Spy"] = "Ground Control and CW 2.0 Creator",
    ["Knife Kitty"] = "KK Ins2 base creator",
    ["NextOren and RXSend developers"] = "Inspiration",
    ["Toyka"] = "Insipiration and help with code",
    ["LifeMod Developers"] = "Bloom settings and vignettes",
    ["-Spac3-"] = "Pidorasina ebannaya, not RXSend enjoyer",
}
-- Main Menu Button Register start 
local PANEL = {}
PANEL.BarStatus = 0
PANEL.BarSpeed = 2

function PANEL:Paint(w,h)
   if self:IsHovered() then
            self.BarStatus = math.Clamp(self.BarStatus + self.BarSpeed * FrameTime(),0,1)
        else
            self.BarStatus = math.Clamp(self.BarStatus - self.BarSpeed * FrameTime(),0,1)
    end
    DisableClipping(true)
    draw.RoundedBox(0,5,h,w * self.BarStatus,1,Color(255,255,255))
    draw.RoundedBox(0,0,2.5,5,h,Color(255,255,255,125))
    DisableClipping(false)
end 

vgui.Register("MMButton",PANEL,"DButton")
-- Main Menu Button Register end 

-- Main Menu Collapsible Register start
local PANEL = {}

function PANEL:Paint(w,h)
    DisableClipping(true)
    surface.SetDrawColor(255,255,255)
    surface.DrawOutlinedRect(-5,0,w,h + 5,1.1)
    DisableClipping(false)
end 

vgui.Register("MMCollapsible",PANEL,"DCollapsibleCategory")

-- Main Menu Collapsible Register end 

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


