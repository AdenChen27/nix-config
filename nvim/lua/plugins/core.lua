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
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
}
