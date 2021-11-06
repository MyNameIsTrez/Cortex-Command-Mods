-- REQUIREMENTS ----------------------------------------------------------------


-- require("Data/Keys");


-- MODULE START ----------------------------------------------------------------


local M = {};
_G[...] = M;


-- CONFIGURABLE VARIABLES ------------------------------------------------------





-- INTERNAL VARIABLES ----------------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------



function M.PrintMOs()
	for mo in M.MOIterator() do
		print(mo);
	end
end


function M.MOIterator()
	local mos = {};
	for i = 1, MovableMan:GetMOIDCount() - 1 do
		local mo = MovableMan:GetMOFromID(i);
		mos[i] = mo;
	end

	-- Returns an anonymous function, see https://stackoverflow.com/a/46008125/13279557
	local j = 0;
	return function()
		j = j + 1;
		return mos[j];
	end;
end


function M.RecursivelyPrint(tab, recursive, depth)
	local recursive = not (recursive == false); -- True by default.
	local depth = depth or 0; -- The depth starts at 0.
	
	-- Getting the longest key of this (sub)table, so all printed values will line up.
	local longestKey = 1;
	for key, _ in pairs(tab) do
		local keyLength = #tostring(key);
		if keyLength > longestKey then
			longestKey = keyLength;
		end
	end
	
	if depth == 0 then
		print("");
	end
	
	-- Print the keys and values, with extra spaces so the values line up.
	for key, value in pairs(tab) do
		local spacingCount = longestKey - #tostring(key); -- How many spaces are added between the key and value.
		
		print(
			string.rep(string.rep(" ", 4), depth) .. -- Tabulate tables that are deep inside the original table.
			string.rep(" ", spacingCount) ..
			tostring(key) ..
			" | " ..
			M._GetValueString(value)
		);
		
		local isTable = type(value) == "table";
		local valueIsTable = (value == tab);
		if recursive and isTable and not valueIsTable then
			M.RecursivelyPrint(value, recursive, depth + 1); -- Go into the table.
		end
	end
	
	if depth == 0 then
		print("");
	end
end


---Re-maps a number from one range to another.
---
---If you are mapping a lot with the same slope you should use MapUsingSlope() with GetMapSlope() instead to save performance.
---
---Code explanations:
---[Stack Overflow](https://stackoverflow.com/a/5732390/13279557),
---[Arithmetic mindset](https://betterexplained.com/articles/rethinking-arithmetic-a-visual-guide/)
---@param input number
---@param inputStart number
---@param inputEnd number
---@param outputStart number
---@param outputEnd number
---@return number mapped
function M.Map(input, inputStart, inputEnd, outputStart, outputEnd)
	local slope = (outputEnd - outputStart) / (inputEnd - inputStart);
	return outputStart + slope * (input - inputStart);
end


---If you are mapping a lot with the same slope you should use this function to save performance, otherwise use Map().
---
---The slope should be calculated only once using GetMapSlope().
---@param input number
---@param slope number
---@param outputStart number
---@param inputStart number
---@return number mapped
function M.MapUsingSlope(input, slope, outputStart, inputStart)
	return outputStart + slope * (input - inputStart);
end


---Gets the slope for MapUsingSlope().
---
---You're supposed to store the result of this function to save performance, otherwise use Map().
---@param inputStart number
---@param inputEnd number
---@param outputStart number
---@param outputEnd number
---@return number slope
function M.GetMapSlope(inputStart, inputEnd, outputStart, outputEnd)
	return (outputEnd - outputStart) / (inputEnd - inputStart);
end


function M.Printf(s, ...)
	print(string.format(s, ...))
end


-- Credit: http://richard.warburton.it | http://lua-users.org/wiki/FormattingNumbers
function M.AddThousandsSeparator(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M._GetValueString(value)
	if type(value) == "userdata" then
		return "userdata";
	else
		return tostring(value);
	end
end


-- MODULE END ------------------------------------------------------------------


return M;