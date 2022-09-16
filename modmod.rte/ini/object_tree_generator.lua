-- REQUIREMENTS ----------------------------------------------------------------


local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")
local csts = dofile("modmod.rte/ini/csts.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_object_tree(file_structure)
	object_tree = get_object_tree_recursively(file_structure)

	if utils.get_key_count(object_tree.children) == 0 then
		return object_tree.children
	else
		return object_tree
	end
end


function M.get_file_object_tree(filepath)
	local parent_directory, file_name = filepath:match("(.*)/(.*%.ini)")
	local filepath = parent_directory .. "/" .. file_name
	local ast = ast_generator.get_ast(filepath)

	local file_object_tree = { file_name = file_name, collapsed = true, children = generate_file_object_tree(ast) }

	if #file_object_tree.children == 0 then
		return file_object_tree.children
	else
		return file_object_tree
	end
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_object_tree_recursively(file_structure, parent_directory)
	parent_directory = parent_directory or "."

	local object_tree = {}
	object_tree.children = {}
	object_tree.directory_name = parent_directory
	object_tree.collapsed = true

	for k, v in pairs(file_structure) do
		if type(v) == "table" then
			table.insert(object_tree.children, get_object_tree_recursively(v, parent_directory .. "/" .. k))
			object_tree.children[#object_tree.children].directory_name = k
			object_tree.children[#object_tree.children].collapsed = true
		else
			table.insert(object_tree.children, M.get_file_object_tree(parent_directory, v))
		end
	end

	return object_tree
end


-- function get_full_cst(input_folder, subfolder_path)
-- function get_full_cst()
-- 	local file_structure = get_file_structure()

-- 	utils.RecursivelyPrint(file_structure)
-- end


-- function is_mod_folder_or_subfolder(path)

-- end


function get_file_structure()

end


function generate_file_object_tree(ast)
	local file_object_tree = {}

	for _, a in ipairs(ast) do
		if a.children ~= nil then
			local b = {}

			local children = generate_file_object_tree(a.children)

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

			table.insert(file_object_tree, b)
		end
	end

	return file_object_tree
end


-- MODULE END ------------------------------------------------------------------


return M;
