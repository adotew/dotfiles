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
            ['af'] = { query = '@function.outer', desc = 'Around function' },
            ['if'] = { query = '@function.inner', desc = 'Inside function' },
            ['ac'] = { query = '@class.outer', desc = 'Around class' },
            ['ic'] = { query = '@class.inner', desc = 'Inside class' },
            ['aa'] = { query = '@parameter.outer', desc = 'Around argument' },
            ['ia'] = { query = '@parameter.inner', desc = 'Inside argument' },
          },
        },
        move = {
          set_jumps = true,
          goto_next_start = {
            [']m'] = { query = '@function.outer', desc = 'Next function start' },
            [']]'] = { query = '@class.outer', desc = 'Next class start' },
          },
          goto_next_end = {
            [']M'] = { query = '@function.outer', desc = 'Next function end' },
            [']['] = { query = '@class.outer', desc = 'Next class end' },
          },
          goto_previous_start = {
            ['[m'] = { query = '@function.outer', desc = 'Previous function start' },
            ['[['] = { query = '@class.outer', desc = 'Previous class start' },
          },
          goto_previous_end = {
            ['[M'] = { query = '@function.outer', desc = 'Previous function end' },
            ['[]'] = { query = '@class.outer', desc = 'Previous class end' },
          },
        },
        swap = {
          swap_next = {
            ['<leader>pa'] = { query = '@parameter.inner', desc = 'Swap with next parameter' },
          },
          swap_previous = {
            ['<leader>pA'] = { query = '@parameter.inner', desc = 'Swap with previous parameter' },
          },
        },
      }
    end,
  },
}
