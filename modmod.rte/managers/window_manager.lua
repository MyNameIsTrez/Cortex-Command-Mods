-- REQUIREMENTS ----------------------------------------------------------------


local utils = dofile("utils.rte/Modules/Utils.lua")

local colors = dofile("utils.rte/Data/Colors.lua");


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init()
	self.target_wrapped = false

	self.scene_width = SceneMan.SceneWidth
	self.half_scene_width = self.scene_width / 2
	self.scene_height = SceneMan.SceneHeight
	self.half_scene_height = self.scene_height / 2

	self.screen_width = FrameMan.PlayerScreenWidth
	self.screen_height = FrameMan.PlayerScreenHeight
	self.half_screen_size = Vector(self.screen_width, self.screen_height) / 2

	self.text_top_padding = 3
	local text_bottom_padding = 3

	self.text_is_small = true

	local no_maximum_width = 0
	local font_height = FrameMan:CalculateTextHeight("foo", no_maximum_width, self.text_is_small)
	self.text_vertical_stride = self.text_top_padding + font_height + text_bottom_padding

	self.background_color = 146
	self.background_border_color = 71
	self.selected_color = 117
	self.unselected_color = 144

	self.player_id = utils.get_first_human_player_id()
	SceneMan:SetOffset(Vector(0, 0), self.player_id) -- TODO: Necessary?
	-- SceneMan:SetOffset(Vector(10, 10), self.player_id)
	self.screen_offset = SceneMan:GetOffset(self.player_id)
	-- self.screen_offset = Vector(0, 0)

	self.screen_of_player = ActivityMan:GetActivity():ScreenOfPlayer(self.player_id)
	self.scroll_speed = 0.3 -- TODO: This needs to be dynamic
	self.scroll_timer = Timer()

	self.alignment = { left = 0, center = 1, right = 2 }

	self.selectable_windows = { object_tree = 0, properties = 1 }
	self.selected_window = self.selectable_windows.object_tree

	return self
end


function M:update()
	self:_update_screen_offset()
end


function M:draw_border_fill(top_left_pos, width, height, color)
	self:_draw_box_fill(top_left_pos, width, height, color)
	self:draw_border(top_left_pos, width, height)
end


function M:draw_border(top_left_pos, width, height)
	self:_draw_box(top_left_pos, width, height, self.background_border_color)
	self:_draw_box(top_left_pos + Vector(1, 1), width - 2, height - 2, self.background_border_color)
end


function M:draw_selected_line_background(top_left_pos, width)
	self:_draw_line(top_left_pos + Vector(4 - 1, 0), width - 4 * 2 + 1, 0, self.selected_color)
	self:_draw_line(top_left_pos + Vector(4 - 1, self.text_vertical_stride - 1), width - 4 * 2 + 1, 0, self.selected_color)
end


function M:draw_text_line(x, width, x_padding, y_padding, height_index, text, alignment)
	local y = y_padding + self.text_top_padding + height_index * self.text_vertical_stride

	local pos
	if alignment == self.alignment.left then
		pos = Vector(x + x_padding, y)
	else
		pos = Vector(x + width / 2, y)
	end

	self:_draw_text(pos, text, self.text_is_small, alignment);

	self:_draw_line(Vector(x + 4 - 1, y_padding + height_index * self.text_vertical_stride), width - 4 * 2 + 1, 0, self.unselected_color)
	self:_draw_line(Vector(x + 4 - 1, y_padding + (height_index + 1) * self.text_vertical_stride - 1), width - 4 * 2 + 1, 0, self.unselected_color)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M:_draw_box(top_left_pos, width, height, color)
	PrimitiveMan:DrawBoxPrimitive(self.screen_offset + top_left_pos, self.screen_offset + top_left_pos + Vector(width - 1, height - 1), color)
end


function M:_draw_box_fill(top_left_pos, width, height, color)
	local screen_top_left_pos = self.screen_offset + top_left_pos
	PrimitiveMan:DrawBoxFillPrimitive(screen_top_left_pos, screen_top_left_pos + Vector(width - 1, height - 1), color)
end


function M:_draw_line(top_left_pos, offset_x, offset_y, color)
	PrimitiveMan:DrawLinePrimitive(self.screen_offset + top_left_pos, self.screen_offset + top_left_pos + Vector(offset_x, offset_y), color)
end


function M:_draw_text(top_left_pos, text, text_is_small, alignment)
	PrimitiveMan:DrawTextPrimitive(self.screen_offset + top_left_pos, text, text_is_small, alignment);
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
		-- print("x")
	end

	-- TODO: Why doesn't copying the X and Y work?
	-- self.previous_scroll_target.X = scroll_target.X
	-- self.previous_scroll_target.Y = scroll_target.Y
	self.previous_scroll_target = Vector(scroll_target.X, scroll_target.Y)

	if TimerMan:DrawnSimUpdate() then
		if self.target_wrapped then
			if SceneMan.SceneWrapsX then
				if scroll_target.X < self.half_scene_width then
					-- print("a")
					-- print(self.screen_offset.X)
					-- print(self.scene_width)
					self.screen_offset.X = self.screen_offset.X - self.scene_width
					-- print(self.screen_offset.X)
				else
					-- print("b")
					-- print(self.screen_offset.X)
					-- print(self.scene_width)
					self.screen_offset.X = self.screen_offset.X + self.scene_width
					-- print(self.screen_offset.X)
				end
			end

			if SceneMan.SceneWrapsY then
				if scroll_target.Y < self.half_scene_height then
					self.screen_offset.Y = self.screen_offset.Y - self.scene_height
				else
					self.screen_offset.Y = self.screen_offset.Y + self.scene_height
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

	-- self.screen_offset = new_screen_offset.Floored

	SceneMan:SetOffset(old_screen_offset, self.player_id)

	self.scroll_timer:Reset()
end


-- MODULE END ------------------------------------------------------------------


return M;