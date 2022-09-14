-- REQUIREMENTS ----------------------------------------------------------------


local keys = dofile("utils.rte/Data/Keys.lua");

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init(window_manager, object_tree_manager)
	self.window_manager = window_manager
	self.object_tree_manager = object_tree_manager

	self.window_left_padding = 100
	self.window_right_padding = 200

	self.selected_property_index = 1

	return self
end


function M:update()
	self:_key_pressed()
end


function M:draw()
	self.selected_properties = self.object_tree_manager:get_selected_properties()
	self:_update_property_strings()
	self:_update_properties_width()

	self:_draw_properties_background()

	if self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
		self:_draw_selected_property_background()
	end

	self:_draw_property_strings()
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M:_key_pressed()
	if UInputMan:KeyPressed(keys.ArrowUp) then
		self:_key_pressed_up()
	elseif UInputMan:KeyPressed(keys.ArrowDown) then
		self:_key_pressed_down()
	elseif UInputMan:KeyPressed(keys.Enter) then
		self:_key_pressed_enter()
	end
end


function M:_key_pressed_up()
	self.selected_property_index = self:_get_wrapped_selected_property_index(-1)
end


function M:_key_pressed_down()
	self.selected_property_index = self:_get_wrapped_selected_property_index(1)
end


function M:_key_pressed_enter()
end


function M:_get_wrapped_selected_property_index(index_change)
	return utils.get_wrapped_index(self.selected_property_index + index_change, #self.property_strings)
end


function M:_update_property_strings()
	self.property_strings = {}

	for _, property in ipairs(self.selected_properties) do
		local str = string.format("%s | %s", property.property_pointer.content, property.value_pointer.content)
		table.insert(self.property_strings, str)
	end
end


function M:_update_properties_width()
	self.properties_width = 0

	local x = self.window_left_padding + self.window_right_padding

	for _, str in ipairs(self.property_strings) do
		self.properties_width = math.max(self.properties_width, x + FrameMan:CalculateTextWidth(str, self.window_manager.text_is_small))
	end
end


function M:_draw_properties_background()
	self.window_manager:draw_box_fill(Vector(self.window_manager.screen_width - self.properties_width, 0), self.properties_width, self.window_manager.screen_height, self.window_manager.background_color)
end


function M:_draw_selected_property_background()
	local y = self.window_manager.window_top_padding + (self.selected_property_index - 1) * self.window_manager.text_vertical_stride
	self.window_manager:draw_box_fill(Vector(self.window_manager.screen_width - self.properties_width, y), self.properties_width, self.window_manager.text_vertical_stride, self.window_manager.selected_object_color)
end


function M:_draw_property_strings()
	for height_index, str in ipairs(self.property_strings) do
		self.window_manager:draw_line(self.window_manager.screen_width - self.window_right_padding, height_index - 1, str, self.window_manager.alignment.right);
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
