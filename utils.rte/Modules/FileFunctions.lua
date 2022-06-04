-- REQUIREMENTS ----------------------------------------------------------------




-- MODULE START ----------------------------------------------------------------


local M = {};
M = M;


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


--Converts a table to its string representation. Use loadstring() to convert it back to a table later
--StackOverflow origin: https://stackoverflow.com/a/6081639/13279557
function M.SerializeTable(value, name, skipNewlines, depth)
	skipNewlines = skipNewlines or false;
	depth = depth or 0;

	local serializedTableString = string.rep(" ", depth);

	if name then serializedTableString = serializedTableString .. name .. " = "; end

	if type(value) == "table" then
		serializedTableString = serializedTableString .. "{" .. (not skipNewlines and "\n" or "");

		for k, v in pairs(value) do
			serializedTableString = serializedTableString .. SerializeTable(v, k, skipNewlines, depth + 1) .. "," .. (not skipNewlines and "\n" or "");
		end

		serializedTableString = serializedTableString .. string.rep(" ", depth) .. "}";
	elseif type(value) == "number" then
		serializedTableString = serializedTableString .. tostring(value);
	elseif type(value) == "string" then
		serializedTableString = serializedTableString .. string.format("%q", value);
	elseif type(value) == "boolean" then
		serializedTableString = serializedTableString .. (value and "true" or "false");
	else
		serializedTableString = serializedTableString .. "\"[inserializeable datatype:" .. type(value) .. "]\"";
	end

	return serializedTableString;
end

function M.FileExists(filepath)
	local fileID = LuaMan:FileOpen(filepath, "r");
	LuaMan:FileClose(fileID);
	return fileID ~= -1;
end

--Returns the contents of a file as a string
function M.ReadFile(filepath)
	if not FileExists(filepath) then return false; end

	local fileID = LuaMan:FileOpen(filepath, "r");
	local strTab = {};  --Storing the strings in a table and concatenating them at the end is faster than concatenating for every newly added line
	local i = 1;  --Manually tracking the index is faster than calling table.insert()

	while not LuaMan:FileEOF(fileID) do
		strTab[i] = LuaMan:FileReadLine(fileID);
		i = i + 1;
	end

	LuaMan:FileClose(fileID);

	return table.concat(strTab);
end

--Reads the contents of a file like it's a table and returns it
function M.ReadFileAsTable(filepath)
	local fileStr = ReadFile(filepath);
	if fileStr == false then return false; end --If the file doesn't exist

	local func = loadstring("return " .. fileStr);  --loadstring converts a string to a function, that's why there's a "return "
	if func == nil then return false; end --In case the file didn't contain a properly constructed table

	return func(); --Execute the function to return the fileStr table
end

--Beware, this overwrites whatever was already in the file!
function M.WriteToFile(filepath, str)
	local fileID = LuaMan:FileOpen(filepath, "w");
	LuaMan:FileWriteLine(fileID, str); --If you want to write across multiple lines, use the newline character \n in str
	LuaMan:FileClose(fileID);
end

--Beware, this overwrites whatever was already in the file!
function M.WriteTableToFile(filepath, tab)
	local tabStr = SerializeTable(tab)
	WriteToFile(filepath, tabStr)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------





-- MODULE END ------------------------------------------------------------------


return M;
