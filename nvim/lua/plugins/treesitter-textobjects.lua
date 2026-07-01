return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'Around Function' },
            ['if'] = { query = '@function.inner', desc = 'Inside Function' },
            ['ac'] = { query = '@class.outer', desc = 'Around Class' },
            ['ic'] = { query = '@class.inner', desc = 'Inside Class' },
            ['aa'] = { query = '@parameter.outer', desc = 'Around Argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'Inside Argument' },
          },
        },
        move = {
          set_jumps = true,
          goto_next_start = {
            [']m'] = { query = '@function.outer', desc = 'Next Function Start' },
            [']]'] = { query = '@class.outer', desc = 'Next Class Start' },
          },
          goto_next_end = {
            [']M'] = { query = '@function.outer', desc = 'Next Function End' },
            [']['] = { query = '@class.outer', desc = 'Next Class End' },
          },
          goto_previous_start = {
            ['[m'] = { query = '@function.outer', desc = 'Previous Function Start' },
            ['[['] = { query = '@class.outer', desc = 'Previous Class Start' },
          },
          goto_previous_end = {
            ['[M'] = { query = '@function.outer', desc = 'Previous Function End' },
            ['[]'] = { query = '@class.outer', desc = 'Previous Class End' },
          },
        },
        swap = {
          swap_next = {
            ['<leader>pa'] = { query = '@parameter.inner', desc = '[P]arameter Swap Next' },
          },
          swap_previous = {
            ['<leader>pA'] = { query = '@parameter.inner', desc = '[P]arameter Swap Previous' },
          },
        },
      }
    end,
  },
}
