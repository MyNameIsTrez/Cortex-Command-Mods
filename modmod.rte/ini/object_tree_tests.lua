-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
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
	local cst

	cst = get_cst("path")
	object_tree_test("path", {
	})
	cst = get_cst("lstripped_tab")
	object_tree_test("lstripped_tab", {
	})
	cst = get_cst("simple")
	object_tree_test("simple", {
	})
	cst = get_cst("comments")
	object_tree_test("comments", {
	})
	cst = get_cst("nested")
	object_tree_test("nested", {
		{ parent = cst[1], property_index = 1, value_index = 5 }
	})
	cst = get_cst("multiple")
	object_tree_test("multiple", {
		{ parent = cst[1], property_index = 1, value_index = 5 },
		{ parent = cst[2], property_index = 1, value_index = 5 }
	})
	cst = get_cst("complex")
	object_tree_test("complex", {
		{ parent = cst[1], property_index = 5, value_index = 9, preset_name = "red_dot_tiny"}
	})
	cst = get_cst("deindentation_1")
	object_tree_test("deindentation_1", {
		{ parent = cst[1], property_index = 1, value_index = 5 }
	})
	cst = get_cst("deindentation_2")
	object_tree_test("deindentation_2", {
		{ parent = cst[1], property_index = 1, value_index = 5, preset_name = "Foo", collapsed = true, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6 }
		}}
	})
	cst = get_cst("deindentation_3")
	object_tree_test("deindentation_3", {
		{ parent = cst[1], property_index = 1, value_index = 5, preset_name = "Foo", collapsed = true, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6 }
		}}
	})
	cst = get_cst("spaces")
	object_tree_test("spaces", {
	})
	cst = get_cst("comment_before_tabs")
	object_tree_test("comment_before_tabs", {
		{ parent = cst[1], property_index = 1, value_index = 5, collapsed = true, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6, collapsed = true, children = {
				{ parent = cst[1][7].content[1][8].content[1], property_index = 2, value_index = 6 }
			}}
		}}
	})
	cst = get_cst("comment_in_tabs")
	object_tree_test("comment_in_tabs", {
		{ parent = cst[1], property_index = 1, value_index = 5, collapsed = true, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6, collapsed = true, children = {
				{ parent = cst[1][7].content[1][8].content[1], property_index = 2, value_index = 6 }
			}}
		}}
	})
	cst = get_cst("spaces_at_start_of_line")
	object_tree_test("spaces_at_start_of_line", {
	})
	cst = get_cst("datamodule")
	object_tree_test("datamodule", {
		{ parent = cst[1], property_index = 1, collapsed = true, children = {
			{ parent = cst[1][3].content[1], property_index = 2, value_index = 6 },
		}}
	})
	cst = get_cst("value_on_next_line")
	object_tree_test("value_on_next_line", {
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function object_tree_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)

	local tokens = tokens_generator.get_tokens(filepath)
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)
	local object_tree = object_tree_generator.get_object_tree(ast)

	tests.test("object tree", filename, object_tree, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
