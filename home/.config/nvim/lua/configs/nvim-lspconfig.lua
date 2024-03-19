return function()
  local lspconfig = require('lspconfig')

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  lspconfig.pylsp.setup({
    on_attach = function(_, bufnr)
      -- WORKAROUND: for broken gq with python-lsp-server
      -- Clear the formatexpr function call set by python-lsp-server
      vim.api.nvim_buf_set_option(bufnr, 'formatexpr', '')
    end,
    plugins = { pycodestyle = { maxLineLength = 79 } },
    capabilities = capabilities,
  })

  lspconfig.nil_ls.setup({ capabilities = capabilities })

  lspconfig.bashls.setup({ capabilities = capabilities })

  lspconfig.lua_ls.setup({
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = { enable = false },
      },
    },
    capabilities = capabilities,
  })

  vim.diagnostic.config({ virtual_text = false })

  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below
  -- functions
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      -- Enable completion triggered by <C-x><C-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local o = { buffer = ev.buf }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, o)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, o)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, o)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, o)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, o)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, o)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, o)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, o)
      vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, o)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, o)
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, o)
    end,
  })

  if not require('utils').is_legacy_mode() then
    -- Replace default character signs 'E', 'W', 'H', 'I' by glyphs
    local signs = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " "
    }

    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
    end
  end
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
