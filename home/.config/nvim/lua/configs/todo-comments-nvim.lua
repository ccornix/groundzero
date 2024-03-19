return function()
  require('todo-comments').setup({
    signs = not require('utils').is_legacy_mode(),
    highlight = { keyword = 'bg', after = '' },
  })
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
