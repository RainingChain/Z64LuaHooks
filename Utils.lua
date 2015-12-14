
CST = require('Cst')

local callOnFrame = {}

local frameCount = 0

local lastInput = {}
local lastJoy = {}
local callOnButtonPress = {}
local callOnButtonRelease = {}
local callOnButtonHold = {}
local callOnLoop = {}

function timeout_loop()
	frameCount = frameCount + 1	
	callFuncList(callOnFrame[frameCount],true)
end

	
function callFuncList(list,setToNil)
	if(list == nil) then
		return
	end
	
	for key,value in pairs(list) do
		if(list[key]) then
			list[key]();
		end
		if(setToNil) then
			list[key] = nil
		end
	end
	
end

function inputLoop()
	local inp = input.get();
	
	for key,value in pairs(inp) do
		if(not lastInput[key] and inp[key]) then
			callFuncList(callOnButtonPress[key])
		end
		if(lastInput[key] and not inp[key]) then
			callFuncList(callOnButtonRelease[key])
		end
		if(inp[key]) then
			callFuncList(callOnButtonHold[key])
		end
		lastInput[key] = inp[key]
	end
	for key,value in pairs(lastInput) do 
		lastInput[key] = inp[key]
	end
	
	--################
	
	local inp2 = joypad.get();	
	for key,value in pairs(inp2) do
		if(key ~= CST.INPUT.Y_Axis and key ~= CST.INPUT.X_Axis) then			
			if(not lastJoy[key] and inp2[key]) then
				callFuncList(callOnButtonPress[key])
			end
			if(lastJoy[key] and not inp2[key]) then
				callFuncList(callOnButtonRelease[key])
			end
			if(inp2[key]) then
				callFuncList(callOnButtonHold[key])
			end
			lastJoy[key] = inp2[key]			
		end
	end
	for key,value in pairs(lastJoy) do 
		lastJoy[key] = inp2[key]
	end
end

Utils = {}

Utils.onButtonPress = function(id,key,func)
	callOnButtonPress[key] = callOnButtonPress[key] or {};	
	callOnButtonPress[key][id] = func
end

Utils.onButtonRelease = function(id,key,func)
	callOnButtonRelease[key] = callOnButtonRelease[key] or {};	
	callOnButtonRelease[key][id] = func
end

Utils.onButtonHold = function(id,key,func)
	callOnButtonHold[key] = callOnButtonHold[key] or {};	
	callOnButtonHold[key][id] = func
end

Utils.clearOnButtonPress = function(id,key)
	callOnButtonPress[key] = callOnButtonPress[key] or {}
	callOnButtonPress[key][id] = nil
end

Utils.clearOnButtonRelease = function(id,key)
	callOnButtonRelease[key] = callOnButtonRelease[key] or {}
	callOnButtonRelease[key][id] = nil
end


Utils.clearOnButtonHold = function(id,key)
	callOnButtonHold[key] = callOnButtonHold[key] or {}
	callOnButtonHold[key][id] = nil
end


Utils.setTimeout = function(id,func,time2)
	local t = frameCount + time2;
	callOnFrame[t] = callOnFrame[t] or {};
	callOnFrame[t][id] = func
	
	return function()
		callOnFrame[t][id] = nil
	end
end


Utils.readFile = function(filename)
	local file = assert(io.open(filename))
	local contents = file:read('*all')
	file:close()
	return contents
end

Utils.decToHex = function(IN,length)
	local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    if(IN == 0) then
		OUT = '0'
	end
	while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
	
	if(length ~= nil) then
		local padding = length - string.len(OUT);
		while padding > 0 do
			OUT = "0" .. OUT
			padding = padding - 1
		end
	end
	
    return OUT
end
Utils.decToBin = function(IN,length)
    local B,K,OUT,I,D=2,"01","",0
    if(IN == 0) then
		OUT = '0'
	end
	while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
	
	if(length ~= nil) then
		local padding = length - string.len(OUT);
		while padding > 0 do
			OUT = "0" .. OUT
			padding = padding - 1
		end
	end
	
    return OUT
end

Utils.onLoop = function(id,func,interval)
	local c = 0
	interval = interval or 1
	event.unregisterbyname(id)
	event.onframestart(function()
		c = c + 1
		if(c % interval == 0) then
			func()
		end
	end,id)
end

Utils.clearOnLoop = function(id)		
	event.unregisterbyname(id)
end


Utils.onError = function(myErr)
	console.log(myErr)
end

Utils.charAt = function(str,i)
	return string.sub(str,i,i)
end


Utils.getLuaDir = function()
	return io.popen"cd":read'*l'
end

Utils.arrayToString = function(list,hex)
	if(not list.length) then
		return Utils.onError("No .length on list provided in Utils.arrayToString")
	end	
	local i
	local str = "["
	for i=1,list.length do
		if(hex) then
			str = str .. Utils.decToHex(list[i])
		else
			str = str .. list[i]
		end
		if(i ~= list.length) then
			str = str .. ","
		end
	end
	return str .. "]"
end

Utils.invertTable = function(list)
	local res = {}
	for i,j in pairs(list) do 
		res[j] = i 
	end
	return res
end

Utils.clone = function(list)
	local res = {}
	for i,j in pairs(list) do
		res[i] = j
	end
	return res
end

Utils.addPadding = function(str,length,charr,left)
	charr = charr or " "
	while string.len(str) < length do
		if(left) then
			str = charr .. str
		else
			str = str .. charr
		end
	end
	return str
end

Utils.getDistance = function(x0,y0,x1,y1)
	return ((x0-x1)^2 + (y0-y1)^2)^0.5
end

event.unregisterbyname('timeout_loop')
event.onframestart(timeout_loop,'timeout_loop')

event.unregisterbyname('inputLoop')
event.onframestart(inputLoop,'inputLoop')



	
return Utils

