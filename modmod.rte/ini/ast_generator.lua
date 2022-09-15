-- REQUIREMENTS ----------------------------------------------------------------


local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_ast(filepath)
	local cst = cst_generator.get_cst(filepath)
	return generate_ast(cst)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function generate_ast(cst)
	local ast = {}

	for _, a in ipairs(cst) do
		local b = {}

		for i, c in ipairs(a) do
			if c.type == "property" then
				b.property_pointer = a[i]
				break
			end
		end
		for i, c in ipairs(a) do
			if c.type == "value" then
				b.value_pointer = a[i]
				break
			end
		end
		for _, c in ipairs(a) do
			if c.type == "children" then
				b.children = generate_ast(c.content)
				break
			end
		end

		if b.property_pointer ~= nil then
			table.insert(ast, b)
		end
	end

	return ast
end


-- MODULE END ------------------------------------------------------------------


return M;
