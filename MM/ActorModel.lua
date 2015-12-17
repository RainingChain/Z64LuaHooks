local SIZE = Addr.SIZE
local TYPE = Addr.TYPE

ActorModel.new(ActorModel.BASE_MODEL,function(self)
	self.variant = Addr.new(self.address + 0x02,SIZE.byte).get()		--unknown if mm
	self.roomNo = Addr.new(self.address + 0x03,SIZE.byte).get()			--unknown if mm
	
	self.isLink = self.type == CST.ACTOR_TYPE.Link
	
	--based on http://wiki.cloudmodding.com/oot/Actors#Actor_Instances

	self.scaleX = Addr.new(self.address + 0x54,SIZE.float,TYPE.float)	--+0x04 from oot
	self.scaleZ = Addr.new(self.address + 0x58,SIZE.float,TYPE.float)
	self.scaleY = Addr.new(self.address + 0x5C,SIZE.float,TYPE.float)
	
	self.prev = Addr.new(self.address + 0x128,SIZE.pointer)	--+0x08 from oot
	self.next = Addr.new(self.address + 0x12C,SIZE.pointer)	
	

end)
