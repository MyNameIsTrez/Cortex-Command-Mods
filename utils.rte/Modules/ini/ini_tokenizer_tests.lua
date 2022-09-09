-- REQUIREMENTS ----------------------------------------------------------------


local ini_tokenizer = require("Modules.ini.ini_tokenizer")
local tests = require("Modules.Tests")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


-- Use this to test this function:
-- ini_tokenizer_tests, err = loadfile("utils.rte/Modules/ini/ini_tokenizer_tests.lua") ini_tokenizer_tests().tokenizer_tests()
function M.tokenizer_tests()
	tokenizer_test("simple", {
		{ type = "WORD", content = "AddEffect" }, { type = "EXTRA", content = " " }, { type = "EQUALS", content = "=" }, { type = "EXTRA", content = " " }, { type = "WORD", content = "MOPixel" },
	})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function tokenizer_test(filename, expected)
	filepath = tests.get_test_path_from_filename(filename)

	tokens = ini_tokenizer.get_tokens(filepath)

	tokens_without_metadata = {}
	for _, token in ipairs(tokens) do
		table.insert(tokens_without_metadata, { type = token.type, content = token.content })
	end

	tests.test(filename, tokens_without_metadata, expected)
end


-- MODULE END ------------------------------------------------------------------


return M;
