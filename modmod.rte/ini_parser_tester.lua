local file_functions = dofile("utils.rte/Modules/file_functions.lua")
local ini_parser = dofile("modmod.rte/ini_parser.lua")
local ini_writer = dofile("modmod.rte/ini_writer.lua")
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

			local ast = ini_parser.parse(full_path)
			ini_writer.write(ast, tmp_result_path)

			local tmp_result_txt = file_functions.read_file(tmp_result_path)

			local dirpath = full_path:match("^(.+/).+$")
			local expected_path = dirpath .. "expected.ini"
			local expected_txt = file_functions.read_file(expected_path)

			if tmp_result_txt ~= expected_txt then
				print("====== expected this output: =========")
				print(expected_txt)

				print("======== instead found this: =========")
				print(tmp_result_txt)

				print("======== with this AST: ==============")
				utils.print(ast)
				
				print("======================================")

				assert(false)
			end
		end
	end

	LuaMan:FileRemove(tmp_result_path)

	-- TODO: Use the is_invalid_test argument passed to this function for tree_parser_tests/invalid/!
end
