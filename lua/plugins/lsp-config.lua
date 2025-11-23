return {
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'gopls', 'pyright', 'rust_analyzer', 'ts_ls', 'lua_ls', 'biome', 'ruff' },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'nvim-dap-ui' }
    },
    config = function()
      local ok_blink, blink = pcall(require, 'blink.cmp')
      local base_capabilities = ok_blink and blink.get_lsp_capabilities() or nil

      local function build_opts(opts)
        opts = opts or {}
        if base_capabilities then
          opts.capabilities = vim.tbl_deep_extend('force', {}, base_capabilities, opts.capabilities or {})
        end
        return opts
      end

      local function configure(server, opts)
        local ok, err = pcall(vim.lsp.config, server, build_opts(opts))
        if not ok then
          vim.notify(string.format('Failed to configure %s: %s', server, err), vim.log.levels.ERROR)
          return
        end
        vim.lsp.enable(server)
      end

      local util = require('lspconfig.util')
      local go_root = util.root_pattern('go.work', 'go.mod', '.git')

      configure('lua_ls', {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim', 'Snacks' },
            },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      })

      configure('ts_ls', {
        settings = {
          diagnostics = { ignoredCodes = { 2686, 6133, 80006 } },
          completions = {
            completeFunctionCalls = true,
          },
        },
      })

      configure('gopls', {
        root_dir = function(fname)
          if type(fname) == 'number' then
            fname = vim.api.nvim_buf_get_name(fname)
          end
          if not fname or fname == '' then
            return vim.uv.cwd()
          end
          return go_root(fname) or util.path.dirname(fname)
        end,
        settings = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            staticcheck = true,
            codelenses = {
              gc_details = true,
              test = true,
              tidy = true,
              regenerate_cgo = true,
              upgrade_dependency = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedvariable = true,
              unusedwrite = true,
              shadow = true,
              unreachable = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      configure('biome')
      configure('pyright')

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufnr = ev.buf

          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          nmap('<leader>cr', vim.lsp.buf.rename, '[C]ode Rename')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode Action')
          local function goto_definition()
            vim.api.nvim_create_autocmd('CursorMoved', {
              once = true,
              callback = function()
                pcall(vim.cmd, 'normal! zz')
              end,
            })
            vim.lsp.buf.definition()
          end

          nmap('gd', goto_definition, 'Goto Definition')
          nmap('<leader>gd', goto_definition, 'Goto Definition')

          local function toggle_inlay_hints()
            local enabled = vim.lsp.inlay_hint.is_enabled(bufnr)
            vim.lsp.inlay_hint.enable(bufnr, not enabled)
          end
          nmap('<leader>cth', toggle_inlay_hints, 'Toggle inlay hints')
        end,
      })
    end,
  },
}
