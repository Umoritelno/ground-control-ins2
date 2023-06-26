local scrw,scrh = ScrW(),ScrH()
local plym = FindMetaTable("Player")
local circles = include("includes/circles.lua")
--local abilityPanel = nil  

local key = CreateClientConVar("ability_key","18",true,true,"What key will trigger ability?. Check https://wiki.facepunch.com/gmod/Enums/KEY",1,159)

cvars.AddChangeCallback("ability_key",function(name,old,new)
    if abilityPanel then
        abilityPanel.bind = input.GetKeyName(new)
    end
end)

surface.CreateFont("BindAbility", {
    font = "Roboto lt", 
	extended = false,
	size = 17.5,
	weight = 500,
	blursize = 0.1,
	scanlines = 1,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

surface.CreateFont("AbilityCD", {
    font = "Roboto", 
	extended = false,
	size = 35,
	weight = 500,
	blursize = 0.25,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = true ,
})

function AbilityDebug()
    for k,v in pairs(debugtable) do
        if timer.Exists(v) then
            timer.Remove(v)
        end
    end
end 

function plym:UseAbilityClient()
    -- DEPRECATED
    if not self.Ability then return end 
    if not self:Alive() then return end
    if self.Ability.PlyCooldown <= CurTime() or (self.Ability.UsesCount and self.Ability.UsesCount > 0) then
        net.Start("ClientUse")
        net.SendToServer()
    end
end 

net.Receive("AbilityUse",function()
    if not abilityPanel then return end
    if not LocalPlayer().Ability then return end 
    LocalPlayer().Ability.PlyCooldown = net.ReadFloat()
    LocalPlayer().Ability.PlyUseCD = net.ReadFloat()
    local uses = net.ReadInt(16)
    if LocalPlayer().Ability.UsesCount then
        LocalPlayer().Ability.UsesCount = uses
    end
end)

net.Receive("ActiveState",function()
    local tim = net.ReadBool()
    LocalPlayer().Ability.active = tim
end)

function HudAbility(name,desc,icon)
    abilityPanel = vgui.Create("DPanel")
    abilityPanel.mat = Material(icon)
    abilityPanel.bind = input.GetKeyName(key:GetInt())
    abilityPanel:SetPos(scrw * 0.475,scrh * 0.8)
    abilityPanel:SetSize(75,75)
    abilityPanel:SetTooltip(desc)
	
    function abilityPanel:Paint( w, h )
        local lcpl = LocalPlayer()
        surface.SetDrawColor( 255, 255, 255 ) -- Set the drawing color
	    surface.SetMaterial( self.mat ) -- Use our cached material
	    surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
        if lcpl.Ability then
            if (lcpl.Ability.PlyCooldown and lcpl.Ability.PlyCooldown > CurTime()) or (lcpl.Ability.UsesCount and lcpl.Ability.UsesCount <= 0 ) then
                draw.RoundedBox(0,0,0,w,h,Color(0,0,0,227))
                if lcpl.Ability.PlyCooldown > CurTime() then
                    draw.SimpleText(math.Round(lcpl.Ability.PlyCooldown - CurTime()),"AbilityCD",w / 2,h / 2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end
            if lcpl.Ability.PlyUseCD and lcpl.Ability.PlyUseCD > CurTime() then
	            local UseTimeCDCircle = circles.New(CIRCLE_OUTLINED,h * 0.4,w / 2, h / 2,1)
                local realPlyUseTime = lcpl.Ability.PlyUseCD - CurTime()
                local percent = math.Clamp(realPlyUseTime / ply.Ability.usetime,0,1)
                local end_angle = percent * 360
                draw.NoTexture()
                surface.SetDrawColor(26,189,211,self:GetAlpha())
                UseTimeCDCircle:SetStartAngle(360 - end_angle)
                UseTimeCDCircle()
            end
            if lcpl.Ability.UsesCount then
                draw.ShadowText(lcpl.Ability.UsesCount,"BindAbility",w * 0.15,h * 0.15,GAMEMODE.HUDColors.white,GAMEMODE.HUDColors.black,1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            surface.DrawOutlinedRect(0,0,w,h,2.5)
            if lcpl.Ability.passive then
                draw.ShadowText("PASSIVE","BindAbility",w * 0.5,h * 0.85,GAMEMODE.HUDColors.white,GAMEMODE.HUDColors.black,1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                return 
            end
            draw.ShadowText(string.upper(self.bind),"BindAbility",w * 0.85,h * 0.85,GAMEMODE.HUDColors.white,GAMEMODE.HUDColors.black,1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
    
end

net.Receive("AbilityHUD",function()
    local id = net.ReadInt(16)

    local origAbility = abilities[id]
    LocalPlayer().Ability = {}
    LocalPlayer().Ability.id = origAbility.id
    LocalPlayer().Ability.usetime = origAbility.usetime -- wow radial usetimecd very good idea
    LocalPlayer().Ability.PlyCooldown = 0
    LocalPlayer().Ability.PlyUseCD = 0
    LocalPlayer().Ability.UsesCount = origAbility.UsesCount
    LocalPlayer().Ability.passive = origAbility.passive
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    HudAbility(origAbility.name,origAbility.desc,origAbility.icon)
end)

net.Receive("HUDRemove",function()
    AbilityDebug()
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    --LocalPlayer().Cooldown = 0
    LocalPlayer().Ability = nil 
end)

net.Receive("SkanAbility",function()
    local entnear = {}
    for k,v in ipairs(ents.FindInSphere(LocalPlayer():GetPos(),5000)) do
        if v:IsPlayer()then
            if v == LocalPlayer() or not v:Alive() then continue end
        end
        
        if v:IsPlayer() then
           entnear[v] = v:GetPos() + v:OBBCenter()
        end
    end
    timer.Simple(2,function()
    hook.Add("HUDPaint","Skan",function()
        for k,v in pairs(entnear) do
                local coord = v:ToScreen()
                surface.DrawCircle( coord.x, coord.y, 50 + math.sin( CurTime() ) * 25, Color( 255, 120, 0 ) )
        end
    end)
    end)
    timer.Simple(10,function()
        hook.Remove("HUDPaint","Skan")
    end)
end) 
net.Receive("SkanDeath",function()
    hook.Remove("HUDPaint","Skan")
end)

--[[net.Receive("Speed",function()
    
end)
--]]

