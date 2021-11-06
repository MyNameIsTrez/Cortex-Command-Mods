-- REQUIREMENTS ----------------------------------------------------------------


local utils = require("Modules.Utils");


-- GLOBAL SCRIPT START ---------------------------------------------------------


function Benchmarker:StartScript()
	-- CONFIGURABLE VARIABLES
	

	-- Wait for at least 2 frames, because the first frame includes the time it took to load the scene.
	-- It also allows the user to go back to the main menu to disable the benchmarker, before the game slows down to a crawl.
	self.frameDelayBeforeBenchmarking = 100;

	
	-- INTERNAL VARIABLES
	self.tests = {};
	self.timer = Timer();
	self.frame = 0;
	self.finished = false;
	self.ranTest = false;

	Benchmarker:AddTests();
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function Benchmarker:UpdateScript()
	-- self.frame = self.frame + 1;

	-- local a = 0;

	-- if self.frame <= 6 then
	-- 	for _ = 1, 1e8 do a = a + 1 end
	-- 	print(self.timer.ElapsedRealTimeMS);
	-- 	self.timer:Reset();
	-- elseif self.frame <= 12 then
	-- 	print(self.timer.ElapsedRealTimeMS);
	-- 	self.timer:Reset();
	-- end

	-- if self.frame <= 6 then
	-- 	print(self.timer.ElapsedRealTimeMS);
	-- 	self.timer:Reset();
	-- end

	if not self.finished then
		Benchmarker:AdvanceFrame();
	end
end


-- METHODS ---------------------------------------------------------------------


function Benchmarker:AdvanceFrame()
	self.frame = self.frame + 1;

	if self.frame == 1 then
		utils.Printf("Waiting for %d frames before starting the benchmark...", self.frameDelayBeforeBenchmarking);
	end

	-- If no tests have been added, abort benchmarking.
	if self.frame == 1 and #self.tests == 0 then
		Benchmarker:Finish();
		return;
	end

	if self.frame >= self.frameDelayBeforeBenchmarking then
		-- Benchmark every other frame so the game gets enough time to update self.timer.ElapsedRealTimeMS
		if not self.ranTest then
			self.timer:Reset();
			Benchmarker:RunNextTest();
			self.ranTest = true;
		else
			local iterations, funName = unpack(table.remove(self.tests));

			local formattediterations = utils.AddThousandsSeparator(iterations);
			local formattedMilliseconds = utils.AddThousandsSeparator(self.timer.ElapsedRealTimeMS);
			utils.Printf("iterations: %s, function name: %s, elapsed time: %s milliseconds", formattediterations, funName, formattedMilliseconds);

			self.ranTest = false;

			if #self.tests == 0 then
				Benchmarker:Finish();
				return;
			end
		end
	end
end


function Benchmarker:Finish()
	self.finished = true;

	print("Finished benchmarking!");
end


function Benchmarker:AddTests(timer)
	local input = 0.5;
	local inputStart = -1;
	local inputEnd = 1;
	local outputStart = 2;
	local outputEnd = 3;


	local slope = utils.GetMapSlope(inputStart, inputEnd, outputStart, outputEnd);

	-- Comment out any benchmarks you don't want to run!

	-- Benchmarker:AddTest(1e8, "utils.Map", utils.Map, { input, inputStart, inputEnd, outputStart, outputEnd });
	-- Benchmarker:AddTest(1e8, "utils.MapUsingSlope", utils.MapUsingSlope, { input, slope, outputStart, outputEnd });


	-- Website with interesting tests to try: https://springrts.com/wiki/Lua_Performance

	local a = {};
	for i = 1, 100 do
		a[i] = i;
	end

	Benchmarker:AddTest(1e7, "pairs",
		function(a)
			local x;
			for _, v in pairs(a) do
				x = v;
			end
		end,
		{ a }
	);
	Benchmarker:AddTest(1e7, "ipairs",
		function(a)
			local x;
			for _, v in ipairs(a) do
				x = v;
			end
		end,
		{ a }
	);
	Benchmarker:AddTest(1e7, "for i = 1, x do",
		function(a)
			local x;
			for i = 1, 100 do
				x = a[i];
			end
		end,
		{ a }
	);
	Benchmarker:AddTest(1e7, "for i = 1, #a do",
		function(a)
			local x;
			for i = 1, #a do
				x = a[i];
			end
		end,
		{ a }
	);
	Benchmarker:AddTest(1e7, "for i = 1, length do (length not precalculated)",
		function(a)
			local x;
			local length = #a;
			for i = 1, length do
				x = a[i];
			end
		end,
		{ a }
	);
	Benchmarker:AddTest(1e7, "for i = 1, length do (length precalculated)",
		function(a, length)
			local x;
			for i = 1, length do
				x = a[i];
			end
		end,
		{ a, #a }
	);
end


function Benchmarker:AddTest(iterations, funName, fun, args)
	table.insert(self.tests, { iterations, funName, fun, args });
end


function Benchmarker:RunNextTest()
	local iterations, _, fun, args = unpack(self.tests[#self.tests]);

	for _ = 1, iterations do
		fun(unpack(args));
	end
end