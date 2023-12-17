local scrw,scrh = ScrW(),ScrH()
local plym = FindMetaTable("Player")
local circles = include("includes/circles.lua")
--local abilityPanel = nil  

local key = CreateClientConVar("ability_key","18",true,true,"What key will trigger ability?. Check https://wiki.facepunch.com/gmod/Enums/KEY",1,159)

-- abilities locals start
local entnear = {} -- Skan
-- abilities locals end 

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
    font = "Roboto lt", 
	extended = false,
	size = 25,
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
    abilityPanel:SetAlpha(0)
    abilityPanel:AlphaTo(255,2.5,0,function(tbl,pnl)end)
	
    function abilityPanel:Paint( w, h )
        local WhiteColor = Color(255,255,255,alpha)
        local BlackColor = Color(0,0,0,alpha)
        local lcpl = LocalPlayer()
        local alpha = self:GetAlpha()
        surface.SetDrawColor( 124, 123, 123,alpha )
	    surface.SetMaterial( self.mat ) 
	    surface.DrawTexturedRect( 0, 0, w, h ) 
        if lcpl.Ability then
            surface.DrawOutlinedRect(0,0,w,h,2.25)
            if (lcpl.Ability.PlyCooldown and lcpl.Ability.PlyCooldown > CurTime()) or (lcpl.Ability.UsesCount and lcpl.Ability.UsesCount <= 0 ) then
                draw.RoundedBox(0,0,0,w,h,Color(56,53,53,alpha * 0.85))
                if lcpl.Ability.PlyCooldown > CurTime() then
                    draw.SimpleText(math.Round(lcpl.Ability.PlyCooldown - CurTime()),"AbilityCD",w / 2,h / 2,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                end
            end
            if lcpl.Ability.PlyUseCD and lcpl.Ability.PlyUseCD > CurTime() then
	            local UseTimeCDCircle = circles.New(CIRCLE_OUTLINED,h * 0.4,w / 2, h / 2,1)
                local realPlyUseTime = lcpl.Ability.PlyUseCD - CurTime()
                local percent = math.Clamp(realPlyUseTime / ply.Ability.usetime,0,1)
                local end_angle = percent * 360
                draw.NoTexture()
                surface.SetDrawColor(26,189,211,alpha)
                UseTimeCDCircle:SetStartAngle(360 - end_angle)
                UseTimeCDCircle()
            end
            if lcpl.Ability.UsesCount then
                draw.ShadowText(lcpl.Ability.UsesCount,"BindAbility",w * 0.15,h * 0.15,WhiteColor,BlackColor,1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            if lcpl.Ability.passive then
                draw.ShadowText("PASSIVE","BindAbility",w * 0.5,h * 0.85,WhiteColor,BlackColor,1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
                return 
            end
            draw.ShadowText(string.upper(self.bind),"BindAbility",w * 0.85,h * 0.85,WhiteColor,BlackColor,1,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end

net.Receive("AbilityHUD",function()
    local id = net.ReadString()

    local origAbility = abilities[id]
    LocalPlayer().Ability = {}
    LocalPlayer().Ability.id = origAbility.id
    LocalPlayer().Ability.usetime = origAbility.usetime -- wow radial usetimecd very good idea
    LocalPlayer().Ability.PlyCooldown = 0
    LocalPlayer().Ability.PlyUseCD = 0
    LocalPlayer().Ability.UsesCount = origAbility.UsesCount
    LocalPlayer().Ability.passive = origAbility.passive
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    HudAbility(origAbility.name,origAbility.description,origAbility.icon)
end)

net.Receive("HUDRemove",function()
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    LocalPlayer().Ability = nil 
end)

net.Receive("AbilityDebug",function()
    entnear = {}
end)

net.Receive("SkanDeath",function()
    entnear = {}
end)

net.Receive("SkanAbility",function()
    timer.Simple(2,function()

        for k,v in ipairs(ents.FindInSphere(LocalPlayer():GetPos(),5000)) do
            if v:IsPlayer() then
                if v == LocalPlayer() or not v:Alive() or v:Team() == LocalPlayer():Team() then continue end
                
            end

            if v:IsPlayer() then
                entnear[v] = v:GetPos() + v:OBBCenter()
            end
        end
     timer.Simple(10,function()
        entnear = {}
     end)
    end)
end) 

hook.Add("HUDPaint","Skan",function()
    if next(entnear) == nil then return end 
    for k,v in pairs(entnear) do
            local coord = v:ToScreen()
            surface.DrawCircle( coord.x, coord.y, 50 + math.sin( CurTime() ) * 25, Color( 255, 120, 0 ) )
    end
 end)

