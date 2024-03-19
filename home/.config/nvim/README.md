# ccornix's Neovim configuration

## Environment variables

- `MY_NVIM_LEGACY_MODE`

  If set to `y`, true color mode, custom color scheme, and special
  symbols/icons are disabled.

- `MY_NVIM_BASE16_COLORSCHEME`

  If set, then the appropriate base16 color scheme is used. Dark and light
  mode is autodetected from the `base00` color.

## Dependencies

A list of available mason packages is available at:
https://mason-registry.dev/registry/list

Dependencies of mason itself:
- `git`
- `curl` or `wget`
- `tar`
- `gzip`
- `unzip`

TODO: External dependencies not handled by mason:
- `ripgrep`


## References

- https://martinlwx.github.io/en/config-neovim-from-scratch
- https://github.com/VonHeikemen/lsp-zero.nvim
