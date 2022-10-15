-- REQUIREMENTS ----------------------------------------------------------------

local sounds = dofile("modmod.rte/data/sounds.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init()
	local sound_containers = {}
	for _, sound_value in pairs(sounds) do
		if sound_containers[sound_value] == nil then
			sound_containers[sound_value] = CreateSoundContainer(sound_value, "modmod.rte")
		end
	end

	self.sounds = {}
	for sound_key, sound_value in pairs(sounds) do
		self.sounds[sound_key] = sound_containers[sound_value]
	end

	return self
end

function M:play(sound_key)
	local sound = self.sounds[sound_key]
	sound:Play()
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
