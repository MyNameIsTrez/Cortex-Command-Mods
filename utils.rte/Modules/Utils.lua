-- REQUIREMENTS ----------------------------------------------------------------





-- MODULE START ----------------------------------------------------------------


local M = {};
_G[...] = M;


-- CONFIGURABLE VARIABLES ------------------------------------------------------





-- INTERNAL VARIABLES ----------------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


---Prints all MOs.
function M.PrintMOs()
	for mo in M.MOIterator() do
		print(mo);
	end
end


---Use like "for mo in utils.MOIterator() do".
---This is a replacement of this code which is found in almost every mod:
---"for i = 1, MovableMan:GetMOIDCount() - 1 do local mo = MovableMan:GetMOFromID(i); <code that uses mo> end"
---@return function
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


---Prints the content of a table recursively so it can easily be inspected in a console.
---@param tab table
---@param recursive boolean
---@param depth number
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


---Prints a formatted string.
---@param s string
---@param ... any
function M.Printf(s, ...)
	print(string.format(s, ...))
end


---Returns n as a string with thousands separators.
---@param n number
---@return string
-- Credit: http://richard.warburton.it | http://lua-users.org/wiki/FormattingNumbers
function M.AddThousandsSeparator(n)
	local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end


---Makes a shallow copy of a table, which means that tables inside of it won't be copied but referenced.
---See http://lua-users.org/wiki/CopyTable for more information on shallow vs deep copies.
---@param t table
---@return table
function M.ShallowlyCopy(t)
	local t2 = {};
	for k, v in pairs(t) do
		t2[k] = v;
	end
	return t2;
end


-- function M.GetEmptyTableNDim(dimensionsTable, _depth)
-- 	local _depth = _depth or 1;
-- 	if _depth > #dimensionsTable then
-- 		return {};
-- 	end
-- 	local t = {};
-- 	for i, _ in dimensionsTable[_depth] do
-- 		t[i] = M.GetEmptyTableNDim(dimensionsTable, _depth + 1);
-- 	end
-- 	return t;
-- end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


---Used by M.RecursivelyPrint() to turn any type of value into a string.
---@param value any
---@return string
function M._GetValueString(value)
	if pcall(tostring, value) then
		return tostring(value);
	else
		return type(value);
	end
end


-- MODULE END ------------------------------------------------------------------


return M;