-- REQUIREMENTS ----------------------------------------------------------------

local line_editor_manager = dofile("modmod.rte/managers/line_editor_manager.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")
local property_value_types = dofile("modmod.rte/data/property_value_types.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")

local csts = dofile("modmod.rte/ini_object_tree/csts.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------

-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------

-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------

-- INTERNAL PRIVATE VARIABLES --------------------------------------------------

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init(window_manager, object_tree_manager, autoscroll_manager, modmod)
	self.window_manager = window_manager
	self.object_tree_manager = object_tree_manager
	self.autoscroll_manager = autoscroll_manager
	self.line_editor_manager = line_editor_manager:init(window_manager, self, modmod)

	self.window_top_padding = 25
	self.window_left_padding = 15
	self.window_right_padding = 40

	local longest_property_name = utils.max(property_value_types, function(key_1, value_1, key_2, value_2)
		return FrameMan:CalculateTextWidth(key_2, self.window_manager.text_is_small)
			> FrameMan:CalculateTextWidth(key_1, self.window_manager.text_is_small)
	end)

	self.property_names_width = FrameMan:CalculateTextWidth(
		longest_property_name,
		self.window_manager.text_is_small
	) + 37

	self.property_values_width = 150
	self.properties_width = self.property_names_width + self.property_values_width

	self.selected_property_index = 1

	local lines_height = self.window_manager.screen_height
		- self.window_top_padding
		- self.window_manager.text_top_padding
	self.max_scrolling_lines = math.floor(lines_height / self.window_manager.text_vertical_stride)

	self.scrolling_line_offset = 0

	self.is_editing_line = false

	self.selection_change_sound = CreateSoundContainer("Selection Change", "modmod.rte")
	self.user_error_sound = CreateSoundContainer("User Error", "modmod.rte")

	self.checkbox_sprite = CreateMOSRotating("Checkbox", "modmod.rte")

	return self
end

function M:update()
	if self.is_editing_line then
		self.line_editor_manager:update()

		-- TODO: Does this if-elseif belong here? It is weird having it inside of this update(), instead of _key_pressed()
		if UInputMan:KeyPressed(key_bindings.enter) then
			if self.line_editor_manager:is_value_correct_type() then
				self.is_editing_line = false
				self.object_tree_manager:write_selected_file_cst()
				self:_update_properties_live()
			else
				self.user_error_sound:Play()
			end
		elseif UInputMan:KeyPressed(key_bindings.up) or UInputMan:KeyPressed(key_bindings.down) then
			self.is_editing_line = false
			csts.set_value(self:get_selected_property(), self.old_line_value)
		end
	else
		self:_key_pressed()
	end
end

function M:draw()
	self.selected_properties = self.object_tree_manager:get_selected_properties()

	self:_update_properties_height()

	if #self.selected_properties > 0 then
		self:_draw_property_names_border()
		self:_draw_property_values_border()
	end

	self:_draw_property_names()
	self:_draw_property_values()

	if self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
		self:_draw_selected_property_name_background()
		self:_draw_selected_property_value_background()
	end

	self:_draw_bottom_background()

	if self.is_editing_line then
		self.line_editor_manager:draw()
	end
end

function M:get_selected_property()
	return self.selected_properties[self.selected_property_index]
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_key_pressed()
	if self.autoscroll_manager:move(key_bindings.up) then
		self:_up()

		self.selection_change_sound:Play()
	elseif self.autoscroll_manager:move(key_bindings.down) then
		self:_down()

		self.selection_change_sound:Play()
	elseif UInputMan:KeyPressed(key_bindings.enter) then
		self.is_editing_line = true
		self.old_line_value = csts.get_value(self:get_selected_property())
		self.line_editor_manager:move_cursor_to_end_of_selected_line()
	end
end

function M:_up()
	self.selected_property_index = self:_get_wrapped_selected_property_index(-1)

	if self.selected_property_index - 1 < self.scrolling_line_offset then
		self.scrolling_line_offset = self.selected_property_index - 1
	elseif self.scrolling_line_offset + self.max_scrolling_lines < self.selected_property_index - 1 then
		self.scrolling_line_offset = math.max(0, self.selected_property_index - self.max_scrolling_lines)
	end
end

function M:_down()
	self.selected_property_index = self:_get_wrapped_selected_property_index(1)

	if
		self.selected_property_index > self.scrolling_line_offset + self.max_scrolling_lines
		or self.scrolling_line_offset > self.selected_property_index
	then
		self.scrolling_line_offset = math.max(0, self.selected_property_index - self.max_scrolling_lines)
	end
end

function M:_get_wrapped_selected_property_index(index_change)
	return utils.get_wrapped_index(self.selected_property_index + index_change, #self.selected_properties)
end

function M:_update_properties_height()
	self.properties_height = self.window_manager.text_vertical_stride * #self.selected_properties

	if #self.selected_properties > 0 then
		-- The + 1 is for the bottom property's underline
		self.properties_height = self.properties_height + self.window_manager.text_top_padding + 1
	end
end

function M:_draw_property_names_border()
	self.window_manager:draw_border_fill(
		Vector(self.window_manager.screen_width - self.properties_width, self.window_top_padding - 2),
		self.property_names_width,
		self.properties_height,
		self.window_manager.background_color
	)
end

function M:_draw_property_values_border()
	self.window_manager:draw_border_fill(
		Vector(self.window_manager.screen_width - self.property_values_width - 2, self.window_top_padding - 2),
		self.property_values_width + 2,
		self.properties_height,
		self.window_manager.background_color
	)
end

function M:_draw_selected_property_name_background()
	local x = self.window_manager.screen_width - self.properties_width + 1
	local y = self.window_top_padding
	local height_index = self.selected_property_index - self.scrolling_line_offset

	self.window_manager:draw_selected_line_background(Vector(x, y), self.property_names_width - 2, height_index)
end

function M:_draw_selected_property_value_background()
	local x = self.window_manager.screen_width - self.property_values_width - 1
	local y = self.window_top_padding
	local height_index = self.selected_property_index - self.scrolling_line_offset

	self.window_manager:draw_selected_line_background(Vector(x, y), self.property_values_width, height_index)
end

function M:_draw_property_names()
	local x = self.window_manager.screen_width - self.properties_width + 1

	for height_index, selected_property in ipairs(self.selected_properties) do
		local str = csts.get_property(selected_property)
		self.window_manager:draw_text_line(
			x,
			self.property_names_width - 2,
			0,
			self.window_top_padding,
			height_index,
			str,
			self.window_manager.alignment.center
		)
	end
end

function M:_draw_property_values()
	local x = self.window_manager.screen_width - self.property_values_width - 1

	for height_index, selected_property in ipairs(self.selected_properties) do
		local selected_property_property = csts.get_property(selected_property)

		local selected_type = property_value_types[selected_property_property]

		local selected_value = csts.get_value(selected_property)

		if selected_type == "boolean" then
			-- TODO: Calculate width and height in init()?
			local mos = ToMOSprite(self.checkbox_sprite)
			local bitmap_x = x + self.window_left_padding + mos:GetSpriteWidth() / 2
			local bitmap_y = self.window_top_padding + self.window_manager.text_top_padding + (height_index - 1) * self.window_manager.text_vertical_stride + mos:GetSpriteHeight() / 2

			self.window_manager:draw_bitmap(Vector(bitmap_x, bitmap_y), self.checkbox_sprite, 0, 0)
			self.window_manager:draw_selection_lines(x, self.property_values_width, self.window_top_padding, height_index, self.window_manager.unselected_color)
		else
			local str
			if self.is_editing_line and height_index == self.selected_property_index then
				str = utils.possibly_truncate(
					selected_value:reverse(),
					self.property_values_width - 29,
					self.window_manager.text_is_small,
					"..."
				):reverse()
			else
				str = utils.possibly_truncate(
					selected_value,
					self.property_values_width - 29,
					self.window_manager.text_is_small,
					"..."
				)
			end

			if height_index > self.scrolling_line_offset then
				self.window_manager:draw_text_line(
					x,
					self.property_values_width,
					self.window_left_padding,
					self.window_top_padding,
					height_index - self.scrolling_line_offset,
					str,
					self.window_manager.alignment.left
				)
			end
		end
	end
end

function M:_draw_bottom_background()
	-- TODO: This is an ugly fix :(
	local start_height = self.window_top_padding + math.max(self.properties_height - 2, 0)

	self.window_manager:draw_border_fill(
		Vector(
			self.window_manager.screen_width - self.properties_width,
			start_height - 2
		),
		self.properties_width,
		self.window_manager.screen_height - start_height + 2,
		self.window_manager.unselected_color
	)
end

function M:_update_properties_live()
	local selected_preset_name = self.object_tree_manager:get_selected_preset_name()

	for actor in MovableMan.Actors do
		if actor.ClassName == "AHuman" then
			local a_human = ToAHuman(actor)

			local equipped_item = a_human.EquippedItem

			if equipped_item ~= nil and equipped_item.PresetName == selected_preset_name then
				local hd_firearm = ToHDFirearm(equipped_item)

				local selected_property = self:get_selected_property()
				local property = csts.get_property(selected_property)
				local value_string = csts.get_value(selected_property)

				local value
				if tonumber(value_string) ~= nil then
					value = tonumber(value_string)
				else
					value = value_string
				end

				hd_firearm[property] = value
			end
		end
	end
end

-- MODULE END ------------------------------------------------------------------

return M
