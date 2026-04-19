return {
	-- Core
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup()
      vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
      vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"tris203/precognition.nvim",
		event = "VeryLazy",
		config = function()
			require("precognition").setup()
		end,
	},
	{
		"timseriakov/spamguard.nvim",
		event = "VeryLazy",
		config = function()
			local spamguard = require("spamguard")
			spamguard.setup({})
			vim.schedule(function()
				spamguard.enable()
			end)
		end,
	},
	{
		"gaborvecsei/usage-tracker.nvim",
		event = "VeryLazy",
		config = function()
			require("usage-tracker").setup({})
		end,
	},
}
