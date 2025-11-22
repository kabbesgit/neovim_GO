# Keymaps

Leader: `<Space>`

## Go helpers
- `<leader>mb` go build `./...` -> quickfix on errors; closes quickfix + notifies on success
- `<leader>mr` go run `.` in bottom terminal (project root)

## Files / search
- `<leader>ff` Snacks files picker
- `<leader>fg` Snacks git files
- `<leader>fr` recent files
- `<leader>sf` Telescope files (root)
- `<leader>sF` Telescope files (LSP root)
- `<leader>sb` buffer lines (Snacks)
- `<leader>sB` grep open buffers (Snacks)
- `<leader>sg` live grep (Snacks/Telescope root)
- `<leader>sG` live grep (Telescope LSP root)
- `<leader>sw` grep word/selection (Snacks + Telescope)
- `<leader>sh` help tags
- `<leader>sd` diagnostics picker

## Buffers / windows
- `<S-h>` / `<S-l>` prev/next buffer
- `<leader>bp` pin buffer; `<leader>bP` close unpinned; `<leader>bo` close others
- `<leader>wsh` split horiz; `<leader>wsv` split vert; `<leader>wse` equalize; `<leader>wx` close window
- `<leader>fw` write file
- `<leader>qq` quit all

## Git
- `<leader>hs`/`hr` stage/reset hunk; `<leader>hS` stage buffer; `<leader>hu` undo stage; `<leader>hR` reset buffer
- `<leader>hp` preview hunk; `<leader>hb` blame line; `<leader>tb` toggle blame; `<leader>hd` diff; `<leader>hD` diff vs ~; `<leader>td` toggle deleted
- Hunk nav: `[c` / `]c`
- Gitsigns text object: `ih` (o/x mode) select hunk
- Snacks git: `<leader>gc` log, `<leader>gs` status, `<leader>gB` browse, `<leader>gb` blame line, `<leader>gf` lazygit file log, `<leader>gg` lazygit, `<leader>gl` lazygit log cwd

## Harpoon
- `<leader>a` add
- `<C-e>` menu
- `<C-1>`..`<C-4>` jump; `<leader>1`..`<leader>8` jump
- `<leader>fa` prev mark; `<leader>af` next mark
- `<leader>ch` clear marks

## Diagnostics / lists
- `<leader>cd` diagnostic float; `<leader>q` loclist diagnostics; `<leader>nh` clear search
- Trouble: `<leader>dx` workspace diag, `<leader>dw` workspace diag view, `<leader>dq` quickfix, `gR` references
- Trouble (plugin maps): `<leader>xx` diagnostics, `<leader>xX` buffer diagnostics, `<leader>cs` symbols, `<leader>cl` LSP list, `<leader>xL` loclist, `<leader>xQ` qflist

## LSP
- `gd` / `<leader>gd` goto definition (recenters)
- `<leader>cr` rename; `<leader>ca` code action
- `<leader>cth` toggle inlay hints

## Testing (neotest)
- `<leader>tc` nearest test; `<leader>tf` file tests; `<leader>ta` all tests (cwd)
- `<leader>ts` summary; `<leader>to` output; `<leader>tS` stop

## Debugging (DAP)
- `<leader>db` toggle breakpoint; `<leader>dB` conditional
- `<leader>dc` continue; `<leader>dC` run to cursor
- `<leader>ds`/`di`/`do` step over/into/out; `<leader>dr` restart; `<leader>dt` terminate
- `<leader>du` toggle UI; `<leader>de` eval (n/v); `<leader>dv` toggle virtual text
- `<F5>` continue; `<F9>` breakpoint; `<F10>` step over; `<F11>` step into; `<S-F11>` step out; `<S-F5>` restart; `<C-F5>` stop

## Editing aids
- Comment.nvim: `gc` toggle (n/x), `gcc` line, `gb` block, `gbc` block line
- Copilot: `<S-Tab>` accept; `<C-n>` dismiss
- Surround: `gsa` add; `gsd` delete; `gsf`/`gsF` find; `gsh` highlight; `gsr` replace; `gsn` update n_lines
- Flash: `s` jump; `S` treesitter; `r` remote (o); `R` treesitter search (o/x); `<C-s>` toggle in cmdline

## Formatting / linting
- `<leader>f` format buffer
- `<leader>uf` toggle autoformat (buffer)
- `<leader>l` run linters

## Undo / misc
- `<leader>u` toggle undo tree
- Snacks: `<leader>z` zen; `<leader>Z` zoom; `<leader>.` scratch; `<leader>S` select scratch; `<leader>n` notification history; `<leader>un` dismiss notifications; `<c-/>` terminal toggle (also `<c-_>`); `]]`/`[[` next/prev reference
- Toggle options (Snacks): `<leader>us` spell; `<leader>uw` wrap; `<leader>uL` relative number; `<leader>ud` diagnostics; `<leader>ul` line numbers; `<leader>uc` conceal; `<leader>uT` treesitter; `<leader>ub` background; `<leader>uh` inlay hints
