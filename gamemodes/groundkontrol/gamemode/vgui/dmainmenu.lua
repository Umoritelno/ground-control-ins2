-- menu stuff start

local creditslabels = {
    ["Spy"] = "Ground Control and CW 2.0 Creator",
    ["Knife Kitty"] = "KK Ins2 base creator",
    ["NextOren and RXSend developers"] = "Inspiration",
    ["Toyka"] = "Inspiration and help with code",
    ["LifeMod Developers"] = "Bloom settings and vignettes",
}
local creditvignette = {
    ["gradient-r"] = Material("vgui/gradient-r"),
    ["gradient-l"] = Material("vgui/gradient-l"),
    ["gradient-u"] = Material("vgui/gradient-u"),
}

local PANEL = {}
PANEL.BarSpeed = 2

function PANEL:Init()
    self.BarStatus = 0
end

function PANEL:Paint(w,h)
    if self:IsHovered() then
            self.BarStatus = math.Clamp(self.BarStatus + self.BarSpeed * FrameTime(),0,1)
        else
            self.BarStatus = math.Clamp(self.BarStatus - self.BarSpeed * FrameTime(),0,1)
    end
    DisableClipping(true)
    surface.SetDrawColor(48,48,48,self.BarStatus * 255)
    surface.SetMaterial(creditvignette["gradient-l"])
    surface.DrawTexturedRect(0,0,w * self.BarStatus,h)
    draw.RoundedBox(0,5,h,w * self.BarStatus,1,Color(255,255,255))
    draw.RoundedBox(0,0,2.5,5,h,Color(255,255,255,125))
    DisableClipping(false)
end 

vgui.Register("MMButton",PANEL,"DButton")

local PANEL = {}
PANEL.VignetteSpeed = 2

function PANEL:Init()
    self.Header.Paint = function(s,w,h)
        surface.SetDrawColor(64,64,64,self.VignetteStatus * 255)
        surface.SetMaterial(creditvignette["gradient-u"])
        DisableClipping(true)
        surface.DrawTexturedRect(-4,0,w,h)
        DisableClipping(false)
    end
    self.VignetteStatus = 0
end

function PANEL:Paint(w,h)
    if self:GetExpanded() then
        self.VignetteStatus = math.Clamp(self.VignetteStatus + self.VignetteSpeed * FrameTime(),0,1)
    else
        self.VignetteStatus = math.Clamp(self.VignetteStatus - self.VignetteSpeed * FrameTime(),0,1)
    end
    DisableClipping(true)
    surface.SetDrawColor(255,255,255)
    surface.DrawOutlinedRect(-5,0,w,h + 5,1.1)
    DisableClipping(false)
end 

vgui.Register("MMCollapsible",PANEL,"DCollapsibleCategory")

-- menu stuff end

local tbl = {}
tbl.FadeSpeed = 25

