--[[
	if you wish to setup specific things for the gamemode ON THE CLIENT, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--
local blur = Material("pp/blurscreen")
local plr = FindMetaTable("Player")

function plr:ShowRole(desc)
    if text then
		if timer.Exists("RolePanelRemove") then
			timer.Remove("RolePanelRemove")
		end
		text:Remove()
		text = nil
	end

	local text = vgui.Create("RichText")
	text:SetPos(ScrW() * 0.325,ScrH() * 0.1)
	text:SetSize(ScrW() * 0.25,ScrH() * 0.15)
	--text:Dock(FILL)
	text:AppendText(desc)
	text:InsertColorChange(0,0,0,255)
	text:SetVerticalScrollbarEnabled(false)
    function text:Paint(w,h)
		surface.SetDrawColor(255,255,255)
		surface.SetMaterial(blur)
		blur:SetFloat("$blur",5)
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(0,0,w,h) -- hehe
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,125))
	end

	function text:PerformLayout()
		--self:SetBGColor(Color(0, 0, 255))
		self:SetFGColor(Color(255, 255, 255))
		self:SetFontInternal( "DermaLarge" )
	end
	timer.Create("RolePanelRemove",15,1,function()
		if text:IsValid() then
			text:Remove()
			text = nil 
		end
	end)
end 


net.Receive("classinfo",function()
	local classtable = player_manager.GetPlayerClasses()[player_manager.GetPlayerClass(LocalPlayer())]
	LocalPlayer().plclass = classtable
	LocalPlayer():ShowRole(classtable.Desc)
end)

hook.Add("TFA_InspectVGUI_Start", "Kill TFA customization", function()
    return CurTime() < GAMEMODE.PreparationTime
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