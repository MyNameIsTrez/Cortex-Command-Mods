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
	object_tree_test("lstripped_tab", {
		{}
	})
	object_tree_test("simple", {
		{}
	})
	object_tree_test("comments", {
		{}
	})
	object_tree_test("nested", {
		{ property = "Foo", value = "Bar", children = {
			{}
		}}
	})
	object_tree_test("multiple", {
		{ property = "Foo", value = "Bar", children = {
			{}
		}},
		{ property = "A", value = "B", children = {
			{}
		}}
	})
	object_tree_test("complex", {
		{ property = "AddEffect", value = "MOPixel", children = {
			{ property = "PresetName", value = "red_dot_tiny", children = {
				{},
				{}
			}}
		}}
	})
	object_tree_test("deindentation_1", {
		{ property = "PresetName", value = "Foo", children = {
			{},
			{},
			{},
			{},
			{},
			{}
		}}
	})
	object_tree_test("deindentation_2", {
		{ property = "AddEffect", value = "MOPixel", children = {
			{ property = "PresetName", value = "Foo", children = {
				{},
				{},
				{},
				{},
				{},
				{}
			}}
		}}
	})
	object_tree_test("deindentation_3", {
		{ property = "AddEffect", value = "MOPixel", children = {
			{ property = "PresetName", value = "Foo", children = {
				{},
				{},
				{},
				{},
				{},
				{}
			}}
		}}
	})
	object_tree_test("spaces", {
		{}
	})
	object_tree_test("comment_before_tabs", {
		{ property = "A1", value = "A2", children = {
			{ property = "B1", value = "B2", children = {
				{ property = "C1", value = "C2", children = {
					{},
					{}
				}}
			}}
		}}
	})
	object_tree_test("comment_in_tabs", {
		{ property = "A1", value = "A2", children = {
			{ property = "B1", value = "B2", children = {
				{ property = "C1", value = "C2", children = {
					{},
					{}
				}}
			}}
		}}
	})
	object_tree_test("spaces_at_start_of_line", {
		{},
		{}
	})
	object_tree_test("datamodule", {
		{ property = "DataModule", children = {
			{ property = "IconFile", value = "ContentFile", children = {
				{}
			}},
			{}
		}}
	})
	object_tree_test("value_on_next_line", {
		{}
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function object_tree_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)

	local tokens = tokens_generator.get_tokens(filepath)
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)
	local object_tree = object_tree_generator.get_object_tree(ast)

	tests.test(filename, object_tree, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
