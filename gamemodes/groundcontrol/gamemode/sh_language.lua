AddCSLuaFile()
Languages = {}

for k,v in pairs(file.Find("languages/*.lua","LUA")) do
    AddCSLuaFile("languages/"..v)
    include("languages/"..v)
    print("Found new translation("..v..")")
end

local lang = CreateClientConVar("gc_language","english",true,false,"Current language")

if CLIENT then

    surface.CreateFont("PopupFontReplace", {
        font = "Roboto", 
        extended = false,
        size = _S(24),
        weight = 700,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        shadow = false,
    })

    local function CheckFontByLanguage()
        if GM.Language == "english" then
            GM.PopupFont = "PopupFont"
        else 
            GM.PopupFont = "PopupFontReplace"
        end
    end

    if Languages[lang:GetString()] then
        GM.Language = lang:GetString()
    else 
        lang:SetString("english")
    end

    CheckFontByLanguage()

    cvars.AddChangeCallback("gc_language",function(cnv,old,new)
        if Languages[new] then
            GAMEMODE.Language = new
            CheckFontByLanguage()
        end
    end)

end