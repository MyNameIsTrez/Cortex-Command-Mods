-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")
local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")
local file_functions = dofile("utils.rte/Modules/FileFunctions.lua") -- TODO: Remove


-- GLOBAL SCRIPT START ---------------------------------------------------------


function ModMod:StartScript()
	local tokens = tokens_generator.get_tokens("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)
	local object_tree = object_tree_generator.get_object_tree(ast)

	utils.RecursivelyPrint(object_tree)
end

-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function ModMod:UpdateScript()
	-- PrimitiveMan:DrawTextPrimitive(Vector(100, 100), tostring(self.i), false, 0);
end


-- METHODS ---------------------------------------------------------------------
