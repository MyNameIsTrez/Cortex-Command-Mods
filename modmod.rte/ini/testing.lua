-- local fileFunctions = require("FileFunctions")

-- Use this to test this function:
-- f, err = loadfile("utils.rte/Modules/ini/ini_parser.lua") f().foo()
-- function M.foo()
-- 	for actor in MovableMan.Actors do
-- 		local aHuman = ToAHuman(actor)
-- 		local equippedItem = aHuman.EquippedItem
-- 		local hdFirearm = ToHDFirearm(equippedItem)
-- 		hdFirearm["RateOfFire"] = 10000
-- 		hdFirearm.ReloadTime = 0
-- 	end

-- 	local fileStr = fileFunctions.ReadFile("Coalition.rte/Devices/Weapons/UberCannon/UberCannon.ini")

-- 	fileStr = M._GetReplacedValueString(fileStr, "RateOfFire", 10000)
-- 	fileStr = M._GetReplacedValueString(fileStr, "ReloadTime", 0)

-- 	fileFunctions.WriteFile("Coalition.rte/Devices/Weapons/UberCannon/UberCannon.ini", fileStr)
-- end

-- function M._GetReplacedValueString(fileString, property, newValue)
-- 	return fileString:gsub(property .. "[^\n]*", property .. " = " .. newValue)
-- end
