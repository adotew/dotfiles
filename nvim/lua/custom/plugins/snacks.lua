return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      { '<leader>dd', function() Snacks.dashboard() end, desc = 'Dashboard' },
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'LazyGit' }
    },
    opts = function()
      return {
        lazygit = {},
        scroll = {
          enabled = true,
        },
        image = {
          enabled = true,
          formats = {
            'png',
            'jpg',
            'jpeg',
            'gif',
            'bmp',
            'webp',
            'tiff',
            'heic',
            'avif',
            'mp4',
            'mov',
            'avi',
            'mkv',
            'webm',
            'pdf',
            'icns',
            'svg',
          },
          convert = {
            notify = true,
          },
        },
        dashboard = {
          pane_gap = 12,
          sections = {
            { section = 'keys', gap = 1, padding = 1 },
            { section = 'startup' },
          },
        },
      }
    end,
    config = function(_, opts)
      require('snacks').setup(opts)
    end,
  },
}
