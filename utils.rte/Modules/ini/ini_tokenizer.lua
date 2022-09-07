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
number = C(
		P("-")^-1 *
		digit^0 *
		(
			P(".") *
			digit^0
		)^-1
	) /
	tonumber
	* space

lparen = "(" * space
rparen = ")" * space
expr_op = C( S('+-') ) * space
term_op = C( S('*/') ) * space

expr = space * P{
	"EXPR";
	EXPR =
		V("TERM") * expr_op * V("EXPR") / eval +
		V("TERM") / eval,
	TERM =
		V("FACT") * term_op * V("TERM") / eval +
		V("FACT") / eval,
	FACT =
		lparen * V("EXPR") * rparen / eval +
		number / eval
}

function eval(num1, operator, num2)
	if operator == "+" then
		return num1 + num2
	elseif operator == "-" then
		return num1 - num2
	elseif operator == "*" then
		return num1 * num2
	elseif operator == "/" then
		return num1 / num2
	else
		return num1
	end
end

-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_tokenizer.lua") f().foo()
function M.foo()
	-- print(expr:match(" ( 2.5 *3) + -5"))

	assert(expr:match(" 1 + 2 ") == 3)
    assert(expr:match("1+2+3+4+5") == 15)
    assert(expr:match("2*3*4 + 5*6*7") == 234)
    assert(expr:match(" 1 * 2 + 3") == 5)
    assert(expr:match("( 2 +2) *6") == 24)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
