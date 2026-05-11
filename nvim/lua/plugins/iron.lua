-- ~/.config/nvim/lua/plugins/iron.lua
return {
  {
    "Vigemus/iron.nvim",
    cmd = { "IronRepl", "IronFocus", "IronRestart", "IronHide" },
    ft = { "python", "julia" },
    keys = {
      { "<leader>rr", desc = "Iron: toggle REPL" },
      { "<leader>sc", desc = "Iron: send motion", mode = { "n", "x" } },
      { "<leader>sl", desc = "Iron: send line" },
      { "<leader>sf", desc = "Iron: send file" },
      { "<leader>sp", desc = "Iron: send paragraph" },
    },
    config = function()
      local iron = require("iron.core")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = function()
                return vim.fn.executable("ipython") == 1
                    and { "ipython", "--no-autoindent" }
                  or { "python3" }
              end,
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
            julia = {
              command = { "julia" },
            },
          },
          repl_open_cmd = "vertical botright 80 split",
        },
        keymaps = {
          toggle_repl = "<leader>rr",
          restart_repl = "<leader>rR",
          send_motion = "<leader>sc",
          visual_send = "<leader>sc",
          send_file = "<leader>sf",
          send_line = "<leader>sl",
          send_paragraph = "<leader>sp",
          send_code_block = "<leader>sb",
          send_code_block_and_move = "<leader>sn",
          send_until_cursor = "<leader>su",
          send_mark = "<leader>sm",
          mark_motion = "<leader>mc",
          mark_visual = "<leader>mc",
          remove_mark = "<leader>md",
          cr = "<leader>s<cr>",
          interrupt = "<leader>s<space>",
          exit = "<leader>sq",
          clear = "<leader>cl",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Iron: focus REPL" })
      vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Iron: hide REPL" })
    end,
  },
}
