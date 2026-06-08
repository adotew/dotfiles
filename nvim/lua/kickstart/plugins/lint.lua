return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    local debounce_ms = 100
    local timers = {}

    lint.linters_by_ft = {
      markdown = { 'markdownlint' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      javascript = { 'eslint_d' },
      python = { 'ruff' },
    }

    local function stop_timer(bufnr)
      local timer = timers[bufnr]
      if not timer then return end
      timer:stop()
      timer:close()
      timers[bufnr] = nil
    end

    local function available_linters(bufnr)
      local ft_linters = lint.linters_by_ft[vim.bo[bufnr].filetype] or {}
      return vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if type(linter) == 'function' then linter = linter() end
        local cmd = linter and linter.cmd
        return type(cmd) == 'string' and vim.fn.executable(cmd) == 1
      end, ft_linters)
    end

    local function trigger_lint(bufnr)
      stop_timer(bufnr)

      if not vim.api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].modifiable then return end

      local timer = vim.uv.new_timer()
      if not timer then return end

      timers[bufnr] = timer
      timer:start(
        debounce_ms,
        0,
        vim.schedule_wrap(function()
          stop_timer(bufnr)
          if not vim.api.nvim_buf_is_valid(bufnr) or not vim.bo[bufnr].modifiable then return end

          local available = available_linters(bufnr)
          if #available > 0 then lint.try_lint(available, { bufnr = bufnr }) end
        end)
      )
    end

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'TextChangedI' }, {
      group = lint_augroup,
      callback = function(args) trigger_lint(args.buf) end,
    })

    vim.api.nvim_create_autocmd('BufWipeout', {
      group = lint_augroup,
      callback = function(args) stop_timer(args.buf) end,
    })
  end,
}
