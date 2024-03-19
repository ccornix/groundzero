return function()
  local legacy_opts = require('utils').is_legacy_mode() and {
    options = {
      icons_enabled = false,
      section_separators = '',
      component_separators = '',
    }
  } or {}
  require('lualine').setup(vim.tbl_deep_extend('keep', legacy_opts, {
    -- Add options here
  }))
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
