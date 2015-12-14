Addr = require("Addr")
Utils = require("Utils")

local ActorList = Addr.getById("Actor.List")
local SIZE = Addr.SIZE
local TYPE = Addr.TYPE

ActorModel = {}
ActorModel.LIST = {}
ActorModel.new = function(id,constructor)
	if(not id) then
		Utils.onError("id is null, make sure you typed CST.ACTOR_TYPE correctly.")
	end
	ActorModel.LIST[id] = constructor
end

Actor = {}

Actor.new = function(address)
	address = address % CST.GLOBAL_OFFSET
	
	local self = {}
	self.address = address
	self.addressHex = Utils.decToHex(address)
	
	self.type = Addr.new(self.address,SIZE.word).get()
	self.typeHex = Utils.decToHex(self.type,4)
	self.typeName = CST.ACTOR_TYPE_TO_NAME[self.type]
	
	self.variant = Addr.new(self.address + 0x02,SIZE.byte).get()	
	self.roomNo = Addr.new(self.address + 0x03,SIZE.byte).get()	
	
	self.id = address..self.type..self.roomNo..self.variant	--relatively unique	 
	
	--self.uid = Addr.new(self.address + 176,SIZE.double).get()	
	--if(self.uid ~= 0) then
	--	console.log("damnit")
	--end
	
	
	--based on http://wiki.cloudmodding.com/oot/Actors#Actor_Instances
	self.collisionX = Addr.new(self.address + 0x08,SIZE.float,TYPE.float)
	self.collisionZ = Addr.new(self.address + 0x0C,SIZE.float,TYPE.float)
	self.collisionY = Addr.new(self.address + 0x10,SIZE.float,TYPE.float)
	
	self.initRotX = Addr.new(self.address + 0x14,SIZE.word)
	self.initRotZ = Addr.new(self.address + 0x16,SIZE.word)
	self.initRotY = Addr.new(self.address + 0x18,SIZE.word)
	
	self.x = Addr.new(self.address + 0x24,SIZE.float,TYPE.float)
	self.z = Addr.new(self.address + 0x28,SIZE.float,TYPE.float)
	self.y = Addr.new(self.address + 0x2C,SIZE.float,TYPE.float)
	
	self.scaleX = Addr.new(self.address + 0x50,SIZE.float,TYPE.float)
	self.scaleZ = Addr.new(self.address + 0x54,SIZE.float,TYPE.float)
	self.scaleY = Addr.new(self.address + 0x58,SIZE.float,TYPE.float)
	
	self.prev = Addr.new(self.address + 0x120,SIZE.pointer)
	self.next = Addr.new(self.address + 0x124,SIZE.pointer)
	
	--only for damagable enemies
	--self.damageChart = Addr.new(self.address + 0x98,SIZE.double)
	--self.health = Addr.new(self.address + 0xAF,SIZE.byte)
	--self.damageEffect = Addr.new(self.address + 0xB1,SIZE.byte)
	
		
	if(ActorModel.LIST[self.type]) then
		ActorModel.LIST[self.type](self)
	end	
	
	return self
end

Actor.getDistance = function(act0,act1)
	return Utils.getDistance(act0.x.get(),act0.y.get(),act1.x.get(),act1.y.get())
end



--getter
--Actor.getActorsByCategory(CST.ACTOR_CATEGORY.Bomb)[1].type == CST.ACTOR_TYPE.Bomb

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


ActorModel.new(CST.ACTOR_TYPE.Bomb,function(self)
	self.timer = Addr.new(self.address + 0x1E9)
end)

ActorModel.new(CST.ACTOR_TYPE.Bombchu,function(self)	
	self.timer = Addr.new(self.address + 0x141)
end)

ActorModel.new(CST.ACTOR_TYPE.Warpportals,function(self)	
	self.timer = Addr.new(self.address + 0x183)
end)









return Actor









