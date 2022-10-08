-- REQUIREMENTS ----------------------------------------------------------------

local keys = dofile("utils.rte/Data/Keys.lua")
local colors = dofile("utils.rte/Data/Colors.lua")
local key_codes = dofile("utils.rte/Data/KeyCodes.lua")
local key_characters = dofile("utils.rte/Data/KeyCharacters.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- CONFIGURABLE VARIABLES ------------------------------------------------------

local toggled_functions = {
	[keys.B] = {
		function()
			print("Pressed B")
		end,
	},
}

local held_functions = {
	[keys.C] = {
		function()
			print("Held C")
		end,
	},
}

-- INTERNAL VARIABLES ----------------------------------------------------------

local toggled_keys = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.register_toggled_function(key_code, fn)
	if toggled_functions[key_code] == nil then
		toggled_functions[key_code] = {}
	end
	table.insert(toggled_functions[key_code], fn)
	print(key_code)
end

-- function M.register_held_function(key_code, fn)
-- 	if held_functions[key_code] == nil then
-- 		held_functions[key_code] = {}
-- 	end
-- 	table.insert(held_functions[key_code], fn)
-- end

function M.Update()
	Toggled()
	Held()
end

function M.any_key_pressed()
	for key_code, _ in pairs(key_codes) do
		if UInputMan:KeyPressed(key_code) then
			return true
		end
	end
	return false
end

function M.get_held_key_character()
	local key_code = UInputMan:WhichKeyHeld()
	local key = key_characters[key_code]

	if key == nil then
		return nil
	end

	local shift_held = UInputMan.FlagShiftState

	if not shift_held and key_code >= 1 and key_code <= 26 then
		return key:lower()
	end

	return key
end

-- function M.get_held_key()
-- 	local key_code = UInputMan:WhichKeyHeld()
-- 	local key = key_codes[key_code]

-- 	local shift_held = UInputMan.FlagShiftState

-- 	if not shift_held and key_code >= 1 and key_code <= 26 then
-- 		return key:lower()
-- 	end

-- 	return key
-- end

-- function M.GetKeyNameHeld()
-- 	return key_codes[UInputMan:WhichKeyHeld()]
-- end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function Toggled()
	for key_code, functions_to_run in pairs(toggled_functions) do
		print(key_code)
		if UInputMan:KeyPressed(key_code) then
			ToggleKey(key_code)

			for _, function_to_run in ipairs(functions_to_run) do
				function_to_run()
			end
		end
	end
end

function ToggleKey(key_code)
	toggled_keys[key_code] = not toggled_keys[key_code]
	print(toggled_keys[key_code])
end

function Held()
	for key_code, functions_to_run in pairs(held_functions) do
		if UInputMan:KeyHeld(key_code) then
			for _, function_to_run in ipairs(functions_to_run) do
				function_to_run()
			end

			local top_left = Vector(100, 100)
			local bottom_right = top_left + Vector(math.random(100), math.random(100))
			PrimitiveMan:DrawBoxFillPrimitive(top_left, bottom_right, colors.red)
		end
	end
end

-- MODULE END ------------------------------------------------------------------

return M
