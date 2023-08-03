local function path_diff(target_path, node_path)
	local is_match = false
	local function regex_match(pattern, str)
		local regex = vim.regex(pattern)
		return regex:match_str(str)
	end

	while true do
		if #node_path == 0 or #target_path == 0 or regex_match(target_path[#target_path], node_path[#node_path]) then
			break
		end
		is_match = true
		table.remove(target_path)
		table.remove(node_path)
	end

	return is_match
end

local function get_text_from_path_node(node, bufnr)
	if node:type() == "identifier" then
		return vim.treesitter.get_node_text(node, bufnr)
	elseif node:type() == "string_expression" then
		return vim.treesitter.get_node_text(node:child(0), bufnr)
	end

	return nil
end

local function attrpath_to_strings(attrpath, bufnr)
	local path = {}

	for _, node in ipairs(attrpath:field("attr")) do
		local text = get_text_from_path_node(node, bufnr)
		table.insert(path, text)
	end

	return path
end

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

local function hmts_inject_handler(match, _, bufnr, predicate, metadata)
	local path_node = match[predicate[2]]
	local filename = find_filename_in_parent_node(path_node, bufnr)
	local ext = vim.fn.fnamemodify(filename, ":e")
	local lang = vim.treesitter.language.get_lang(ext)
	metadata["injection.language"] = lang
end

vim.treesitter.query.add_predicate("hmts-path?", hmts_path_handler)
vim.treesitter.query.add_directive("hmts-inject!", hmts_inject_handler)
