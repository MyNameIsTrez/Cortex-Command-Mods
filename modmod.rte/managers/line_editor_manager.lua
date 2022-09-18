-- REQUIREMENTS ----------------------------------------------------------------


local csts = dofile("modmod.rte/ini/csts.lua")

local keys = dofile("utils.rte/Data/Keys.lua")
local key_codes = dofile("utils.rte/Data/KeyCodes.lua")

local input_handler = dofile("utils.rte/Modules/InputHandler.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {}


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init(window_manager, properties_manager, modmod)
	self.window_manager = window_manager
	self.properties_manager = properties_manager
	self.modmod = modmod

	self.cursor_color = 254

	return self
end


function M:update()
	self:_key_pressed()
end


function M:draw()
	local selected_line = csts.get_value(self.properties_manager.selected_properties[self.properties_manager.selected_property_index])
	-- print(selected_line)
	-- print(self.cursor_x)
	local character_x = FrameMan:CalculateTextWidth(selected_line:sub(1, self.cursor_x - 1), self.window_manager.text_is_small)
	local selected_character = selected_line:sub(self.cursor_x - 1, self.cursor_x - 1)
	local character_width = FrameMan:CalculateTextWidth(selected_character, self.window_manager.text_is_small)

	local x = self.window_manager.screen_width - self.properties_manager.property_values_width - 1 + character_x
	local y = self.properties_manager.window_top_padding + self.window_manager.font_height

	local height_index = self.properties_manager.selected_property_index - self.properties_manager.scrolling_line_offset

	self.window_manager:draw_line(Vector(x, y), character_width, 0, self.cursor_color)
	-- print("bar")
end


function M:move_cursor_to_end_of_selected_line()
	local selected_line = csts.get_value(self.properties_manager.selected_properties[self.properties_manager.selected_property_index])
	self.cursor_x = #selected_line + 1
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M:_key_pressed()
	-- print("")
	-- print(input_handler.any_key_pressed())
	-- print(self.modmod.held_key_character ~= nil)
	-- print("")
	if input_handler.any_key_pressed() and self.modmod.held_key_character ~= nil then
		csts.set_value(self.properties_manager.selected_properties[self.properties_manager.selected_property_index],
			csts.get_value(self.properties_manager.selected_properties[self.properties_manager.selected_property_index]) ..
			self.modmod.held_key_character
		)
	end
end


-- MODULE END ------------------------------------------------------------------


return M
