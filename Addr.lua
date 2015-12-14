Utils = require("Utils")

local WCH_PATH = "Addr_JP_10.wch"

Addr = {}

local SIZE = { bit=1/8, byte=8/8,word=16/8,double=32/8,pointer=32/8,float=32/8 }
local TYPE = { unsigned=0,signed=1,hex=2,binary=3,fixedPoint12=4,fixedPoint20=5,fixedPoint16=6,float=7}
Addr.SIZE = SIZE
Addr.TYPE = TYPE


memory.usememorydomain("ROM")

function Addr.new (address,size,type,id,sbStart,sbLength,isRom)
	address = address % CST.GLOBAL_OFFSET
	local self = {}
	self.address = address
	self.addressHex = Utils.decToHex(self.address)
	self.size = size or SIZE.byte
	self.type = type or TYPE.unsigned
	self.id = id or "no id"
	self.sbStart = sbStart or 0
	self.sbLength = sbLength or 0	
	self.lastValue = 0
	self.isRom = isRom or false
	
	local mem = mainmemory
	if(self.isRom) then
		mem = memory
	end

	
	if(self.sbStart + self.sbLength > 16) then
		return ERROR("sbStart + sbLength must be < 16")
	end
	
	self.print = function()
	   console.log(self.id .. " = " .. self.toString())
	end
		
	self.set = function(val)
		if(self.size == SIZE.bit) then
			if(string.len(val) ~= self.sbLength) then
				return ERROR("self.set string.len(val) must == SbLength",self.id)
			end
			
			local v = mem.read_u16_be(self.address)
			local str = Utils.decToBin(v,16)
			local rightLen = 16 - self.sbStart - self.sbLength;
			local str2 = bizstring.substring(str,0,self.sbStart) --self.sbStart
				.. val	--selfLength
				.. bizstring.substring(str,self.sbStart+self.sbLength,rightLen)
			local numVal = tonumber(str2, 2)
			return mem.write_u16_be(self.address,numVal)	
		elseif(self.size == SIZE.byte) then
			if(self.type == TYPE.signed) then
				return mem.write_s8(self.address,val)	
			else
				return mem.write_u8(self.address,val)
			end
		elseif(self.size == SIZE.word) then
			if(self.type == TYPE.signed) then
				return mem.write_s16_be(self.address,val)	
			else
				return mem.write_u16_be(self.address,val)	
			end
		elseif(self.size == SIZE.double) then
			if(self.type == TYPE.signed) then
				return mem.write_s32_be(self.address,val)	
			end
			if(self.type == TYPE.float) then
				return mem.writefloat(self.address,val,true)	
			end
			return mem.write_u32_be(self.address,val,true)	
		end
	end
	
	self.get = function()
		if(self.size == SIZE.bit) then
			local v = mem.read_u16_be(self.address)
			local str = Utils.decToBin(v,16)
			return bizstring.substring(str,1+self.sbStart,self.sbLength)			
		elseif(self.size == SIZE.byte) then
			if(self.type == TYPE.signed) then
				return mem.read_s8(self.address)	
			end
			return mem.read_u8(self.address)			
		elseif(self.size == SIZE.word) then
			if(self.type == TYPE.signed) then
				return mem.read_s16_be(self.address)	
			end
			return mem.read_u16_be(self.address)	
		elseif(self.size == SIZE.double) then
			if(self.type == TYPE.signed) then
				return mem.read_s32_be(self.address)	
			elseif(self.type == TYPE.float) then
				return mem.readfloat(self.address,true)	
			else
				return mem.read_u32_be(self.address)	
			end
		end
	end
	
	self.toString = function()
		local val = self.get();
		if(self.type == TYPE.bin) then
			return Utils.decToBin(val)
		elseif(self.type == TYPE.hex) then
			return Utils.decToHex(val,self.size*2)
		else
			return tostring(val)
		end
	end
	
	self.onChange = function(id,func)
		self.lastValue = self.get()
		Utils.onLoop("Addr-"..self.id..id,function()
			local newVal = self.get()
			if(self.lastValue ~= newVal) then
				local oldVal = self.lastValue
				self.lastValue = newVal
				func(newVal,oldVal)
			end
		end)
	end
	
	self.clearOnChange = function()
		Utils.clearOnLoop("Addr-"..self.id..id)
	end
	
	return self
end

function ERROR(msg,info)
	console.log(msg,info or "")
end

