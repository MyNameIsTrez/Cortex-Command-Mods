-- REQUIREMENTS ----------------------------------------------------------------


local ini_tokenizer_tests = require("Modules.ini.ini_tokenizer_tests")
local ini_cst_tests = require("Modules.ini.ini_cst_tests")
-- local ini_ast_tests = require("Modules.ini.ini_ast_tests")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


-- Use this to test this function:
-- run_tests, err = loadfile("utils.rte/Modules/run_tests.lua") run_tests().run()
function M.run()
	ini_tokenizer_tests.tokenizer_tests()
	ini_cst_tests.cst_tests()
	-- ini_ast_tests.ast_tests()
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
