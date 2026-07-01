return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      messages = { enabled = false },
      notify = { enabled = false },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = false,
        inc_rename = false,
        lsp_doc_border = false,
      },
      views = {
        cmdline_popup = {
          position = { row = '50%', col = '50%' },
          size = {
            min_width = 60,
            width = 'auto',
            height = 'auto',
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
        },
        cmdline_popupmenu = {
          relative = 'editor',
          position = { row = '58%', col = '50%' },
          size = {
            width = 60,
            height = 'auto',
            max_height = 15,
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
        },
      },
    },
  },
}
