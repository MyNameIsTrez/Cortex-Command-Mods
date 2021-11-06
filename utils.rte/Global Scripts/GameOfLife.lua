-- REQUIREMENTS ----------------------------------------------------------------


local utils = require("Modules.Utils");


-- GLOBAL SCRIPT START ---------------------------------------------------------


function GameOfLife:StartScript()
	-- CONFIGURABLE VARIABLES
	self.framesBetweenUpdates = 10;

	self.topLeftX = 1800; -- TODO: Set this equal to the variable of the top-left of the player's screen every frame instead!
	self.topLeftY = 500; -- TODO: Set this equal to the variable of the top-left of the player's screen every frame instead!

	self.columns = 30;
	self.rows = 30;

	self.cellSize = 15;

	self.deadColor = 4;
	self.aliveColor = 20;


	-- INTERNAL VARIABLES
	self.frame = 0;
	self.state = GameOfLife:GetEmptyState();
	self.nextState = nil;
	

	-- SETUP
	GameOfLife:KillAllCells();


	-- CONFIGURABLE STARTING STATES

	-- R-pentomino for 30x30
	self.state[14][15] = true;
	self.state[14][16] = true;
	self.state[15][14] = true;
	self.state[15][15] = true;
	self.state[16][15] = true;

	-- R-pentomino for 5x5
	-- self.state[2][3] = true;
	-- self.state[2][4] = true;
	-- self.state[3][2] = true;
	-- self.state[3][3] = true;
	-- self.state[4][3] = true;
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function GameOfLife:UpdateScript()	
	-- for i = 1, 1000 do
	-- 	local xOffset = (math.random(self.columns) - 1) * self.cellSize;
	-- 	local yOffset = (math.random(self.rows) - 1) * self.cellSize;

	-- 	local topLeft = Vector(self.topLeftX + xOffset, self.topLeftY + yOffset);
	-- 	local bottomRight = topLeft + Vector(self.cellSize, self.cellSize);

	-- 	PrimitiveMan:DrawBoxFillPrimitive(topLeft, bottomRight, math.random(255));
	-- end

	self.frame = self.frame + 1;

	-- + 1 so a self.framesBetweenUpdates of 0 works.
	if self.frame % (self.framesBetweenUpdates + 1) == 0 then
		GameOfLife:Update();
	end

	GameOfLife:Draw();
end


-- METHODS ---------------------------------------------------------------------


function GameOfLife:GetEmptyState()
	local state = {};

	for row = 1, self.rows do
		state[row] = {};
	end

	return state;
end


function GameOfLife:KillAllCells()
	for row = 1, self.rows do
		for column = 1, self.columns do
			self.state[row][column] = false;
		end
	end
end


function GameOfLife:Update()
	local neighbors;

	self.nextState = GameOfLife:GetEmptyState();

	for row = 1, self.rows do
		for column = 1, self.columns do
			neighbors = GameOfLife:CountCellNeighbors(row, column);

			GameOfLife:UpdateCellState(row, column, neighbors);
		end
	end

	self.state = self.nextState;
end


function GameOfLife:CountCellNeighbors(row, column)
	local neighbors = 0;

	if row > 1 then
		if column > 1 and            self.state[row-1][column-1] then neighbors = neighbors + 1; end
		if                           self.state[row-1][column-0] then neighbors = neighbors + 1; end
		if column < self.columns and self.state[row-1][column+1] then neighbors = neighbors + 1; end
	end

    if column > 1 and                self.state[row-0][column-1] then neighbors = neighbors + 1; end
	if column < self.columns and     self.state[row-0][column+1] then neighbors = neighbors + 1; end

	if row < self.rows then
		if column > 1 and            self.state[row+1][column-1] then neighbors = neighbors + 1; end
		if                           self.state[row+1][column-0] then neighbors = neighbors + 1; end
		if column < self.columns and self.state[row+1][column+1] then neighbors = neighbors + 1; end
	end

	return neighbors;
end


function GameOfLife:UpdateCellState(row, column, neighbors)
	if neighbors < 2 or neighbors > 3 then
		self.nextState[row][column] = false;
	elseif neighbors == 2 then
		self.nextState[row][column] = self.state[row][column];
	elseif neighbors == 3 then
		self.nextState[row][column] = true;
	end
end


function GameOfLife:Draw()
	for row = 1, self.rows do
		for column = 1, self.columns do
			GameOfLife:DrawCell(row, column);
		end
	end
end


function GameOfLife:DrawCell(row, column)
	local xOffset = (column - 1) * self.cellSize;
	local yOffset = (row - 1) * self.cellSize;

	local topLeft = Vector(self.topLeftX + xOffset, self.topLeftY + yOffset);
	local bottomRight = topLeft + Vector(self.cellSize, self.cellSize);

	local color = self.state[row][column] and self.aliveColor or self.deadColor;

	PrimitiveMan:DrawBoxFillPrimitive(topLeft, bottomRight, color);
end