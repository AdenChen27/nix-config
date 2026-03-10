return {
	{
		"lervag/vimtex",
		init = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 0
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_fold_enabled = 1
			vim.g.vimtex_matchparen_enabled = 0
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
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "aux",
				out_dir = "",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
				},
			}

      -- override imaps after vimtex init
			vim.api.nvim_create_autocmd("User", {
				pattern = "VimtexEventInitPost",
				callback = function()
					local add_map = vim.fn["vimtex#imaps#add_map"]
					add_map({
						lhs = "`e",
						rhs = "\\varepsilon",
						leader = "",
						wrapper = "vimtex#imaps#wrap_math",
					})
					add_map({
						lhs = "`f",
						rhs = "\\varphi",
						leader = "",
						wrapper = "vimtex#imaps#wrap_math",
					})
				end,
			})
		end,
	},
	-- "KeitaNakamura/tex-conceal.vim",
}
