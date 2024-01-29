-- REQUIREMENTS ----------------------------------------------------------------

local file_object_generator = dofile("modmod.rte/ini_object_tree/file_object_generator.lua")
local csts = dofile("modmod.rte/ini_object_tree/csts.lua")

local writer = dofile("modmod.rte/ini_object_tree/writer.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

local utils = dofile("utils.rte/Modules/utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init(modmod)
	self.window_manager = modmod.window_manager

	self.pixels_of_indentation_per_depth = 15

	self.window_top_padding = 16
	self.window_left_padding = 15
	self.window_right_padding = 40

	self.object_tree = file_object_generator.get_starting_object_tree()

	self:_update_object_tree_strings()

	self.selected_object_indices = { 1 }

	local lines_height = ui.screen_height - self.window_top_padding - self.window_manager.text_top_padding
	self.max_scrolling_lines = math.floor(lines_height / self.window_manager.text_vertical_stride)

	self.scrolling_line_offset = 0

	self.item_change_sound = CreateSoundContainer("Item Change", "modmod.rte")
	self.selection_change_sound = CreateSoundContainer("Selection Change", "modmod.rte")

	return self
end

function M:key_pressed()
	if self:can_move(key_bindings.up) then
		self:_up()
		self.up:Play()
	elseif self:can_move(key_bindings.down) then
		self:_down()
		self.down:Play()
	elseif UInputMan:KeyPressed(key_bindings.left) then
		self:_left()
	elseif UInputMan:KeyPressed(key_bindings.right) then
		self:_right()
	end
end

function M:draw()
	self:_draw_object_tree_background()
	self:_draw_top_background()
	self:_draw_object_tree_border()
	self:_draw_object_tree_strings(self.object_tree_strings, { 0 })
	self:_draw_selected_object_background()
	self:_draw_bottom_background()
end

function M:has_not_collapsed_properties_object_selected()
	return self:_get_selected_object().collapsed ~= true and self:_get_selected_object().properties ~= nil
end

function M:get_selected_properties()
	return self:_get_selected_object().properties or {}
end

function M:write_selected_file_cst()
	local file_cst = self:_get_selected_file_cst()
	local file_path = self:_get_selected_object_path()
	writer.write_ini_file_cst(file_cst, file_path)
end

function M:get_selected_preset_name()
	local preset_name_pointer = self:_get_selected_object().preset_name_pointer

	if preset_name_pointer ~= nil then
		return preset_name_pointer.content
	else
		return nil
	end
end

function M:get_selected_object_type()
	local object_type = self:_get_selected_object().value_pointer

	if object_type ~= nil then
		return object_type.content
	else
		return nil
	end
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_up()
	if
		self:_get_last_selected_object_index() > 1
		and self:_get_previous_selected_object().children ~= nil
		and not self:_get_previous_selected_object().collapsed
	then
		self:_set_last_selected_object_index(self:_get_last_selected_object_index() - 1)

		while self:_get_selected_object().children ~= nil and not self:_get_selected_object().collapsed do
			table.insert(self.selected_object_indices, 1)
			self:_set_last_selected_object_index(self:_get_selected_object_parent_child_count())
		end

		if self:_get_selected_object_vertical_index() < self.scrolling_line_offset then
			self.scrolling_line_offset = self:_get_selected_object_vertical_index()
		end
	else
		if #self.selected_object_indices == 1 then
			self:_set_last_selected_object_index(self:_get_wrapped_last_selected_object_index(-1))

			if self:_get_selected_object_vertical_index() < self.scrolling_line_offset then
				self.scrolling_line_offset = self:_get_selected_object_vertical_index()
			elseif
				self.scrolling_line_offset + self.max_scrolling_lines < self:_get_selected_object_vertical_index()
			then
				self.scrolling_line_offset = math.max(
					0,
					self:_get_selected_object_vertical_index() - self.max_scrolling_lines
				)
			end
		else
			if self:_get_last_selected_object_index() == 1 and #self.selected_object_indices > 1 then
				table.remove(self.selected_object_indices)

				if self:_get_selected_object_vertical_index() < self.scrolling_line_offset then
					self.scrolling_line_offset = math.max(
						0,
						self:_get_selected_object_vertical_index() - self.max_scrolling_lines
					)
				end
			elseif self:_get_last_selected_object_index() > 1 then
				self:_set_last_selected_object_index(self:_get_last_selected_object_index() - 1)

				if self:_get_selected_object_vertical_index() < self.scrolling_line_offset then
					self.scrolling_line_offset = self:_get_selected_object_vertical_index()
				end
			end
		end
	end

	self:_potentially_load_file()
end

function M:_down()
	local selected_object = self:_get_selected_object()

	if selected_object.children ~= nil and not selected_object.collapsed then
		table.insert(self.selected_object_indices, 1)

		if self:_get_selected_object_vertical_index() > self.scrolling_line_offset + self.max_scrolling_lines then
			self.scrolling_line_offset = math.max(
				0,
				self:_get_selected_object_vertical_index() - self.max_scrolling_lines
			)
		end
	else
		if #self.selected_object_indices == 1 then
			self:_set_last_selected_object_index(self:_get_wrapped_last_selected_object_index(1))

			if
				self:_get_selected_object_vertical_index() > self.scrolling_line_offset + self.max_scrolling_lines
				or self.scrolling_line_offset > self:_get_selected_object_vertical_index()
			then
				self.scrolling_line_offset = math.max(
					0,
					self:_get_selected_object_vertical_index() - self.max_scrolling_lines
				)
			end
		else
			if self:_parents_have_next_object() then
				while
					self:_get_last_selected_object_index() == self:_get_selected_object_parent_child_count()
					and #self.selected_object_indices > 1
				do
					table.remove(self.selected_object_indices)
				end
			end

			if self:_get_last_selected_object_index() < self:_get_selected_object_parent_child_count() then
				self:_set_last_selected_object_index(self:_get_last_selected_object_index() + 1)

				if
					self:_get_selected_object_vertical_index()
					> self.scrolling_line_offset + self.max_scrolling_lines
				then
					self.scrolling_line_offset = math.max(
						0,
						self:_get_selected_object_vertical_index() - self.max_scrolling_lines
					)
				end
			end
		end
	end

	self:_potentially_load_file()
end

function M:_left()
	local selected_object = self:_get_selected_object()

	if selected_object.children ~= nil and not selected_object.collapsed then
		selected_object.collapsed = true
		self:_update_object_tree_strings()

		if self:_get_last_object_vertical_index() - self.scrolling_line_offset < self.max_scrolling_lines then
			self.scrolling_line_offset = math.max(
				0,
				self:_get_selected_object_vertical_index() - self.max_scrolling_lines
			)
		end

		self.collapse:Play()
	elseif #self.selected_object_indices > 1 then
		table.remove(self.selected_object_indices)

		self.up_object_tree_layer:Play()
	end
end

function M:_get_last_selected_object_index()
	return self.selected_object_indices[#self.selected_object_indices]
end

function M:_set_last_selected_object_index(i)
	self.selected_object_indices[#self.selected_object_indices] = i
end

function M:_get_wrapped_last_selected_object_index(index_change)
	return utils.get_wrapped_index(
		self:_get_last_selected_object_index() + index_change,
		self:_get_selected_object_parent_child_count()
	)
end

function M:_get_selected_file_cst()
	local selected_object = self.object_tree

	for _, selected_object_index in ipairs(self.selected_object_indices) do
		selected_object = selected_object.children[selected_object_index]

		if selected_object.cst ~= nil then
			return selected_object.cst
		end
	end
end

function M:_get_selected_object_path()
	local file_path = "."
	local selected_object = self.object_tree

	for _, selected_object_index in ipairs(self.selected_object_indices) do
		selected_object = selected_object.children[selected_object_index]

		if selected_object.file_name ~= nil then
			return utils.path_join(file_path, selected_object.file_name)
		else
			file_path = utils.path_join(file_path, selected_object.directory_name)
		end
	end

	return file_path
end

function M:_parents_have_next_object()
	for i = #self.selected_object_indices, 1, -1 do
		local ith_selected_object_index = self.selected_object_indices[i]
		local ith_selected_object_parent_child_count = self:_get_ith_selected_object_parent_child_count(i)

		if ith_selected_object_index < ith_selected_object_parent_child_count then
			return true
		end
	end

	return false
end

function M:_get_selected_object()
	local selected_object = self.object_tree

	for _, selected_object_index in ipairs(self.selected_object_indices) do
		selected_object = selected_object.children[selected_object_index]
	end

	return selected_object
end

function M:_get_previous_selected_object()
	local selected_object = self.object_tree

	for i = 1, #self.selected_object_indices - 1 do
		local selected_object_index = self.selected_object_indices[i]
		selected_object = selected_object.children[selected_object_index]
	end

	return selected_object.children[self:_get_last_selected_object_index() - 1]
end

function M:_get_selected_object_parent_child_count()
	return M:_get_ith_selected_object_parent_child_count(#self.selected_object_indices)
end

function M:_get_ith_selected_object_parent_child_count(ith_selected_object_index)
	local object_parent = self.object_tree

	for i = 1, ith_selected_object_index - 1 do
		local selected_object_index = self.selected_object_indices[i]
		object_parent = object_parent.children[selected_object_index]
	end

	return #object_parent.children
end

function M:_potentially_load_file()
	local selected_object = self:_get_selected_object()

	if selected_object.file_name ~= nil and selected_object.children == nil and selected_object.properties == nil then
		local file_path = self:_get_selected_object_path()

		-- TODO: Do this in a nicer way somehow?
		local file_object = file_object_generator.get_file_object(file_path)
		selected_object.cst = file_object.cst
		selected_object.children = file_object.children
		selected_object.collapsed = file_object.collapsed
		selected_object.properties = file_object.properties

		self:_update_object_tree_strings()
	end
end

function M:_update_object_tree_strings()
	self.object_tree_strings = self:_get_object_tree_strings_recursively(self.object_tree, 0)
	self:_update_object_tree_width()
	self:_update_tree_height()
end

function M:_get_object_tree_strings_recursively(object_tree, depth)
	local object_tree_strings = {}

	object_tree_strings.depth = depth

	for _, v in ipairs(object_tree.children) do
		local str = ""

		if v.collapsed then
			str = str .. "v"
		elseif v.collapsed == false then
			str = str .. ">"
		else
			-- TODO: It's jank how this relies on two spaces
			-- being the same width as a "v" or a ">"
			str = str .. "  "
		end

		str = str .. " "

		if v.preset_name_pointer ~= nil then
			str = string.format("%s%s (%s)", str, v.preset_name_pointer.content, csts.get_property(v))
		elseif v.file_name ~= nil then
			str = str .. v.file_name
		elseif v.directory_name ~= nil then
			str = str .. v.directory_name .. "/"
		else
			str = str .. csts.get_property(v)
		end

		table.insert(object_tree_strings, str)

		if v.children ~= nil and not v.collapsed then
			table.insert(object_tree_strings, self:_get_object_tree_strings_recursively(v, depth + 1))
		end
	end

	return object_tree_strings
end

function M:_update_object_tree_width()
	self.object_tree_width = 0
	self:_update_object_tree_width_recursively(self.object_tree_strings)
end

function M:_update_object_tree_width_recursively(object_tree_strings)
	local x = self.window_left_padding
		+ object_tree_strings.depth * self.pixels_of_indentation_per_depth
		+ self.window_right_padding

	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_object_tree_width_recursively(v)
		else
			self.object_tree_width = math.max(
				self.object_tree_width,
				x + FrameMan:CalculateTextWidth(v, self.window_manager.text_is_small)
			)
		end
	end
end

function M:_update_tree_height()
	self.tree_height = self.window_manager.text_top_padding + 1
	self:_update_tree_height_recursively(self.object_tree_strings)
end

function M:_update_tree_height_recursively(object_tree_strings)
	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_tree_height_recursively(v)
		else
			self.tree_height = self.tree_height + self.window_manager.text_vertical_stride
		end
	end
end

function M:_draw_object_tree_background()
	self.window_manager:draw_border_fill(Vector(0, 0), self.object_tree_width, ui.screen_height, ui.light_green)
end

function M:_draw_top_background()
	self.window_manager:draw_border_fill(Vector(0, 0), self.object_tree_width, self.window_top_padding, ui.dark_green)
end

function M:_draw_object_tree_border()
	self.window_manager:draw_border(Vector(0, self.window_top_padding - 2), self.object_tree_width, self.tree_height)
end

function M:_draw_selected_object_background()
	local height_index = self:_get_selected_object_vertical_index() - self.scrolling_line_offset + 1
	self.window_manager:draw_selected_line_background(
		Vector(1, self.window_top_padding),
		self.object_tree_width - 2,
		height_index
	)
end

function M:_draw_bottom_background()
	self.window_manager:draw_border_fill(
		Vector(0, self.window_top_padding + self.tree_height - 4),
		self.object_tree_width,
		ui.screen_height - self.window_top_padding - self.tree_height + 4,
		ui.dark_green
	)
end

-- TODO: Remove the -1 in here since Lua is 1-based
function M:_get_selected_object_vertical_index()
	return self:_get_selected_object_vertical_index_recursively(self.object_tree, 1, true) - 1
end

function M:_get_selected_object_vertical_index_recursively(object_tree, depth, stop)
	local count = 0

	for i, v in ipairs(object_tree.children) do
		count = count + 1

		if i == self.selected_object_indices[depth] and stop then
			if v.children ~= nil and not v.collapsed and depth + 1 <= #self.selected_object_indices then
				count = count + self:_get_selected_object_vertical_index_recursively(v, depth + 1, true)
			end
			return count
		elseif v.children ~= nil and not v.collapsed then
			count = count + self:_get_selected_object_vertical_index_recursively(v, depth + 1, false)
		end
	end

	return count
end

function M:_get_last_object_vertical_index()
	return self:_get_last_object_vertical_index_recursively(self.object_tree) - 1
end

function M:_get_last_object_vertical_index_recursively(object_tree)
	local count = 0

	for i, v in ipairs(object_tree.children) do
		count = count + 1

		if v.children ~= nil and not v.collapsed then
			count = count + self:_get_last_object_vertical_index_recursively(v)
		end
	end

	return count
end

function M:_draw_object_tree_strings(object_tree_strings, height)
	local x_padding = self.window_left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth

	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_draw_object_tree_strings(v, height)
		else
			height[1] = height[1] + 1
			if height[1] > self.scrolling_line_offset then
				self.window_manager:draw_text_line(
					1,
					self.object_tree_width - 2,
					x_padding,
					self.window_top_padding,
					height[1] - self.scrolling_line_offset,
					v,
					ui.alignments.left
				)
			end
		end
	end
end

-- MODULE END ------------------------------------------------------------------

return M
