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

      map('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[G]it [S]tage Hunk' })
      map('v', '<leader>gr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = '[G]it [R]eset Hunk' })
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[G]it [S]tage Hunk' })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[G]it [R]eset Hunk' })
      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[G]it [S]tage Buffer' })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[G]it [R]eset Buffer' })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it [P]review Hunk' })
      map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = '[G]it Preview [I]nline' })
      map('n', '<leader>gb', function() gitsigns.blame_line { full = true } end, { desc = '[G]it [B]lame Line' })
      map('n', '<leader>gd', gitsigns.diffthis, { desc = '[G]it [D]iff Index' })
      map('n', '<leader>gD', function() gitsigns.diffthis '@' end, { desc = '[G]it [D]iff Last Commit' })
      map('n', '<leader>gQ', function() gitsigns.setqflist 'all' end, { desc = '[G]it All Hunks to Quickfix' })
      map('n', '<leader>gq', gitsigns.setqflist, { desc = '[G]it Hunks to Quickfix' })
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle Git [B]lame Line' })
      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle Git [W]ord Diff' })
      map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Inside Git [H]unk' })
    end,
  },
}
