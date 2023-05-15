// Variables that are used on both client and server

SWEP.NormalHoldtype = "passive"

SWEP.PrintName			= "Bukkake Blaster"
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true

SWEP.Author			= "Rambo_6"
SWEP.Contact		= ""
SWEP.Purpose		= "I'M GONNA..."
SWEP.Instructions	= "Left click to cum on something. Right click to launch a jizzbomb."

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true		// Spawnable in singleplayer or by server admins

SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= ""

SWEP.Slot = 4
SWEP.SlotPos = 0

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "cum"
SWEP.Primary.Delay          = 0.8

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.CumCooldown = 0.8
SWEP.CumBombCoolDown = 10
SWEP.CumDistance = 800

SWEP.DisgustChance = 25 -- chance that a person will be disgusted when cummed on

SWEP.healCumLittle = 1 -- how much hp we regain for cooming with left mouse
SWEP.healCumBig = 4 -- right mouse heal
SWEP.holsterTime = 0
SWEP.dropsDisabled = true
SWEP.selectSortWeight = 6

local ShootSound = Sound( "vo/ravenholm/engage03.wav" )

local HitSounds = {"vo/k_lab/ba_guh.wav",
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

sound.Add({
	name = "bukkake_hotcum",
	sound = {
		"weapons/cumtown_bukkake/hotcum1.wav",
		"weapons/cumtown_bukkake/hotcum2.wav"
	},
	channel = CHAN_AUTO,
	volume = 1,
	level = 80,
	pitchstart = 95,
	pitchend = 105
})

-- precache the sound
Sound("weapons/cumtown_bukkake/bouttablow.wav")

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Cumball")
	
	if SERVER then
		self:SetCumball(self.CumBombCoolDown)
	end
end

function SWEP:Initialize()
	self.holsterTime = 0
	self.blowNotification = 0
end

function SWEP:Holster()
	self.holsterTime = CurTime() -- track when we holstered this swep
	return true
end

function SWEP:Deploy()
	-- compensate for that time by getting the delta
	local dt = CurTime() - self.holsterTime
	
	self:SetCumball(math.min(self.CumBombCoolDown, self:GetCumball() + dt))
	self.Owner:DrawViewModel(false)
	
	return true
end

function SWEP:Reload()
end

function SWEP:Think()	
	local cBall = self:GetCumball()
	
	if cBall <= self.CumBombCoolDown then
		self:SetCumball(math.min(self.CumBombCoolDown, cBall + FrameTime()))
				
		if CLIENT and IsFirstTimePredicted() then
			local thisBall = self:GetCumball()
						
			if thisBall >= self.CumBombCoolDown and self.blowNotification < self.CumBombCoolDown then
				surface.PlaySound("weapons/cumtown_bukkake/bouttablow.wav")
			end
			
			self.blowNotification = thisBall
		end
	end
end


/*---------------------------------------------------------
	PrimaryAttack
---------------------------------------------------------*/

-- helper method to write uncompressed vector values
local function _writePreciseVector(vec)
	net.WriteFloat(vec.x)
	net.WriteFloat(vec.y)
	net.WriteFloat(vec.z)
end

local function _readPreciseVector()
	local x = net.ReadFloat()
	local y = net.ReadFloat()
	local z = net.ReadFloat()
	
	return x, y, z
end

SWEP.traceStruct = {}

function SWEP:PrimaryAttack()
	local ct = CurTime()
	
	self:SetNextPrimaryFire(ct + self.CumCooldown)
	self:SetNextSecondaryFire(ct + self.CumCooldown)
	
	if not IsFirstTimePredicted() then
		return
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin( (self.Owner:GetPos() + Vector(0,0,23)) + (self.Owner:GetForward() * 5))
		effectdata:SetNormal( self.Owner:GetPos():GetNormal() )
		effectdata:SetAngles( self.Owner:GetAngles() )
	util.Effect( "Sementrail", effectdata )
	
	local trace = self.traceStruct
	trace.start = self.Owner:GetShootPos()
	local angForward = self.Owner:EyeAngles():Forward()
	trace.endpos = trace.start + angForward * self.CumDistance
	trace.filter = self.Owner
	local tr = util.TraceLine(trace)
	
	if tr.Hit then
		local decStart, decEnd = tr.HitPos - angForward * 10, tr.HitPos + angForward	
		local finalString
		
		if tr.HitNonWorld then
			if CLIENT then
				util.Decal("PaintSplatPink", decStart, decEnd) -- BIG cum
				sound.Play("bukkake_hotcum", tr.HitPos)
			else
				finalString = "PaintSplatPink"
			end
			
			if tr.Entity:IsPlayer() then
				if SERVER then
					net.Start("cumshot")
						net.WriteInt(4, 32)
					net.Send(tr.Entity)
					
					if self.Owner:Team() ~= tr.Entity:Team() then
						GAMEMODE:trackRoundMVP(self.Owner, "cumsniper", 1)
					end
				end
				
				if math.random(1, 100) <= self.DisgustChance then
					tr.Entity:EmitSound(Sound(HitSounds[math.random(1,table.Count(HitSounds))]),100,math.random(95,105))
				end
			end
		else
			if CLIENT then
				util.Decal("BirdPoop", decStart, decEnd) -- small cum...
				sound.Play("bukkake_hotcum", tr.HitPos)
			else
				finalString = "BirdPoop"
			end
		end
		
		if SERVER then
			GAMEMODE:trackRoundMVP(self.Owner, "coomer", 1)
			
			local filter = RecipientFilter()
			filter:AddPVS(trace.start)
			
			net.Start("cumshot_visual")
				net.WriteEntity(self)
				_writePreciseVector(decStart)
				_writePreciseVector(decEnd)
				net.WriteString(finalString)
			net.Send(filter)
		end
	end
	
	self:EmitSound( ShootSound, 70, math.random(100,110) )
	
	if SERVER then
		self.Owner:SetHealth(math.min(self.Owner:GetMaxHealth(), self.Owner:Health() + self.healCumLittle))
	end
end

if CLIENT then
	function SWEP.handleVisualCumshot(msg)
		local ent = net.ReadEntity()
		
		if not IsValid(ent) or ent == LocalPlayer() then
			return
		end
		
		local decStart = Vector(_readPreciseVector())
		local decEnd = Vector(_readPreciseVector())
		local decalName = net.ReadString()
		
		sound.Play("bukkake_hotcum", decEnd)
		util.Decal(decalName, decStart, decEnd)
	end
	
	net.Receive("cumshot_visual", SWEP.handleVisualCumshot)
end

/*---------------------------------------------------------
	SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()	
	if self:GetCumball() < self.CumBombCoolDown then
		return
	end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetCumball(0)
	self:EmitSound(ShootSound, 100, math.random(50, 70))
	
	if SERVER then
		GAMEMODE:trackRoundMVP(self.Owner, "coomer", 1)
		
		local cg = ents.Create( "sent_cumgrenade" )
		if ( !cg:IsValid() ) then return end
		cg:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 7 )
		cg:SetAngles(self.Owner:GetAngles())
		cg:setCoomer(self.Owner)
		cg:Spawn()
		cg:Initialize()
		cg:Activate()
		
		local phys = cg:GetPhysicsObject()
		if !phys:IsValid() or (phys == nil) then return end
		
		phys:SetVelocity( self.Owner:GetAimVector() * 5000 )
		
		self.Owner:SetHealth(math.min(self.Owner:GetMaxHealth(), self.Owner:Health() + self.healCumBig))
	end
end
