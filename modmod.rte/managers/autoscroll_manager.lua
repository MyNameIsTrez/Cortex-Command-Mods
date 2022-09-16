-- REQUIREMENTS ----------------------------------------------------------------


local keys = dofile("utils.rte/Data/Keys.lua");


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init()
	self.keys = {
		[keys.ArrowUp] = Timer(),
		[keys.ArrowDown] = Timer(),
	}

	self.minimum_ms_held_before_autoscroll = 200
	self.ms_between_autoscrolls = 50

	for _, timer in pairs(self.keys) do
		timer:SetRealTimeLimitMS(self.minimum_ms_held_before_autoscroll)
	end

	return self
end


function M:move(key)
	if UInputMan:KeyPressed(key) then
		return true
	end

	if UInputMan:KeyHeld(key) then
		local ms_held_autoscrolling = self.keys[key].ElapsedRealTimeMS - self.minimum_ms_held_before_autoscroll

		if self.keys[key]:IsPastRealTimeLimit() and ms_held_autoscrolling > self.ms_between_autoscrolls then
			self.keys[key].ElapsedRealTimeMS = self.minimum_ms_held_before_autoscroll
			return true
		end
	else
		self.keys[key]:Reset()
	end

	return false
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
