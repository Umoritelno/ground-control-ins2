--[[
	if you wish to setup specific things for the gamemode ON THE CLIENT, you should do it here
	this file will never be changed in future updates (except for being included in them), so you're free to adjust the gamemode as you see fit here 
	the code here will be run after everything in the gamemode has been initialized 
	
	this is also the best place for the "GroundControlPostInitEntity" hook (added with hook.Add as usual)
]]--

net.Receive("updateclientcvar",function()
	local child = net.ReadString()
	local state = net.ReadBool()
    GAMEMODE[child] = state
end)

-- client cvars start 
local cwZ = CreateClientConVar("gc_cw_z","0",true,false,"How much z-axis of CW 2.0 weapons will be increased",-3,1)
local cwY = CreateClientConVar("gc_cw_y","0",true,false,"How much y-axis of CW 2.0 weapons will be increased",-1,5)
local cwX = CreateClientConVar("gc_cw_x","0",true,false,"How much x-axis of CW 2.0 weapons will be increased",-1,3)

local toytown =  CreateClientConVar("gc_toytown",0,true,false,"Should toytown effect work?",0,1)

-- bloom start
GM.BloomTable = {} 
local bloombool = CreateClientConVar("gc_bloom_enable",0,true,false,"Should bloom effect work?",0,1)
local bloomid = CreateClientConVar("gc_bloom_id","Orange/White Bloom Modifier",true,false,"What type of bloom should work?")

function AddBloomModifier(key,tbl)
  for key, col in pairs(tbl.Colour) do
    tbl.Colour[key] = col / 255
  end

	GM.BloomTable[key] = tbl
