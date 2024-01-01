local ui = require("ui")

-- TODO: Do this instead
-- local screen_scale = FrameMan.PlayerScreenScale
local screen_scale = 2

function ExampleUI:StartScript()
	print("In ExampleUI:StartScript()")

	ui.screen_scale = 2

	self.menu_is_open = false

	self.activity = ActivityMan:GetActivity()
	self.gameActivity = ToGameActivity(self.activity)

	self.cursor_mosparticle = CreateMOSParticle("Cursor", "example_ui.rte")

	local cursor_mos = ToMOSprite(self.cursor_mosparticle)
	self.cursor_size = Vector(cursor_mos:GetSpriteWidth(), cursor_mos:GetSpriteHeight())

	self.funds_changed_sound = CreateSoundContainer("Funds Changed", "Base.rte")
end

function ExampleUI:UpdateScript()
	-- print("In ExampleUI:UpdateScript()")

	if UInputMan:KeyPressed(Key.M) then
		self.menu_is_open = not self.menu_is_open

		local lock = self.menu_is_open

		-- CIM stands for ControllerInputMode
		self.gameActivity:LockControlledActor(Activity.PLAYER_1, lock, Controller.CIM_DISABLED)
	end

	if self.menu_is_open then
		if ui:button("Add 100 gold", Vector(50, 50), Vector(80, 50)) then
			local team_funds = self.activity:GetTeamFunds(Activity.TEAM_1)
			self.activity:SetTeamFunds(team_funds + 100, Activity.TEAM_1)
			self.funds_changed_sound:Play()
		end
		if ui:button("Add 1000 gold", Vector(50, 100), Vector(80, 50)) then
			local team_funds = self.activity:GetTeamFunds(Activity.TEAM_1)
			self.activity:SetTeamFunds(team_funds + 1000, Activity.TEAM_1)
			self.funds_changed_sound:Play()
		end

		local mouse_pos = UInputMan:GetMousePos() / screen_scale

		local screen_id = 0
		local world_pos = mouse_pos + CameraMan:GetOffset(screen_id)

		local cursor_center_pos = world_pos + self.cursor_size / 2

		local rotation_angle = 0
		local frame_index = 0
		PrimitiveMan:DrawBitmapPrimitive(cursor_center_pos, self.cursor_mosparticle, rotation_angle, frame_index)
	end
end
