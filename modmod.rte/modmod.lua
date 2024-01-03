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
	-- utils.print(self.object_tree)

	self:update_object_tree_text(self.object_tree)

	self.cursor_mosparticle = CreateMOSParticle("Cursor", "modmod.rte")
	local cursor_mos = ToMOSprite(self.cursor_mosparticle)
	self.cursor_size = Vector(cursor_mos:GetSpriteWidth(), cursor_mos:GetSpriteHeight())

	self.show_modmod = CreateSoundContainer("Menu Enter", "modmod.rte")
	self.hide_modmod = CreateSoundContainer("Menu Exit", "modmod.rte")
	self.expand = CreateSoundContainer("Item Change", "modmod.rte")
	self.collapse = CreateSoundContainer("Item Change", "modmod.rte")
	-- self.switch_window = CreateSoundContainer("Focus Change", "modmod.rte")
	-- self.up = CreateSoundContainer("Selection Change", "modmod.rte")
	-- self.down = CreateSoundContainer("Selection Change", "modmod.rte")
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

	local depth = 0
	local object_tree_width = self:get_object_tree_width(self.object_tree, depth)
	-- utils.print{object_tree_width = object_tree_width}

	local object_tree_height = self:get_object_tree_height(self.object_tree)
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

	local height_ptr = { 0 }
	local depth = 0
	local selected_object_path = "."
	self:object_tree_buttons(self.object_tree, object_tree_width, height_ptr, depth, selected_object_path)

	local world_pos = ui.screen_offset + ui.mouse_pos
	local cursor_center_pos = world_pos + self.cursor_size / 2
	local rotation_angle = 0
	local frame_index = 0
	PrimitiveMan:DrawBitmapPrimitive(cursor_center_pos, self.cursor_mosparticle, rotation_angle, frame_index)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function ModMod:update_object_tree_text(object_tree)
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

		v.text = str

		if v.children ~= nil and not v.collapsed then
			self:update_object_tree_text(v)
		end
	end
end

function ModMod:get_object_tree_width(object_tree, depth)
	local width = 106

	local padding = ui.window_left_padding + depth * ui.pixels_of_indentation_per_depth + ui.window_right_padding

	for _, v in ipairs(object_tree.children) do
		if v.children ~= nil and not v.collapsed then
			width = math.max(width, self:get_object_tree_width(v, depth + 1))
		else
			width = math.max(width, FrameMan:CalculateTextWidth(v.text, ui.text_is_small) + padding)
		end
	end

	return width
end

function ModMod:get_object_tree_height(object_tree)
	return ui.text_top_padding + 1 + ui.text_vertical_stride * self:get_object_tree_line_count(object_tree)
end

function ModMod:get_object_tree_line_count(object_tree)
	local count = 0

	for _, v in ipairs(object_tree.children) do
		if v.children ~= nil and not v.collapsed then
			count = count + self:get_object_tree_line_count(v)
		else
			count = count + 1
		end
	end

	return count
end

function ModMod:object_tree_buttons(object_tree, object_tree_width, height_ptr, depth, selected_object_path)
	local text_x = ui.window_left_padding + depth * ui.pixels_of_indentation_per_depth

	for _, selected_object in ipairs(object_tree.children) do
		height_ptr[1] = height_ptr[1] + 1

		-- TODO: An optional optimization is to return when height goes past the max height
		if height_ptr[1] > ui.object_tree_line_scroll_offset then
			local height_index = height_ptr[1] - ui.object_tree_line_scroll_offset
			local text_vertical_stride = (height_index - 1) * ui.text_vertical_stride
			local y = ui.window_top_padding + text_vertical_stride
			local pos = Vector(2, y)
			local width = object_tree_width - 4
			local is_directory = selected_object.directory_name ~= nil

			if ui:object_tree_button(selected_object.text, pos, width, text_x, is_directory) then
				if is_directory then
					local path = utils.path_join(selected_object_path, selected_object.directory_name)
					self:object_tree_directory_pressed(selected_object, path)
				else
					local path = utils.path_join(selected_object_path, selected_object.file_name)
					self:object_tree_subobject_pressed(selected_object, path)
				end
			end
		end

		-- If this is an expanded directory, recurse
		if selected_object.children ~= nil and not selected_object.collapsed then
			local path = utils.path_join(selected_object_path, selected_object.directory_name)

			self:object_tree_buttons(selected_object, object_tree_width, height_ptr, depth + 1, path)
		end
	end
end

function ModMod:object_tree_directory_pressed(directory, selected_object_path)
	if directory.collapsed then
		if directory.children == nil then
			local children = {}

			for directory_name in LuaMan:GetDirectoryList(selected_object_path) do
				table.insert(children, {
					directory_name = directory_name,
					collapsed = true,
				})
			end

			for file_name in LuaMan:GetFileList(selected_object_path) do
				if utils.path_extension(file_name) == ".ini" then
					-- TODO: Remove?
					-- local file_path = utils.path_join(selected_object_path, file_name)
					-- local file_object = object_tree_generator.get_file_object_tree(file_path)
					-- table.insert(children, file_object)

					table.insert(children, {
						file_name = file_name,
					})
				end
			end

			if #children > 0 then
				directory.children = children
			end
		end

		if directory.children ~= nil then
			directory.collapsed = false
			self:update_object_tree_text(self.object_tree)
			self.expand:Play()
		end
	else
		directory.collapsed = true
		self:update_object_tree_text(self.object_tree)
		self.collapse:Play()
	end
end

function ModMod:object_tree_subobject_pressed(subobject, selected_object_path)
	-- TODO: Show object in properties tab
	print("foo")
end
