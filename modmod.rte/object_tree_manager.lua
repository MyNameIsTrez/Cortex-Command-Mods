-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")
local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init()
	local tokens = tokens_generator.get_tokens("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)

	self.pixels_of_indentation_per_depth = 20
	self.uses_small_font = false

	self.font_height = FrameMan:CalculateTextHeight("foo", 0, self.uses_small_font)
	self.vertical_padding = 5
	self.vertical_stride = self.font_height + self.vertical_padding

	self.object_tree = object_tree_generator.get_object_tree(ast)

	self.object_tree[1].collapsed = false

	self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)

	self:_update_object_tree_width_and_height(self.object_tree_strings)

	return self
end


function M:update()
	-- utils.RecursivelyPrint(object_tree_strings)
	self:_draw_object_tree_background(self.object_tree_strings, {-1})
	self:_draw_object_tree_strings(self.object_tree_strings, {-1})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M:_update_object_tree_width_and_height(object_tree_strings)
	self.tree_width = 0
	self.tree_height = 0
	self:_update_object_tree_width_and_height_recursively(object_tree_strings, {-1})
end


function M:_update_object_tree_width_and_height_recursively(object_tree_strings, height)
	local x = object_tree_strings.depth * self.pixels_of_indentation_per_depth

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_update_object_tree_width_and_height_recursively(v, height)
		else
			height[1] = height[1] + 1
			local y = height[1] * self.vertical_stride

			self.tree_width = math.max(self.tree_width, x + FrameMan:CalculateTextWidth(v, self.uses_small_font))
			self.tree_height = math.max(self.tree_height, y + self.vertical_stride)
		end
	end
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

		if v.preset_name ~= nil then
			str = string.format("%s%s (%s)", str, v.preset_name, v.value)
		else
			str = str .. v.value
		end

		table.insert(object_tree_strings, str)

		if v.children ~= nil and not v.collapsed then
			table.insert(object_tree_strings, self:_get_object_tree_strings(v.children, depth + 1))
		end
	end

	return object_tree_strings
end


function M:_draw_object_tree_background(object_tree_strings, height)
	PrimitiveMan:DrawRoundedBoxFillPrimitive(Vector(0, 0), Vector(self.tree_width, self.tree_height), 0, 1)
end


function M:_draw_object_tree_strings(object_tree_strings, height)
	local x = object_tree_strings.depth * self.pixels_of_indentation_per_depth

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:_draw_object_tree_strings(v, height)
		else
			height[1] = height[1] + 1

			local y = height[1] * self.vertical_stride
			PrimitiveMan:DrawTextPrimitive(Vector(x, y), v, self.uses_small_font, 0);
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
