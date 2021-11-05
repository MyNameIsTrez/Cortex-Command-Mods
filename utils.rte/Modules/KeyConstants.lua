-- REQUIREMENTS ----------------------------------------------------------------





-- MODULE START ----------------------------------------------------------------


local P = {};
_G[...] = P; -- ... is the module's name


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------


-- Inspiration:
-- http://wiki.datarealms.com/Keylist
-- https://github.com/liballeg/allegro5/blob/master/include/allegro5/keycodes.h
P.Keys = {
	A = 1,
	B = 2,
	C = 3,
	D = 4,
	E = 5,
	F = 6,
	G = 7,
	H = 8,
	I = 9,
	J = 10,
	K = 11,
	L = 12,
	M = 13,
	N = 14,
	O = 15,
	P = 16,
	Q = 17,
	R = 18,
	S = 19,
	T = 20,
	U = 21,
	V = 22,
	W = 23,
	X = 24,
	Y = 25,
	Z = 26,
	Zero = 27,
	One = 28,
	Two = 29,
	Three = 30,
	Four = 31,
	Five = 32,
	Six = 33,
	Seven = 34,
	Eight = 35,
	Nine = 36,
	NumpadZero = 37,
	NumpadOne = 38,
	NumpadTwo = 39,
	NumpadThree = 40,
	NumpadFour = 41,
	NumpadFive = 42,
	NumpadSix = 43,
	NumpadSeven = 44,
	NumpadEight = 45,
	NumpadNine = 46,
	F1 = 47,
	F2 = 48,
	F3 = 49,
	F4 = 50,
	F5 = 51,
	F6 = 52,
	F7 = 53,
	F8 = 54,
	F9 = 55,
	F10 = 56,
	F11 = 57,
	F12 = 58,
	Esc = 59,
	Grave = 60,
	Minus = 61,
	Equals = 62,
	Backspace = 63,
	Tab = 64,
	OpenBracket = 65,
	CloseBracket = 66,
	Enter = 67,
	Apostrophe = 69,
	Backslash = 70,
	-- Less than(<) / Greater than(>) = 71 but I have no clue how these are typed without the Shift key being recognized by CCCP
	Comma = 72,
	Period = 73,
	Slash = 74,
	Spacebar = 75,
	Insert = 76,
	Delete = 77,
	Pos1 = 78,
	End = 79,
	PageUp = 80,
	PageDown = 81,
	ArrowLeft = 82,
	ArrowRight = 83,
	ArrowUp = 84,
	ArrowDown = 85,
	NumpadSlash = 86,
	NumpadAsterisk = 87,
	NumpadMinus = 88,
	NumpadPlus = 89,
	NumpadPeriod = 90,
	NumpadEnter = 91,
};


-- INTERNAL PRIVATE VARIABLES --------------------------------------------------


-- local keysFromIDs = {
-- 	"A",
-- 	"B",
-- 	"C",
-- 	"D",
-- 	"E",
-- 	"F",
-- 	"G",
-- 	"H",
-- 	"I",
-- 	"J",
-- 	"K",
-- 	"L",
-- 	"M",
-- 	"N",
-- 	"O",
-- 	"P",
-- 	"Q",
-- 	"R",
-- 	"S",
-- 	"T",
-- 	"U",
-- 	"V",
-- 	"W",
-- 	"X",
-- 	"Y",
-- 	"Z",
-- 	"Zero",
-- 	"One",
-- 	"Two",
-- 	"Three",
-- 	"Four",
-- 	"Five",
-- 	"Six",
-- 	"Seven",
-- 	"Eight",
-- 	"Nine",
-- 	"NumpadZero",
-- 	"NumpadOne",
-- 	"NumpadTwo",
-- 	"NumpadThree",
-- 	"NumpadFour",
-- 	"NumpadFive",
-- 	"NumpadSix",
-- 	"NumpadSeven",
-- 	"NumpadEight",
-- 	"NumpadNine",
-- 	"F1",
-- 	"F2",
-- 	"F3",
-- 	"F4",
-- 	"F5",
-- 	"F6",
-- 	"F7",
-- 	"F8",
-- 	"F9",
-- 	"F10",
-- 	"F11",
-- 	"F12",
-- 	"Esc",
-- 	"Grave",
-- 	"Minus",
-- 	"Equals",
-- 	"Backspace",
-- 	"Tab",
-- 	"OpenBracket",
-- 	"CloseBracket",
-- 	"Enter",
-- 	nil,
-- 	"Apostrophe",
-- 	"Backslash",
-- 	nil,-- Less than(<) / Greater than(>) but I have no clue how these are typed without the Shift key being recognized by CCCP
-- 	"Comma",
-- 	"Period",
-- 	"Slash",
-- 	"Spacebar",
-- 	"Insert",
-- 	"Delete",
-- 	"Pos1",
-- 	"End",
-- 	"PageUp",
-- 	"PageDown",
-- 	"ArrowLeft",
-- 	"ArrowRight",
-- 	"ArrowUp",
-- 	"ArrowDown",
-- 	"NumpadSlash",
-- 	"NumpadAsterisk",
-- 	"NumpadMinus",
-- 	"NumpadPlus",
-- 	"NumpadPeriod",
-- 	"NumpadEnter",
-- };


-- PUBLIC FUNCTIONS ------------------------------------------------------------


-- function P.GetKeyNameHeld()
-- 	return keysFromIDs[UInputMan:WhichKeyHeld()];
-- end


-- PRIVATE FUNCTIONS  ----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return P;