-- <C-j/j/k/l> to move between windows
for _, key in ipairs({ "h", "j", "k", "l" }) do
	vim.keymap.set("n", "<C-" .. key:upper() .. ">", "<C-w><C-" .. key:upper() .. ">", { silent = true })
end

-- <leader>/ to comment out the current line
vim.keymap.set("n", "<leader>/", ":Commentary<CR>j")

-- <leader>F to run stylua on the current file
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.keymap.set("n", "<leader>F", function()
			vim.cmd("silent! write")
			vim.cmd("silent! !stylua %")
			vim.cmd("edit")
		end, { buffer = true, desc = "Format Lua with stylua" })
	end,
})


-- <C-l> to correct spelling in insert mode
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { silent = true })

