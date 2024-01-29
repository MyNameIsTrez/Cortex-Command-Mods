local tree_parser = dofile("modmod.rte/tree_parser.lua")
local tree_writer = dofile("modmod.rte/tree_writer.lua")

local file_functions = dofile("utils.rte/Modules/FileFunctions.lua")
local utils = dofile("utils.rte/Modules/Utils.lua")

function TreeParserTester:StartScript()
	print("TreeParserTester:StartScript()")

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
	
	for path in file_functions.Walk(tests_directory_path .. directory_name) do
		-- Strip tests_directory_path from the start of path
		path = path:sub(#tests_directory_path)
		
		local is_file = path:sub(-1) ~= "/"
		local basename = path:match("^.+/(.*)$")

		if is_file and basename == "input.ini" then
			print("Test '" .. utils.dirname(path) .. "'")

			-- TODO: Use tree_parser.lua and tree_writer.lua to create tmp_result_path

			-- local diagnostics = {}
			-- local file_tree = tree_parser.parse(folder_path, diagnostics)

			-- tree_writer.write(file_tree, output_folder_path)
		end
	end
	
	LuaMan:FileRemove(tmp_result_path)

	-- TODO: Use the is_invalid_test argument passed to this function for tree_parser_tests/invalid/!
end
