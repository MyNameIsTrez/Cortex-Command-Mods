-- REQUIREMENTS ----------------------------------------------------------------


-- local iniTokenizerTests = require("Modules.ini_tokenizer_tests")
local l = require("Modules.ini.lulpeg")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


space = l.S(" \t\n")^0

number = l.C(
		l.P("-")^-1 *
		l.R("09")^0 *
		(
			l.P(".") *
			l.R("09")^0
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

expr = l.P{
	"EXPR";
	EXPR = ( l.V("TERM") * l.C( l.S("+-") ) * l.V("EXPR") +
			 l.V("TERM") ) / eval,
	TERM = ( l.V("FACT") * l.C( l.S("/*") ) * l.V("TERM") +
			 l.V("FACT") ) / eval,
	FACT = ( space * "(" * l.V("EXPR") * ")" * space +
			 space * number * space ) / eval
}

-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_tokenizer.lua") f().foo()
function M.foo()
	print(expr:match(" ( 2.5 *3) + 5"))
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
