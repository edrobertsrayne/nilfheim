# Nixvim Keymaps Reference

Comprehensive reference for all keymaps configured in the Nilfheim nixvim setup.

**Leader key**: `<Space>`
**Local leader key**: `\`

## Table of Contents

- [Core Navigation](#core-navigation)
- [Essential Editor Shortcuts](#essential-editor-shortcuts)
- [Window and Buffer Management](#window-and-buffer-management)
- [Tab Management](#tab-management)
- [Git Operations](#git-operations)
- [File and Project Navigation](#file-and-project-navigation)
- [Search Operations](#search-operations)
- [LSP Navigation and Operations](#lsp-navigation-and-operations)
- [Diagnostics and Quickfix](#diagnostics-and-quickfix)
- [Word Navigation](#word-navigation)
- [UI Toggles and Utilities](#ui-toggles-and-utilities)
- [Terminal](#terminal)
- [Line Movement](#line-movement)
- [Completion](#completion)
- [Code Comments](#code-comments)
- [Surround Operations](#surround-operations)
- [Text Objects](#text-objects)
- [Motion and Jumping](#motion-and-jumping)

---

## Core Navigation

### Better Up/Down Movement

Respects word wrap when moving vertically without a count.

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `j` | `gj` when no count | Move down (respects wrap) |
| `n` | `k` | `gk` when no count | Move up (respects wrap) |

### Window Navigation

Tmux-aware window navigation (handled by `tmux-navigator` plugin).

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<C-h>` | Navigate left | Move to left window/tmux pane |
| `n` | `<C-j>` | Navigate down | Move to window/pane below |
| `n` | `<C-k>` | Navigate up | Move to window/pane above |
| `n` | `<C-l>` | Navigate right | Move to right window/tmux pane |

### Window Resizing

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<C-Up>` | `resize +2` | Increase window height |
| `n` | `<C-Down>` | `resize -2` | Decrease window height |
| `n` | `<C-Left>` | `vertical resize -2` | Decrease window width |
| `n` | `<C-Right>` | `vertical resize +2` | Increase window width |

---

## Essential Editor Shortcuts

### Clear Search and Escape

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<Esc>` | `:noh<CR>` | Escape and clear search highlights |
| `i` | `<Esc>` | `:noh<CR>` | Escape and clear search highlights |
| `n` | `<leader>nh` | `:nohl<CR>` | Clear search highlights |
| `n` | `<leader>ur` | Redraw screen | Redraw / Clear hlsearch / Update diff |

### Save File

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<C-s>` | `:w<CR>` | Save file |
| `i` | `<C-s>` | `:w<CR>` | Save file |
| `x` | `<C-s>` | `:w<CR>` | Save file |
| `s` | `<C-s>` | `:w<CR>` | Save file |

### Better Indenting

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `v` | `<` | `<gv` | Indent left (keeps selection) |
| `v` | `>` | `>gv` | Indent right (keeps selection) |

### Insert Mode

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `i` | `jk` | `<ESC>` | Exit insert mode |

### Search Navigation

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `n` | `nzzzv` | Next search result (centered) |
| `n` | `N` | `Nzzzv` | Previous search result (centered) |

---

## Window and Buffer Management

### Window Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>ww` | `<C-W>p` | Switch to other window |
| `n` | `<leader>wd` | `<C-W>c` | Delete window |
| `n` | `<leader>w-` | `<C-W>s` | Split window below |
| `n` | `<leader>w|` | `<C-W>v` | Split window right |
| `n` | `<leader>-` | `<C-W>s` | Split window below (alternative) |
| `n` | `<leader>|` | `<C-W>v` | Split window right (alternative) |

### Buffer Navigation

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<S-h>` | `:bprevious` | Previous buffer |
| `n` | `<S-l>` | `:bnext` | Next buffer |
| `n` | `[b` | `:bprevious` | Previous buffer (bracket notation) |
| `n` | `]b` | `:bnext` | Next buffer (bracket notation) |
| `n` | `<leader>bb` | `:e #` | Switch to alternate buffer |

### Buffer Operations

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>bd` | Snacks bufdelete | Delete buffer |
| `n` | `<leader>bD` | Snacks bufdelete + close | Delete buffer and window |
| `n` | `<leader>bo` | `%bd\|e#\|bd#` | Delete other buffers |

### Quit

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>qq` | `:qa` | Quit all |

---

## Tab Management

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader><tab><tab>` | `:tabnew` | New tab |
| `n` | `<leader><tab>d` | `:tabclose` | Close tab |
| `n` | `<leader><tab>]` | `:tabnext` | Next tab |
| `n` | `<leader><tab>[` | `:tabprevious` | Previous tab |
| `n` | `<leader><tab>l` | `:tablast` | Last tab |
| `n` | `<leader><tab>o` | `:tabonly` | Close other tabs |

