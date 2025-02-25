return function()
  if not require('utils').is_legacy_mode() then
    vim.cmd.colorscheme('gruvbox')
    vim.opt.background = 'dark'
  end
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
