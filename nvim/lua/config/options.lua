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

