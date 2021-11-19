-- REQUIREMENTS ----------------------------------------------------------------


local utils = require("Modules.Utils");

local Colors = require("Data.Colors");


-- MODULE START ----------------------------------------------------------------


local M = {};
M = M;



-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------


local data = {};
local mergedData;
local dataIndex = 1;


-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.Add(topLeft, bottomRight, color)
	data[dataIndex] = { topLeft, bottomRight, color };
	dataIndex = dataIndex + 1;
end


function M.Update()
	M._Merge();
	M._Empty();
end


function M.Draw()
	-- print("foo")
	-- print(#mergedData);
	-- print("bar")
	if mergedData == nil then
		return;
	end

	-- print("mergedData length:");
	-- print(#mergedData);

	for index, mergedDatum in ipairs(mergedData) do
		local topLeft, bottomRight, color = unpack(mergedDatum);
		-- if topLeft == nil or bottomRight == nil or color == nil then
		-- 	print(index);
		-- 	print(":)");
		-- end
		PrimitiveMan:DrawBoxFillPrimitive(topLeft, bottomRight, color);
		PrimitiveMan:DrawBoxPrimitive(topLeft, bottomRight, Colors.orange);
	end
	

	-- local topLeft = Vector(1800, 500);
	-- local cellSize = 15;

	-- for _, datum in ipairs(mergedData) do
	-- 	if datum[1] then
	-- 		datum[1] = (datum[1] - topLeft) / cellSize + Vector(1, 1);
	-- 	end
	-- 	if datum[2] then
	-- 		datum[2] = (datum[2] - topLeft + Vector(1, 1)) / cellSize;
	-- 	end
		
	-- 	-- if datum[0] then
	-- 	-- 	datum[0] = datum[0] - topLeft;
	-- 	-- end
	-- 	-- if datum[1] then
	-- 	-- 	datum[1] = datum[1] - topLeft;
	-- 	-- end
	-- end

	-- utils.RecursivelyPrint(mergedData);
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M._Empty()
	data = {};
	dataIndex = 1;
end


-- TODO: This function currently assumes the elements are added in the order of top-left to bottom-right.
function M._Merge()
	-- utils.RecursivelyPrint(data);

	mergedData = {};
	-- print("Creating mergedData table")
	local mergedDataIndex = 1;

	local mergedTopLeft;
	local mergedBottomRight;
	local mergedColor;

	local speculativeTopLeft;
	local speculativeBottomRight;

	local topLeft;
	local bottomRight;
	local color;
	
	-- print(#data)

	for _, datum in ipairs(data) do
		topLeft, bottomRight, color = unpack(datum);

		if mergedColor == nil then -- TODO: Move this out of the loop.
			mergedTopLeft = topLeft;
			mergedBottomRight = bottomRight;
			mergedColor = color;
		elseif color ~= mergedColor then
			mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, mergedColor };
			-- mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, 1 };
			mergedDataIndex = mergedDataIndex + 1;

			if speculativeTopLeft and speculativeBottomRight then
				mergedData[mergedDataIndex] = { speculativeTopLeft, speculativeBottomRight, mergedColor };
				-- mergedData[mergedDataIndex] = { speculativeTopLeft, speculativeBottomRight, 2 };
				mergedDataIndex = mergedDataIndex + 1;

				speculativeTopLeft = nil;
				speculativeBottomRight = nil;
			end

			mergedTopLeft = topLeft;
			mergedBottomRight = bottomRight;
			mergedColor = color;
		elseif topLeft.X < mergedTopLeft.X then
			mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, color };
			-- mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, 3 };
			mergedDataIndex = mergedDataIndex + 1;

			mergedTopLeft = topLeft;
			mergedBottomRight = bottomRight;
			mergedColor = color;
		elseif bottomRight.X >= mergedBottomRight.X then
			mergedBottomRight = bottomRight;

			speculativeTopLeft = nil;
			speculativeBottomRight = nil;
		elseif speculativeTopLeft == nil and topLeft.Y > mergedBottomRight.Y then
			speculativeTopLeft = topLeft;
			speculativeBottomRight = bottomRight;
		else
			speculativeBottomRight = bottomRight;
		end
	end

	if mergedTopLeft and mergedBottomRight then
		mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, color };
		-- mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, 4 };
		mergedDataIndex = mergedDataIndex + 1;
	end
end


-- function M._IndexToCoordinates(index)
-- 	local x = index % ;
-- 	local y = math.ceil(index / );
-- 	return x, y;
-- end


-- MODULE END ------------------------------------------------------------------


return M;