-- <C-j/j/k/l> to move between windows
for _, key in ipairs({ "h", "j", "k", "l" }) do
	vim.keymap.set("n", "<C-" .. key:upper() .. ">", "<C-w><C-" .. key:upper() .. ">", { silent = true })
end

-- <leader>/ to comment out the current line
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })

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


-- <telescope>
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
