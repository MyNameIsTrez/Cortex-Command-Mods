-- REQUIREMENTS ----------------------------------------------------------------


local screen_offset_manager = dofile("modmod.rte/object_tree_manager/draw_manager/screen_offset_manager.lua")

local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local keys = dofile("utils.rte/Data/Keys.lua");

local csts = dofile("modmod.rte/ini/csts.lua")


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

	local no_maximum_width = 0
	local font_height = FrameMan:CalculateTextHeight("foo", no_maximum_width, self.uses_small_font)
	local vertical_padding = 5
	self.vertical_stride = font_height + vertical_padding

	self.top_padding = 5
	self.bottom_padding = 10
	self.left_padding = 20
	self.right_padding = 40

	self.object_tree = object_tree_generator.get_object_tree("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")

	self.toggle = false

	-- self.selected_object = self.object_tree[1]

	return self
end


function M:draw()
	self.screen_offset_manager:update_screen_offset()
	self.screen_offset = self.screen_offset_manager:get_screen_offset()


	if UInputMan:KeyPressed(keys.ArrowRight) then
		self.object_tree[1].collapsed = self.toggle
		self.toggle = not self.toggle
	end

	self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)

	self:_update_object_tree_width_and_height(self.object_tree_strings)


	self:_draw_object_tree_background(self.object_tree_strings, {-1})

	self.object_tree_strings[5] = tostring(self.screen_offset)
	self:_draw_object_tree_strings(self.object_tree_strings, {-1})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


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


function M:_update_object_tree_width_and_height(object_tree_strings)
	self.tree_width = 0
	self.tree_height = 0
	self:_update_object_tree_width_and_height_recursively(object_tree_strings, {-1})
end


function M:_update_object_tree_width_and_height_recursively(object_tree_strings, height)
	local x = self.left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth + self.right_padding

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_object_tree_width_and_height_recursively(v, height)
		else
			height[1] = height[1] + 1
			local y = self.top_padding + height[1] * self.vertical_stride

			self.tree_width = math.max(self.tree_width, x + FrameMan:CalculateTextWidth(v, self.uses_small_font))
			self.tree_height = math.max(self.tree_height, y + self.vertical_stride + self.bottom_padding)
		end
	end
end


function M:_draw_object_tree_background(object_tree_strings, height)
	PrimitiveMan:DrawRoundedBoxFillPrimitive(self.screen_offset, self.screen_offset + Vector(self.tree_width, self.tree_height), 10, 1)
end


function M:_draw_object_tree_strings(object_tree_strings, height)
	local x = self.left_padding + object_tree_strings.depth * self.pixels_of_indentation_per_depth

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_draw_object_tree_strings(v, height)
		else
			height[1] = height[1] + 1

			local y = self.top_padding + height[1] * self.vertical_stride
			PrimitiveMan:DrawTextPrimitive(self.screen_offset + Vector(x, y), v, self.uses_small_font, 0);
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
