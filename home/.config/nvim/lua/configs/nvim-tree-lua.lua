return function()
  local legacy_opts = require('utils').is_legacy_mode() and {
    renderer = {
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
        }
      }
    },
    view = { float = { open_win_config = { border = 'single' } } }
  } or {}
  require('nvim-tree').setup(vim.tbl_deep_extend('keep', legacy_opts, {
    view = { float = {
      enable = true,
      open_win_config = { border = 'rounded' }
    }}
  }))
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
