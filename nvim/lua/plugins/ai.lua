return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false }, -- handled by copilot-cmp
				panel = { enabled = false },      -- handled by copilot-cmp
				filetypes = { ["*"] = true },     -- attach everywhere; autocmds handle courses
			})

			-- Track which buffers have already had their initial courses-disable applied
			-- this session. Cleared on BufEnter so each buffer visit gets one disable,
			-- but manual :Copilot enable persists for the rest of that visit.
			local initialized = {}

			local function in_courses()
				local path = vim.fn.expand("%:p")
				local name = vim.fn.expand("%:t")
				return string.find(string.lower(path), "/courses/")
					and not string.find(string.lower(name), "notes")
			end

			-- When entering a non-courses buffer, re-enable Copilot.
			-- Also clear the initialized flag so the next visit to a courses buffer
			-- gets a fresh disable.
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					initialized[buf] = nil
					if not in_courses() then
						vim.cmd("Copilot enable")
					end
				end,
			})

			-- On first InsertEnter per buffer visit, disable if in courses.
			-- After that, leave Copilot state alone so manual toggles work.
			vim.api.nvim_create_autocmd("InsertEnter", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					if initialized[buf] then return end
					initialized[buf] = true
					if in_courses() then
						vim.cmd("Copilot disable")
					end
				end,
			})
		end,
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
		},
		opts = {
			provider = "copilot",
		},
	},
}
