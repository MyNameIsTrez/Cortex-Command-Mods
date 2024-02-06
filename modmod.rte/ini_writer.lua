local file_functions = dofile("utils.rte/Modules/file_functions.lua")

local M = {}

function M.write(ast, output_path)
	local output = {}

	for index, node in ipairs(ast) do
		write_recursively(node, output, 0)

		-- Don't add a trailing newline,
		-- since write_recursively() already adds it
		if node.property ~= nil and index < #ast - 1 then
			output[#output + 1] = "\n"
		end
	end

	local output_str = table.concat(output)
	file_functions.write_file(output_path, output_str)
end

function write_recursively(node, output, depth)
	-- Don't add an empty line
	if node.property == nil and #node.comments == 0 then
		return
	end

	for i = 1, depth do
		table.insert(output, "\t")
	end

	if node.property then
		table.insert(output, node.property)
	end

	if node.value then
		table.insert(output, " = ")
		table.insert(output, node.value)
	end

	if #node.comments > 0 then
		if node.property ~= nil then
			table.insert(output, " ")
		end

		table.insert(output, "//")

		for _, comment in ipairs(node.comments) do
			table.insert(output, " ")
			table.insert(output, comment)
		end
	end

	table.insert(output, "\n")

	for _, child in ipairs(node.children) do
		write_recursively(child, output, depth + 1)
	end
end

return M
