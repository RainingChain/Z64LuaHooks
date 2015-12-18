--Made by SoundBlitz
if(not Mod.isGame({CST.GAMES.OOT,CST.GAMES.MM})) then
	return
end

local mod
local form
local tbspeed
local framePressed = 0

mod = Mod.new("speedMod","Link Speed Mod",function()
	form = forms.newform(250,90,"Link Speed Modifier",function()
		form = nil
		mod.deactivate()	
	end)
	forms.label(form,"Links Speed",0,0,70,20)
	
	tbspeed = forms.textbox(form,"25",70,20,nil,0,20)
	
	Utils.onLoop("speedMod-loop",function()
		local speedmod = tonumber(forms.gettext(tbspeed)) or 1
		
		Utils.onButtonHold("speedMod-key",CST.INPUT.A,function()
			framePressed = framePressed + 1
			if(framePressed > 15) then
				Addr.getById("Move.Speed").set(speedmod)
			end
		end)
		
		Utils.onButtonRelease("speedMod-keyUp",CST.INPUT.A,function()
			framePressed = 0
		end)
		
	end,3)
end,function()
	Utils.clearOnLoop("speedMod-loop")
	Utils.clearOnButtonHold("speedMod-key",CST.INPUT.A)
	Utils.clearOnButtonRelease("speedMod-keyUp",CST.INPUT.A)
	if(form) then
		forms.destroy(form)
	end
	form = nil
end)