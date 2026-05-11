return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		event = "BufReadPost",
		config = function()
			-- Fold ranges between `# %%` cell markers (Jupyter/VSCode style).
			local function cell_ranges(bufnr)
				local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
				local ranges, start = {}, nil
				for i, line in ipairs(lines) do
					if line:match("^%s*#%s*%%%%") then
						if start then
							table.insert(ranges, { startLine = start - 1, endLine = i - 2 })
						end
						start = i
					end
				end
				if start and start < #lines then
					table.insert(ranges, { startLine = start - 1, endLine = #lines - 1 })
				end
				return ranges
			end

			-- Python provider: treesitter folds + cell folds, merged.
			local function python_provider(bufnr)
				local ok, rs = pcall(require("ufo.provider.treesitter").getFolds, bufnr)
				if not ok or type(rs) ~= "table" then
					rs = {}
				end
				for _, r in ipairs(cell_ranges(bufnr)) do
					table.insert(rs, r)
				end
				return rs
			end

			require("ufo").setup({
				provider_selector = function(_, filetype, _)
					if filetype == "python" then
						return python_provider
					end
					-- Filetypes whose tree-sitter parser produces useful fold ranges.
					-- For others, fall back to indent-based folding.
					local ts_ok = {
						tex = true, lua = true, bash = true,
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
