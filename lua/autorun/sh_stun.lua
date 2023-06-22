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