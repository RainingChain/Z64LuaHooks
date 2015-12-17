CST = CST or {}

CST.GAMES = {
	OOT="OOT",
	MM="MM",
}

CST.GAME = CST.GAMES.OOT
if(bizstring.contains(bizstring.tolower(gameinfo.getromname()),"mask")) then --kinda bad...
	CST.GAME = CST.GAMES.MM
	console.log("Majora's Mask detected.")
end
--OOT is 941952000

require(CST.GAME..".Cst")

CST.GLOBAL_OFFSET = 0x80000000

CST.INPUT = {
	["A"] = "P1 A",
	["B"] = "P1 B",
	["Z"] = "P1 Z",
	["R"] = "P1 R",
	["L"] = "P1 L",
	["Start"] = "P1 Start",
	["C_Left"] = "P1 C Left",
	["C_Right"] = "P1 C Right",
	["C_Up"] = "P1 C Up",
	["C_Down"] = "P1 C Down",
	["D_Left"] = "P1 DPad L",
	["D_Right"] = "P1 DPad R",
	["D_Up"] = "P1 DPad U",
	["D_Down"] = "P1 DPad D",
	["Y_Axis"] = "P1 Y Axis",
	["X_Axis"] = "P1 X Axis"
}