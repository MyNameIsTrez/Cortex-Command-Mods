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

	self.object_tree = object_tree_generator.get_object_tree("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")

	self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)
	self:_update_object_tree_width(self.object_tree_strings)

	self.selected_object_parent_indices = { 1 }

	return self
end


function M:update()
	self:_KeyPressed()
	self:_draw()
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M:_KeyPressed()
	if UInputMan:KeyPressed(keys.ArrowRight) then
		if self:_get_selected_object().children ~= nil then
			if self:_get_selected_object().collapsed == true then
				self:_get_selected_object().collapsed = false

				self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)
				self:_update_object_tree_width()
			elseif self:_get_selected_object().collapsed == false then
				table.insert(self.selected_object_parent_indices, 1)
			end
		end
	elseif UInputMan:KeyPressed(keys.ArrowLeft) then
		if self:_get_selected_object().children ~= nil and self:_get_selected_object().collapsed == false then
			self:_get_selected_object().collapsed = true

			self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)
			self:_update_object_tree_width()
		elseif #self.selected_object_parent_indices > 1 then
			table.remove(self.selected_object_parent_indices)
		end
	elseif UInputMan:KeyPressed(keys.ArrowDown) then
		self.selected_object_parent_indices[#self.selected_object_parent_indices] = self:_get_wrapped(self.selected_object_parent_indices[#self.selected_object_parent_indices] + 1)
	elseif UInputMan:KeyPressed(keys.ArrowUp) then
		self.selected_object_parent_indices[#self.selected_object_parent_indices] = self:_get_wrapped(self.selected_object_parent_indices[#self.selected_object_parent_indices] - 1)
	end
end


function M:_get_wrapped(i)
	return (i - 1) % self:_get_selected_object_parent_child_count() + 1
end


function M:_draw()
	self:_draw_object_tree_background()

	self:_draw_selected_object_background()

	-- self.object_tree_strings[5] = tostring(self.screen_offset)

	self:_draw_object_tree_strings(self.object_tree_strings, {-1})
end


function M:_get_selected_object()
	local selected_object = self.object_tree

	-- TODO: Make object tree immediately start with a list of children so this iteration can be simpler
	selected_object = selected_object[self.selected_object_parent_indices[1]]

	for i = 2, #self.selected_object_parent_indices do
		local selected_object_parent_index = self.selected_object_parent_indices[i]
		selected_object = selected_object.children[selected_object_parent_index]
	end

	return selected_object
end


function M:_get_selected_object_parent_child_count()
	local object_parent = self.object_tree

	if #self.selected_object_parent_indices == 1 then
		return #object_parent
	end

	-- TODO: Make object tree immediately start with a list of children so this iteration can be simpler
	object_parent = self.object_tree[self.selected_object_parent_indices[1]]

	for i = 2, #self.selected_object_parent_indices - 1 do
		local selected_object_parent_index = self.selected_object_parent_indices[i]
		object_parent = object_parent.children[selected_object_parent_index]
	end

	return #object_parent.children
end


function M:_get_object_tree_strings(object_tree, depth)
	depth = depth or 0

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
			table.insert(object_tree_strings, self:_get_object_tree_strings(v.children, depth + 1))
		end
	end

	return object_tree_strings
end


function M:_update_object_tree_width()
	self.tree_width = 0
	self:_update_object_tree_width_recursively(self.object_tree_strings)
end


function M:_update_object_tree_width_recursively(object_tree_strings)
	local x = self.window_manager.window_left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth + self.window_manager.window_right_padding

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_object_tree_width_recursively(v)
		else
			self.tree_width = math.max(self.tree_width, x + FrameMan:CalculateTextWidth(v, self.window_manager.text_is_small))
		end
	end
end


function M:_draw_object_tree_background()
	self.window_manager:draw_box_fill(Vector(0, 0), Vector(self.tree_width, self.window_manager.screen_height), self.window_manager.background_color)
end


function M:_draw_selected_object_background()
	local y = self.window_manager.window_top_padding + self:_get_selected_object_vertical_index() * self.window_manager.text_vertical_stride
	self.window_manager:draw_box_fill(Vector(0, y), Vector(0, y) + Vector(self.tree_width, self.window_manager.text_vertical_stride), self.window_manager.selected_object_color)
end


function M:_get_selected_object_vertical_index()
	return self:_get_selected_object_vertical_index_recursively(self.object_tree, 1, true) - 1
end


function M:_get_selected_object_vertical_index_recursively(object_tree, depth, stop)
	local count = 0

	for i, v in ipairs(object_tree) do
		count = count + 1

		if i == self.selected_object_parent_indices[depth] and stop then
			if v.children ~= nil and not v.collapsed and depth + 1 <= #self.selected_object_parent_indices then
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
	local x = self.window_manager.window_left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_draw_object_tree_strings(v, height)
		else
			height[1] = height[1] + 1
			self.window_manager:draw_line(x, height[1], v, self.window_manager.alignment.left);
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
