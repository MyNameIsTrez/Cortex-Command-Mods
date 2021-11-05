-- REQUIREMENTS ----------------------------------------------------------------


local KeyConstants = require("Modules/KeyConstants");
local Keys = KeyConstants;


-- MODULE START ----------------------------------------------------------------


local P = {};
_G[...] = P;


-- CONFIGURABLE VARIABLES ------------------------------------------------------


local toggledFunctions = {
	[Keys.A] = function() print("Pressed A"); end,
	[Keys.B] = function() print("Pressed B"); end,
};


local continuousFunctions = {
	[Keys.C] = function() print("Pressed C"); end,
	[Keys.D] = function() print("Pressed D"); end,
};



-- INTERNAL VARIABLES ----------------------------------------------------------


local pressedKeys = {};


-- PUBLIC FUNCTIONS ------------------------------------------------------------


function P.Update()
	P.Toggled();
	-- P.Held();
end


-- PRIVATE FUNCTIONS  ----------------------------------------------------------


function P.Toggled()
	for inputKey, functionToRun in pairs(toggledFunctions) do
		if (UInputMan:KeyPressed(inputKey)) then
			P.ToggleKey(inputKey);
			functionToRun();
		end
	end
end


function P.ToggleKey(inputKey)
	pressedKeys[inputKey] = not pressedKeys[inputKey];
	print(pressedKeys[inputKey]);
end


-- MODULE END ------------------------------------------------------------------


return P;