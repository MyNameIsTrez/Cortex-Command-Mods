-- REQUIREMENTS ----------------------------------------------------------------

local file_functions = dofile("utils.rte/Modules/file_functions.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.write_ini_file_cst(file_cst, file_path)
	local lines = {}

	for _, object in ipairs(file_cst) do
		append_lines_recursively(object, lines)
	end

	local str = table.concat(lines)
	file_functions.write_file(file_path, str)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function append_lines_recursively(file_cst, lines)
	for _, token in ipairs(file_cst) do
		if token.type ~= "children" then
			table.insert(lines, token.content)
		elseif token.type == "children" then
			for _, sub_file_cst in ipairs(token.content) do
				append_lines_recursively(sub_file_cst, lines)
			end
		end
	end
end

-- MODULE END ------------------------------------------------------------------

return M
