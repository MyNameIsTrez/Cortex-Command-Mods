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


function M.file_object_tree_tests()
	local ast

	file_object_tree_test("path", {})
	file_object_tree_test("lstripped_tab", {})
	file_object_tree_test("simple", {})
	file_object_tree_test("comments", {})
	ast = get_ast("nested")
	file_object_tree_test("nested", { file_name = "nested", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
	}})
	ast = get_ast("multiple")
	file_object_tree_test("multiple", { file_name = "multiple", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children },
		{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer, properties = ast[2].children }
	}})
	ast = get_ast("complex")
	file_object_tree_test("complex", { file_name = "complex", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, properties = ast[1].children }
	}})
	ast = get_ast("deindentation_1")
	file_object_tree_test("deindentation_1", { file_name = "deindentation 1", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
	}})
	ast = get_ast("deindentation_2")
	file_object_tree_test("deindentation_2", { file_name = "deindentation 2", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children }
		}}
	}})
	ast = get_ast("deindentation_3")
	file_object_tree_test("deindentation_3", { file_name = "deindentation 3", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children }
		}}
	}})
	file_object_tree_test("spaces", {})
	ast = get_ast("comment_before_tabs")
	file_object_tree_test("comment_before_tabs", { file_name = "comment_before_tabs", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
				{ property_pointer = ast[1].children[1].children[1].property_pointer, value_pointer = ast[1].children[1].children[1].value_pointer, properties = ast[1].children[1].children[1].children }
			}}
		}}
	}})
	ast = get_ast("comment_in_tabs")
	file_object_tree_test("comment_in_tabs", { file_name = "comment_in_tabs", children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
				{ property_pointer = ast[1].children[1].children[1].property_pointer, value_pointer = ast[1].children[1].children[1].value_pointer, properties = ast[1].children[1].children[1].children }
			}}
		}}
	}})
	file_object_tree_test("spaces_at_start_of_line", {})
	ast = get_ast("datamodule")
	file_object_tree_test("datamodule", { file_name = "datamodule", children = {
		{ property_pointer = ast[1].property_pointer, collapsed = true, properties = { ast[1].children[2] }, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children },
		}}
	}})
	file_object_tree_test("value_on_next_line", {})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_ast(file_name)
	local filepath = test_files.get_test_path_from_file_name(file_name)
	return ast_generator.get_ast(filepath)
end


function file_object_tree_test(file_name, expected)
	local filepath = test_files.get_test_path_from_file_name(file_name)
	local object_tree = object_tree_generator.get_file_object_tree("modmod.rte/ini/ini_test_files", file_name)

	tests.test("object tree", file_name, object_tree, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
