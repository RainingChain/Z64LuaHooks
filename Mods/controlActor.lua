if(not Mod.isGame({CST.GAMES.OOT,CST.GAMES.MM})) then
	return
end

local Camera = Addr.getById("Misc.CameraActor")
local CameraLinkPt = Utils.addGlobalOffset(Addr.getById("Misc.CameraLink").address)
local form 

local selectedPt = 0
local selectedPt_tb
local mod

mod = Mod.new("controlActor","Control Actor",function()	
	form = forms.newform(300,200,"",function()
		form = nil
		mod.deactivate()
	end)
	
	Utils.addUI(form,"label",{text="Actor Pointer:",x=0,y=0,width=70})
	selectedPt_tb = Utils.addUI(form,"textbox",{text="",x=75,y=0,width=125,type="HEX"})
	
	Utils.addUI(form,"label",{text="Control with NumberPad",x=0,y=25,width=150})

	Utils.addUI(form,"checkbox",{text="Focus Camera",x=0,y=50,onclick=function(checked)
		if(checked) then
			if(Actor.isPointerActor(selectedPt)) then
				Camera.set(Utils.addGlobalOffset(selectedPt))
			else
				console.log("pointer doesnt pointer to an actor")
			end
		else
			Camera.set(CameraLinkPt)
		end
	end})
		
	Utils.onLoop("controlActor-updateAct",function()
		selectedPt = tonumber(forms.gettext(selectedPt_tb),16) or 0
	
		if(selectedPt == 0 or not Actor.isPointerActor(selectedPt)) then
			return
		end
		local act = Actor.new(selectedPt)
		if(Utils.isButtonHeld(CST.KEYS.NumberPad4)) then
			act.x.set(act.x.get() - 20)
		end
		if(Utils.isButtonHeld(CST.KEYS.NumberPad6)) then
			act.x.set(act.x.get() + 20)
		end
		if(Utils.isButtonHeld(CST.KEYS.NumberPad8)) then
			act.y.set(act.y.get() - 20)
		end
		if(Utils.isButtonHeld(CST.KEYS.NumberPad2)) then
			act.y.set(act.y.get() + 20)
		end
		if(Utils.isButtonHeld(CST.KEYS.NumberPad5)) then
			act.z.set(act.z.get() + 50)
		end
		if(Utils.isButtonHeld(CST.KEYS.NumberPad9)) then
			act.z.set(act.z.get() - 50)
		end		
	end,5)
	
end,function()
	Utils.clearOnLoop("controlActor-updateAct")	
	if(form) then
		forms.destroy(form)
	end
	form = nil
end)
