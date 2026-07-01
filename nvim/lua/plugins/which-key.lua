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
      { '<leader>f', desc = '[F]ind [F]iles' },
      { '<leader>/', desc = '[S]earch [G]rep' },
      { '<leader>o', desc = '[O]pen [O]il', icon = { icon = '󰙅 ', color = 'blue' } },
      { '<leader>g', group = '[G]it', icon = { icon = ' ', color = 'red' } },
      { '<leader>t', group = '[T]oggle', icon = { icon = ' ', color = 'yellow' } },
      { '<leader>h', group = '[H]unk', mode = { 'n', 'v' } },
      { '<leader>x', group = '[X] Diagnostics', icon = { icon = '󱖫 ', color = 'red' } },
      { '<leader>p', group = '[P]arameter' },
      { '<leader><leader>', desc = '[F]ind Buffers', hidden = true },
      { '<leader>F', desc = '[F]ormat Buffer', hidden = true },
      { '<leader>dd', desc = '[D]ashboard', hidden = true },
      { 'gr', group = '[L]SP Actions', mode = { 'n' } },
    },
  },
}
