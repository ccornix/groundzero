return function()
  local is_legacy_mode = require('utils').is_legacy_mode()

  local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local str = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
    return col ~= 0 and str:sub(col, col):match("%s") == nil
  end

  local luasnip = require('luasnip')
  local cmp = require('cmp')
  local lspkind = require('lspkind')

  local open_win_config = cmp.config.window.bordered()
  open_win_config.border = is_legacy_mode and 'single' or 'rounded'

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      -- Use <C-b/f> to scroll the docs
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      -- Use <C-k/j> to switch in items
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      -- Use <CR>(Enter) to confirm selection
      -- Accept currently selected item. Set `select` to `false` to only
      -- confirm explicitly selected items.
      ["<CR>"] = cmp.mapping.confirm({ select = false }),

      -- A super tab
      --
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
      ["<Tab>"] = cmp.mapping(function(fallback)
        -- Hint: if the completion menu is visible select next one
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }), -- i - insert mode; s - select mode
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    -- Appearance
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    formatting = {
      -- Customize the appearance of the completion menu
      format = lspkind.cmp_format({
        mode = is_legacy_mode and "text" or "symbol_text",
        -- Prevent the popup from showing more than provided characters
        maxwidth = 50,
        -- When popup menu exceed maxwidth, the truncated part would show
        -- ellipsis_char instead (must define maxwidth first)
        ellipsis_char = "...",

        -- The function below will be called before any actual modifications
        -- from lspkind so that you can provide more controls on popup
        -- customization. (See
        -- [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          vim_item.menu = ({
            nvim_lsp = "[Lsp]",
            luasnip = "[Luasnip]",
            buffer = "[File]",
            path = "[Path]",
          })[entry.source.name]
          return vim_item
        end,
      }),
    },
    window = {
      completion = open_win_config,
      documentation = open_win_config,
    },
    -- Set source precedence
    sources = cmp.config.sources({
      { name = "nvim_lsp" }, -- For nvim-lsp
      { name = "luasnip" }, -- For luasnip user
      { name = "buffer" }, -- For buffer word completion
      { name = "path" }, -- For path completion
    }),
  })
end

-- vim: ts=2:sw=2:et:fen:fdm=marker
