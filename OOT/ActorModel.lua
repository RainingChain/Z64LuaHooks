local SIZE = Addr.SIZE
local TYPE = Addr.TYPE

ActorModel.new(ActorModel.BASE_MODEL,function(self)
	self.variant = Addr.new(self.address + 0x02,SIZE.byte).get()	
	self.roomNo = Addr.new(self.address + 0x03,SIZE.byte).get()	
	
	self.isLink = self.type == CST.ACTOR_TYPE.Link
	
	--based on http://wiki.cloudmodding.com/oot/Actors#Actor_Instances
	--self.collisionX = Addr.new(self.address + 0x08,SIZE.float,TYPE.float)
	--self.collisionZ = Addr.new(self.address + 0x0C,SIZE.float,TYPE.float)
	--self.collisionY = Addr.new(self.address + 0x10,SIZE.float,TYPE.float)
	
	--self.initRotX = Addr.new(self.address + 0x14,SIZE.word)
	--self.initRotZ = Addr.new(self.address + 0x16,SIZE.word)
	--self.initRotY = Addr.new(self.address + 0x18,SIZE.word)
	
	self.scaleX = Addr.new(self.address + 0x50,SIZE.float,TYPE.float)
	self.scaleZ = Addr.new(self.address + 0x54,SIZE.float,TYPE.float)
	self.scaleY = Addr.new(self.address + 0x58,SIZE.float,TYPE.float)
	
	self.prev = Addr.new(self.address + 0x120,SIZE.pointer)
	self.next = Addr.new(self.address + 0x124,SIZE.pointer)
	
	--only for damagable enemies
	self.damageChart = Addr.new(self.address + 0x98,SIZE.pointer)
	self.health = Addr.new(self.address + 0xAF,SIZE.byte)
	self.damageEffect = Addr.new(self.address + 0xB1,SIZE.byte)
end)

	

ActorModel.new(CST.ACTOR_TYPE.Bomb,function(self)
	self.timer = Addr.new(self.address + 0x1E9)
end)

ActorModel.new(CST.ACTOR_TYPE.Bombchu,function(self)	
	self.timer = Addr.new(self.address + 0x141)
end)

ActorModel.new(CST.ACTOR_TYPE.Warpportals,function(self)	
	self.timer = Addr.new(self.address + 0x183)
end)
