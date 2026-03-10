-- ~/.config/nvim/lua/lsp/on_attach.lua
local M = {}

M.on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  -- LSP navigation
  map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
  map("n", "gr", vim.lsp.buf.references, "Show References")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")

  -- LSP actions
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  
  -- Diagnostics
  map("n", "<leader>d", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "<leader>dl", vim.diagnostic.setloclist, "Buffer Diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
end

return M

