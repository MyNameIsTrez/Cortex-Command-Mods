-- REQUIREMENTS ----------------------------------------------------------------


local Enum = require("Modules.Enum").Enum;
local utils = require("Modules.Utils");


-- GLOBAL SCRIPT START ---------------------------------------------------------


function DrawOptimizer:StartScript()
	-- CONFIGURABLE VARIABLES
	self.primitiveEnum = Enum("BoxFill");

	
	-- INTERNAL VARIABLES
	self.primitives = nil;


	-- SETUP
	DrawOptimizer:EmptyPrimitivesTable();
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function DrawOptimizer:UpdateScript()
	DrawOptimizer:Draw();
end


-- METHODS ---------------------------------------------------------------------


function DrawOptimizer:EmptyPrimitivesTable()
	local primitives = self.primitives;

	primitives = {};

	primitives[self.primitiveEnum.BoxFill] = {};

	-- utils.RecursivelyPrint(self.primitives);
	utils.RecursivelyPrint(primitives);
	-- utils.RecursivelyPrint(self.primitiveEnum);
end


function DrawOptimizer:Draw()
	-- for _, primitivesData in pairs(self.primitives) do
	-- 	for _, primitiveData in ipairs(primitivesData) do
	-- 		utils.Printf("primitiveData: %s", primitiveData);
	-- 	end
	-- end
end