-- REQUIREMENTS ----------------------------------------------------------------

local utils = dofile("utils.rte/Modules/Utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.FileExists(filepath)
	local fileID = LuaMan:FileOpen(filepath, "r")
	LuaMan:FileClose(fileID)
	return fileID ~= -1
end

-- Returns the contents of a file as a string
function M.ReadFile(filepath)
	if not M.FileExists(filepath) then
		return false
	end

	local fileID = LuaMan:FileOpen(filepath, "r")
	local strTab = {} -- Storing the strings in a table and concatenating them at the end is faster than concatenating for every newly added line
	local i = 1 -- Manually tracking the index is faster than calling table.insert()

	while not LuaMan:FileEOF(fileID) do
		strTab[i] = LuaMan:FileReadLine(fileID)
		i = i + 1
	end

	LuaMan:FileClose(fileID)

	return table.concat(strTab)
end

-- Beware, this overwrites whatever was already in the file!
function M.WriteFile(filepath, str)
	local fileID = LuaMan:FileOpen(filepath, "w")
	LuaMan:FileWriteLine(fileID, str) -- If you want to write across multiple lines, use the newline character \n in str
	LuaMan:FileClose(fileID)
end

-- Beware, this overwrites whatever was already in the file!
function M.WriteTableToFile(filepath, tab)
	local tabStr = utils.SerializeTable(tab)
	M.WriteFile(filepath, "return " .. tabStr .. "\n")
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
