local scrw,scrh = ScrW(),ScrH()
local plym = FindMetaTable("Player")
--local abilityPanel = nil  

surface.CreateFont("AbilityUseTimeCD", {
    font = "Roboto Lt", 
	extended = false,
	size = 15.5,
	weight = 500,
	blursize = 0.8,
	scanlines = 0,
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
    font = "Roboto Cn", 
	extended = false,
	size = 35,
	weight = 500,
	blursize = 0,
	scanlines = 5,
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
    if not self.Ability then return end 
    if not self:Alive() then return end
    if self.Ability.PlyCooldown <= CurTime() then
        net.Start("ClientUse")
        net.SendToServer()
    end
end 

net.Receive("AbilityUse",function()
    if abilityPanel == nil  then return end
    if not LocalPlayer().Ability then return end 
    LocalPlayer().Ability.PlyCooldown = net.ReadFloat()
    LocalPlayer().Ability.PlyUseCD = net.ReadInt(16)
    
end)

net.Receive("ActiveState",function()
    local tim = net.ReadBool()
    LocalPlayer().Ability.active = tim
end)

concommand.Add("ability_use",function(ply)
    ply:UseAbilityClient()
end)

function HudAbility(name,desc,icon)
    abilityPanel = vgui.Create("DPanel")
    abilityPanel.mat = Material(icon)
    abilityPanel:SetPos(scrw * 0.475,scrh * 0.8)
    abilityPanel:SetSize(75,75)
    abilityPanel:SetTooltip(desc)
	
    function abilityPanel:Paint( w, h )
        surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
	    surface.SetMaterial( self.mat ) -- Use our cached material
	    surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
        if LocalPlayer().Ability then
            if LocalPlayer().Ability.PlyCooldown and LocalPlayer().Ability.PlyCooldown > CurTime() then
                draw.RoundedBox(0,0,0,w,h,Color(0,0,0,227))
                draw.SimpleText(math.Round(LocalPlayer().Ability.PlyCooldown - CurTime()),"AbilityCD",w / 2,h / 2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
            if LocalPlayer().Ability.PlyUseCD and LocalPlayer().Ability.PlyUseCD > CurTime() then
                local ang = LocalPlayer().Ability.PlyUseCD / LocalPlayer().Ability.usetime * 360
                local radius = h 
                local originX,originY = w / 2, h / 2
                local y = math.sin( ang ) * radius + originY
                local x = math.cos( ang ) * radius + originX
                draw.SimpleText(math.Round(LocalPlayer().Ability.PlyUseCD - CurTime()),"AbilityUseTimeCD",w / 2,h / 5,Color(0,204,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
            end
        end
    end
    
end

net.Receive("AbilityHUD",function()
    local desc = net.ReadString()
    local name = net.ReadString()
    local icon = net.ReadString()
    local usetime = net.ReadFloat()

    LocalPlayer().Ability = {}
    LocalPlayer().Ability.name = name 
    LocalPlayer().Ability.usetime = usetime -- wow radial usetimecd very good idea
    LocalPlayer().Ability.PlyCooldown = 0
    LocalPlayer().Ability.PlyUseCD = 0
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    HudAbility(name,desc,icon)
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
            --if v:IsNPC() or v:IsPlayer() then
                local coord = v:ToScreen()
                surface.DrawCircle( coord.x, coord.y, 50 + math.sin( CurTime() ) * 25, Color( 255, 120, 0 ) )
            --end
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

net.Receive("doorblock",function()
end)

net.Receive("doorblockdeath",function()
end)

net.Receive("SilentStep",function()
  
end)

net.Receive("SilentStepDeath",function()
end)


