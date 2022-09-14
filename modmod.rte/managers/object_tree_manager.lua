-- REQUIREMENTS ----------------------------------------------------------------


local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local keys = dofile("utils.rte/Data/Keys.lua");

local csts = dofile("modmod.rte/ini/csts.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init(window_manager)
	self.window_manager = window_manager

	self.pixels_of_indentation_per_depth = 20

	self.window_top_padding = 16
	self.window_left_padding = 20
	self.window_right_padding = 40

	self.object_tree = object_tree_generator.get_object_tree("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")

	self:_update_object_tree_strings()

	self.selected_object_indices = { 1 }

	return self
end


function M:update()
	self:_key_pressed()
end


function M:draw()
	self:_draw_object_tree_background()
	self:_draw_top_background()
	self:_draw_object_tree_border()
	-- self.object_tree_strings[5] = tostring(self.screen_offset)
	self:_draw_object_tree_strings(self.object_tree_strings, {-1})
	self:_draw_selected_object_background()
	self:_draw_bottom_background()
end


function M:has_not_collapsed_properties_object_selected()
	return self:_get_selected_object().collapsed ~= true and self:_get_selected_object().properties ~= nil
end


function M:get_selected_properties()
	return self:_get_selected_object().properties or {}
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M:_key_pressed()
	if UInputMan:KeyPressed(keys.ArrowUp) then
		self:_key_pressed_up()
	elseif UInputMan:KeyPressed(keys.ArrowDown) then
		self:_key_pressed_down()
	elseif UInputMan:KeyPressed(keys.ArrowLeft) then
		self:_key_pressed_left()
	elseif UInputMan:KeyPressed(keys.ArrowRight) then
		self:_key_pressed_right()
	end
end


function M:_key_pressed_up()
	if self:_get_last_selected_object_index() > 1 and self:_get_previous_selected_object().children ~= nil and self:_get_previous_selected_object().collapsed == false then
		self:_set_last_selected_object_index(self:_get_last_selected_object_index() - 1)

		while self:_get_selected_object().children ~= nil and self:_get_selected_object().collapsed == false do
			table.insert(self.selected_object_indices, 1)
			self:_set_last_selected_object_index(self:_get_selected_object_parent_child_count())
		end
	else
		if #self.selected_object_indices == 1 then
			self:_set_last_selected_object_index(self:_get_wrapped_last_selected_object_index(-1))
		else
			if self:_get_last_selected_object_index() == 1 and #self.selected_object_indices > 1 then
				table.remove(self.selected_object_indices)
			elseif self:_get_last_selected_object_index() > 1 then
				self:_set_last_selected_object_index(self:_get_last_selected_object_index() - 1)
			end
		end
	end
end


function M:_key_pressed_down()
	if self:_get_selected_object().children ~= nil and self:_get_selected_object().collapsed == false then
		table.insert(self.selected_object_indices, 1)
	else
		if #self.selected_object_indices == 1 then
			self:_set_last_selected_object_index(self:_get_wrapped_last_selected_object_index(1))
		else
			while self:_get_last_selected_object_index() == self:_get_selected_object_parent_child_count() and #self.selected_object_indices > 1 do
				table.remove(self.selected_object_indices)
			end
			if self:_get_last_selected_object_index() < self:_get_selected_object_parent_child_count() then
				self:_set_last_selected_object_index(self:_get_last_selected_object_index() + 1)
			end
		end
	end
end


function M:_key_pressed_left()
	if self:_get_selected_object().children ~= nil and self:_get_selected_object().collapsed == false then
		self:_get_selected_object().collapsed = true
		self:_update_object_tree_strings()
	elseif #self.selected_object_indices > 1 then
		table.remove(self.selected_object_indices)
	end
end


function M:_key_pressed_right()
	if self:_get_selected_object().children ~= nil and self:_get_selected_object().collapsed == true then
		self:_get_selected_object().collapsed = false
		self:_update_object_tree_strings()
	end
end


function M:_get_last_selected_object_index()
	return self.selected_object_indices[#self.selected_object_indices]
end


function M:_set_last_selected_object_index(i)
	self.selected_object_indices[#self.selected_object_indices] = i
end


function M:_get_wrapped_last_selected_object_index(index_change)
	return utils.get_wrapped_index(self:_get_last_selected_object_index() + index_change, self:_get_selected_object_parent_child_count())
end


function M:_get_selected_object()
	local selected_object = self.object_tree

	-- TODO: Make object tree immediately start with a list of children so this iteration can be simpler
	selected_object = selected_object[self.selected_object_indices[1]]

	for i = 2, #self.selected_object_indices do
		local selected_object_index = self.selected_object_indices[i]
		selected_object = selected_object.children[selected_object_index]
	end

	return selected_object
end


function M:_get_previous_selected_object()
	local selected_object = self.object_tree

	if #self.selected_object_indices == 1 and self:_get_last_selected_object_index() > 1 then
		return selected_object[self:_get_last_selected_object_index() - 1]
	end

	-- TODO: Make object tree immediately start with a list of children so this iteration can be simpler
	selected_object = selected_object[self.selected_object_indices[1]]

	for i = 2, #self.selected_object_indices - 1 do
		local selected_object_index = self.selected_object_indices[i]
		selected_object = selected_object.children[selected_object_index]
	end

	return selected_object.children[self:_get_last_selected_object_index() - 1]
end


function M:_get_selected_object_parent_child_count()
	local object_parent = self.object_tree

	if #self.selected_object_indices == 1 then
		return #object_parent
	end

	-- TODO: Make object tree immediately start with a list of children so this iteration can be simpler
	object_parent = self.object_tree[self.selected_object_indices[1]]

	for i = 2, #self.selected_object_indices - 1 do
		local selected_object_index = self.selected_object_indices[i]
		object_parent = object_parent.children[selected_object_index]
	end

	return #object_parent.children
end


function M:_update_object_tree_strings()
	self.object_tree_strings = self:_get_object_tree_strings_recursively(self.object_tree, 0)
	self:_update_object_tree_width()
	self:_update_tree_height()
end


function M:_get_object_tree_strings_recursively(object_tree, depth)
	local object_tree_strings = {}

	object_tree_strings.depth = depth

	for _, v in ipairs(object_tree) do
		local str = ""

		if v.children ~= nil then
			if v.collapsed then
				str = str .. "v"
			else
				str = str .. ">"
			end
		end

		str = str .. " "

		if v.preset_name_pointer ~= nil then
			str = string.format("%s%s (%s)", str, v.preset_name_pointer.content, csts.property(v))
		else
			str = str .. csts.property(v)
		end

		table.insert(object_tree_strings, str)

		if v.children ~= nil and not v.collapsed then
			table.insert(object_tree_strings, self:_get_object_tree_strings_recursively(v.children, depth + 1))
		end
	end

	return object_tree_strings
end


function M:_update_object_tree_width()
	self.tree_width = 0
	self:_update_object_tree_width_recursively(self.object_tree_strings)
end


function M:_update_object_tree_width_recursively(object_tree_strings)
	local x = self.window_left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth + self.window_right_padding

	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_object_tree_width_recursively(v)
		else
			self.tree_width = math.max(self.tree_width, x + FrameMan:CalculateTextWidth(v, self.window_manager.text_is_small))
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
	self.window_manager:draw_border_fill(Vector(0, 0), self.tree_width, self.window_manager.screen_height, self.window_manager.background_color)
end


function M:_draw_top_background()
	self.window_manager:draw_border_fill(Vector(0, 0), self.tree_width, self.window_top_padding, self.window_manager.unselected_color)
end


function M:_draw_object_tree_border()
	self.window_manager:draw_border(Vector(0, self.window_top_padding - 2), self.tree_width, self.tree_height)
end


function M:_draw_selected_object_background()
	local y = self.window_top_padding + self:_get_selected_object_vertical_index() * self.window_manager.text_vertical_stride
	self.window_manager:draw_selected_line_background(Vector(1, y), self.tree_width - 2)
end


function M:_draw_bottom_background()
	self.window_manager:draw_border_fill(Vector(0, self.window_top_padding + self.tree_height - 4), self.tree_width, self.window_manager.screen_height - self.window_top_padding - self.tree_height + 4, self.window_manager.unselected_color)
end


function M:_get_selected_object_vertical_index()
	return self:_get_selected_object_vertical_index_recursively(self.object_tree, 1, true) - 1
end


function M:_get_selected_object_vertical_index_recursively(object_tree, depth, stop)
	local count = 0

	for i, v in ipairs(object_tree) do
		count = count + 1

		if i == self.selected_object_indices[depth] and stop then
			if v.children ~= nil and not v.collapsed and depth + 1 <= #self.selected_object_indices then
				count = count + self:_get_selected_object_vertical_index_recursively(v.children, depth + 1, true)
			end
			return count
		elseif v.children ~= nil and not v.collapsed then
			count = count + self:_get_selected_object_vertical_index_recursively(v.children, depth + 1, false)
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
			self.window_manager:draw_text_line(1, self.tree_width - 2, x_padding, self.window_top_padding, height[1], v, self.window_manager.alignment.left);
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
