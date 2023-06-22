

hook.Add("RenderScreenspaceEffects","SupressVignette",function()
local stunamount = LocalPlayer():GetNWFloat("stunamount",0)
local stunpercent = (stunamount / 100)
local alpha = stunpercent * 255
local passes = 3 -- maybe will be changed
    cam.Start2D()

    surface.SetDrawColor(0, 0, 0, alpha)
    surface.SetMaterial(vignetteTable[3])

    for i = 1,passes do
        surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
    end

    cam.End2D()
end)