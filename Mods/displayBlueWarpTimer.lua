Mod = require("./../Mod")

local form
local label = nil
local mod
--Mod.activate("displayBomb")

mod = Mod.new("displayBlueWarpTimer","Display Blue Warp Timer",function()
	form = forms.newform(320,200,"Blue Warp",function()
		form = nil
		mod.deactivate()
	end)
	label = forms.label(form,"",0,0,200,25,true),
	
	Utils.onLoop("displayBlueWarpTimer-",function()	
		local warp = Actor.getActorByType(CST.ACTOR_TYPE.Warpportals)
		if(warp) then
			forms.settext(label,"Timer = " .. warp.timer.get())
		else
			forms.settext(label,"No Blue Warp in map.")
		end		
	end,1)
end,function()
	if(form) then
		forms.destroy(form)
	end
	form = nil
	Utils.clearOnLoop("displayBlueWarpTimer-")
end)