end

                      AddBloomModifier("Orange/White Bloom Modifier", { -- thx lifemod devs for this code
                        Colour = {
                          R = 355,
                          G = 323,
                          B = 127
                        },
                        Darken = 0.19,
                        Multiply = 0.45 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                    
                      AddBloomModifier("Orange/Gold Bloom Modifier", {
                        Colour = {
                          R = 455,
                          G = 391,
                          B = 0
                        },
                        Darken = 0.19,
                        Multiply = 0.45 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                    
                      AddBloomModifier("Red/White Bloom Modifier", {
                        Colour = {
                          R = 355,
                          G = 127,
                          B = 127
                        },
                        Darken = 0.19,
                        Multiply = 1 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                    
                     AddBloomModifier("Red/Orange Bloom Modifier", {
                        Colour = {
                          R = 355,
                          G = 193,
                          B = 0
                        },
                        Darken = 0.19,
                        Multiply = 1 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                    
                      AddBloomModifier("Magenta/White Bloom Modifier", {
                        Colour = {
                          R = 191,
                          G = 127,
                          B = 355
                        },
                        Darken = 0.19,
                        Multiply = 1.15 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                    
                      AddBloomModifier("Green/White Bloom Modifier", {
                        Colour = {
                          R = 127,
                          G = 355,
                          B = 159
                        },
                        Darken = 0.19,
                        Multiply = 0.35 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                    
                      AddBloomModifier("Blue/White Bloom Modifier", {
                        Colour = {
                          R = 127,
                          G = 159,
                          B = 355
                        },
                        Darken = 0.19,
                        Multiply = 0.7 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 2.24
                      })
                      
                  
                    
                      AddBloomModifier("Heretic's Bloom Modifier", {
                        Colour = {
                          R = 64,
                          G = 200,
                          B = 255
                        },
                        Darken = 0.69,
                        Multiply = 2.32,
                        SizeX = 8.84,
                        SizeY = 0,
                        Passes = 25 / 30,
                        ColourMultiply = 1
                      })
                    
                      AddBloomModifier("Shell's BloomModifier for UEP 3.5", {
                        Colour = {
                          R = 224,
                          G = 237,
                          B = 255
                        },
                        Darken = 0.60,
                        Multiply = 1 / 5,
                        SizeX = 2.97,
                        SizeY = 3.18,
                        Passes = 2,
                        ColourMultiply = 0.9
                      })

GM:registerAutoUpdateConVar("gc_bloom_id", function(name, old, new)
	if GAMEMODE.BloomTable[new] then
		GAMEMODE.BloomType = new 
	else 
		local default = "Orange/White Bloom Modifier"
	    GAMEMODE.BloomType = default
	end
end)
-- bloom end 


local filter = CreateClientConVar("BlueFilter",0,true,false,"Will filter work?",0,1)
-- filter rgb elements start
local filterRed = CreateClientConVar("gc_filter_red","0",true,false,"The add color's red value. 0 (black) means no change.",0,0.05)
local filterGreen = CreateClientConVar("gc_filter_green","0",true,false,"The add color's green value. 0 (black) means no change.",0,0.05)
local filterBlue = CreateClientConVar("gc_filter_blue","0",true,false,"The add color's blue value. 0 (black) means no change.",0,0.05)
local filterColour = CreateClientConVar("gc_filter_colour","0",true,false,"The saturation value. Setting this to 0 will turn the image to grey-scale. 1 means no change.",1,1.6)
-- filter rgb elements end 

GM.FilterColor = Color(filterRed:GetFloat(),filterGreen:GetFloat(),filterBlue:GetFloat(),filterColour:GetFloat())
local customModify = {
	[ "$pp_colour_addr" ] = GM.FilterColor.r,
	[ "$pp_colour_addg" ] = GM.FilterColor.g,
	[ "$pp_colour_addb" ] = GM.FilterColor.b,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = GM.FilterColor.a,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

--[[GM.CW_Z = cwZ:GetFloat()
GM.CW_Y = cwY:GetFloat()
GM.CW_X = cwX:GetFloat()]]

-- filter cvars callback start

cvars.AddChangeCallback("gc_filter_red", function(name, old, new)
	GAMEMODE.FilterColor.r = new 
	customModify["$pp_colour_addr"] = new 
end)

cvars.AddChangeCallback("gc_filter_green", function(name, old, new)
	GAMEMODE.FilterColor.g = new 
	customModify["$pp_colour_addg"] = new
end)

cvars.AddChangeCallback("gc_filter_blue", function(name, old, new)
	GAMEMODE.FilterColor.b = new
	customModify["$pp_colour_addb"] = new
end)

cvars.AddChangeCallback("gc_filter_colour", function(name, old, new)
	GAMEMODE.FilterColor.a = new
	customModify["$pp_colour_colour"] = new
end)

--filter cvars callback end 

-- weapon cvars callback start 

GM:registerAutoUpdateConVar("gc_cw_z", function(name, old, new)
	GAMEMODE.CW_Z = new 
end)

GM:registerAutoUpdateConVar("gc_cw_y", function(name, old, new)
	GAMEMODE.CW_Y = new 
end)

GM:registerAutoUpdateConVar("gc_cw_x", function(name, old, new)
	GAMEMODE.CW_X = new 
end)
-- weapon cvars callback end 
-- client cvars end 
-- colormodify start 
hook.Add( "RenderScreenspaceEffects", "GroundControlColorModify", function()
	local bool = filter:GetBool()
	local toy = toytown:GetBool()
	local bloomb = bloombool:GetBool()
	local bloomstr = GetConVar("gc_bloom_id"):GetString()
	local bloomtbl = GAMEMODE.BloomTable[bloomstr]
	if bool and !LocalPlayer():NVGBASE_IsGoggleActive() then
		DrawColorModify( customModify ) -- color modification
	end
	if toy then
		DrawToyTown(1,ScrH() / 5) -- toytown
	end
	if bloomb and bloomtbl then
		DrawBloom(bloomtbl.Darken,bloomtbl.Multiply,bloomtbl.SizeX,bloomtbl.SizeY,bloomtbl.Passes,bloomtbl.ColourMultiply,bloomtbl.Colour.R,bloomtbl.Colour.G,bloomtbl.Colour.B)
	end
end )
-- colormodify end 
local blur = Material("pp/blurscreen")
local plr = FindMetaTable("Player")

-- fonts start

surface.CreateFont("ShowRole", {
    font = "Roboto", 
	extended = false,
	size = 30,
	weight = 500,
	blursize = 0.5,
	scanlines = 2,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

--[[surface.CreateFont("SpecRound", {
    font = "Prototype", 
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0.1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false ,
})
--]]

surface.CreateFont("SpecRoundReplace", {
    font = "Roboto", 
	extended = false,
	size = 20,
	weight = 500,
	blursize = 0.1,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false ,
})



-- fonts end 

function BlurPanel( panel, layers, density, alpha )
    local x, y = panel:LocalToScreen(0, 0)

    surface.SetDrawColor( 255, 255, 255, alpha )
    surface.SetMaterial( blur )

    for i = 1, 3 do
        blur:SetFloat( "$blur", ( i / layers ) * density )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
    end
end

function plr:ShowRoleDebug()
	if text then
		for i,v in pairs(self.stringtable or {}) do
			if timer.Exists("RolePanelAdd"..i) then
			 timer.Remove("RolePanelAdd"..i)
		    end
		end
		text:Remove()
		text = nil
	end
end 

function plr:ShowRole(desc)
    self:ShowRoleDebug()
	text = vgui.Create("RichText")
	text.stringtable = string.ToTable(desc)
	text:SetSize(ScrW() * 0.25,ScrH() * 0.15)
	text:SetPos(ScrW() * 0.325,ScrH() * 0.1)
	text:CenterHorizontal()
	--text:Dock(FILL)
	--text:AppendText(desc)
	text:InsertColorChange(0,0,0,255)
	text:SetVerticalScrollbarEnabled(false)
    local delay = 0
	for number,bukva in pairs(text.stringtable) do
		timer.Create("RolePanelAdd"..number,delay,1,function()
			if number == table.Count(text.stringtable) then
		         text:AlphaTo(0,2,5,function(data,pnl)
					if pnl:IsValid() then
						pnl:Remove()
						pnl = nil 
					   end
				 end)
			end
			if text then
			    text:AppendText(bukva)
			    chat.PlaySound() 
			end
		end)
		delay = delay + 0.1
	end

    function text:Paint(w,h)
	    BlurPanel( self, 1, 1, self:GetAlpha() )
		surface.SetDrawColor(255,255,255,self:GetAlpha())
		surface.DrawOutlinedRect(0,0,w,h,2.5)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,125))
	end

	function text:PerformLayout()
		self:SetFGColor(Color(212,209,209,self:GetAlpha()))
		self:SetFontInternal( "ShowRole" )
	end
	
	--[[function text:OnRemove()
		for i,v in pairs(self.stringtable or {}) do
			if timer.Exists("RolePanelAdd"..i) then
			 timer.Remove("RolePanelAdd"..i)
		    end
		end
	end--]]
end 


net.Receive("classinfo",function()
	local class = net.ReadString()
	--local playerclass = player_manager.GetPlayerClass(LocalPlayer())
	local classtable = table.Copy(player_manager.GetPlayerClasses()[class])
	LocalPlayer().plclass = classtable
	if GetGlobalBool("RolesEnabled") then
		LocalPlayer():ShowRole(GetCurLanguage().classes[class].Desc)
	end
end)

--[[hook.Add("TFA_InspectVGUI_Start", "Kill TFA customization", function()
    return CurTime() < GAMEMODE.PreparationTime
end)--]]

hook.Add("TFA_DrawCrosshair", "TFA_Crosshair", function()
    return GetGlobalBool("CrosshairEnabled") == true
end)

hook.Add("TFA_DrawHUDAmmo", "TFA_3D2D", function()
    return GetGlobalBool("AmmoTextDisabled") == true
end)

CustomizableWeaponry.callbacks:addNew("adjustViewmodelPosition", "GroundControl_adjustViewmodelPosition2", function(self, targetPos, targetAng)
	if self.GlobalDelay > CurTime() then return end
	if self.dt.State == CW_IDLE then
		targetPos.y = targetPos.y + GAMEMODE.CW_Y
	    targetPos.z = targetPos.z + GAMEMODE.CW_Z
		targetPos.x = targetPos.x + GAMEMODE.CW_X
	end
	
	return targetPos, targetAng
end)

CustomizableWeaponry.callbacks:addNew("overrideReserveAmmoText", "GroundControl_AmmoTextOverride", function(self)
	if !GetGlobalBool("AmmoTextChanged") then return end 
	local ammoCount = self.Owner:GetAmmoCount(self.Primary.Ammo)
	local magAmount = math.ceil(ammoCount/self.Primary.ClipSize_Orig)
	local finalstring = magAmount.." Mag(s)"
	return Color(255,255,255),finalstring
end)

net.Receive("killnotification",function()
	local rolestr = net.ReadString()
	local nick = net.ReadString()
	chat.AddText(Color(150, 197, 255, 255), "[GROUND CONTROL] ", Color(255, 255, 255, 255), "Вы убили союзника ",Color(252,207,8),nick,Color(255,255,255),". Роль: ",Color(3,243,23),rolestr,Color(255,255,255),"." )
end)


net.Receive("NewVote_Start",function()
	vgui.Create("NewVote")
end)