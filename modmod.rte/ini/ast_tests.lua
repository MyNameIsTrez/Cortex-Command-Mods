-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
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
	ast_test("path", {
		{ property = "FilePath", value = "A/B" },
		{ property = "AirResistance", value = "0.05" }
	})
	ast_test("lstripped_tab", {
		{ property = "Foo", value = "Bar" }
	})
	ast_test("simple", {
		{ property = "AddEffect", value = "MOPixel" }
	})
	ast_test("comments", {
	})
	ast_test("nested", {
		{ property = "Foo", value = "Bar", children = {
			{ property = "Baz", value = "Bee" }
		}}
	})
	ast_test("multiple", {
		{ property = "Foo", value = "Bar", children = {
			{ property = "Baz", value = "Bee" }
		}},
		{ property = "A", value = "B", children = {
			{ property = "C", value = "D" }
		}}
	})
	ast_test("complex", {
		{ property = "AddEffect", value = "MOPixel", children = {
			{ property = "PresetName", value = "red_dot_tiny", children = {
				{ property = "Mass", value = "0.0" },
				{ property = "Xd", value = "42" }
			}}
		}}
	})
	ast_test("deindentation_1", {
		{ property = "PresetName", value = "Foo", children = {
			{ property = "A1", value = "X" },
			{ property = "A2", value = "X" },
			{ property = "B1", value = "X" },
			{ property = "B2", value = "X" },
			{ property = "C1", value = "X" },
			{ property = "C2", value = "X" }
		}}
	})
	ast_test("deindentation_2", {
		{ property = "AddEffect", value = "MOPixel", children = {
			{ property = "PresetName", value = "Foo", children = {
				{ property = "A1", value = "X" },
				{ property = "A2", value = "X" },
				{ property = "B1", value = "X" },
				{ property = "B2", value = "X" },
				{ property = "C1", value = "X" },
				{ property = "C2", value = "X" }
			}}
		}}
	})
	ast_test("deindentation_3", {
		{ property = "AddEffect", value = "MOPixel", children = {
			{ property = "PresetName", value = "Foo", children = {
				{ property = "A1", value = "X" },
				{ property = "A2", value = "X" },
				{ property = "B1", value = "X" },
				{ property = "B2", value = "X" },
				{ property = "C1", value = "X" },
				{ property = "C2", value = "X" }
			}}
		}}
	})
	ast_test("spaces", {
		{ property = "Foo", value = "Bar Baz" }
	})
	ast_test("comment_before_tabs", {
		{ property = "A1", value = "A2", children = {
			{ property = "B1", value = "B2", children = {
				{ property = "C1", value = "C2", children = {
					{ property = "D1", value = "D2" },
					{ property = "E1", value = "E2" }
				}}
			}}
		}}
	})
	ast_test("comment_in_tabs", {
		{ property = "A1", value = "A2", children = {
			{ property = "B1", value = "B2", children = {
				{ property = "C1", value = "C2", children = {
					{ property = "D1", value = "D2" },
					{ property = "E1", value = "E2" }
				}}
			}}
		}}
	})
	ast_test("spaces_at_start_of_line", {
		{ property = "Foo", value = "Bar" },
		{ property = "Baz", value = "Bee" }
	})
	ast_test("datamodule", {
		{ property = "DataModule", children = {
			{ property = "IconFile", value = "ContentFile", children = {
				{ property = "FilePath", value = "Foo" }
			}},
			{ property = "ModuleName", value = "Bar" }
		}}
	})
	ast_test("value_on_next_line", {
		{ property = "Foo", value = "Bar" }
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function ast_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)

	local tokens = tokens_generator.get_tokens(filepath)
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)

	tests.test("ast", filename, ast, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
