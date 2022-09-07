-- REQUIREMENTS ----------------------------------------------------------------


-- local iniTokenizerTests = require("Modules.ini_tokenizer_tests")
local l = require("Modules.ini.lulpeg")
local utils = require("Modules.Utils")


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
local Ct = l.Ct
local Cc = l.Cc


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
	/ tonumber
	* space

expr_op = C( S('+-') ) * space
term_op = C( S('*/') ) * space

expr = space * P{
	"EXPR";
	EXPR = Ct( Cc("expr") * V("TERM") * ( expr_op * V("TERM") )^0 ),
	TERM = Ct( Cc("term") * V("FACT") * ( term_op * V("FACT") )^0 ),
	FACT = number
}

-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_tokenizer.lua") f().foo()
function M.foo()
	local x = expr:match("2 + 3")
	utils.RecursivelyPrint(x)
	print(type(x[2][2]))
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
