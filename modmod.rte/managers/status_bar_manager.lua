-- REQUIREMENTS ----------------------------------------------------------------

local settings = dofile("modmod.rte/data/settings.lua")
local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------

-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------

-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------

-- INTERNAL PRIVATE VARIABLES --------------------------------------------------

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init(window_manager, status_bar_width, status_bar_height)
	self.window_manager = window_manager

	-- TODO: Write a proper HTML-like library so this width and height doesn't have to be jankily passed from the properties manager anymore
	self.status_bar_width = status_bar_width
	self.status_bar_height = status_bar_height

	self.save_to_disk_sprite = CreateMOSRotating("Save to Disk", "modmod.rte")

	return self
end

function M:update() end

function M:draw()
	self:_draw_status_bar_background()

	local frame = settings.save_to_disk and 1 or 0
	self.window_manager:draw_bitmap(Vector(100, 100), self.save_to_disk_sprite, 0, frame)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function M:_draw_status_bar_background()
	self.window_manager:draw_border_fill(
		Vector(self.window_manager.screen_width - self.status_bar_width, 0),
		self.status_bar_width,
		self.status_bar_height,
		self.window_manager.unselected_color
	)
end

-- MODULE END ------------------------------------------------------------------

return M
