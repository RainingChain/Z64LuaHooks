if(not Mod.isGame({CST.GAMES.OOT})) then
	return
end

local form
local Name = Addr.getById("Misc.Name")
local mod

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
			if(c) then
				local v = string.byte(c)
				
				--A=171  a=197  1=1  .=234  -=228
				if(c >= "a" and c <= "z") then
					Name.set(i-1,v + 100)
				elseif(c >= "A" and  c <= "Z") then
					Name.set(i-1,v + 106)
				elseif(c >= "0" and  c <= "9") then
					Name.set(i-1,v -48)
				elseif(c == ".") then
					Name.set(i-1,234)
				elseif(c == "-") then
					Name.set(i-1,228)
				else	--space and others
					Name.set(i-1,223)
				end
				
			else
				Name.set(i-1,223)
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
