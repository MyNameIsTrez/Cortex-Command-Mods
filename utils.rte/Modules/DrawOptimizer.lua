-- REQUIREMENTS ----------------------------------------------------------------


local utils = dofile("utils.rte/Modules/Utils.lua");

local Colors = dofile("utils.rte/Data/Colors.lua");


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------


local data = {};
local dataIndex = 1;

local mergedData;


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
	if mergedData == nil then
		return;
	end

	for _, mergedDatum in ipairs(mergedData) do
		local topLeft, bottomRight, color = unpack(mergedDatum);

		PrimitiveMan:DrawBoxFillPrimitive(topLeft, bottomRight, color);
		PrimitiveMan:DrawBoxPrimitive(topLeft, bottomRight, Colors.orange);
	end
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------


-- TODO: This function currently assumes the elements are added in the order of top-left to bottom-right.
function M._Merge()
	mergedData = {};
	local mergedDataIndex = 1;

	local mergedTopLeft;
	local mergedBottomRight;
	local mergedColor;

	local speculativeTopLeft;
	local speculativeBottomRight;

	local topLeft;
	local bottomRight;
	local color;

	for _, datum in ipairs(data) do
		topLeft, bottomRight, color = unpack(datum);

		if mergedColor == nil then
			mergedTopLeft = topLeft;
			mergedBottomRight = bottomRight;
			mergedColor = color;
		elseif color ~= mergedColor then
			mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, mergedColor };
			mergedDataIndex = mergedDataIndex + 1;

			if speculativeTopLeft and speculativeBottomRight then
				mergedData[mergedDataIndex] = { speculativeTopLeft, speculativeBottomRight, mergedColor };
				mergedDataIndex = mergedDataIndex + 1;

				speculativeTopLeft = nil;
				speculativeBottomRight = nil;
			end

			mergedTopLeft = topLeft;
			mergedBottomRight = bottomRight;
			mergedColor = color;
		elseif topLeft.X < mergedTopLeft.X then
			mergedData[mergedDataIndex] = { mergedTopLeft, mergedBottomRight, color };
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
		mergedDataIndex = mergedDataIndex + 1;
	end
end

function M._Empty()
	data = {};
	dataIndex = 1;
end

-- MODULE END ------------------------------------------------------------------


return M;
