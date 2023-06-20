AddCSLuaFile()

local pl = FindMetaTable("Player")

--local oldfunc = pl:NVGBASE_ToggleGoggleAnim

function pl:NVGBASE_ToggleGoggle(loadout,silent,force) 
	local toggled = self:NVGBASE_IsGoggleActive();
	if (!self:Alive() or !GAMEMODE.NVGEnabled) and !toggled then return end

	-- Failsafe if the goggle has changed to one that we don't have access to. A good example
	-- of this would be a gamemode where player model whitelisting is on and the player has
	-- switched teams mid game. The new model or team might not have access to the last goggle he used.
	if (_G:NVGBASE_IsWhitelistOn() && !toggled && !self:NVGBASE_IsWhitelisted(loadout, self:GetNWInt("NVGBASE_CURRENT_GOGGLE", 1))) then
		self:NVGBASE_SwitchToNextGoggle(loadout);
	end

	if (force != nil) then
		self:ConCommand("NVGBASE_TOGGLE " .. force);
		self:SetNWFloat("NVGBASE_NEXT_TOGGLE", CurTime() + loadout.Settings.Transition.Switch);
	else
		self:ConCommand("NVGBASE_TOGGLE " .. (!toggled && 1 || 0));
		self:SetNWFloat("NVGBASE_NEXT_TOGGLE", CurTime() + loadout.Settings.Transition.Switch);
	end

	local goggle = self:NVGBASE_GetGoggle();
	if (!silent && goggle.Sounds != nil) then
		if (!toggled) then if (goggle.Sounds.ToggleOn != nil) then self:EmitSound(goggle.Sounds.ToggleOn, 75, 100, 1, CHAN_ITEM); end
		else if (goggle.Sounds.ToggleOff != nil) then self:EmitSound(goggle.Sounds.ToggleOff, 75, 100, 1, CHAN_ITEM); end end
	end
end 

--[[local GC_NVG = {}
GC_NVG.Settings = {
    Gestures = {
		On = ACT_ARM,
		Off = ACT_DISARM
	},

	BodyGroups = {
		Group = 1,
		Values = {
			On = 1,
			Off = 0
		}
	},

	Overlays = {
		Goggle = Material("vgui/splinter_cell/overlay_vignette"),
		Transition = Material("vgui/splinter_cell/nvg_turnon_static")
	},

	Transition = {
		Rate = 5,
		Delay = 0.225,
		Switch = 0.5,
		Sound = "splinter_cell/goggles/standard/goggles_mode.wav"
	},

	RemoveOnDeath = true

}
GC_NVG[1] = {
    Name = "Night",
	Whitelist = {
		"models/splinter_cell_3/player/sam_a.mdl",
		"models/splinter_cell_3/player/sam_b.mdl",
		"models/splinter_cell_3/player/sam_c.mdl",
		"models/splinter_cell_3/player/sam_d.mdl",

		"models/splinter_cell_4/player/sam_a.mdl", -- Yes it was stolen from splinter cell addon
		"models/splinter_cell_4/player/sam_b.mdl",
		"models/splinter_cell_4/player/sam_c.mdl",

		"models/splinter_cell_3/player/coop_agent_one.mdl",
		"models/splinter_cell_3/player/coop_agent_one_urban.mdl",
		"models/splinter_cell_4/player/coop_agent_one_arctic.mdl",
		"models/splinter_cell_3/player/coop_agent_two.mdl",
		"models/splinter_cell_3/player/coop_agent_two_urban.mdl",
		"models/splinter_cell_4/player/coop_agent_two_arctic.mdl"
	},

	MaterialOverlay   = Material("vgui/splinter_cell/nvg_anim"),
	OverlayFirst      = false,

	MaterialInterlace = Material("vgui/splinter_cell/noise"),
	InterlaceColor    = Color(155, 155, 155, 32),

	MaterialOverride  = nil,
	Filter = function(ent)
		return;
	end,

	Sounds = {
		Loop      = nil,
		ToggleOn  = "splinter_cell/goggles/standard/goggles_toggle.wav",
		ToggleOff = "splinter_cell/goggles/standard/goggles_toggle.wav",
		Activate  = "splinter_cell/goggles/standard/goggles_activate.wav"
	},

	Lighting = {
		Color      = Color(25, 25, 25),
		Min        = 0,
		Style      = 0,
		Brightness = 1,
		Size       = 200,
		Decay      = 200,
		DieTime    = 0.05
	},

	ProjectedTexture = {
		FOV        = 140,
		VFOV       = 100, -- Vertical FOV
		Brightness = 2,
		Distance   = 2500
	},

	PhotoSensitive = 0.9,

	ColorCorrection = {
		ColorAdd   = Color(0.2, 0.4, 0.05),
		ColorMul   = Color(0, 0, 0),
		ColorMod   = 0.25,
		Contrast   = 1,
		Brightness = 0.05
	},

	PostProcess = function(self)
		DrawBloom(0.65, 3.1, 1.75, 0.45, 2, 1, 155 / 255, 155 / 255, 155 / 255);
		DrawBloom(0.1, 2, 0.5, 0.25, 1, 0.6, 130 / 255, 135 / 255, 35 / 255);
	end
}

NVGBASE.Register("Ground Control", GC_NVG);]]