-- REQUIREMENTS ----------------------------------------------------------------

local cst_generator = dofile("modmod.rte/ini_object_tree/cst_generator.lua")
local ast_generator = dofile("modmod.rte/ini_object_tree/ast_generator.lua")
local file_object_generator = dofile("modmod.rte/ini_object_tree/file_object_generator.lua")

local test_files = dofile("modmod.rte/ini_object_tree/test_files.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.run_tests()
	local ast, cst

	cst = get_cst("comment_before_tabs")
	ast = get_ast("comment_before_tabs")
	ini_file_object_test("comment_before_tabs", {
		file_name = "comment_before_tabs.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				collapsed = true,
				children = {
					{
						property_pointer = ast[1].children[1].property_pointer,
						value_pointer = ast[1].children[1].value_pointer,
						collapsed = true,
						children = {
							{
								property_pointer = ast[1].children[1].children[1].property_pointer,
								value_pointer = ast[1].children[1].children[1].value_pointer,
								properties = ast[1].children[1].children[1].children,
							},
						},
					},
				},
			},
		},
	})
	cst = get_cst("comment_in_tabs")
	ast = get_ast("comment_in_tabs")
	ini_file_object_test("comment_in_tabs", {
		file_name = "comment_in_tabs.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				collapsed = true,
				children = {
					{
						property_pointer = ast[1].children[1].property_pointer,
						value_pointer = ast[1].children[1].value_pointer,
						collapsed = true,
						children = {
							{
								property_pointer = ast[1].children[1].children[1].property_pointer,
								value_pointer = ast[1].children[1].children[1].value_pointer,
								properties = ast[1].children[1].children[1].children,
							},
						},
					},
				},
			},
		},
	})
	cst = get_cst("comments")
	ini_file_object_test("comments", { file_name = "comments.ini", cst = cst })
	cst = get_cst("complex")
	ast = get_ast("complex")
	ini_file_object_test("complex", {
		file_name = "complex.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				preset_name_pointer = ast[1].children[1].value_pointer,
				properties = ast[1].children,
			},
		},
	})
	cst = get_cst("datamodule")
	ast = get_ast("datamodule")
	ini_file_object_test("datamodule", {
		file_name = "datamodule.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				collapsed = true,
				properties = { ast[1].children[2] },
				children = {
					{
						property_pointer = ast[1].children[1].property_pointer,
						value_pointer = ast[1].children[1].value_pointer,
						properties = ast[1].children[1].children,
					},
				},
			},
		},
	})
	cst = get_cst("deindentation_1")
	ast = get_ast("deindentation_1")
	ini_file_object_test("deindentation_1", {
		file_name = "deindentation_1.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				properties = ast[1].children,
			},
		},
	})
	cst = get_cst("deindentation_2")
	ast = get_ast("deindentation_2")
	ini_file_object_test("deindentation_2", {
		file_name = "deindentation_2.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				preset_name_pointer = ast[1].children[1].value_pointer,
				collapsed = true,
				children = {
					{
						property_pointer = ast[1].children[1].property_pointer,
						value_pointer = ast[1].children[1].value_pointer,
						properties = ast[1].children[1].children,
					},
				},
			},
		},
	})
	cst = get_cst("deindentation_3")
	ast = get_ast("deindentation_3")
	ini_file_object_test("deindentation_3", {
		file_name = "deindentation_3.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				preset_name_pointer = ast[1].children[1].value_pointer,
				collapsed = true,
				children = {
					{
						property_pointer = ast[1].children[1].property_pointer,
						value_pointer = ast[1].children[1].value_pointer,
						properties = ast[1].children[1].children,
					},
				},
			},
		},
	})
	cst = get_cst("include_files")
	ast = get_ast("include_files")
	ini_file_object_test("include_files", {
		file_name = "include_files.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
			{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer },
		},
	})

	-- This is expected to raise a "Too many tabs found" error.
	-- cst = get_cst("invalid_tabbing")
	-- ini_file_object_test("invalid_tabbing", { file_name = "invalid_tabbng.ini", cst = cst })

	cst = get_cst("lstripped_tab")
	ast = get_ast("lstripped_tab")
	ini_file_object_test("lstripped_tab", {
		file_name = "lstripped_tab.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		},
	})
	cst = get_cst("multiple")
	ast = get_ast("multiple")
	ini_file_object_test("multiple", {
		file_name = "multiple.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				properties = ast[1].children,
			},
			{
				property_pointer = ast[2].property_pointer,
				value_pointer = ast[2].value_pointer,
				properties = ast[2].children,
			},
		},
	})
	cst = get_cst("nested")
	ast = get_ast("nested")
	ini_file_object_test("nested", {
		file_name = "nested.ini",
		cst = cst,
		collapsed = true,
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				properties = ast[1].children,
			},
		},
	})
	cst = get_cst("object_and_property")
	ast = get_ast("object_and_property")
	ini_file_object_test("object_and_property", {
		file_name = "object_and_property.ini",
		cst = cst,
		collapsed = true,
		properties = {
			{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer },
		},
		children = {
			{
				property_pointer = ast[1].property_pointer,
				value_pointer = ast[1].value_pointer,
				properties = ast[1].children,
			},
		},
	})
	cst = get_cst("path")
	ast = get_ast("path")
	ini_file_object_test("path", {
		file_name = "path.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
			{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer },
		},
	})
	cst = get_cst("simple")
	ast = get_ast("simple")
	ini_file_object_test("simple", {
		file_name = "simple.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		},
	})
	cst = get_cst("spaces_at_start_of_line")
	ast = get_ast("spaces_at_start_of_line")
	ini_file_object_test("spaces_at_start_of_line", {
		file_name = "spaces_at_start_of_line.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
			{ property_pointer = ast[2].property_pointer, value_pointer = ast[2].value_pointer },
		},
	})
	cst = get_cst("spaces")
	ast = get_ast("spaces")
	ini_file_object_test("spaces", {
		file_name = "spaces.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		},
	})
	cst = get_cst("traditional")
	ini_file_object_test("traditional", { file_name = "traditional.ini", cst = cst })
	cst = get_cst("value_on_next_line")
	ast = get_ast("value_on_next_line")
	ini_file_object_test("value_on_next_line", {
		file_name = "value_on_next_line.ini",
		cst = cst,
		properties = {
			{ property_pointer = ast[1].property_pointer, value_pointer = ast[1].value_pointer },
		},
	})
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function get_ast(file_name)
	local file_path = test_files.get_test_path_from_file_name(file_name)
	return ast_generator.get_file_path_ast(file_path)
end

function ini_file_object_test(file_name, expected)
	local file_path = test_files.get_test_path_from_file_name(file_name)
	local ini = file_object_generator.get_file_object(file_path)

	-- tests.test("object tree", file_name, ini, expected)
end

-- MODULE END ------------------------------------------------------------------

return M
