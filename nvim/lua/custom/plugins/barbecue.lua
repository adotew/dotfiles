return {
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    enabled = false,
    event = 'LspAttach',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {},
  },
}
