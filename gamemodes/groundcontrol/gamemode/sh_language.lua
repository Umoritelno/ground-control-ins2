AddCSLuaFile()
Languages = {}
local correctLanguage
local correctLanguageId = "english.lua" -- language we will use as example for fixing others

local languagesTable = file.Find("localization/*.lua","LUA")

local function CheckLanguageCorrect(langtbl)
   if !correctLanguage then
      ErrorNoHalt("Correct language not found and can cause visual bugs(text drawing fails and etc). Report me for fixes")
      return 
   end

   for k,v in pairs(correctLanguage) do
    if !langtbl[k] or (istable(langtbl[k]) and table.IsEmpty(langtbl[k])) then
        langtbl[k] = v
    elseif istable(langtbl[k]) and k != "lastManPhrases" then 
        local ktbl = langtbl[k]
        for id,val in pairs(correctLanguage[k]) do
            if !ktbl[id] then
                ktbl[id] = val
            end
        end
    end
   end
end 

if table.HasValue(languagesTable,correctLanguageId) then
    AddCSLuaFile("localization/"..correctLanguageId)
    include("localization/"..correctLanguageId)
    Languages[Language.id] = Language
    correctLanguage = Language
    Language = nil 
    table.RemoveByValue(languagesTable,correctLanguageId)
    print("Found new localization("..correctLanguageId.."). Registering it as correct...")
end

for k,v in pairs(languagesTable) do
    AddCSLuaFile("localization/"..v)
    include("localization/"..v)
    CheckLanguageCorrect(Language)
    Languages[Language.id] = Language
    Language = nil 
    print("Found new localization("..v..")")
end

if CLIENT then

    local lang = CreateClientConVar("gc_language","english",true,false,"Current language")

    cvars.AddChangeCallback("gc_language",function(cnv,old,new)
        if Languages[new] then
            GAMEMODE.Language = new 
            CheckFontByLanguage()
        end
    end)

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
        local G = GM or GAMEMODE
        local replacetbl = GetCurLanguage().fontReplace
        if replacetbl then
            G.Fonts = G.DefFonts
            table.Merge(G.Fonts,replacetbl)
        else 
            G.Fonts = G.DefFonts
        end
    end

    function GetCurLanguage()
        local G = GM or GAMEMODE 
        return Languages[G.Language or "english"]
    end

    function SetCurLanguage(id)
        if Languages[id] then
            if GM then
                GM.Language = id 
                CheckFontByLanguage()
            else 
                lang:SetString(id)
            end
        end
    end

    if Languages[lang:GetString()] then
        SetCurLanguage(lang:GetString())
    else 
        SetCurLanguage("english")
    end

end