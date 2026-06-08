return {
  {
    dir = vim.fn.stdpath 'config',
    name = 'right-status',
    event = 'VeryLazy',
    config = function()
      local state = { buf = nil, win = nil }
      local group = vim.api.nvim_create_augroup('custom-right-status', { clear = true })
      local namespace = vim.api.nvim_create_namespace 'custom-right-status'
      local excluded_filetypes = {
        Trouble = true,
        alpha = true,
        dashboard = true,
        help = true,
        lazy = true,
        mason = true,
        ['neo-tree'] = true,
        notify = true,
        oil = true,
        qf = true,
        toggleterm = true,
      }

      local function filename(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == '' then return '[No Name]' end

        return vim.fs.basename(vim.fs.normalize(path))
      end

      local function diagnostics(bufnr)
        local counts = {
          error = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR }),
          warn = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN }),
          info = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.INFO }),
          hint = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.HINT }),
        }

        local parts = {}
        if counts.error > 0 then table.insert(parts, { 'E:' .. counts.error, 'DiagnosticError' }) end
        if counts.warn > 0 then table.insert(parts, { 'W:' .. counts.warn, 'DiagnosticWarn' }) end
        if counts.info > 0 then table.insert(parts, { 'I:' .. counts.info, 'DiagnosticInfo' }) end
        if counts.hint > 0 then table.insert(parts, { 'H:' .. counts.hint, 'DiagnosticHint' }) end
        return parts
      end

      local function mode_label()
        local mode = vim.api.nvim_get_mode().mode
        local labels = {
          n = 'NORMAL',
          no = 'NORMAL',
          i = 'INSERT',
          ic = 'INSERT',
          ix = 'INSERT',
          v = 'VISUAL',
          V = 'V-LINE',
          ['\22'] = 'V-BLOCK',
          R = 'REPLACE',
          Rc = 'REPLACE',
          Rv = 'V-REPLACE',
          c = 'COMMAND',
          cv = 'COMMAND',
          ce = 'COMMAND',
          r = 'PROMPT',
          rm = 'MORE',
          ['r?'] = 'CONFIRM',
          s = 'SELECT',
          S = 'S-LINE',
          ['\19'] = 'S-BLOCK',
          t = 'TERMINAL',
        }

        return labels[mode] or mode:upper()
      end

      local function mode_highlight()
        local mode = vim.api.nvim_get_mode().mode
        local by_mode = {
          n = 'RightStatusNormal',
          no = 'RightStatusNormal',
          i = 'String',
          ic = 'String',
          ix = 'String',
          v = 'Special',
          V = 'Special',
          ['\22'] = 'Special',
          R = 'Error',
          Rc = 'Error',
          Rv = 'Error',
          c = 'Function',
          cv = 'Function',
          ce = 'Function',
          r = 'Identifier',
          rm = 'Identifier',
          ['r?'] = 'Identifier',
          s = 'Type',
          S = 'Type',
          ['\19'] = 'Type',
          t = 'PreProc',
        }

        return by_mode[mode] or 'RightStatusNormal'
      end

      local function progress()
        local current = vim.fn.line '.'
        local total = vim.fn.line '$'
        if current <= 1 then return 'Top' end
        if current >= total then return 'Bot' end
        return string.format('%d%%', math.floor(current / total * 100))
      end

      local function active_target()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        if not vim.api.nvim_buf_is_valid(buf) then return nil end
        if vim.bo[buf].buftype ~= '' then return nil end
        if excluded_filetypes[vim.bo[buf].filetype] then return nil end
        return win, buf
      end

      local function ensure_buf()
        if state.buf and vim.api.nvim_buf_is_valid(state.buf) then return state.buf end

        state.buf = vim.api.nvim_create_buf(false, true)
        vim.bo[state.buf].bufhidden = 'wipe'
        return state.buf
      end

      local function close()
        if state.win and vim.api.nvim_win_is_valid(state.win) then
          vim.api.nvim_win_close(state.win, true)
        end
        state.win = nil
      end

      local function set_highlights()
        local winbar = vim.api.nvim_get_hl(0, { name = 'WinBar' })
        local function hex(color) return color and string.format('#%06x', color) or nil end

        vim.api.nvim_set_hl(0, 'RightStatusNormal', { fg = hex(winbar.fg), bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'RightStatusMuted', { link = 'Comment' })
      end

      local function pad_left(text, width)
        local padding = math.max(width - vim.fn.strdisplaywidth(text), 0)
        return string.rep(' ', padding) .. text
      end

      local function render()
        local win, buf = active_target()
        if not win then
          close()
          return
        end

        set_highlights()

        local lines = {
          { text = mode_label(), hl = mode_highlight() },
          { text = filename(buf), hl = 'RightStatusMuted' },
        }

        local diag_parts = diagnostics(buf)
        local diag_chunks = {}
        if #diag_parts == 0 then
          diag_chunks = { { 'OK', 'RightStatusMuted' } }
        else
          for index, part in ipairs(diag_parts) do
            if index > 1 then table.insert(diag_chunks, { ' ', 'RightStatusMuted' }) end
            table.insert(diag_chunks, part)
          end
        end

        local meta_lines = { { text = progress(), hl = 'RightStatusMuted' } }

        local width = 0
        for _, line in ipairs(lines) do
          width = math.max(width, vim.fn.strdisplaywidth(line.text))
        end
        do
          local diag_text = ''
          for _, chunk in ipairs(diag_chunks) do
            diag_text = diag_text .. chunk[1]
          end
          width = math.max(width, vim.fn.strdisplaywidth(diag_text))
        end
        for _, line in ipairs(meta_lines) do
          width = math.max(width, vim.fn.strdisplaywidth(line.text))
        end

        width = math.min(math.max(width, 8), math.max(vim.o.columns - 4, 8))
        local diag_text = ''
        for _, chunk in ipairs(diag_chunks) do
          diag_text = diag_text .. chunk[1]
        end

        local all_lines = {
          pad_left(lines[1].text, width),
          pad_left(lines[2].text, width),
          pad_left(diag_text, width),
          pad_left(meta_lines[1].text, width),
        }

        local float_buf = ensure_buf()
        vim.bo[float_buf].modifiable = true
        vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, all_lines)
        vim.bo[float_buf].modifiable = false

        local config = {
          relative = 'editor',
          anchor = 'NE',
          row = 0,
          col = vim.o.columns - 1,
          width = width,
          height = #all_lines,
          focusable = false,
          style = 'minimal',
          noautocmd = true,
          zindex = 45,
        }

        if state.win and vim.api.nvim_win_is_valid(state.win) then
          vim.api.nvim_win_set_config(state.win, config)
        else
          state.win = vim.api.nvim_open_win(float_buf, false, config)
        end

        vim.wo[state.win].winblend = 0
        vim.wo[state.win].wrap = false
        vim.wo[state.win].winhighlight = 'Normal:RightStatusNormal,FloatBorder:FloatBorder'

        vim.api.nvim_buf_clear_namespace(float_buf, namespace, 0, -1)

        for line_index, line in ipairs(lines) do
          local col = math.max(width - vim.fn.strdisplaywidth(line.text), 0)
          vim.api.nvim_buf_add_highlight(float_buf, namespace, line.hl, line_index - 1, col, -1)
        end

        local col = math.max(width - vim.fn.strdisplaywidth(diag_text), 0)
        for _, chunk in ipairs(diag_chunks) do
          local text, hl = chunk[1], chunk[2]
          vim.api.nvim_buf_add_highlight(float_buf, namespace, hl, 2, col, col + #text)
          col = col + #text
        end

        for idx, line in ipairs(meta_lines) do
          local col = math.max(width - vim.fn.strdisplaywidth(line.text), 0)
          vim.api.nvim_buf_add_highlight(float_buf, namespace, line.hl, idx + 2, col, -1)
        end
      end

      local queued = false
      local function schedule_render()
        if queued then return end
        queued = true
        vim.schedule(function()
          queued = false
          pcall(render)
        end)
      end

      vim.api.nvim_create_autocmd({
        'BufEnter',
        'WinEnter',
        'CursorMoved',
        'CursorMovedI',
        'DiagnosticChanged',
        'ModeChanged',
        'BufWritePost',
        'LspAttach',
        'VimResized',
        'ColorScheme',
      }, {
        group = group,
        callback = schedule_render,
      })

      vim.api.nvim_create_autocmd({ 'WinClosed', 'BufLeave', 'InsertLeave', 'InsertEnter' }, {
        group = group,
        callback = schedule_render,
      })

      schedule_render()
    end,
  },
}
