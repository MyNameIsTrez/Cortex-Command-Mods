-- REQUIREMENTS ----------------------------------------------------------------


local draw_manager = dofile("modmod.rte/object_tree_manager/draw_manager/draw_manager.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init()
	self.draw_manager = draw_manager:init()

	return self
end


function M:update()
	-- utils.RecursivelyPrint(object_tree_strings)

	self.draw_manager:draw()
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
