--[[
	if you wish to setup specific things for the gamemode ON THE CLIENT, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--

net.Receive("classinfo",function()
	local classtable = player_manager.GetPlayerClasses()[player_manager.GetPlayerClass(LocalPlayer())]
	LocalPlayer().plclass = classtable
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