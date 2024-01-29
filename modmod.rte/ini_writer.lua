local file_functions = dofile("utils.rte/Modules/file_functions.lua")

local M = {}

function M.write(ast, path)
	local fd = LuaMan:FileOpen(path, "w")
	assert(fd ~= -1)

	-- TODO: Write while recursively descending the AST
	LuaMan:FileWriteLine(fd, "foo\n")

	LuaMan:FileClose(fd)
end

return M
