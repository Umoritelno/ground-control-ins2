AddCSLuaFile()
Languages = {}
local correctLanguage
local correctLanguageId = "english.lua" -- language we will use as example for fixing others

local languagesTable = file.Find(engine.ActiveGamemode().."/gamemode/localization/*.lua","LUA")

function table.InheritLoop(t,base,filter,keepfilteronchildren)
    if !filter then
        filter = {}
    end
    --[[local args = {...}
    for _,val in pairs(args) do -- idea with filter table better then VarArgs I quess
        args[val] = true 
        val = nil 
    end]]

    for k, v in pairs( base ) do
		if ( t[ k ] == nil ) then 
            t[ k ] = v 
            --print("Replaced slot["..k.."] using correct language")
        elseif istable(t[k]) and !filter[k] then
            if keepfilteronchildren then
                table.InheritLoop(t[k],v,filter,true)
            else
                table.InheritLoop(t[k],v)
            end 
        end
	end


	return t
end

local function CheckLanguageCorrect(langtbl)
   if !correctLanguage then
      ErrorNoHalt("[Ground Control] !Error!\nReason:'Correct language not found and can cause visual bugs(text drawing fails and etc). Report me for fixes'\n")
      return 
   end
    table.InheritLoop(langtbl,correctLanguage,{"lastManPhrases","fontReplace","Random"},true)
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

    local lang = CreateClientConVar("gc_language","English",true,false,"Current language")

    cvars.AddChangeCallback("gc_language", function(cnv, old, new)
        if Languages[new] then
                GAMEMODE.Language = new 
        else 
            GAMEMODE.Language = "English"
            end
            CheckFontByLanguage()
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

    function CheckFontByLanguage()
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
        return Languages[G.Language or "English"]
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
        SetCurLanguage("English")
    end

end