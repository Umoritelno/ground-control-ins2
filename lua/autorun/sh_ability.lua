print("Shared loaded!")
abilities = {}
nets = {}
debugtable = {
    "BerserkKD",
    "DisquiseKD",
    "AbilityCD",
    "SilentStepTimer",
    "AbilityUse",
}

function AddSkill(data) 
    local name = data.name 
    data.id = table.Count(abilities) + 1
    abilities[table.Count(abilities) + 1] = data 
    for k,v in pairs(data.nets) do
        table.Add(nets,data.nets)
    end
 end 
 
 AddSkill(
     {   name = "Skan",
         icon = "skan/Skan.png",
         description = "Вы сканируете область вокруг вас на наличие живых целей",
         cooldown = 20,
         usetime = 10,
         nets = {"SkanAbility",
                  "SkanDeath"},
         use = function(ply)
             net.Start("SkanAbility")
             --net.WriteString("Skan.png")
             --net.WriteInt(10,5)
             net.Send(ply)
         end,
         death = function(ply)
            net.Start("SkanDeath")
            --hook.Remove("HUDPaint","Skan")
            net.Send(ply)
         end,
         customUse = false,
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
         nets = {"doorblock",
                "doorblockdeath"},
         use = function(ply)
            local ent = ply:GetEyeTrace().Entity
            local hitpos = ply:GetEyeTrace().HitPos
            if ent:IsValid() then
                if ply.Cooldown <= CurTime() and ent:GetClass() == "prop_door_rotating" then
                if hitpos:DistToSqr(ply:GetPos()) > 0 and hitpos:DistToSqr(ply:GetPos()) < 5500 then 
                print("Ability Activated")
                ply.Cooldown = CurTime() + ply.Ability.cooldown
                net.Start("AbilityUse")
                net.WriteInt(ply.Cooldown,32)
                net.WriteString(ply.Ability.icon)
                net.WriteString(ply.Ability.description)
                net.WriteString(ply.Ability.name)
                net.WriteInt(ply.Ability.cooldown,16)
                net.Send(ply)
                ent:Fire("Lock")
                net.Start("doorblock")
                net.WriteEntity(ent)
                net.Send(ply)
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
         death = function(ply)
            net.Start("doorblockdeath")
            net.Send(ply)
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
         nets = {"SilentStep",
                 "SilentStepDeath"},
         use = function(ply)
            --ply.Ability.active = true 
            net.Start("SilentStep")
            net.Send(ply)
            timer.Create("SilentStepTimer"..ply:EntIndex(),15,1,function()
                --ply.Ability.active = false 
                net.Start("SilentStepDeath")
                net.Send(ply)
            end)
         end,
         death = function(ply)
            if timer.Exists("SilentStepTimer"..ply:EntIndex()) then
                timer.Remove("SilentStepTimer"..ply:EntIndex())
            end
            --ply.Ability.active = false 
            net.Start("SilentStepDeath")
            net.Send(ply)
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
         nets = {--"BerserkDeath",
                "BerserkKill"},
         active = false,
         use = function(ply)
            ply:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 120), 15, 0 )
            --[[net.Start("Berserk")
            net.Send(ply)
            --]]
            timer.Create("BerserkKD"..ply:EntIndex(),15,1,function()
                ply:Kill()
            end)
         end,
         death = function(ply)
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
            "models/player/Group01/male_03.mdl",
            "models/player/Group01/male_01.mdl"
        }
    },
         use = function(ply)
            ply.defaultModel = ply:GetModel()
            ply:SetModel(ply.Ability.models[ply:Team()][math.random(1,table.Count(ply.Ability.models[ply:Team()]))])
            timer.Create("DisquiseKD"..ply:EntIndex(),30,1,function()
                ply:SetModel(ply.defaultModel)
            end)
         end,
         death = function(ply)
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

hook.Add("PlayerFootstep","SilentStep",function(ply,pos,foot,sound,volume,filter)
    if ply.Ability and ply.Ability.name == "SilentStep" and ply.Ability.active then
        --print("Toyka cheater")
        return true 
    end
end)

