-- REQUIREMENTS ----------------------------------------------------------------


local keys = require("Data.Keys");
local keyCodes = require("Data.KeyCodes");
local colors = require("Data.Colors");


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE VARIABLES ------------------------------------------------------


local toggledFunctions = {
	[keys.A] = function() print("Pressed A"); end,
	[keys.B] = function() print("Pressed B"); end,
};


local heldFunctions = {
	[keys.C] = function() print("Held C"); end,
	[keys.D] = function() print("Held D"); end,
};


-- INTERNAL VARIABLES ----------------------------------------------------------


local toggledKeys = {};


-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.Update()
	-- M._Toggled();
	M._Held();
end


-- function M.GetKeyNameHeld()
-- 	return keyCodes[UInputMan:WhichKeyHeld()];
-- end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M._Toggled()
	for keyCode, functionToRun in pairs(toggledFunctions) do
		if (UInputMan:KeyPressed(keyCode)) then
			M._ToggleKey(keyCode);
			functionToRun();
		end
	end
end


function M._ToggleKey(keyCode)
	toggledKeys[keyCode] = not toggledKeys[keyCode];
	print(toggledKeys[keyCode]);
end


function M._Held()
	for keyCode, functionToRun in pairs(heldFunctions) do
		if (UInputMan:KeyHeld(keyCode)) then
			-- functionToRun();

			local topLeft = Vector(1000, 1000);
			local bottomRight = topLeft + Vector(math.random(10), math.random(10));
			-- PrimitiveMan:DrawBoxFillPrimitive(topLeft, bottomRight, colors[math.random(3)])
			PrimitiveMan:DrawBoxFillPrimitive(topLeft, bottomRight, 13)
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
