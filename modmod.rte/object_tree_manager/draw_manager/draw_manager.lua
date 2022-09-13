-- REQUIREMENTS ----------------------------------------------------------------


local screen_offset_manager = dofile("modmod.rte/object_tree_manager/draw_manager/screen_offset_manager.lua")

local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local colors = dofile("utils.rte/Data/Colors.lua");
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


function M:init()
	self.screen_offset_manager = screen_offset_manager:init()

	self.pixels_of_indentation_per_depth = 20
	self.uses_small_font = false

	self.background_color = colors.blue
	self.selected_object_color = colors.green

	self.screen_height = FrameMan.PlayerScreenHeight

	local no_maximum_width = 0
	local font_height = FrameMan:CalculateTextHeight("foo", no_maximum_width, self.uses_small_font)

	self.text_top_padding = 5
	local text_bottom_padding = 5
	self.vertical_stride = self.text_top_padding + font_height + text_bottom_padding

	self.top_padding = 16
	self.left_padding = 20
	self.right_padding = 40

	self.object_tree = object_tree_generator.get_object_tree("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")

	self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)
	self:_update_object_tree_width(self.object_tree_strings)

	self.selected_object_parent_indices = { 1 }

	return self
end


function M:draw()
	self.screen_offset_manager:update_screen_offset()
	self.screen_offset = self.screen_offset_manager:get_screen_offset()


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
		self.selected_object_parent_indices[#self.selected_object_parent_indices] = (self.selected_object_parent_indices[#self.selected_object_parent_indices] + 1 - 1) % self:_get_selected_object_parent_child_count() + 1
	elseif UInputMan:KeyPressed(keys.ArrowUp) then
		self.selected_object_parent_indices[#self.selected_object_parent_indices] = (self.selected_object_parent_indices[#self.selected_object_parent_indices] - 1 - 1) % self:_get_selected_object_parent_child_count() + 1
	end

	self:_draw_object_tree_background()

	self:_draw_selected_object_background()

	-- self.object_tree_strings[5] = tostring(self.screen_offset)

	self:_draw_object_tree_strings(self.object_tree_strings, {-1})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


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

	for i = 1, #self.selected_object_parent_indices - 1 do
		local selected_object_parent_index = self.selected_object_parent_indices[i]
		object_parent = object_parent[selected_object_parent_index]
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
	local x = self.left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth + self.right_padding

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_object_tree_width_recursively(v)
		else
			self.tree_width = math.max(self.tree_width, x + FrameMan:CalculateTextWidth(v, self.uses_small_font))
		end
	end
end


function M:_draw_object_tree_background()
	PrimitiveMan:DrawBoxFillPrimitive(self.screen_offset, self.screen_offset + Vector(self.tree_width, self.screen_height), self.background_color)
end


function M:_draw_selected_object_background()
	print("--")
	print(self.selected_object_parent_indices[1])
	print(self.selected_object_parent_indices[2])
	print(self:_get_selected_object_vertical_index())
	print("--")
	local y = self.top_padding + self:_get_selected_object_vertical_index() * self.vertical_stride
	PrimitiveMan:DrawBoxFillPrimitive(self.screen_offset + Vector(0, y), self.screen_offset + Vector(0, y) + Vector(self.tree_width, self.vertical_stride), self.selected_object_color)
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
	local x = self.left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_draw_object_tree_strings(v, height)
		else
			height[1] = height[1] + 1

			local y = self.top_padding + self.text_top_padding + height[1] * self.vertical_stride
			PrimitiveMan:DrawTextPrimitive(self.screen_offset + Vector(x, y), v, self.uses_small_font, 0);
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
