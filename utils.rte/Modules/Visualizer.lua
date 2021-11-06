-- REQUIREMENTS ----------------------------------------------------------------


local colors = require("Data.Colors");


-- MODULE START ----------------------------------------------------------------


local M = {};
_G[...] = M;


-- CONFIGURABLE VARIABLES ------------------------------------------------------





-- INTERNAL VARIABLES ----------------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


-- function Visualizer:StartScript()
-- 	-- self.continuousFns = {
-- 	-- 	E = function()
-- 	-- 		print("E stands for Epic!")
-- 	-- 	end,
-- 	-- 	B = function()
-- 	-- 		for i = 1, 3 do
-- 	-- 			print(i .. ", ")
-- 	-- 		end
-- 	-- 		print("uh! My baby don't mess around because she loves me so, and this I know for sure")
-- 	-- 	end,
-- 	-- };
-- 	-- self.toggledFns = {
-- 	-- 	C = function()
-- 	-- 		PrimitiveMan:DrawBoxFillPrimitive(Vector(500, 500), Vector(1000, 1000), 42)
-- 	-- 	end,
-- 	-- };

-- 	-- self.updateTimer = Timer();
-- 	-- self.updateTimer:SetSimTimeLimitMS(1000);
-- 	-- self.i = 0;
-- end


-- function Visualizer:UpdateScript()
-- 	local startX = 100; local startY = 100;
-- 	local w = 16; local h = 16;
-- 	for yIndex = 1, 16 do
-- 		for xIndex = 1, 16 do
-- 			local x1 = startX + xIndex * w;
-- 			local y1 = startY + yIndex * h;
-- 			local x2 = x1 + w;
-- 			local y2 = y1 + h;
-- 			local colorIndex = xIndex + yIndex * 16 - 16;
-- 			PrimitiveMan:DrawBoxFillPrimitive(Vector(x1, y1), Vector(x2, y2), colorIndex - 1);
-- 		end
-- 	end
-- 	-- PrimitiveMan:DrawBoxFillPrimitive(Vector(1000, 1000), Vector(1010, 1010), 1)
-- 	-- PrimitiveMan:DrawBoxFillPrimitive(Vector(1010, 1010), Vector(1020, 1020), 244)
-- 	-- PrimitiveMan:DrawBoxFillPrimitive(Vector(1020, 1020), Vector(1030, 1030), 244)
-- 	-- PrimitiveMan:DrawBoxFillPrimitive(Vector(1030, 1030), Vector(1040, 1040), 244)
-- 	-- PrimitiveMan:DrawTextPrimitive(Vector(100, 350), tostring(UInputMan:AnyInput()), false, 0);
-- 	-- if UInputMan:AnyInput() then
-- 	-- 	self.i = self.i + 1;
-- 	-- end
-- 	-- print(self.i)
-- 	-- PrimitiveMan:DrawTextPrimitive(Vector(100, 100), tostring(self.i), false, 0);
-- 	-- if self.updateTimer:IsPastSimTimeLimit() then
-- 	-- 	self.updateTimer:Reset();
-- 	-- 	self.i = 0;
-- 	-- end
-- 	-- Handle(self.continuousFns, self.toggledFns);
-- 	-- HandleContinuous(self.continuousFns);
-- 	-- HandleToggled(self.toggledFns);
-- end

-- KeyInput = {
-- 	A = 1,
-- 	C = 3,
-- };

-- function Visualizer:StartScript(self)
--     self.anyInputFunctions = {
--         A = function() print("hi"); end,
--         C = function() self:ReloadScripts(); end
--     };
-- end

-- function Visualizer:UpdateScript(self)
--     HandleAnyInput(self.anyInputFunctions);
-- end

-- function HandleAnyInput(inputFunctions)
--     for keyName, functionToRun in pairs(inputFunctions) do
-- 		local keyID = KeyInput[keyName]
--         if UInputMan:KeyPressed(keyID) then
--             functionToRun();
--         end
--     end
-- end


function Visualizer:UpdateScript(self)
	local radius = 10;

	for actor in MovableMan.Actors do
		PrimitiveMan:DrawCirclePrimitive(actor.Pos, radius, colors.red);
	end

	for actor in MovableMan.Particles do
		PrimitiveMan:DrawCirclePrimitive(actor.Pos, radius, colors.yellow);
	end
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;