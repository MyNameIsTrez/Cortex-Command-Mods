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

-- function M.max(tab, fn)
-- 	local key
-- 	local value

-- 	for k, v in pairs(tab) do
-- 		if key == nil or fn(key, value, k, v) then
-- 			key = k
-- 			value = v
-- 		end
-- 	end

-- 	return key, value
-- end

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

function M.print(value, recursive)
	if type(value) == "table" then
		print(M.SerializeTable(value))
	else
		print(value)
	end
	-- TODO: Try commenting this out
	M.flush_log()
end

-- Converts a table to its string representation. Use loadstring() to convert it back to a table later
-- StackOverflow origin: https://stackoverflow.com/a/6081639/13279557
function M.SerializeTable(value, separator, skipNewlines, name, depth)
	separator = separator or "\t"
	skipNewlines = skipNewlines or false
	depth = depth or 0

	local serializedTableString = string.rep(separator, depth)

	if name then
		serializedTableString = serializedTableString .. name .. " = "
	end

	if type(value) == "table" then
		local possible_newline = skipNewlines and "" or "\n"

		serializedTableString = serializedTableString .. "{" .. possible_newline

		for k, v in pairs(value) do
			serializedTableString = serializedTableString
				.. M.SerializeTable(v, separator, skipNewlines, k, depth + 1)
				.. ","
				.. possible_newline
		end

		serializedTableString = serializedTableString .. string.rep(separator, depth) .. "}"
	elseif type(value) == "number" then
		serializedTableString = serializedTableString .. tostring(value)
	elseif type(value) == "string" then
		serializedTableString = serializedTableString .. string.format("%q", value)
	elseif type(value) == "boolean" then
		serializedTableString = serializedTableString .. (value and "true" or "false")
	else
		serializedTableString = serializedTableString .. '"[unserializable type: ' .. type(value) .. ']"'
	end

	return serializedTableString
end

function M.clamp(v, min, max)
	return math.max(min, math.min(max, v))
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
