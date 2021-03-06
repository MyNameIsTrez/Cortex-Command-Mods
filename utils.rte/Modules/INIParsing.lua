-- REQUIREMENTS ----------------------------------------------------------------


local fileFunctions = require("Modules.FileFunctions")


-- MODULE START ----------------------------------------------------------------


local M = {};
M = M;


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.foo()
	for actor in MovableMan.Actors do
		local aHuman = ToAHuman(actor)
		local equippedItem = aHuman.EquippedItem
		local hdFirearm = ToHDFirearm(equippedItem)
		hdFirearm.RateOfFire = 10000
		hdFirearm.ReloadTime = 0
	end

	local fileStr = fileFunctions.ReadFile("Coalition.rte/Devices/Weapons/UberCannon/UberCannon.ini")

	fileStr = M.GetReplacedValueString(fileStr, "RateOfFire", 10000)
	fileStr = M.GetReplacedValueString(fileStr, "ReloadTime", 0)

	fileFunctions.WriteFile("Coalition.rte/Devices/Weapons/UberCannon/UberCannon.ini", fileStr)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M.GetReplacedValueString(oldString, property, newValue)
	return oldString:gsub(property .. "[^\n]*", property .. " = " .. newValue)
end

-- MODULE END ------------------------------------------------------------------


return M;
