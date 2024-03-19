local M = {}

function M.base16_colorscheme_name()
  return vim.env.MY_BASE16_COLORSCHEME or 'decaf'
end

function M.is_legacy_mode()
  return vim.env.MY_NVIM_LEGACY_MODE == 'y' or vim.env.TERM == 'linux'
end

return M
