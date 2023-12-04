AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Fists"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.DisableSprintViewSimulation = false
	
	SWEP.DrawTraditionalWorldModel = false
	SWEP.WM = "models/weapons/c_arms.mdl"
	SWEP.WMPos = Vector(0.25, -1, 1.25)
	SWEP.WMAng = Vector(-10, 90, 180)
	
	SWEP.IconLetter = ""
end

SWEP.CanBackstab = false

SWEP.Animations = {
	slash_primary = "fists_left",
	slash_secondary = "fists_right",
	draw = "fists_draw"
}

SWEP.Sounds = {
	fists_left = {{time = 0.1, sound = "WeaponFrag.Throw"}},
	fists_right = {{time = 0.1, sound = "WeaponFrag.Throw"}}
}

SWEP.NormalHoldType = "fist"
SWEP.RunHoldType = "normal"

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Base = "cw_melee_base"
SWEP.Category = "CW 2.0"

SWEP.UseHands = true
SWEP.selectSortWeight = GAMEMODE.CurWepBase != "tfa" and 4 or 5

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = "models/weapons/c_arms.mdl"

SWEP.DrawSpeed = 1.5
SWEP.isKnife = true
SWEP.dropsDisabled = true
SWEP.Sprinting = false
SWEP.SprintingEnabled = false
SWEP.SprintPos = Vector(0, 0, 2)
SWEP.SprintAng = Vector(-15, 0, 0)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= ""

SWEP.PrimaryAttackDelay = 0.4
SWEP.SecondaryAttackDelay = 0.4
SWEP.disarmChance = {27, 54, 14, 88, 9, 11, 13, 65, 20, 69, 4} -- даб даб даб да я

SWEP.PrimaryAttackDamage = {15, 25}
SWEP.SecondaryAttackDamage = {15, 25}
SWEP.BackstabDamageMultiplier = 3

SWEP.PrimaryAttackRange = 50

SWEP.HolsterTime = 0.4
SWEP.DeployTime = 0.6

SWEP.PrimaryAttackImpactTime = 0.1
SWEP.PrimaryAttackDamageWindow = 0.1

SWEP.SecondaryAttackImpactTime = 0.1
SWEP.SecondaryAttackDamageWindow = 0.1

SWEP.PrimaryHitAABB = {
	Vector( -10, -10, -8 ),
	Vector( 10, 10, 8 )
}

SWEP.PlayerHitSounds = {"Flesh.ImpactHard"}
SWEP.MiscHitSounds = {"Flesh.ImpactHard"}

function SWEP:getDealtDamage(ent)
	local dmg = type(self.attackDamage) == "table" and math.random(self.attackDamage[1], self.attackDamage[2]) or self.attackDamage
	
	if ent:IsPlayer() and self:isBackstab(ent) then
		dmg = dmg * self.BackstabDamageMultiplier
	end

	local velocity = self.Owner:GetVelocity()
	dmg = dmg + velocity:Length() / self.VelocityToDamageDivider
	
	return dmg
end

local SP = game.SinglePlayer()
local traceData = {}

local bullet = {}
bullet.Damage = 0
bullet.Force = 0
bullet.Tracer = 0
bullet.Num = 1
bullet.Spread = Vector(0, 0, 0)

local noNormal = Vector(1, 1, 1)

function SWEP:IndividualThink()
	if (SP and SERVER) or IsFirstTimePredicted() then
		local ct = CurTime()
		
		if self.attackDamageTime and ct > self.attackDamageTime and ct < self.attackDamageTime + self.attackDamageTimeWindow then
			self.Owner:LagCompensation(true)
				local eyeAngles = self.Owner:EyeAngles()
				local forward = eyeAngles:Forward()
				traceData.start = self.Owner:GetShootPos()
				traceData.endpos = traceData.start + forward * self.attackRange
				
				traceData.mins = self.attackAABB[1]:Rotate(eyeAngles)
				traceData.maxs = self.attackAABB[2]:Rotate(eyeAngles)
				
				traceData.filter = self.Owner
				
				local trace = util.TraceHull(traceData)
			self.Owner:LagCompensation(false)
			
			if trace.Hit then
				local ent = trace.Entity
				
				if IsValid(ent) then
					local sounds = nil
					
					if ent:IsPlayer() then
						sounds = self.PlayerHitSounds
						-- self:createBloodEffect(ent, trace)
					elseif ent:IsNPC() then
						sounds = self.NPCHitSounds[ent:GetClass()] or self.PlayerHitSounds
						-- self:createBloodEffect(ent, trace)
					else
						bullet.Src = traceData.start
						bullet.Dir = forward
						
						self.Owner:FireBullets(bullet)
						
						if SERVER then
							local phys = ent:GetPhysicsObject()
							
							if phys and phys:IsValid() then
								phys:AddVelocity(forward * self.PushVelocity)
							end
						end
					end
					
					if SERVER then
						local forceDir = noNormal
						local forceMultiplier = 0
						
						if not ent:IsPlayer() and not ent:IsNPC() then
							forceDir = trace.HitNormal
						end
						
						local damageInfo = DamageInfo()
						damageInfo:SetDamage(self:getDealtDamage(ent))
						damageInfo:SetAttacker(self.Owner)
						damageInfo:SetInflictor(self)
						damageInfo:SetDamageForce(forward * self.DamageForce * forceDir)
						damageInfo:SetDamagePosition(trace.HitPos)
						
						ent:TakeDamageInfo(damageInfo)
						
						if ent:IsPlayer() then
							local activeWeapon = ent:GetActiveWeapon()
							
							if not activeWeapon or (activeWeapon and not activeWeapon.dropsDisabled and not activeWeapon.isKnife) then
								local lol = self.disarmChance[math.random(1, #self.disarmChance)]
								
								if math.random(1, 100) <= lol then
									ent:dropWeaponNicely(nil, VectorRand() * 20, VectorRand() * 200)
									
									GAMEMODE:trackRoundMVP(self.Owner, "cqcenjoyer", 1)
								end
							end
						end
					end
					
					sounds = sounds or self.MiscHitSounds
					self:emitSoundFromList(sounds)
				else
					self:emitSoundFromList(self.MiscHitSounds)
				end
				
				self.attackDamageTime = nil
			end
		end
	end
end