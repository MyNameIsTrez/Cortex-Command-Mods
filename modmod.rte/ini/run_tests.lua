-- REQUIREMENTS ----------------------------------------------------------------


local tokenizer_tests = dofile("modmod.rte/ini/tokenizer_tests.lua")
local cst_tests = dofile("modmod.rte/ini/cst_tests.lua")
local ast_tests = dofile("modmod.rte/ini/ast_tests.lua")


-- CODE ------------------------------------------------------------------------


tokenizer_tests.tokenizer_tests()
cst_tests.cst_tests()
ast_tests.ast_tests()
