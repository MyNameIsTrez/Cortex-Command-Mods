-- REQUIREMENTS ----------------------------------------------------------------


local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")
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

	local file_structure = {}

	for ini_path, _ in pairs(ini_paths) do
		local x = file_structure

		for part in ini_path:gmatch("([^/]*)/") do
			if x[part] == nil then
				x[part] = {}
			end

			x = x[part]
		end

		table.insert(x, ini_path:match(".*/(.*)"))
	end

	return file_structure
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_ini_paths()
	local ini_paths = {}

	for data_module in PresetMan.Modules do
		local data_module_file_name = data_module.FileName

		add_file_ini_paths(data_module_file_name .. "/Index.ini", ini_paths)
	end

	return ini_paths
end


function add_file_ini_paths(ini_path, ini_paths)
	local ast = ast_generator.get_ast(ini_path)
	add_ini_paths(ast, ini_paths)
end


function add_ini_paths(ast, ini_paths)
	for _, v in ipairs(ast) do
		if v.children ~= nil then
			add_ini_paths(v.children, ini_paths)
		end

		local property = csts.property(v)

		if is_load_ini_property(property) then
			local ini_path = csts.value(v)

			local visited_before = ini_paths[ini_path]
			if not visited_before then
				ini_paths[ini_path] = true
				add_file_ini_paths(ini_path, ini_paths)
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
