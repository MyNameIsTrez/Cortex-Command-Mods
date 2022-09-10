-- REQUIREMENTS ----------------------------------------------------------------


local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.test(test_type, test_name, result, expected)
	if not utils.deepequals(result, expected) then
		print("Result:")
		utils.RecursivelyPrint(result)
		print("Expected:")
		utils.RecursivelyPrint(expected)
		error(string.format("The '%s' test '%s' failed, report it to MyNameIsTrez#1585!", test_type, test_name))
	end
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
