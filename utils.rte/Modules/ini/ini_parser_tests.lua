-- REQUIREMENTS ----------------------------------------------------------------


local ini_tokenizer = require("Modules.ini.ini_tokenizer")
local ini_parser = require("Modules.ini.ini_parser")
local tests = require("Modules.Tests")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


-- Use this to test this function:
-- ini_parser_tests, err = loadfile("utils.rte/Modules/ini/ini_parser_tests.lua") ini_parser_tests().parser_tests()
function M.parser_tests()
	-- test("invalid_tabbing", {}) -- This is expected to raise a "Too many tabs found" error.

	parser_test("lstripped_tab", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" },
		}
	})
	parser_test("simple", {
		{
			{ type = "property", content = "AddEffect" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "MOPixel" },
		}
	})
	parser_test("comments", {
		{
			{ type = "extra", content = "// foo"}, { type = "extra", content = "\n" },
			{ type = "extra", content = "/*a\nb\nc*/" }, { type = "extra", content = "\n" },
		},
	})
	parser_test("nested", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" }, { type = "extra", content = "\n" },
			{ type = "children", content = {
				{
					{ type = "extra", content = "\t" }, { type = "property", content = "Baz" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bee" }, { type = "extra", content = "\n" },
				}
			}}
		}
	})
	parser_test("multiple", {
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
	parser_test("complex", {
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
	parser_test("deindentation_1", {
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
	parser_test("deindentation_2", {
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
	parser_test("deindentation_3", {
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
	parser_test("spaces", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar Baz" },
		}
	})
	parser_test("comment_before_tabs", {
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
	parser_test("comment_in_tabs", {
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
	parser_test("spaces_at_start_of_line", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bar" }, { type = "extra", content = "\n" }, { type = "extra", content = "    " },
		},
		{
			{ type = "property", content = "Baz" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = " " }, { type = "value", content = "Bee" },
		}
	})
	parser_test("datamodule", {
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
	parser_test("value_on_next_line", {
		{
			{ type = "property", content = "Foo" }, { type = "extra", content = " " }, { type = "extra", content = "=" }, { type = "extra", content = "\n" },
			{ type = "value", content = "Bar" },
		}
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function parser_test(filename, expected)
	filepath = tests.get_test_path_from_filename(filename)

	tokens = ini_tokenizer.get_tokens(filepath)
	ini_cst = ini_parser.get_parsed_tokens(tokens)

	tests.test(filename, ini_cst, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
