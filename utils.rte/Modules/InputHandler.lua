-- REQUIREMENTS ----------------------------------------------------------------


local keys = dofile("utils.rte/Data/Keys.lua")
local colors = dofile("utils.rte/Data/Colors.lua")
-- local key_codes = dofile("utils.rte/Data/KeyCodes.lua")


-- MODULE START ----------------------------------------------------------------


local M = {}


-- CONFIGURABLE VARIABLES ------------------------------------------------------


local toggled_functions = {
	[keys.B] = { function() print("Pressed B") end }
}


local held_functions = {
	[keys.C] = { function() print("Held C") end }
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
	M._Toggled()
	M._Held()
end


-- function M.GetKeyNameHeld()
-- 	return key_codes[UInputMan:WhichKeyHeld()]
-- end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M._Toggled()
	for key_code, functions_to_run in pairs(toggled_functions) do
		print(key_code)
		if (UInputMan:KeyPressed(key_code)) then
			M._ToggleKey(key_code)

			for _, function_to_run in ipairs(functions_to_run) do
				function_to_run()
			end
		end
	end
end


function M._ToggleKey(key_code)
	toggled_keys[key_code] = not toggled_keys[key_code]
	print(toggled_keys[key_code])
end


function M._Held()
	for key_code, functions_to_run in pairs(held_functions) do
		if (UInputMan:KeyHeld(key_code)) then
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
