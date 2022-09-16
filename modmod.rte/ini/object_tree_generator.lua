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


function M.get_object_tree(file_structure, parent_path)
	parent_path = parent_path or "."

	local object_tree = {}

	for k, v in pairs(file_structure) do
		if type(v) == "table" then
			object_tree[k] = M.get_object_tree(v, parent_path .. "/" .. k)
		else
			object_tree[v] = M.get_file_object_tree(parent_path .. "/" .. v)
		end
	end

	return object_tree
end


-- function M.get_file_object_tree(path)
function M.get_file_object_tree(filepath)
	local ast = ast_generator.get_ast(filepath)
	return generate_object_tree(ast)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


-- function get_full_cst(input_folder, subfolder_path)
-- function get_full_cst()
-- 	local file_structure = get_file_structure()

-- 	utils.RecursivelyPrint(file_structure)
-- end


-- function is_mod_folder_or_subfolder(path)

-- end


function get_file_structure()

end


function generate_object_tree(ast)
	local object_tree = {}

	for _, a in ipairs(ast) do
		if a.children ~= nil then
			local b = {}

			local children = generate_object_tree(a.children)

			if #children > 0 then
				b.children = children
				b.collapsed = true
			end

			b.property_pointer = a.property_pointer
			b.value_pointer = a.value_pointer

			b.properties = {}

			for _, child in ipairs(a.children) do
				if csts.property(child) == "PresetName" then
					b.preset_name_pointer = child.value_pointer
				end
				if child.children == nil then
					table.insert(b.properties, child)
				end
			end

			if #b.properties == 0 then
				b.properties = nil
			end

			table.insert(object_tree, b)
		end
	end

	return object_tree
end


-- MODULE END ------------------------------------------------------------------


return M;
