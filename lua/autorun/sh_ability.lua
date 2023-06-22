print("Shared loaded!")
AddCSLuaFile("includes/circles.lua") -- add squid module(thx)
abilities = {}
nets = {}
debugtable = {
    "BerserkKD",
    "SkanDeath",
    "doorblockdeath",
    "DisquiseKD",
    "AbilityCD",
    "SilentStepTimer",
    "AbilityUse",
}

function AddSkill(data) 
    local name = data.name 
    data.id = table.Count(abilities) + 1
    abilities[table.Count(abilities) + 1] = data 
    if SERVER then
        for key,nt in pairs(data.nets) do
            util.AddNetworkString(nt)
        end
    end
 end 
 
 AddSkill(
     {   name = "Skan",
         icon = "skan/Skan.png",
         description = "Вы сканируете область вокруг вас на наличие живых целей",
         cooldown = 35,
         usetime = 10,
         nets = {"SkanAbility",
                  "SkanDeath"},
         use = function(ply)
             net.Start("SkanAbility")
             net.Send(ply)
         end,
         death = function(ply,bool)
            net.Start("SkanDeath")
            net.Send(ply)
         end,
         customUse = false,
         UsesCount = 3,
     }
 )

--[[AddSkill(
     {   name = "SpeedBoost",
         icon = "speedboost/SpeedBoost.png",
         description = "Дает вам временное ускорение",
         cooldown = 60,
         usetime = 15,
         nets = {"Speed",
                 "DeathSpeed"},
         use = function(ply)
            ply:ScreenFade( SCREENFADE.IN, Color( 255, 217, 0, 64), 15, 0 )
             ply:SetRunSpeed(750)
             timer.Simple(15,function()
                ply:SetWalkSpeed(200)
                ply:SetRunSpeed(500)
             end)
             net.Start("Speed")
             net.Send(ply)
         end,
         death = function(ply)
            if ply:GetWalkSpeed() == 750 then 
            ply:SetRunSpeed(500)
            end 
            net.Start("DeathSpeed")
            net.Send(ply)
         end,
         customUse = false,
     }
)
--]]

AddSkill(
     {   name = "DoorBlock",
         icon = "doorblock/doorblock.jpg",
         description = "Вы блокируете дверь перед собой",
         cooldown = 30,
         usetime = 10,
         nets = {},
         use = function(ply)
            local origAbility = abilities[ply.Ability.id]
            local ent = ply:GetEyeTrace().Entity
            local hitpos = ply:GetEyeTrace().HitPos
            if ent:IsValid() then
                if ply.Ability.PlyCooldown <= CurTime() and ent:GetClass() == "prop_door_rotating" then
                 if hitpos:DistToSqr(ply:GetPos()) > 0 and hitpos:DistToSqr(ply:GetPos()) < 5500 then 
                  print("Ability Activated")
                  ply.Ability.PlyCooldown = CurTime() + origAbility.cooldown
                  ply.Ability.PlyUseCD = CurTime() + origAbility.usetime
                  net.Start("AbilityUse")
                  net.WriteFloat(self.Ability.PlyCooldown)
                  net.WriteFloat(self.Ability.PlyUseCD)
                  net.Send(ply)
                  ent:Fire("Lock")
                   timer.Simple(10,function()
                    ent:Fire("Unlock")
                   end)
                 else 
                    print("Я не могу дотянуться")
                 end 
                else
                 print("Ability is reloading")
                end 
            end 
         end,
         death = function(ply,bool)
         end,
         customUse = true,
     }
)

AddSkill(
     {   name = "SilentStep",
         icon = "silentstep/silentstepicon.jpg",
         description = "Ваши шаги не издают звуков",
         cooldown = 60,
         usetime = 15,
         nets = {},
         use = function(ply)
         end,
         death = function(ply,bool)
         end,
         customUse = false,
     }
)

