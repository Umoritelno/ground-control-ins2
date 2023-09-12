if CLIENT then
    vignetteTable = {}
end

for i = 1,5 do
    local path = "materials/vignettes/vignette"..i..".png"
    if SERVER then
        resource.AddSingleFile(path)
    else 
        vignetteTable[i] = Material(path)
    end
end

maxStun = 100

hook.Add("TFA_Attachment_Attached","TFA_Suppressed",function(wep,ID,attTbl,category)
    if attTbl.WeaponTable.Silenced then
        wep.Suppressed = true
    end
end)

hook.Add("TFA_Attachment_Detached","TFA_Suppressed",function(wep,ID,attTbl,category)
    if attTbl.WeaponTable.Silenced then
        wep.Suppressed = false
    end
end)