-- REQUIREMENTS ----------------------------------------------------------------

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

--Converts a table to its string representation. Use loadstring() to convert it back to a table later
--StackOverflow origin: https://stackoverflow.com/a/6081639/13279557
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
		serializedTableString = serializedTableString .. '"[inserializeable datatype:' .. type(value) .. ']"'
	end

	return serializedTableString
end

function M.FileExists(filepath)
	local fileID = LuaMan:FileOpen(filepath, "r")
	LuaMan:FileClose(fileID)
	return fileID ~= -1
end

--Returns the contents of a file as a string
function M.ReadFile(filepath)
	if not M.FileExists(filepath) then
		return false
	end

	local fileID = LuaMan:FileOpen(filepath, "r")
	local strTab = {} --Storing the strings in a table and concatenating them at the end is faster than concatenating for every newly added line
	local i = 1 --Manually tracking the index is faster than calling table.insert()

	while not LuaMan:FileEOF(fileID) do
		strTab[i] = LuaMan:FileReadLine(fileID)
		i = i + 1
	end

	LuaMan:FileClose(fileID)

	return table.concat(strTab)
end

--Beware, this overwrites whatever was already in the file!
function M.WriteFile(filepath, str)
	local fileID = LuaMan:FileOpen(filepath, "w")
	LuaMan:FileWriteLine(fileID, str) --If you want to write across multiple lines, use the newline character \n in str
	LuaMan:FileClose(fileID)
end

--Beware, this overwrites whatever was already in the file!
function M.WriteTableToFile(filepath, tab)
	local tabStr = M.SerializeTable(tab)
	M.WriteFile(filepath, "return " .. tabStr .. "\n")
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
