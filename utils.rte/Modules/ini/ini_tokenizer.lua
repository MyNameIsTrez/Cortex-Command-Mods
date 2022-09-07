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

number = C(
		P("-")^-1 *
		R("09")^0 *
		(
			P(".") *
			R("09")^0
		)^-1
	) /
	tonumber

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

expr = P{
	"EXPR";
	EXPR = ( V("TERM") * C( S("+-") ) * V("EXPR") +
			 V("TERM") ) / eval,
	TERM = ( V("FACT") * C( S("/*") ) * V("TERM") +
			 V("FACT") ) / eval,
	FACT = ( space * "(" * V("EXPR") * ")" * space +
			 space * number * space ) / eval
}

-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_tokenizer.lua") f().foo()
function M.foo()
	print(expr:match(" ( 2.5 *3) + -5"))
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
