-- REQUIREMENTS ----------------------------------------------------------------

local window_manager = dofile("modmod.rte/managers/window_manager.lua")
local settings_manager = dofile("modmod.rte/managers/settings_manager.lua")
local sounds_manager = dofile("modmod.rte/managers/sounds_manager.lua")
local autoscroll_manager = dofile("modmod.rte/managers/autoscroll_manager.lua")
local object_tree_manager = dofile("modmod.rte/managers/object_tree_manager.lua")
local properties_manager = dofile("modmod.rte/managers/properties_manager.lua")
local status_bar_manager = dofile("modmod.rte/managers/status_bar_manager.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")

-- GLOBAL SCRIPT START ---------------------------------------------------------

function ModMod:StartScript()
	self.activity = ActivityMan:GetActivity()

	self.run_update_function = false
	self.initialized = false

	self.sounds_manager = sounds_manager:init()
end

-- GLOBAL SCRIPT UPDATE --------------------------------------------------------

function ModMod:UpdateScript()
	-- for actor in MovableMan.Actors do
	-- 	utils.print(actor)
	-- 	-- utils.print(actor.RightEngine)
	-- 	-- utils.print(ToACDropShip(actor))
	-- 	-- utils.print(ToACDropShip(actor).RightEngine)
	-- 	-- utils.print(ToACDropShip(actor).RightThruster)
	-- end
	-- for item in MovableMan.Items do
	-- 	utils.print(item)
	-- end
	-- for particle in MovableMan.Particles do
	-- 	utils.print(particle)
	-- end
	-- utils.print("--")

	-- for actor in MovableMan.AddedActors do
	-- 	utils.print(actor)
	-- end
	-- for item in MovableMan.AddedItems do
	-- 	utils.print(item)
	-- end
	-- for particle in MovableMan.AddedParticles do
	-- 	utils.print(particle)
	-- end

	self:update_controlled_actor()

	if UInputMan:KeyPressed(key_bindings.show_modmod) then
		self.run_update_function = not self.run_update_function

		if self.run_update_function then
			self.sounds_manager:play("show_modmod")
		else
			self.sounds_manager:play("hide_modmod")
		end

		if not self.initialized then
			self.initialized = true
			self:initialize()
		end
	end

	if not self.run_update_function then
		return
	end

	self:update()
	self:key_pressed()
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

	self.settings_manager = settings_manager:init()

	self.autoscroll_manager = autoscroll_manager:init()
	self.object_tree_manager = object_tree_manager:init(self)
	self.properties_manager = properties_manager:init(self)
	self.status_bar_manager = status_bar_manager:init(self)

	self.focus_change_sound = CreateSoundContainer("Focus Change", "modmod.rte")
end

function ModMod:update()
	self.window_manager:update()
end

function ModMod:key_pressed()
	self.status_bar_manager:key_pressed()

	if self:same_selected_window() then
		local selectable_windows = self.window_manager.selectable_windows

		if self.window_manager.selected_window == selectable_windows.properties then
			self.properties_manager:key_pressed()
		elseif self.window_manager.selected_window == selectable_windows.object_tree then
			self.object_tree_manager:key_pressed()
		end
	end
end

function ModMod:same_selected_window()
	local selectable_windows = self.window_manager.selectable_windows

	if
		UInputMan:KeyPressed(key_bindings.right)
		and self.window_manager.selected_window == selectable_windows.object_tree
		and self.object_tree_manager:has_not_collapsed_properties_object_selected()
	then
		self.window_manager.selected_window = selectable_windows.properties

		self.sounds_manager:play("switch_window")

		return false
	end

	if
		UInputMan:KeyPressed(key_bindings.left)
		and self.window_manager.selected_window == selectable_windows.properties
		and not self.properties_manager.is_editing_line
	then
		self.properties_manager.selected_property_index = 1
		self.window_manager.selected_window = selectable_windows.object_tree

		self.sounds_manager:play("switch_window")

		return false
	end

	return true
end

function ModMod:draw()
	self.object_tree_manager:draw()
	self.properties_manager:draw()
	self.status_bar_manager:draw()
end
