return {
  'stevearc/oil.nvim',
  keys = {
    { '<leader>o', '<cmd>Oil<CR>', desc = '[O]pen [O]il' },
    {
      '<leader>oh',
      function() require('oil').toggle_hidden() end,
      desc = 'Toggle [O]il [H]idden files',
    },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
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
