if(not Mod.isGame({CST.GAMES.OOT,CST.GAMES.MM})) then
	return
end

local canvas
local width = 500
local height = 500
local LinkX = Addr.getById("Move.X")
local LinkY = Addr.getById("Move.Y")

local catColor = {
	[CST.ACTOR_CATEGORY.Bomb]={color=0xFF000000,size=10},
	[CST.ACTOR_CATEGORY.Chest]={color=0xFFFFFF00,size=10},
	[CST.ACTOR_CATEGORY.Door]={color=0xFF888888,size=10},
	[CST.ACTOR_CATEGORY.Enemy]={color=0xFFFF0000,size=10},
	[CST.ACTOR_CATEGORY.Npc]={color=0xFF00FF00,size=10},
	[CST.ACTOR_CATEGORY.Boss]={color=0xFF00FF00,size=15},
	[CST.ACTOR_CATEGORY.Player]={color=0xFF0000FF,size=10},
	[CST.ACTOR_CATEGORY.ItemAction]={color=0xFF00FFFF,size=10},
	[CST.ACTOR_CATEGORY.Misc]={color=0xFFAA00AA,size=5},
	[CST.ACTOR_CATEGORY.Prop]={color=0xFF005555,size=5},
	[CST.ACTOR_CATEGORY.Prop1]={color=0xFF555500,size=5},
}

Mod.new("minimap","Dynamic Minimap",function()	
	canvas = gui.createcanvas(width,height)
	Utils.onLoop("minimap-draw",function()		
		canvas.Clear(0x00000000);
		
		local linkX = LinkX.get();
		local linkY = LinkY.get();
		
		for cat,cs in pairs(catColor) do
			local actList = Actor.getActorsByCategory(cat)
			
			for i=1,actList.length do
				local actor = actList[i]
				local x = (actor.x.get()-linkX)/15 + width/2
				local y = (actor.y.get()-linkY)/15 + height/2
				canvas.DrawRectangle(x-cs.size/2,y-cs.size/2,cs.size,cs.size,0,cs.color)
				pt = actor.next.get()
			end
		end
		
		canvas.Refresh()
	end,10)	
end,function()
	Utils.clearOnLoop("minimap-draw")
	if(canvas) then
		canvas.Dispose()
	end
	canvas = nil
end)
