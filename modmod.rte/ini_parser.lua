local file_functions = dofile("utils.rte/Modules/file_functions.lua")
local utils = dofile("utils.rte/Modules/utils.lua")

local M = {}

function M.parse(path)
	local text = file_functions.read_file(path)

	local tokens = get_tokens(text)
	
	return {
		{
			property = "A",
			value = "B",
			comments = {},
			children = {},
		},
	}
end

function get_tokens(text)
	local tokens = {}

	-- p stands for ptr
	local p = {
		slice = text,
		multiline_comment_depth = 0,
		seen_property = false,
	}

	while #p.slice > 0 do
		local token = get_token(p)
		table.insert(tokens, token)
	end

	if p.multiline_comment_depth > 0 then
		error("Unclosed multiline comment")
	end

	return tokens
end

function get_token(p)
	if p.slice[1] == "\n" then
		p.seen_property = false
		local token = { type = "Newline", slice = p.slice[1] }
		p.slice = p.slice:sub(2)
		return token
	elseif p.multiline_comment_depth > 0 then
		local found_comment_marker = false
		local i = 1
		while i <= #p.slice do
			if p.slice[i] == "\n" then
				break
			elseif p.slice[i] == "/" and p.slice[i + 1] == "*" then
				p.multiline_comment_depth = p.multiline_comment_depth + 1
				i = i + 2
				found_comment_marker = true
				break
			elseif p.slice[i] == "*" and p.slice[i + 1] == "/" then
				p.multiline_comment_depth = p.multiline_comment_depth - 1
				i = i + 2
				found_comment_marker = true
				break
			else
				i = i + 1
			end
		end

		local comment_end_index
		if found_comment_marker then
			comment_end_index = i - 2
		else
			comment_end_index = i
		end

		local comment = utils.trim(p.slice:sub(1, comment_end_index))
		local token = { type = "Comment", slice = comment }
		p.slice = p.slice:sub(i)
		return token
	elseif p.slice[1] == "/" and p.slice[2] == "/" then
		local index = p.slice:find("\n", 3)

		local newline_index
		if index then
			newline_index = index
		else
			newline_index = #p.slice
		end

		local token = { type = "Comment", slice = utils.trim(p.slice:sub(3, newline_index)) }
		p.slice = p.slice:sub(newline_index)
		return token
	elseif p.slice[1] == "/" and p.slice[2] == "*" then
		p.multiline_comment_depth = p.multiline_comment_depth + 1

		local found_comment_marker = false
		local i = 2
		while i <= #p.slice do
			if p.slice[i] == "\n" then
				break
			elseif p.slice[i] == "/" and p.slice[i + 1] == "*" then
				p.multiline_comment_depth = p.multiline_comment_depth + 1
				i = i + 2
				found_comment_marker = true
				break
			elseif p.slice[i] == "*" and p.slice[i + 1] == "/" then
				p.multiline_comment_depth = p.multiline_comment_depth + 1
				i = i + 2
				found_comment_marker = true
				break
			else
				i = i + 1
			end
		end

		local comment_end_index
		if found_comment_marker then
			comment_end_index = i - 2
		else
			comment_end_index = i
		end

		local comment = utils.trim(p.slice:sub(3, comment_end_index))
		local token = { type = "Comment", slice = comment }
		p.slice = p.slice:sub(i)
		return token
	elseif p.slice[1] == "\t" then
		local i = 2
		while i <= #p.slice do
			local character = p.slice[i]
			if character ~= "\t" then
				break
			end
			i = i + 1
		end

		local token = { type = "Tabs", slice = p.slice:sub(1, i - 1) }
		p.slice = p.slice:sub(i)
		return token
	elseif p.slice[1] == " " then
		local i = 2
		while i <= #p.slice do
			local character = p.slice[i]
			if character ~= " " then
				break
			end
			i = i + 1
		end

		local token = { type = "Spaces", slice = p.slice:sub(1, i - 1) }
		p.slice = p.slice:sub(i)
		return token
	elseif p.slice[1] == "=" then
		local token = { type = "Equals", slice = p.slice[1] }
		p.slice = p.slice:sub(2)
		return token
	end

	-- A Sentence ends with a word, or the start of a comment
	local end_index = 2
	local sentence_end_index = end_index
	while end_index <= #p.slice do
		if p.slice[end_index] == "=" and not p.seen_property then
			break
		end
		if
			p.slice[end_index] == "\n"
			or p.slice[end_index] == "\t"
			or (p.slice[end_index] == "/" and (p.slice[end_index + 1] == "*" or p.slice[end_index + 1] == "/"))
		then
			break
		end
		if p.slice[end_index] ~= " " then
			sentence_end_index = end_index + 1
		end
		end_index = end_index + 1
	end

	p.seen_property = true
	local token = { type = "Sentence", slice = p.slice:sub(1, sentence_end_index - 1) }
	p.slice = p.slice:sub(sentence_end_index)
	return token
end

return M
