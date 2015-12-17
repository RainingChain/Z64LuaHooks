if(not Mod.isGame({CST.GAMES.OOT})) then
	return
end

local form
local checkbox
local mod
local Language = Addr.getById("Misc.Language")

mod = Mod.new("changeLanguage","Change Language",function()
	form = forms.newform(200,150,"Blue Warp",function()
		form = nil
		mod.deactivate()
	end)
	checkbox = forms.checkbox(form,"Japanese?",0,0)
	forms.setproperty(checkbox,"Checked",Language.get() == CST.LANGUAGE.japanese)
	forms.label(form,"Active on Soft Reset.",0,25,200,25,true)
	
	forms.addclick(checkbox,function()
		Utils.setTimeout("changeLanguage-",function()
			if(forms.ischecked(checkbox)) then
				Language.set(CST.LANGUAGE.japanese)
			else
				Language.set(CST.LANGUAGE.english)
			end
		end,5)
	end)
	
end,function()
	if(form) then
		forms.destroy(form)
	end
	form = nil
	Utils.clearOnLoop("changeLanguage-")
end)
