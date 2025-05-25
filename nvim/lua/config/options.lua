local o = vim.opt

-- UI
o.number = true
o.relativenumber = true
o.colorcolumn = "80"
o.mouse = "v"
o.spell = true
o.termguicolors = true
o.conceallevel = 2
o.signcolumn = "yes"

vim.api.nvim_set_hl(0, "Conceal", { link = "Normal" })
vim.api.nvim_set_hl(0, "SpellBad", { underline = true })


-- Colorschemes
o.background = "light"
vim.cmd("colorscheme catppuccin-latte")

-- Search Behavior
o.incsearch = true
o.hlsearch = false

-- Editing Behavior
o.fileencoding = "utf-8"
o.backspace = { "indent", "eol", "start" }
o.updatetime = 250

-- Search
o.ignorecase = true
o.smartcase = true

-- Indentation
o.autoindent = true
o.cindent = true
o.shiftwidth = 2
o.tabstop = 2
o.expandtab = true

-- Folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99

-- Persistent Data (swap/undo/backup)
local cache = vim.fn.stdpath("state")
o.directory  = cache .. "/swap//"
o.backupdir  = cache .. "/backup//"
o.undodir    = cache .. "/undo//"
o.undofile   = true


-- Autocommands

local aug = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

-- Remember folds
aug("remember_folds", { clear = true })
cmd("BufWinLeave", {
	group = "remember_folds",
	pattern = "*",
	callback = function()
		if vim.api.nvim_buf_get_name(0) ~= "" and vim.bo.buftype == "" then
			vim.cmd("mkview")
		end
	end,
})
cmd("BufWinEnter", {
	group = "remember_folds",
	pattern = "*",
	callback = function()
		if vim.api.nvim_buf_get_name(0) ~= "" and vim.bo.buftype == "" then
			vim.cmd("silent! loadview")
		end
	end,
})


-- FileType-specific indentation
cmd("FileType", {
	group = aug("CustomTabSettings", { clear = true }),
	pattern = { "python", "c", "cpp" },
	callback = function()
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true
	end,
})

