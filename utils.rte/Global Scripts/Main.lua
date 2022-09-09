-- REQUIREMENTS ----------------------------------------------------------------


local inputHandler = dofile("utils.rte/Modules/InputHandler.lua");


-- GLOBAL SCRIPT START ---------------------------------------------------------


function Main:StartScript()
	print("Main:StartScript() of utils.rte");
end


-- GLOBAL SCRIPT UPDATE --------------------------------------------------------


function Main:UpdateScript()
	print("Main:UpdateScript() of utils.rte");

	-- inputHandler.Update();
	-- AnyInput() -- Only triggers when a key is initially pressed.
	-- if UInputMan:KeyHeld() then
	-- 	print(math.random());
	-- end
end


-- METHODS ---------------------------------------------------------------------
