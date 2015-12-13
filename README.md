Z64 Lua Hooks
==============

This project provides support for mods for Ocarina of Time JP 1.0.

All you need to use it is a Ocarina of Time JP 1.0 ROM and the [Bizhawk emulator](http://tasvideos.org/BizHawk.html). No setup required, it works right out of the box.

####Goal:
- Provide read/write addresses support by id. Ex: `Addr.getById("Amount.Bomb").set(10)`
- Provide event support. Ex: `Utils.onButtonPress`
- Provide Enum. Ex: `CST.ACTOR_TYPE.Bomb == 0x0010`
- Provide Actor RAM map. Ex: `Actor.new(pointerToBomb).x.set(10)`
- Provide modular Mod support. Ex: See `/Mods` folder.

####How to use:
- Open Bizhawk and load the ROM.
- Open the Lua Console via Tools->Lua Console
- Open the script `main.lua`
- Click to checkbox to apply thee mods you want.
- NOTICE: Always close the Mod Window before closing the Lua Console.
	
####How to contribute:
- Extend the Actor RAM map in `Actor.lua`.
- Add Enums in `Cst.lua`.
- Add new addresses in `Addr_JP_10.wch` via Tools->RAM Watch
..- Dungeon map/key/compass/flags.
..- Permanent flags.
- Create new mods following examples in `/Mods`.


####Mods made so far:
- [Minimap Displaying All Actors](https://youtu.be/1x5szVqoyuU)
- [Attracts all Actors towards Link](https://www.youtube.com/watch?v=wQbrlCaYlx0)
- [Scale Link and Actors](https://www.youtube.com/watch?v=Oczgt9Ib9KI)
- Change Name
- Bomb Tornado (Causes bombs to loop in circles around you)
- Display Bomb	(Display all bombs x,y,z,timer and address)
- Press L to levitate
- Teleport
- Change Tunic Hex Color (Modifies ROM)

[More Mods Video](https://www.youtube.com/watch?v=kUZ-sWL7h0Q)




#### API

######Utils

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
		
	
######Addr

	On initialization, every address in `Addr_JP_10.wch` will create its corresponding Addr accessible via `Addr.getById(id)`.

	constructor(number address,Addr.SIZE size,Addr.TYPE type,string id)
	
	instance
		void set(number value)
		number get()
		string toString()
	
	static 
		Addr getById(string id)
		
		
######Mod

	constructor(string id,string name,Function onActivate,[Function onDeactivate])
	
	instance
		void activate()
		void deactivate()
	
	static 
		Mod getById(string id)
		void activate(string id)
		void deactivate(string id)
		void openMainForm()
		
		
######Actor

	constructor(number address)
		
	instance
		CST.ACTOR_TYPE type
		string addressHex
		number address
		string id
		Addr x
		Addr y
		Addr z
		Addr next
		Addr prev
		Addr scaleX
		Addr scaleY
		Addr scaleZ
		
		