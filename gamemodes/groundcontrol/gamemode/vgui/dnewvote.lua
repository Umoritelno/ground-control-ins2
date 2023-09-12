local circles = include("includes/circles.lua")
local PANEL = {}

function PANEL:addItem( tbl )
	local RulePanel = self.scroll:Add( "ManualCheckBox" )
    RulePanel.HoverMul = 0
    RulePanel.MaxHoverMul = 0.1
    RulePanel.MinHoverMul = 0
	RulePanel.Cvr = tbl.cvar -- Create container for this item
	RulePanel:Dock( TOP ) -- Dock it
	RulePanel:DockMargin( 0, 1, 0, 0 ) -- Add 1 pixel spacing in between each item
    function RulePanel:Paint(w,h)
        local FT = FrameTime()
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(0,0,w,h,1.2)
        surface.DrawOutlinedRect(w * 0.9,0,w,h,1.2)
        if self:GetChecked() then
            self.HoverMul = math.Approach(self.HoverMul,self.MaxHoverMul,FT * 1.1)
            self.NeedAnim = true 
        else
            self.NeedAnim = false
            self.HoverMul = math.Approach(self.HoverMul,self.MinHoverMul,FT * 1.1)
        end
        --[[local TopTriangle = {
            {x = w,y = h},
            {x = w * (1 - self.HoverMul),y = h},
            {x = w,y = h * self.HoverMul},
        }--]]

        local TopTriangle = {
            {x = w * 0.9,y = h},
            {x = w * (1 - self.HoverMul),y = h * 0.1},
            {x = w,y = h * self.HoverMul},
        }
        local BottomTriangle = {
            {x = w,y = h},
            {x = w * (1 - self.HoverMul),y = h},
            {x = w,y = h * self.HoverMul},
        }
        surface.SetDrawColor(255,255,255,125)
        draw.NoTexture()
        surface.DrawPoly(BottomTriangle)
        surface.DrawPoly(TopTriangle)
       -- draw.RoundedBox(0,0,0,w * self.HoverMul,h,Color(255,255,255,200))
        --draw.RoundedBox(0,w * (1 -self.HoverMul),0,w,h,Color(255,255,255,200))
        --surface.DrawOutlinedRect(w * 0.8,0,w,h,1.2)
    end

	table.insert(self.ChildPo,RulePanel)


	--[[local CheckBox = RulePanel:Add( "ManualCheckBox" ) -- Create checkbox with image
    CheckBox.HoverMul = 0
    CheckBox.MaxHoverMul = 0.5
    CheckBox.MinHoverMul = 0
	CheckBox:SetWidth( RulePanel:GetWide() * 1.8 ) -- Make the check box a bit wider than the image so it looks nicer
	CheckBox:Dock( RIGHT ) -- Dock it
	CheckBox:SetChecked( false )
    function CheckBox:Paint(w,h)
        local FT = FrameTime()
        if self:GetChecked() then
            self.HoverMul = math.Approach(self.HoverMul,self.MaxHoverMul,FT * 3)
        else
            self.HoverMul = math.Approach(self.HoverMul,self.MinHoverMul,FT * 3)
        end
        surface.SetDrawColor(255,255,255)
        surface.DrawOutlinedRect(0,0,w,h,1.2)
        draw.RoundedBox(0,0,0,w * self.HoverMul,h,Color(255,255,255,200))
        draw.RoundedBox(0,w * (1 -self.HoverMul),0,w,h,Color(255,255,255,200))
    end
	RulePanel.CheckBox = CheckBox -- Add reference to call--]]

	local DLabel = RulePanel:Add( "DLabel" ) -- Create text
	DLabel:SetText( tbl.helptext ) -- Set the text
	DLabel:Dock( FILL ) -- Dock it
	DLabel:DockMargin( 5, 0, 0, 0 ) -- Move the text to the right a little
	DLabel:SetTextColor( Color( 255, 255, 255) ) -- Set text color to black
end

function PANEL:Init()
    local scrw,scrh = ScrW(),ScrH()
   self.timer = CurTime() + GAMEMODE.NewVoteTime
   self.ChildPo = {}
   self:SetSize(0,0)
   self.IsAnim = true
   self:MakePopup()
   self:SetTitle("")
   self:ShowCloseButton(false)
   local scroll = self:Add("DScrollPanel")
   scroll:DockMargin(0,scrh * 0.02,0,0)
   scroll:Dock(FILL)
   self.scroll = scroll
   for k,v in pairs(GAMEMODE.NewGolosArgs) do
	self:addItem(v)
   end
   self.Apply = vgui.Create("DButton",self)
   self.Apply.HoverMul = 0
   self.Apply.MaxHoverMul = 1
   self.Apply.MinHoverMul = 0
   self.Apply:SetText("Sent to server")
   self.Apply:Dock(BOTTOM)
   self.Apply:SetTextColor(GAMEMODE.HUDColors.white)
   self.Apply.DoClick = function()
	self:Close()
   end
   self.Apply.Paint = function(s,w,h)
    local FT = FrameTime()
    if s:IsHovered() then
        self.Apply.HoverMul = math.Approach(self.Apply.HoverMul,self.Apply.MaxHoverMul,FT * 1.1)
    else
        self.Apply.HoverMul = math.Approach(self.Apply.HoverMul,self.Apply.MinHoverMul,FT * 1.1)
    end
    draw.RoundedBox(0,0,0,w * 0.1,h * self.Apply.HoverMul,Color(255,255,255,75))
    draw.RoundedBox(0,w * 0.9,h * (1 - self.Apply.HoverMul),w * 0.1,h,Color(255,255,255,75))
	surface.SetDrawColor(255,255,255)
	surface.DrawOutlinedRect(0,0,w,h,1)
   end
   self:SizeTo(scrw * 0.3,scrh * 0.375,0.5,0,-1,function(animdata,pnl)
       self.IsAnim = false
   end)
end 

function PANEL:OnClose()
	local cvarsTbl = {}
	for k,v in pairs(self.ChildPo) do
		cvarsTbl[v.Cvr] = v:GetChecked() == true
	end
	net.Start("NewVote_Get")
	net.WriteTable(cvarsTbl)
	net.SendToServer()
end

function PANEL:Think()
	if self.IsAnim then
        self:Center()
    end
    if CurTime() >= self.timer then
        self:Close()
    end
end

function PANEL:Paint(w,h)
   local alpha = self:GetAlpha()
   local timecircle = circles.New(CIRCLE_FILLED,20,w * 0.5, h * 0.06)
   local percent = math.Clamp((self.timer - CurTime()) / GAMEMODE.NewVoteTime,0,1)
   BlurPanel(self,1,1,alpha)
   timecircle:SetStartAngle(360 - (360 * percent))
   draw.NoTexture()
   surface.SetDrawColor(255,255,255,alpha)
   timecircle()
   surface.DrawOutlinedRect(0,0,w,h,1.75)
   draw.RoundedBox(0,0,0,w,h,Color(32,32,32,110))
end

vgui.Register("NewVote",PANEL,"DFrame")