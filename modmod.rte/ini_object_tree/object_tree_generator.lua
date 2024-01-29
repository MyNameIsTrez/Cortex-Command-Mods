-- REQUIREMENTS ----------------------------------------------------------------

local cst_generator = dofile("modmod.rte/ini_object_tree/cst_generator.lua")
local ast_generator = dofile("modmod.rte/ini_object_tree/ast_generator.lua")

local csts = dofile("modmod.rte/ini_object_tree/csts.lua")

local utils = dofile("utils.rte/Modules/utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.get_file_object_tree(file_path)
	local cst = cst_generator.get_cst(file_path)
	local ast = ast_generator.get_ast(cst)

	local inner_file_object_tree = generate_inner_file_object_tree(ast)

	local parent_directory_path, file_name = file_path:match("(.*)/(.*%.ini)")
	local file_object_tree = { file_name = file_name, cst = cst }

	if ast_is_traditional_ini(ast) then
		return file_object_tree
	end

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
				if csts.get_property(child) == "PresetName" then
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

function ast_is_traditional_ini(ast)
	local property

	for _, v in ipairs(ast) do
		property = csts.get_property(v)

		if property:sub(1, 1) == "[" and property:sub(-1, -1) == "]" then
			return true
		end
	end

	return false
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

return M
