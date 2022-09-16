-- REQUIREMENTS ----------------------------------------------------------------


local ini_file_structure = dofile("modmod.rte/ini_file_structure.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_file_structure()
	return ini_file_structure
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
