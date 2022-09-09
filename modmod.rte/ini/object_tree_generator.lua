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
		local b = {
			property = a.property,
			value = a.value
		}

		if a.children ~= nil then
			local children = M.get_object_tree(a.children)
			if #children > 0 then
				b.children = children
			end
			table.insert(object_tree, b)
		end
	end

	return object_tree
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
