

local MainMenu,settings
local creditslabels = {
    ["Spy"] = "Ground Control and CW 2.0 Creator",
    ["Knife Kitty"] = "KK Ins2 base creator",
    ["Nextoren And RXSend developers"] = "Inspiration",
}

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
end 

vgui.Register("MMButton",PANEL,"DButton")


local background = {
    ["cs_militia"] = Material("backgrounds/fon1.png"),
    ["cs_assault"] = Material("backgrounds/fon2.png"),
    ["cs_italy"] = Material("backgrounds/fon3.png"),
    ["de_nuke"] = Material("backgrounds/fon4.png"),
    ["de_inferno"] = Material("backgrounds/fon5.png"),
    ["de_train"] = Material("backgrounds/fon6.png"),
    ["de_dust2"] = Material("backgrounds/fon7.png"),
    ["de_dust"] = Material("backgrounds/fon8.png"),
    ["cs_compound"] = Material("backgrounds/fon9.png"),
    ["cs_havana"] = Material("backgrounds/fon10.png"),
    ["cs_office"] = Material("backgrounds/fon11.png"),
    ["de_aztec"] = Material("backgrounds/fon12.png"),
    ["de_cbble"] = Material("backgrounds/fon13.png"),
    ["de_chateau"] = Material("backgrounds/fon14.png"),
    ["de_piranesi"] = Material("backgrounds/fon15.png"),
    ["de_port"] = Material("backgrounds/fon16.png"),
    ["de_prodigy"] = Material("backgrounds/fon17.png"),
    ["de_tides"] = Material("backgrounds/fon18.png"),
}

local fon = Material("defaultfon.png")
local titleimage = Material("Logo.png")
if background[game.GetMap()] != nil then
    fon = background[game.GetMap()]
else
    fon = Material("backgrounds/defaultfon.png")
end

local scrw,scrh = ScrW(),ScrH()
CreateClientConVar("InMainMenu","0",false,false,"",0,1)
CreateClientConVar("VGOLOVU",0,true,false,"",0,1)
CreateClientConVar("BlueFilter",0,true,false,"",0,1)

hook.Add( "InitPostEntity", "Ready", function()
        net.Start( "cool_addon_client_ready" )
        net.SendToServer()
end )

net.Receive("Golova",function()
    if GetConVar("VGOLOVU"):GetBool() == true then
        --print("belike")
        surface.PlaySound("golova.mp3")
    end
end)

