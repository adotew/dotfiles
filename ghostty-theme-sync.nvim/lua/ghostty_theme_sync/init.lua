local M = {}

local default_config = {
  auto_sync = true,
  notify = false,
  ghostty_config_file = vim.fn.expand '~/.config/ghostty/config',
  fallback_theme = {
    theme = 'Builtin Dark',
    background = '#1d1f21',
    foreground = '#c5c8c6',
    palette = {
      ['0'] = '#282a2e',
      ['1'] = '#a54242',
      ['2'] = '#8c9440',
      ['3'] = '#de935f',
      ['4'] = '#5f819d',
      ['5'] = '#85678f',
      ['6'] = '#5e8d87',
      ['7'] = '#707880',
      ['8'] = '#373b41',
      ['9'] = '#cc6666',
      ['10'] = '#b5bd68',
      ['11'] = '#f0c674',
      ['12'] = '#81a2be',
      ['13'] = '#b294bb',
      ['14'] = '#8abeb7',
      ['15'] = '#c5c8c6',
    },
  },
}

local config = vim.deepcopy(default_config)

local function notify(message, level)
  if not config.notify then return end

  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.INFO, { title = 'GhosttyThemeSync' })
  end)
end

local function merge_with_defaults(theme)
  return vim.tbl_deep_extend('force', vim.deepcopy(config.fallback_theme), theme or {})
end

local function read_ghostty_config()
  local output = vim.fn.systemlist { 'ghostty', '+show-config' }
  if vim.v.shell_error ~= 0 then
    return nil, ('Failed to read Ghostty config from %s'):format(config.ghostty_config_file)
  end

  local theme = { palette = {} }
  for _, line in ipairs(output) do
    local key, value = line:match '^([%w%-]+)%s*=%s*(.+)$'
    if key and value then
      if key == 'theme' then
        theme.theme = value
      elseif key == 'background' then
        theme.background = value
      elseif key == 'foreground' then
        theme.foreground = value
      elseif key == 'palette' then
        local index, color = value:match '^(%d+)%s*=%s*(#%x%x%x%x%x%x)$'
        if index and color and tonumber(index) <= 15 then theme.palette[index] = color end
      end
    end
  end

  if type(theme.theme) ~= 'string' or theme.theme == '' then
    return nil, ('Ghostty config does not expose a theme in %s'):format(config.ghostty_config_file)
  end

  return theme
end

