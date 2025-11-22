return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'gopls',
          'delve',
          'goimports',
          'gofumpt',
          'golangci-lint',
          'gomodifytags',
          'gotests',
          'staticcheck',
        },
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 12,
      })
    end,
  },
}
