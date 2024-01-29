-- REQUIREMENTS ----------------------------------------------------------------

local utils = dofile("utils.rte/Modules/Utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.FileExists(filepath)
	local fd = LuaMan:FileOpen(filepath, "r")
	LuaMan:FileClose(fd)
	return fd ~= -1
end

-- Returns the contents of a file as a string
function M.ReadFile(filepath)
	if not M.FileExists(filepath) then
		return false
	end

	local fd = LuaMan:FileOpen(filepath, "r")
	local strTab = {} -- Storing the strings in a table and concatenating them at the end is faster than concatenating for every newly added line
	local i = 1 -- Manually tracking the index is faster than calling table.insert()

	while not LuaMan:FileEOF(fd) do
		strTab[i] = LuaMan:FileReadLine(fd)
		i = i + 1
	end

	LuaMan:FileClose(fd)

	return table.concat(strTab)
end

-- Beware, this overwrites whatever was already in the file!
function M.WriteFile(filepath, str)
	local fd = LuaMan:FileOpen(filepath, "w")
	LuaMan:FileWriteLine(fd, str) -- If you want to write across multiple lines, use the newline character \n in str
	LuaMan:FileClose(fd)
end

-- Beware, this overwrites whatever was already in the file!
function M.WriteTableToFile(filepath, tab)
	local tabStr = utils.SerializeTable(tab)
	M.WriteFile(filepath, "return " .. tabStr .. "\n")
end

-- Source: http://lua-users.org/wiki/DirTreeIterator
function M.Walk(dir)
	assert(dir and dir ~= "", "directory parameter is missing or empty")

	-- Remove any trailing slash,
	-- so that when we do `.. "/"` later, we don't end up with two slashes
	if dir:sub(-1) == "/" then
		dir = dir:sub(1, -2)
	end

	local function closure(dir)
		for entry in LuaMan:GetDirectoryList(dir) do
			if entry ~= "." and entry ~= ".." then
				entry = dir .. "/" .. entry
				coroutine.yield(entry .. "/", "directory")
				closure(entry)
			end
		end
		for entry in LuaMan:GetFileList(dir) do
			entry = dir .. "/" .. entry
			coroutine.yield(entry, "file")
		end
	end

	return coroutine.wrap(function()
		closure(dir)
	end)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

-- MODULE END ------------------------------------------------------------------

return M
