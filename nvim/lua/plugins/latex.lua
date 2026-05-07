return {
	{
		"lervag/vimtex",
		init = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_view_method = "general"
			vim.g.vimtex_view_general_viewer = "sioyek"
			vim.g.vimtex_view_general_options = "--forward-search-file @tex --forward-search-line @line @pdf"
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_fold_enabled = 1
			vim.g.vimtex_matchparen_enabled = 0
      vim.g.vimtex_syntax_custom_cmds = {
				{ name = 'vec', mathmode = true, conceal = true, argstyle = 'bold' },
				{ name = 'vocab', conceal = true, argstyle = 'bold' },
			}
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
			vim.g.vimtex_compiler_latexmk_engines = { _ = "-xelatex" }
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "aux",
				out_dir = "",
				callback = 1,
				continuous = 1,
				executable = "latexmk",
				options = {
					"-verbose",
					"-file-line-error",
				},
			}

      -- override imaps after vimtex init
			vim.api.nvim_create_autocmd("User", {
				pattern = "VimtexEventInitPost",
				callback = function()
					local add_map = vim.fn["vimtex#imaps#add_map"]
					add_map({
						lhs = "`e",
						rhs = "\\eps",
						leader = "",
						wrapper = "vimtex#imaps#wrap_math",
					})
					add_map({
						lhs = "`f",
						rhs = "\\vphi",
						leader = "",
						wrapper = "vimtex#imaps#wrap_math",
					})
				end,
			})
		end,
		config = function()
			local function relink(group, target)
				vim.api.nvim_set_hl(0, group, { link = target })
			end
			relink("texCmd", "Function")
			relink("texCmdEnv", "Function")
			relink("texCmdPart", "Function")
			relink("texDefCmd", "Function")
			relink("texArg", "Identifier")
			relink("texOpt", "Identifier")
			relink("texMathZoneX", "String")
			relink("texMathZoneY", "String")
			relink("texMathSymbol", "Operator")
			relink("texEnvArgName", "Type")
			relink("texSection", "Keyword")
			relink("texComment", "Comment")
			relink("texRefZone", "Underlined")
			relink("texInputFile", "String")
			relink("texDelimiter", "Delimiter")
			relink("texTypeStyle", "Type")
		end,
	},
	-- "KeitaNakamura/tex-conceal.vim",
}