local function apply_theme(theme)
  local palette = theme.palette or {}
  local p = function(index, fallback) return palette[tostring(index)] or fallback end

  vim.api.nvim_exec_autocmds('ColorSchemePre', { modeline = false })
  vim.cmd 'highlight clear'
  if vim.fn.exists 'syntax_on' == 1 then vim.cmd 'syntax reset' end
  vim.o.termguicolors = true
  vim.o.background = 'dark'
  vim.g.colors_name = 'ghostty-sync'

  local highlights = {
    Normal = { fg = theme.foreground, bg = theme.background },
    NormalNC = { fg = theme.foreground, bg = theme.background },
    NormalFloat = { fg = theme.foreground, bg = theme.background },
    FloatBorder = { fg = p(8, theme.foreground), bg = theme.background },
    SignColumn = { bg = theme.background },
    CursorLine = { bg = p(0, theme.background) },
    CursorLineNr = { fg = p(3, theme.foreground), bold = true },
    LineNr = { fg = p(8, theme.foreground) },
    Comment = { fg = p(8, theme.foreground), italic = true },
    Constant = { fg = p(9, theme.foreground) },
    String = { fg = p(2, theme.foreground) },
    Character = { fg = p(2, theme.foreground) },
    Number = { fg = p(9, theme.foreground) },
    Boolean = { fg = p(9, theme.foreground) },
    Float = { fg = p(9, theme.foreground) },
    Identifier = { fg = p(5, theme.foreground) },
    Function = { fg = p(4, theme.foreground) },
    Statement = { fg = p(5, theme.foreground) },
    Conditional = { fg = p(5, theme.foreground) },
    Repeat = { fg = p(5, theme.foreground) },
    Operator = { fg = p(6, theme.foreground) },
    Keyword = { fg = p(5, theme.foreground) },
    Exception = { fg = p(1, theme.foreground) },
    PreProc = { fg = p(3, theme.foreground) },
    Include = { fg = p(5, theme.foreground) },
    Define = { fg = p(5, theme.foreground) },
    Macro = { fg = p(5, theme.foreground) },
    Type = { fg = p(3, theme.foreground) },
    Special = { fg = p(6, theme.foreground) },
    Delimiter = { fg = p(7, theme.foreground) },
    Underlined = { fg = p(4, theme.foreground), underline = true },
    Todo = { fg = theme.background, bg = p(3, theme.foreground), bold = true },
    Error = { fg = p(1, theme.foreground), bg = theme.background, bold = true },
    WarningMsg = { fg = p(3, theme.foreground) },
    DiagnosticError = { fg = p(1, theme.foreground) },
    DiagnosticWarn = { fg = p(3, theme.foreground) },
    DiagnosticInfo = { fg = p(4, theme.foreground) },
    DiagnosticHint = { fg = p(6, theme.foreground) },
    Pmenu = { fg = theme.foreground, bg = theme.background },
    PmenuSel = { fg = theme.background, bg = p(4, theme.foreground) },
    Visual = { bg = p(8, theme.background) },
    Search = { fg = theme.background, bg = p(3, theme.foreground) },
    IncSearch = { fg = theme.background, bg = p(9, theme.foreground) },
    StatusLine = { fg = theme.foreground, bg = theme.background },
    StatusLineNC = { fg = p(8, theme.foreground), bg = theme.background },
    WinBar = { bg = 'NONE' },
    WinBarNC = { bg = 'NONE' },
    NotifyBackground = { bg = theme.background },
    NoiceMiniNormal = { fg = p(4, theme.foreground), bold = true },
    NoiceMiniInsert = { fg = p(2, theme.foreground), bold = true },
    NoiceMiniVisual = { fg = p(5, theme.foreground), bold = true },
    NoiceMiniReplace = { fg = p(3, theme.foreground), bold = true },
    NoiceMiniNormalBorder = { fg = p(4, theme.foreground) },
    NoiceMiniInsertBorder = { fg = p(2, theme.foreground) },
    NoiceMiniVisualBorder = { fg = p(5, theme.foreground) },
    NoiceMiniReplaceBorder = { fg = p(3, theme.foreground) },
  }

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  local links = {
    WhichKey = 'Function',
    WhichKeyBorder = 'FloatBorder',
    WhichKeyDesc = 'Identifier',
    WhichKeyGroup = 'Keyword',
    WhichKeyIcon = '@markup.link',
    WhichKeyNormal = 'NormalFloat',
    WhichKeySeparator = 'Comment',
    WhichKeyTitle = 'FloatTitle',
    WhichKeyValue = 'Comment',
  }

  for group, target in pairs(links) do
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  vim.api.nvim_exec_autocmds('ColorScheme', {
    group = nil,
    modeline = false,
    pattern = 'ghostty-sync',
  })
end

function M.load_theme(opts)
  opts = opts or {}

  local theme, err = read_ghostty_config()
  if theme then return theme end
  if opts.allow_fallback then return vim.deepcopy(config.fallback_theme) end

  return nil, err
end

function M.apply(opts)
  opts = opts or {}

  local theme, err = M.load_theme { allow_fallback = opts.allow_fallback }
  if not theme then
    notify(err, vim.log.levels.ERROR)
    return false, err
  end

  theme = merge_with_defaults(theme)
  apply_theme(theme)

  if not opts.silent then notify(('Applied Ghostty theme: %s'):format(theme.theme), vim.log.levels.INFO) end

  return true
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', vim.deepcopy(default_config), opts or {})

  if vim.fn.exists ':ThemeSync' ~= 2 then
    vim.api.nvim_create_user_command('ThemeSync', function()
      M.apply()
    end, { desc = 'Reload Ghostty theme and reapply Neovim colors' })
  end

  local group = vim.api.nvim_create_augroup('ghostty-theme-sync', { clear = true })

  if config.auto_sync then
    M.apply { silent = true, allow_fallback = true }

    vim.api.nvim_create_autocmd('VimEnter', {
      group = group,
      callback = function()
        M.apply { silent = true, allow_fallback = true }
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = group,
      pattern = 'VeryLazy',
      callback = function()
        M.apply { silent = true, allow_fallback = true }
      end,
    })

    vim.api.nvim_create_autocmd('FocusGained', {
      group = group,
      callback = function()
        M.apply { silent = true, allow_fallback = true }
      end,
    })
  end
end

return M
