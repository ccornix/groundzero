return function()
  require('nvim-treesitter.configs').setup({
    -- ensure_installed = 'all',
    -- sync_install = false,
    -- auto_install = true,
    -- ignore_install = {},
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  })
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
