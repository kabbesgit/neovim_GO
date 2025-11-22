return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-go',
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-go')({
          experimental = { test_table = true },
          args = { '-count=1', '-cover' },
        }),
      },
      discovery = { enabled = true },
      running = { concurrent = true },
      default_strategy = 'integrated',
    })
  end,
  keys = {
    {
      '<leader>tc',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>tf',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Run file tests',
    },
    {
      '<leader>ta',
      function()
        require('neotest').run.run(vim.loop.cwd())
      end,
      desc = 'Run all tests in project',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle test summary',
    },
    {
      '<leader>to',
      function()
        require('neotest').output.open({ enter = true, auto_close = true })
      end,
      desc = 'Open test output',
    },
    {
      '<leader>tS',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop running tests',
    },
  },
}
