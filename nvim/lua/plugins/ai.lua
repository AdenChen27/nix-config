return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- handled by copilot-cmp
				panel = { enabled = false },      -- handled by copilot-cmp
				filetypes = { ["*"] = true },     -- attach everywhere; BufEnter handles courses
			})

			-- Disable Copilot when path contains "courses" (case-insensitive)
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local buf_path = vim.fn.expand("%:p")
					local buf_name = vim.fn.expand("%:t")
					if
						string.find(string.lower(buf_path), "/courses/")
						and not string.find(string.lower(buf_name), "notes")
					then
						vim.cmd("Copilot disable")
					else
						vim.cmd("Copilot enable")
					end
				end,
			})
		end,
	},
}
