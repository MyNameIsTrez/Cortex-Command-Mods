require("Modules/BenchmarkerTests")


function Run(f, ...)
	local s = os.clock();
	for _ = 1, 1000000 do
		f(...);
	end
	return os.clock() - s;
end


function Compare(f1, f2, ...)
	local t1 = Run(f1, ...);
	local t2 = Run(f2, ...);
	Printf("t1: %d, t2: %d", t1, t2);
end


function RunAll()
	
end