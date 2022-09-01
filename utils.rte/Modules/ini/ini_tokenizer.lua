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


-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_tokenizer.lua") f().foo()
function M.foo()
	n = l.C(
			l.P("-")^-1 *
			l.R("09")^0 *
			(
				l.P(".") *
				l.R("09")^0
			)^-1
		) /
		tonumber

	print(n:match("53"))
	print(n:match("-17"))
	print(n:match("5.02"))
	print(n:match(".3"))
	print(n:match("7."))
	print(n:match("a"))
end

function pr(args)
	-- print(args)
	-- if (args[1] == nil) then return end
	-- print(table.concat(args, ","))

	-- if (args == nil) then return end
	-- print(args["negative"])
	-- print(args["ipart"])
	-- print(args["fpart"])
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
