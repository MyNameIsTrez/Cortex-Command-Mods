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

	ast = get_ast("path")
	file_object_tree_test("path", { file_name = "path.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer }
	}})
	ast = get_ast("lstripped_tab")
	file_object_tree_test("lstripped_tab", { file_name = "lstripped_tab.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer }
	}})
	ast = get_ast("simple")
	file_object_tree_test("simple", { file_name = "simple.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer }
	}})
	ast = get_ast("comments")
	file_object_tree_test("comments", { file_name = "comments.ini" })
	ast = get_ast("nested")
	file_object_tree_test("nested", { file_name = "nested.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
	}})
	ast = get_ast("multiple")
	file_object_tree_test("multiple", { file_name = "multiple.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children },
		{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer, properties = ast[2].children }
	}})
	ast = get_ast("complex")
	file_object_tree_test("complex", { file_name = "complex.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, properties = ast[1].children }
	}})
	ast = get_ast("deindentation_1")
	file_object_tree_test("deindentation_1", { file_name = "deindentation_1.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
	}})
	ast = get_ast("deindentation_2")
	file_object_tree_test("deindentation_2", { file_name = "deindentation_2.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children }
		}}
	}})
	ast = get_ast("deindentation_3")
	file_object_tree_test("deindentation_3", { file_name = "deindentation_3.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, preset_name_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children }
		}}
	}})
	ast = get_ast("include_files")
	file_object_tree_test("include_files", { file_name = "include_files.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer }
	}})
	ast = get_ast("spaces")
	file_object_tree_test("spaces", { file_name = "spaces.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer }
	}})
	ast = get_ast("comment_before_tabs")
	file_object_tree_test("comment_before_tabs", { file_name = "comment_before_tabs.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
				{ property_pointer = ast[1].children[1].children[1].property_pointer, value_pointer = ast[1].children[1].children[1].value_pointer, properties = ast[1].children[1].children[1].children }
			}}
		}}
	}})
	ast = get_ast("comment_in_tabs")
	file_object_tree_test("comment_in_tabs", { file_name = "comment_in_tabs.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, collapsed = true, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, collapsed = true, children = {
				{ property_pointer = ast[1].children[1].children[1].property_pointer, value_pointer = ast[1].children[1].children[1].value_pointer, properties = ast[1].children[1].children[1].children }
			}}
		}}
	}})
	ast = get_ast("spaces_at_start_of_line")
	file_object_tree_test("spaces_at_start_of_line", { file_name = "spaces_at_start_of_line.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer }
	}})
	ast = get_ast("datamodule")
	file_object_tree_test("datamodule", { file_name = "datamodule.ini", collapsed = true, children = {
		{ property_pointer = ast[1].property_pointer, collapsed = true, properties = { ast[1].children[2] }, children = {
			{ property_pointer = ast[1].children[1].property_pointer, value_pointer = ast[1].children[1].value_pointer, properties = ast[1].children[1].children },
		}}
	}})
	ast = get_ast("value_on_next_line")
	file_object_tree_test("value_on_next_line", { file_name = "value_on_next_line.ini", properties = {
		{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer }
	}})
	ast = get_ast("object_and_property")
	file_object_tree_test("object_and_property", { file_name = "object_and_property.ini", collapsed = true, properties = {
			{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer }
		}, children = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer, properties = ast[1].children }
		}
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_ast(file_name)
	local filepath = test_files.get_test_path_from_file_name(file_name)
	return ast_generator.get_ast(filepath)
end


function file_object_tree_test(file_name, expected)
	local filepath = test_files.get_test_path_from_file_name(file_name)
	local object_tree = object_tree_generator.get_file_object_tree(filepath)

	tests.test("object tree", file_name, object_tree, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
