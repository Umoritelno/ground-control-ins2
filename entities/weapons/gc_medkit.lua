AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Medkit"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.DisableSprintViewSimulation = false
	SWEP.DrawTraditionalWorldModel = false
	
	SWEP.WM = "models/weapons/tfa_fas2/w_ifak.mdl"
	SWEP.WMPos = Vector(-4, 2.5, 3)
	SWEP.WMAng = Vector(30, 0, 180)
	
	SWEP.HUD_3D2DScale = 0.01
	SWEP.IconLetter = false
	
	SWEP.SelectIcon = surface.GetTextureID("ground_control/hud/status/medic")
end

CustomizableWeaponry:addFireSound("GC_MEDKIT_BANDAGE_RETRIEVE", "weapons/gc_ifak/bandage_retrieve.wav", 1, 55, CHAN_STATIC)
CustomizableWeaponry:addFireSound("GC_MEDKIT_BANDAGE_OPEN", "weapons/gc_ifak/bandage_open.wav", 1, 55, CHAN_STATIC)

CustomizableWeaponry:addFireSound("GC_MEDKIT_HEMOSTAT_RETRIEVE", "weapons/gc_ifak/hemostat_retrieve.wav", 1, 55, CHAN_STATIC)
CustomizableWeaponry:addFireSound("GC_MEDKIT_HEMOSTAT_CLOSE", "weapons/gc_ifak/hemostat_close.wav", 1, 55, CHAN_STATIC)

CustomizableWeaponry:addFireSound("GC_MEDKIT_EQUIP", "weapons/gc_ifak/equip_n.wav", 1, 55, CHAN_STATIC)

CustomizableWeaponry:addFireSound("GC_MEDKIT_OPEN", "weapons/gc_ifak/open_n.wav", 1, 60, CHAN_STATIC)

CustomizableWeaponry:addFireSound("GC_MEDKIT_BANDAGE_RIP", "weapons/gc_ifak/bandage_rip.wav", 1, 60, CHAN_STATIC)

SWEP.CanBackstab = false

SWEP.Animations = {
	use = "fire",
	draw = "deploy"
}

SWEP.Sounds = {
	fire = {
		{time = 0.2, sound = "GC_MEDKIT_BANDAGE_RETRIEVE"},
		{time = 1.1, sound = "GC_MEDKIT_BANDAGE_OPEN"},
		{time = 2.45, sound = "GC_MEDKIT_BANDAGE_RIP"},
	},
	deploy = {
		{time = 0, sound = "GC_MEDKIT_EQUIP"},
		{time = 0.1, sound = "GC_MEDKIT_OPEN"},
	}
}

SWEP.NormalHoldType = "slam"
SWEP.RunHoldType = "normal"

SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.Base = "cw_melee_base"
SWEP.Category = "CW 2.0"

SWEP.selectSortWeight = 5
SWEP.UseHands = true

SWEP.Author			= "hamburger fan 228"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false
SWEP.ViewModel = "models/weapons/tfa_fas2/c_ifak.mdl"
SWEP.WorldModel = "models/weapons/tfa_fas2/w_ifak.mdl"

SWEP.isKnife = false
SWEP.isMedkit = true
SWEP.dropsDisabled = true
SWEP.Sprinting = false
SWEP.SprintingEnabled = false
SWEP.SprintPos = Vector(0, 0, 2)
SWEP.SprintAng = Vector(-15, 0, 0)

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= ""

SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo			= ""

SWEP.HolsterTime = 0.4
SWEP.DeployTime = 0.6
SWEP.interactDelay = 0.5

SWEP.animSpeed = 1
SWEP.healDuration = 3.2 / SWEP.animSpeed -- how much time to heal someone?
SWEP.healRange = 45
SWEP.healCancelCutoff = 1.15 -- velocity > walkSpeed * this = cancel heal
SWEP.healDistCancel = 90 -- ranger greater than this? heal cancels

SWEP.HealAmountsFriend = { -- index = amount of times healed + 1, value = health to heal
	regular = {10, 7, 3},
	medic = { -- key is medic trait level, value is heal data
		{10, 7, 5, 3}, -- 25
		{11, 9, 6, 4}, -- 30
		{14, 10, 7, 4}, -- 35
		{14, 12, 7, 5}, -- 38
		{15, 12, 8, 5} -- 40
	}
}

