return {
	-- Core
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
  {
    "ggandor/leap.nvim",
    config = function()
      local leap = require("leap")

      -- Only map `s` (forward) and `S` (backward) for current window
      vim.keymap.set({ "n", "x", "o" }, "s", function()
        leap.leap({ target_windows = { vim.api.nvim_get_current_win() } })
      end)

      vim.keymap.set({ "n", "x", "o" }, "S", function()
        leap.leap({ backward = true, target_windows = { vim.api.nvim_get_current_win() } })
      end)
    end,
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
}
