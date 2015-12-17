
local invertTable = function(list)
	local res = {}
	for i,j in pairs(list) do res[j] = i end
	return res
end

CST = CST or {}

CST.ITEM = {
	DekuStick=0,
		
}

CST.ITEM_TO_NAME = invertTable(CST.ITEM)

CST.ACTOR_CATEGORY = {
	Switch=0,
	Prop1=1,
	Player=2,
	Bomb=3,
	Npc=4,
	Enemy=5,
	Prop=6,
	ItemAction=7,
	Misc=8,
	Boss=9,
	Door=10,
	Chest=11,
}

CST.ACTOR_CATEGORY_TO_NAME = invertTable(CST.ACTOR_CATEGORY)

CST.ACTOR_TYPE = {
	Link=0x0000,
	
}

CST.ACTOR_TYPE_TO_NAME = invertTable(CST.ACTOR_TYPE)

CST.MAP_TO_EXIT = {
	--ex DekuTree=0x0000,
	
}

CST.EXIT_TO_MAP = invertTable(CST.MAP_TO_EXIT)

return CST;