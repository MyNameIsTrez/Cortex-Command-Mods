-- Source: Casey Muratori's "Immediate-Mode Graphical User Interfaces - 2005":
-- https://www.youtube.com/watch?v=Z1qyvQsjK5Y

-- MODULE START ----------------------------------------------------------------

local ui = {}

-- INTERNAL VARIABLES 1 --------------------------------------------------------

ui.alignments = { left = 0, center = 1, right = 2 }

-- TODO: Do this instead, once the function works in C++
-- ui.screen_scale = FrameMan.PlayerScreenScale
ui.screen_scale = 2

ui.screen_height = FrameMan.PlayerScreenHeight

ui.object_tree_line_scroll_offset = 0

-- CONFIGURABLE VARIABLES ------------------------------------------------------

-- TODO: Use color names, instead of raw values
-- TODO: The game just sets the line above and bellow the button to
-- TODO: yellow when it is hovered/clicked, but I can do more!
ui.button_color_normal = 13 -- Red
ui.button_color_hot = 122 -- Yellow
ui.button_color_active = 151 -- Green

ui.button_text_is_small = true
ui.button_text_alignment = ui.alignments.center

ui.light_green = 146
ui.dark_green = 144
ui.orange = 71
-- ui.yellow = 117
-- ui.white = 254

ui.pixels_of_indentation_per_depth = 15

ui.window_top_padding = 16
ui.window_left_padding = 15
ui.window_right_padding = 40

ui.text_is_small = true

ui.text_top_padding = 3

local no_max_width = 0
local text_bottom_padding = 3

-- INTERNAL VARIABLES 2 --------------------------------------------------------

ui.font_height = FrameMan:CalculateTextHeight("foo", no_max_width, ui.text_is_small)
ui.text_vertical_stride = ui.text_top_padding + ui.font_height + text_bottom_padding

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function ui:update()
	self.screen_offset = CameraMan:GetOffset(Activity.PLAYER_1)
	self.mouse_pos = UInputMan:GetMousePos() / self.screen_scale
end

function ui:filled_box_with_border(pos, size, filled_color, border_color)
	self:_filled_box(pos, size, filled_color)

	self:_box(pos, size, border_color)
	self:_box(pos + Vector(1, 1), size - Vector(2, 2), border_color)
end

function ui:object_tree_buttons(object_tree_strings, object_tree_width, height, depth)
	local x_padding = ui.window_left_padding + depth * ui.pixels_of_indentation_per_depth

	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			self:object_tree_buttons(v, object_tree_width, height, depth + 1)
		else
			-- Using a table as a pointer
			height[1] = height[1] + 1

			-- TODO: An optional optimization is to return when height goes past the max height
			if height[1] > self.object_tree_line_scroll_offset then
				local width = object_tree_width - 2
				local y_padding = ui.window_top_padding
				local height_index = height[1] - ui.object_tree_line_scroll_offset
				local text = v
				local alignment = ui.alignments.left

				local y = y_padding + self.text_top_padding + (height_index - 1) * self.text_vertical_stride
				local pos
				if alignment == self.alignments.left then
					pos = Vector(x_padding, y)
				else
					pos = Vector(width / 2, y)
				end
				self:_text(pos, text, self.text_is_small, alignment)

				local selection_lines_x = 0
				local selection_lines_y = y_padding + (height_index - 1) * self.text_vertical_stride
				self:_selection_lines(selection_lines_x, selection_lines_y, width, self.dark_green)

				-- self:_button(text, pos, size, x, width, y_padding, alignment)
			end
		end
	end
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function ui:_filled_box(pos, size, color)
	local world_pos = self.screen_offset + pos
	-- TODO: Is the -1 on width and height really necessary?
	-- TODO: Is it *really* not the caller's responsibility?
	PrimitiveMan:DrawBoxFillPrimitive(world_pos, world_pos + size - Vector(1, 1), color)
end

function ui:_box(pos, size, color)
	local world_pos = self.screen_offset + pos
	-- TODO: Is the -1 on width and height really necessary?
	-- TODO: Is it *really* not the caller's responsibility?
	PrimitiveMan:DrawBoxPrimitive(world_pos, world_pos + size - Vector(1, 1), color)
end

function ui:_text(pos, text, text_is_small, alignment)
	local world_pos = self.screen_offset + pos
	PrimitiveMan:DrawTextPrimitive(world_pos, text, text_is_small, alignment)
end

function ui:_selection_lines(x, y, width, color)
	local start_x = x + 4
	local offset = Vector(width - 4 * 2 + 1, 0)
	self:_line(Vector(start_x, y), offset, color)
	self:_line(Vector(start_x, y + self.text_vertical_stride - 1), offset, color)
end

function ui:_line(pos, offset, color)
	local world_pos = self.screen_offset + pos
	PrimitiveMan:DrawLinePrimitive(world_pos, world_pos + offset, color)
end

function ui:_button(text, pos, size)
	local clicked = false

	if self.active == text then
		if self:_left_mouse_went_up() then
			if self.hot == text then
				clicked = true
			end

			self.active = nil
		end
	elseif self.hot == text then
		if self:_left_mouse_went_down() then
			self.active = text
		end
	end

	if self.active == text then
		self:filled_box(pos, size, self.button_color_active)
	elseif self:_cursor_inside(pos, size) and self.active == nil then
		self:filled_box(pos, size, self.button_color_hot)

		self.hot = text
	else
		self:filled_box(pos, size, self.button_color_normal)

		if self.hot == text then
			self.hot = nil
		end
	end

	-- TODO: text_pos needs to have a different value when button_text_is_small is false
	local text_pos = pos
	if self.button_text_alignment == self.alignments.center then
		text_pos = text_pos + size / 2 + Vector(0, -5)
	end
	self:text(text_pos, text, self.button_text_is_small, self.button_text_alignment)

	return clicked
end

function ui:_left_mouse_went_up()
	return UInputMan:MouseButtonReleased(MouseButtons.MOUSE_LEFT)
end

function ui:_left_mouse_went_down()
	return UInputMan:MouseButtonPressed(MouseButtons.MOUSE_LEFT)
end

function ui:_cursor_inside(el_pos, size)
	local el_x = el_pos.X
	local el_y = el_pos.Y

	local el_width = size.X
	local el_height = size.Y

	local mouse_x = self.mouse_pos.X
	local mouse_y = self.mouse_pos.Y

	return (mouse_x > el_x) and (mouse_x < el_x + el_width) and (mouse_y > el_y) and (mouse_y < el_y + el_height)
end

-- MODULE END ------------------------------------------------------------------

return ui