function tbl:Init()
    local curMap = string.lower(game.GetMap())
    local scrw,scrh = ScrW(),ScrH()
    local CurLanguage = GetCurLanguage()
    local bglist = file.Find("materials/"..curMap.."/*.png","GAME")
    local fon 
    if bglist and !table.IsEmpty(bglist) then
        fon = table.Random(bglist)
        fon = Material(curMap.."/"..fon) -- i changed content directories so adding new backgrounds are easier
    else 
        fon = Material("backgrounds/defaultfon.png")
    end
        self.AutoUpdateVars = {} -- this table updating when player closing main menu
        self:SetSize(scrw,scrh)
        self:Center()
        self:SetTitle("")
        self:SetDraggable(false)
        self:ShowCloseButton(false)
        self:MakePopup()
        local alpha = 255
        self.Paint = function(s,w,h)
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetMaterial(fon)
            surface.DrawTexturedRect(0,0,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,alpha))
            alpha = math.Clamp(alpha - self.FadeSpeed * FrameTime(),0,255)
        end
        --[[function self:OnKeyCodePressed(keycode)
            if keycode == 95 then
                self:Remove()
                self = nil 
            end
        end--]]

        local exitToMenuButton = vgui.Create("MMButton",self)
            exitToMenuButton:Dock(BOTTOM)
            exitToMenuButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            exitToMenuButton:SetText("OPEN GMOD'S OVERLAY")
            exitToMenuButton:SetTextColor(Color(255,255,255))
            exitToMenuButton.DoClick = function(s)
                gui.ActivateGameUI()
                self:Remove()
            end

        local exitButton = vgui.Create("MMButton",self)
            exitButton:Dock(BOTTOM)
            exitButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            exitButton:SetText("EXIT")
            exitButton:SetTextColor(Color(255,255,255))
            exitButton.DoClick = function()
                RunConsoleCommand("Disconnect")
            end
        
        local CreditsButton = vgui.Create("MMButton",self)
        CreditsButton:Dock(BOTTOM)
        CreditsButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        CreditsButton.BarStatus = 0
        CreditsButton.BarSpeed = 2
        CreditsButton:SetText("CREDITS")
        CreditsButton:SetTextColor(Color(255,255,255))
            CreditsButton.DoClick = function()
                if self.credits == nil then 
                self.credits = vgui.Create("DFrame",self)
                self.credits:SetPos(scrw * 0.5,scrh * 1.30)
                self.credits:SetSize(scrw * 0.2,scrh * 0.25)
                self.credits:SetDraggable(false)
                self.credits.InAnim = true 
                self.credits:MoveTo(scrw * 0.5,scrh * 0.75,0.45,0,-1,function()
                    self.credits.InAnim = false 
                end)
                self.credits:SetTitle("")
                self.credits:ShowCloseButton(false)
                self.credits.Paint = function(s,w,h)
                    --draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
                    BlurPanel(s,1,1,255)
                    surface.SetDrawColor(255,255,255,125)
                    surface.DrawOutlinedRect(0,0,w,h,1.5)
                end
                local creditScroller = vgui.Create("DScrollPanel",self.credits)
                creditScroller:Dock(FILL)
                for k,v in pairs(creditslabels) do
                    local credit = creditScroller:Add("DLabel")
                    credit:Dock(TOP)
                    credit:DockMargin(0,0,0,scrh * 0.01)
                    credit:SetText(k.." ".."-".."  "..v)
                    credit.Paint = function(s,w,h)
                        surface.SetMaterial(creditvignette["gradient-r"])
                        surface.SetDrawColor(64,64,64,120)
                        surface.DrawTexturedRect(0,0,w,h)
                    end
                end
            else
                if not self.credits.InAnim then 
                    self.credits:MoveTo(scrw * 0.5,scrh * 1.30,0.45,0,-1,function()
                    if self.credits != nil then 
                     self.credits:Remove()
                     self.credits = nil 
                    end 
                end)
            end 
            end 
        end

        local SettingsButton = vgui.Create("MMButton",self)
        SettingsButton:Dock(BOTTOM)
        SettingsButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        SettingsButton.BarStatus = 0
        SettingsButton.BarSpeed = 2
        SettingsButton:SetText("SETTINGS")
        SettingsButton:SetTextColor(Color(255,255,255))
            SettingsButton.DoClick = function()
                if self.settings == nil then 
                    self.settings = vgui.Create("DFrame",self)
                    self.settings:SetPos(scrw * 1.30,0)
                    self.settings:SetSize(scrw * 0.3,scrh)
                    self.settings:SetDraggable(false)
                    self.settings.InAnim = true 
                    local scroll = vgui.Create("DScrollPanel",self.settings)
                    scroll:Dock(FILL)
                    surface.SetFont("DermaDefault")
                    self.settings.AddCategory = function(s,name,id,docktop)
                        s[id] = vgui.Create( "MMCollapsible", scroll )
                        s[id]:SetLabel(name)	
                        s[id]:Dock(TOP)
                        s[id]:DockMargin(0,0,0,docktop)	
                        s[id]:SetExpanded( true )	-- Start collapsed
                        s[id].list = vgui.Create( "DPanelList", s[id] ) 
                        s[id].list:SetSpacing( 5 )	
                        s[id].list:SetPadding( 9 )						
                        s[id].list:EnableHorizontal( false )					
                        s[id].list:EnableVerticalScrollbar( false )	
                        s[id]:SetContents( s[id].list )	
                    end
                    -- OTHER LIST START
                    self.settings:AddCategory(string.upper(CurLanguage.settings.OtherCollap),"OtherCollap",scrh * 0.03)
                    -- OTHER LIST END 	
                    self.settings.OtherCollap.Golova = vgui.Create("DCheckBoxLabel",scroll)
                    --self.settings.Golova:Dock(TOP)
                    --self.settings.Golova:DockMargin(0,0,0,scrh * 0.01)
                    self.settings.OtherCollap.Golova:SetText(CurLanguage.settings.Headshot)
                    self.settings.OtherCollap.Golova:SetConVar("VGOLOVU")
                    self.settings.OtherCollap.list:AddItem( self.settings.OtherCollap.Golova )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.combo = vgui.Create("DComboBox", bindpanel)
                    bindpanel.combo:SetSize(scrw * 0.20,0)
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
                    
                    self.settings.OtherCollap.list:AddItem( bindpanel )

                    -- VISUAL LIST START 
                    self.settings:AddCategory(string.upper(CurLanguage.settings.VisualCollap),"VisualCollap",scrh * 0.03)
                    -- VISUAL LIST END 
                    self.settings.VisualCollap.Crosshair = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.Crosshair:SetText(CurLanguage.settings.Crosshair)
                    self.settings.VisualCollap.Crosshair:SetConVar("gc_crosshair_enable")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.Crosshair )

                    --[[self.settings.VisualCollap.HUDMirror  = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.HUDMirror:SetText(CurLanguage.settings.HudFlipped )
                    self.settings.VisualCollap.HUDMirror:SetConVar("gc_hud_flipped")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.HUDMirror )--]]
                    
                    self.settings.VisualCollap.Legs = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.Legs:SetText(CurLanguage.settings.Legs)
                    self.settings.VisualCollap.Legs:SetConVar("cl_legs")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.Legs )

                    self.settings.VisualCollap.Toytown = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.Toytown:SetText(CurLanguage.settings.Toytown)
                    self.settings.VisualCollap.Toytown:SetConVar("gc_toytown")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.Toytown )

                    -- bloom effect start
                    self.settings.VisualCollap.BloomBool = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.BloomBool:SetText(CurLanguage.settings.BloomBool)
                    self.settings.VisualCollap.BloomBool:SetConVar("gc_bloom_enable")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.BloomBool )

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
                    
                    self.settings.VisualCollap.list:AddItem( bindpanel )
                    
                    -- bloom effect end 
                    
                    self.settings.VisualCollap.FilterBool = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.FilterBool:SetText(CurLanguage.settings.FilterBool)
                    self.settings.VisualCollap.FilterBool:SetConVar("gc_filter_enable")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.FilterBool )
                    self.settings.VisualCollap.FilterColor = {}

                    self.settings.VisualCollap.FilterColor.r = vgui.Create("DNumSlider", scroll)
                    self.settings.VisualCollap.FilterColor.r:SetText(CurLanguage.settings.FilterRed)
                    self.settings.VisualCollap.FilterColor.r:SetMin(GetConVar("gc_filter_red"):GetMin())
                    self.settings.VisualCollap.FilterColor.r:SetMax(GetConVar("gc_filter_red"):GetMax())
                    self.settings.VisualCollap.FilterColor.r:SetDecimals(2)
                    self.settings.VisualCollap.FilterColor.r:SetConVar("gc_filter_red")

                    self.settings.VisualCollap.FilterColor.g = vgui.Create("DNumSlider", scroll)
                    self.settings.VisualCollap.FilterColor.g:SetText(CurLanguage.settings.FilterGreen)
                    self.settings.VisualCollap.FilterColor.g:SetMin(GetConVar("gc_filter_green"):GetMin())
                    self.settings.VisualCollap.FilterColor.g:SetMax(GetConVar("gc_filter_green"):GetMax())
                    self.settings.VisualCollap.FilterColor.g:SetDecimals(2)
                    self.settings.VisualCollap.FilterColor.g:SetConVar("gc_filter_green")

                    self.settings.VisualCollap.FilterColor.b = vgui.Create("DNumSlider", scroll)
                    self.settings.VisualCollap.FilterColor.b:SetText(CurLanguage.settings.FilterBlue)
                    self.settings.VisualCollap.FilterColor.b:SetMin(GetConVar("gc_filter_blue"):GetMin())
                    self.settings.VisualCollap.FilterColor.b:SetMax(GetConVar("gc_filter_blue"):GetMax())
                    self.settings.VisualCollap.FilterColor.b:SetDecimals(2)
                    self.settings.VisualCollap.FilterColor.b:SetConVar("gc_filter_blue")

                    self.settings.VisualCollap.FilterColor.a = vgui.Create("DNumSlider", scroll)
                    self.settings.VisualCollap.FilterColor.a:SetText(CurLanguage.settings.FilterColour)
                    self.settings.VisualCollap.FilterColor.a:SetMin(GetConVar("gc_filter_colour"):GetMin())
                    self.settings.VisualCollap.FilterColor.a:SetMax(GetConVar("gc_filter_colour"):GetMax())
                    self.settings.VisualCollap.FilterColor.a:SetDecimals(2)
                    self.settings.VisualCollap.FilterColor.a:SetConVar("gc_filter_colour")

                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.FilterColor.r )
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.FilterColor.g )
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.FilterColor.b )
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.FilterColor.a )
                    
                    self.settings.VisualCollap.Impact = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.Impact:SetText(CurLanguage.settings.Impact)
                    self.settings.VisualCollap.Impact:SetConVar("cl_new_impact_effects")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.Impact )

                    self.settings.VisualCollap.Dynlight = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.Dynlight:SetText(CurLanguage.settings.Dynlight)
                    self.settings.VisualCollap.Dynlight:SetConVar("cl_tfa_rms_muzzleflash_dynlight")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.Dynlight )

                    self.settings.VisualCollap.SmokeShock = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.SmokeShock:SetText(CurLanguage.settings.SmokeShock)
                    self.settings.VisualCollap.SmokeShock:SetConVar("cl_tfa_rms_smoke_shock")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.SmokeShock )

                    self.settings.VisualCollap.EjectSmoke = vgui.Create("DCheckBoxLabel",scroll)
                    self.settings.VisualCollap.EjectSmoke:SetText(CurLanguage.settings.EjectSmoke)
                    self.settings.VisualCollap.EjectSmoke:SetConVar("cl_tfa_rms_default_eject_smoke")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.EjectSmoke )

                    self.settings.VisualCollap.XAxis = vgui.Create("DNumSlider",scroll)
                    self.settings.VisualCollap.XAxis:SetText(CurLanguage.settings.XAxis)
                    self.settings.VisualCollap.XAxis:SetMin(GetConVar("gc_cw_x"):GetMin())
                    self.settings.VisualCollap.XAxis:SetMax(GetConVar("gc_cw_x"):GetMax())
                    self.settings.VisualCollap.XAxis:SetDecimals(1)
                    self.settings.VisualCollap.XAxis:SetConVar("gc_cw_x")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.XAxis )

                    self.settings.VisualCollap.YAxis = vgui.Create("DNumSlider",scroll)
                    self.settings.VisualCollap.YAxis:SetText(CurLanguage.settings.YAxis)
                    self.settings.VisualCollap.YAxis:SetMin(GetConVar("gc_cw_y"):GetMin())
                    self.settings.VisualCollap.YAxis:SetMax(GetConVar("gc_cw_y"):GetMax())
                    self.settings.VisualCollap.YAxis:SetDecimals(1)
                    self.settings.VisualCollap.YAxis:SetConVar("gc_cw_y")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.YAxis )

                    self.settings.VisualCollap.ZAxis = vgui.Create("DNumSlider",scroll)
                    self.settings.VisualCollap.ZAxis:SetText(CurLanguage.settings.ZAxis)
                    self.settings.VisualCollap.ZAxis:SetMin(GetConVar("gc_cw_z"):GetMin())
                    self.settings.VisualCollap.ZAxis:SetMax(GetConVar("gc_cw_z"):GetMax())
                    self.settings.VisualCollap.ZAxis:SetDecimals(1)
                    self.settings.VisualCollap.ZAxis:SetConVar("gc_cw_z")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.ZAxis )

                    self.settings.VisualCollap.XAxisTFA = vgui.Create("DNumSlider",scroll)
                    self.settings.VisualCollap.XAxisTFA:SetText(CurLanguage.settings.XAxisTFA)
                    self.settings.VisualCollap.XAxisTFA:SetMin(GetConVar("cl_tfa_viewmodel_offset_x"):GetMin())
                    self.settings.VisualCollap.XAxisTFA:SetMax(GetConVar("cl_tfa_viewmodel_offset_x"):GetMax())
                    self.settings.VisualCollap.XAxisTFA:SetDecimals(1)
                    self.settings.VisualCollap.XAxisTFA:SetConVar("cl_tfa_viewmodel_offset_x")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.XAxisTFA )

                    self.settings.VisualCollap.YAxisTFA = vgui.Create("DNumSlider",scroll)
                    self.settings.VisualCollap.YAxisTFA:SetText(CurLanguage.settings.YAxisTFA)
                    self.settings.VisualCollap.YAxisTFA:SetMin(GetConVar("cl_tfa_viewmodel_offset_y"):GetMin())
                    self.settings.VisualCollap.YAxisTFA:SetMax(GetConVar("cl_tfa_viewmodel_offset_y"):GetMax())
                    self.settings.VisualCollap.YAxisTFA:SetDecimals(1)
                    self.settings.VisualCollap.YAxisTFA:SetConVar("cl_tfa_viewmodel_offset_y")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.YAxisTFA )

                    self.settings.VisualCollap.ZAxisTFA = vgui.Create("DNumSlider",scroll)
                    self.settings.VisualCollap.ZAxisTFA:SetText(CurLanguage.settings.ZAxisTFA)
                    self.settings.VisualCollap.ZAxisTFA:SetMin(GetConVar("cl_tfa_viewmodel_offset_z"):GetMin())
                    self.settings.VisualCollap.ZAxisTFA:SetMax(GetConVar("cl_tfa_viewmodel_offset_z"):GetMax())
                    self.settings.VisualCollap.ZAxisTFA:SetDecimals(1)
                    self.settings.VisualCollap.ZAxisTFA:SetConVar("cl_tfa_viewmodel_offset_z")
                    self.settings.VisualCollap.list:AddItem( self.settings.VisualCollap.ZAxisTFA )
                    -- gameplay Collap start
                    self.settings:AddCategory(string.upper(CurLanguage.settings.GameplayCollap),"GameplayCollap",scrh * 0.03)
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
                    
                    self.settings.GameplayCollap.list:AddItem( bindpanel )

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
                    local size = 
                    bindpanel.lbl:SetSize(scrw * 0.15,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.RadioKey)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    self.settings.GameplayCollap.list:AddItem( bindpanel )

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
                    
                    self.settings.GameplayCollap.list:AddItem( bindpanel )

                    local bindpanel = vgui.Create("DPanel",scroll)
                    bindpanel.Paint = function(w,h) end 
                    bindpanel.bind = vgui.Create("DBinder", bindpanel)
                    bindpanel.bind:SetSize(scrw * 0.14,0) --scrw * 0.14
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
                    
                    self.settings.GameplayCollap.list:AddItem( bindpanel )

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
                    
                    self.settings.GameplayCollap.list:AddItem( bindpanel )

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
                    bindpanel.lbl:SetSize(scrw * 0.14,0)
                    bindpanel.lbl:Dock(LEFT)
                    bindpanel.lbl:SetText(CurLanguage.settings.LeanRight)
                    bindpanel.lbl:SetTextColor(GAMEMODE.HUDColors.white)
                    
                    self.settings.GameplayCollap.list:AddItem( bindpanel )



                    self.settings:MoveTo(scrw * 0.7,0,0.5,0,-1,function()
                       self.settings.InAnim = false 
                    end)
                self.settings:SetTitle("")
                self.settings:ShowCloseButton(false)
                 self.settings.Paint = function(s,w,h)
                    BlurPanel(s,1,1,255)
                    surface.SetDrawColor(255,255,255,125)
                    surface.DrawOutlinedRect(0,0,w,h,1.5)
                 end
            else
                if not self.settings.InAnim then 
                    self.settings:MoveTo(scrw * 1.30,0,0.5,0,-1,function()
                    if self and self.settings then 
                        self.settings:Remove()
                        self.settings = nil 
                    end 
                end)
              end 
            end 
        end

        local achivs = vgui.Create("MMButton",self)
        achivs:Dock(BOTTOM)
        achivs:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        achivs:SetText("ACHIEVEMENTS")
        achivs:SetTextColor(Color(255,255,255))


        local playButton = vgui.Create("MMButton",self)
            playButton:Dock(BOTTOM)
            playButton:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
            playButton:SetText("PLAY")
            playButton:SetTextColor(Color(255,255,255))
            playButton.DoClick = function()
                self:Remove()
                self = nil 
            end

        local title = vgui.Create("DLabel",self)
        title:Dock(BOTTOM)
        title:DockMargin(scrw * 0.05,0,scrw * 0.75,scrh * 0.05)
        title:SetTextColor(Color(255,255,255,120))
        title:SetText("Ground Kontrol")
        title:SetFont("CloseCaption_BoldItalic")

        achivs.DoClick = function()
            if self.achivs == nil then 
                self.achivs = vgui.Create("DFrame",self)
                self.achivs:SetPos(scrw * 0.25,scrh * 2)
                self.achivs:SetSize(scrw * 0.25,scrh)
                self.achivs:SetDraggable(false)
                self.achivs.InAnim = true
                local scroll = vgui.Create("DScrollPanel",self.achivs)
                scroll:Dock(FILL)

            local i = 1
            local count = table.Count(GAMEMODE.Achievements)

        for id, ach in pairs(GAMEMODE.Achievements) do
          local localized = CurLanguage.achivs[id]
          local panel = scroll:Add("DPanel")
          panel:SetHeight(scrh * 0.05)
          panel:Dock(TOP)
          panel:DockMargin(0,0,0,scrh * 0.03)
          panel:SetTooltip(ach.Desc)
          local weight,height = panel:GetSize()
          local desc = panel:Add("RichText")
          desc:Dock(FILL)
          desc:DockMargin(scrw * 0.04,scrh * 0.019,scrw * 0.02,scrh * 0.001)
          desc:AppendText(localized.Desc or ach.Desc)

         if ach.Goal then
                panel.Done = (GAMEMODE.AchievementsProgress[id] or 0) >= ach.Goal
            else
                panel.Done = GAMEMODE.AchievementsProgress[id] == true
         end
        
          panel.Paint = function(me,w,h)
            draw.RoundedBox(0,0,0,w,h,Color(63,59,59))
            --surface.DrawOutlinedRect(0,0,w,h,1.1)
            draw.SimpleText(localized.Name or ach.Name,"AchievsTitle",w * 0.5,h * 0.25,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
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

            self.achivs:MoveTo(scrw * 0.25,0,0.5,0,-1,function()
                self.achivs.InAnim = false
            end)
            self.achivs:SetTitle("")
            self.achivs:ShowCloseButton(false)
            self.achivs.Paint = function(s,w,h)
                BlurPanel(s,1,1,255)
                surface.SetDrawColor(255,255,255,125)
                surface.DrawOutlinedRect(0,0,w,h,1.5)
            end
            else 
             if not self.achivs.InAnim then 
                self.achivs:MoveTo(scrw * 0.25,scrh * 2,0.5,0,-1,function()
                 if self and self.achivs then 
                    self.achivs:Remove()
                    self.achivs = nil 
                 end 
                end)
             end 
            end 
 

        end
    MainMenu = self
end


function tbl:OnRemove()
    for cvar,tbl in pairs(self.AutoUpdateVars) do
        if tbl.type == "float" then
            GetConVar(cvar):SetFloat(tbl.val)
        elseif tbl.type == "int" then 
            GetConVar(cvar):SetInt(tbl.val)
        elseif tbl.type == "bool" then 
            GetConVar(cvar):SetBool(tbl.val)
        end
    end
    MainMenu = nil
end 
--[[function OpenMainMenu()
end]]

vgui.Register("DMainMenu",tbl,"DFrame")