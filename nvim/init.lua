vim.g.mapleader = " "

require("config.lazy")
require("config.options")
require("config.keymaps")

-- Autocommands
local aug = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

aug("remember_folds", { clear = true })
cmd("BufWinLeave", {
	group = "remember_folds",
	pattern = "*",
	command = "mkview",
})
cmd("BufWinEnter", {
	group = "remember_folds",
	pattern = "*",
	command = "silent! loadview",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("CustomTabSettings", { clear = true }),
	pattern = { "python", "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

-- Colours & Conceal
vim.api.nvim_set_hl(0, "Conceal", { link = "Normal" })
vim.api.nvim_set_hl(0, "SpellBad", { underline = true })
-- vim.api.nvim_set_hl(0, "Normal", { fg = "#111111" })

-- Spelling helper
vim.keymap.set("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { silent = true })
