-- REQUIREMENTS ----------------------------------------------------------------


local file_functions = dofile("utils.rte/Modules/FileFunctions.lua")
local utils = dofile("utils.rte/Modules/Utils.lua")

local l = dofile("utils.rte/Modules/lulpeg.lua")


-- MODULE START ----------------------------------------------------------------


local M = {};


-- CONFIGURABLE PUBLIC VARIABLES -----------------------------------------------





-- CONFIGURABLE PRIVATE VARIABLES ----------------------------------------------





-- INTERNAL PUBLIC VARIABLES ---------------------------------------------------





-- INTERNAL PRIVATE VARIABLES --------------------------------------------------


local P = l.P
local C = l.C

local space = l.S(" \t")^0
local delimiter =
	P(space^-1 * "=" ) +
	P(space^-1 * "//") +
	P(space^-1 * "/*") +
	P(space^-1 * "\n")

local word = C((1 - delimiter)^1)


-- PUBLIC FUNCTIONS ------------------------------------------------------------


function M.get_tokens(filepath)
	local tokens = {}

	local text = file_functions.ReadFile(filepath)
	text = utils.lstrip(text)

	text_len = #text

	i = 1
	while i <= text_len do
		local char = text:sub(i, i)

		if char == "/" then
			i = tokenize_comment(i, text_len, text, tokens, filepath)
		elseif char == "\t" then
			i = tokenize_tabs(i, text_len, text, tokens, filepath)
		elseif char == " " then
			i = tokenize_spaces(i, text_len, text, tokens, filepath)
		elseif char == "=" then
			i = tokenize_equals(i, text_len, text, tokens, filepath)
		elseif char == "\n" then
			i = tokenize_newline(i, text_len, text, tokens, filepath)
		else
			i = tokenize_word(i, text_len, text, tokens, filepath)
		end
	end

	return tokens
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function get_token(type_, content, i, filepath)
	return { type = type_, content = content, index = i, filepath = filepath }
end


function tokenize_comment(i, text_len, text, tokens, filepath)
	if i + 1 <= text_len and text:sub(i + 1, i + 1) == "/" then
		return tokenize_single_line_comment(i, text_len, text, tokens, filepath)
	else
		return tokenize_multi_line_comment(i, text_len, text, tokens, filepath)
	end
end


function tokenize_single_line_comment(i, text_len, text, tokens, filepath)
	local token = ""

	while i <= text_len and text:sub(i, i) ~= "\n" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, get_token("EXTRA", token, i, filepath))

	return i
end


function tokenize_multi_line_comment(i, text_len, text, tokens, filepath)
	local token = ""

	while i <= text_len and not (text:sub(i, i) == "*" and i + 1 <= text_len and text:sub(i + 1, i + 1) == "/") do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	token = token .. "*/"
	i = i + 2

	table.insert(tokens, get_token("EXTRA", token, i, filepath))

	return i
end


function tokenize_tabs(i, text_len, text, tokens, filepath)
	local token = ""

	while i <= text_len and text:sub(i, i) == "\t" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, get_token("TABS", token, i, filepath))

	return i
end


function tokenize_spaces(i, text_len, text, tokens, filepath)
	local token = ""

	while i <= text_len and text:sub(i, i) == " " do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, get_token("EXTRA", token, i, filepath))

	return i
end


function tokenize_equals(i, text_len, text, tokens, filepath)
	local token = ""

	while i <= text_len and text:sub(i, i) == "=" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, get_token("EQUALS", token, i, filepath))

	return i
end


function tokenize_newline(i, text_len, text, tokens, filepath)
	local token = ""

	while i <= text_len and text:sub(i, i) == "\n" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, get_token("NEWLINES", token, i, filepath))

	return i
end


function tokenize_word(i, text_len, text, tokens, filepath)
	local subtext = text:sub(i)

	local token = word:match(subtext)

	i = i + #token

	table.insert(tokens, get_token("WORD", token, i, filepath))

	return i
end


-- MODULE END ------------------------------------------------------------------


return M;
