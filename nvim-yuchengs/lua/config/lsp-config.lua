-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- Mappings.
    local map = function(mode, l, r, opts)
      opts = opts or {}
      opts.silent = true
      opts.buffer = ev.buf
      vim.keymap.set(mode, l, r, opts)
    end

    map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
    map("n", "<C-]>", vim.lsp.buf.definition)
    map("n", "K", vim.lsp.buf.hover)
    map("n", "<C-k>", vim.lsp.buf.signature_help)
    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
    map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
    map("n", "[d", vim.diagnostic.goto_prev, { desc = "previous diagnostic" })
    map("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
    map("n", "<leader>rd", vim.diagnostic.hide, { desc = "hide diagnostic" })
    map("n", "<leader>sd", vim.diagnostic.show, { desc = "show diagnostic" })
    map("n", "<leader>q", vim.diagnostic.setqflist, { desc = "put diagnostic to qf" })
    map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })

    map("n", "<leader>f", vim.lsp.buf.format, { desc = "format code" })
  end,
})
