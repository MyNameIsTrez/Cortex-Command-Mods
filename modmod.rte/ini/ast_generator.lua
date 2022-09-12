-- REQUIREMENTS ----------------------------------------------------------------





-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_ast(cst)
	local ast = {}

	for _, a in ipairs(cst) do
		local b = {}

		b.parent = a

		for i, c in ipairs(a) do
			if c.type == "property" then
				b.property_index = i
				break
			end
		end
		for i, c in ipairs(a) do
			if c.type == "value" then
				b.value_index = i
				break
			end
		end
		for _, c in ipairs(a) do
			if c.type == "children" then
				b.children = M.get_ast(c.content)
				break
			end
		end

		if b.property_index ~= nil then
			table.insert(ast, b)
		end
	end

	return ast
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
