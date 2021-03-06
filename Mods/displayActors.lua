if(not Mod.isGame({CST.GAMES.OOT,CST.GAMES.MM})) then
	return
end

local form
local myForms = {}
local mod
local catDd
local typeDd
local max = 28
local hexCb

local NOFILTER = "0--No Filter--"
local catList = Utils.clone(CST.ACTOR_CATEGORY_TO_NAME)
catList.whatever = NOFILTER

local typeList = Utils.clone(CST.ACTOR_TYPE_TO_NAME)
typeList.whatever = NOFILTER

mod = Mod.new("displayActors","Display Actors",function()
	form = forms.newform(620,600,"Actors",function()
		form = nil
		mod.deactivate()
	end)
	
	catDd = forms.dropdown(form,catList,150,0,120,20)
	typeDd = forms.dropdown(form,typeList,300,0,180,20)
	
	hexCb = forms.checkbox(form,"Hex",510,0)
	
	for i=1,max do
		myForms[i] = Utils.addUI(form,"label",{text="",x=20,y=i * 20,width=600,height=20,fixedWidth=true})
		Utils.addUI(form,"button",{x=0,y=i * 20,text=" ",width=20,height=20,onclick=function()
			console.log(forms.gettext(myForms[i]))
		end})
		
	end
	
	Utils.onLoop("displayActors-",function()
		local catSel = forms.gettext(catDd)
		local typeSel = forms.gettext(typeDd)
		local hex = forms.ischecked(hexCb)
		
		local count = 1
		for name,cat in pairs(CST.ACTOR_CATEGORY) do
			if(catSel == NOFILTER or catSel == name) then		
				local actList = Actor.getActorsByCategory(cat)
				
				for i=1,actList.length do
					local act = actList[i]
					if(typeSel == NOFILTER or CST.ACTOR_TYPE[typeSel] == act.type) then
						if(myForms[count]) then	--only xx forms available
							local text = ""
							if(not hex) then
								text = Utils.addPadding(act.typeName,20) 
									.. " 0x" .. act.addressHex
									.. " 0x" .. act.typeHex
									.. " x=" .. Utils.addPadding(""..math.floor(act.x.get()),5)
									.. " y=" .. Utils.addPadding(""..math.floor(act.y.get()),5)
									.. " z=" .. Utils.addPadding(""..math.floor(act.z.get()),5)
								if(act.timer) then
									text = text .. " timer=" .. act.timer.get() 
								end	
							else
								for j=0,10 do
									text = text .. Addr.new(act.address + j*4,Addr.SIZE.double,Addr.TYPE.hex).toString() .. " "									
								end								
							end
							
							forms.settext(myForms[count],text)
							count = count + 1
						end
					end
				end
			end
		end
		for j=count,max do
			forms.settext(myForms[j],"")
		end
	end,5)
end,function()
	if(form) then
		forms.destroy(form)
	end
	form = nil
	Utils.clearOnLoop("displayActors-")
end)
