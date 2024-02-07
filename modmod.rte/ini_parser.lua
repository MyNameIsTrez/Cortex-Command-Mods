local file_functions = dofile("utils.rte/Modules/file_functions.lua")
local utils = dofile("utils.rte/Modules/utils.lua")

local get = utils.get

local M = {}

function M.parse(path)
	local text = file_functions.read_file(path)
	text = crlf_to_lf(text)

	local tokens = get_tokens(text, path)

	return get_ast(tokens, path)
end

function crlf_to_lf(text)
	return text:gsub("\r\n", "\n")
end

function get_tokens(text, path)
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
		error("Unclosed multiline comment in file " .. path)
	end

	return tokens
end

function get_token(p)
	if get(p.slice, 1) == "\n" then
		p.seen_property = false
		local token = { type = "Newline", slice = get(p.slice, 1) }
		p.slice = p.slice:sub(2)
		return token
	elseif p.multiline_comment_depth > 0 then
		local found_comment_marker = false
		local i = 1
		while i <= #p.slice do
			if get(p.slice, i) == "\n" then
				break
			elseif get(p.slice, i) == "/" and get(p.slice, i + 1) == "*" then
				p.multiline_comment_depth = p.multiline_comment_depth + 1
				i = i + 2
				found_comment_marker = true
				break
			elseif get(p.slice, i) == "*" and get(p.slice, i + 1) == "/" then
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
	elseif get(p.slice, 1) == "/" and get(p.slice, 2) == "/" then
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
	elseif get(p.slice, 1) == "/" and get(p.slice, 2) == "*" then
		p.multiline_comment_depth = p.multiline_comment_depth + 1

		local found_comment_marker = false
		local i = 2
		while i <= #p.slice do
			if get(p.slice, i) == "\n" then
				break
			elseif get(p.slice, i) == "/" and get(p.slice, i + 1) == "*" then
				p.multiline_comment_depth = p.multiline_comment_depth + 1
				i = i + 2
				found_comment_marker = true
				break
			elseif get(p.slice, i) == "*" and get(p.slice, i + 1) == "/" then
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
	elseif get(p.slice, 1) == "\t" then
		local i = 2
		while i <= #p.slice do
			local character = get(p.slice, i)
			if character ~= "\t" then
				break
			end
			i = i + 1
		end

		local token = { type = "Tabs", slice = p.slice:sub(1, i - 1) }
		p.slice = p.slice:sub(i)
		return token
	elseif get(p.slice, 1) == " " then
		local i = 2
		while i <= #p.slice do
			local character = get(p.slice, i)
			if character ~= " " then
				break
			end
			i = i + 1
		end

		local token = { type = "Spaces", slice = p.slice:sub(1, i - 1) }
		p.slice = p.slice:sub(i)
		return token
	elseif get(p.slice, 1) == "=" then
		local token = { type = "Equals", slice = get(p.slice, 1) }
		p.slice = p.slice:sub(2)
		return token
	end

	-- A Sentence ends with a word, or the start of a comment
	local end_index = 2
	local sentence_end_index = end_index
	while end_index <= #p.slice do
		if get(p.slice, end_index) == "=" and not p.seen_property then
			break
		end
		if
			get(p.slice, end_index) == "\n"
			or get(p.slice, end_index) == "\t"
			or (
				get(p.slice, end_index) == "/"
				and (get(p.slice, end_index + 1) == "*" or get(p.slice, end_index + 1) == "/")
			)
		then
			break
		end
		if get(p.slice, end_index) ~= " " then
			sentence_end_index = end_index + 1
		end
		end_index = end_index + 1
	end

	p.seen_property = true
	local token = { type = "Sentence", slice = p.slice:sub(1, sentence_end_index - 1) }
	p.slice = p.slice:sub(sentence_end_index)
	return token
end

function get_ast(tokens, path)
	local ast = {}

	-- The game ignores the indentation of the first line of a file,
	-- but we choose to trim that indentation
	local p = {
		token_index = 1,
	}
	if line_has_sentence(tokens, p.token_index) then
		p.token_index = left_trim_first_line(tokens)
	end

	while p.token_index < #tokens do
		local node = get_node(tokens, p, 0)
		table.insert(ast, node)
	end

	return ast
