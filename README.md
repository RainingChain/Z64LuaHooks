Zelda Framework
==============

This framework is meant to provide support for mods for the original Ocarina of Time ROM.
It is meant to work with no setup.
This means it must require no external dependencies other than the project .lua files, the unmodified ROM and unmodified Bizhawk emulator.

Goal:
	-Provide event support. Ex: Utils.onButtonPress
	-Provide read/write addresses support by id. Ex: Addr.getById("Amount.Bomb").set(10) 
	-Provide Enum. Ex: CST.ACTOR_TYPE.Bomb == 0x0010
	-Provide Actor RAM map. Ex: Actor.new(pointerToBomb).x.set(10)
	-Provide modular Mod support. Ex: See /Mods folder.

How to use:
	-Open Bizhawk and load the ROM.
	-Open the Lua Console via Tools->Lua Console
	-Open the script "main.lua"
	-Click to checkbox to apply thee mods you want.
	-NOTICE: Always close the Mod Window before closing the Lua Console.
	
How to contribute:
	-Extend the Actor RAM map in Actor.lua.
	-Add Enums in CST.
	-Add new addresses in Addr_JP_10.wch via Tools->RAM Watch
	-Create new mods following examples in /Mods

	
Utils
	static
		string charAt(number pos)		
		void onButtonPress(string id, CST.INPUT input, Function func)
		void onButtonRelease(string id, CST.INPUT input, Function func)
		void onButtonHold(string id, CST.INPUT input, Function func)		
		void clearOnButtonHold(string id, CST.INPUT input)
		void clearOnButtonPress(string id, CST.INPUT input)
		void clearOnButtonRelease(string id, CST.INPUT input)
		Function setTimeout(string id, Function func, number time)
			Call the function returned to prevent the function call
		string readFile(string path)
		string decToHex(number num,[number length)
			Add 0 left padding to match length if provided
		string decToBin(number num,[number length)
			Add 0 left padding to match length if provided
		void onLoop(string id, Function func,number interval)
		void clearOnLoop(string id)
		string getLuaDir()
			Return path to folder containing "main.lua"
		
	
Addr
	On initialization, every address in the file "Addr_JP_10.wch" will create its corresponding Addr accessible via Addr.getById(id).

	constructor(number address,Addr.SIZE size,Addr.TYPE type,string id)
	
	instance
		void set(number value)
		number get()
		string toString()
	
	static 
		Addr getById(string id)
		
		
Mod
	constructor(string id,string name,Function onActivate,[Function onDeactivate])
	
	instance
		void activate()
		void deactivate()
	
	static 
		Mod getById(string id)
		void activate(string id)
		void deactivate(string id)
		void openMainForm()
		
		
Actor
	constructor(number address)
		
	instance
		CST.ACTOR_TYPE type
		string addressHex
		number address
		
		
		