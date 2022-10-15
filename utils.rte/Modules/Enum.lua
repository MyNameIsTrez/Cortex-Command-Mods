-- REQUIREMENTS ----------------------------------------------------------------

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.Enum(...)
	local enumTable = {}

	for index, name in ipairs({ ... }) do
		enumTable[name] = index
	end

	return enumTable
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
