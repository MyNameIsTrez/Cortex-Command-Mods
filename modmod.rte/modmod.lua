-- REQUIREMENTS ----------------------------------------------------------------


local window_manager = dofile("modmod.rte/managers/window_manager.lua")
local object_tree_manager = dofile("modmod.rte/managers/object_tree_manager.lua")
local properties_manager = dofile("modmod.rte/managers/properties_manager.lua")

local keys = dofile("utils.rte/Data/Keys.lua");


-- GLOBAL SCRIPT START ---------------------------------------------------------


function ModMod:StartScript()
	self.window_manager = window_manager:init()
	self.object_tree_manager = object_tree_manager:init(self.window_manager)
	self.properties_manager = properties_manager:init(self.window_manager, self.object_tree_manager)
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function ModMod:UpdateScript()
	self.window_manager:update()

	if UInputMan:KeyPressed(keys.ArrowRight)
		and self.window_manager.selected_window == self.window_manager.selectable_windows.object_tree
		and self.object_tree_manager:has_not_collapsed_properties_object_selected() then
		self.window_manager.selected_window = self.window_manager.selectable_windows.properties
	elseif UInputMan:KeyPressed(keys.ArrowLeft)
		and self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
		self.window_manager.selected_window = self.window_manager.selectable_windows.object_tree
	elseif self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
		self.properties_manager:update()
	elseif self.window_manager.selected_window == self.window_manager.selectable_windows.object_tree then
		self.object_tree_manager:update()
	end

	self.object_tree_manager:draw()
	self.properties_manager:draw()
end
