return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'VeryLazy',
    init = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { 'lsp', 'indent' }
      end,
    },
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end, desc = 'Open all folds' },
      { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
      { 'zr', function() require('ufo').openFoldsExceptKinds() end, desc = 'Open folds except kinds' },
      { 'zm', function() require('ufo').closeFoldsWith(1) end, desc = 'Close folds with' },
      { 'zK', function() require('ufo').peekFoldedLinesUnderCursor() end, desc = 'Peek fold' },
    },
  },
}
