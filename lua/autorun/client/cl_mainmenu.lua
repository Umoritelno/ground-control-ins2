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

local curMap = string.lower(game.GetMap())


local scrw,scrh = ScrW(),ScrH()
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
    local CurLanguage = GetCurLanguage()
    local bglist = file.Find("materials/"..curMap.."/*.png","GAME")
    local fon 
    if bglist and !table.IsEmpty(bglist) then
        fon = table.Random(bglist)
        fon = Material(curMap.."/"..fon) -- i changed content directories so adding new backgrounds are easier
    else 
        fon = Material("backgrounds/defaultfon.png")
    end

    if MainMenu != nil then
        MainMenu:Remove()
        MainMenu = nil 
    else
        MainMenu = vgui.Create("DFrame")
        MainMenu.FadeSpeed = 25 
        MainMenu:SetSize(scrw,scrh)
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:MakePopup()
        local alpha = 255
        MainMenu.Paint = function(s,w,h)
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial(fon)
            surface.DrawTexturedRect(0,0,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,alpha))
            alpha = math.Clamp(alpha - MainMenu.FadeSpeed * FrameTime(),0,255)
        end
        function MainMenu:OnKeyCodePressed(keycode)
            if keycode == 95 then
                MainMenu:Remove()
                MainMenu = nil 
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
                    local scroll = vgui.Create("DScrollPanel",MainMenu.settings)
                    scroll:Dock(FILL)
                    -- OTHER LIST START
                    MainMenu.settings.OtherCollap = vgui.Create( "MMCollapsible", scroll )
                    MainMenu.settings.OtherCollap:SetLabel(string.upper(CurLanguage.settings.OtherCollap))	
                    MainMenu.settings.OtherCollap:Dock(TOP)
                    MainMenu.settings.OtherCollap:DockMargin(0,0,0,scrh * 0.03)	
                    MainMenu.settings.OtherCollap:SetExpanded( true )	-- Start collapsed
                    MainMenu.settings.OtherCollap.list = vgui.Create( "DPanelList", MainMenu.settings.OtherCollap ) 
                    MainMenu.settings.OtherCollap.list:SetSpacing( 5 )	
                    MainMenu.settings.OtherCollap.list:SetPadding(9)						
                    MainMenu.settings.OtherCollap.list:EnableHorizontal( false )					
                    MainMenu.settings.OtherCollap.list:EnableVerticalScrollbar( false )	
                    MainMenu.settings.OtherCollap:SetContents( MainMenu.settings.OtherCollap.list )	
                    -- OTHER LIST END 	
                    MainMenu.settings.OtherCollap.Golova = vgui.Create("DCheckBoxLabel",scroll)
                    --MainMenu.settings.Golova:Dock(TOP)
                    --MainMenu.settings.Golova:DockMargin(0,0,0,scrh * 0.01)
                    MainMenu.settings.OtherCollap.Golova:SetText(CurLanguage.settings.Headshot)
                    MainMenu.settings.OtherCollap.Golova:SetConVar("VGOLOVU")
                    MainMenu.settings.OtherCollap.list:AddItem( MainMenu.settings.OtherCollap.Golova )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.combo = vgui.Create("DComboBox", bindpanel)
                    bindpanel.combo:SetSize(scrw * 0.22,0)
                    bindpanel.combo:Dock(RIGHT)

                    for id,lang in pairs(Languages) do
                        bindpanel.combo:AddChoice(id)
                    end

                    bindpanel.combo.OnSelect = function(index,val,data)
                        --print(data)
                        SetCurLanguage(data)
                    end

                    bindpanel.combo:SetValue(GAMEMODE.Language)
                    
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.Language)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.OtherCollap.list:AddItem( bindpanel )

                    -- VISUAL LIST START 
                    MainMenu.settings.VisualCollap = vgui.Create( "MMCollapsible", scroll )
                    MainMenu.settings.VisualCollap:SetLabel(string.upper(CurLanguage.settings.VisualCollap))	
                    MainMenu.settings.VisualCollap:Dock(TOP)
                    MainMenu.settings.VisualCollap:DockMargin(0,0,0,scrh * 0.03)	
                    MainMenu.settings.VisualCollap:SetExpanded( true )	-- Start collapsed
                    MainMenu.settings.VisualCollap.list = vgui.Create( "DPanelList", MainMenu.settings.OtherCollap ) -- Make a list of items to add to our category (collection of controls)
                    MainMenu.settings.VisualCollap.list:SetSpacing( 5 )				
                    MainMenu.settings.VisualCollap.list:SetPadding(9) -- DColorMixer is looking weird without padding changes
                    MainMenu.settings.VisualCollap.list:EnableHorizontal( false )					-- Only vertical items
                    MainMenu.settings.VisualCollap.list:EnableVerticalScrollbar( false )			-- Enable the scrollbar if (the contents are too wide)
                    MainMenu.settings.VisualCollap:SetContents( MainMenu.settings.VisualCollap.list )
                    -- VISUAL LIST END 
                    MainMenu.settings.VisualCollap.Legs = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.Legs:SetText(CurLanguage.settings.Legs)
                    MainMenu.settings.VisualCollap.Legs:SetConVar("cl_legs")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.Legs )

                    MainMenu.settings.VisualCollap.Toytown = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.Toytown:SetText(CurLanguage.settings.Toytown)
                    MainMenu.settings.VisualCollap.Toytown:SetConVar("gc_toytown")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.Toytown )

                    -- bloom effect start
                    MainMenu.settings.VisualCollap.BloomBool = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.BloomBool:SetText(CurLanguage.settings.BloomBool)
                    MainMenu.settings.VisualCollap.BloomBool:SetConVar("gc_bloom_enable")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.BloomBool )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.combo = vgui.Create("DComboBox", bindpanel)
                    bindpanel.combo:SetSize(scrw * 0.22,0)
                    bindpanel.combo:Dock(RIGHT)

                    for ind,tbl in pairs(GAMEMODE.BloomTable) do
                        bindpanel.combo:AddChoice(ind,tbl)
                    end

                    bindpanel.combo.OnSelect = function(index,val,data)
                        GetConVar("gc_bloom_id"):SetString(data)
                    end

                    bindpanel.combo:SetValue(GAMEMODE.BloomType)
                    
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.BloomStyle)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.VisualCollap.list:AddItem( bindpanel )
                    
                    -- bloom effect end 
                    
                    MainMenu.settings.VisualCollap.FilterBool = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.FilterBool:SetText(CurLanguage.settings.FilterBool)
                    MainMenu.settings.VisualCollap.FilterBool:SetConVar("BlueFilter")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.FilterBool )
                    MainMenu.settings.VisualCollap.FilterColor = {}

                    MainMenu.settings.VisualCollap.FilterColor.r = vgui.Create("DNumSlider", scroll)
                    MainMenu.settings.VisualCollap.FilterColor.r:SetText(CurLanguage.settings.FilterRed)
                    MainMenu.settings.VisualCollap.FilterColor.r:SetMin(GetConVar("gc_filter_red"):GetMin())
                    MainMenu.settings.VisualCollap.FilterColor.r:SetMax(GetConVar("gc_filter_red"):GetMax())
                    MainMenu.settings.VisualCollap.FilterColor.r:SetDecimals(2)
                    MainMenu.settings.VisualCollap.FilterColor.r:SetConVar("gc_filter_red")

                    MainMenu.settings.VisualCollap.FilterColor.g = vgui.Create("DNumSlider", scroll)
                    MainMenu.settings.VisualCollap.FilterColor.g:SetText(CurLanguage.settings.FilterGreen)
                    MainMenu.settings.VisualCollap.FilterColor.g:SetMin(GetConVar("gc_filter_green"):GetMin())
                    MainMenu.settings.VisualCollap.FilterColor.g:SetMax(GetConVar("gc_filter_green"):GetMax())
                    MainMenu.settings.VisualCollap.FilterColor.g:SetDecimals(2)
                    MainMenu.settings.VisualCollap.FilterColor.g:SetConVar("gc_filter_green")

                    MainMenu.settings.VisualCollap.FilterColor.b = vgui.Create("DNumSlider", scroll)
                    MainMenu.settings.VisualCollap.FilterColor.b:SetText(CurLanguage.settings.FilterBlue)
                    MainMenu.settings.VisualCollap.FilterColor.b:SetMin(GetConVar("gc_filter_blue"):GetMin())
                    MainMenu.settings.VisualCollap.FilterColor.b:SetMax(GetConVar("gc_filter_blue"):GetMax())
                    MainMenu.settings.VisualCollap.FilterColor.b:SetDecimals(2)
                    MainMenu.settings.VisualCollap.FilterColor.b:SetConVar("gc_filter_blue")

                    MainMenu.settings.VisualCollap.FilterColor.a = vgui.Create("DNumSlider", scroll)
                    MainMenu.settings.VisualCollap.FilterColor.a:SetText(CurLanguage.settings.FilterColour)
                    MainMenu.settings.VisualCollap.FilterColor.a:SetMin(GetConVar("gc_filter_colour"):GetMin())
                    MainMenu.settings.VisualCollap.FilterColor.a:SetMax(GetConVar("gc_filter_colour"):GetMax())
                    MainMenu.settings.VisualCollap.FilterColor.a:SetDecimals(2)
                    MainMenu.settings.VisualCollap.FilterColor.a:SetConVar("gc_filter_colour")

                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.FilterColor.r )
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.FilterColor.g )
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.FilterColor.b )
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.FilterColor.a )
                    
                    MainMenu.settings.VisualCollap.Impact = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.Impact:SetText(CurLanguage.settings.Impact)
                    MainMenu.settings.VisualCollap.Impact:SetConVar("cl_new_impact_effects")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.Impact )

                    MainMenu.settings.VisualCollap.Dynlight = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.Dynlight:SetText(CurLanguage.settings.Dynlight)
                    MainMenu.settings.VisualCollap.Dynlight:SetConVar("cl_tfa_rms_muzzleflash_dynlight")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.Dynlight )

                    MainMenu.settings.VisualCollap.SmokeShock = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.SmokeShock:SetText(CurLanguage.settings.SmokeShock)
                    MainMenu.settings.VisualCollap.SmokeShock:SetConVar("cl_tfa_rms_smoke_shock")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.SmokeShock )

                    MainMenu.settings.VisualCollap.EjectSmoke = vgui.Create("DCheckBoxLabel",scroll)
                    MainMenu.settings.VisualCollap.EjectSmoke:SetText(CurLanguage.settings.EjectSmoke)
                    MainMenu.settings.VisualCollap.EjectSmoke:SetConVar("cl_tfa_rms_default_eject_smoke")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.EjectSmoke )

                    MainMenu.settings.VisualCollap.XAxis = vgui.Create("DNumSlider",scroll)
                    MainMenu.settings.VisualCollap.XAxis:SetText(CurLanguage.settings.XAxis)
                    MainMenu.settings.VisualCollap.XAxis:SetMin(GetConVar("gc_cw_x"):GetMin())
                    MainMenu.settings.VisualCollap.XAxis:SetMax(GetConVar("gc_cw_x"):GetMax())
                    MainMenu.settings.VisualCollap.XAxis:SetDecimals(1)
                    MainMenu.settings.VisualCollap.XAxis:SetConVar("gc_cw_x")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.XAxis )

                    MainMenu.settings.VisualCollap.YAxis = vgui.Create("DNumSlider",scroll)
                    MainMenu.settings.VisualCollap.YAxis:SetText(CurLanguage.settings.YAxis)
                    MainMenu.settings.VisualCollap.YAxis:SetMin(GetConVar("gc_cw_y"):GetMin())
                    MainMenu.settings.VisualCollap.YAxis:SetMax(GetConVar("gc_cw_y"):GetMax())
                    MainMenu.settings.VisualCollap.YAxis:SetDecimals(1)
                    MainMenu.settings.VisualCollap.YAxis:SetConVar("gc_cw_y")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.YAxis )

                    MainMenu.settings.VisualCollap.ZAxis = vgui.Create("DNumSlider",scroll)
                    MainMenu.settings.VisualCollap.ZAxis:SetText(CurLanguage.settings.ZAxis)
                    MainMenu.settings.VisualCollap.ZAxis:SetMin(GetConVar("gc_cw_z"):GetMin())
                    MainMenu.settings.VisualCollap.ZAxis:SetMax(GetConVar("gc_cw_z"):GetMax())
                    MainMenu.settings.VisualCollap.ZAxis:SetDecimals(1)
                    MainMenu.settings.VisualCollap.ZAxis:SetConVar("gc_cw_z")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.ZAxis )

                    MainMenu.settings.VisualCollap.XAxisTFA = vgui.Create("DNumSlider",scroll)
                    MainMenu.settings.VisualCollap.XAxisTFA:SetText(CurLanguage.settings.XAxisTFA)
                    MainMenu.settings.VisualCollap.XAxisTFA:SetMin(GetConVar("cl_tfa_viewmodel_offset_x"):GetMin())
                    MainMenu.settings.VisualCollap.XAxisTFA:SetMax(GetConVar("cl_tfa_viewmodel_offset_x"):GetMax())
                    MainMenu.settings.VisualCollap.XAxisTFA:SetDecimals(1)
                    MainMenu.settings.VisualCollap.XAxisTFA:SetConVar("cl_tfa_viewmodel_offset_x")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.XAxisTFA )

                    MainMenu.settings.VisualCollap.YAxisTFA = vgui.Create("DNumSlider",scroll)
                    MainMenu.settings.VisualCollap.YAxisTFA:SetText(CurLanguage.settings.YAxisTFA)
                    MainMenu.settings.VisualCollap.YAxisTFA:SetMin(GetConVar("cl_tfa_viewmodel_offset_y"):GetMin())
                    MainMenu.settings.VisualCollap.YAxisTFA:SetMax(GetConVar("cl_tfa_viewmodel_offset_y"):GetMax())
                    MainMenu.settings.VisualCollap.YAxisTFA:SetDecimals(1)
                    MainMenu.settings.VisualCollap.YAxisTFA:SetConVar("cl_tfa_viewmodel_offset_y")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.YAxisTFA )

                    MainMenu.settings.VisualCollap.ZAxisTFA = vgui.Create("DNumSlider",scroll)
                    MainMenu.settings.VisualCollap.ZAxisTFA:SetText(CurLanguage.settings.ZAxisTFA)
                    MainMenu.settings.VisualCollap.ZAxisTFA:SetMin(GetConVar("cl_tfa_viewmodel_offset_z"):GetMin())
                    MainMenu.settings.VisualCollap.ZAxisTFA:SetMax(GetConVar("cl_tfa_viewmodel_offset_z"):GetMax())
                    MainMenu.settings.VisualCollap.ZAxisTFA:SetDecimals(1)
                    MainMenu.settings.VisualCollap.ZAxisTFA:SetConVar("cl_tfa_viewmodel_offset_z")
                    MainMenu.settings.VisualCollap.list:AddItem( MainMenu.settings.VisualCollap.ZAxisTFA )
                    -- gameplay Collap start
                    MainMenu.settings.GameplayCollap = vgui.Create( "MMCollapsible", scroll )
                    MainMenu.settings.GameplayCollap:SetLabel(string.upper(CurLanguage.settings.GameplayCollap))	
                    MainMenu.settings.GameplayCollap:Dock(TOP)
                    MainMenu.settings.GameplayCollap:DockMargin(0,0,0,scrh * 0.03)	
                    MainMenu.settings.GameplayCollap:SetExpanded( true )	-- Start collapsed
                    MainMenu.settings.GameplayCollap.list = vgui.Create( "DPanelList", MainMenu.settings.OtherCollap ) -- Make a list of items to add to our category (collection of controls)
                    MainMenu.settings.GameplayCollap.list:SetSpacing( 5 )				
                    MainMenu.settings.GameplayCollap.list:SetPadding(9) -- DColorMixer is looking weird without padding changes
                    MainMenu.settings.GameplayCollap.list:EnableHorizontal( false )					-- Only vertical items
                    MainMenu.settings.GameplayCollap.list:EnableVerticalScrollbar( false )			-- Enable the scrollbar if (the contents are too wide)
                    MainMenu.settings.GameplayCollap:SetContents( MainMenu.settings.GameplayCollap.list )
                    -- gameplay Collap end 

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0)
                    bindpanel.bind:Dock(RIGHT)
                    bindpanel.bind:SetSelectedNumber(GetConVar("ability_key"):GetInt())
                    function bindpanel.bind:OnChange(num)
                        GetConVar("ability_key"):SetInt(num)
                    end 
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.AbilityKey)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.GameplayCollap.list:AddItem( bindpanel )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0)
                    bindpanel.bind:Dock(RIGHT)
                    bindpanel.bind:SetSelectedNumber(GetConVar("gc_radiokey"):GetInt())
                    function bindpanel.bind:OnChange(num)
                        GetConVar("gc_radiokey"):SetInt(num)
                    end 
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.RadioKey)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.GameplayCollap.list:AddItem( bindpanel )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0)
                    bindpanel.bind:Dock(RIGHT)
                    bindpanel.bind:SetSelectedNumber(GetConVar("NVGBASE_INPUT"):GetInt())
                    function bindpanel.bind:OnChange(num)
                        LocalPlayer():ConCommand("NVGBASE_INPUT "..num)
                        --GetConVar("NVGBASE_INPUT"):SetInt(num)
                    end 
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.NVGActivation)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.GameplayCollap.list:AddItem( bindpanel )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0)
                    bindpanel.bind:Dock(RIGHT)
                    bindpanel.bind:SetSelectedNumber(GetConVar("NVGBASE_CYCLE"):GetInt())
                    function bindpanel.bind:OnChange(num)
                        LocalPlayer():ConCommand("NVGBASE_CYCLE "..num) -- its throwing error aka "cant modify convar created not by Lua"
                        --GetConVar("NVGBASE_CYCLE"):SetInt(num)
                    end 
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.NVGCycle)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.GameplayCollap.list:AddItem( bindpanel )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0)
                    bindpanel.bind:Dock(RIGHT)
                    bindpanel.bind:SetSelectedNumber(GetConVar("gc_lean_left"):GetInt())
                    function bindpanel.bind:OnChange(num)
                        GetConVar("gc_lean_left"):SetInt(num)
                    end 
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.LeanLeft)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.GameplayCollap.list:AddItem( bindpanel )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0)
                    bindpanel.bind:Dock(RIGHT)
                    bindpanel.bind:SetSelectedNumber(GetConVar("gc_lean_right"):GetInt())
                    function bindpanel.bind:OnChange(num)
                        GetConVar("gc_lean_right"):SetInt(num)
                    end 
                    bindpanel.lbl = vgui.Create("DLabel",bindpanel)
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.LeanRight)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    MainMenu.settings.GameplayCollap.list:AddItem( bindpanel )



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
                    if MainMenu and MainMenu.settings then 
                        MainMenu.settings:Remove()
                        MainMenu.settings = nil 
                    end 
                end)
              end 
            end 
        end

        local achivs = vgui.Create("MMButton",MainMenu)
        achivs:Dock(BOTTOM)
        achivs:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        achivs:SetText("ACHIEVEMENTS")
        achivs:SetTextColor(Color(255,255,255))


        local playButton = vgui.Create("MMButton",MainMenu)
            playButton:Dock(BOTTOM)
            playButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            playButton:SetText("PLAY")
            playButton:SetTextColor(Color(255,255,255))
            playButton.DoClick = function()
                MainMenu:Remove()
                MainMenu = nil 
            end

        local title = vgui.Create("DLabel",MainMenu)
        title:Dock(BOTTOM)
        title:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        title:SetTextColor(Color(255,255,255,120))
        title:SetText("Ground Kontrol")
        title:SetFont("CloseCaption_BoldItalic")

        achivs.DoClick = function()
            if MainMenu.achivs == nil then 
                MainMenu.achivs = vgui.Create("DFrame",MainMenu)
                MainMenu.achivs:SetPos(scrw * 0.25,scrh * 2)
                MainMenu.achivs:SetSize(scrw * 0.25,scrh)
                MainMenu.achivs.InAnim = true
                local scroll = vgui.Create("DScrollPanel",MainMenu.achivs)
                scroll:Dock(FILL)

            local i = 1
            local count = table.Count(GAMEMODE.Achievements)

        for id, ach in pairs(GAMEMODE.Achievements) do
          local panel = scroll:Add("DPanel")
          panel:SetHeight(scrh * 0.05)
          panel:Dock(TOP)
          panel:DockMargin(0,0,0,scrh * 0.03)
          panel:SetTooltip(ach.Desc)
          local weight,height = panel:GetSize()
          local desc = panel:Add("RichText")
          desc:Dock(FILL)
          desc:DockMargin(scrw * 0.04,scrh * 0.019,scrw * 0.02,scrh * 0.001)
          desc:AppendText(ach.Desc)

        if ach.Goal then
                panel.Done = (GAMEMODE.AchievementsProgress[id] or 0) >= ach.Goal
            else
                panel.Done = GAMEMODE.AchievementsProgress[id] == true
        end
        
          panel.Paint = function(me,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(63,59,59))
            --surface.DrawOutlinedRect(0,0,w,h,1.1)
            draw.SimpleText(ach.Name,"AchievsTitle",w * 0.5,h * 0.25,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
            if panel.Done then
                draw.SimpleText("+","MMSimple",w * 0.1,h / 2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            if ach.Goal then
                draw.SimpleTextOutlined((GAMEMODE.AchievementsProgress[id] or 0) .. "/" .. ach.Goal,"MMSimple",w * 0.8,h * 0.5,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1.1,Color(0,0,0))
                --self:ShadowedText((GAMEMODE.AchievementsProgress[id] or 0) .. "/" .. ach.Goal, "HNS.RobotoSmall", w / 2, 60, self:GetTheme(3), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            surface.SetDrawColor(GAMEMODE.HUDColors.white)
            surface.DrawOutlinedRect(0,0,w,h,1)
         end

        i = i + 1
        end

                MainMenu.achivs:MoveTo(scrw * 0.25,0,0.5,0,-1,function()
                    MainMenu.achivs.InAnim = false
                end)
                MainMenu.achivs:SetTitle("")
                MainMenu.achivs:ShowCloseButton(false)
                 MainMenu.achivs.Paint = function(s,w,h)
                    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,150))
                    surface.SetDrawColor(255,255,255,125)
                    surface.DrawOutlinedRect(0,0,w,h,1.5)
                 end
            else 
                if not MainMenu.achivs.InAnim then 
                    MainMenu.achivs:MoveTo(scrw * 0.25,scrh * 2,0.5,0,-1,function()
                    if MainMenu and MainMenu.achivs then 
                        MainMenu.achivs:Remove()
                        MainMenu.achivs = nil 
                    end 
                  end)
                end 
            end 
 

        end

    end
end

hook.Add("PlayerBindPress","MainMenuClose",function(ply,bind,pr,cd)
    if bind == "gm_showspare2" then
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


