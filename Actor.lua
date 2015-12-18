local ActorList = Addr.getById("Actor.List")
local SIZE = Addr.SIZE
local TYPE = Addr.TYPE

local ID_ADDR = 26

local USE_ID = false

Actor = Actor or {}
Actor.LIST = {}
Actor.NEXT = 1
Actor.COUNT = 0

ActorModel = ActorModel or {}
ActorModel.LIST = {}
ActorModel.BASE_MODEL = "BASE_MODEL"
ActorModel.new = function(id,constructor)
	if(not id) then
		Utils.onError("id is null, make sure you typed CST.ACTOR_TYPE correctly.")
	end
	ActorModel.LIST[id] = constructor
end



Utils.onLoop("Actor_garbageCollector",function()
	for i,act in pairs(Actor.LIST) do
		--changed type => no longer exists
		if(act.type ~= mainmemory.read_u16_be(act.address)) then
			Actor.LIST[i] = nil
			Actor.COUNT = Actor.COUNT - 1
		end
	end
end,500)

event.onloadstate(function()
	Utils.setTimeout("Actor_clear",function()
		Actor.NEXT = 1
		Actor.COUNT = 0
		Actor.LIST = {}
		local list = Actor.getActors()
		for i=1,list.length do
			mainmemory.write_u16_be(list[i].address + ID_ADDR,0)
		end
	end,1)
end,"Actor_clearList")

Actor.new = function(address)
	address = address % CST.GLOBAL_OFFSET
	
	local self = {}
		
	if(USE_ID) then
		local id = mainmemory.read_u16_be(address + ID_ADDR)
		if(id ~= 0 and Actor.LIST[id]) then
			return Actor.LIST[id]
		end
	
		id = Actor.NEXT
		mainmemory.write_u16_be(address + ID_ADDR,Actor.NEXT)
		Actor.NEXT = Actor.NEXT + 1
		Actor.COUNT = Actor.COUNT + 1		
		Actor.LIST[id] = self
		
		self.id = id 
	else
		self.id = address	--address..self.type..self.roomNo..self.variant	--relatively unique	 
	end
		
	self.custom = {}
	
	self.address = address
	self.addressHex = Utils.decToHex(address)
	
	self.x = Addr.new(self.address + 0x24,SIZE.float,TYPE.float)
	self.z = Addr.new(self.address + 0x28,SIZE.float,TYPE.float)
	self.y = Addr.new(self.address + 0x2C,SIZE.float,TYPE.float)
	
	
	self.type = Addr.new(self.address,SIZE.word).get()
	self.typeHex = Utils.decToHex(self.type,4)
	self.typeName = CST.ACTOR_TYPE_TO_NAME[self.type] or ""
	ActorModel.LIST[ActorModel.BASE_MODEL](self)
		
	if(ActorModel.LIST[self.type]) then
		ActorModel.LIST[self.type](self)
	end	
	
	return self
end

Actor.getDistance = function(act0,act1)
	return Utils.getDistance(act0.x.get(),act0.y.get(),act1.x.get(),act1.y.get())
end

Actor.QUERY = {
	address="address",
	actor="actor",
	addressHex="addressHex",
	type="type",
	typeHex="typeHex",
	typeName="typeName",
}	

Actor.getActorByCategory = function(cat)	--first one
	local count = ActorList.get(cat,0)
	if(count) then
		return Actor.new(ActorList.get(cat,1))
	end
	return nil
end

Actor.getActorByType = function(type,categories)
	categories = categories or CST.ACTOR_CATEGORY	--restrict to speed up
	for i,j in pairs(categories) do
		local list = Actor.getActorsByCategory(j)
		local k
		for k=1,list.length do
			if(list[k].type == type) then
				return list[k]
			end
		end
	end
	return nil
end

Actor.getActorsByType = function(type)	
	local res = {length = 0}
	for i,j in pairs(CST.ACTOR_CATEGORY) do
		local list = Actor.getActorsByCategory(j)
		local k
		for k=1,list.length do
			if(list[k].type == type) then
				res.length = res.length + 1
				res[res.length] = list[k]
			end
		end
	end
	return res
end

Actor.getActors = function()
	local res = {length=0}
	for i,j in pairs(CST.ACTOR_CATEGORY) do
		local list = Actor.getActorsByCategory(j)
		for i=1,list.length do
			res.length = res.length + 1 
			res[res.length] = list[i]
		end		
	end
	return res	
end

Actor.isPointerActor = function(pt)
	local list = Actor.getActors()
	for i = 1,list.length do
		if(list[i].address == pt) then
			return true
		end
	end
	return false
end

Actor.getLink = function()
	return Actor.getActorByType(CST.ACTOR_TYPE.Link,{CST.ACTOR_CATEGORY.Player})
end

Actor.getById = function(id)
	return Actor.LIST[id]
end

Actor.getActorsByCategory = function(cat,query)
	local res = {}
	local count = ActorList.get(cat,0)
	res.length = count
	local pt = ActorList.get(cat,1)
	local i
	for i=1,count do
		local act = Actor.new(pt)
		if(not query or query == Actor.QUERY.actor) then
			res[i] = act
		elseif(query == Actor.QUERY.address) then
			res[i] = act.address
		elseif(query == Actor.QUERY.addressHex) then
			res[i] = act.addressHex
		elseif(query == Actor.QUERY.typeHex) then
			res[i] = act.typeHex
		elseif(query == Actor.QUERY.typeName) then
			res[i] = act.typeName
		elseif(query == Actor.QUERY.type) then
			res[i] = act.type
		end
		pt = act.next.get()
	end
	return res
end

Actor.printAll = function(query)
	for i,j in pairs(CST.ACTOR_CATEGORY) do
		console.log(i,Utils.arrayToString(Actor.getActorsByCategory(j,query)))
	end
end



return Actor









