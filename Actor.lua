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

Actor.new = function(address)
	address = address % CST.GLOBAL_OFFSET
	
	local self = {}
	self.address = address
	self.addressHex = Utils.decToHex(address)
	
	self.type = Addr.new(self.address,SIZE.word,TYPE.hex).get()	
	
	self.next = nil
	
	if(ActorModel.LIST[self.type]) then
		ActorModel.LIST[self.type](self)
	else
		Utils.onError("No constructor for actor type " .. self.type)
	end	
	
	return self
end





ActorModel.new(CST.ACTOR_TYPE.Bomb,function(self)
	self.x = Addr.new(self.address + 0x24,SIZE.float,TYPE.float)	--duplicate 0x38 0x100
	self.z = Addr.new(self.address + 0x28,SIZE.float,TYPE.float)
	self.y = Addr.new(self.address + 0x2C,SIZE.float,TYPE.float)
	self.timer = Addr.new(self.address + 0x1E9)
	self.next = Addr.new(self.address + 0x124,SIZE.pointer)
end)


ActorModel.new(CST.ACTOR_TYPE.Bombchu,function(self)
	self.x = Addr.new(self.address + 0x24,SIZE.float,TYPE.float)
	self.z = Addr.new(self.address + 0x28,SIZE.float,TYPE.float)
	self.y = Addr.new(self.address + 0x2C,SIZE.float,TYPE.float)
	
	self.timer = Addr.new(self.address + 0x141)
	self.next = Addr.new(self.address + 0x124,SIZE.pointer)	
end)






return Actor









