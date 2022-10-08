-- REQUIREMENTS ----------------------------------------------------------------

local l = dofile("utils.rte/Modules/lulpeg.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- CONFIGURABLE VARIABLES ------------------------------------------------------

-- INTERNAL VARIABLES ----------------------------------------------------------

-- PUBLIC FUNCTIONS ------------------------------------------------------------

---Prints all MOs.
function M.PrintMOs()
	for mo in M.MOIterator() do
		print(mo)
	end
end

---Use like "for mo in utils.MOIterator() do".
---This is a replacement of this code which is found in almost every mod:
---"for i = 1, MovableMan:GetMOIDCount() - 1 do local mo = MovableMan:GetMOFromID(i); <code that uses mo> end"
---@return function
function M.MOIterator()
	local mos = {}
	for i = 1, MovableMan:GetMOIDCount() - 1 do
		local mo = MovableMan:GetMOFromID(i)
		mos[i] = mo
	end

	-- Returns an anonymous function, see https://stackoverflow.com/a/46008125/13279557
	local j = 0
	return function()
		j = j + 1
		return mos[j]
	end
end

---Prints the content of a table recursively so it can easily be inspected in a console.
---@param tab table
---@param recursive boolean
---@param depth number
function M.RecursivelyPrint(tab, recursive, depth)
	local recursive = not (recursive == false) -- True by default.
	local depth = depth or 0 -- The depth starts at 0.

	-- Getting the longest key of this (sub)table, so all printed values will line up.
	local longestKey = 1
	for key, _ in pairs(tab) do
		local keyLength = #tostring(key)
		if keyLength > longestKey then
			longestKey = keyLength
		end
	end

	if depth == 0 then
		print("")
	end

	-- Print the keys and values, with extra spaces so the values line up.
	for key, value in pairs(tab) do
		local spacingCount = longestKey - #tostring(key) -- How many spaces are added between the key and value.

		print(
			string.rep(string.rep(" ", 4), depth) -- Tabulate tables that are deep inside the original table.
				.. string.rep(" ", spacingCount)
				.. tostring(key)
				.. " | "
				.. GetValueString(value)
		)

		local isTable = type(value) == "table"
		local valueIsTable = (value == tab)
		if recursive and isTable and not valueIsTable then
			M.RecursivelyPrint(value, recursive, depth + 1) -- Go into the table.
		end
	end

	if depth == 0 then
		print("")
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
	local slope = (outputEnd - outputStart) / (inputEnd - inputStart)
	return outputStart + slope * (input - inputStart)
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
	return outputStart + slope * (input - inputStart)
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
	return (outputEnd - outputStart) / (inputEnd - inputStart)
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
	local left, num, right = string.match(n, "^([^%d]*%d)(%d*)(.-)$")
	return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

---Makes a shallow copy of a table, which means that tables inside of it won't be copied but referenced.
---See http://lua-users.org/wiki/CopyTable for more information on shallow vs deep copies.
---@param t table
---@return table
function M.ShallowlyCopy(t)
	local t2 = {}
	for k, v in pairs(t) do
		t2[k] = v
	end
	return t2
end

---Counts the number of keys in a table.
---This isn't the same as using the # operator, since that doesn't count the keys, only the indices.
---@param t table
---@return number count
function M.get_key_count(t)
	local count = 0
	for _, _ in pairs(t) do
		count = count + 1
	end
	return count
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

function M.lstrip(str)
	return str:match("%s*(.*)")
end

function M.rstrip(str)
	return str:match("(.-)%s*$")
end

-- Source: https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3
function M.deepequals(t1, t2, ignore_mt)
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then
		return false
	end
	-- non-table types can be directly compared
	if ty1 ~= "table" and ty2 ~= "table" then
		return t1 == t2
	end
	-- as well as tables which have the metamethod __eq
	local mt = getmetatable(t1)
	if not ignore_mt and mt and mt.__eq then
		return t1 == t2
	end
	for k1, v1 in pairs(t1) do
		local v2 = t2[k1]
		if v2 == nil or not M.deepequals(v1, v2) then
			return false
		end
	end
	for k2, v2 in pairs(t2) do
		local v1 = t1[k2]
		if v1 == nil or not M.deepequals(v1, v2) then
			return false
		end
	end
	return true
end

-- Source: https://staff.fnwi.uva.nl/h.vandermeer/docs/lua/lualpeg/lpeg.html
-- function M.split(s, sep)
--   sep = lpeg.P(sep)
--   local elem = lpeg.C((1 - sep)^0)
--   local p = lpeg.Ct(elem * (sep * elem)^0)
--   return lpeg.match(p, s)
-- end

function M.get_first_human_player_id()
	local activity = ActivityMan:GetActivity()
	for player_id = 0, activity.PlayerCount do
		if activity:PlayerActive(player_id) and activity:PlayerHuman(player_id) then
			return player_id
		end
	end
end

-- function M.round(n)
-- 	return math.floor(n + 0.5)
-- end

-- Source: https://stackoverflow.com/a/8695525/13279557
function M.reduce(tab, fn, init)
	local acc = init

	for i, v in ipairs(tab) do
		if i == 1 and not init then
			acc = v
		else
			acc = fn(acc, v)
		end
	end

	return acc
end

function M.sum(tab)
	return M.reduce(tab, function(a, b)
		return a + b
	end)
end

-- Source: https://stackoverflow.com/a/5180611/13279557
function M.max_fn(tab, fn)
	if #tab == 0 then
		return nil, nil
	end

	local key = 1
	local value = tab[1]

	for i = 2, #tab do
		if fn(value, tab[i]) then
			key = i
			value = tab[i]
		end
	end

	return key, value
end

function M.get_wrapped_index(i, max)
	return (i - 1) % max + 1
end

function M.possibly_truncate(str, max_width, is_small, truncation_ending)
	if FrameMan:CalculateTextWidth(str, is_small) <= max_width then
		return str
	end

	if truncation_ending then
		local rstripped_whitespace = str:match(".-(%s*)$")
		max_width = max_width
			+ FrameMan:CalculateTextWidth(rstripped_whitespace, is_small)
			- FrameMan:CalculateTextWidth(truncation_ending, is_small)
	end

	local index = math.ceil(#str / 2)
	local step = math.ceil(index / 2)

	while step > 0 do
		if FrameMan:CalculateTextWidth(str:sub(1, index), is_small) < max_width then
			index = index + step
		elseif FrameMan:CalculateTextWidth(str:sub(1, index), is_small) > max_width then
			index = index - step
		end

		step = math.floor(step / 2)
	end

	if truncation_ending then
		return M.rstrip(str:sub(1, index)) .. truncation_ending
	else
		return str:sub(1, index)
	end
end

function M.path_join(path_1, path_2)
	return path_1 .. "/" .. path_2
end

function M.path_extension(path)
	return path:match(".*(%..*)")
end

function M.flush_log()
	ConsoleMan:SaveAllText("LogConsole.txt")
end

function M.print(str, recursive)
	if type(str) == "table" then
		M.RecursivelyPrint(str, recursive)
	else
		print(str)
	end
	M.flush_log()
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

---Used by M.RecursivelyPrint() to turn any type of value into a string.
---@param value any
---@return string
function GetValueString(value)
	if pcall(tostring, value) then
		return tostring(value)
	else
		return type(value)
	end
end

-- MODULE END ------------------------------------------------------------------

return M
