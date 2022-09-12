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

	self.target_wrapped = false

	self.scene_width = SceneMan.SceneWidth
	self.half_scene_width = self.scene_width / 2
	self.scene_height = SceneMan.SceneHeight
	self.half_scene_height = self.scene_height / 2

	self.screen_width = FrameMan.PlayerScreenWidth
	self.screen_height = FrameMan.PlayerScreenHeight
	self.half_screen_size = Vector(self.screen_width, self.screen_height) / 2

	self.player_id = utils.get_first_human_player_id()
	self.screen_of_player = ActivityMan:GetActivity():ScreenOfPlayer(self.player_id)
	self.scroll_speed = 0.3 -- TODO: This needs to be dynamic
	self.scroll_timer = Timer()

	SceneMan:SetOffset(Vector(0, 0), self.player_id) -- TODO: Necessary?
	-- SceneMan:SetOffset(Vector(10, 10), self.player_id)
	self.screen_offset = SceneMan:GetOffset(self.player_id)
	-- self.screen_offset = Vector(0, 0)

	self.pixels_of_indentation_per_depth = 20
	self.uses_small_font = false

	local no_maximum_width = 0
	self.font_height = FrameMan:CalculateTextHeight("foo", no_maximum_width, self.uses_small_font)
	self.vertical_padding = 5
	self.vertical_stride = self.font_height + self.vertical_padding

	self.top_padding = 5
	self.bottom_padding = 10
	self.left_padding = 20
	self.right_padding = 40

	self.object_tree = object_tree_generator.get_object_tree(ast)

	self.object_tree[1].collapsed = false

	self.object_tree_strings = self:_get_object_tree_strings(self.object_tree)

	self:_update_object_tree_width_and_height(self.object_tree_strings)

	return self
end


function M:update()
	-- utils.RecursivelyPrint(object_tree_strings)
	self:_update_screen_offset()
	self.object_tree_strings[5] = tostring(self.screen_offset)
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


function M:_update_screen_offset()
	local scroll_target = SceneMan:GetScrollTarget(self.screen_of_player)

	-- Can't be done in init() since GetScrollTarget() always wrongly returns Vector(0, 0)
	if self.previous_scroll_target == nil then
		self.previous_scroll_target = SceneMan:GetScrollTarget(self.screen_of_player)
	end

	-- TODO: Not sure whether this scroll_target - self.previous_scroll_target is correct since it was originally targetCenter.m_X
	if (SceneMan.SceneWrapsX and math.abs(scroll_target.X - self.previous_scroll_target.X) > self.half_scene_width) or
	   (SceneMan.SceneWrapsY and math.abs(scroll_target.X - self.previous_scroll_target.Y) > self.half_scene_height) then
		self.target_wrapped = true
		print("x")
	end

	-- TODO: Why doesn't copying the X and Y work?
	-- self.previous_scroll_target.X = scroll_target.X
	-- self.previous_scroll_target.Y = scroll_target.Y
	self.previous_scroll_target = Vector(scroll_target.X, scroll_target.Y)

	if TimerMan:DrawnSimUpdate() then
		if self.target_wrapped then
			if SceneMan.SceneWrapsX then
				if scroll_target.X < self.half_scene_width then
					print("a")
					print(self.screen_offset.X)
					print(self.scene_width)
					self.screen_offset.X = self.screen_offset.X - self.scene_width
					print(self.screen_offset.X)
				else
					print("b")
					print(self.screen_offset.X)
					print(self.scene_width)
					self.screen_offset.X = self.screen_offset.X + self.scene_width
					print(self.screen_offset.X)
				end
			end

			if SceneMan.SceneWrapsY then
				if scroll_target.Y < self.half_scene_height then
					print("c")
					print(self.screen_offset.Y)
					print(self.scene_height)
					self.screen_offset.Y = self.screen_offset.Y - self.scene_height
					print(self.screen_offset.Y)
				else
					print("d")
					print(self.screen_offset.Y)
					print(self.scene_height)
					self.screen_offset.Y = self.screen_offset.Y + self.scene_height
					print(self.screen_offset.Y)
				end
			end
		end

		self.target_wrapped = false
	end

	-- TODO: See line 1331 of SceneEditorGUI.cpp
	-- Can cursor_pos even be known?
	-- cursor_wrapped = SceneMan:ForceBounds(self.cursor_pos)

	local offset_target = scroll_target - self.half_screen_size

	if (offset_target.Floored == self.screen_offset.Floored) then
		return
	-- else
	-- 	print(offset_target.Floored - self.screen_offset.Floored)
	end

	local scroll_difference = offset_target - self.screen_offset
	local scroll_progress = self.scroll_speed * self.scroll_timer.ElapsedRealTimeMS * 0.05
	scroll_progress = math.min(1, scroll_progress)
	local scroll_result = (scroll_difference * scroll_progress).Rounded
	local new_screen_offset = self.screen_offset + scroll_result

	local old_screen_offset = SceneMan:GetOffset(self.player_id)

	-- TODO: Replace this with calling the clamp checking function that SetOffset() calls
	SceneMan:SetOffset(new_screen_offset, self.player_id)
	self.screen_offset = SceneMan:GetOffset(self.player_id)

	SceneMan:SetOffset(old_screen_offset, self.player_id)

	self.scroll_timer:Reset()
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
