local scrw,scrh = ScrW(),ScrH()
local plym = FindMetaTable("Player")
--local abilityPanel = nil  

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
    if self.Cooldown <= CurTime() then
        net.Start("ClientUse")
        net.SendToServer()
    end
end 

net.Receive("AbilityUse",function()
    if abilityPanel == nil  then return end
    LocalPlayer().Cooldown = net.ReadInt(32)
    --local icon = net.ReadString()
    --local desc = net.ReadString()
    --local name = net.ReadString()
    --local cd = net.ReadInt(16)

    
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
        if LocalPlayer().Cooldown and LocalPlayer().Cooldown > CurTime() then
            draw.RoundedBox(0,0,0,w,h,Color(0,0,0,227))
            draw.SimpleText(math.Round(LocalPlayer().Cooldown - CurTime()),"DermaLarge",w / 2,h / 2,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
    
end

net.Receive("AbilityHUD",function()
    local desc = net.ReadString()
    local name = net.ReadString()
    local icon = net.ReadString()

    LocalPlayer().Cooldown = 0
    LocalPlayer().Ability = {}
    LocalPlayer().Ability.name = name 
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    HudAbility(name,desc,icon)
    --[[timer.Simple(0.5,function()
        if LocalPlayer():IsValid() and LocalPlayer():Alive() then
            HudAbility(name,desc,icon)
        end
    end) 
    --]]  
end)

net.Receive("HUDRemove",function()
    AbilityDebug()
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    LocalPlayer().Cooldown = 0
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
    local dooricon = Material("doorblock/dooricon.png")
    local ent = net.ReadEntity()
    hook.Add("HUDPaint","BlockedDoorHUD",function()
        local doorvect = ent:GetPos():ToScreen()
        surface.SetMaterial(dooricon)
        surface.DrawTexturedRect(doorvect.x,doorvect.y,25,25)
        --draw.SimpleText("Дверь заблокирована","ChatFont",doorvect.x,doorvect.y,Color(255,255,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
    end)
    timer.Simple(10,function()
        hook.Remove("HUDPaint","BlockedDoorHUD")
    end)
end)

net.Receive("doorblockdeath",function()
    hook.Remove("HUDPaint","BlockedDoorHUD")
end)

net.Receive("SilentStep",function()
  
    --LocalPlayer().Ability.active = true 
end)

net.Receive("SilentStepDeath",function()
    --LocalPlayer().Ability.active = false 
    --hook.Remove("PlayerFootstep","SilentStepHook")
end)

--[[net.Receive("Disquise",function()
    timer.Create("DisquiseKD",30,1,function()
        net.Start("DisquiseClient")
        net.SendToServer()
    end)
end)
--]]


