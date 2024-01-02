-- REQUIREMENTS ----------------------------------------------------------------

-- TODO: Use require() in all files instead of dofile(),
-- once the issue of require()d modules not being reloaded on F2 is fixed

local object_tree_generator = dofile("modmod.rte/ini_object_tree/object_tree_generator.lua")
-- TODO: Get rid of loading csts.lua here, since it's an implementation detail?
local csts = dofile("modmod.rte/ini_object_tree/csts.lua")

local key_bindings = dofile("modmod.rte/data/key_bindings.lua")

local ui = dofile("utils.rte/Modules/ui.lua")
local utils = dofile("utils.rte/Modules/Utils.lua")

-- GLOBAL SCRIPT ---------------------------------------------------------------

function ModMod:StartScript()
	print("In ModMod:StartScript()")

	self.showing_modmod = false
	self.initialized = false

	self.activity = ActivityMan:GetActivity()
	self.gameActivity = ToGameActivity(self.activity)

	self.object_tree = {
		children = {
			{
				directory_name = "Data",
				collapsed = true,
			},
			{
				directory_name = "Mods",
				collapsed = true,
			},
		},
	}
	utils.print(self.object_tree)

	self.cursor_mosparticle = CreateMOSParticle("Cursor", "modmod.rte")
	local cursor_mos = ToMOSprite(self.cursor_mosparticle)
	self.cursor_size = Vector(cursor_mos:GetSpriteWidth(), cursor_mos:GetSpriteHeight())

	self.show_modmod = CreateSoundContainer("Menu Enter", "modmod.rte")
	self.hide_modmod = CreateSoundContainer("Menu Exit", "modmod.rte")
	-- self.switch_window = CreateSoundContainer("Focus Change", "modmod.rte")
	-- self.up = CreateSoundContainer("Selection Change", "modmod.rte")
	-- self.down = CreateSoundContainer("Selection Change", "modmod.rte")
	-- self.collapse = CreateSoundContainer("Item Change", "modmod.rte")
	-- self.expand = CreateSoundContainer("Item Change", "modmod.rte")
	-- self.up_object_tree_layer = CreateSoundContainer("Selection Change", "modmod.rte")
	-- self.start_editing_value = CreateSoundContainer("Focus Change", "modmod.rte")
	-- self.edited_value = CreateSoundContainer("Slice Picked", "modmod.rte")
	-- self.user_error = CreateSoundContainer("User Error", "modmod.rte")
	-- self.toggle_checkbox = CreateSoundContainer("Slice Picked", "modmod.rte")
	-- self.toggle_status = CreateSoundContainer("Slice Picked", "modmod.rte")
end

function ModMod:UpdateScript()
	ui:update()

	if UInputMan:KeyPressed(key_bindings.show_modmod) then
		self.showing_modmod = not self.showing_modmod

		if self.showing_modmod then
			self.show_modmod:Play()

			-- TODO: Why does this not seem to do anything?
			-- UInputMan:SetMousePos(Vector(500, 500), Activity.PLAYER_1)
		else
			self.hide_modmod:Play()
		end

		if not self.initialized then
			self.initialized = true

			-- self.window_manager = window_manager:init()
			-- self.object_tree_manager = object_tree_manager:init(self)
			-- self.properties_manager = properties_manager:init(self)
			-- self.status_bar_manager = status_bar_manager:init(self)
		end

		-- CIM stands for ControllerInputMode
		local lock = self.showing_modmod
		self.gameActivity:LockControlledActor(Activity.PLAYER_1, lock, Controller.CIM_AI)
	end

	if not self.showing_modmod then
		return
	end

	local object_tree_strings = self:get_object_tree_strings(self.object_tree)
	-- utils.print(object_tree_strings)

	local depth = 0
	local object_tree_width = self:get_object_tree_width(object_tree_strings, depth)
	-- utils.print{object_tree_width = object_tree_width}

	local object_tree_height = self:get_object_tree_height(object_tree_strings)
	-- utils.print{object_tree_height = object_tree_height}

	-- Draw empty area box above object tree
	ui:filled_box_with_border(Vector(0, 0), Vector(object_tree_width, ui.window_top_padding), ui.dark_green, ui.orange)

	-- Draw object tree box
	ui:filled_box_with_border(
		Vector(0, ui.window_top_padding - 2),
		Vector(object_tree_width, object_tree_height),
		ui.light_green,
		ui.orange
	)

	-- Draw empty area box below object tree
	ui:filled_box_with_border(
		Vector(0, ui.window_top_padding + object_tree_height - 4),
		Vector(object_tree_width, ui.screen_height - ui.window_top_padding - object_tree_height + 4),
		ui.dark_green,
		ui.orange
	)

	ui:object_tree_strings(object_tree_strings, object_tree_width, { 0 }, 0)

	local world_pos = ui.screen_offset + ui.mouse_pos

	local cursor_center_pos = world_pos + self.cursor_size / 2

	local rotation_angle = 0
	local frame_index = 0
	PrimitiveMan:DrawBitmapPrimitive(cursor_center_pos, self.cursor_mosparticle, rotation_angle, frame_index)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function ModMod:get_object_tree_strings(object_tree)
	local object_tree_strings = {}

	for _, v in ipairs(object_tree.children) do
		local str = ""

		if v.collapsed then
			str = str .. "v"
		elseif v.collapsed == false then
			str = str .. ">"
		else
			-- TODO: It's jank how this relies on two spaces
			-- being the same width as a "v" or a ">"
			str = str .. "  "
		end

		str = str .. " "

		if v.preset_name_pointer ~= nil then
			str = string.format("%s%s (%s)", str, v.preset_name_pointer.content, csts.get_property(v))
		elseif v.file_name ~= nil then
			str = str .. v.file_name
		elseif v.directory_name ~= nil then
			str = str .. v.directory_name .. "/"
		else
			str = str .. csts.get_property(v)
		end

		table.insert(object_tree_strings, str)

		if v.children ~= nil and not v.collapsed then
			table.insert(object_tree_strings, self:get_object_tree_strings(v))
		end
	end

	return object_tree_strings
end

function ModMod:get_object_tree_width(object_tree_strings, depth)
	local width = 0

	local padding = ui.window_left_padding + depth * ui.pixels_of_indentation_per_depth + ui.window_right_padding

	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			width = math.max(width, self:get_object_tree_width({ v, depth + 1 }))
		else
			width = math.max(width, FrameMan:CalculateTextWidth(v, ui.text_is_small) + padding)
		end
	end

	return width
end

function ModMod:get_object_tree_height(object_tree_strings)
	return ui.text_top_padding + 1 + ui.text_vertical_stride * self:get_object_tree_string_count(object_tree_strings)
end

function ModMod:get_object_tree_string_count(object_tree_strings)
	local count = 0

	for _, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			count = count + self:get_object_tree_string_count(v)
		else
			count = count + 1
		end
	end

	return count
end
