if(not Mod.isGame({CST.GAMES.OOT})) then
	return
end

local form
local canvas
local Tunic = Addr.getById("Misc.TunicColorHex")
local mod
local textboxR
local textboxG
local textboxB
local canvas

local getTextboxText = function(tb)	--returns length=2
	return bizstring.substring(forms.gettext(tb).."00",0,2)
end

mod = Mod.new("changeTunicColor","Change Tunic Color",function()
	form = forms.newform(200,200,"Change Tunic Color",function()
		form = nil
		mod.deactivate()
	end)

	forms.label(form,"R:",0,0,30,20)
	textboxR = forms.textbox(form,"",50,20,"HEX",50,0)
	forms.label(form,"G:",0,25,30,20)
	textboxG = forms.textbox(form,"",50,20,"HEX",50,25)
	forms.label(form,"B:",0,50,30,20)
	textboxB = forms.textbox(form,"",50,20,"HEX",50,50)
	
	forms.label(form,"Change applied on Soft Reset.",0,75)
	
	forms.button(form,"Go",function()
		local r = tonumber(getTextboxText(textboxR),16)
		local g = tonumber(getTextboxText(textboxG),16)
		local b = tonumber(getTextboxText(textboxB),16)
		
		Tunic.set(0,r)
		Tunic.set(1,g)
		Tunic.set(2,b)
		mod.deactivate()
	end,0,100)
	
	canvas = gui.createcanvas(200,200)
	
	Utils.onLoop("changeTunicColor-draw",function()
		local str = "0xFF"
			.. getTextboxText(textboxR)
			.. getTextboxText(textboxG)
			.. getTextboxText(textboxB)
		canvas.DrawRectangle(0,0,200,200,0,tonumber(str,16))
		canvas.Refresh()
	end,10)
	
	
end,function()
	Utils.clearOnLoop("changeTunicColor-draw")
	if(form) then
		forms.destroy(form)
	end
	if(canvas) then
		canvas.Dispose()
	end
	canvas = nil
	form = nil
end)
