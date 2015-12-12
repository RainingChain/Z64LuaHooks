

Utils = require("Utils")
Addr = require("Addr")

local clearTimeout
Utils.setTimeout("a",function()
	console.log("setTimeout 100")
	clearTimeout()	--prevent b
end,100)

clearTimeout = Utils.setTimeout("b",function()
	console.log("should NOT be displayed")
end,200)

console.log("Pressing A should display message.")
console.log("Pressing B should remove Button A events.")

Utils.onButtonRelease("c",CST.INPUT.A,function()
	console.log("onButtonRelease A")
end)

Utils.onButtonPress("d",CST.INPUT.A,function()
	console.log("onButtonPress A")
end)

Utils.onButtonHold("e",CST.INPUT.A,function()
	console.log("onButtonHold A")
end)


Utils.onButtonRelease("f",CST.INPUT.B,function()
	Utils.clearOnButtonRelease("c",CST.INPUT.A)
	Utils.onButtonPress("d",CST.INPUT.A)
	Utils.onButtonHold("e",CST.INPUT.A)
	console.log("event with button A should now be removed")
end)


--####################
console.log("#########")

Addr.getById("Amount.Bomb").set(10)
console.log("Bomb amount should be 10",Addr.getById("Amount.Bomb").get())

console.log("Kokiri Tunic removed from pause menu")
Addr.getById("Equip.KokiriTunic").set("0")



















