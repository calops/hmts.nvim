local M = {}

local function path_diff(node_path, target_path)
	local is_match = false

	while true do
		if #node_path == 0 or node_path[#node_path] ~= target_path[#target_path] then
			break
		end
		is_match = true
		table.remove(target_path)
		table.remove(node_path)
	end

	return is_match
end

function M.setup(_)
	vim.treesitter.query.add_predicate("nix-path?", function(match, _, bufnr, predicate)
		local node_capture = predicate[2]
		local target_path = vim.list_slice(predicate, 3, nil)
		local node = match[node_capture]:parent():parent()

		while node do
			if #target_path == 0 then
				vim.print("success")
				return true
			end
			if node:type() == "binding" then
				local path_node = node:field("attrpath")[1]
				local path_str = vim.treesitter.get_node_text(path_node, bufnr)
				local is_match = path_diff(vim.split(path_str, ".", { plain = true }), target_path)
				if not is_match then
					return false
				end
			end
			node = node:parent()
		end

		return false
	end)
end

return M
