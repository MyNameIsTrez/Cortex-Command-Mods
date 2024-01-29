function Filesystem:StartScript()
	print("Filesystem:StartScript()")

	-- TODO: Change `SupportedGameVersion = 6.0.0` to 5.1.0 before adding this to the PR!

	local dir = "Mods/filesystem.rte/sandbox"

	-- Deliberately uppercasing "filesystem.rte" to show case-insensitivity
	local DIR = "Mods/FILESYSTEM.rte/sandbox"

	-- Recreate sandbox/
	LuaMan:DirectoryRemove(dir, true)
	assert(LuaMan:DirectoryCreate(dir))

	-- Open and remove files, and test they exist ------------------------------
	assert(not LuaMan:FileExists(dir .. "/foo.txt"))

	assert(not LuaMan:FileExists(dir))

	assert(LuaMan:FileOpen(dir .. "/nonexistent.txt", "r") == -1)

	local fd = LuaMan:FileOpen(dir .. "/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	-- Can overwrite already existing file
	local fd = LuaMan:FileOpen(dir .. "/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	assert(LuaMan:FileExists(dir .. "/foo.txt"))

	local fd = LuaMan:FileOpen(dir .. "/foo.txt", "r")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	assert(LuaMan:FileRemove(dir .. "/foo.txt"))
	assert(not LuaMan:FileRemove(dir .. "/foo.txt"))

	assert(not LuaMan:FileExists(dir .. "/foo.txt"))
	----------------------------------------------------------------------------

	-- Create and remove directory, and test they exist ------------------------
	assert(not LuaMan:DirectoryExists(dir .. "/foo"))

	assert(LuaMan:DirectoryExists(dir))

	assert(LuaMan:DirectoryCreate(dir .. "/foo"))

	-- Can't create already existing directory
	assert(not LuaMan:DirectoryCreate(dir .. "/foo"))

	local fd = LuaMan:FileOpen(dir .. "/foo/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	assert(not LuaMan:DirectoryExists(dir .. "/foo/foo.txt"))

	-- Can't remove a directory that has a file in it
	assert(not LuaMan:DirectoryRemove(dir .. "/foo"))

	assert(LuaMan:FileRemove(dir .. "/foo/foo.txt"))

	assert(LuaMan:DirectoryRemove(dir .. "/foo"))
	assert(not LuaMan:DirectoryExists(dir .. "/foo"))
	----------------------------------------------------------------------------

	-- List files and directories ----------------------------------------------
	assert(LuaMan:DirectoryCreate(dir .. "/foo"))

	local fd = LuaMan:FileOpen(dir .. "/foo/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	for entry_dir_name in LuaMan:GetDirectoryList(dir .. "/nonexistent") do
		assert(false)
	end
	for entry_file_name in LuaMan:GetFileList(dir .. "/nonexistent") do
		assert(false)
	end

	local entered = false
	for entry_dir_name in LuaMan:GetDirectoryList(dir) do
		assert(entry_dir_name == "foo")
		entered = true
	end
	assert(entered)

	local entered = false
	for entry_file_name in LuaMan:GetFileList(dir .. "/foo") do
		assert(entry_file_name == "foo.txt")
		entered = true
	end
	assert(entered)

	assert(LuaMan:DirectoryRemove(dir .. "/foo", true))
	----------------------------------------------------------------------------

	-- Recursively create and remove directories -------------------------------

	-- Can't create directory recursively without a second `true` argument
	assert(not LuaMan:DirectoryCreate(dir .. "/foo/bar"))

	assert(LuaMan:DirectoryCreate(dir .. "/foo/bar", true))

	-- Can't create already existing directory
	assert(not LuaMan:DirectoryCreate(dir .. "/foo/bar"))

	local fd = LuaMan:FileOpen(dir .. "/foo/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	local fd = LuaMan:FileOpen(dir .. "/foo/bar/bar.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	-- Can't remove directory recursively without a second `true` argument
	assert(not LuaMan:DirectoryRemove(dir .. "/foo"))

	assert(LuaMan:DirectoryRemove(dir .. "/foo", true))
	assert(not LuaMan:DirectoryExists(dir .. "/foo"))
	----------------------------------------------------------------------------

	-- Rename files ------------------------------------------------------------
	local fd = LuaMan:FileOpen(dir .. "/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	-- Can't rename to an existing path, even if it's identical to oldPath
	-- Ensures parity between Linux which can overwrite an empty directory, while Windows can't
	-- Ensures parity between Linux which can't rename a directory to a newPath that is a file in order to overwrite it, while Windows can
	assert(not LuaMan:FileRename(dir .. "/foo.txt", dir .. "/foo.txt"))

	-- newPath isn't implied to have the same filename as oldPath
	assert(not LuaMan:FileRename(dir .. "/foo.txt", dir))

	assert(LuaMan:FileRemove(dir .. "/foo.txt"))
	----------------------------------------------------------------------------

	-- Rename directories ------------------------------------------------------
	assert(LuaMan:DirectoryCreate(dir .. "/foo"))

	-- Can't rename to an existing path, even if it's identical to oldPath
	-- Ensures parity between Linux which can overwrite an empty directory, while Windows can't
	-- Ensures parity between Linux which can't rename a directory to a newPath that is a file in order to overwrite it, while Windows can
	assert(not LuaMan:DirectoryRename(dir .. "/foo", dir .. "/foo"))

	-- newPath isn't implied to have the same directory name as oldPath
	assert(not LuaMan:DirectoryRename(dir .. "/foo", dir))

	assert(LuaMan:DirectoryRemove(dir .. "/foo"))
	----------------------------------------------------------------------------

	-- Every function is case-insensitive, even on Linux -----------------------
	assert(LuaMan:DirectoryCreate(DIR .. "/foo"))

	assert(LuaMan:DirectoryExists(DIR .. "/foo"))

	assert(LuaMan:DirectoryRemove(DIR .. "/foo"))

	local fd = LuaMan:FileOpen(DIR .. "/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	assert(LuaMan:FileExists(DIR .. "/foo.txt"))

	assert(LuaMan:FileRename(DIR .. "/foo.txt", DIR .. "/bar.txt"))

	assert(LuaMan:FileRemove(DIR .. "/bar.txt"))

	assert(LuaMan:DirectoryCreate(DIR .. "/foo"))

	local fd = LuaMan:FileOpen(DIR .. "/foo/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	local entered = false
	for entry_dir_name in LuaMan:GetDirectoryList(DIR) do
		assert(entry_dir_name == "foo")
		entered = true
	end
	assert(entered)

	local entered = false
	for entry_file_name in LuaMan:GetFileList(DIR .. "/foo") do
		assert(entry_file_name == "foo.txt")
		entered = true
	end
	assert(entered)

	assert(LuaMan:DirectoryRemove(DIR .. "/foo", true))
	----------------------------------------------------------------------------

	-- Overwrite with different casing -----------------------------------------
	assert(LuaMan:DirectoryCreate(dir .. "/foo"))
	assert(not LuaMan:DirectoryCreate(dir .. "/foo"))
	-- Because this isn't allowed on Windows, we don't allow it on Linux
	assert(not LuaMan:DirectoryCreate(dir .. "/Foo"))

	local fd = LuaMan:FileOpen(dir .. "/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)

	-- Replace foo.txt with Foo.txt
	local fd = LuaMan:FileOpen(dir .. "/Foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)
	assert(LuaMan:FileExists(DIR .. "/Foo.txt"))
	assert(LuaMan:FileExists(DIR .. "/foo.txt"))
	assert(LuaMan:FileRemove(DIR .. "/Foo.txt"))
	assert(LuaMan:DirectoryRemove(DIR .. "/foo"))
	----------------------------------------------------------------------------

	-- Can't escape out of the Mods/ directory ---------------------------------
	assert(not LuaMan:DirectoryCreate(dir .. "../foo"))
	assert(not LuaMan:DirectoryExists(dir .. "../foo"))
	assert(LuaMan:FileOpen(dir .. "../Mods/foo.txt", "w") == -1)
	assert(LuaMan:GetFileList(dir .. "../Mods")() == nil)
	assert(LuaMan:GetDirectoryList(dir .. "../Mods")() == nil)

	-- Test DirectoryRemove() and DirectoryRename()
	assert(LuaMan:DirectoryCreate(dir .. "/foo"))
	assert(not LuaMan:DirectoryRemove(dir .. "../Mods/foo"))
	assert(not LuaMan:DirectoryRename(dir .. "../Mods/foo", dir .. "/bar"))
	assert(LuaMan:DirectoryRemove(dir .. "/foo"))

	-- Test FileExists(), FileRemove() and FileRename()
	local fd = LuaMan:FileOpen(dir .. "/foo.txt", "w")
	assert(fd ~= -1)
	LuaMan:FileClose(fd)
	assert(not LuaMan:FileExists(dir .. "../Mods/foo.txt"))
	assert(not LuaMan:FileRemove(dir .. "../Mods/foo.txt"))
	assert(not LuaMan:FileRename(dir .. "../Mods/foo.txt", dir .. "/bar.txt"))
	assert(not LuaMan:FileRename(dir .. "/bar.txt", dir .. "../Mods/foo.txt"))
	assert(LuaMan:FileRemove(dir .. "/foo.txt"))
	----------------------------------------------------------------------------

	assert(LuaMan:DirectoryRemove(dir, true))

	print("End of Filesystem:StartScript()")
end
