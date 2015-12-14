Mod = require("./../Mod")

local form
local bombForm = nil
local mod
--Mod.activate("displayBomb")

mod = Mod.new("displayBomb","Display Bombs",function()
	form = forms.newform(320,200,"Bombs",function()
		form = nil
		mod.deactivate()
	end)
	bombForm = {
		[1]=forms.label(form,"",0,0,300,25,true),
		[2]=forms.label(form,"",0,25,300,25,true),
		[3]=forms.label(form,"",0,50,300,25,true),
		[4]=forms.label(form,"",0,75,300,25,true),
		[5]=forms.label(form,"",0,100,300,25,true),
		[6]=forms.label(form,"",0,125,300,25,true),
	}
	
	Utils.onLoop("displayBomb-timer",function()	
		local bombs = Actor.getActorsByCategory(CST.ACTOR_CATEGORY.Bomb)
		
		local i
		for i=1,6 do
			if(not bombs[i]) then
				forms.settext(bombForm[i],"")
			else
				local text = "Bomb" .. i .. " = " 
					.. bombs[i].timer.get() 
					.. " | x=" .. math.floor(bombs[i].x.get())
					.. " y=" .. math.floor(bombs[i].y.get())
					.. " 0x" .. bombs[i].addressHex
				forms.settext(bombForm[i],text)
			end	
		end
	end,3)
end,function()
	if(form) then
		forms.destroy(form)
	end
	form = nil
	Utils.clearOnLoop("displayBomb-timer")
end)
