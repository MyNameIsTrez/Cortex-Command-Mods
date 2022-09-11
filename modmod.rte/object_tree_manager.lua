-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")
local cst_generator = dofile("modmod.rte/ini/cst_generator.lua")
local ast_generator = dofile("modmod.rte/ini/ast_generator.lua")
local object_tree_generator = dofile("modmod.rte/ini/object_tree_generator.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M:init()
	local tokens = tokens_generator.get_tokens("Browncoats.rte/Actors/Infantry/BrowncoatHeavy/BrowncoatHeavy.ini")
	local cst = cst_generator.get_cst(tokens)
	local ast = ast_generator.get_ast(cst)

	self.object_tree = object_tree_generator.get_object_tree(ast)

	return self
end


function M:update()
	self.object_tree[1].collapsed = false

	local object_tree_strings = get_object_tree_strings(self.object_tree)

	-- utils.RecursivelyPrint(object_tree_strings)
	draw_object_tree_strings(object_tree_strings, {-1})
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_object_tree_strings(object_tree, depth)
	depth = depth or 0

	local object_tree_strings = {}

	object_tree_strings.depth = depth

	for _, v in ipairs(object_tree) do
		local str = ""

		if v.children ~= nil then
			if v.collapsed then
				str = str .. "v"
			else
				str = str .. ">"
			end
		end

		str = str .. " "

		if v.preset_name ~= nil then
			str = string.format("%s%s (%s)", str, v.preset_name, v.value)
		else
			str = str .. v.value
		end

		table.insert(object_tree_strings, str)

		if v.children ~= nil and not v.collapsed then
			table.insert(object_tree_strings, get_object_tree_strings(v.children, depth + 1))
		end
	end

	return object_tree_strings
end

function draw_object_tree_strings(object_tree_strings, height)
	local x = object_tree_strings.depth * 20

	for i, v in ipairs(object_tree_strings) do
		if type(v) == "table" then
			draw_object_tree_strings(v, height)
		else
			height[1] = height[1] + 1
			local y = height[1] * 13
			PrimitiveMan:DrawTextPrimitive(Vector(x, y), v, false, 0);
		end
	end
end


-- MODULE END ------------------------------------------------------------------


return M;
