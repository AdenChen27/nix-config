local group = vim.api.nvim_create_augroup("PythonCellMarkers", { clear = true })

local function set_highlight()
	vim.api.nvim_set_hl(0, "PythonCellMarker", {
		fg = "#3a6b5f",
		bg = "#f4f0d9",
		bold = true,
	})
end

local function clear_match()
	if vim.w.python_cell_marker_match_id then
		pcall(vim.fn.matchdelete, vim.w.python_cell_marker_match_id)
		vim.w.python_cell_marker_match_id = nil
	end
end

local function update_match()
	clear_match()

	if vim.bo.filetype == "python" then
		vim.w.python_cell_marker_match_id = vim.fn.matchadd("PythonCellMarker", [[^\s*#\s*%%.*$]], 20)
	end
end

set_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
	group = group,
	callback = set_highlight,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType", "WinEnter" }, {
	group = group,
	callback = update_match,
})
