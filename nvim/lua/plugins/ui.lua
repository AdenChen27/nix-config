return {
	-- Colorschemes
	-- { "ayu-theme/ayu-vim", name = "ayu" },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd("colorscheme catppuccin-latte")
			vim.api.nvim_set_hl(0, "Conceal", { link = "Normal" })
			vim.api.nvim_set_hl(0, "SpellBad", { underline = true })
		end,
	},
	-- { "projekt0n/github-nvim-theme", name = "github-theme" },
	-- { "EdenEast/nightfox.nvim" },
	-- { "marko-cerovac/material.nvim" },

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
}
