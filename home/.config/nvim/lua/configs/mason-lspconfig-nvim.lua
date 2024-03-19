return function()
  require('mason-lspconfig').setup({
    ensure_installed = {
      'pylsp',
      'nil_ls',
      'bashls',
      'lua_ls',
    },
  })
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
