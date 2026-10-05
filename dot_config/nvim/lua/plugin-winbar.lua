return {
  {
    dir = vim.fn.stdpath 'config',
    name = 'winbar',
    event = 'VeryLazy',
    config = function()
      local group = vim.api.nvim_create_augroup('custom-winbar', { clear = true })
      local excluded_filetypes = {
        Trouble = true,
        alpha = true,
        help = true,
        lazy = true,
        mason = true,
        ['neo-tree'] = true,
        notify = true,
        oil = true,
        qf = true,
        toggleterm = true,
      }

      local mode_labels = {
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

      local mode_highlights = {
        n = 'WinbarModeNormal',
        no = 'WinbarModeNormal',
        i = 'WinbarModeInsert',
        ic = 'WinbarModeInsert',
        ix = 'WinbarModeInsert',
        v = 'WinbarModeVisual',
        V = 'WinbarModeVisual',
        ['\22'] = 'WinbarModeVisual',
        R = 'WinbarModeReplace',
        Rc = 'WinbarModeReplace',
        Rv = 'WinbarModeReplace',
        c = 'WinbarModeCommand',
        cv = 'WinbarModeCommand',
        ce = 'WinbarModeCommand',
        r = 'WinbarModeCommand',
        rm = 'WinbarModeCommand',
        ['r?'] = 'WinbarModeCommand',
        s = 'WinbarModeVisual',
        S = 'WinbarModeVisual',
        ['\19'] = 'WinbarModeVisual',
        t = 'WinbarModeTerminal',
      }

      local function set_highlights()
        local function hex(hl_name, attr)
          local h = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
          return h[attr] and string.format('#%06x', h[attr]) or nil
        end

        local fg = hex('WinBar', 'fg') or hex('Normal', 'fg')
        local ink = hex('Normal', 'bg') or '#1a1b26'

        vim.api.nvim_set_hl(0, 'WinbarMuted', { link = 'Comment' })
        vim.api.nvim_set_hl(0, 'WinBar', { fg = fg, bg = 'NONE' })
        vim.api.nvim_set_hl(0, 'WinBarNC', { fg = hex('Comment', 'fg'), bg = 'NONE' })

        local function mode_hl(name, accent)
          vim.api.nvim_set_hl(0, name, { fg = ink, bg = hex(accent, 'fg') or fg, bold = true })
        end
        mode_hl('WinbarModeNormal', 'Function')
        mode_hl('WinbarModeInsert', 'String')
        mode_hl('WinbarModeVisual', 'Special')
        mode_hl('WinbarModeReplace', 'Error')
        mode_hl('WinbarModeCommand', 'WarningMsg')
        mode_hl('WinbarModeTerminal', 'PreProc')
      end

      local function hl(name, text)
        return string.format('%%#%s#%s%%*', name, text)
      end

      function _G.Winbar()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].buftype ~= '' or excluded_filetypes[vim.bo[buf].filetype] then return '' end

        local mode = vim.api.nvim_get_mode().mode
        local path = vim.api.nvim_buf_get_name(buf)
        local name = path == '' and '[No Name]' or vim.fs.basename(vim.fs.normalize(path))
        local head = vim.b[buf].gitsigns_head

        local left = hl(mode_highlights[mode] or 'WinbarModeNormal', ' ' .. (mode_labels[mode] or mode:upper()) .. ' ')

        local center = { hl('WinbarMuted', name) }
        if head and head ~= '' then table.insert(center, hl('WinbarMuted', ' ' .. head)) end

        local counts = {
          { #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.ERROR }), 'DiagnosticError', 'E' },
          { #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.WARN }), 'DiagnosticWarn', 'W' },
          { #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.INFO }), 'DiagnosticInfo', 'I' },
          { #vim.diagnostic.get(buf, { severity = vim.diagnostic.severity.HINT }), 'DiagnosticHint', 'H' },
        }
        local diags = {}
        for _, item in ipairs(counts) do
          if item[1] > 0 then table.insert(diags, hl(item[2], item[3] .. ':' .. item[1])) end
        end
        if #diags == 0 then table.insert(diags, hl('WinbarMuted', 'OK')) end

        local current, total = vim.fn.line '.', vim.fn.line '$'
        local progress = current <= 1 and 'Top' or current >= total and 'Bot' or string.format('%d%%%%', math.floor(current / total * 100))
        local right = table.concat(diags, ' ') .. '  ' .. hl('WinbarMuted', progress)

        return left .. '%=' .. table.concat(center, '  ') .. '%=' .. right
      end

      set_highlights()
      vim.o.winbar = '%{%v:lua.Winbar()%}'

      vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = set_highlights,
      })

      vim.api.nvim_create_autocmd({ 'DiagnosticChanged', 'ModeChanged' }, {
        group = group,
        callback = function() vim.cmd.redrawstatus() end,
      })

      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'GitSignsUpdate',
        callback = function() vim.cmd.redrawstatus() end,
      })
    end,
  },
}
