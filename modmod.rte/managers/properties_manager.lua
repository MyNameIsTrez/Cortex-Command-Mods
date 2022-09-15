-- REQUIREMENTS ----------------------------------------------------------------


local keys = dofile("utils.rte/Data/Keys.lua");

local utils = dofile("utils.rte/Modules/Utils.lua")

local csts = dofile("modmod.rte/ini/csts.lua")


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

	self.window_top_padding = 25
	self.window_left_padding = 15
	self.window_right_padding = 40

	-- TODO: Load this from a file that is automatically kept up-to-date with the game instead
	local property_names = {
		"PresetName", "Mass", "AirResistance", "HitsMOs",
		"GetsHitByMOs", "FrameCount", "AngularVel", "DeepCheck",
		"DrawAfterParent", "DeepCheck", "JointStrength", "JointStiffness",
		"GibImpulseLimit", "GibWoundLimit", "CollidesWithTerrainWhileAttached"
	}

	local max_length_property_name_index = utils.max_fn(property_names, function(str1, str2)
		return FrameMan:CalculateTextWidth(str2, self.window_manager.text_is_small)
			> FrameMan:CalculateTextWidth(str1, self.window_manager.text_is_small)
	end)

	self.property_names_width = FrameMan:CalculateTextWidth(property_names[max_length_property_name_index], self.window_manager.text_is_small) + 37

	self.property_values_width = 150
	self.properties_width = self.property_names_width + self.property_values_width

	self.selected_property_index = 1

	return self
end


function M:update()
	self:_key_pressed()
end


function M:draw()
	self.selected_properties = self.object_tree_manager:get_selected_properties()

	self:_update_properties_height()

	self:_draw_properties_background()
	self:_draw_top_background()

	if #self.selected_properties > 0 then
		self:_draw_property_names_border()
		self:_draw_property_values_border()
	end

	self:_draw_property_names()
	self:_draw_property_values()

	if self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
		self:_draw_selected_property_background()
	end

	self:_draw_bottom_background()
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
	return utils.get_wrapped_index(self.selected_property_index + index_change, #self.selected_properties)
end


function M:_update_properties_height()
	self.properties_height = self.window_manager.text_top_padding + self.window_manager.text_vertical_stride * #self.selected_properties + 1
end


function M:_draw_properties_background()
	self.window_manager:draw_border_fill(Vector(self.window_manager.screen_width - self.properties_width, 0), self.properties_width, self.window_manager.screen_height, self.window_manager.background_color)
end


function M:_draw_top_background()
	self.window_manager:draw_border_fill(Vector(self.window_manager.screen_width - self.properties_width, 0), self.properties_width, self.window_top_padding, self.window_manager.unselected_color)
end


function M:_draw_property_names_border()
	local height = self.window_manager.text_top_padding + #self.selected_properties * self.window_manager.text_vertical_stride + 1

	self.window_manager:draw_border(Vector(self.window_manager.screen_width - self.properties_width, self.window_top_padding - 2), self.property_names_width, height)
end


function M:_draw_property_values_border()
	local height = self.window_manager.text_top_padding + #self.selected_properties * self.window_manager.text_vertical_stride + 1

	self.window_manager:draw_border(Vector(self.window_manager.screen_width - self.property_values_width - 2, self.window_top_padding - 2), self.property_values_width + 2, height)
end


function M:_draw_selected_property_background()
	local x = self.window_manager.screen_width - self.properties_width
	local y = self.window_top_padding + (self.selected_property_index - 1) * self.window_manager.text_vertical_stride
	self.window_manager:draw_selected_line_background(Vector(x, y), self.properties_width)
end


function M:_draw_property_names()
	local x = self.window_manager.screen_width - self.properties_width + 1

	for height_index, selected_property in ipairs(self.selected_properties) do
		local str = csts.property(selected_property)
		self.window_manager:draw_text_line(x, self.property_names_width - 2, 0, self.window_top_padding, height_index - 1, str, self.window_manager.alignment.center);
	end
end


function M:_draw_property_values()
	local x = self.window_manager.screen_width - self.property_values_width - 1

	for height_index, selected_property in ipairs(self.selected_properties) do
		local str = utils.possibly_truncate(csts.value(selected_property), self.property_values_width - 29, self.window_manager.text_is_small, "...")
		self.window_manager:draw_text_line(x, self.property_values_width, self.window_left_padding, self.window_top_padding, height_index - 1, str, self.window_manager.alignment.left);
	end
end


function M:_draw_bottom_background()
	self.window_manager:draw_border_fill(Vector(self.window_manager.screen_width - self.properties_width, self.window_top_padding + self.properties_height - 4), self.properties_width, self.window_manager.screen_height - self.window_top_padding - self.properties_height + 4, self.window_manager.unselected_color)
end


-- MODULE END ------------------------------------------------------------------


return M;
