-- REQUIREMENTS ----------------------------------------------------------------

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------

-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------

-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------

-- INTERNAL PRIVATE VARIABLES --------------------------------------------------

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init(window_manager, settings_manager, status_bar_width, status_bar_height)
	self.window_manager = window_manager
	self.settings_manager = settings_manager

	-- TODO: Write a proper HTML-like library so this width and height doesn't have to be jankily passed from the properties manager anymore
	self.status_bar_width = status_bar_width
	self.status_bar_height = status_bar_height

	self.status_bar_top_left = Vector(self.window_manager.screen_width - self.status_bar_width, 0)

	self.save_to_disk_mosr = CreateMOSRotating("Save to Disk", "modmod.rte")

	local save_to_disk_mos = ToMOSprite(self.save_to_disk_mosr)
	local save_to_disk_sprite_size = Vector(save_to_disk_mos:GetSpriteWidth(), save_to_disk_mos:GetSpriteHeight())

	self.save_to_disk_sprite_top_left = self.status_bar_top_left + save_to_disk_sprite_size / 2 + Vector(4, 4)

	return self
end

function M:key_pressed()
	if UInputMan:KeyPressed(key_bindings.save_to_disk) then
		self.settings_manager:invert("save_to_disk")
	end
end

function M:draw()
	self:_draw_status_bar_background()

	local frame = self.settings_manager:get("save_to_disk") and 1 or 0
	self.window_manager:draw_bitmap(self.save_to_disk_sprite_top_left, self.save_to_disk_mosr, 0, frame)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_draw_status_bar_background()
	self.window_manager:draw_border_fill(
		self.status_bar_top_left,
		self.status_bar_width,
		self.status_bar_height,
		self.window_manager.unselected_color
	)
end

-- MODULE END ------------------------------------------------------------------

return M
