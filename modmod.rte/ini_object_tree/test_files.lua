-- REQUIREMENTS ----------------------------------------------------------------

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.get_test_path_from_file_name(file_name)
	return string.format("modmod.rte/ini_object_tree/ini_test_files/%s.ini_test", file_name)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
