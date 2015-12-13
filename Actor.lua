Addr = require("Addr")
Utils = require("Utils")

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

Actor.new = function(address,silentError)
	address = address % CST.GLOBAL_OFFSET
	
	local self = {}
	self.address = address
	self.addressHex = Utils.decToHex(address)
	
	self.type = Addr.new(self.address,SIZE.word).get()	
	
	--based on http://wiki.cloudmodding.com/oot/Actors#Actor_Instances
	
	self.variant = Addr.new(self.address + 0x02,SIZE.byte).get()	
	self.roomNo = Addr.new(self.address + 0x03,SIZE.byte).get()	
	
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
	elseif(not silentError) then
		Utils.onError("No constructor for actor type " .. self.type)
	end	
	
	return self
end


ActorModel.new(CST.ACTOR_TYPE.Bomb,function(self)
	self.timer = Addr.new(self.address + 0x1E9)
end)


ActorModel.new(CST.ACTOR_TYPE.Bombchu,function(self)	
	self.timer = Addr.new(self.address + 0x141)
end)






return Actor









