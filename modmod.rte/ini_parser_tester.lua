local tree_parser = dofile("modmod.rte/tree_parser.lua")
local ini_writer = dofile("modmod.rte/ini_writer.lua")

local file_functions = dofile("utils.rte/Modules/file_functions.lua")
local utils = dofile("utils.rte/Modules/utils.lua")

function INIParserTester:StartScript()
	print("INIParserTester:StartScript()")

	test_directory("general", false)
	-- TODO: Add these back!
	-- test_directory("ini_rules", false)
	-- test_directory("invalid", true)
	-- test_directory("lua_rules", false)
	-- test_directory("mod", false)
	-- test_directory("updated", false)

	print("Passed all tests! :)")
end

function test_directory(directory_name, is_invalid_test)
	local tests_directory_path = "Mods/modmod.rte/data/tree_parser_tests/"

	local tmp_result_path = tests_directory_path .. "tmp_result.ini"

	for full_path in file_functions.walk(tests_directory_path .. directory_name) do
		local relative_path = full_path:sub(#tests_directory_path)

		local is_file = relative_path:sub(-1) ~= "/"
		local basename = relative_path:match("^.+/(.*)$")

		if is_file and basename == "input.ini" then
			local dirname = relative_path:match("^.-/(.+)/.+$")
			print("Test '" .. dirname .. "'")

			-- local diagnostics = {}
			-- local file_tree = tree_parser.parse(full_path, diagnostics)

			ini_writer.write(ast, tmp_result_path)

			tmp_result_txt = file_functions.read_file(tmp_result_path)

			local dirpath = full_path:match("^(.+/).+$")
			local expected_path = dirpath .. "expected.ini"
			expected_txt = file_functions.read_file(expected_path)

			if tmp_result_txt ~= expected_txt then
				local printed = ""

				printed = printed .. "\n====== expected this output: =========\n"
				printed = printed .. expected_txt

				printed = printed .. "\n======== instead found this: =========\n"
				printed = printed .. tmp_result_txt

				printed = printed .. "\n======================================"

				print(printed)

				assert(false)
			end
		end
	end

	LuaMan:FileRemove(tmp_result_path)

	-- TODO: Use the is_invalid_test argument passed to this function for tree_parser_tests/invalid/!
end
