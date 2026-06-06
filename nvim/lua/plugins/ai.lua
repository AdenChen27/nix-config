return {
	{
		"zbirenbaum/copilot.lua",
		lazy = false,
		config = function()
			local function in_courses(bufname)
				local path = string.lower(bufname)
				local name = string.lower(vim.fs.basename(bufname))
				return string.find(path, "/courses/", 1, true) and not string.find(name, "notes", 1, true)
			end

			require("copilot").setup({
				suggestion = { enabled = true, auto_trigger = true, hide_during_completion = false, keymap = { accept = "<C-j>" } },
				panel = { enabled = false },
				filetypes = { ["*"] = true },
				should_attach = function(bufnr, bufname)
					if not vim.bo[bufnr].buflisted then
						return false
					end

					if vim.bo[bufnr].buftype ~= "" then
						return false
					end

					return not in_courses(bufname)
				end,
			})

			vim.api.nvim_create_user_command("CopilotEnable", function()
				vim.cmd("Copilot! attach")
			end, {})
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
