-- REQUIREMENTS ----------------------------------------------------------------


local csts = dofile("modmod.rte/ini/csts.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_object_tree(ast)
	local object_tree = {}

	for _, a in ipairs(ast) do
		if a.children ~= nil then
			local b = {}

			local children = M.get_object_tree(a.children)

			if #children > 0 then
				b.children = children
				b.collapsed = true
			end

			b.parent = a.parent
			b.property_index = a.property_index
			b.value_index = a.value_index

			for _, child in ipairs(a.children) do
				if csts.property(child) == "PresetName" then
					b.preset_name = csts.value(child)
					break
				end
			end

			table.insert(object_tree, b)
		end
	end

	return object_tree
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
