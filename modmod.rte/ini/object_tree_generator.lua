-- REQUIREMENTS ----------------------------------------------------------------


local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")

local csts = dofile("modmod.rte/ini/csts.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_object_tree(filepath)
	local ast = ast_generator.get_ast(filepath)
	return M._generate_object_tree(ast)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M._generate_object_tree(ast)
	local object_tree = {}

	for _, a in ipairs(ast) do
		if a.children ~= nil then
			local b = {}

			local children = M._generate_object_tree(a.children)

			if #children > 0 then
				b.children = children
				b.collapsed = true
			end

			b.property_pointer = a.property_pointer
			b.value_pointer = a.value_pointer

			for _, child in ipairs(a.children) do
				if csts.property(child) == "PresetName" then
					b.preset_name_pointer = child.value_pointer
					break
				end
			end

			table.insert(object_tree, b)
		end
	end

	return object_tree
end


-- MODULE END ------------------------------------------------------------------


return M;