SWEP.HealAmountsSelf = { -- same but when healing self
	regular = {5, 3, 2}, -- 10
	medic = {
		{6, 4, 2}, -- 12
		{7, 5, 2}, -- 14
		{8, 5, 3}, -- 16
		{9, 6, 3}, -- 18
		{9, 6, 5}, -- 20
	}
}

if CLIENT then
	SWEP.cb_onHealingChanged = function(ent, name, old, new)		
		if IsValid(LocalPlayer()) and LocalPlayer():GetActiveWeapon() == ent then
			if not new then
				ent:stopHeal()
				ent:updateBGs()
			end
		end
	end
end

function SWEP:SetupDataTables()
	self:DTVar("Int", 0, "State")
	self:DTVar("Int", 1, "Shots")
	self:DTVar("Float", 0, "HolsterDelay")
	self:DTVar("Bool", 0, "Suppressed")
	self:DTVar("Bool", 1, "Safe")
	self:DTVar("Bool", 2, "BipodDeployed")
	self:DTVar("Bool", 3, "M203Active")
	self:DTVar("Angle", 0, "ViewOffset")
	
	self:DTVar("Bool", 4, "Healing")
	self:DTVar("Float", 2, "HealTime")
	self:DTVar("Entity", 0, "HealTarget")
	
	if CLIENT then
		self:NetworkVarNotify("Healing", self.cb_onHealingChanged)
	end
end

function SWEP:SetHealing(state)
	self.dt.Healing = state
end

function SWEP:SetHealTime(time)
	self.dt.HealTime = time
end

function SWEP:SetHealTarget(tgt)
	self.dt.HealTarget = tgt
end

function SWEP:Initialize()
	self.BaseClass.Initialize(self)
	
	self.dt.Healing = false
	self.dt.HealTime = 0
	self.dt.HealTarget = NULL
	
	if CLIENT and self.Owner == LocalPlayer() then
		self:updateBGs()
	end
end

function SWEP:OnRemove()
	self.BaseClass.OnRemove(self)
	
	if self.dt.Healing then
		self:stopHeal()
	end
end

local SP = game.SinglePlayer()

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
		
	if CLIENT and self.Owner == LocalPlayer() then
		self:updateBGs()
	end
end

function SWEP:Holster(wep)	
	if self.dt.Healing then
		return false
	end
	
	if CLIENT and self.Owner == LocalPlayer() then
		self:updateBGs()
	end
	
	if self.BaseClass.Holster(self, wep) then
		self:stopHeal()
		return true
	end
end

function SWEP:IndividualThink()
	if self.dt.Healing then		
		if not IsValid(self.dt.HealTarget) or not self:getReachableHealTarget() or not self:getCanHealTarget(self.dt.HealTarget) or self.Owner:GetPos():Distance(self.dt.HealTarget:GetPos()) > self.healDistCancel then
			self:stopHeal()
		else
			if CurTime() > self.dt.HealTime then
				self:finishHeal()
			end
		end
		
		if IsFirstTimePredicted() and self.dt.Healing and self:getLastPlayedAnim() ~= self.Animations.use then -- edge cases
			self:sendWeaponAnim("use", 1, 0)
		end
	else
		if IsFirstTimePredicted() and self:getLastPlayedAnim() ~= self.Animations.draw then -- edge cases
			self:sendWeaponAnim("draw", 1, 0)
		end
	end
end

function SWEP:getHealProgression(target)
	local baseTable = target == self.Owner and self.HealAmountsSelf or self.HealAmountsFriend
	
	if self.Owner:hasStatusEffect("medic") then
		local traitLev = self.Owner:getTraitLevel("medic")
		return baseTable.medic[traitLev]
	end
	
	return baseTable.regular
end

