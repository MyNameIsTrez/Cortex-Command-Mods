-- REQUIREMENTS ----------------------------------------------------------------

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

	-- TODO: Don't have this be gotten by being passed from properties_manager.lua pls
	self.status_bar_width = status_bar_width
	self.status_bar_height = status_bar_height

	return self
end

function M:update() end

function M:draw()
	self:_draw_status_bar_background()
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
