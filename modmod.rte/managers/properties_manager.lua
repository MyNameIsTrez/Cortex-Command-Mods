-- REQUIREMENTS ----------------------------------------------------------------

local line_editor_manager = dofile("modmod.rte/managers/line_editor_manager.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

local parent_classes = dofile("modmod.rte/data/properties/parent_classes.lua")
local properties = dofile("modmod.rte/data/properties/properties.lua")
local property_value_types = dofile("modmod.rte/data/properties/property_value_types.lua")

local utils = dofile("utils.rte/Modules/utils.lua")

local csts = dofile("modmod.rte/ini_object_tree/csts.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init(modmod)
	self.modmod = modmod

	self.window_manager = modmod.window_manager
	self.settings_manager = modmod.settings_manager
	self.object_tree_manager = modmod.object_tree_manager
	self.line_editor_manager = line_editor_manager:init(self)

	self.window_top_padding = 32
	self.window_left_padding = 15
	self.window_right_padding = 40

	local longest_property_name = self:_get_longest_property_name(properties)
	self.property_names_width = FrameMan:CalculateTextWidth(longest_property_name, self.window_manager.text_is_small)
		+ 37

	self.property_values_width = 150
	self.properties_width = self.property_names_width + self.property_values_width

	self.selected_property_index = 1

	local lines_height = ui.screen_height - self.window_top_padding - self.window_manager.text_top_padding
	self.max_scrolling_lines = math.floor(lines_height / self.window_manager.text_vertical_stride)

	self.scrolling_line_offset = 0

	self.is_editing_line = false

	self.selection_change_sound = CreateSoundContainer("Selection Change", "modmod.rte")
	self.user_error_sound = CreateSoundContainer("User Error", "modmod.rte")
	self.slice_picked_sound = CreateSoundContainer("Slice Picked", "modmod.rte")
	self.focus_change_sound = CreateSoundContainer("Focus Change", "modmod.rte")

	self.checkbox_mosparticle = CreateMOSParticle("Checkbox", "modmod.rte")
	self.checkbox_top_padding = 2

	local checkbox_mos = ToMOSprite(self.checkbox_mosparticle)
	self.checkbox_sprite_half_width = checkbox_mos:GetSpriteWidth() / 2
	self.checkbox_sprite_half_height = checkbox_mos:GetSpriteHeight() / 2

	return self
end

function M:key_pressed()
	if self.is_editing_line then
		self.line_editor_manager:key_pressed()
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

function M:get_selected_property_value_type()
	local property_name = csts.get_property(self:get_selected_property())
	-- utils.print("property name:")
	-- utils.print(property_name)

	return self:_get_property_value_type(property_name)
end

function M:write_and_update_properties_live()
	if self.settings_manager:get("save_to_disk") then
		self.object_tree_manager:write_selected_file_cst()
	end

	self:_update_properties_live()
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_get_longest_property_name(subproperties)
	local longest_property_name = ""

	for _, value in pairs(subproperties) do
		if type(value) == "table" or type(value) == "string" then
			if type(value) == "table" then
				value = self:_get_longest_property_name(value)
			end

			if
				type(value) == "string"
				and FrameMan:CalculateTextWidth(value, self.window_manager.text_is_small)
					> FrameMan:CalculateTextWidth(longest_property_name, self.window_manager.text_is_small)
			then
				longest_property_name = value
			end
		end
	end

	return longest_property_name
end

function M:_key_pressed()
	local selected_property = self:get_selected_property()

	if self:can_move(key_bindings.up) then
		self:_up()

		self.up:Play()
	elseif self:can_move(key_bindings.down) then
		self:_down()

		self.down:Play()
	elseif UInputMan:KeyPressed(key_bindings.enter) and self:get_selected_property_value_type() == "boolean" then
		local boolean_value = tonumber(csts.get_value(selected_property))
		if boolean_value == 1 then
			boolean_value = 0
		else
			boolean_value = 1
		end

		csts.set_value(selected_property, boolean_value)

		self:write_and_update_properties_live()

		self.toggle_checkbox:Play()
	elseif UInputMan:KeyPressed(key_bindings.enter) then
		self.is_editing_line = true
		self.old_line_value = csts.get_value(selected_property)
		self.line_editor_manager:move_cursor_to_end_of_selected_line()
		self.start_editing_value:Play()
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
		ui.light_green
	)
end

function M:_draw_property_values_border()
	self.window_manager:draw_border_fill(
		Vector(self.window_manager.screen_width - self.property_values_width - 2, self.window_top_padding - 2),
		self.property_values_width + 2,
		self.properties_height,
		ui.light_green
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
			ui.alignments.center
		)
	end
end

function M:_draw_property_values()
	local x = self.window_manager.screen_width - self.property_values_width - 1

	for height_index, selected_property in ipairs(self.selected_properties) do
		local property = csts.get_property(selected_property)
		local selected_type = self:_get_property_value_type(property)

		local selected_value = csts.get_value(selected_property)

		if selected_type == "boolean" then
			local bitmap_x = x + self.window_left_padding + self.checkbox_sprite_half_width
			local bitmap_y = self.window_top_padding
				+ self.checkbox_top_padding
				+ (height_index - 1) * self.window_manager.text_vertical_stride
				+ self.checkbox_sprite_half_height

			local frame = tonumber(selected_value)
			self.window_manager:draw_bitmap(Vector(bitmap_x, bitmap_y), self.checkbox_mosparticle, 0, frame)

			self.window_manager:draw_selection_lines(
				x,
				self.property_values_width,
				self.window_top_padding,
				height_index,
				ui.dark_green
			)
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
					ui.alignments.left
				)
			end
		end
	end
end

function M:_draw_bottom_background()
	-- TODO: This is an ugly fix :(
	local start_height = self.window_top_padding + math.max(self.properties_height - 2, 0)

	self.window_manager:draw_border_fill(
		Vector(self.window_manager.screen_width - self.properties_width, start_height - 2),
		self.properties_width,
		ui.screen_height - start_height + 2,
		ui.dark_green
	)
end

function M:_update_properties_live()
	local selected_preset_name = self.object_tree_manager:get_selected_preset_name()

	for actor in MovableMan.Actors do
		if actor.ClassName == "AHuman" then
			local a_human = ToAHuman(actor)

			local equipped_item = a_human.EquippedItem
			-- utils.print({ equipped_item.PresetName, selected_preset_name})

			-- if equipped_item ~= nil and equipped_item.PresetName == selected_preset_name then
			if equipped_item ~= nil and equipped_item.PresetName == "IN-02 Backblast" then
				local hd_firearm = ToHDFirearm(equipped_item)
				utils.print(hd_firearm.Magazine)

				hd_firearm.Magazine.Mass = 2000

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

function M:_get_property_value_type(property_name, object_type)
	if object_type == nil then
		object_type = self.object_tree_manager:get_selected_object_type()
	end
	-- utils.print("object type:")
	-- utils.print(object_type)

	local property_value_type = property_value_types[object_type][property_name]
	-- utils.print("property value type:")
	-- utils.print(property_value_type)

	if property_value_type ~= nil then
		return property_value_type
	else
		return self:_get_property_value_type(property_name, parent_classes[object_type])
	end
end

-- MODULE END ------------------------------------------------------------------

return M