end

function line_has_sentence(tokens, token_index)
	while token_index < #tokens do
		local token = tokens[token_index]

		if token.type == "Newline" then
			return false
		elseif token.type == "Sentence" then
			return true
		end

		token_index = token_index + 1
	end

	return false
end

function left_trim_first_line(tokens)
	local token_index = 1

	while tokens[token_index].type ~= "Sentence" do
		token_index = token_index + 1
	end

	return token_index
end

function get_node(tokens, p, depth)
	local seen = "Start"
	
	local node = {
		comments = {},
		children = {},
	}

	local token = tokens[p.token_index]

	local line_depth = get_line_depth(tokens, p.token_index)
	if line_depth > depth then
		error_on_line_and_column("Too many tabs", tokens, p.token_index)
	elseif line_depth < depth then
		return node
	end

	local checked_line_depth = true

	while p.token_index < #tokens do
		local token = tokens[p.token_index]
		
		if seen == "Start" and token.type == "Sentence" then
			-- This if-statement is deliberately in a loop,
			-- since whitespace and multiline comments may come before it
			node.property = token.slice
			seen = "Property"
			p.token_index = p.token_index + 1
		elseif seen == "Newline" and not checked_line_depth then
			checked_line_depth = true

			line_depth = get_line_depth(tokens, p.token_index)

			if line_depth > depth + 1 then
				error_on_line_and_column("Too many tabs", tokens, p.token_index)
			elseif line_depth == depth + 1 then
				local child_node = get_node(tokens, p, depth + 1)
				table.insert(node.children, child_node)
				checked_line_depth = false
			else
				return node
			end
		elseif seen == "Property" and token.type == "Equals" then
			seen = "Equals"
			p.token_index = p.token_index + 1
		elseif seen == "Equals" and token.type == "Sentence" then
			node.value = token.slice
			seen = "Value"
			p.token_index = p.token_index + 1
		elseif token.type == "Comment" then
			if #token.slice > 0 then
				table.insert(node.comments, token.slice)
			end
			p.token_index = p.token_index + 1
		elseif token.type == "Tabs" or token.type == "Spaces" then
			p.token_index = p.token_index + 1
		elseif token.type == "Newline" then
			seen = "Newline"
			p.token_index = p.token_index + 1
			checked_line_depth = false
		else
			error_on_line_and_column("Unexpected token '" .. token.slice .. "'", tokens, p.token_index)
		end
	end
	
	return node
end

function get_line_depth(tokens, token_index)
	local token = tokens[token_index]

	if token.type == "Sentence" then
		return 0
	elseif not line_has_sentence(tokens, token_index) then
		return get_next_sentence_depth(tokens, token_index)
	end

	local tabs_seen = 0

	while token_index < #tokens do
		token = tokens[token_index]

		if token.type == "Sentence" then
			return tabs_seen
		end

		if token.type == "Tabs" then
			tabs_seen = tabs_seen + #token.slice
		end

		token_index = token_index + 1
	end

	return 0
end

function get_next_sentence_depth(tokens, token_index)
	local tabs_seen = 0

	while token_index < #tokens do
		local token = tokens[token_index]

		if token.type == "Newline" then
			tabs_seen = 0
		elseif token.type == "Sentence" then
			return tabs_seen
		end

		if token.type == "Tabs" then
			tabs_seen = tabs_seen + #token.slice
		end

		token_index = token_index + 1
	end

	return 0
end

function error_on_line_and_column(reason, tokens, token_index)
	local line = 1
	local column = 1

	local i = 1
	while i < token_index do
		local token = tokens.items[i]

		if token.type == "Newline" then
			line = line + 1
			column = 1
		else
			column = column + #token.slice
		end

		i = i + 1
	end

	error("Error: " .. reason .. " on line " .. line .. ", column " .. column)
end

return M
