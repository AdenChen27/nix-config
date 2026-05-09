return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		event = "BufReadPost",
		config = function()
			require("ufo").setup({
				provider_selector = function(_, filetype, _)
					-- Filetypes whose tree-sitter parser produces useful fold ranges.
					-- For others, fall back to indent-based folding.
					local ts_ok = {
						tex = true, python = true, lua = true, bash = true,
						markdown = true, json = true, html = true, css = true,
						javascript = true,
					}
					if ts_ok[filetype] then
						return { "treesitter", "indent" }
					end
					return { "indent" }
				end,
			})

			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
			vim.keymap.set("n", "K",  function()
				if not require("ufo").peekFoldedLinesUnderCursor() then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek fold or hover" })
		end,
	},
}
