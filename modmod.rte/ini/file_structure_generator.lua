-- REQUIREMENTS ----------------------------------------------------------------


local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")
local csts = dofile("modmod.rte/ini/csts.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


--[[
Returned format:
{
	["Browncoats.rte"] = {
		Actors = {
			Infantry = {
				BrowncoatHeavy = {
					"BrowncoatHeavy.ini"
				}
			}
		}
	}
}
]]--
function M.get_file_structure()
	local ini_paths = get_ini_paths()
	utils.RecursivelyPrint(ini_paths)

	return {
		["Browncoats.rte"] = {
			Actors = {
				Infantry = {
					BrowncoatHeavy = {
						"BrowncoatHeavy.ini"
					},
					BrowncoatLight = {
						"BrowncoatLight.ini"
					}
				}
			}
		},
		["Coalition.rte"] = {
			Devices = {
				Weapons = {
					GatlingGun = {
						"GatlingGun.ini"
					}
				}
			}
		}
	}
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_ini_paths()
	local ini_paths = {}

	for data_module in PresetMan.Modules do
		local data_module_file_name = data_module.FileName

		local object_tree = object_tree_generator.get_file_object_tree(data_module_file_name, "Index.ini")

		add_datamodule_ini_paths_recursively(object_tree, ini_paths)
	end

	return ini_paths
end


function add_datamodule_ini_paths_recursively(object_tree, ini_paths)
	for _, v in ipairs(object_tree.children) do
		if v.children ~= nil then
			add_datamodule_ini_paths_recursively(v, ini_paths)
		end

		if v.properties then
			for _, subproperty in ipairs(v.properties) do
				local property = csts.property(subproperty)

				if is_load_ini_property(property) then
					local ini_path = csts.value(subproperty)
					ini_paths[ini_path] = true
				end
			end
		end
	end
end


function is_load_ini_property(property)
	for _, load_ini_property in ipairs({ "IncludeFile", "SkinFile" }) do
		if property == load_ini_property then
			return true
		end
	end

	return false
end


-- MODULE END ------------------------------------------------------------------


return M;
