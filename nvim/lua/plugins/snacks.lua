return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      {
        '<leader>gg',
        function() Snacks.terminal('lazygit', { cwd = Snacks.git.get_root() }) end,
        desc = '[G]it lazy[G]it',
      },
    },
    opts = {
      dashboard = { enabled = false },
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
    },
  },
}
