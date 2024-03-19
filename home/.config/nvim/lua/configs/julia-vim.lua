return function()
  -- Fix annoying auto-indentation behavior
  vim.g.julia_indent_align_brackets = 0
  vim.g.julia_indent_align_funcargs = 0
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
