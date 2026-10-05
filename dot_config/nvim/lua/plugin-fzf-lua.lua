return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    dependencies = { 'nvim-mini/mini.icons' },
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        group = vim.api.nvim_create_augroup('fzf-lua-startup', { clear = true }),
        once = true,
        callback = function()
          if vim.fn.argc() ~= 0 then return end
          local picker = vim.env.NVIM_FZF or 'files'
          if picker == '' or picker == 'none' then return end
          local fzf = require 'fzf-lua'
          if type(fzf[picker]) ~= 'function' then return end
          fzf[picker]()
        end,
      })
    end,
    keys = function()
      local fzf = function(name, opts)
        return function() require('fzf-lua')[name](opts or {}) end
      end

      return {
        { '<leader>sh', fzf 'helptags', desc = '[S]earch [H]elp' },
        { '<leader>sk', fzf 'keymaps', desc = '[S]earch [K]eymaps' },
        { '<leader>f', fzf 'files', desc = '[F]ind [F]iles' },
        { '<leader>ss', fzf 'builtin', desc = '[S]earch [S]elect Picker' },
        { '<leader>sw', fzf 'grep_cword', desc = '[S]earch Current [W]ord' },
        { '<leader>sw', fzf 'grep_visual', mode = 'v', desc = '[S]earch Selection' },
        { '<leader>sg', fzf 'live_grep', desc = '[S]earch [G]rep' },
        { '<leader>sd', fzf 'diagnostics_workspace', desc = '[S]earch [D]iagnostics' },
        { '<leader>sr', fzf 'resume', desc = '[S]earch [R]esume' },
        { '<leader>s.', fzf 'oldfiles', desc = '[S]earch Old Files' },
        { '<leader>sc', fzf 'commands', desc = '[S]earch [C]ommands' },
        { '<leader><leader>', fzf 'buffers', desc = '[F]ind Buffers' },
        { '<leader>/', fzf 'live_grep', desc = '[S]earch [G]rep' },
        {
          '<leader>s/',
          function() require('fzf-lua').live_grep { cwd = vim.fn.getcwd(), prompt = 'Open buffers> ' } end,
          desc = '[S]earch Project Grep',
        },
        {
          '<leader>sn',
          function() require('fzf-lua').files { cwd = vim.fn.stdpath 'config' } end,
          desc = '[S]earch [N]eovim Files',
        },
      }
    end,
    opts = {
      winopts = {
        border = 'rounded',
        preview = { border = 'rounded' },
      },
      files = {
        hidden = true,
        rg_opts = '--color=never --files --hidden --follow --glob=!.git/*',
      },
      grep = {
        rg_opts = '--column --line-number --no-heading --color=always --smart-case --hidden --glob=!.git/*',
      },
    },
    config = function(_, opts)
      local fzf = require 'fzf-lua'
      fzf.setup(opts)
      fzf.register_ui_select()

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('fzf-lua-lsp-attach', { clear = true }),
        callback = function(event)
          local buf = event.buf
          vim.keymap.set('n', 'grr', fzf.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
          vim.keymap.set('n', 'gri', fzf.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
          vim.keymap.set('n', 'grd', fzf.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
          vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { buffer = buf, desc = '[O]pen Document Symbols' })
          vim.keymap.set('n', 'gW', fzf.lsp_workspace_symbols, { buffer = buf, desc = '[O]pen Workspace Symbols' })
          vim.keymap.set('n', 'grt', fzf.lsp_typedefs, { buffer = buf, desc = '[G]oto [T]ype Definition' })
        end,
      })
    end,
  },
}
