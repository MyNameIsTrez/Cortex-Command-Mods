-- REQUIREMENTS ----------------------------------------------------------------


local window_manager = dofile("modmod.rte/managers/window_manager.lua")
local autoscroll_manager = dofile("modmod.rte/managers/autoscroll_manager.lua")
local object_tree_manager = dofile("modmod.rte/managers/object_tree_manager.lua")
local properties_manager = dofile("modmod.rte/managers/properties_manager.lua")

local keys = dofile("utils.rte/Data/Keys.lua");

-- TODO: Remove
local input_handler = dofile("utils.rte/Modules/InputHandler.lua");
local key_codes = dofile("utils.rte/Data/KeyCodes.lua");


-- GLOBAL SCRIPT START ---------------------------------------------------------


function ModMod:StartScript()
	self.activity = ActivityMan:GetActivity()

	self.run_update_function = false
	self.initialized = false
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function ModMod:UpdateScript()
	local controlled_actor = self.activity:GetControlledActor(Activity.PLAYER_1)

	if controlled_actor ~= nil then
		if self.run_update_function then
			controlled_actor.Status = Actor.INACTIVE
		end
		if not self.run_update_function then
			controlled_actor.Status = Actor.STABLE
		end
		if self.previous_frame_controlled_actor ~= nil and controlled_actor.UniqueID ~= self.previous_frame_controlled_actor.UniqueID then
			self.previous_frame_controlled_actor.Status = Actor.STABLE
		end
	elseif self.previous_frame_controlled_actor ~= nil then
		self.previous_frame_controlled_actor.Status = Actor.STABLE
	end

	if UInputMan:KeyPressed(keys.N) then
		self.run_update_function = not self.run_update_function

		if not self.initialized then
			self.initialized = true
			self:initialize()
		end
	end

	self.previous_frame_controlled_actor = controlled_actor

	if not self.run_update_function then
		return
	end

	if input_handler.any_key_pressed() then
		self.held_key_character = input_handler.get_held_key_character()
		-- print("Held key character: " .. tostring(self.held_key_character))
		-- ConsoleMan:SaveAllText("LogConsole.txt")
	end

	self.window_manager:update()

	if UInputMan:KeyPressed(keys.ArrowRight)
		and self.window_manager.selected_window == self.window_manager.selectable_windows.object_tree
		and self.object_tree_manager:has_not_collapsed_properties_object_selected() then
		self.window_manager.selected_window = self.window_manager.selectable_windows.properties
	elseif UInputMan:KeyPressed(keys.ArrowLeft)
		and self.window_manager.selected_window == self.window_manager.selectable_windows.properties and not self.properties_manager.is_editing_line then
		self.properties_manager.selected_property_index = 1
		self.window_manager.selected_window = self.window_manager.selectable_windows.object_tree
	elseif self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
		self.properties_manager:update()
	elseif self.window_manager.selected_window == self.window_manager.selectable_windows.object_tree then
		self.object_tree_manager:update()
	end

	self.object_tree_manager:draw()
	self.properties_manager:draw()

	-- if not self.x_pressed and UInputMan:KeyPressed(keys.X) then
	-- 	print("Pressed X")
	-- 	ConsoleMan:SaveAllText("LogConsole.txt")

	-- 	self.x_pressed = true
	-- end

	-- if self.x_pressed and input_handler.any_key_pressed() then
	-- 	print(input_handler.get_held_key_character())
	-- 	ConsoleMan:SaveAllText("LogConsole.txt")
	-- end
end


-- FUNCTIONS -------------------------------------------------------------------


function ModMod:initialize()
	self.window_manager = window_manager:init()
	self.autoscroll_manager = autoscroll_manager:init()
	self.object_tree_manager = object_tree_manager:init(self.window_manager, self.autoscroll_manager)
	self.properties_manager = properties_manager:init(self.window_manager, self.object_tree_manager, self.autoscroll_manager, self)

	UInputMan:WhichKeyHeld()
end
