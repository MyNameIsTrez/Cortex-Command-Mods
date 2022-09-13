-- REQUIREMENTS ----------------------------------------------------------------


local tokens_generator = dofile("modmod.rte/ini/tokens_generator.lua")

local utils = dofile("utils.rte/Modules/Utils.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------





-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_cst(filepath)
	local tokens = tokens_generator.get_tokens(filepath)
	return M._generate_cst(tokens)
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function M._generate_cst(tokens, parsed, token_idx, depth)
	--[[
	newline -> start -> property -> equals -> value
	^                                         v
	+-----------------------------------------+
	]]--

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

		if     state == "newline" and is_deeper(depth, token, tokens, token_idx[1] + 1) then
			local children = { type = "children", content = {} }
			append(children, parsed)
			M._generate_cst(tokens, children.content, token_idx, depth + 1)
			-- "state" is deliberately not being changed here.
		elseif state == "newline" and is_same_depth(depth, token, tokens, token_idx[1] + 1) then
			table.insert(parsed, {})
			state = "start"
		elseif state == "newline" and is_shallower(depth, token, tokens, token_idx[1] + 1) then
			return
		elseif state == "newline" and (#parsed == 0 or token.type == "WORD") then
			table.insert(parsed, {})
			state = "start"

		elseif state == "start" and token.type == "WORD" then
			append( { type = "property", content = token["content"] }, parsed )
			state = "property"
			token_idx[1] = token_idx[1] + 1
		elseif state == "property" and token.type == "EQUALS" then
			append( { type = "extra", content = token["content"] }, parsed )
			state = "equals"
			token_idx[1] = token_idx[1] + 1
		elseif state == "property" and token.type == "NEWLINES" then
			append( { type = "extra", content = token["content"] }, parsed )
			state = "newline"
			token_idx[1] = token_idx[1] + 1
		elseif state == "equals" and token.type == "WORD" then
			append( { type = "value", content = token["content"] }, parsed )
			state = "value"
			token_idx[1] = token_idx[1] + 1
		elseif state == "value" and token.type == "NEWLINES" then
			append( { type = "extra", content = token["content"] }, parsed )
			state = "newline"
			token_idx[1] = token_idx[1] + 1

		else
			append( { type = "extra", content = token["content"] }, parsed )
			token_idx[1] = token_idx[1] + 1
		end
	end

	return parsed
end


function append(parsed_token, parsed)
	table.insert(parsed[#parsed], parsed_token)
end


function is_deeper(depth, token, tokens, next_token_idx)
	new_depth = get_depth(token, tokens, next_token_idx)

	if new_depth > depth + 1 then
		error("Too many tabs!")
	end

	return new_depth > depth
end


function get_depth(token, tokens, next_token_idx)
	local tabs_seen

	if     token.type == "NEWLINES" then
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

		if     next_token.type == "WORD" then
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

function is_same_depth(depth, token, tokens, next_token_idx)
	return token.type == "TABS" and get_depth(token, tokens, next_token_idx) == depth
end

function is_shallower(depth, token, tokens, next_token_idx)
	new_depth = get_depth(token, tokens, next_token_idx)
	return new_depth ~= -1 and new_depth < depth
end


-- MODULE END ------------------------------------------------------------------


return M;
