-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")

local test_files = dofile("modmod.rte/ini/test_files.lua")

local tests = dofile("utils.rte/Modules/Tests.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.cst_tests()
	-- cst_test("invalid_tabbing", {}) -- This is expected to raise a "Too many tabs found" error.

	cst_test("path", {
		{
			{ type = "property", content = "FilePath" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "A/B" }, { type = "extra", content = "\n" }
		},
		{
			{ type = "property", content = "AirResistance" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "0.05" }, { type = "extra", content = "\n" }
		}
	})
	cst_test("lstripped_tab", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" },
		}
	})
	cst_test("simple", {
		{
			{ type = "property", content = "AddEffect" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "MOPixel" },
		}
	})
	cst_test("comments", {
		{
			{ type = "extra", content = "// foo"}, { type = "extra", content = "\n" },
			{ type = "extra", content = "/*a\nb\nc*/" }, { type = "extra", content = "\n" },
		},
	})
	cst_test("nested", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "Baz" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bee" }, { type = "extra", content = "\n" },
				}
			}}
		}
	})
	cst_test("multiple", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "Baz" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bee" }, { type = "extra", content = "\n" },
				}
			}}
		},
		{
			{ type = "property", content = "A" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "B" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "C" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "D" }, { type = "extra", content = "\n" },
				}
			}}
		}
	})
	cst_test("complex", {
		{
			{ type = "extra", content = "// foo"}, { type = "extra", content = "\n" },
			{ type = "extra", content = "/*a\nb\nc*/" }, { type = "extra", content = "\n" },
			{ type = "property", content = "AddEffect" }, { type = "extra", content = "  " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "MOPixel" }, { type = "extra", content = "//bar" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "PresetName" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = "  " }, { type = "value", content = "red_dot_tiny" }, { type = "extra", content = "\n" },
					{ type = "children", content = {
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "Mass" }, { type = "extra", content = "  " }, { type = "extra", content = "=" }, { type = "extra", content = "  " }, { type = "value", content = "0.0" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "Xd" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "42" },
						}
					}}
				}
			}}
		}
	})
	cst_test("deindentation_1", {
		{
			{ type = "property", content = "PresetName" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Foo" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "A1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n\n" },
				},
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "A2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
				},
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "B1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
					{ type = "extra", content = " " }, { type = "extra", content = "\n" },
				},
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "B2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
				},
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "C1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
					{ type = "extra", content = "//foo" }, { type = "extra", content = "\n" },
				},
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "C2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" },
				}
			}}
		}
	})
	cst_test("deindentation_2", {
		{
			{ type = "property", content = "AddEffect" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "MOPixel" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "PresetName" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Foo" }, { type = "extra", content = "\n" },
					{ type = "children", content = {
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "A1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "A2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "B1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
							{ type = "extra", content = " " }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "B2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "C1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
							{ type = "extra", content = "//foo" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "C2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" },
						}
					}}
				}
			}}
		}
	})
	cst_test("deindentation_3", {
		{
			{ type = "property", content = "AddEffect" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "MOPixel" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "PresetName" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Foo" }, { type = "extra", content = "\n" },
					{ type = "children", content = {
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "A1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
							{ type = "extra", content = "\t" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "A2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "B1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
							{ type = "extra", content = "\t" }, { type = "extra", content = " " }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "B2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "C1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" }, { type = "extra", content = "\n" },
							{ type = "extra", content = "\t" }, { type = "extra", content = "//foo" }, { type = "extra", content = "\n" },
						},
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "C2" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "X" },
						}
					}}
				}
			}}
		}
	})
	cst_test("spaces", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar Baz" },
		}
	})
	cst_test("comment_before_tabs", {
		{
			{ type = "property", content = "A1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "A2" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "B1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "B2" }, { type = "extra", content = "\n" },
					{ type = "children", content = {
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "C1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "C2" }, { type = "extra", content = "\n" },
							{ type = "children", content = {
								{
									{ type = "extra", content = "/*foo*/" }, { type = "extra", content = "\t\t\t" }, { type = "property", content = "D1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "D2" }, { type = "extra", content = "\n" },
								},
								{
									{ type = "extra", content = "\t\t\t" }, { type = "property", content = "E1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "E2" },
								}
							}}
						}
					}}
				}
			}}
		}
	})
	cst_test("comment_in_tabs", {
		{
			{ type = "property", content = "A1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "A2" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "B1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "B2" }, { type = "extra", content = "\n" },
					{ type = "children", content = {
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "C1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "C2" }, { type = "extra", content = "\n" },
							{ type = "children", content = {
								{
									{ type = "extra", content = "\t" }, { type = "extra", content = "/*foo*/" }, { type = "extra", content = "\t\t" }, { type = "property", content = "D1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "D2" }, { type = "extra", content = "\n" },
								},
								{
									{ type = "extra", content = "\t\t\t" }, { type = "property", content = "E1" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "E2" },
								}
							}}
						}
					}}
				}
			}}
		}
	})
	cst_test("spaces_at_start_of_line", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" }, { type = "extra", content = "\n" }, { type = "extra", content = "    " },
		},
		{
			{ type = "property", content = "Baz" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bee" },
		}
	})
	cst_test("datamodule", {
		{
			{ type = "property", content = "DataModule" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "IconFile" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "ContentFile" }, { type = "extra", content = "\n" },
					{ type = "children", content = {
						{
							{ type = "extra", content = "\t\t" }, { type = "property", content = "FilePath" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Foo" }, { type = "extra", content = "\n" },
						}
					}}
				},
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "ModuleName" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" },
				}
			}}
		}
	})
	cst_test("value_on_next_line", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = "\n" },
			{ type = "value", content = "Bar" },
		}
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function cst_test(filename, expected)
	local filepath = test_files.get_test_path_from_filename(filename)

	local tokens = tokens_generator.get_tokens(filepath)
	local cst = cst_generator.get_cst(tokens)

	tests.test("cst", filename, cst, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
