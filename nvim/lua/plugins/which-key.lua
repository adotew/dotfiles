return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  init = function()
    local function set_which_key_background()
      local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
      local bg = normal.bg and string.format('#%06x', normal.bg) or 'NONE'
      vim.api.nvim_set_hl(0, 'WhichKeyNormal', { bg = bg })
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('custom-which-key-background', { clear = true }),
      callback = set_which_key_background,
    })
    set_which_key_background()
  end,
  opts = {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    win = {
      width = 35,
      col = -1,
      row = -1,
    },
    sort = { 'manual' },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' }, icon = { icon = ' ', color = 'green' } },
      { '<leader>f', desc = 'Find [F]iles' },
      { '<leader>/', desc = '[/] Search by Grep' },
      { '<leader>o', desc = 'Open [O]il', icon = { icon = '󰙅 ', color = 'blue' } },
      { '<leader>g', group = '[G]it', icon = { icon = ' ', color = 'red' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>m', group = 'Harpoon', icon = { icon = '󰛢 ', color = 'cyan' } },
      { '<leader>x', group = 'Diagnostics', icon = { icon = '󱖫 ', color = 'red' } },
      { '<leader>q', group = 'Session', icon = { icon = ' ', color = 'grey' } },
      { '<leader>w', group = '[W]indow' },
      { '<leader>a', group = '[A]I' },
      { '<leader>n', group = '[N]oice' },
      { '<leader>p', group = '[P]arameter' },
      { '<leader><leader>', hidden = true },
      { '<leader>F', hidden = true },
      { '<leader>dd', hidden = true },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  },
}
