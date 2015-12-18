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
	["CLeft"] = "P1 C Left",
	["CRight"] = "P1 C Right",
	["CUp"] = "P1 C Up",
	["CDown"] = "P1 C Down",
	["DLeft"] = "P1 DPad L",
	["DRight"] = "P1 DPad R",
	["DUp"] = "P1 DPad U",
	["DDown"] = "P1 DPad D",
	["YAxis"] = "P1 Y Axis",
	["XAxis"] = "P1 X Axis"
}

CST.KEYS = {		--Utils.displayInput()
	A = "A",B = "B",C = "C",D = "D",E = "E",F = "F",
	G = "G",H = "H",I = "I",J = "J",K = "K",
	L = "L",M = "M",N = "N",O = "O",P = "P",
	Q = "Q",R = "R",S = "S",T = "T",U = "U",
	V = "V",W = "W",X = "X",Y = "Y",Z = "Z",
	NumberPad1="NumberPad1",NumberPad2="NumberPad2",NumberPad3="NumberPad3",NumberPad4="NumberPad4",
	NumberPad5="NumberPad5",NumberPad6="NumberPad6",NumberPad7="NumberPad7",NumberPad8="NumberPad8",
	NumberPad9="NumberPad9",NumberPad0="NumberPad0",
	LeftArrow="LeftArrow",RightArrow="RightArrow",UpArrow="UpArrow",DownArrow="DownArrow",
	D1="D1",D2="D2",D3="D3",D4="D4",D5="D5",D6="D6",D7="D7",D8="D8",D9="D9",D0="D0",
	Grave="Grave",LeftBracket="LeftBracket",RightBracket="RightBracket",
}

CST.UI = {
	textbox = "textbox",
	label = "label",
	checkbox = "checkbox",
	dropdown = "dropdown"
}






