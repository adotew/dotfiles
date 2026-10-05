return {
  'stevearc/aerial.nvim',
  opts = {},
  keys = {
    { '<leader>sO', '<cmd>AerialToggle<CR>', desc = '[S]ymbols [O]utline' },
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
