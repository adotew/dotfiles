return {
  'stevearc/oil.nvim',
  keys = {
    { '<leader>o', '<cmd>Oil<CR>', desc = '[O]pen [O]il' },
  },
  opts = {
    confirmation = {
      border = 'rounded',
    },
  },
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  lazy = false,
}
