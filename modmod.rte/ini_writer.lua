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
		append(output, "\t")
	end

	if node.property then
		append(output, node.property)
	end

	if node.value then
		append(output, " = ")
		append(output, node.value)
	end

	if #node.comments > 0 then
		if node.property ~= nil then
			append(output, " ")
		end

		append(output, "//")

		for _, comment in ipairs(node.comments) do
			append(output, " ")
			append(output, comment)
		end
	end

	append(output, "\n")

	for _, child in ipairs(node.children) do
		write_recursively(child, output, depth + 1)
	end
end

function append(output, str)
	output[#output + 1] = str
end

return M
