-- REQUIREMENTS ----------------------------------------------------------------





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

			b.property = a.property
			b.value = a.value

			for _, child in ipairs(a.children) do
				if child.property == "PresetName" then
					b.preset_name = child.value
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
