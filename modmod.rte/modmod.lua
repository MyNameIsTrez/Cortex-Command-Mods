-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- GLOBAL SCRIPT START ---------------------------------------------------------


function ModMod:StartScript()
	local tokens = tokens_generator.get_tokens("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)

	-- utils.RecursivelyPrint(get_objects_tree(ast))
end

-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function ModMod:UpdateScript()
	-- PrimitiveMan:DrawTextPrimitive(Vector(100, 100), tostring(self.i), false, 0);
end


-- METHODS ---------------------------------------------------------------------
