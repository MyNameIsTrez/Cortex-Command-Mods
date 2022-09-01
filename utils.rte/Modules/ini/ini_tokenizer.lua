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


number = l.C(
		l.P("-")^-1 *
		l.R("09")^0 *
		(
			l.P(".") *
			l.R("09")^0
		)^-1
	) /
	tonumber

space = l.S(" \t\n")^0

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
	-- pattern = ((l.P"A"^0) + (l.P"B"^0))
	-- print(pattern:match"ABA") -- Why is this 4 and not 3?

	-- pr(expr:match("2 * 3"))
	repl()
end

-- function pr(...)
-- 	-- print(table.concat(args, ","))

-- 	for i, v in ipairs({...}) do
-- 		print(v)
-- 	end
-- end

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

function repl()
	print(expr:match(" ( 2.5 *3) + 5"))
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
