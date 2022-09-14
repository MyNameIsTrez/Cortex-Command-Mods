-- REQUIREMENTS ----------------------------------------------------------------


local window_manager = dofile("modmod.rte/managers/window_manager.lua")
local object_tree_manager = dofile("modmod.rte/managers/object_tree_manager.lua")
local properties_manager = dofile("modmod.rte/managers/properties_manager.lua")


-- GLOBAL SCRIPT START ---------------------------------------------------------


function ModMod:StartScript()
	self.window_manager = window_manager:init()
	-- self.navigation_manager = navigation_manager:init()
	self.object_tree_manager = object_tree_manager:init(self.window_manager)
	self.properties_manager = properties_manager:init(self.window_manager)
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function ModMod:UpdateScript()
	self.window_manager:update()
	-- self.navigation_manager:update()
	self.object_tree_manager:update()
	self.properties_manager:update()
end