function OpenMainMenu()
    local mainmenustatus = GetConVar("InMainMenu")
    if MainMenu != nil then
        MainMenu:Remove()
        MainMenu = nil 
        settings = nil 
        mainmenustatus:SetBool(false)
    else
        mainmenustatus:SetBool(true)
        MainMenu = vgui.Create("DFrame")
        MainMenu:SetSize(scrw,scrh)
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:MakePopup()
        MainMenu.Paint = function(s,w,h)
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial(fon)
            surface.DrawTexturedRect(0,0,w,h)
        end
        function MainMenu:OnKeyCodePressed(keycode)
            if keycode == 92 then
                MainMenu:Remove()
                MainMenu = nil 
                mainmenustatus:SetBool(false)
            end
        end

        local exitButton = vgui.Create("MMButton",MainMenu)
            exitButton:Dock(BOTTOM)
            exitButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            exitButton:SetText("EXIT")
            exitButton:SetTextColor(Color(255,255,255))
            exitButton.DoClick = function()
                RunConsoleCommand("Disconnect")
            end
        
        local CreditsButton = vgui.Create("MMButton",MainMenu)
        CreditsButton:Dock(BOTTOM)
        CreditsButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        CreditsButton.BarStatus = 0
        CreditsButton.BarSpeed = 2
        CreditsButton:SetText("CREDITS")
        CreditsButton:SetTextColor(Color(255,255,255))
            CreditsButton.DoClick = function()
                if MainMenu.credits == nil then 
                MainMenu.credits = vgui.Create("DFrame",MainMenu)
                MainMenu.credits:SetPos(scrw * 0.375,scrh * 1.30)
                MainMenu.credits:SetSize(scrw * 0.2,scrh * 0.25)
                MainMenu.credits.InAnim = true 
                MainMenu.credits:MoveTo(scrw * 0.375,scrh * 0.75,0.45,0,-1,function()
                    MainMenu.credits.InAnim = false 
                end)
                MainMenu.credits:SetTitle("")
                MainMenu.credits:ShowCloseButton(false)
                MainMenu.credits.Paint = function(s,w,h)
                    draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
                end
                local creditScroller = vgui.Create("DScrollPanel",MainMenu.credits)
                creditScroller:Dock(FILL)
                for k,v in pairs(creditslabels) do
                    local credit = creditScroller:Add("DLabel")
                    credit:Dock(TOP)
                    credit:DockMargin(0,0,0,scrh * 0.01)
                    credit:SetText(k.." ".."-".."  "..v)
                end
            else
                if not MainMenu.credits.InAnim then 
                    MainMenu.credits:MoveTo(scrw * 0.375,scrh * 1.30,0.45,0,-1,function()
                    if MainMenu.credits != nil then 
                     MainMenu.credits:Remove()
                     MainMenu.credits = nil 
                    end 
                end)
            end 
            end 
        end

        local SettingsButton = vgui.Create("MMButton",MainMenu)
        SettingsButton:Dock(BOTTOM)
        SettingsButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        SettingsButton.BarStatus = 0
        SettingsButton.BarSpeed = 2
        SettingsButton:SetText("SETTINGS")
        SettingsButton:SetTextColor(Color(255,255,255))
            SettingsButton.DoClick = function()
                if MainMenu.settings == nil then 
                    MainMenu.settings = vgui.Create("DFrame",MainMenu)
                    MainMenu.settings:SetPos(scrw * 1.30,0)
                    MainMenu.settings:SetSize(scrw * 0.3,scrh)
                    MainMenu.settings.InAnim = true 
                    MainMenu.settings.Golova = vgui.Create("DCheckBoxLabel",MainMenu.settings)

                    MainMenu.settings.Golova:Dock(TOP)
                    MainMenu.settings.Golova:DockMargin(0,0,0,scrh * 0.01)
                    MainMenu.settings.Golova:SetText("В ГОЛОВУ")
                    MainMenu.settings.Golova:SetConVar("VGOLOVU")
                    MainMenu.settings.Impact = vgui.Create("DCheckBoxLabel",MainMenu.settings)
                    MainMenu.settings.Impact:Dock(TOP)
                    MainMenu.settings.Impact:DockMargin(0,0,0,scrh * 0.01)
                    MainMenu.settings.Impact:SetText("Включить улучшенные эффекты попадания пуль?")
                    MainMenu.settings.Impact:SetConVar("cl_new_impact_effects")
                    MainMenu.settings.BlueFilter = vgui.Create("DCheckBoxLabel",MainMenu.settings)
                    MainMenu.settings.BlueFilter:Dock(TOP)
                    MainMenu.settings.BlueFilter:DockMargin(0,0,0,scrh * 0.01)
                    MainMenu.settings.BlueFilter:SetText("Включить синий фильтр?")
                    MainMenu.settings.BlueFilter:SetConVar("BlueFilter")
                    MainMenu.settings.ARC9Settings = vgui.Create("DButton",MainMenu.settings)
                    MainMenu.settings.ARC9Settings:Dock(TOP)
                    MainMenu.settings.ARC9Settings:DockMargin(0,0,0,scrh * 0.01)
                    MainMenu.settings.ARC9Settings:SetText("Открыть меню настроек ARC9")
                    MainMenu.settings.ARC9Settings.DoClick = function()
                        ARC9_OpenSettings()
                    end
                    MainMenu.settings:MoveTo(scrw * 0.7,0,0.5,0,-1,function()
                    MainMenu.settings.InAnim = false 
                end)
                MainMenu.settings:SetTitle("")
                MainMenu.settings:ShowCloseButton(false)
                MainMenu.settings.Paint = function(s,w,h)
                    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,150))
                end
            else
                if not MainMenu.settings.InAnim then 
                    MainMenu.settings:MoveTo(scrw * 1.30,0,0.5,0,-1,function()
                    if MainMenu.settings != nil then 
                        MainMenu.settings:Remove()
                        MainMenu.settings = nil 
                    end 
                end)
            end 
            end 
        end


        local playButton = vgui.Create("MMButton",MainMenu)
            playButton:Dock(BOTTOM)
            playButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            playButton:SetText("PLAY")
            playButton:SetTextColor(Color(255,255,255))
            playButton.DoClick = function()
                MainMenu:Remove()
                MainMenu = nil 
                mainmenustatus:SetBool(false)
            end

            local title = vgui.Create("DLabel",MainMenu)
            --title:SetPos(scrw * 0.045 ,scrh * 0.4)
            --title:SetSize(scrw * 0.1,scrh * 0.1)
            title:Dock(BOTTOM)
            title:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            title:SetTextColor(Color(255,255,255,120))
            title:SetText("Ground Kontrol")
            title:SetFont("CloseCaption_BoldItalic")
    end
end

hook.Add("PlayerBindPress","MainMenuClose",function(ply,bind,pr,cd)
    if bind == "gm_showhelp" then
        OpenMainMenu()
    end
end)

net.Receive( "SpawnMainMenu", function()
	OpenMainMenu()
end )