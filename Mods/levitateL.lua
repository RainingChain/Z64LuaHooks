Mod = require("./../Mod")


Mod.new("levitateL","Press L to Levitate",function()
	Utils.onButtonHold("levitateL-key",CST.INPUT.L,function()
		Addr.getById("Move.ZVelocity").set(4)
	end)
end,function()
	Utils.clearOnButtonHold("levitateL-key",CST.INPUT.L)
end)

