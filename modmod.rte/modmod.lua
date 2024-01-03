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

	-- self.min_object_tree_width = 106 -- TODO: Use
	-- self.max_object_tree_width = 300 -- TODO: Use
	self.object_tree_width = 200

	-- self.min_object_tree_height = ? -- TODO: Use
	-- self.max_object_tree_height = ? -- TODO: Use
	-- With a value of 20, max_visible_object_tree_lines will be 1, and with 36 it will be 2
	self.object_tree_height = 164 -- max_visible_object_tree_lines will be 10

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

	local object_tree_line_count = self:get_object_tree_line_count(self.object_tree)

	local max_visible_object_tree_lines = (self.object_tree_height - ui.text_top_padding - 1) / ui.button_height
	-- TODO: Check if the printed value is an exact integer and exactly right
	-- print(max_visible_object_tree_lines)

	local mouse_wheel_movement = UInputMan:MouseWheelMoved()
	if mouse_wheel_movement > 0 then -- if scrolling up
		ui.object_tree_line_scroll_offset = math.max(0, ui.object_tree_line_scroll_offset - mouse_wheel_movement)
	elseif mouse_wheel_movement < 0 then -- elseif scrolling down
		local max_object_tree_line_scroll_offset = math.max(0, object_tree_line_count - max_visible_object_tree_lines)

		-- Substracting mouse_wheel_movement is like adding it, since it's a negative value
		local new_offset = ui.object_tree_line_scroll_offset - mouse_wheel_movement
		if new_offset <= max_object_tree_line_scroll_offset then
			ui.object_tree_line_scroll_offset = new_offset
		end
	end

	local need_scrollbar = object_tree_line_count > max_visible_object_tree_lines
	if need_scrollbar then
		-- TODO: Draw scrollbar on the right of the object tree
	end

	local visible_object_tree_line_count = math.min(
		max_visible_object_tree_lines,
		object_tree_line_count - ui.object_tree_line_scroll_offset
	)
	local object_tree_height = ui.text_top_padding + 1 + ui.button_height * visible_object_tree_line_count
	-- utils.print{object_tree_height = object_tree_height}

	-- Draw empty area box above object tree
	ui:filled_box_with_border(Vector(0, 0), Vector(self.object_tree_width, ui.window_top_padding), ui.dark_green, ui.orange)

	-- Draw object tree box
	ui:filled_box_with_border(
		Vector(0, ui.window_top_padding - 2),
		Vector(self.object_tree_width, object_tree_height),
		ui.light_green,
		ui.orange
	)

	-- TODO: Draw a little handle on the bottom-right of the object tree for adjusting self.object_tree_width and self.object_tree_height
	-- utils.print{object_tree_width = self.object_tree_width}

	-- Draw empty area box below object tree
	local pos = Vector(0, ui.window_top_padding + object_tree_height - 4)
	local size = Vector(self.object_tree_width, self.object_tree_height - object_tree_height + 2)
	if size.Y > 2 then
		ui:filled_box_with_border(pos, size, ui.dark_green, ui.orange)
	end

	local height_ptr = { 0 }
	local depth = 0
	local selected_object_path = "."
	self:object_tree_buttons(
		self.object_tree,
		self.object_tree_width,
		height_ptr,
		ui.object_tree_line_scroll_offset,
		max_visible_object_tree_lines,
		depth,
		selected_object_path
	)

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
			str = str .. v.directory_name
		else
			str = str .. csts.get_property(v)
		end

		v.text = str

		if v.children ~= nil and not v.collapsed then
			self:update_object_tree_text(v)
		end
	end
end

function ModMod:get_object_tree_line_count(object_tree)
	local count = 0

	for _, v in ipairs(object_tree.children) do
		count = count + 1

		if v.children ~= nil and not v.collapsed then
			count = count + self:get_object_tree_line_count(v)
		end
	end

	return count
end

function ModMod:object_tree_buttons(
	object_tree,
	object_tree_width,
	height_ptr,
	object_tree_line_scroll_offset,
	max_visible_object_tree_lines,
	depth,
	selected_object_path
)
	local text_x = ui.window_left_padding + depth * ui.pixels_of_indentation_per_depth

	for _, selected_object in ipairs(object_tree.children) do
		height_ptr[1] = height_ptr[1] + 1

		if height_ptr[1] - object_tree_line_scroll_offset > max_visible_object_tree_lines then
			return
		end

		if height_ptr[1] > ui.object_tree_line_scroll_offset then
			local height_index = height_ptr[1] - ui.object_tree_line_scroll_offset
			local y = ui.window_top_padding + (height_index - 1) * ui.button_height
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

			self:object_tree_buttons(
				selected_object,
				object_tree_width,
				height_ptr,
				object_tree_line_scroll_offset,
				max_visible_object_tree_lines,
				depth + 1,
				path
			)
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
