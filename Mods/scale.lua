if(not Mod.isGame({CST.GAMES.OOT})) then
	return
end

local mod
local form
local tbX
local tbY
local tbZ
local tbLX
local tbLY
local tbLZ

mod = Mod.new("scale","Scale Modifier",function()
	form = forms.newform(200,200,"Scale",function()
		form = nil
		mod.deactivate()
	end)

	forms.label(form,"X:",0,0,50,20)
	tbX = forms.textbox(form,"1.0",50,20,nil,70,0)
	forms.label(form,"Y:",0,25,50,20)
	tbY = forms.textbox(form,"1.0",50,20,nil,70,25)
	forms.label(form,"Z:",0,50,50,20)
	tbZ = forms.textbox(form,"1.0",50,20,nil,70,50)
	
	
	forms.label(form,"Link X:",0,75,50,20)
	tbLX = forms.textbox(form,"1.0",50,20,nil,70,75)
	forms.label(form,"Link Y:",0,100,50,20)
	tbLY = forms.textbox(form,"1.0",50,20,nil,70,100)
	forms.label(form,"Link Z:",0,125,50,20)
	tbLZ = forms.textbox(form,"1.0",50,20,nil,70,125)
	
	Utils.onLoop("scale-loop",function()	
		local scaleX = tonumber(forms.gettext(tbX)) or 1
		local scaleY = tonumber(forms.gettext(tbY)) or 1
		local scaleZ = tonumber(forms.gettext(tbZ)) or 1
		
		local scaleLX = tonumber(forms.gettext(tbLX)) or 1
		local scaleLY = tonumber(forms.gettext(tbLY)) or 1
		local scaleLZ = tonumber(forms.gettext(tbLZ)) or 1
		
		local actList = Actor.getActors()
		for i=1,actList.length do
			local act = actList[i]
			if(not act.custom["scale"]) then
				act.custom["scale"] = true
				Utils.setTimeout(math.random(),function()	--must change scale after init
					if(act.isLink) then
						act.scaleX.set(scaleLX*act.scaleX.get())
						act.scaleY.set(scaleLY*act.scaleY.get())
						act.scaleZ.set(scaleLZ*act.scaleZ.get())
					else 
						act.scaleX.set(scaleX*act.scaleX.get())
						act.scaleY.set(scaleY*act.scaleY.get())
						act.scaleZ.set(scaleZ*act.scaleZ.get())
					end
				end,25)
			end
		end
	end,3)
end,function()
	Utils.clearOnLoop("scale-loop")
	if(form) then
		forms.destroy(form)
	end
	form = nil
end)
