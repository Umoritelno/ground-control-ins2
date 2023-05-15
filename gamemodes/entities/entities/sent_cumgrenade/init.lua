
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.AddNetworkString("cumshot")
util.PrecacheModel("models/props/cs_italy/orange.mdl")

// This is the spawn function. It's called when a client calls the entity to be spawned.
// If you want to make your SENT spawnable you need one of these functions to properly create the entity
//
// ply is the name of the player that is spawning it
// tr is the trace from the player's eyes 
//

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "sent_cumgrenade" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:SetPlayer(ply)
	self:SetPhysicsAttacker(ply)
	self:SetOwner(ply)
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/

local CumHitSounds = {"vo/k_lab/ba_guh.wav",
"ambient/voices/m_scream1.wav",
"vo/coast/odessa/male01/nlo_cubdeath01.wav",
"vo/npc/male01/answer20.wav",
"vo/npc/male01/answer39.wav",
"vo/npc/male01/fantastic01.wav",
"vo/npc/male01/goodgod.wav",
"vo/npc/male01/gordead_ans05.wav",
"vo/npc/male01/gordead_ans04.wav",
"vo/npc/male01/gordead_ans19.wav",
"vo/npc/male01/ohno.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pardonme01.wav",
"vo/npc/male01/stopitfm.wav",
"vo/npc/male01/uhoh.wav",
"vo/npc/male01/vanswer01.wav",
"vo/npc/male01/vanswer14.wav",
"vo/npc/male01/watchwhat.wav",
"vo/trainyard/male01/cit_hit01.wav",
"vo/trainyard/male01/cit_hit02.wav",
"vo/trainyard/male01/cit_hit03.wav",
"vo/trainyard/male01/cit_hit04.wav",
"vo/trainyard/male01/cit_hit05.wav"}

function ENT:Initialize()
	self:SetModel( "models/props/cs_italy/orange.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS ) 
	self:SetColor(self.color)
	self:SetMaterial("models/weapons/flare/shellside")
	self:SetGravity(.5)
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableDrag(true)
		phys:EnableCollisions(true)
		phys:SetMass(2)
	end	
end

local vec90 = Vector(0, 0, 90)
local vecMinus90 = Vector(0, 0, -90)

local tracedata = {}
local disgustChance = 33
local cumSplatSounds = ENT.cumSplatSounds

function ENT:explodeCum()
	local pos = self:GetPos()
	tracedata.start = pos
	tracedata.endpos = pos + vecMinus90
	--tracedata.filter = self
	
	local trace = util.TraceLine(tracedata)
	
	if trace.HitWorld then
		util.Decal("PaintSplatPink",trace.HitPos+trace.HitNormal,trace.HitPos-trace.HitNormal)
	end

	self:EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav",math.random(100,120),math.random(90,110))
	
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	util.Effect("Spermbomb", effectdata)
		
	for i=1,math.random(7,15) do
		local effectdata = EffectData()
		effectdata:SetOrigin( pos + Vector(0,0,20))
		effectdata:SetAngles( (VectorRand() * 10):Angle() )
		util.Effect( "Sementrail", effectdata )
	end
	
	for i=1,math.random(4,7) do
		tracedata.start = pos + vec90
		tracedata.endpos = pos + Vector(math.random(-150,150),math.random(-150,150),-90)
		local trace = util.TraceLine(tracedata)
		
		if trace.Hit then
			util.Decal("PaintSplatPink",trace.HitPos+trace.HitNormal,trace.HitPos-trace.HitNormal)
		end
	end
	
	local recipients = {}
	local own = self:GetOwner()
	local ownTeam
	
	if IsValid(own) then
		ownTeam = own:Team()
	end
	
	local trackTimes = 0
	
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 200 )) do
		if v:IsValid() and v:IsPlayer() and v:Alive() then
			recipients[#recipients + 1] = v
			
			if v:Team() ~= ownTeam then		
				trackTimes = trackTimes + 1
			end
			
			if math.random(1, 100) <= disgustChance and v ~= self.coomer then
				v:EmitSound(Sound(CumHitSounds[math.random(1, #CumHitSounds)]), 100, math.random(95,105))
			end
			
			local pos = v:GetPos()
			
			tracedata.start = pos + vec90
			tracedata.endpos = pos + vecMinus90
			
			local trace = util.TraceLine(tracedata)
			
			if trace.Hit then
				util.Decal("PaintSplatPink",trace.HitPos+trace.HitNormal,trace.HitPos-trace.HitNormal)
			end
		end
	end
	
	if ownTeam and trackTimes > 0 then
		GAMEMODE:trackRoundMVP(own, "cumsniper", trackTimes)
	end
	
	net.Start("cumshot")
		net.WriteInt(30, 32)
	net.Send(recipients)
	
	self:EmitSound(cumSplatSounds[math.random(1, #cumSplatSounds)], 100, math.random(80, 85))
	
	self:Remove()
	--self:Fire("kill",1,0.01)
end

function ENT:setCoomer(coomer)
	self.coomer = coomer
	self:SetPlayer(coomer)
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function ENT:Think()

	if self:WaterLevel() > 0 then
		self:explodeCum()
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect("Spermtrail", effectdata)
  
 end 


/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )

	self:explodeCum()
	
end