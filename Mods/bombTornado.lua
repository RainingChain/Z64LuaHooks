Mod = require("./../Mod")

local form
local BombCount = Addr.getById("Actor.List").list[CST.ACTOR_CATEGORY.Bomb].list[0]
local BombFirst = Addr.getById("Actor.List").list[CST.ACTOR_CATEGORY.Bomb].list[1]
local LinkX = Addr.getById("Move.X")
local LinkY = Addr.getById("Move.Y")
local LinkZ = Addr.getById("Move.Z")

--Mod.activate("displayBomb")

local rot = {
	[0] = 0,
	[1] = 2/3 * math.pi,
	[2] = 4/3 * math.pi
}
Mod.new("bombTornado","Bomb Tornado",function()
	Utils.onLoop("bombTornado-",function()	
		local bc = BombCount.get();
		local pt = BombFirst.get();
		
		rot[0] = rot[0] + math.pi/15
		rot[1] = rot[1] + math.pi/15
		rot[2] = rot[2] + math.pi/15
		
		local i = 0
		while i < bc and i < 3 do
			local bomb = Actor.new(pt)
			
			if(bomb.timer.get() < 15) then	--prevent explosion
				bomb.timer.set(40)
			end
			bomb.x.set(LinkX.get() + 75*math.cos(rot[i]))
			bomb.y.set(LinkY.get() + 75*math.sin(rot[i]))
			
			pt = bomb.next.get()
			i = i + 1
		end
	end,3)
end,function()
	Utils.clearOnLoop("bombTornado-")
end)
