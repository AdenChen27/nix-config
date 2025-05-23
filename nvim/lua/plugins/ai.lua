return {
	-- {
	--   "robitx/gp.nvim",
	--   lazy = false,
	--   config = function()
	--     require("gp").setup({
	--       openai_api_key = os.getenv("OPENAI_API_KEY"),
	--       agents = {
	--         {
	--           name = "ChatGPT-4",
	--           chat = true,
	--           command = false,
	--           model = "gpt-4",
	--           system_prompt = "You are a helpful assistant.",
	--         },
	--         {
	--           name = "CodeGPT",
	--           chat = false,
	--           command = true,
	--           model = "gpt-4",
	--           system_prompt = "You are a code assistant.",
	--         },
	--       },
	--     })
	--   end,
	-- },
	{
		"github/copilot.vim",
		lazy = false,
		config = function()
			-- Disable Copilot's default <Tab> mapping
			vim.g.copilot_no_tab_map = true

			-- Use <C-J> to accept Copilot suggestions
			vim.cmd([[
          imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
        ]])

			-- Disable Copilot when path contains "courses" (case-insensitive)
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*",
				callback = function()
					local buf_path = vim.fn.expand("%:p")
					if string.find(string.lower(buf_path), "/courses/") then
						vim.cmd("Copilot disable")
					else
						vim.cmd("Copilot enable")
					end
				end,
			})
		end,
	},
}


