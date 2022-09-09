-- REQUIREMENTS ----------------------------------------------------------------


local utils = require("Modules.Utils")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_test_path_from_filename(filename)
	return string.format("utils.rte/Modules/ini/ini_test_files/%s.ini", filename)
end


function M.test(test_name, result, expected)
	if not utils.deepequals(result, expected) then
		print("Result:")
		utils.RecursivelyPrint(result)
		print("Expected:")
		utils.RecursivelyPrint(expected)
		error(string.format("The test '%s' failed, report it to MyNameIsTrez#1585!", test_name))
	end
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
