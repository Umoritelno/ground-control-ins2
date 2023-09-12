print("Shared loaded!")
AddCSLuaFile("includes/circles.lua") -- add squid module(thx)
abilities = {}

if SERVER then 
    debugtable = {
        "AbilityUse",
    }

    GlobalEntityTakeDamage = function(target,dmg)end
end 

local curMap = string.lower(game.GetMap())

function AddSkill(data)
    local count = #abilities 
    --data.id = count + 1
    if (data.whitelist and !data.whitelist[curMap]) or (data.blacklist and data.blacklist[curMap]) then
        print("Skill "..data.name.." was removed from ability table")
        return 
    end
    abilities[data.id] = data 
    if SERVER then
        for key,nt in pairs(data.nets or {}) do
            util.AddNetworkString(nt)
        end

        for i,tim in pairs(data.timers or {}) do
            debugtable[#debugtable + 1] = tim 
        end
    end

    --[[for hookname,hookdata in pairs(data.hooks or {}) do
        if hookname == "EntityTakeDamage" and SERVER then
            local funccopy = GlobalEntityTakeDamage
            GlobalEntityTakeDamage = function()
                funccopy()
                hookdata.func()
            end
            continue 
        end
        if hookdata.state == "client" then
            if CLIENT then
                hook.Add(hookname,data.name.."_"..hookname,hookdata.func)
            end
        elseif hookdata.state == "server" then 
            if SERVER then
                hook.Add(hookname,data.name.."_"..hookname,hookdata.func)
            end
        else 
            hook.Add(hookname,data.name.."_"..hookname,hookdata.func)
        end
    end]]
 end 
 
 AddSkill(
     {   name = "Skan",
         id = "skan",
         icon = "skan/Skan.png",
         description = "Вы сканируете область вокруг вас на наличие живых целей",
         cooldown = 35,
         usetime = 10,
         nets = {"SkanAbility",
                  "SkanDeath"},
         use = function(ply)
             net.Start("SkanAbility")
             net.Send(team.GetPlayers(ply:Team()))
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
         id = "doorblock",
         icon = "doorblock/doorblock.jpg",
         description = "Вы блокируете дверь перед собой",
         whitelist = {["cs_assault"] = true,},
         cooldown = 30,
         usetime = 10,
         nets = {},
         use = function(ply)
            --local origAbility = abilities[ply.Ability.id]
            local ent = ply:GetEyeTrace().Entity
            local hitpos = ply:GetEyeTrace().HitPos
            if ent:IsValid() then
                if ply.Ability.PlyCooldown <= CurTime() and ent:GetClass() == "prop_door_rotating" then
                 if hitpos:DistToSqr(ply:GetPos()) > 0 and hitpos:DistToSqr(ply:GetPos()) < 5500 then 
                  print("Ability Activated")
                  ply.Ability.PlyCooldown = CurTime() + ply.Ability.cooldown
                  ply.Ability.PlyUseCD = CurTime() + ply.Ability.usetime
                  net.Start("AbilityUse")
                  net.WriteFloat(ply.Ability.PlyCooldown)
                  net.WriteFloat(ply.Ability.PlyUseCD)
                  net.Send(ply)
                  ent:Fire("Lock")
                   timer.Simple(10,function()
                    ent:Fire("Unlock")
                   end)
                 else 
                    ply.Ability.PlyCooldown = CurTime() + 5
                    net.Start("AbilityUse")
                    net.WriteFloat(5)
                    net.WriteFloat(0)
                    net.Send(ply)
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
         id = "silentstep",
         icon = "silentstep/silentstepicon.jpg",
         description = "Ваши шаги не издают звуков",
         cooldown = 60,
         usetime = 15,
         nets = {},
         use = function(ply)
         end,
         death = function(ply,bool)
         end,
         hooks = {
            ["PlayerFootstep"] = {
              state = "shared",
              func = function(ply,pos,foot,sound,volume,filter)
                  if ply.Ability and ply.Ability.id == "silentstep" and ply.Ability.active then
                     return true 
                  end 
              end,
            }
         },
         customUse = false,
     }
)

AddSkill(
     {   name = "Berserk",
         id = "berserk",
         icon = "berserk/berserk.jpg",
         description = "Вам выдали экспериментальный препарат, который повышает ваше сопротивление к повреждениям и ускоряет сердцебиение. К сожалению, у него есть и недостатки, но вас же это не волнует, верно?",
         cooldown = 90,
         usetime = 15,
         nets = {},
         timers = {"BerserkKD"},
         active = false,
         use = function(ply)
    
            ply:ScreenFade( SCREENFADE.IN, Color( 255, 0, 0, 120), 15, 0 )
            timer.Create("BerserkKD"..ply:SteamID64(),15,1,function()
                ply:Kill()
            end)
         end,
         death = function(ply,bool)
         end,
         hooks = {
            ["EntityTakeDamage"] = {
                state = "server",
                func = function(target,dmg)
                    if target:IsPlayer() and target.Ability then
                        --local origAbility = abilities[target.Ability.id]

                        if target.Ability.id == "berserk" and target.Ability.active then
                            dmg:ScaleDamage(0.65)
                        end
                    end
                end,
              },
         },
         customUse = false,
     }
)

AddSkill(
     {   name = "Disguise",
         id = "disquise",
         icon = "disquise/disquise.jpg",
         description = "Вы приготовились перед операцией и нашли вражескую униформу",
         cooldown = 90,
         usetime = 30,
         nets = {"Disquise"},
         timers = {"DisquiseKD"},
         models = {
        [1] = {
            "models/player/leet.mdl",
            "models/player/phoenix.mdl",
            "models/player/guerilla.mdl",
            "models/player/arctic.mdl",
        },
        [2] = {
            "models/player/riot.mdl",
            "models/player/swat.mdl",
            "models/player/urban.mdl",
            "models/player/gasmask.mdl"
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
            timer.Create("DisquiseKD"..ply:SteamID64(),30,1,function()
                ply:SetModel(ply.defaultModel)
            end)
         end,
         death = function(ply,bool)
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
         id = "swansong",
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
         hooks = {
            ["PlayerShouldTakeDamage"] = {
              state = "server",
              func = function(ply,attacker)
                if ply.Ability then
                    if ply.Ability.id == "swansong" and ply.Ability.SwanCD then
                        return false 
                    end
                end
              end
            },
            ["FinishMove"] = {
                state = "server",
                func = function(ply,mv)
                    if ply.Ability then
                        if ply.Ability.id == "swansong" and ply.Ability.SwanCD and ply.Ability.SwanCD <= CurTime() then
                            ply:Kill()
                        end
                    end
                end
            },
            ["EntityTakeDamage"] = {
                state = "server",
                func = function(target,dmg)
                    if target:IsPlayer() and target.Ability then
                        --local origAbility = abilities[target.Ability.id]

                        if target.Ability.id == "swansong" and !target.Ability.SwanCD then
                            self.Ability.use(target)
                                return true 
                        end
                    end
                end
            },
            ["DoPlayerDeath"] = {
                state = "server",
                func = function(target,dmg)
                    if attacker:IsPlayer() and ply != attacker then
                        if attacker.Ability and attacker.Ability.id == "swansong" then
                            if attacker.Ability.SwanCD then
                                attacker.Ability.SwanCD = attacker.Ability.SwanCD + 5
                            end
                        end
                    end
                end
            },
           },
         customUse = false,
         passive = true,
     }
)


AddSkill(
     {   name = "Death's hand",
         id = "deathshand",
         icon = "berserk/berserk.jpg",
         description = "После смерти вы дарите противникам разрывной подарок",
         cooldown = 90,
         usetime = 10,
         nets = {},
         use = function(ply)
         end,
         death = function(ply,bool)
            if !bool then
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
         passive = true, --
     }
)

hook.Add("PlayerFootstep","SilentStep",function(ply,pos,foot,sound,volume,filter)
    if ply.Ability and ply.Ability.id == "silentstep" and ply.Ability.active then
        return true 
    end
end)

