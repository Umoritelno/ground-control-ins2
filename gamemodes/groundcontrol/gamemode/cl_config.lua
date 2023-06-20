--[[
	if you wish to setup specific things for the gamemode ON THE CLIENT, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--

-- client cvars start 
local cwZ = CreateClientConVar("gc_cw_z","0",true,false,"How much z-axis of CW 2.0 weapons will be increased",-3,1)
local cwY = CreateClientConVar("gc_cw_y","0",true,false,"How much y-axis of CW 2.0 weapons will be increased",-1,5)
local cwX = CreateClientConVar("gc_cw_x","0",true,false,"How much x-axis of CW 2.0 weapons will be increased",-1,3)

local filter = CreateClientConVar("BlueFilter",0,true,false,"Will filter work?",0,1)
-- filter rgb elements start
local filterRed = CreateClientConVar("gc_filter_red","0",true,false,"The add color's red value. 0 (black) means no change.",0,0.05)
local filterGreen = CreateClientConVar("gc_filter_green","0",true,false,"The add color's green value. 0 (black) means no change.",0,0.05)
local filterBlue = CreateClientConVar("gc_filter_blue","0",true,false,"The add color's blue value. 0 (black) means no change.",0,0.05)
local filterColour = CreateClientConVar("gc_filter_colour","0",true,false,"The saturation value. Setting this to 0 will turn the image to grey-scale. 1 means no change.",1,3)
-- filter rgb elements end 
GM.FilterColor = Color(filterRed:GetFloat(),filterBlue:GetFloat(),filterGreen:GetFloat(),filterColour:GetFloat())
local customModify = {
	[ "$pp_colour_addr" ] = GM.FilterColor.r,
	[ "$pp_colour_addg" ] = GM.FilterColor.g,
	[ "$pp_colour_addb" ] = GM.FilterColor.b,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = GM.FilterColor.a,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

GM.CW_Z = cwZ:GetFloat()
GM.CW_Y = cwY:GetFloat()
GM.CW_X = cwX:GetFloat()

-- filter cvars callback start

cvars.AddChangeCallback("gc_filter_red", function(name, old, new)
	GAMEMODE.FilterColor.r = new 
	customModify["$pp_colour_addr"] = new 
end)

cvars.AddChangeCallback("gc_filter_green", function(name, old, new)
	GAMEMODE.FilterColor.g = new 
	customModify["$pp_colour_addg"] = new
end)

cvars.AddChangeCallback("gc_filter_blue", function(name, old, new)
	GAMEMODE.FilterColor.b = new
	customModify["$pp_colour_addb"] = new
end)

cvars.AddChangeCallback("gc_filter_colour", function(name, old, new)
	GAMEMODE.FilterColor.a = new
	customModify["$pp_colour_colour"] = new
end)

--filter cvars callback end 

-- weapon cvars callback start 

cvars.AddChangeCallback("gc_cw_z", function(name, old, new)
	GAMEMODE.CW_Z = new 
end)

cvars.AddChangeCallback("gc_cw_y", function(name, old, new)
	GAMEMODE.CW_Y = new 
end)

cvars.AddChangeCallback("gc_cw_x", function(name, old, new)
	GAMEMODE.CW_X = new 
end)
-- weapon cvars callback end 
-- client cvars end 
-- colormodify start 
hook.Add( "RenderScreenspaceEffects", "GroundControlColorModify", function()
	local bool = filter:GetBool()
	if bool then
		DrawColorModify( customModify )
	end
end )
-- colormodify end 
local blur = Material("pp/blurscreen")
local plr = FindMetaTable("Player")

-- fonts start

surface.CreateFont("ShowRole", {
    font = "Roboto", 
	extended = false,
	size = 30,
	weight = 500,
	blursize = 1.25,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

surface.CreateFont("SpecRound", {
    font = "Prototype", 
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0.1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false ,
})

-- fonts end 

function BlurPanel( panel, layers, density, alpha )
    local x, y = panel:LocalToScreen(0, 0)

    surface.SetDrawColor( 255, 255, 255, alpha )
    surface.SetMaterial( blur )

    for i = 1, 3 do
        blur:SetFloat( "$blur", ( i / layers ) * density )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
    end
end

function plr:ShowRole(desc)
    if text then
		if timer.Exists("RolePanelRemove") then
			timer.Remove("RolePanelRemove")
		end
		--[[for i = 0,text.size do
			if timer.Exists("RolePanelAdd"..i) then
			 timer.Remove("RolePanelAdd"..i)
		    end
		end
		--]]
		text:Remove()
		text = nil
	end

	text = vgui.Create("RichText")
	text.stringtable = string.ToTable(desc)
	text.size = table.Count(text.stringtable)
	text:SetSize(ScrW() * 0.25,ScrH() * 0.15)
	text:SetPos(ScrW() * 0.325,ScrH() * 0.1)
	text:CenterHorizontal()
	--text:Dock(FILL)
	text:AppendText(desc)
	text:InsertColorChange(0,0,0,255)
	text:SetVerticalScrollbarEnabled(false)
    local delay = 0
	--[[for number,bukva in pairs(text.stringtable) do
		timer.Create("RolePanelAdd"..number,delay + 0.1,1,function()
			if number == table.Count(text.stringtable) then
				timer.Create("RolePanelRemove",5,1,function()
		         if text:IsValid() then
			      text:Remove()
			      text = nil 
		         end
	            end)
			end
			if text then
				delay = delay + 0.1
			    text:AppendText(bukva)
			    chat.PlaySound() 
			end
		end)
	end
	--]]
	timer.Create("RolePanelRemove",15,1,function()
		if text:IsValid() then
		 text:Remove()
		 text = nil 
		end
	end)

    function text:Paint(w,h)
	    BlurPanel( self, 1, 1, self:GetAlpha() )
		surface.DrawOutlinedRect(0,0,w,h,3.5)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,125))
	end

	function text:PerformLayout()
		self:SetFGColor(Color(255, 255, 255))
		self:SetFontInternal( "ShowRole" )
	end
end 


net.Receive("classinfo",function()
	local classtable = player_manager.GetPlayerClasses()[player_manager.GetPlayerClass(LocalPlayer())]
	LocalPlayer().plclass = classtable
	LocalPlayer():ShowRole(classtable.Desc)
end)

hook.Add("TFA_InspectVGUI_Start", "Kill TFA customization", function()
    return CurTime() < GAMEMODE.PreparationTime
end)

CustomizableWeaponry.callbacks:addNew("adjustViewmodelPosition", "GroundControl_adjustViewmodelPosition2", function(self, targetPos, targetAng)
	if self.dt.State == 0 then
		targetPos.y = targetPos.y + GAMEMODE.CW_Y
	    targetPos.z = targetPos.z + GAMEMODE.CW_Z
		targetPos.x = targetPos.x + GAMEMODE.CW_X
	end
	
	return targetPos, targetAng
end)

net.Receive("killnotification",function()
	local rolestr = net.ReadString()
	local nick = net.ReadString()
	chat.AddText(Color(150, 197, 255, 255), "[GROUND CONTROL] ", Color(255, 255, 255, 255), "Вы убили союзника ",Color(252,207,8),nick,Color(255,255,255)," Роль: ",Color(3,243,23),rolestr,"." )
end)

--[[

local PANEL = {}

function PANEL:addItem( convar )
	local RulePanel = self:Add( "DPanel" )
	RulePanel.Cvr = convar -- Create container for this item
	RulePanel:Dock( TOP ) -- Dock it
	RulePanel:DockMargin( 0, 1, 0, 0 ) -- Add 1 pixel spacing in between each item
	self.cvrs[RulePanel.Cvr] = false

	--table.insert( self.cvrs, RulePanel.Cvr ) -- Add to list of lines

	local ImageCheckBox = RulePanel:Add( "ImageCheckBox" ) -- Create checkbox with image
	ImageCheckBox:SetMaterial( "icon16/accept.png" ) -- Set its image
	ImageCheckBox:SetWidth( 24 ) -- Make the check box a bit wider than the image so it looks nicer
	ImageCheckBox:Dock( LEFT ) -- Dock it
	ImageCheckBox:SetChecked( false )
	ImageCheckBox.OnChange = function(val)
		self.cvrs[RulePanel.Cvr] = val
	end
	RulePanel.ImageCheckBox = ImageCheckBox -- Add reference to call

	local DLabel = RulePanel:Add( "DLabel" ) -- Create text
	DLabel:SetText( convar:GetHelpText() ) -- Set the text
	DLabel:Dock( FILL ) -- Dock it
	DLabel:DockMargin( 5, 0, 0, 0 ) -- Move the text to the right a little
	DLabel:SetTextColor( Color( 0, 0, 0 ) ) -- Set text color to black
end

function PANEL:Init()
   self.cvrs = {}
   self:SetSize(ScrW() * 0.25,ScrH() * 0.25)
   self:Center()
   self:MakePopup()
   self:SetTitle("")
   for k,v in pairs(GM.NewGolosArgs) do
	self:addItem(v)
   end
   timer.Simple(30,function()
	if IsValid(self) then
		self:Remove()
	end
   end)
   self.Apply = vgui.Create("DButton",self)
   self.Apply:Dock(BOTTOM)
   self.Apply.DoClick = function()
	self:Remove()
   end
end 

function PANEL:OnRemove()
	net.Start("NewVote_Get")
	net.WriteTable(self.cvrs)
	net.SendToServer()
end

vgui.Register("NewVote",PANEL,"DFrame")]]