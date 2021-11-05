-- REQUIREMENTS ----------------------------------------------------------------


local utils = require("Modules/Utils");


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

	Benchmarker:AddTests();
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function Benchmarker:UpdateScript()
	if not self.finished then
		Benchmarker:AdvanceFrame();
	end
end


-- FUNCTIONS  ------------------------------------------------------------------


function Benchmarker:AdvanceFrame()
	if self.frame == 0 then
		utils.Printf("Waiting for %d frames before starting the benchmark...", self.frameDelayBeforeBenchmarking);
	end

	-- If no tests have been added, abort benchmarking.
	if self.frame == 0 and #self.tests == 0 then
		Benchmarker:Finish();
		return;
	end

	if self.frame >= self.frameDelayBeforeBenchmarking then
		-- Benchmark every other frame so the game gets enough time to update self.timer.ElapsedRealTimeMS
		if self.frame % 2 == 0 then
			self.timer:Reset();
			Benchmarker:RunTest();
		else
			local iterations, funName = unpack(table.remove(self.tests));

			local formattediterations = utils.AddThousandsSeparator(iterations);
			local formattedMilliseconds = utils.AddThousandsSeparator(self.timer.ElapsedRealTimeMS);
			utils.Printf("iterations: %s, function name: %s, elapsed time: %s milliseconds", formattediterations, funName, formattedMilliseconds);
			
			if #self.tests == 0 then
				Benchmarker:Finish();
				return;
			end
		end
	end

	self.frame = self.frame + 1;
end


function Benchmarker:Finish()
	self.finished = true;

	print("Finished benchmarking!");
end


-- Website with other interesting tests to write: https://springrts.com/wiki/Lua_Performance

function Benchmarker:AddTests(timer)
	local input = 0.5;
	local inputStart = -1;
	local inputEnd = 1;
	local outputStart = 2;
	local outputEnd = 3;

	local slope = utils.GetMapSlope(inputStart, inputEnd, outputStart, outputEnd);

	-- Comment out any benchmarks you don't want to do!
	Benchmarker:AddTest(1e8, "utils.Map", utils.Map, { input, inputStart, inputEnd, outputStart, outputEnd });
	Benchmarker:AddTest(1e8, "utils.MapCompact", utils.MapCompact, { input, inputStart, inputEnd, outputStart, outputEnd });
	Benchmarker:AddTest(1e8, "utils.MapUsingSlope", utils.MapUsingSlope, { input, slope, outputStart, outputEnd });
end


function Benchmarker:AddTest(iterations, funName, fun, args)
	table.insert(self.tests, { iterations, funName, fun, args });
end


function Benchmarker:RunTest()
	local iterations, _, fun, args = unpack(self.tests[#self.tests]);

	for _ = 1, iterations do
		fun(unpack(args));
	end
end