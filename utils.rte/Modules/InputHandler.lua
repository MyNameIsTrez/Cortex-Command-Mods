-- REQUIREMENTS ----------------------------------------------------------------


local keys = require("Data/Keys");
-- local keysFromIDs = require("Data/KeysFromIDs");

local benchmarker = require("Modules/Benchmarker");


-- MODULE START ----------------------------------------------------------------


local M = {};
_G[...] = M;


-- CONFIGURABLE VARIABLES ------------------------------------------------------


local toggledFunctions = {
	[keys.A] = function() print("Pressed A"); end,
	[keys.B] = function() benchmarker.RunAll(); end,
};


local heldFunctions = {
	[keys.C] = function() print("Held C"); end,
	[keys.D] = function() print("Held D"); end,
};


-- INTERNAL VARIABLES ----------------------------------------------------------


local pressedKeys = {};


-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.Update()
	M._Toggled();
	M._Held();
end


-- function M.GetKeyNameHeld()
-- 	return keysFromIDs[UInputMan:WhichKeyHeld()];
-- end


-- PRIVATE FUNCTIONS  ----------------------------------------------------------


function M._Toggled()
	for inputKey, functionToRun in pairs(toggledFunctions) do
		if (UInputMan:KeyPressed(inputKey)) then
			M._ToggleKey(inputKey);
			functionToRun();
		end
	end
end


function M._ToggleKey(inputKey)
	pressedKeys[inputKey] = not pressedKeys[inputKey];
	print(pressedKeys[inputKey]);
end


function M._Held()

end


-- MODULE END ------------------------------------------------------------------


return M;