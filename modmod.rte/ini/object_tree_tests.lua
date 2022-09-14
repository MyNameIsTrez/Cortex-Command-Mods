-- REQUIREMENTS ----------------------------------------------------------------


local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")
local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local test_files = dofile("modmod.rte/ini/test_files.lua")

local tests = dofile("utils.rte/Modules/Tests.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.object_tree_tests()
	local ast

	object_tree_test("path", {})
	object_tree_test("lstripped_tab", {})
	object_tree_test("simple", {})
	object_tree_test("comments", {})
	ast = get_ast("nested")
	object_tree_test("nested", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
	})
	ast = get_ast("multiple")
	object_tree_test("multiple", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children },
		{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer, properties = ast[2].children }
	})
	ast = get_ast("complex")
	object_tree_test("complex", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, properties = ast[1].children }
	})
	ast = get_ast("deindentation_1")
	object_tree_test("deindentation_1", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
	})
	ast = get_ast("deindentation_2")
	object_tree_test("deindentation_2", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children }
		}}
	})
	ast = get_ast("deindentation_3")
	object_tree_test("deindentation_3", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children }
		}}
	})
	ast = get_ast("spaces")
	object_tree_test("spaces", {
	})
	ast = get_ast("comment_before_tabs")
	object_tree_test("comment_before_tabs", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
				{ property_pointer = ast[1].children[1].children[1].property_pointer, value_pointer = ast[1].children[1].children[1].value_pointer, properties = ast[1].children[1].children[1].children }
			}}
		}}
	})
	ast = get_ast("comment_in_tabs")
	object_tree_test("comment_in_tabs", {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
				{ property_pointer = ast[1].children[1].children[1].property_pointer, value_pointer = ast[1].children[1].children[1].value_pointer, properties = ast[1].children[1].children[1].children }
			}}
		}}
	})
	ast = get_ast("spaces_at_start_of_line")
	object_tree_test("spaces_at_start_of_line", {
	})
	ast = get_ast("datamodule")
	object_tree_test("datamodule", {
		{ property_pointer = ast[1].property_pointer, collapsed = true, properties = { ast[1].children[2] }, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children },
		}}
	})
	ast = get_ast("value_on_next_line")
	object_tree_test("value_on_next_line", {
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_ast(filename)
	local filepath = test_files.get_test_path_from_filename(filename)
	return ast_generator.get_ast(filepath)
end


function object_tree_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)
	local object_tree = object_tree_generator.get_object_tree(filepath)

	tests.test("object tree", filename, object_tree, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
