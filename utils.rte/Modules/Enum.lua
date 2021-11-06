-- REQUIREMENTS ----------------------------------------------------------------





-- MODULE START ----------------------------------------------------------------


local M = {};
Enum = M;



-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.Enum(...)
	local enumTable = {};

	for _, name in ipairs({...}) do
		enumTable[name] = name;
	end

	return enumTable;
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;