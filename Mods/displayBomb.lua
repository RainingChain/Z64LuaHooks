Mod = require("./../Mod")

local form
local bombForm = nil
local BombCount = Addr.getById("Actor.List").list[CST.ACTOR_CATEGORY.Bomb].list[0]
local BombFirst = Addr.getById("Actor.List").list[CST.ACTOR_CATEGORY.Bomb].list[1]

--Mod.activate("displayBomb")

Mod.new("displayBomb","Display Bombs",function()
	form = forms.newform(320,150,"Bombs",function()
		form = nil
		Mod.getById("displayBomb").deactivate()
	end)
	bombForm = {
		[0]=forms.label(form,"",0,50,300,25,true),
		[1]=forms.label(form,"",0,25,300,25,true),
		[2]=forms.label(form,"",0,0,300,25,true),
	}
	
	Utils.onLoop("displayBomb-timer",function()	
		local bc = BombCount.get();
		local pt = BombFirst.get();
		
		local i = 0
		while i < bc and i < 3 do
			local bomb = Actor.new(pt)
			local text = "Bomb" .. i .. " = " 
				.. bomb.timer.get() 
				.. " | x=" .. math.floor(bomb.x.get())
				.. " y=" .. math.floor(bomb.y.get())
				.. " 0x" .. bomb.addressHex
			forms.settext(bombForm[i],text)
			pt = bomb.next.get()
			i = i + 1
		end
		while i < 3 do
			forms.settext(bombForm[i],"")
			i = i + 1
		end
	end,3)
end,function()
	if(form) then
		forms.destroy(form)
	end
	form = nil
	Utils.clearOnLoop("displayBomb-timer")
end)
