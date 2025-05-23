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
      leap.add_default_mappings()
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
