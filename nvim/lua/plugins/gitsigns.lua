return {
  'lewis6991/gitsigns.nvim',
  init = function()
    local group = vim.api.nvim_create_augroup('config-gitsigns-blame-highlight', { clear = true })
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = group,
      callback = function()
        vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { link = 'Comment' })
      end,
    })
    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { link = 'Comment' })
  end,
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = true,
    current_line_blame_opts = { delay = 0 },
    current_line_blame_formatter = '  <author>, <author_time:%R> - <summary>  ',
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Next Git [C]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Previous Git [C]hange' })

      map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[H]unk [S]tage' })
      map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[H]unk [R]eset' })
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = '[H]unk [S]tage' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = '[H]unk [R]eset' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = '[H]unk [S]tage Buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = '[H]unk [R]eset Buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = '[H]unk [P]review' })
      map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = '[H]unk Preview [I]nline' })
      map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = '[H]unk [B]lame Line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = '[H]unk [D]iff Index' })
      map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = '[H]unk [D]iff Last Commit' })
      map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end, { desc = '[H]unk All to Quickfix' })
      map('n', '<leader>hq', gitsigns.setqflist, { desc = '[H]unk to Quickfix' })
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle Git [B]lame Line' })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle Git [W]ord Diff' })
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Inside Git [H]unk' })
    end,
  },
}
