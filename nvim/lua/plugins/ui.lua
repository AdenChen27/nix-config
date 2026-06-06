return {
	{
		"sainnhe/everforest",
		priority = 1000,
		lazy = false,
		config = function()
			vim.o.background = "light"
			vim.g.everforest_background = "hard"      -- lightest built-in (#fffbef)
			vim.g.everforest_better_performance = 1
			vim.cmd("colorscheme everforest")

			local bg = "#ffffff"  -- override: lighter than everforest hard
			vim.api.nvim_set_hl(0, "Normal",       { bg = bg })
			vim.api.nvim_set_hl(0, "NormalNC",     { bg = bg })
			vim.api.nvim_set_hl(0, "SignColumn",   { bg = bg })
			vim.api.nvim_set_hl(0, "EndOfBuffer",  { bg = bg })
			vim.api.nvim_set_hl(0, "LineNr",       { bg = bg })
			vim.api.nvim_set_hl(0, "FoldColumn",   { bg = bg })

			vim.api.nvim_set_hl(0, "Conceal", { link = "Normal" })
			vim.api.nvim_set_hl(0, "SpellBad", { underline = true })
		end,
	},
	{ "EdenEast/nightfox.nvim",     lazy = true },  -- dayfox
	{ "catppuccin/nvim",            lazy = true, name = "catppuccin" },  -- catppuccin-latte
	{ "NLKNguyen/papercolor-theme", lazy = true },  -- PaperColor

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
				},
			})
		end,
	},

  -- Color
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup()
		end,
	},

	-- Icons (used by lualine, telescope, etc.)
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Keybinding hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup()
		end,
	},

	-- Markdown rendering
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("render-markdown").setup()
		end,
	},

	-- Browser Markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft = { "markdown" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
	},
}
