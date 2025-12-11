local function ensure_go_defaults(dap)
  if not dap then
    return
  end

  -- Provide a Go adapter if none is registered yet
  if not dap.adapters then
    dap.adapters = {}
  end
  if not dap.adapters.go then
    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "--listen", "127.0.0.1:${port}", "--log" },
      },
    }
  end

  -- Provide a minimal Go configuration if none exist
  if not dap.configurations then
    dap.configurations = {}
  end
  if not dap.configurations.go or vim.tbl_isempty(dap.configurations.go) then
    dap.configurations.go = {
      {
        type = "go",
        name = "Debug file",
        request = "launch",
        program = "${file}",
        console = "internalConsole",
      },
      {
        type = "go",
        name = "Debug package",
        request = "launch",
        program = "${workspaceFolder}",
        console = "internalConsole",
      },
    }
  end
end

return {
  'rcarriga/nvim-dap-ui',
  ft = { 'go', 'gomod', 'gowork' },
  init = function()
    local function lazy_load(...)
      local plugins = { ... }
      local ok, lazy = pcall(require, 'lazy')
      if not ok then
        return false
      end
      lazy.load({ plugins = plugins })
      return true
    end

    local function with_dap(callback)
      return function(...)
        -- Load core DAP plugins plus Go adapter
        lazy_load('nvim-dap', 'nvim-dap-ui', 'nvim-dap-go')
        local ok, dap = pcall(require, 'dap')
        if not ok then
          vim.notify('nvim-dap is not available', vim.log.levels.ERROR)
          return
        end
        ensure_go_defaults(dap)
        return callback(dap, ...)
      end
    end

    local function with_dapui(callback)
      return function(...)
        lazy_load('nvim-dap', 'nvim-dap-ui')
        local ok, dapui = pcall(require, 'dapui')
        if not ok then
          vim.notify('nvim-dap-ui is not available', vim.log.levels.ERROR)
          return
        end
        return callback(dapui, ...)
      end
    end

    -- Buffer-local Go keymaps only
    local function map_go_keys(bufnr)
      local function buf(lhs, rhs, desc, mode)
        vim.keymap.set(mode or 'n', lhs, rhs, { buffer = bufnr, desc = desc })
      end

      buf('<leader>db', with_dap(function(dap)
        dap.toggle_breakpoint()
      end), 'DAP: toggle breakpoint')

      buf('<leader>dB', with_dap(function(dap)
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end), 'DAP: conditional breakpoint')

      buf('<leader>dd', with_dap(function(dap)
        dap.continue()
      end), 'DAP: start/continue')

      buf('<leader>dc', with_dap(function(dap)
        dap.continue()
      end), 'DAP: continue')

      buf('<leader>dC', with_dap(function(dap)
        dap.run_to_cursor()
      end), 'DAP: run to cursor')

      buf('<leader>ds', with_dap(function(dap)
        dap.step_over()
      end), 'DAP: step over')

      buf('<leader>di', with_dap(function(dap)
        dap.step_into()
      end), 'DAP: step into')

      buf('<leader>do', with_dap(function(dap)
        dap.step_out()
      end), 'DAP: step out')

      buf('<leader>dr', with_dap(function(dap)
        if dap.restart then
          dap.restart()
        else
          dap.terminate()
          dap.continue()
        end
      end), 'DAP: restart')

      buf('<leader>dt', with_dap(function(dap)
        dap.terminate()
      end), 'DAP: terminate')

      buf('<leader>du', with_dapui(function(dapui)
        dapui.toggle()
      end), 'DAP UI: toggle')

      buf('<leader>de', with_dapui(function(dapui)
        dapui.eval()
      end), 'DAP: eval expression')

      buf('<leader>de', with_dapui(function(dapui)
        dapui.eval()
      end), 'DAP: eval selection', 'v')

      buf('<leader>dv', function()
        lazy_load('nvim-dap', 'nvim-dap-ui', 'nvim-dap-virtual-text')
        vim.cmd('DapVirtualTextToggle')
      end, 'DAP: toggle virtual text')

      -- F-key aliases (optional)
      buf('<F5>', with_dap(function(dap)
        dap.continue()
      end), 'DAP: start/continue (F5)')

      buf('<F9>', with_dap(function(dap)
        dap.toggle_breakpoint()
      end), 'DAP: toggle breakpoint (F9)')

      buf('<F10>', with_dap(function(dap)
        dap.step_over()
      end), 'DAP: step over (F10)')

      buf('<F11>', with_dap(function(dap)
        dap.step_into()
      end), 'DAP: step into (F11)')

      buf('<S-F11>', with_dap(function(dap)
        dap.step_out()
      end), 'DAP: step out (S-F11)')

      buf('<S-F5>', with_dap(function(dap)
        if dap.restart then
          dap.restart()
        else
          dap.terminate()
          dap.continue()
        end
      end), 'DAP: restart (S-F5)')

      buf('<C-F5>', with_dap(function(dap)
        dap.terminate()
      end), 'DAP: stop (C-F5)')
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GoDapKeymaps", { clear = true }),
      pattern = { "go", "gomod", "gowork" },
      callback = function(event)
        map_go_keys(event.buf)
      end,
    })
  end,
  dependencies = {
    'mfussenegger/nvim-dap',
    'theHamsta/nvim-dap-virtual-text',
    'leoluz/nvim-dap-go',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dap_virtual_text = require("nvim-dap-virtual-text")

    -- Use Neovim split for runInTerminal requests (if an adapter asks for it)
    dap.defaults.fallback.terminal_win_cmd = "belowright 15split | terminal"

    -- Setup DAP UI
    dapui.setup({
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = ""
        }
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" }
        }
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = ""
      },
      layouts = {
        {
          elements = {
            { id = "scopes",      size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 }
          },
          position = "left",
          size = 40
        },
        {
          elements = {
            { id = "repl",    size = 0.5 },
            { id = "console", size = 0.5 }
          },
          position = "bottom",
          size = 10
        }
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t"
      },
      render = {
        indent = 1,
        max_value_lines = 100
      }
    })

    -- UPDATED: Virtual text with improved configuration
    dap_virtual_text.setup({
      enabled = true, -- CHANGED: Now enabled by default with limits
      enabled_commands = true,
      highlight_changed_variables = true,
      highlight_new_as_changed = false,
      show_stop_reason = true,
      commented = false,
      only_first_definition = true,
      all_references = false,
      clear_on_continue = false,

      -- IMPROVED: Custom display callback to limit length
      display_callback = function(variable, buf, stackframe, node, options)
        -- Limit value length to prevent clutter
        local value = variable.value
        if #value > 50 then
          value = string.sub(value, 1, 50) .. '...'
        end

        if options.virt_text_pos == 'inline' then
          return ' = ' .. value
        else
          return variable.name .. ' = ' .. value
        end
      end,

      virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',
      all_frames = false,
      virt_lines = false,
      virt_text_win_col = nil
    })

    -- Setup Go debugging
    require("dap-go").setup({
      delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = {},
        build_flags = "",
        detached = vim.fn.has("win32") == 0,
        cwd = nil,
      },
    })

    -- Ensure Go adapter/configs exist (in case dap-go didn't populate yet)
    ensure_go_defaults(dap)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GoDapConfig", { clear = true }),
      pattern = "go",
      callback = function()
        ensure_go_defaults(dap)
      end,
    })

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Go-specific debugging keymaps
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("GoDebugMappings", { clear = true }),
      pattern = "go",
      callback = function(event)
        vim.keymap.set("n", "<leader>td", function()
          require("dap-go").debug_test()
        end, { buffer = event.buf, desc = "Debug test" })

        vim.keymap.set("n", "<leader>tD", function()
          require("dap-go").debug_last_test()
        end, { buffer = event.buf, desc = "Debug last test" })
      end,
    })

    -- DAP signs
    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition",
      { text = "🟡", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "🟢", texthl = "DapLogPoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "🔶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })

    local function set_dap_highlights()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#0f255c", fg = "NONE" })
    end

    set_dap_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("DapHighlights", { clear = true }),
      callback = set_dap_highlights,
    })
  end,
}