function Addr.create(str)
	local a = bizstring.split(str,"\t");
	
	local address = tonumber(a[1], 16)
	if(address == 0) then --aka separator
		return nil
	end
	
	local size;
	if(a[2] == "b") then
		size = SIZE.byte
	elseif(a[2] == "w") then
		size = SIZE.word
	elseif(a[2] == "d") then
		size = SIZE.double
	end	
	
	local type;
	if(a[3] == "u") then
		type = TYPE.unsigned
	elseif(a[3] == "s") then
		type = TYPE.signed
	elseif(a[3] == "h") then
		type = TYPE.hex
	elseif(a[3] == "b") then
		type = TYPE.binary
	elseif(a[3] == "1") then
		type = TYPE.fixedPoint12
		ERROR("unsupported type fixedPoint12",id)
	elseif(a[3] == "2") then
		type = TYPE.fixedPoint20
		ERROR("unsupported type fixedPoint20",id)
	elseif(a[3] == "3") then
		type = TYPE.fixedPoint16
		ERROR("unsupported type fixedPoint16",id)
	elseif(a[3] == "f") then
		type = TYPE.float
	end	
	
	local id = a[6]
	id = bizstring.trim(bizstring.split(id,"--")[1])
	
	local isRom = a[5] == "ROM"
	
	if(bizstring.startswith(id,"[")) then	--only support array length < 10
		local str = bizstring.substring(id,1,string.len(id)-1)	--remove [
		local leftRight = bizstring.split(str,"]")
		id = leftRight[2]
		local split = bizstring.split(leftRight[1],",")
		local length1 = tonumber(split[1])
		
		if(split[2]) then	--2d array
			local length2 = tonumber(split[2])
			Addr.LIST[id] = Addr.array2D.new(address,length1,length2,size,type,isRom)
		else	--1d array
			Addr.LIST[id] = Addr.array.new(address,length1,size,type,isRom)
		end
	elseif(bizstring.startswith(id,"(")) then
		local start = tonumber(bizstring.substring(id,1,1))
		local length = tonumber(bizstring.substring(id,3,1))
		id = bizstring.substring(id,5,string.len(id)-5)
		Addr.LIST[id] = Addr.new(address,SIZE.bit,TYPE.binary,id,start,length,isRom)
	else	
		Addr.LIST[id] = Addr.new(address,size,type,id,0,0,isRom)
	end
	return Addr.LIST[id]
end


Addr.LIST = {}

function Addr.getById(id)
	return Addr.LIST[id]
end


Addr.array = {}
Addr.array.new = function(address,length,sizeCell,type,isRom)
	local self = {}
	self.address = address
	self.addressHex = Utils.decToHex(self.address)
	self.length = length
	self.list = {}
	local i
	for i=0,self.length-1 do
		self.list[i] = Addr.new(address + i * sizeCell,sizeCell,type,"",0,0,isRom)
	end
	
	self.get = function(num)
		return self.list[num].get()
	end
		
	self.set = function(num,val)
		self.list[num].set(val)
	end
	
	self.toString = function()
		local str = "["
		local i
		for i = 0,self.length-1 do
			str = str .. self.get(i)
			if(i ~= self.length-1) then
				str = str .. ","
			end
		end
		return str .. "]"
	end
	
	self.print = function()
		console.log(self.toString())
	end
	
	return self
end

Addr.array2D = {}
Addr.array2D.new = function(address,length,length2,sizeCell,type,isRom)
	local self = {}
	self.address = address
	self.addressHex = Utils.decToHex(self.address)
	self.length = length
	self.list = {}
	
	self.get = function(num,num2)
		return self.list[num].list[num2].get()
	end
	
	self.set = function(num,num2,val)
		self.list[num].list[num2].set(val)
	end
	
	self.toString = function()
		local str = "["
		local i
		for i = 0,self.length-1 do
			str = str .. self.list[i].toString()
			if(i ~= self.length-1) then
				str = str .. ","
			end
		end
		return str .. "]"
	end
	
	self.print = function()
		console.log(self.toString())
	end
	
	--init
	local sizeSubArray = length2 * sizeCell
	local i
	for i=0,self.length-1 do
		self.list[i] = Addr.array.new(address + i * sizeSubArray,length2,sizeCell,type,isRom)
	end
	
	
	return self
end

Addr.init = function()
	loadWch()
end


function loadWch()
	local a = bizstring.split(Utils.readFile(WCH_PATH),"\n")
	
	local i = 3	--skip Domain RDRAM \n SystemID N64
	while a[i] do
		Addr.create(a[i])
		i = i + 1
	end
	
end

Addr.init()

return Addr;