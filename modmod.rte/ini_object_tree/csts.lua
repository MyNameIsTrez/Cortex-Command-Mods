-- REQUIREMENTS ----------------------------------------------------------------

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.get_property(ast)
	return ast.property_pointer.content
end

function M.get_value(ast)
	return ast.value_pointer.content
end

function M.set_property(ast, content)
	ast.property_pointer.content = content
end

function M.set_value(ast, content)
	ast.value_pointer.content = content
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
