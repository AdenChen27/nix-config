-- ~/.config/nvim/lua/lsp/on_attach.lua
local M = {}

M.on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "<leader>dl", vim.diagnostic.setloclist, "Buffer Diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

return M

