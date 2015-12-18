local callOnFrame = {}

local frameCount = 0

local lastInput = {}
local lastJoy = {}
local callOnButtonPress = {}
local callOnButtonRelease = {}
local callOnButtonHold = {}
local callOnLoop = {}

local function callFuncList (list,setToNil)
	if(list == nil) then
		return
	end
	
	for key,value in pairs(list) do
		if(list[key]) then
			if not pcall(list[key]) then
				Utils.onError("error with func "..key)
			end
		end
		if(setToNil) then
			list[key] = nil
		end
	end
end

local function timeout_loop()
	frameCount = frameCount + 1	
	callFuncList(callOnFrame[frameCount],true)
end
	


local function inputLoop()
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

Utils.isButtonHeld = function(key)
	return input.get()[key] or false
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

Utils.decToHex = function(val,length)
	--a = ("%08X"):format(number)
	local OUT = bizstring.hex(val)
	if(length ~= nil) then
		return Utils.addPadding(OUT,length,"0",true)
	end
    return OUT
end

Utils.decToBin = function(val,length)
	local OUT = bizstring.binary(val)
	if(length ~= nil) then
		return Utils.addPadding(OUT,length,"0",true)
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
			if(not pcall(func)) then
				Utils.onError("error with onLoop "..id)
			end
		end
	end,id)
end

Utils.clearOnLoop = function(id)		
	event.unregisterbyname(id)
end

Utils.onError = function(myErr,info)
	if(info) then
		console.log(myErr,info)
	else
		console.log(myErr)
	end
	console.log(debug.traceback())
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

Utils.contains = function(list,what)
	for i,j in pairs(list) do
		if(j == what) then
			return true
		end
	end
	return false
end

Utils.displayInput = function()
	Utils.onLoop("Utils.displayInput",function() 
		console.log("input:",input.get())
	end,100)
end

Utils.clearDisplayInput = function()
	Utils.clearOnLoop("Utils.displayInput")
end

Utils.addUI = function(form,type,prop)
	prop.height = prop.height or 25
	prop.width = prop.width or 100
	prop.x = prop.x or 0
	prop.y = prop.y or 0
	prop.text = prop.text or ""
	prop.multiline = prop.multiline or false
	prop.fixedWidth = prop.fixedWidth or false
	
	local handle
	if(type == "label") then
		handle = forms.label(form,prop.text,prop.x, prop.y,prop.width, prop.height,prop.fixedWidth)
	elseif(type == "textbox") then
		handle = forms.textbox(form,prop.text,prop.width,prop.height,prop.type,prop.x, prop.y,prop.multiline,	prop.fixedWidth)
	elseif(type == "dropdown") then
		handle = forms.dropdown(form,prop.items,prop.x,prop.y,prop.width, prop.height)
	elseif(type == "checkbox") then
		handle = forms.checkbox(form,prop.text,prop.x,prop.y)
		if(prop.checked) then
			Utils.setChecked(handle,true)
		end
	elseif(type == "button") then
		handle = forms.button(form,prop.text,prop.onclick,prop.x,prop.y,prop.width, prop.height)
	else
		return Utils.onError("invalid UI type",type)
	end
	if(type ~= "button" and prop.onclick) then
		forms.addclick(handle,function()
			if(type == CST.UI.checkbox) then
				prop.onclick(not forms.ischecked(handle))
			else
				prop.onclick(handle)
			end
		end)
	end
	return handle
end

Utils.setChecked = function(handle,val)
	forms.setproperty(handle,"Checked",val)
end

Utils.addGlobalOffset = function(val)
	return tonumber("80"..Utils.decToHex(val,6),16)
end

event.unregisterbyname('timeout_loop')
event.onframestart(timeout_loop,'timeout_loop')

event.unregisterbyname('inputLoop')
event.onframestart(inputLoop,'inputLoop')



	
return Utils

