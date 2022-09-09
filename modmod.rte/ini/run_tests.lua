-- REQUIREMENTS ----------------------------------------------------------------


local tokenizer_tests = require("ini.tokenizer_tests")
local cst_tests = require("ini.cst_tests")
local ast_tests = require("ini.ast_tests")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


-- Use this to test this function:
-- run_tests, err = loadfile("modmod.rte/ini/run_tests.lua") run_tests().run()
function M.run()
	tokenizer_tests.tokenizer_tests()
	cst_tests.cst_tests()
	ast_tests.ast_tests()
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
