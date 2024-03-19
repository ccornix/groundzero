return function()
  local legacy_opts = require('utils').is_legacy_mode() and {
    icons = false,
    fold_open = 'v',
    fold_closed = '>',
    signs = {
      error = 'E',
      warning = 'W',
      hint = 'H',
      information = 'I',
    },
    use_diagnostic_signs = false,
  } or {}
  require('trouble').setup(vim.tbl_deep_extend('keep', legacy_opts, {
    signs = {
      error = "",
      warning = "",
      hint = "",
      info = ""
    }
  }))
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
