function Bone:StartScript()
	self.playing = false
	self.ticks_playing_frame = 0

	local supported_resolutions = {
		["1920x1080"] = true,
		["1280x720"] = true,
		["960x540"] = true,
	}

	local screen_size = tostring(FrameMan.PlayerScreenWidth) .. "x" .. tostring(FrameMan.PlayerScreenHeight)

	if supported_resolutions[screen_size] == nil then
		error(
			"Your resolution setting has boned you! Change it in the settings menu to 1920x1080 or 1280x720 or 960x540"
		)
	end

	self.bone_sound = CreateSoundContainer("Bone", "bone.rte")

	self.bone_mosparticle = CreateMOSParticle("Bone " .. screen_size, "bone.rte")

	local bone_mos = ToMOSprite(self.bone_mosparticle)
	self.bone_size = Vector(bone_mos:GetSpriteWidth(), bone_mos:GetSpriteHeight())
end

function Bone:UpdateScript()
	if not self.playing and UInputMan:KeyPressed(2) and not self.bone_sound:IsBeingPlayed() then
		self.playing = true
		self.frame_index = 0
		self.bone_sound:Play()
	elseif self.playing and self.frame_index <= 47 then
		local screen_offset = CameraMan:GetOffset(Activity.PLAYER_1)
		local center_position = screen_offset + self.bone_size / 2
		local rotation_angle = 0
		PrimitiveMan:DrawBitmapPrimitive(center_position, self.bone_mosparticle, rotation_angle, self.frame_index)

		self.ticks_playing_frame = self.ticks_playing_frame + 1

		if self.ticks_playing_frame % 2 == 0 then
			self.frame_index = self.frame_index + 1
			self.ticks_playing_frame = 0
		end
	elseif self.playing then
		self.playing = false
	end
end
