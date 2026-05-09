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
				"latex",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
        disable = { "latex" }  -- parse only; VimTeX owns highlighting
			},
			indent = {
				enable = true,
			},
		})
	end,
}
