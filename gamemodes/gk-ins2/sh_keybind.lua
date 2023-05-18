AddCSLuaFile()

local trans = {["MOUSE1"] = "LEFT MOUSE BUTTON",
	["MOUSE2"] = "RIGHT MOUSE BUTTON"}
	
function GM:getKeyBind(bind)
	local b = input.LookupBinding(bind)
	local e = trans[b]
	
	return b and ("[" .. (e and e or string.upper(b)) .. "]") or "[\"" .. bind .. "\" not bound]"
end

if CLIENT then
	function GM:getActionKey(action)
		return self.ActionsToKey[action].bind
	end
end