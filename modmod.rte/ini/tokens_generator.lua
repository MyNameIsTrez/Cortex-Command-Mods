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


function M.get_tokens(file_path)
	local tokens = {}

	local text = file_functions.ReadFile(file_path)
	text = utils.lstrip(text)

	-- TODO: This is a hotfix for shitty Techion.rte/Devices/Tools/Nanolyzer/Nanolyzer.ini
	-- Make a Data repo PR that fixes this instead
	text = text:gsub("\t    ", "\t\t")

	text_len = #text

	i = 1
	while i <= text_len do
		local char = text:sub(i, i)

		if char == "/" then
			i = _tokenize_comment(i, text_len, text, tokens, file_path)
		elseif char == "\t" then
			i = _tokenize_tabs(i, text_len, text, tokens, file_path)
		elseif char == " " then
			i = _tokenize_spaces(i, text_len, text, tokens, file_path)
		elseif char == "=" then
			i = _tokenize_equals(i, text_len, text, tokens, file_path)
		elseif char == "\n" then
			i = _tokenize_newline(i, text_len, text, tokens, file_path)
		else
			i = _tokenize_word(i, text_len, text, tokens, file_path)
		end
	end

	return tokens
end


-- PRIVATE FUNCTIONS -----------------------------------------------------------


function _tokenize_comment(i, text_len, text, tokens, file_path)
	if i + 1 <= text_len and text:sub(i + 1, i + 1) == "/" then
		return _tokenize_single_line_comment(i, text_len, text, tokens, file_path)
	else
		return _tokenize_multi_line_comment(i, text_len, text, tokens, file_path)
	end
end


function _tokenize_single_line_comment(i, text_len, text, tokens, file_path)
	local token = ""

	while i <= text_len and text:sub(i, i) ~= "\n" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, _get_token("EXTRA", token, i, file_path))

	return i
end


function _get_token(type_, content, i, file_path)
	return { type = type_, content = content, index = i, file_path = file_path }
end


function _tokenize_multi_line_comment(i, text_len, text, tokens, file_path)
	local token = ""

	while i <= text_len and not (text:sub(i, i) == "*" and i + 1 <= text_len and text:sub(i + 1, i + 1) == "/") do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	token = token .. "*/"
	i = i + 2

	table.insert(tokens, _get_token("EXTRA", token, i, file_path))

	return i
end


function _tokenize_tabs(i, text_len, text, tokens, file_path)
	local token = ""

	while i <= text_len and text:sub(i, i) == "\t" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, _get_token("TABS", token, i, file_path))

	return i
end


function _tokenize_spaces(i, text_len, text, tokens, file_path)
	local token = ""

	while i <= text_len and text:sub(i, i) == " " do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, _get_token("EXTRA", token, i, file_path))

	return i
end


function _tokenize_equals(i, text_len, text, tokens, file_path)
	local token = ""

	while i <= text_len and text:sub(i, i) == "=" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, _get_token("EQUALS", token, i, file_path))

	return i
end


function _tokenize_newline(i, text_len, text, tokens, file_path)
	local token = ""

	while i <= text_len and text:sub(i, i) == "\n" do
		token = token .. text:sub(i, i)
		i = i + 1
	end

	table.insert(tokens, _get_token("NEWLINES", token, i, file_path))

	return i
end


function _tokenize_word(i, text_len, text, tokens, file_path)
	local subtext = text:sub(i)

	local token = word:match(subtext)

	i = i + #token

	table.insert(tokens, _get_token("WORD", token, i, file_path))

	return i
end


-- MODULE END ------------------------------------------------------------------


return M;
