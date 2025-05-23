return {
	-- Colorschemes
	{ "ayu-theme/ayu-vim", name = "ayu" },
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "projekt0n/github-nvim-theme", name = "github-theme" },
	{ "EdenEast/nightfox.nvim" },
	{ "marko-cerovac/material.nvim" },

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
		"NvChad/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Icons (used by lualine, telescope, etc.)
	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- Smooth scrolling
	{ "psliwka/vim-smoothie" },
}
