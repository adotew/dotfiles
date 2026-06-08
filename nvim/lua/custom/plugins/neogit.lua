return {
  'NeogitOrg/neogit',
  lazy = true,
  dependencies = {
    'sindrets/diffview.nvim', -- optional
    'folke/snacks.nvim', -- optional
  },
  cmd = 'Neogit',
  keys = {
    { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
  },
}
