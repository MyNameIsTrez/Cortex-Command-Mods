require("Scripts/Keys")


function PrintMOs()
	for mo in MOIterator() do
		print(mo);
	end
end


function MOIterator()
	local mos = {};
	for i = 1, MovableMan:GetMOIDCount() - 1 do
		local mo = MovableMan:GetMOFromID(i);
		mos[i] = mo;
	end

	local j = 0;
	return function() -- Returns an anonymous function, see https://stackoverflow.com/a/46008125/13279557
		j = j + 1;
		return mos[j];
	end;
end


function RecursivelyPrint(tab, recursive, depth)
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
			_GetValueString(value)
		);
		
		local isTable = type(value) == "table";
		local valueIsTable = (value == tab);
		if recursive and isTable and not valueIsTable then
			RecursivelyPrint(value, recursive, depth + 1); -- Go into the table.
		end
	end
	
	if depth == 0 then
		print("");
	end
end


function _GetValueString(value)
	if type(value) == "userdata" then
		return "userdata";
	else
		return tostring(value);
	end
end