function SWEP:getHealAmount(target)
	local healAmts = self:getHealProgression(target)
	
	return math.min(math.abs(target:Health() - target:GetMaxHealth()), healAmts[math.min(#healAmts, math.max(1, target:getHealGrade() + 1))])
end

function SWEP:beginHeal(target)	
	if IsFirstTimePredicted() then
		self:sendWeaponAnim("use", self.animSpeed, 0)
		-- todo: proepr animes
		--self:sendWeaponAnim("draw", self.DrawSpeed)
	end
	
	self.dt.Healing = true
	self.dt.HealTarget = target
	self.dt.HealTime = CurTime() + self.healDuration
	
	if SERVER then
		self.dt.HealTarget.healing = true
		self.Owner:SetActivity(ACT_GMOD_GESTURE_ITEM_GIVE)
	end
end

function SWEP:stopHeal()
	if IsFirstTimePredicted() then
		self:sendWeaponAnim("draw", 1, 0)
		
		if CLIENT then
			self:updateBGs()
		end
	end
	
	self:delayUse()
	
	if SERVER and self.dt.HealTarget then
		self.dt.HealTarget.healing = false
	end
	
	self.dt.Healing = false
	self.dt.HealTarget = NULL
	self.dt.HealTime = 0
end

function SWEP:delayUse()
	self:SetNextPrimaryFire(CurTime() + self.interactDelay)
	self:SetNextSecondaryFire(CurTime() + self.interactDelay)
end

function SWEP:updateBGs()
	if self.Owner.bandages > 3 then
		self.CW_VM:SetBodygroup(1, 0)
	elseif self.Owner.bandages > 0 then
		self.CW_VM:SetBodygroup(1, 1)
	else
		self.CW_VM:SetBodygroup(1, 2)
	end
end

function SWEP:finishHeal()
	local healTarget = self.dt.HealTarget
	
	if SERVER and IsValid(healTarget) then
		local healAmount = self:getHealAmount(healTarget)
		
		if healTarget:Health() < healTarget:GetMaxHealth() then
			healTarget:SetHealth(healTarget:Health() + healAmount)
			healTarget:setHealGrade(healTarget:getHealGrade() + 1)
			
			if healTarget ~= self.Owner then
				self.Owner:addCurrency(GAMEMODE.CashPerHeal, GAMEMODE.ExpPerHeal, "TEAMMATE_HEALED", self.Owner)
				GAMEMODE:trackRoundMVP(self.Owner, "medkitfan", 1)
			end
		end
		
		healTarget:setBleeding(false)
		healTarget.healing = false
		
		if self.Owner.canUncrippleLimbs and healTarget:uncrippleArm() and healTarget ~= self.Owner then
			self.Owner:addCurrency(GAMEMODE.CashPerUncripple, GAMEMODE.ExpPerUncripple, "TEAMMATE_UNCRIPPLED")
		end
		
		healTarget:changeSustainedArmDamage(-healAmount)
		
		self.Owner:useBandage()
		self.Owner:sendBandages()
		self.Owner:setWeight(self.Owner:calculateWeight())
	end
	
	if IsFirstTimePredicted() then
		if CLIENT then
			self:updateBGs()
		end
		
		self:sendWeaponAnim("draw", 1, 0)
	end
	
	self.dt.Healing = false
	self.dt.HealTarget = NULL
	self.dt.HealTime = 0
	
	self:delayUse()
end

local tr = {}

function SWEP:getHealTrace(startpos, endpos)	
	tr.start = startpos
	tr.endpos = endpos
	tr.filter = self.Owner
	tr.mask = self.NormalTraceMask
	
	local trace = util.TraceLine(tr)
	
	return trace
end

-- returns whether the heal target is reachable by us
function SWEP:getReachableHealTarget()
	local trace = self:getHealTrace(self.Owner:EyePos(), self.dt.HealTarget:EyePos())
	
	-- if we don't hit anything means we can get to our heal target
	-- if we do hit the heal target means the trace hit his hitbox
	return not IsValid(trace.Entity) or trace.Entity == self.dt.HealTarget
end

function SWEP:getHealTarget()
	local eyePos = self.Owner:EyePos()
	local aimVec = self.Owner:GetAimVector()
	local trace = self:getHealTrace(eyePos, eyePos + aimVec * self.healRange)
	
	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:Team() == self.Owner:Team() then
		return trace.Entity
	end
	
	return nil
end

function SWEP:getCanHealTarget(target)
	--print(self.Owner:GetVelocity():Length(), self.Owner:GetWalkSpeed() * self.healCancelCutoff)
	if not self.Owner:OnGround() or self.Owner:GetVelocity():Length() > self.Owner:GetWalkSpeed() * self.healCancelCutoff or target:GetVelocity():Length() > target:GetWalkSpeed() * self.healCancelCutoff then
		return false
	end
		
	return self.Owner.bandages > 0 and (target:Alive() and (target:Health() < target:GetMaxHealth() and target:getHealGrade() < #self:getHealProgression(target)) or (target.bleeding or target:hasStatusEffect("bleeding") or target:hasStatusEffect("crippled_arm")))
end

function SWEP:PrimaryAttack()
	-- todo: heal target
	if not self.dt.Healing then
		local healTarget = self:getHealTarget()
		
		if healTarget and self:getCanHealTarget(healTarget) then
			self:beginHeal(healTarget)
			self:delayUse()
		end
	end
end

function SWEP:SecondaryAttack()	
	if not self.dt.Healing and self:getCanHealTarget(self.Owner) then
		self:beginHeal(self.Owner)
		self:delayUse()
	end
end

if CLIENT then
	local grey = Color(125, 125, 125, 255)
	local gradient = surface.GetTextureID("cw2/gui/gradient")
	
	function SWEP:getHealText(target)
		if IsValid(target) and self:getCanHealTarget(target) then
			if self.Owner.bandages <= 0 then
				return "No bandages", self.HUDColors.red
			end
		
			local health, maxHealth = target:Health(), target:GetMaxHealth()
			
			if target == self.Owner then				
				if health < maxHealth then
					return "Heal self +" .. self:getHealAmount(target) .. "HP", self.HUDColors.white
				elseif self.Owner.bleeding then
					return "Bandage self", self.HUDColors.white
				elseif self.Owner:hasStatusEffect("crippled_arm") and self.Owner:hasStatusEffect("medic") and GAMEMODE.cripplingEnabled then
					return "Uncripple self", self.HUDColors.white
				end
			else
				if health < maxHealth then
					return "Heal ally +" .. self:getHealAmount(target) .. "% HP (" .. math.min(GAMEMODE.MaxHealth, target:Health()) .. "% HP)", self.HUDColors.white
				elseif target:hasStatusEffect("bleeding") then
					return "Bandage ally (" .. math.min(GAMEMODE.MaxHealth, target:Health()) .. "% HP)", self.HUDColors.white
				elseif target:hasStatusEffect("crippled_arm") and self.Owner:hasStatusEffect("medic") and GAMEMODE.cripplingEnabled then
					return "Uncripple ally (" .. math.min(GAMEMODE.MaxHealth, target:Health()) .. "% HP)", self.HUDColors.white
				end
			end
		end
		
		return self:getBaseHealText(target), grey
	end
	
	function SWEP:getBaseHealText(target)
		if target == self.Owner then
			return "Heal self"
		end
		
		return "Heal ally"
	end
	
	function SWEP:draw3D2DHUD()
		local aimVec = self.Owner:GetAimVector()
		
		local modelPos = self.CW_VM:GetPos()
		local modelAng = self.CW_VM:GetAngles()
		local forwardAng = modelAng * 1
		
		modelAng:RotateAroundAxis(modelAng:Right(), 90)
		modelAng:RotateAroundAxis(modelAng:Up(), -80)
				
		cam.Start3D2D(modelPos + modelAng:Up() * -20 + modelAng:Right() * -1.5 + modelAng:Forward() * -3, modelAng, self.HUD_3D2DScale)
			cam.IgnoreZ(true)
				surface.SetDrawColor(20, 21, 21, 240)
				surface.SetTexture(gradient)
				surface.DrawTexturedRect(-600, 100, 400, 82 * 1.5)
				
				if self.dt.Healing then
					local lp = LocalPlayer()
					local selfHeal = lp == self.dt.HealTarget
					draw.ShadowText("Healing " .. (selfHeal and "self" or self.dt.HealTarget:Nick()) .. " - " .. math.Round((1 - math.min(1, (self.dt.HealTime - CurTime()) / self.healDuration)) * 100, 0) .. "%", "CW_HUD48", -590, 135, self.HUDColors.green, self.HUDColors.black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					
					
					draw.ShadowText(selfHeal and "Don't run"  or "Don't run & close to heal target", "CW_HUD60", -590, 180, self.HUDColors.white, self.HUDColors.black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					local healTarget = self:getHealTarget()
					
					local healText, healColor = self:getHealText(healTarget)
					local selfHealText, selfHealColor = self:getHealText(self.Owner)
					
					draw.ShadowText("[LMB] " .. healText, "CW_HUD60", -590, 135, healColor, self.HUDColors.black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					
					draw.ShadowText("[RMB] " .. selfHealText, "CW_HUD48", -590, 190, selfHealColor, self.HUDColors.black, 2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			cam.IgnoreZ(false)
		cam.End3D2D()
	end
end