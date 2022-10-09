-- REQUIREMENTS ----------------------------------------------------------------

local tokens_generator = dofile("modmod.rte/ini_object_tree/tokens_generator.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")

-- MODULE START ----------------------------------------------------------------

local M = {}

-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------

-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------

-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------

-- INTERNAL PRIVATE VARIABLES --------------------------------------------------

-- PUBLIC FUNCTIONS ------------------------------------------------------------

function M.get_cst(file_path)
	local tokens = tokens_generator.get_tokens(file_path)
	return generate_cst(tokens)
end

-- PRIVATE FUNCTIONS -----------------------------------------------------------

function generate_cst(tokens, parsed, token_idx, depth)
	--[[
	newline -> start -> property -> equals -> value
	^                                         v
	+-----------------------------------------+
	--]]

	local depth = depth or 0

	if parsed == nil then
		parsed = {}
	end
	if token_idx == nil then
		token_idx = { 1 }
	end

	local state = "newline"

	while token_idx[1] <= #tokens do
		token = tokens[token_idx[1]]

		if state == "newline" and _is_deeper(depth, token, tokens, token_idx[1] + 1) then
			local children = { type = "children", content = {} }
			_append(children, parsed)
			generate_cst(tokens, children.content, token_idx, depth + 1)
			-- "state" is deliberately not being changed here.
		elseif state == "newline" and _is_same_depth(depth, token, tokens, token_idx[1] + 1) then
			table.insert(parsed, {})
			state = "start"
		elseif state == "newline" and _is_shallower(depth, token, tokens, token_idx[1] + 1) then
			return
		elseif state == "newline" and (#parsed == 0 or token.type == "WORD") then
			table.insert(parsed, {})
			state = "start"
		elseif state == "start" and token.type == "WORD" then
			_append({ type = "property", content = token["content"] }, parsed)
			state = "property"
			token_idx[1] = token_idx[1] + 1
		elseif state == "property" and token.type == "EQUALS" then
			_append({ type = "extra", content = token["content"] }, parsed)
			state = "equals"
			token_idx[1] = token_idx[1] + 1
		elseif state == "property" and token.type == "NEWLINES" then
			_append({ type = "extra", content = token["content"] }, parsed)
			state = "newline"
			token_idx[1] = token_idx[1] + 1
		elseif state == "equals" and token.type == "WORD" then
			_append({ type = "value", content = token["content"] }, parsed)
			state = "value"
			token_idx[1] = token_idx[1] + 1
		elseif state == "value" and token.type == "NEWLINES" then
			_append({ type = "extra", content = token["content"] }, parsed)
			state = "newline"
			token_idx[1] = token_idx[1] + 1
		else
			_append({ type = "extra", content = token["content"] }, parsed)
			token_idx[1] = token_idx[1] + 1
		end
	end

	return parsed
end

function _is_deeper(depth, token, tokens, next_token_idx)
	new_depth = _get_depth(token, tokens, next_token_idx)

	if new_depth > depth + 1 then
		error(
			string.format(
				"Too many tabs after one another were found at file_path '%s' at character %d. If you aren't able to find where the excessive tabs are, ask MyNameIsTrez#1585 in the CCCP Discord server for help.",
				token.file_path,
				token.index
			)
		)
	end

	return new_depth > depth
end

function _get_depth(token, tokens, next_token_idx)
	local tabs_seen

	if token.type == "NEWLINES" then
		return -1
	elseif token.type == "WORD" then
		return 0
	elseif token.type == "TABS" then
		tabs_seen = #token.content
	else
		tabs_seen = 0
	end

	while next_token_idx <= #tokens do
		next_token = tokens[next_token_idx]

		if next_token.type == "WORD" then
			return tabs_seen
		elseif next_token.type == "TABS" then
			tabs_seen = tabs_seen + #next_token.content
		elseif next_token.type == "NEWLINES" then
			return -1
		end

		next_token_idx = next_token_idx + 1
	end

	return -1 -- Reached when the while-loop read the last character of the file and didn't return.
end

function _append(parsed_token, parsed)
	table.insert(parsed[#parsed], parsed_token)
end

function _is_same_depth(depth, token, tokens, next_token_idx)
	return token.type == "TABS" and _get_depth(token, tokens, next_token_idx) == depth
end

function _is_shallower(depth, token, tokens, next_token_idx)
	new_depth = _get_depth(token, tokens, next_token_idx)
	return new_depth ~= -1 and new_depth < depth
end

-- MODULE END ------------------------------------------------------------------

return M
