--- This file contains the implementation of the hmts-path? and hmts-inject! predicates.

--- TODO: find a way to properly get these types in scope for the language server
--- @alias TSNode userdata
--- @alias vim.regex userdata

--- Returns a compiled vim regex for the given pattern. The regex is cached in a table to avoid recompilation.
---@param pattern string
---@return vim.regex
local function get_regex(pattern)
	local magic_prefixes = { ["\\v"] = true, ["\\m"] = true, ["\\M"] = true, ["\\V"] = true }
	local function check_magic(str)
		if string.len(str) < 2 or magic_prefixes[string.sub(str, 1, 2)] then
			return str
		end
		return "\\v" .. str
	end

	local compiled_vim_regexes = setmetatable({}, {
		__index = function(t, pat)
			local res = vim.regex(check_magic(pat))
			rawset(t, pat, res)
			return res
		end,
	})

	return compiled_vim_regexes[pattern]
end

--- Checks if the given string matches the given regex pattern.
---@param pattern string
---@param str string
---@return boolean
local function regex_match(pattern, str)
	local regex = get_regex(pattern)
	return regex:match_str(str) ~= nil
end

--- Compares the given nix path with the given target path. The target path is modified in place, with the matching
--- nodes removed.
---@param target_path string[]
---@param node_path string[]
---@return boolean
local function path_diff(target_path, node_path)
	local is_match = false

	while true do
		if
			#node_path == 0
			or #target_path == 0
			or not regex_match(target_path[#target_path], node_path[#node_path])
		then
			break
		end
		is_match = true
		table.remove(target_path)
		table.remove(node_path)
	end

	return is_match
end

--- Returns the text of the given path node.
---@param node TSNode
---@param bufnr integer
---@return string|nil
local function get_text_from_path_node(node, bufnr)
	if node:type() == "identifier" then
		return vim.treesitter.get_node_text(node, bufnr)
	elseif node:type() == "string_expression" then
		return vim.treesitter.get_node_text(node:child(0), bufnr)
	end

	return nil
end

--- Returns the nix path of the given attrpath node as a list of strings.
---@param attrpath TSNode
---@param bufnr integer
---@return string[]
local function attrpath_to_strings(attrpath, bufnr)
	local path = {}

	for _, node in ipairs(attrpath:field("attr")) do
		local text = get_text_from_path_node(node, bufnr)
		table.insert(path, text)
	end

	return path
end

--- Returns the filename contained in the parent of the given node.
---@param path_node TSNode
---@param bufnr integer
---@return string|nil
local function find_filename_in_parent_node(path_node, bufnr)
	local text = vim.treesitter.get_node_text(path_node, bufnr)
	local _, _, filename = string.find(text, "(.*)%.text$")
	filename = string.sub(filename, 2, -2)

	if filename ~= nil then
		return filename
	end

	local parent = path_node:parent()
	while parent do
		if parent:type() == "binding" then
			local attrpath = parent:field("attrpath")[1]
			return get_text_from_path_node(attrpath, bufnr)
		end
		parent = parent:parent()
	end
end

--- Checks if the given capture is located at the end of the given nix path. Every node can be matched by a regex.
---@param match table<string, TSNode>
---@param _ string
---@param bufnr integer
---@param predicate string[]
---@return boolean
local function hmts_path_handler(match, _, bufnr, predicate)
	local node = match[predicate[2]]:parent()
	local target_path = vim.list_slice(predicate, 3, nil)

	while node do
		if #target_path == 0 then
			return true
		end
		if node:type() == "binding" then
			local path_node = node:field("attrpath")[1]
			local is_match = path_diff(target_path, attrpath_to_strings(path_node, bufnr))
			if not is_match then
				return false
			end
		end
		node = node:parent()
	end

	return false
end

--- Detects the language of the injection from the file extension of the filename contained in the nix path of the given
--- capture.
---@param match table<string, TSNode>
---@param _ string
---@param bufnr integer
---@param predicate string[]
---@param metadata table<string, string>
local function hmts_inject_handler(match, _, bufnr, predicate, metadata)
	local path_node = match[predicate[2]]
	local filename = find_filename_in_parent_node(path_node, bufnr)
	local ext = vim.fn.fnamemodify(filename, ":e")
	local lang = vim.treesitter.language.get_lang(ext)
	metadata["injection.language"] = lang
end

vim.treesitter.query.add_predicate("hmts-path?", hmts_path_handler)
vim.treesitter.query.add_directive("hmts-inject!", hmts_inject_handler)
