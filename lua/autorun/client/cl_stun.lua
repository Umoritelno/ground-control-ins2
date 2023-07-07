
local passes = 3 -- maybe will be changed
local replacePasses = 2 
local FadeSpeed = 5 -- only for stun replace vignette
hook.Add("HUDPaint","StunEffects",function()
   if !GAMEMODE.StunEnabled then
    local vignetteAlpha = LocalPlayer().vignettePerc or 0
    surface.SetDrawColor(0,0,0,255 * vignetteAlpha)
    surface.SetMaterial(vignetteTable[1])
    for i = 1,replacePasses do
      surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
    end
    LocalPlayer().vignettePerc = math.max(0,vignetteAlpha - (2.5 * FrameTime()))
    return 
   end
 local stunamount = LocalPlayer():GetNWFloat("stunamount",0)
 local stunpercent = (stunamount / 100)
 local alpha = stunpercent * 255
  surface.SetDrawColor(0, 0, 0, alpha)
  surface.SetMaterial(vignetteTable[3])

  for i = 1,passes do
    surface.DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)
  end
end)

net.Receive("StunReplace",function()
  LocalPlayer().vignettePerc = 1
end)

