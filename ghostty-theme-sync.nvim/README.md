# ghostty-theme-sync.nvim

Sync Neovim's colors with Ghostty's active theme.

This plugin uses `ghostty +show-config` as the source of truth and builds a
Neovim colorscheme from Ghostty's resolved `background`, `foreground`, and base
palette entries.

## Requirements

- Neovim 0.10+
- Ghostty available on `$PATH`

## Installation

### lazy.nvim

```lua
{
  dir = vim.fn.stdpath("config") .. "/../ghostty-theme-sync.nvim",
  name = "ghostty-theme-sync.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("ghostty_theme_sync").setup()
  end,
}
```

## Usage

```lua
require("ghostty_theme_sync").setup({
  auto_sync = true,
  notify = false,
})
```

### Commands

- `:ThemeSync` re-reads Ghostty's resolved config and reapplies the Neovim
  colors.

## Options

```lua
require("ghostty_theme_sync").setup({
  auto_sync = true,
  notify = false,
})
```

## Notes

- This plugin is Ghostty-only.
- Ghostty remains the source of truth. Change the theme in Ghostty, then run
  `:ThemeSync` or refocus Neovim after saving your Ghostty config.
