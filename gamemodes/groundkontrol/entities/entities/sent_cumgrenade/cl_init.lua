
include('shared.lua')

local matFlak = Material( "sprites/gunsmoke" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
end


/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()
	
	self.Entity:DrawModel()
	
end