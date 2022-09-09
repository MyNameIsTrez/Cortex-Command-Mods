-- REQUIREMENTS ----------------------------------------------------------------





-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_test_path_from_filename(filename)
	return string.format("modmod.rte/ini/ini_test_files/%s.ini", filename)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
