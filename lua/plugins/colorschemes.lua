return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        'folke/tokyonight.nvim',
        lazy = false,
        config = function()
          require('tokyonight').setup({
            style = 'night',
            light_style = 'day',
            transparent = false,
          })
        end,
      },
    },
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
      })

      local cursor_groups = { 'Cursor', 'lCursor', 'CursorIM', 'TermCursor', 'TermCursorNC' }
      local function apply_tokyonight_cursor()
        local cursor_highlight = { bg = '#363636', fg = '#f8f8f2' }
        for _, group in ipairs(cursor_groups) do
          vim.api.nvim_set_hl(0, group, cursor_highlight)
        end
      end

      local function apply_scheme(background)
        local scheme = background == 'light' and 'tokyonight-day' or 'catppuccin'
        local ok, err = pcall(vim.cmd.colorscheme, scheme)
        if not ok then
          vim.notify(('Failed to load colorscheme %s: %s'):format(scheme, err), vim.log.levels.ERROR)
          return
        end

        if scheme == 'tokyonight-day' then
          apply_tokyonight_cursor()
        end
      end

      apply_scheme(vim.o.background)

      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'background',
        callback = function()
          apply_scheme(vim.o.background)
        end,
      })

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function(event)
          if event.match == 'tokyonight-day' then
            apply_tokyonight_cursor()
          end
        end,
      })
    end,
  },
}
