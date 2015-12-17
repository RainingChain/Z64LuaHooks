if(not Mod.isGame({CST.GAMES.OOT})) then
	return
end

local form
local LinkX = Addr.getById("Move.X")
local LinkY = Addr.getById("Move.Y")

--Mod.activate("displayBomb")

local rotSpd = math.pi/15
local rot = {
	[1] = 0/6 * math.pi,
	[2] = 4/6 * math.pi,
	[3] = 8/6 * math.pi,
	[4] = 12/6 * math.pi,
	[5] = 16/6 * math.pi,
	[6] = 20/6 * math.pi,
}
Mod.new("bombTornado","Bomb Tornado",function()
	Utils.onLoop("bombTornado-",function()	
		for r=1,6 do
			rot[r] = rot[r] + rotSpd
		end
		
		local bombs = Actor.getActorsByCategory(CST.ACTOR_CATEGORY.Bomb)
		
		for i=1,6 do
			if(bombs[i]) then
				local bomb = bombs[i]
				
				if(bomb.timer.get() < 15) then	--prevent explosion
					bomb.timer.set(40)
				end
				bomb.x.set(LinkX.get() + 75*math.cos(rot[i]))
				bomb.y.set(LinkY.get() + 75*math.sin(rot[i]))
			end
		end
	end,3)
end,function()
	Utils.clearOnLoop("bombTornado-")
end)