---

## Git Operations

### Git Pickers (Snacks)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>gb` | Snacks git_branches | Browse git branches |
| `n` | `<leader>gl` | Snacks git_log | Git log |
| `n` | `<leader>gL` | Snacks git_log_line | Git log for current line |
| `n` | `<leader>gs` | Snacks git_status | Git status |
| `n` | `<leader>gS` | Snacks git_stash | Git stash |
| `n` | `<leader>gd` | Snacks git_diff | Git diff (hunks) |
| `n` | `<leader>gf` | Snacks git_log_file | Git log for current file |
| `n` | `<leader>gB` | Snacks gitbrowse | Browse file/selection on GitHub |
| `v` | `<leader>gB` | Snacks gitbrowse | Browse selection on GitHub |
| `n` | `<leader>gg` | Snacks lazygit | Open Lazygit |

### Git Hunks (Gitsigns)

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>hs` | Gitsigns stage_hunk | Stage hunk |
| `n` | `<leader>hr` | Gitsigns reset_hunk | Reset hunk |
| `n` | `<leader>hp` | Gitsigns preview_hunk | Preview hunk |
| `n` | `<leader>hb` | Gitsigns blame_line | Blame line |
| `n` | `]h` | Gitsigns next_hunk | Next hunk |
| `n` | `[h` | Gitsigns prev_hunk | Previous hunk |

---

## File and Project Navigation

### Quick Access

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader><space>` | Snacks smart | Smart find files (git-aware) |
| `n` | `<leader>,` | Snacks buffers | List buffers |
| `n` | `<leader>/` | Snacks grep | Grep in project |
| `n` | `<leader>:` | Snacks command_history | Command history |
| `n` | `<leader>e` | Snacks explorer | File explorer |

### Find Files

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>fb` | Snacks buffers | Find buffers |
| `n` | `<leader>fc` | Snacks files (config) | Find config file |
| `n` | `<leader>ff` | Snacks files | Find files |
| `n` | `<leader>fg` | Snacks git_files | Find git files |
| `n` | `<leader>fp` | Snacks projects | Find projects |
| `n` | `<leader>fr` | Snacks recent | Recent files |

---

## Search Operations

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>sb` | Snacks lines | Search buffer lines |
| `n` | `<leader>sB` | Snacks grep_buffers | Grep open buffers |
| `n` | `<leader>sg` | Snacks grep | Grep in project |
| `n` | `<leader>sw` | Snacks grep_word | Search word under cursor |
| `x` | `<leader>sw` | Snacks grep_word | Search visual selection |
| `n` | `<leader>s"` | Snacks registers | Search registers |
| `n` | `<leader>sa` | Snacks autocmds | Search autocmds |
| `n` | `<leader>sc` | Snacks command_history | Search command history |
| `n` | `<leader>sC` | Snacks commands | Search commands |
| `n` | `<leader>sd` | Snacks diagnostics | Search diagnostics |
| `n` | `<leader>sD` | Snacks diagnostics_buffer | Search buffer diagnostics |
| `n` | `<leader>sh` | Snacks help | Search help pages |
| `n` | `<leader>sH` | Snacks highlights | Search highlights |
| `n` | `<leader>si` | Snacks icons | Search icons |
| `n` | `<leader>sj` | Snacks jumps | Search jump list |
| `n` | `<leader>sk` | Snacks keymaps | Search keymaps |
| `n` | `<leader>sl` | Snacks loclist | Search location list |
| `n` | `<leader>sm` | Snacks marks | Search marks |
| `n` | `<leader>sM` | Snacks man | Search man pages |
| `n` | `<leader>sq` | Snacks qflist | Search quickfix list |
| `n` | `<leader>sR` | Snacks resume | Resume last search |
| `n` | `<leader>su` | Snacks undo | Search undo history |

---

## LSP Navigation and Operations

### Navigation

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `gd` | Snacks lsp_definitions | Go to definition |
| `n` | `gD` | Snacks lsp_declarations | Go to declaration |
| `n` | `gr` | Snacks lsp_references | Find references |
| `n` | `gI` | Snacks lsp_implementations | Go to implementation |
| `n` | `gy` | Snacks lsp_type_definitions | Go to type definition |
| `n` | `<leader>ss` | Snacks lsp_symbols | LSP symbols |
| `n` | `<leader>sS` | Snacks lsp_workspace_symbols | LSP workspace symbols |

### Hover and Info

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `K` | `vim.lsp.buf.hover()` | Hover documentation |
| `n` | `gK` | `vim.lsp.buf.signature_help()` | Signature help |
| `n` | `<leader>cl` | `:LspInfo` | LSP info |

### Code Actions

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>ca` | `vim.lsp.buf.code_action()` | Code action |
| `x` | `<leader>ca` | `vim.lsp.buf.code_action()` | Code action (visual) |
| `n` | `<leader>cr` | `vim.lsp.buf.rename()` | Rename symbol |
| `n` | `<leader>cR` | Snacks rename_file | Rename file |

---

## Diagnostics and Quickfix

### Diagnostics

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>cd` | `vim.diagnostic.open_float()` | Line diagnostics |
| `n` | `]d` | `vim.diagnostic.goto_next()` | Next diagnostic |
| `n` | `[d` | `vim.diagnostic.goto_prev()` | Previous diagnostic |
| `n` | `]e` | Next error | Next error (severity: ERROR) |
| `n` | `[e` | Previous error | Previous error (severity: ERROR) |
| `n` | `]w` | Next warning | Next warning (severity: WARN) |

### Trouble

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>xx` | `:Trouble diagnostics` | Diagnostics (Trouble) |
| `n` | `<leader>xX` | `:Trouble diagnostics buffer` | Buffer diagnostics (Trouble) |
| `n` | `<leader>xL` | `:Trouble loclist` | Location list (Trouble) |
| `n` | `<leader>xQ` | `:Trouble qflist` | Quickfix list (Trouble) |

### Todo Comments

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>xt` | `:TodoTrouble` | Todo (Trouble) |
| `n` | `<leader>xq` | `:TodoQuickFix` | Todo (QuickFix) |

### Quickfix Navigation

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `[q` | `:cprev` | Previous quickfix |
| `n` | `]q` | `:cnext` | Next quickfix |

---

## Word Navigation

Navigation using Snacks Words (word highlights under cursor).

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `]]` | Snacks words.jump(1) | Next reference |
| `t` | `]]` | Snacks words.jump(1) | Next reference |
| `n` | `[[` | Snacks words.jump(-1) | Previous reference |
| `t` | `[[` | Snacks words.jump(-1) | Previous reference |

---

## UI Toggles and Utilities

### Snacks Utilities

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>z` | Snacks zen | Toggle Zen mode |
| `n` | `<leader>Z` | Snacks zen.zoom | Toggle Zoom |
| `n` | `<leader>.` | Snacks scratch | Toggle scratch buffer |
| `n` | `<leader>S` | Snacks scratch.select | Select scratch buffer |
| `n` | `<leader>n` | Snacks notifier.show_history | Notification history |
| `n` | `<leader>un` | Snacks notifier.hide | Dismiss all notifications |

### UI Toggles

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<leader>ul` | `:set nu!` | Toggle line numbers |
| `n` | `<leader>uL` | `:set rnu!` | Toggle relative line numbers |
| `n` | `<leader>uc` | Toggle conceallevel | Toggle conceallevel (0/2) |
| `n` | `<leader>ud` | Toggle diagnostics | Toggle diagnostics |
| `n` | `<leader>us` | `:set spell!` | Toggle spelling |
| `n` | `<leader>uw` | `:set wrap!` | Toggle wrap |
| `n` | `<leader>uf` | Toggle autoformat | Toggle auto format (global) |
| `n` | `<leader>uF` | Toggle autoformat | Toggle auto format (buffer) |
| `n` | `<leader>uC` | Snacks colorschemes | Select colorscheme |

---

## Terminal

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<C-/>` | Snacks terminal | Toggle terminal |
| `n` | `<C-_>` | Snacks terminal | Toggle terminal (alternative) |

---

## Line Movement

Move lines up and down in different modes.

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `<A-j>` | `:m .+1<cr>==` | Move line down |
| `n` | `<A-k>` | `:m .-2<cr>==` | Move line up |
| `i` | `<A-j>` | `<esc>:m .+1<cr>==gi` | Move line down |
| `i` | `<A-k>` | `<esc>:m .-2<cr>==gi` | Move line up |
| `v` | `<A-j>` | `:m '>+1<cr>gv=gv` | Move selection down |
| `v` | `<A-k>` | `:m '<-2<cr>gv=gv` | Move selection up |

---

## Completion

Completion keymaps (nvim-cmp).

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `i` | `<CR>` | Confirm | Confirm completion |
| `i` | `<Tab>` | Select next | Next completion item |
| `i` | `<S-Tab>` | Select prev | Previous completion item |
| `i` | `<C-Space>` | Complete | Trigger completion |
| `i` | `<C-d>` | Scroll docs | Scroll docs down |
| `i` | `<C-f>` | Scroll docs | Scroll docs up |

---

## Code Comments

Comment.nvim provides intelligent commenting.

### Toggler

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `gcc` | Toggle line comment | Toggle comment on current line |
| `n` | `gbc` | Toggle block comment | Toggle block comment |

### Operator-pending

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n` | `gc` | Comment operator | Comment motion (e.g., `gcip` = comment paragraph) |
| `n` | `gb` | Block comment operator | Block comment motion |
| `v` | `gc` | Comment selection | Comment visual selection |
| `v` | `gb` | Block comment selection | Block comment visual selection |

---

## Surround Operations

nvim-surround provides surround text objects (default keymaps).

### Normal Mode

| Key | Action | Description |
|-----|--------|-------------|
| `ys{motion}{char}` | Add | Add surround (e.g., `ysiw"` = surround word with quotes) |
| `ds{char}` | Delete | Delete surround (e.g., `ds"` = delete quotes) |
| `cs{target}{replacement}` | Change | Change surround (e.g., `cs"'` = change `"` to `'`) |

### Visual Mode

| Key | Action | Description |
|-----|--------|-------------|
| `S{char}` | Add | Surround selection with char |

### Common Examples

- `ysiw"` - Surround inner word with double quotes
- `yss)` - Surround entire line with parentheses
- `ds"` - Delete surrounding double quotes
- `cs"'` - Change surrounding double quotes to single quotes
- `cst<div>` - Change surrounding tag to `<div>`

---

## Text Objects

### Treesitter Text Objects

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `o`/`x` | `af` | `@function.outer` | Outer function |
| `o`/`x` | `if` | `@function.inner` | Inner function |
| `o`/`x` | `ac` | `@class.outer` | Outer class |
| `o`/`x` | `ic` | `@class.inner` | Inner class |

### Examples

- `daf` - Delete outer function
- `vif` - Visually select inner function
- `yac` - Yank outer class
- `cic` - Change inner class

---

## Motion and Jumping

### Flash

Flash provides enhanced motion and jumping. Default keymaps:

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n`/`x`/`o` | `s` | Flash jump | Jump to any location (2-char search) |
| `n`/`x`/`o` | `S` | Flash treesitter | Jump to treesitter node |

### Enhanced f/F/t/T

Flash integrates with default `f`, `F`, `t`, `T` motions for enhanced character finding with labels.

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `n`/`x`/`o` | `f` | Find char forward | Enhanced find forward |
| `n`/`x`/`o` | `F` | Find char backward | Enhanced find backward |
| `n`/`x`/`o` | `t` | Till char forward | Enhanced till forward |
| `n`/`x`/`o` | `T` | Till char backward | Enhanced till backward |

---

## Plugin Default Keymaps

### nvim-autopairs

Auto-pairs provides automatic bracket/quote pairing.

| Mode | Key | Action | Description |
|------|-----|--------|-------------|
| `i` | `(` | Auto-pair | Inserts `()` and places cursor between |
| `i` | `{` | Auto-pair | Inserts `{}` and places cursor between |
| `i` | `[` | Auto-pair | Inserts `[]` and places cursor between |
| `i` | `"` | Auto-pair | Inserts `""` and places cursor between |
| `i` | `'` | Auto-pair | Inserts `''` and places cursor between |
| `i` | `<BS>` | Delete pair | Deletes both brackets if empty |
| `i` | `<CR>` | Expand pair | Expands pairs with newline and indent |

---

## Configuration Files

Keymap definitions are located in:

- `modules/home/nixvim/keymaps.nix` - Main keymap definitions
- `modules/home/nixvim/plugins.nix` - Plugin configurations with keymaps
- `modules/home/nixvim/languages.nix` - LSP and treesitter text objects
- `modules/home/nixvim/default.nix` - Leader key configuration

**Leader configuration** (defined in `modules/home/nixvim/default.nix:44-45`):
```nix
globals = {
  mapleader = " ";
  maplocalleader = "\\";
};
```

---

## Which-Key Groups

Press `<leader>` to see available command groups:

| Prefix | Group |
|--------|-------|
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>s` | Search |
| `<leader>u` | UI |
| `<leader>w` | Windows |
| `<leader>x` | Diagnostics/Quickfix |
| `<leader>q` | Quit/Session |
| `<leader>c` | Code |
| `<leader>b` | Buffers |
| `<leader>t` | Terminal |
| `<leader>n` | Notifications |
| `<leader>l` | LSP |
| `<leader><tab>` | Tabs |

---

## Tips

1. **Discovery**: Press `<Space>` (leader) and wait to see available commands via which-key
2. **Search keymaps**: Use `<leader>sk` to search all keymaps interactively
3. **Help**: Use `<leader>sh` to search help pages
4. **Learn motions**: Flash motions (`s`, `S`) are powerful for quick navigation
5. **Completion**: `<C-Space>` triggers completion manually anywhere
6. **Undo tree**: Use `<leader>su` to browse undo history with Snacks picker

---

## See Also

- [Snacks.nvim Documentation](https://github.com/folke/snacks.nvim)
- [Flash.nvim Documentation](https://github.com/folke/flash.nvim)
- [nvim-surround Documentation](https://github.com/kylechui/nvim-surround)
- [Comment.nvim Documentation](https://github.com/numToStr/Comment.nvim)
- [nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
