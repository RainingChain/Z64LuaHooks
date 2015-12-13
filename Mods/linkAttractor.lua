Mod = require("./../Mod")

local ActorList = Addr.getById("Actor.List")
local LinkX = Addr.getById("Move.X")
local LinkY = Addr.getById("Move.Y")
local LinkZ = Addr.getById("Move.Z")
local rot = {}

Mod.new("linkAttractor","Attractor",function()
	Utils.onLoop("linkAttractor-loop",function()	
		local linkX = LinkX.get()
		local linkY = LinkY.get()
		local linkZ = LinkZ.get()
		
		for name,offset in pairs(CST.ACTOR_CATEGORY) do
			if(offset ~= CST.ACTOR_CATEGORY.Player) then
				local count = ActorList.get(offset,0)
				local pt = ActorList.get(offset,1)
				
				local i
				for i=0,count-1 do
					local actor = Actor.new(pt,true)
					local x = actor.x.get()
					local y = actor.y.get()
					local z = actor.z.get()
					rot[pt] = rot[pt] or {
						value=0,
						inc=(math.random()-0.5)*math.pi/10,
						dist=25 + 75 * math.random(),
						z=80 + math.random()*80
					}
					rot[pt].value = rot[pt].value + rot[pt].inc
					
					local dist = Utils.getDistance(linkX,linkY,x,y)
					if(dist < 500) then
						local tx = linkX + math.cos(rot[pt].value) * rot[pt].dist
						local ty = linkY + math.sin(rot[pt].value) * rot[pt].dist
						
						actor.x.set(x + (tx - x)/10)
						actor.y.set(y + (ty - y)/10)
						
						if(z < linkZ + rot[pt].z) then
							actor.z.set(z+5)
						else
							actor.z.set(linkZ + rot[pt].z)
						end
					end
					pt = actor.next.get()
				end
			end
		end
		
	end,3)
end,function()
	Utils.clearOnLoop("linkAttractor-loop")
end)
