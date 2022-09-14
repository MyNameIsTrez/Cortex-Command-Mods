-- REQUIREMENTS ----------------------------------------------------------------


local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
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
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] },
		{ property_pointer = cst[2][1], value_pointer = cst[2][5] }
	})
	cst = get_cst("lstripped_tab")
	ast_test("lstripped_tab", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] }
	})
	cst = get_cst("simple")
	ast_test("simple", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] }
	})
	ast_test("comments", {})
	cst = get_cst("nested")
	ast_test("nested", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6] }
		}}
	})
	cst = get_cst("multiple")
	ast_test("multiple", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6] }
		}},
		{ property_pointer = cst[2][1], value_pointer = cst[2][5], children = {
			{ property_pointer = cst[2][7].content[1][2], value_pointer = cst[2][7].content[1][6] }
		}}
	})
	cst = get_cst("complex")
	ast_test("complex", {
		{ property_pointer = cst[1][5], value_pointer = cst[1][9], children = {
			{ property_pointer = cst[1][12].content[1][2], value_pointer = cst[1][12].content[1][6] },
			{ property_pointer = cst[1][12].content[2][2], value_pointer = cst[1][12].content[2][6] },
			{ property_pointer = cst[1][12].content[3][2], value_pointer = cst[1][12].content[3][6] }
		}}
	})
	cst = get_cst("deindentation_1")
	ast_test("deindentation_1", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6] },
			{ property_pointer = cst[1][7].content[2][2], value_pointer = cst[1][7].content[2][6] },
			{ property_pointer = cst[1][7].content[3][2], value_pointer = cst[1][7].content[3][6] },
			{ property_pointer = cst[1][7].content[4][2], value_pointer = cst[1][7].content[4][6] },
			{ property_pointer = cst[1][7].content[5][2], value_pointer = cst[1][7].content[5][6] },
			{ property_pointer = cst[1][7].content[6][2], value_pointer = cst[1][7].content[6][6] }
		}}
	})
	cst = get_cst("deindentation_2")
	ast_test("deindentation_2", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6], children = {
				{ property_pointer = cst[1][7].content[1][8].content[1][2], value_pointer = cst[1][7].content[1][8].content[1][6] },
				{ property_pointer = cst[1][7].content[1][8].content[2][2], value_pointer = cst[1][7].content[1][8].content[2][6] },
				{ property_pointer = cst[1][7].content[1][8].content[3][2], value_pointer = cst[1][7].content[1][8].content[3][6] },
				{ property_pointer = cst[1][7].content[1][8].content[4][2], value_pointer = cst[1][7].content[1][8].content[4][6] },
				{ property_pointer = cst[1][7].content[1][8].content[5][2], value_pointer = cst[1][7].content[1][8].content[5][6] },
				{ property_pointer = cst[1][7].content[1][8].content[6][2], value_pointer = cst[1][7].content[1][8].content[6][6] }
			}}
		}}
	})
	cst = get_cst("deindentation_3")
	ast_test("deindentation_3", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6], children = {
				{ property_pointer = cst[1][7].content[1][8].content[1][2], value_pointer = cst[1][7].content[1][8].content[1][6] },
				{ property_pointer = cst[1][7].content[1][8].content[2][2], value_pointer = cst[1][7].content[1][8].content[2][6] },
				{ property_pointer = cst[1][7].content[1][8].content[3][2], value_pointer = cst[1][7].content[1][8].content[3][6] },
				{ property_pointer = cst[1][7].content[1][8].content[4][2], value_pointer = cst[1][7].content[1][8].content[4][6] },
				{ property_pointer = cst[1][7].content[1][8].content[5][2], value_pointer = cst[1][7].content[1][8].content[5][6] },
				{ property_pointer = cst[1][7].content[1][8].content[6][2], value_pointer = cst[1][7].content[1][8].content[6][6] }
			}}
		}}
	})
	cst = get_cst("spaces")
	ast_test("spaces", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] }
	})
	cst = get_cst("comment_before_tabs")
	ast_test("comment_before_tabs", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6], children = {
				{ property_pointer = cst[1][7].content[1][8].content[1][2], value_pointer = cst[1][7].content[1][8].content[1][6], children = {
					{ property_pointer = cst[1][7].content[1][8].content[1][8].content[1][3], value_pointer = cst[1][7].content[1][8].content[1][8].content[1][7] },
					{ property_pointer = cst[1][7].content[1][8].content[1][8].content[2][2], value_pointer = cst[1][7].content[1][8].content[1][8].content[2][6] }
				}}
			}}
		}}
	})
	cst = get_cst("comment_in_tabs")
	ast_test("comment_in_tabs", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5], children = {
			{ property_pointer = cst[1][7].content[1][2], value_pointer = cst[1][7].content[1][6], children = {
				{ property_pointer = cst[1][7].content[1][8].content[1][2], value_pointer = cst[1][7].content[1][8].content[1][6], children = {
					{ property_pointer = cst[1][7].content[1][8].content[1][8].content[1][4], value_pointer = cst[1][7].content[1][8].content[1][8].content[1][8] },
					{ property_pointer = cst[1][7].content[1][8].content[1][8].content[2][2], value_pointer = cst[1][7].content[1][8].content[1][8].content[2][6] }
				}}
			}}
		}}
	})
	cst = get_cst("spaces_at_start_of_line")
	ast_test("spaces_at_start_of_line", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] },
		{ property_pointer = cst[2][1], value_pointer = cst[2][5] }
	})
	cst = get_cst("datamodule")
	ast_test("datamodule", {
		{ property_pointer = cst[1][1], children = {
			{ property_pointer = cst[1][3].content[1][2], value_pointer = cst[1][3].content[1][6], children = {
				{ property_pointer = cst[1][3].content[1][8].content[1][2], value_pointer = cst[1][3].content[1][8].content[1][6] }
			}},
			{ property_pointer = cst[1][3].content[2][2], value_pointer = cst[1][3].content[2][6] },
		}}
	})
	cst = get_cst("value_on_next_line")
	ast_test("value_on_next_line", {
		{ property_pointer = cst[1][1], value_pointer = cst[1][5] },
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
