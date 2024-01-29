-- REQUIREMENTS ----------------------------------------------------------------

local tokenizer_tests = dofile("modmod.rte/ini_object_tree/tokenizer_tests.lua")
local cst_tests = dofile("modmod.rte/ini_object_tree/cst_tests.lua")
local ast_tests = dofile("modmod.rte/ini_object_tree/ast_tests.lua")
local file_object_tests = dofile("modmod.rte/ini_object_tree/file_object_tests.lua")

-- CODE ------------------------------------------------------------------------

tokenizer_tests.run_tests()
cst_tests.run_tests()
ast_tests.run_tests()
file_object_tests.run_tests()
