-- REQUIREMENTS ----------------------------------------------------------------


local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
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
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] }
	})
	cst = get_cst("multiple")
	object_tree_test("multiple", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] },
		{ property_pointer = cst[2][1], value_pointer = cst[2][5] }
	})
	cst = get_cst("complex")
	object_tree_test("complex", {
		{ property_pointer = cst[1][5], value_pointer = cst[1][9], preset_name_pointer = cst[1][12].content[1][6] }
	})
	cst = get_cst("deindentation_1")
	object_tree_test("deindentation_1", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] }
	})
	cst = get_cst("deindentation_2")
	object_tree_test("deindentation_2", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], preset_name_pointer = cst[1][7].content[1][6], collapsed = true, children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6] }
		}}
	})
	cst = get_cst("deindentation_3")
	object_tree_test("deindentation_3", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], preset_name_pointer = cst[1][7].content[1][6], collapsed = true, children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6] }
		}}
	})
	cst = get_cst("spaces")
	object_tree_test("spaces", {
	})
	cst = get_cst("comment_before_tabs")
	object_tree_test("comment_before_tabs", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], collapsed = true, children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6], collapsed = true, children = {
				{ property_pointer = cst[1][7].content[1][8].content[1][2], value_pointer = cst[1][7].content[1][8].content[1][6] }
			}}
		}}
	})
	cst = get_cst("comment_in_tabs")
	object_tree_test("comment_in_tabs", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], collapsed = true, children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6], collapsed = true, children = {
				{ property_pointer = cst[1][7].content[1][8].content[1][2], value_pointer = cst[1][7].content[1][8].content[1][6] }
			}}
		}}
	})
	cst = get_cst("spaces_at_start_of_line")
	object_tree_test("spaces_at_start_of_line", {
	})
	cst = get_cst("datamodule")
	object_tree_test("datamodule", {
		{ property_pointer = cst[1][1], collapsed = true, children = {
			{ property_pointer = cst[1][3].content[1][2], value_pointer = cst[1][3].content[1][6] },
		}}
	})
	cst = get_cst("value_on_next_line")
	object_tree_test("value_on_next_line", {
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_cst(filename)
	local filepath = test_files.get_test_path_from_filename(filename)
	return cst_generator.get_cst(filepath)
end


function object_tree_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)
	local object_tree = object_tree_generator.get_object_tree(filepath)

	tests.test("object tree", filename, object_tree, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