AddSkill(
     {   name = "Berserk",
         icon = "berserk/berserk.jpg",
         description = "Вам выдали экспериментальный препарат, который повышает ваше сопротивление к повреждениям и ускоряет пульс. К сожалению, у него есть и недостатки, но вас же это не волнует, верно?",
         cooldown = 90,
         usetime = 15,
         nets = {},
         active = false,
         use = function(ply)
            ply:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 120), 15, 0 )
            timer.Create("BerserkKD"..ply:EntIndex(),15,1,function()
                ply:Kill()
            end)
         end,
         death = function(ply,bool)
            if timer.Exists("BerserkKD"..ply:EntIndex()) then
                timer.Remove("BerserkKD"..ply:EntIndex())
            end
         end,
         customUse = false,
     }
)

AddSkill(
     {   name = "Disguise",
         icon = "disquise/disquise.jpg",
         description = "Вы приготовились перед операцией и нашли вражескую форму",
         cooldown = 90,
         usetime = 30,
         nets = {"Disquise"},
         models = {
            [2] = {
            "models/player/riot.mdl",
            "models/player/swat.mdl",
            "models/player/urban.mdl",
            "models/player/gasmask.mdl"
        },
        [1] = {
            "models/player/leet.mdl",
            "models/player/phoenix.mdl",
            "models/player/guerilla.mdl",
            "models/player/arctic.mdl",
        },
        [3] = {
            "models/player/group01/male_03.mdl",
            "models/player/group01/male_01.mdl"
        }
    },
         use = function(ply)
            ply.defaultModel = ply:GetModel()
            if GAMEMODE.curGametype.name == "ghettodrugbust" and GAMEMODE.curGametype.loadoutTeam == ply:Team() then
                ply:SetModel(ply.Ability.models[3][math.random(1,table.Count(ply.Ability.models[3]))])
            else 
                ply:SetModel(ply.Ability.models[ply:Team()][math.random(1,table.Count(ply.Ability.models[ply:Team()]))])
            end
            timer.Create("DisquiseKD"..ply:EntIndex(),30,1,function()
                ply:SetModel(ply.defaultModel)
            end)
         end,
         death = function(ply,bool)
            if timer.Exists("DisquiseKD"..ply:EntIndex()) then
                 timer.Remove("DisquiseKD"..ply:EntIndex())
            end
         end,
         customUse = false,
     }
)

--[[hook.Add("SetupMove","MySpeed", function( ply, mv,cmd )
    if ply.Ability and ply.Ability.speedhook then
        ply.Ability.speedhook(ply,mv,cmd)
    end
end )
--]]

AddSkill(
     {   name = "Swan Song",
         icon = "berserk/berserk.jpg",
         description = "Что такое смерть?",
         cooldown = 90,
         usetime = 10,
         nets = {},
         use = function(ply)
            local usetm = abilities[ply.Ability.id].usetime
            ply.Ability.active = true 
            ply.Ability.SwanCD = CurTime() + usetm
            ply:ScreenFade( SCREENFADE.IN, Color( 0, 140, 255, 100), usetm, 0 )
         end,
         death = function(ply,bool)
         end,
         customUse = false,
         passive = true,
     }
)


AddSkill(
     {   name = "Death's hand",
         icon = "berserk/berserk.jpg",
         description = "После смерти вы дарите противникам разрывной подарок",
         cooldown = 90,
         usetime = 10,
         nets = {},
         use = function(ply)
         end,
         death = function(ply,bool)
            if not bool then
             local grenade = ents.Create("cw_kk_ins2_projectile_frag")
             local pos = ply:GetPos()
                grenade:SetPos(pos)
		        grenade:Spawn()
		        grenade:Activate()
		        grenade:SetOwner(ply)
                grenade:Fuse(3)
            end
         end,
         customUse = false,
         passive = true,
     }
)

hook.Add("PlayerFootstep","SilentStep",function(ply,pos,foot,sound,volume,filter)
    if ply.Ability and ply.Ability.id == 3 and ply.Ability.active then
        return true 
    end
end)

