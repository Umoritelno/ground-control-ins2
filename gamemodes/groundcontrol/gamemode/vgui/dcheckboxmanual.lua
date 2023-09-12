local PANEL = {}

function PANEL:SetChecked( bOn )

	if ( self.State == bOn ) then return end
	self.State = bOn

end

function PANEL:GetChecked()

	return self.State

end

function PANEL:Set( bOn )

	self:SetChecked( bOn )

end

function PANEL:DoClick()

	self:SetChecked( !self.State )

end

function PANEL:SizeToContents()

	self:InvalidateLayout()

end

function PANEL:Paint()
end

function PANEL:PerformLayout()
end

function PANEL:Init()
    self:SetText("")
end

vgui.Register( "ManualCheckBox", PANEL, "Button" )