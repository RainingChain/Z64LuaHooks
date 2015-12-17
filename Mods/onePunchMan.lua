if(not Mod.isGame({CST.GAMES.OOT})) then
	return
end
	
local cats = {[CST.ACTOR_CATEGORY.Enemy] = true,[CST.ACTOR_CATEGORY.Boss] = true}

mod = Mod.new("onePunchMan","One Punch Man",function()
	Utils.onLoop("onePunchMan-loop",function()
		for cat,t in pairs(cats) do
			local actList = Actor.getActorsByCategory(cat)
			for i=1,actList.length do
				actList[i].health.set(1)	--if 0, stalfos dont die...			
			end
		end
	end,25)
end,function()
	Utils.clearOnLoop("scale-loop")
end)
