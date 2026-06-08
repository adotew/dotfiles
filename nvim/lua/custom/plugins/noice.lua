return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    keys = {
      { '<leader>nd', '<cmd>NoiceDismiss<cr>', desc = 'Dismiss Noice' },
    },
    opts = {
      cmdline = {
        enabled = false,
        view = 'cmdline',
      },
      messages = { enabled = false },
      popupmenu = {
        enabled = false,
        backend = 'nui',
      },
      notify = { enabled = false },
      lsp = {
        progress = { enabled = false },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
        hover = { enabled = true },
        signature = { enabled = true },
        message = { enabled = false },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = true,
      },
      routes = {},
      views = {
        mini_normal = {
          backend = 'mini',
          position = { row = '50%', col = '50%' },
          size = 'auto',
          timeout = 1000,
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winblend = 0,
            winhighlight = {
              Normal = 'NoiceMiniNormal',
              FloatBorder = 'NoiceMiniNormalBorder',
            },
          },
        },
        mini_insert = {
          backend = 'mini',
          position = { row = '50%', col = '50%' },
          size = 'auto',
          timeout = 1000,
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winblend = 0,
            winhighlight = {
              Normal = 'NoiceMiniInsert',
              FloatBorder = 'NoiceMiniInsertBorder',
            },
          },
        },
        mini_visual = {
          backend = 'mini',
          position = { row = '50%', col = '50%' },
          size = 'auto',
          timeout = 1000,
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winblend = 0,
            winhighlight = {
              Normal = 'NoiceMiniVisual',
              FloatBorder = 'NoiceMiniVisualBorder',
            },
          },
        },
        mini_replace = {
          backend = 'mini',
          position = { row = '50%', col = '50%' },
          size = 'auto',
          timeout = 1000,
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winblend = 0,
            winhighlight = {
              Normal = 'NoiceMiniReplace',
              FloatBorder = 'NoiceMiniReplaceBorder',
            },
          },
        },
        popupmenu = {
          relative = 'editor',
          position = { row = 8, col = '50%' },
          size = { width = 60, height = 10 },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = 'NormalFloat',
              FloatBorder = 'FloatBorder',
            },
          },
        },
      },
    },
  },
}
