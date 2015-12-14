Mod = require("./../Mod")

local LinkX = Addr.getById("Move.X")
local LinkY = Addr.getById("Move.Y")
local LinkZ = Addr.getById("Move.Z")
local rot = {}

Mod.new("linkAttractor","Attractor",function()
	Utils.onLoop("linkAttractor-loop",function()	
		local linkX = LinkX.get()
		local linkY = LinkY.get()
		local linkZ = LinkZ.get()
		
		for name,cat in pairs(CST.ACTOR_CATEGORY) do
			local actList = Actor.getActorsByCategory(cat)
			if(cat == CST.ACTOR_CATEGORY.Player) then
				actList.length = 0
			end
			
			for i=1,actList.length do
				local actor = actList[i]
				rot[actor.id] = rot[actor.id] or {
					value=0,
					inc=(math.random()-0.5)*math.pi/10,
					dist=25 + 75 * math.random(),
					z=80 + math.random()*80
				}
				local r = rot[actor.id]
				local x = actor.x.get()
				local y = actor.y.get()
				local z = actor.z.get()
				
				r.value = r.value + r.inc
				
				local dist = Utils.getDistance(linkX,linkY,x,y)
				if(dist < 500) then
					local tx = linkX + math.cos(r.value) * r.dist
					local ty = linkY + math.sin(r.value) * r.dist
					
					actor.x.set(x + (tx - x)/10)
					actor.y.set(y + (ty - y)/10)
					
					if(z < linkZ + r.z) then
						actor.z.set(z+5)
					else
						actor.z.set(linkZ + r.z)
					end
				end
			end
		end
		
	end,3)
end,function()
	Utils.clearOnLoop("linkAttractor-loop")
end)
