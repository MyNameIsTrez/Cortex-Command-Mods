-- REQUIREMENTS ----------------------------------------------------------------

local csts = dofile("modmod.rte/ini_object_tree/csts.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")
local property_value_types = dofile("modmod.rte/data/property_value_types.lua")

local input_handler = dofile("utils.rte/Modules/InputHandler.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init(properties_manager)
	self.properties_manager = properties_manager

	self.modmod = properties_manager.modmod
	self.window_manager = properties_manager.window_manager
	self.sounds_manager = self.modmod.sounds_manager

	self.cursor_color = 254

	return self
end

function M:key_pressed()
	local selected_line = self:_get_selected_line()

	if UInputMan:KeyPressed(key_bindings.backspace) and #selected_line > 0 then
		local selected_property = self.properties_manager:get_selected_property()
		csts.set_value(selected_property, selected_line:sub(1, #selected_line - 1))
		self.cursor_x = self.cursor_x - 1
	elseif input_handler.get_character_pressed() ~= nil then
		local selected_property = self.properties_manager:get_selected_property()
		csts.set_value(selected_property, selected_line .. input_handler.get_character_pressed())
		self.cursor_x = self.cursor_x + 1
	elseif UInputMan:KeyPressed(key_bindings.enter) then
		if self:_is_value_correct_type() then
			self.properties_manager.is_editing_line = false
			self.properties_manager:write_and_update_properties_live()
			self.sounds_manager:play("edited_value")
		else
			self.sounds_manager:play("user_error")
		end
	elseif UInputMan:KeyPressed(key_bindings.up) or UInputMan:KeyPressed(key_bindings.down) then
		self.properties_manager.is_editing_line = false
		local selected_property = self.properties_manager:get_selected_property()
		csts.set_value(selected_property, self.properties_manager.old_line_value)
	end
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

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_get_selected_line()
	return csts.get_value(self.properties_manager:get_selected_property())
end

function M:_is_value_correct_type()
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

-- MODULE END ------------------------------------------------------------------

return M
