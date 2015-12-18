if(not Mod.isGame({CST.GAMES.OOT,CST.GAMES.MM})) then
	return
end

local form
local mod
local Name = Addr.getById("Misc.Name")

local isOot = CST.GAME == CST.GAMES.OOT

--oot JP:	A=171  a=197  1=1  .=234  -=228
--MM U:	A=0x0A  a=0x24  1=1  .=0x40  -=0x3f	space=0x3e
local off_a = isOot and (197 - string.byte("a")) or (0x24 - string.byte("a"))
local off_A = isOot and (171 - string.byte("A")) or (0x0A - string.byte("A"))
local off_0 = 0 - string.byte("0")
local dot = isOot and 234 or 0x40
local hyphen = isOot and 228 or 0x3f
local space = isOot and 223 or 0x3e


mod = Mod.new("changeName","Change Name",function()
	form = forms.newform(200,150,"Change Name",function()
		form = nil
		mod.deactivate()
	end)

	forms.label(form,"New Name: ")
	local textbox = forms.textbox(form,"",100,20,nil,25,25)
	
	forms.button(form,"Go",function()
		local str = forms.gettext(textbox)
		local i
		for i=1,8 do
			local c = Utils.charAt(str,i)
			if(not c) then
				Name.set(i-1,space)
			else
				local v = string.byte(c)
				if(c >= "a" and c <= "z") then
					Name.set(i-1,v + off_a)
				elseif(c >= "A" and  c <= "Z") then
					Name.set(i-1,v + off_A)
				elseif(c >= "0" and  c <= "9") then
					Name.set(i-1,v - off_0)
				elseif(c == ".") then
					Name.set(i-1,dot)
				elseif(c == "-") then
					Name.set(i-1,hyphen)
				else
					Name.set(i-1,space)
				end
			end
		end
		mod.deactivate()
	end,25,50)
end,function()
	if(form) then
		forms.destroy(form)
	end
	form = nil
end)
