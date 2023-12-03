ENT.color = Color(230, 230, 230, 255)

ENT.Type 			= "anim"
ENT.PrintName		= "Cum Bomb"
ENT.Author			= "Rambo_6"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.cumSplatSounds = {
	"weapons/cumtown_bukkake/hotcum1.wav",
	"weapons/cumtown_bukkake/hotcum2.wav"
}

for key, snd in ipairs(ENT.cumSplatSounds) do
	util.PrecacheSound(snd)
end