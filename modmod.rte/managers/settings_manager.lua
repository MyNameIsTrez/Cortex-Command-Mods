-- REQUIREMENTS ----------------------------------------------------------------

local settings = dofile("modmod.rte/data/settings.lua")

local file_functions = dofile("utils.rte/Modules/FileFunctions.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init()
	return self
end

function M:invert(settings_key)
	local current_value = not self:get(settings_key)

	self:set(settings_key, current_value)
end

function M:get(settings_key)
	return settings[settings_key]
end

function M:set(settings_key, value)
	settings[settings_key] = value

	file_functions.WriteTableToFile("modmod.rte/data/settings.lua", settings)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
