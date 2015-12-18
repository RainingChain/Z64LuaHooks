if(not Mod.isGame({CST.GAMES.OOT,CST.GAMES.MM})) then
	return
end

local canvas
local width = 400
local height = 400
local LinkX = Addr.getById("Move.X")
local LinkY = Addr.getById("Move.Y")
local form 
local zoom = 10
local zoom_tb
local mod
local size = 100
local size_tb 
local onlyDisplay = 0
local onlyDisplay_tb 
local displayPt_cb

local catColor = {
	[CST.ACTOR_CATEGORY.Bomb]={color=0xFF000000,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.Chest]={color=0xFFFF6600,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.Door]={color=0xFF888888,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.Enemy]={color=0xFFFF0000,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.Npc]={color=0xFF00FF00,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.Boss]={color=0xFF00FF00,size=8,cb=nil},
	[CST.ACTOR_CATEGORY.Player]={color=0xFF0000FF,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.ItemAction]={color=0xFF00FFFF,size=6,cb=nil},
	[CST.ACTOR_CATEGORY.Misc]={color=0xFFAA00AA,size=3,cb=nil},
	[CST.ACTOR_CATEGORY.Prop]={color=0xFF005555,size=3,cb=nil},
	[CST.ACTOR_CATEGORY.Prop1]={color=0xFF555500,size=3,cb=nil},
	[CST.ACTOR_CATEGORY.Switch]={color=0xFF555500,size=3,cb=nil},
}


--Addr.getById("Misc.CameraActor").set(0x8040C6D0)


mod = Mod.new("minimap","Dynamic Minimap",function()	
	canvas = gui.createcanvas(width,height)
	form = forms.newform(300,300,"",function()
		form = nil
		mod.deactivate()
	end)
	
	Utils.addUI(form,"label",{text="Zoom:",x=0,y=0,width=75})
	zoom_tb = Utils.addUI(form,"textbox",{text="10",x=80,y=0,width=50,type="UNSIGNED"})
	
	Utils.addUI(form,"label",{text="Square Size:",x=0,y=25,width=75})
	size_tb = Utils.addUI(form,"textbox",{text="100",x=80,y=25,width=50,type="UNSIGNED"})
	
	Utils.addUI(form,"label",{text="Only Display Pt:",x=0,y=50,width=75})
	onlyDisplay_tb = Utils.addUI(form,"textbox",{text="000000",x=80,y=50,width=50,type="HEX"})
	
	displayPt_cb = Utils.addUI(form,"checkbox",{text="Display Pt",x=0,y=75,width=100})
	
	local c = 0
	for i,j in pairs(catColor) do
		catColor[i].cb = Utils.addUI(form,"checkbox",{
			text=CST.ACTOR_CATEGORY_TO_NAME[i],
			x=125*(c%2),y=100 + 25*math.floor(c/2),checked=true,width=100,
		})
		c = c + 1
	end
	
	
	Utils.onLoop("minimap-draw",function()		
		zoom = tonumber(forms.gettext(zoom_tb)) or 10
		size = tonumber(forms.gettext(size_tb)) or 100
		onlyDisplay = tonumber(forms.gettext(onlyDisplay_tb),16) or 0 
		local displayPt = forms.ischecked(displayPt_cb)
		canvas.Clear(0x00000000);
		
		local linkX = LinkX.get();
		local linkY = LinkY.get();
		for cat,cs in pairs(catColor) do
			if(forms.ischecked(catColor[cat].cb)) then			
				local actList = Actor.getActorsByCategory(cat)
				
				for i=1,actList.length do
					local act = actList[i]
					local x = (act.x.get()-linkX)/zoom + width/2
					local y = (act.y.get()-linkY)/zoom + height/2
					local s = cs.size * 15 / zoom * size / 100
					if(onlyDisplay == 0 or onlyDisplay == act.address or act.isLink) then
						canvas.DrawRectangle(x-s/2,y-s/2,s,s,0,cs.color)
						if(displayPt) then
							canvas.DrawText(x-s/2,y-s/2-10, act.addressHex,0xFF000000,10);
						end
					end
				end
			end
		end
		
		canvas.Refresh()
	end,10)
	
end,function()
	Utils.clearOnLoop("minimap-draw")
	if(canvas) then
		canvas.Dispose()
	end
	if(form) then
		forms.destroy(form)
	end
	form = nil
	canvas = nil
end)
