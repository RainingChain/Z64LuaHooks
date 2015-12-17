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


assert(Utils.arrayToString({length=2,[1]=23,[2]="ga"}) == "[23,ga]")
assert(Utils.arrayToString({length=2,[1]=12,[2]=8},true) == "[C,8]")
assert(Utils.decToHex(100) == "64")
assert(Utils.decToHex(100,4) == "0064")
assert(Utils.decToBin(100) == "1100100")
assert(Utils.decToBin(100,10) == "0001100100")
assert(Utils.invertTable({bob="a"}).a == "bob")
assert(Utils.addPadding("bob",5) == "bob  ")
assert(Utils.addPadding("bob",5,"y") == "bobyy")
assert(Utils.addPadding("bob",5,"y",true) == "yybob")
assert(Utils.contains({"12","43"},"43"))
assert(not Utils.contains({"12","43"},"433"))

--####################
console.log("#########")

Addr.getById("Amount.Bomb").set(10)
console.log("Bomb amount should be 10",Addr.getById("Amount.Bomb").get())

console.log("Kokiri Tunic removed from pause menu")
Addr.getById("Equip.KokiriTunic").set("0")



















