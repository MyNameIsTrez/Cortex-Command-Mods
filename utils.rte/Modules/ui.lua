-- Source: Casey Muratori's "Immediate-Mode Graphical User Interfaces - 2005":
-- https://www.youtube.com/watch?v=Z1qyvQsjK5Y

-- MODULE START ----------------------------------------------------------------

local ui = {}

-- INTERNAL VARIABLES ----------------------------------------------------------

ui.alignments = { left = 0, center = 1, right = 2 }

-- TODO: Do this instead
-- ui.screen_scale = FrameMan.PlayerScreenScale
ui.screen_scale = 2

-- CONFIGURABLE VARIABLES ------------------------------------------------------

ui.button_color_normal = 13 -- Red
ui.button_color_hot = 122 -- Yellow
ui.button_color_active = 151 -- Green
ui.button_text_is_small = true
ui.button_text_alignment = ui.alignments.center

ui.background_color = 146 -- Dark green

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function ui:update()
	self.screen_offset = CameraMan:GetOffset(Activity.PLAYER_1)
	self.mouse_pos = UInputMan:GetMousePos() / self.screen_scale
end

function ui:button(text, pos, size)
	local clicked = false

	if self.active == text then
		if self:left_mouse_went_up() then
			if self.hot == text then
				clicked = true
			end

			self.active = nil
		end
	elseif self.hot == text then
		if self:left_mouse_went_down() then
			self.active = text
		end
	end

	local world_pos = self.screen_offset + pos

	if self.active == text then
		PrimitiveMan:DrawBoxFillPrimitive(world_pos, world_pos + size, self.button_color_active)
	elseif self:cursor_inside(pos, size) and self.active == nil then
		PrimitiveMan:DrawBoxFillPrimitive(world_pos, world_pos + size, self.button_color_hot)

		self.hot = text
	else
		PrimitiveMan:DrawBoxFillPrimitive(world_pos, world_pos + size, self.button_color_normal)

		if self.hot == text then
			self.hot = nil
		end
	end

	-- TODO: text_pos needs to be different when button_text_is_small is false
	local text_pos = world_pos
	if ui.button_text_alignment == ui.alignments.center then
		text_pos = text_pos + size / 2 + Vector(0, -5)
	end
	PrimitiveMan:DrawTextPrimitive(text_pos, text, self.button_text_is_small, self.button_text_alignment)

	return clicked
end

function ui:box(pos, size)
	local world_pos = self.screen_offset + pos

	PrimitiveMan:DrawBoxFillPrimitive(world_pos, world_pos + size, self.background_color)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function ui:left_mouse_went_up()
	return UInputMan:MouseButtonReleased(MouseButtons.MOUSE_LEFT)
end

function ui:left_mouse_went_down()
	return UInputMan:MouseButtonPressed(MouseButtons.MOUSE_LEFT)
end

function ui:cursor_inside(el_pos, size)
	local el_x = el_pos.X
	local el_y = el_pos.Y

	local el_width = size.X
	local el_height = size.Y

	local mouse_x = ui.mouse_pos.X
	local mouse_y = ui.mouse_pos.Y

	return (mouse_x > el_x) and (mouse_x < el_x + el_width) and (mouse_y > el_y) and (mouse_y < el_y + el_height)
end

-- MODULE END ------------------------------------------------------------------

return ui
