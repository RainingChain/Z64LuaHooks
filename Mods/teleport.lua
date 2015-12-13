Mod = require("./../Mod")

local form
local dropdown
local checkbox
local mod

local Entrance = Addr.getById("Misc.EntranceIndex")

mod = Mod.new("teleport","Teleport",function()
	form = forms.newform(250,200,"Teleport",function()
		form = nil
		mod.deactivate()
	end)
	
	local v = {}	--because bizhawk wants name as value
	for name,offset in pairs(CST.MAP_TO_EXIT) do
		v[offset] = name
	end
	
	dropdown = forms.dropdown(form,v,0,0,200,20)
	forms.label(form,"Freeze Destination",0,30)
	checkbox = forms.checkbox(form,"",100,25)
	
	Utils.onLoop("teleport-",function()
		if(forms.ischecked(checkbox)) then
			Entrance.set(CST.MAP_TO_EXIT[forms.gettext(dropdown)])
		end
	end,1)
		
end,function()
	Utils.clearOnLoop("teleport-")
	if(form) then
		forms.destroy(form)
	end
	form = nil
end)
