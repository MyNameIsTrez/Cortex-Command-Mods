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
	parent_directory, file_name = filepath:match("(.*)/(.*%.ini)")

	local filepath = parent_directory .. "/" .. file_name
	local ast = ast_generator.get_ast(filepath)

	local inner_file_object_tree = generate_inner_file_object_tree(ast)

	local file_object_tree = { file_name = file_name }

	if ast_has_children(ast) then
		file_object_tree.collapsed = true
		file_object_tree.children = inner_file_object_tree
	end

	local properties = ast_get_properties(ast)
	if #properties > 0 then
		file_object_tree.properties = properties
	end

	return file_object_tree
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
			table.insert(object_tree.children, M.get_file_object_tree(parent_directory .. "/" .. v))
		end
	end

	return object_tree
end


function generate_inner_file_object_tree(ast)
	local file_object_tree = {}

	for _, a in ipairs(ast) do
		if a.children ~= nil then
			local b = {}

			local children = generate_inner_file_object_tree(a.children)

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


function ast_has_children(ast)
	for _, v in ipairs(ast) do
		if v.children ~= nil then
			return true
		end
	end

	return false
end


function ast_get_properties(ast)
	local properties = {}

	for _, v in ipairs(ast) do
		if v.children == nil then
			table.insert(properties, v)
		end
	end

	return properties
end


-- MODULE END ------------------------------------------------------------------


return M;
