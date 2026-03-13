return {
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true, auto_trigger = true, hide_during_completion = false, keymap = { accept = "<C-j>" } },
				panel = { enabled = false },
				filetypes = { ["*"] = true },
			})

			local function in_courses()
				local path = vim.fn.expand("%:p")
				local name = vim.fn.expand("%:t")
				return string.find(string.lower(path), "/courses/")
					and not string.find(string.lower(name), "notes")
			end

			local initialized = {}

			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local buf = vim.api.nvim_get_current_buf()
					if in_courses() then
						-- Only disable on first visit; manual :Copilot enable persists until restart
						if not initialized[buf] then
							initialized[buf] = true
							vim.cmd("Copilot disable")
						end
					else
						initialized[buf] = nil
						vim.cmd("Copilot enable")
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
