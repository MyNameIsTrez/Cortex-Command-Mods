-- REQUIREMENTS ----------------------------------------------------------------

local sounds = dofile("modmod.rte/data/sounds.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M:init()
	self.mosr_sounds = {}
	for _, sound_value in pairs(sounds) do
		if self.mosr_sounds[sound_value] == nil then
			self.mosr_sounds[sound_value] = CreateSoundContainer(sound_value, "modmod.rte")
		end
	end

	self.sounds = {}
	for sound_key, sound_value in pairs(sounds) do
		self.sounds[sound_key] = self.mosr_sounds[sound_value]
	end

	return self
end

function M:play(sound_key)
	self.sounds[sound_key]:Play()
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
