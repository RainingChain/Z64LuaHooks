Addr = require("Addr")
Utils = require("Utils")
Actor = require("Actor")
CST = require('Cst')

local formCheckbox = {}

Mod = {}

Mod.new = function(id,name,onActivate,onDeactivate)
	local self = {}
	self.id = id
	self.name = name
	self.onActivate = onActivate
	self.onDeactivate = onDeactivate
	self.active = false
	
	self.activate = function(updateCheckbox)
		if(not self.active) then
			self.onActivate(self)
		end
		
		self.active = true
		
		if(updateCheckbox ~= false and formCheckbox[self.id]) then
			forms.setproperty(formCheckbox[self.id],"Checked",true)
		end
	end
	
	self.deactivate = function(updateCheckbox)
		if(self.active and self.onDeactivate) then
			self.onDeactivate(self)
		end
		self.active = false
		
		if(updateCheckbox ~= false and formCheckbox[self.id]) then
			forms.setproperty(formCheckbox[self.id],"Checked",false)
		end
	end
	
	Mod.LIST[id] = self
	return self
end

Mod.LIST = {}	

Mod.getById = function(id)
	return Mod.LIST[id]
end
	
Mod.activate = function(id)
	Mod.LIST[id].activate()
end	

Mod.deactivate = function(id)
	Mod.LIST[id].deactivate()
end	



Mod.openMainForm = function()	
	local form = forms.newform(300,300,"Mods",function()
		for key,m in pairs(Mod.LIST) do
			m.deactivate()
		end
	end)
	
	local y = 0
	for key,m in pairs(Mod.LIST) do 
		forms.label(form,m.name,0,y,200,25,true)
		
		local checkbox = forms.checkbox(form,"",225,y)
		formCheckbox[m.id] = checkbox
		
		forms.addclick(checkbox,function()
			if(not forms.ischecked(checkbox)) then	--not cuz stupid bizhawk
				Mod.LIST[key].activate(false)	--[key] so can overwrite		
			else
				Mod.LIST[key].deactivate(false)
			end
		end)
		y = y + 25
	end	
end


return Mod

