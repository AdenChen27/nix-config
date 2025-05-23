return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"python",
				"lua",
				"bash",
				"vim",
				"markdown",
				"json",
				"html",
				"css",
				"javascript",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
        disable = { "latex" }
			},
			indent = {
				enable = true,
			},
		})
	end,
}
