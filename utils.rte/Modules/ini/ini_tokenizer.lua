-- REQUIREMENTS ----------------------------------------------------------------


-- local iniTokenizerTests = require("Modules.ini_tokenizer_tests")
local l = require("Modules.ini.lulpeg")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------


local S = l.S
local C = l.C
local P = l.P
local R = l.R
local V = l.V


-- PUBLIC FUNCTIONS ------------------------------------------------------------


space = S(" \t\n")^0

digit = R("09")
number =
	C(
		("-" + digit) *
		digit^0 *
		(
			P(".") *
			digit^0
		)^-1
	)
	* space

expr_op = C( S('+-') ) * space
term_op = C( S('*/') ) * space

expr = space * P{
	"EXPR";
	EXPR = V("TERM") * ( ( expr_op * V("TERM") )^0 ),
	TERM = V("FACT") * ( ( term_op * V("FACT") )^0 ),
	FACT = number
}

-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_tokenizer.lua") f().foo()
function M.foo()
	local a, b, c, d, e, f, g = expr:match("2 * 3 * 4 + 5 * 6 * 7")
	print(a)
	print(b)
	print(c)
	print(d)
	print(e)
	print(f)
	print(g)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
