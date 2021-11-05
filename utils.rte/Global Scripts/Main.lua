local InputHandler = require("Modules/InputHandler");


function Main:StartScript()
	print("Utils.rte's Main.lua Global Script is active!");
end


function Main:UpdateScript()
	-- print("Start of Utils.rte's Main.lua update");

	InputHandler.Update();
end