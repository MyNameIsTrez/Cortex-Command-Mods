-- REQUIREMENTS ----------------------------------------------------------------

local csts = dofile("modmod.rte/ini/csts.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")
local property_value_types = dofile("modmod.rte/data/property_value_types.lua")

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
	local selected_line = self:_get_selected_line()

	local str = utils.possibly_truncate(
		selected_line:reverse(),
		self.properties_manager.property_values_width - 29,
		self.window_manager.text_is_small,
		"..."
	):reverse()

	local character_x = FrameMan:CalculateTextWidth(str:sub(1, self.cursor_x - 1), self.window_manager.text_is_small)
	local selected_character = selected_line:sub(self.cursor_x - 1, self.cursor_x - 1)

	local x = self.window_manager.screen_width
		- self.properties_manager.property_values_width
		- 1
		+ self.properties_manager.window_left_padding
		+ character_x

	local height_index = self.properties_manager.selected_property_index - self.properties_manager.scrolling_line_offset
	local y = self.properties_manager.window_top_padding
		+ self.window_manager.font_height
		+ (height_index - 1) * self.window_manager.text_vertical_stride

	local x_offset = 4
	local y_offset = 0

	self.window_manager:draw_line(Vector(x, y), x_offset, y_offset, self.cursor_color)
end

function M:move_cursor_to_end_of_selected_line()
	local selected_line = self:_get_selected_line()
	self.cursor_x = #selected_line + 1
end

function M:is_value_correct_type()
	local selected_property = self.properties_manager:get_selected_property()
	local property = csts.get_property(selected_property)
	local value_string = csts.get_value(selected_property)

	local property_value_type = property_value_types[property]

	-- In the case a property name isn't in the table yet, this function assumes the value type is valid
	if (property_value_type == "number" or property_value_type == "boolean") and tonumber(value_string) == nil then
		return false
	end

	return true
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_key_pressed()
	local selected_line = self:_get_selected_line()

	if UInputMan:KeyPressed(key_bindings.backspace) and #selected_line > 0 then
		csts.set_value(self.properties_manager:get_selected_property(), selected_line:sub(1, #selected_line - 1))
		self.cursor_x = self.cursor_x - 1
	elseif input_handler.any_key_pressed() and self.modmod.held_key_character ~= nil then
		-- elseif self.modmod.held_key_character ~= nil then
		csts.set_value(self.properties_manager:get_selected_property(), selected_line .. self.modmod.held_key_character)
		self.cursor_x = self.cursor_x + 1
	end
end

function M:_get_selected_line()
	return csts.get_value(self.properties_manager:get_selected_property())
end

-- MODULE END ------------------------------------------------------------------

return M
