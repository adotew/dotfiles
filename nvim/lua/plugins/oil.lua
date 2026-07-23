return {
  'stevearc/oil.nvim',
  keys = {
    { '<leader>o', '<cmd>Oil<CR>', desc = '[O]pen [O]il' },
  },
  opts = {
    default_file_explorer = true,
    confirmation = {
      border = 'rounded',
    },
  },
  dependencies = {
    {
      'nvim-mini/mini.icons',
      opts = {},
      config = function(_, opts)
        require('mini.icons').setup(opts)
        MiniIcons.mock_nvim_web_devicons()
      end,
    },
  },
  lazy = false,
}
