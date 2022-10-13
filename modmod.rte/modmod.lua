-- REQUIREMENTS ----------------------------------------------------------------

local window_manager = dofile("modmod.rte/managers/window_manager.lua")
local autoscroll_manager = dofile("modmod.rte/managers/autoscroll_manager.lua")
local object_tree_manager = dofile("modmod.rte/managers/object_tree_manager.lua")
local properties_manager = dofile("modmod.rte/managers/properties_manager.lua")
local status_bar_manager = dofile("modmod.rte/managers/status_bar_manager.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

-- TODO: Remove
local input_handler = dofile("utils.rte/Modules/InputHandler.lua")
local key_codes = dofile("utils.rte/Data/KeyCodes.lua")

-- GLOBAL SCRIPT START ---------------------------------------------------------

function ModMod:StartScript()
	self.activity = ActivityMan:GetActivity()

	self.run_update_function = false
	self.initialized = false

	-- UInputMan:WhichKeyHeld()
end

-- GLOBAL SCRIPT UPDATE --------------------------------------------------------

function ModMod:UpdateScript()
	self:update_controlled_actor()

	if UInputMan:KeyPressed(key_bindings.show_modmod) then
		self.run_update_function = not self.run_update_function

		if not self.initialized then
			self.initialized = true
			self:initialize()
		end
	end

	if not self.run_update_function then
		return
	end

	self:update()
	self:draw()
end

-- FUNCTIONS -------------------------------------------------------------------

function ModMod:update_controlled_actor()
	local controlled_actor = self.activity:GetControlledActor(Activity.PLAYER_1)

	if controlled_actor ~= nil then
		if self.run_update_function then
			controlled_actor.Status = Actor.INACTIVE
		end
		if not self.run_update_function then
			controlled_actor.Status = Actor.STABLE
		end
		if
			self.previous_frame_controlled_actor ~= nil
			and controlled_actor.UniqueID ~= self.previous_frame_controlled_actor.UniqueID
		then
			self.previous_frame_controlled_actor.Status = Actor.STABLE
		end
	elseif self.previous_frame_controlled_actor ~= nil then
		self.previous_frame_controlled_actor.Status = Actor.STABLE
	end

	self.previous_frame_controlled_actor = controlled_actor
end

function ModMod:initialize()
	self.window_manager = window_manager:init()
	self.autoscroll_manager = autoscroll_manager:init()
	self.object_tree_manager = object_tree_manager:init(self.window_manager, self.autoscroll_manager)
	self.properties_manager = properties_manager:init(
		self,
		self.window_manager,
		self.object_tree_manager,
		self.autoscroll_manager
	)
	self.status_bar_manager = status_bar_manager:init(
		self.window_manager,
		self.properties_manager.properties_width,
		self.properties_manager.window_top_padding
	)

	self.focus_change_sound = CreateSoundContainer("Focus Change", "modmod.rte")

	-- This is used in order for keys to be registered somewhat consistently
	-- TODO: Figure out and fix the C++ bug with Gacyr so this can be nuked
	UInputMan:WhichKeyHeld()
end

function ModMod:update()
	-- TODO: Shouldn't this be done in line_editor_manager.lua where self.held_key_character is used?
	if input_handler.any_key_pressed() then
		self.held_key_character = input_handler.get_held_key_character()
		-- print("Held key character: " .. tostring(self.held_key_character))
		-- ConsoleMan:SaveAllText("LogConsole.txt")
	end

	self.window_manager:update()

	local changed_selected_window = self:update_selected_window()

	if not changed_selected_window then
		if self.window_manager.selected_window == self.window_manager.selectable_windows.properties then
			self.properties_manager:update()
		elseif self.window_manager.selected_window == self.window_manager.selectable_windows.object_tree then
			self.object_tree_manager:update()
		end
	end

	self.status_bar_manager:update()
end

function ModMod:update_selected_window()
	if
		UInputMan:KeyPressed(key_bindings.right)
		and self.window_manager.selected_window == self.window_manager.selectable_windows.object_tree
		and self.object_tree_manager:has_not_collapsed_properties_object_selected()
	then
		self.window_manager.selected_window = self.window_manager.selectable_windows.properties

		self.focus_change_sound:Play()

		return true
	end

	if
		UInputMan:KeyPressed(key_bindings.left)
		and self.window_manager.selected_window == self.window_manager.selectable_windows.properties
		and not self.properties_manager.is_editing_line
	then
		self.properties_manager.selected_property_index = 1
		self.window_manager.selected_window = self.window_manager.selectable_windows.object_tree

		self.focus_change_sound:Play()

		return true
	end

	return false
end

function ModMod:draw()
	self.object_tree_manager:draw()
	self.properties_manager:draw()
	self.status_bar_manager:draw()
end
