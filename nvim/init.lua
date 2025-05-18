-- Init.lua ── only one lazy.nvim bootstrap + setup

-- 0. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git','clone','--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 1. Plugins
require('lazy').setup({
  -- file tree
  { 'preservim/NERDTree', cmd = 'NERDTreeToggle' },

  -- quality-of-life
  'vim-scripts/indentpython.vim',
  'tmsvg/pear-tree',
  {
    'wakatime/vim-wakatime',
    config = function()
      vim.g.wakatime_api_key = os.getenv('WAKATIME_API_KEY')
    end,
  },
  'tpope/vim-commentary',
  'ap/vim-css-color',
  'wfxr/minimap.vim',
  'psliwka/vim-smoothie',

  -- colours
  { 'ayu-theme/ayu-vim', name = 'ayu' },

  -- leap
  {
    'ggandor/leap.nvim',
    config = function()
      local leap = require('leap')

      -- Don't call `add_default_mappings()` to avoid installing all keys

      -- Only map `s` (forward) and `S` (backward)
      vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
        leap.leap({ target_windows = { vim.api.nvim_get_current_win() } })
      end)

      vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
        leap.leap({ backward = true, target_windows = { vim.api.nvim_get_current_win() } })
      end)
    end,
  },

  -- LaTeX
  {
    'lervag/vimtex',
    init = function()
      vim.g.tex_flavor                = 'latex'
      vim.g.vimtex_view_method        = 'skim'
      vim.g.vimtex_view_skim_sync     = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_quickfix_mode      = 0
      vim.g.vimtex_fold_enabled       = 1
      vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_compiler_latexmk   = {
        aux_dir   = 'aux',
        out_dir   = '',
        callback  = 1,
        continuous= 1,
        executable= 'latexmk',
        options   = {
          '-verbose','-file-line-error',
          '-synctex=1','-interaction=nonstopmode',
        },
      }
    end,
  },
  'KeitaNakamura/tex-conceal.vim',

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build   = "make install_jsregexp",
    event   = "VeryLazy",
    config  = function()
      require("config.luasnip").setup()
    end,
  },

  -- AI
  {
    "robitx/gp.nvim",
    config = function()
        local conf = {
        }
        require("gp").setup(conf)
    end,
  },
  {
      "github/copilot.vim",
      lazy = false,
      config = function()
        -- Disable Copilot's default <Tab> mapping
        vim.g.copilot_no_tab_map = true
        
        -- Use <C-J> to accept Copilot suggestions
        vim.cmd [[
          imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        ]]

        -- Disable Copilot when path contains "courses" (case-insensitive)
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "*",
          callback = function()
            local buf_path = vim.fn.expand("%:p")
            if string.find(string.lower(buf_path), "/courses/") then
              vim.cmd("Copilot disable")
            else
              vim.cmd("Copilot enable")
            end
          end,
        })
      end,
    }
})

-- 2. General options
local o = vim.opt
o.hlsearch       = false
o.mouse          = 'v'
o.hidden         = true
o.fileencoding   = 'utf-8'
o.relativenumber = true
o.number         = true
o.colorcolumn    = '80'
o.spell = true

local cache = vim.fn.stdpath('state')
o.directory = cache .. '/swap//'
o.backupdir = cache .. '/backup//'
o.undodir   = cache .. '/undo//'
o.undofile  = true

o.backspace   = { 'indent', 'eol', 'start' }
o.autoindent  = true
o.cindent     = true
o.shiftwidth  = 2
o.smarttab    = true
o.expandtab   = true
o.tabstop     = 2
o.softtabstop = 0

o.foldmethod = 'indent'
o.foldlevel  = 99
vim.keymap.set('n', '<space>', 'za', { silent = true })

-- 3. Key-maps
for _, key in ipairs({ 'h','j','k','l' }) do
  vim.keymap.set('n', '<C-' .. key:upper() .. '>',
    '<C-w><C-' .. key:upper() .. '>', { silent = true })
end
vim.keymap.set('n', '<leader>/', ':Commentary<CR>j')
vim.keymap.set('i', '<leader>/', '<Esc>:Commentary<CR>ji')
vim.keymap.set('v', '<leader>/', 'gc')

-- 4. Autocommands
local aug = vim.api.nvim_create_augroup
local cmd = vim.api.nvim_create_autocmd

aug('remember_folds', { clear = true })
cmd('BufWinLeave', {
  group = 'remember_folds',
  pattern = '*',
  command = 'mkview',
})
cmd('BufWinEnter', {
  group = 'remember_folds',
  pattern = '*',
  command = 'silent! loadview',
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


-- 5. Colours & Conceal
vim.opt.background = 'light'
vim.cmd('colorscheme ayu')
vim.api.nvim_set_hl(0,'Conceal',{ link = 'Normal' })
vim.api.nvim_set_hl(0,'SpellBad',{ underline = true })
vim.api.nvim_set_hl(0,'Normal',{ fg = '#111111' })

vim.opt.conceallevel = 2
-- vim.opt.concealcursor = "n"
vim.g.vimtex_syntax_conceal = {
  accents = 1,
  ligatures = 1,
  cites = 1,
  fancy = 1,
  greek = 1,
  math_bounds = 0,
  math_delimiters = 1,
  math_fracs = 1,
  math_super_sub = 1,
  symbols = 1,
}



-- 6. Minimap defaults
vim.g.minimap_width               = 10
vim.g.minimap_auto_start          = 1
vim.g.minimap_auto_start_win_enter= 1

-- 7. Spelling helper
vim.keymap.set('i','<C-l>','<c-g>u<Esc>[s1z=`]a<c-g>u',{ silent = true })

