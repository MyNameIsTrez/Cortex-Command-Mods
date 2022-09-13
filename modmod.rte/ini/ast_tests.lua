-- REQUIREMENTS ----------------------------------------------------------------


local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")

local test_files = dofile("modmod.rte/ini/test_files.lua")

local tests = dofile("utils.rte/Modules/Tests.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.ast_tests()
	local cst

	cst = get_cst("path")
	ast_test("path", {
		{ parent = cst[1], property_index = 1, value_index = 5 },
		{ parent = cst[2], property_index = 1, value_index = 5 }
	})
	cst = get_cst("lstripped_tab")
	ast_test("lstripped_tab", {
		{ parent = cst[1], property_index = 1, value_index = 5 }
	})
	cst = get_cst("simple")
	ast_test("simple", {
		{ parent = cst[1], property_index = 1, value_index = 5 }
	})
	cst = get_cst("comments")
	ast_test("comments", {
	})
	cst = get_cst("nested")
	ast_test("nested", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6 }
		}}
	})
	cst = get_cst("multiple")
	ast_test("multiple", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6 }
		}},
		{ parent = cst[2], property_index = 1, value_index = 5, children = {
			{ parent = cst[2][7].content[1], property_index = 2, value_index = 6 }
		}}
	})
	cst = get_cst("complex")
	ast_test("complex", {
		{ parent = cst[1], property_index = 5, value_index = 9, children = {
			{ parent = cst[1][12].content[1], property_index = 2, value_index = 6 },
			{ parent = cst[1][12].content[2], property_index = 2, value_index = 6 },
			{ parent = cst[1][12].content[3], property_index = 2, value_index = 6 }
		}}
	})
	cst = get_cst("deindentation_1")
	ast_test("deindentation_1", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6 },
			{ parent = cst[1][7].content[2], property_index = 2, value_index = 6 },
			{ parent = cst[1][7].content[3], property_index = 2, value_index = 6 },
			{ parent = cst[1][7].content[4], property_index = 2, value_index = 6 },
			{ parent = cst[1][7].content[5], property_index = 2, value_index = 6 },
			{ parent = cst[1][7].content[6], property_index = 2, value_index = 6 }
		}}
	})
	cst = get_cst("deindentation_2")
	ast_test("deindentation_2", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6, children = {
				{ parent = cst[1][7].content[1][8].content[1], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[2], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[3], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[4], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[5], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[6], property_index = 2, value_index = 6 }
			}}
		}}
	})
	cst = get_cst("deindentation_3")
	ast_test("deindentation_3", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6, children = {
				{ parent = cst[1][7].content[1][8].content[1], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[2], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[3], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[4], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[5], property_index = 2, value_index = 6 },
				{ parent = cst[1][7].content[1][8].content[6], property_index = 2, value_index = 6 }
			}}
		}}
	})
	cst = get_cst("spaces")
	ast_test("spaces", {
		{ parent = cst[1], property_index = 1, value_index = 5 }
	})
	cst = get_cst("comment_before_tabs")
	ast_test("comment_before_tabs", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6, children = {
				{ parent = cst[1][7].content[1][8].content[1], property_index = 2, value_index = 6, children = {
					{ parent = cst[1][7].content[1][8].content[1][8].content[1], property_index = 3, value_index = 7 },
					{ parent = cst[1][7].content[1][8].content[1][8].content[2], property_index = 2, value_index = 6 }
				}}
			}}
		}}
	})
	cst = get_cst("comment_in_tabs")
	ast_test("comment_in_tabs", {
		{ parent = cst[1], property_index = 1, value_index = 5, children = {
			{ parent = cst[1][7].content[1], property_index = 2, value_index = 6, children = {
				{ parent = cst[1][7].content[1][8].content[1], property_index = 2, value_index = 6, children = {
					{ parent = cst[1][7].content[1][8].content[1][8].content[1], property_index = 4, value_index = 8 },
					{ parent = cst[1][7].content[1][8].content[1][8].content[2], property_index = 2, value_index = 6 }
				}}
			}}
		}}
	})
	cst = get_cst("spaces_at_start_of_line")
	ast_test("spaces_at_start_of_line", {
		{ parent = cst[1], property_index = 1, value_index = 5 },
		{ parent = cst[2], property_index = 1, value_index = 5 }
	})
	cst = get_cst("datamodule")
	ast_test("datamodule", {
		{ parent = cst[1], property_index = 1, children = {
			{ parent = cst[1][3].content[1], property_index = 2, value_index = 6, children = {
				{ parent = cst[1][3].content[1][8].content[1], property_index = 2, value_index = 6 }
			}},
			{ parent = cst[1][3].content[2], property_index = 2, value_index = 6 },
		}}
	})
	cst = get_cst("value_on_next_line")
	ast_test("value_on_next_line", {
		{ parent = cst[1], property_index = 1, value_index = 5 },
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_cst(filename)
	local filepath = test_files.get_test_path_from_filename(filename)
	return cst_generator.get_cst(filepath)
end


function ast_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)
	local ast = ast_generator.get_ast(filepath)

	tests.test("ast", filename, ast, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
