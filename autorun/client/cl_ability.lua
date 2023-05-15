local scrw,scrh = ScrW(),ScrH()
local abilityPanel = nil  

function AbilityDebug()
    for k,v in pairs(debugtable) do
        if timer.Exists(v) then
            timer.Remove(v)
        end
    end
end 

hook.Add("HUDPaint","AbilityTime",function()
    if abilityPanel == nil then return end 
    if LocalPlayer().cooldown == nil then return end 
    if LocalPlayer().cooldown <= CurTime() then return end 
    draw.SimpleText(math.Round(LocalPlayer().cooldown - CurTime()),"ChatFont",scrw * 0.49,scrh * 0.775,Color(255,255,255))
end)

net.Receive("AbilityUse",function()
    LocalPlayer().cooldown = net.ReadInt(32)
    local icon = net.ReadString()
    local desc = net.ReadString()
    local name = net.ReadString()
    local cd = net.ReadInt(16)
    if abilityPanel == nil  then return end

    function abilityPanel:Paint( w, h )
        surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
        surface.SetMaterial( Material(icon) ) -- Use our cached material
        surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
        draw.RoundedBox(5,0,0,w,h,Color(0,0,0,227))
    end

    timer.Create("AbilityCD",cd,1,function()
        if abilityPanel:Valid() then 
        function abilityPanel:Paint( w, h )
            surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
            surface.SetMaterial( Material(icon) ) -- Use our cached material
            surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
        end
    end 
    end)
end)

function HudAbility(name,desc,icon)
    abilityPanel = vgui.Create("DPanel")
    abilityPanel:SetPos(scrw * 0.475,scrh * 0.8)
    abilityPanel:SetSize(75,75)
    abilityPanel:SetTooltip(desc)
    local bindlabel = vgui.Create("DLabel",abilityPanel)
    bindlabel:SetFont("DermaLarge")
    bindlabel:SetSize(50,50)
    --bindlabel:Dock(FILL)
    bindlabel:SetPos(scrw * 0.5,scrh * 0.9)
    bindlabel:SetColor(Color(255,255,255))
    bindlabel:SetText("H")
    local timelabel = vgui.Create("DLabel",abilityPanel)
    timelabel:SetPos(scrw * 0.475,scrh * 0.825)
    timelabel:SetSize(100,100)
    timelabel.think = function()
        if abilityPanel == nil then return end
        if LocalPlayer().cooldown == nil then return end 
        if not LocalPlayer().cooldown <= CurTime() then
            timelabel:SetText(math.Round(LocalPlayer().cooldown - CurTime()))
        else
            timelabel:SetText("")
        end
    end
    --]]

    function abilityPanel:Paint( w, h )
        surface.SetDrawColor( 255, 255, 255, 255 ) -- Set the drawing color
	    surface.SetMaterial( Material(icon) ) -- Use our cached material
	    surface.DrawTexturedRect( 0, 0, w, h ) -- Actually draw the rectangle
    end
    --[[function abilityPanel:Paint(w,h)
        surface.SetMaterial(Material(icon))
        surface.DrawTexturedRect(0,0,w,h)
    end
    --]]
end

net.Receive("AbilityHUD",function()
    print("Ability has been drawn")
    LocalPlayer().cooldown = 0
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    local desc = net.ReadString()
    local name = net.ReadString()
    local icon = net.ReadString()
    timer.Simple(0.5,function()
        if LocalPlayer():IsValid() and LocalPlayer():Alive() then
            HudAbility(name,desc,icon)
        end
    end)   
end)

net.Receive("HUDRemove",function()
    AbilityDebug()
    if abilityPanel != nil then abilityPanel:Remove() abilityPanel = nil end 
    LocalPlayer().cooldown = 0
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
    --[[hook.Add("PlayerFootstep","SilentStepHook",function()
        return true 
    end)
    --]]
    --[[timer.Create("SilentStepTimer",15,1,function()
        hook.Remove("PlayerFootstep","SilentStepHook")
    end)
    --]]
    LocalPlayer().Ability.active = true 
end)

net.Receive("SilentStepDeath",function()
    LocalPlayer().Ability.active = false 
    --hook.Remove("PlayerFootstep","SilentStepHook")
end)

--[[net.Receive("Disquise",function()
    timer.Create("DisquiseKD",30,1,function()
        net.Start("DisquiseClient")
        net.SendToServer()
    end)
end)
--]]


