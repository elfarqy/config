# Neovim Modern IDE Setup Guide

A complete setup guide for transforming Neovim into a modern IDE with TypeScript, JavaScript, Python, and PHP support.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [First-Time Setup](#first-time-setup)
- [Quick Reference Card](#quick-reference-card)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Optional Enhancements](#optional-enhancements)

---

## Prerequisites

Before starting, ensure you have the following installed:

### Required Software

| Software | Minimum Version | Purpose | Check Command |
|----------|----------------|---------|---------------|
| Neovim | 0.9+ | Editor | `nvim --version` |
| Git | Any | Clone plugins | `git --version` |
| Node.js | 16+ | TS/JS LSP servers | `node --version` |
| npm | Any | LSP dependencies | `npm --version` |
| Python | 3.8+ | Python LSP server | `python3 --version` |
| PHP | 7.4+ | PHP LSP server | `php --version` |
| wget/curl | Any | Download files | `wget --version` |

### Installing Prerequisites

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install neovim git nodejs npm python3 python3-pip php php-xml wget
```

**macOS:**
```bash
brew install neovim git node python3 wget
# PHP via Homebrew (optional)
brew install php
```

**Arch Linux:**
```bash
sudo pacman -S neovim git nodejs npm python python-pip php wget
```

---

## Installation Steps

### Step 1: Verify Configuration Files Exist

The configuration files should already be in place at:
```
~/.config/nvim/
├── init.lua
├── SETUP-GUIDE.md (this file)
└── lua/
    ├── plugins.lua
    ├── lsp.lua
    ├── keymaps.lua
    └── completion.lua
```

To verify:
```bash
ls -la ~/.config/nvim
ls -la ~/.config/nvim/lua
```

### Step 2: Open Neovim

Simply open Neovim to trigger automatic plugin installation:

```bash
nvim
```

**What happens automatically:**
1. `lazy.nvim` downloads and installs all configured plugins
2. `nvim-treesitter` installs syntax parsers for your languages
3. You'll see installation progress in a floating window

**Wait for:** The "[Lazy.nvim] Plugin installation complete" message

### Step 3: Install LSP Servers via Mason

After plugins are installed, open Mason to install LSP servers:

1. Open command mode: Press `:` (colon)
2. Type: `Mason`
3. Press Enter

Or use the keybinding: `<leader>m` (Space + m) - *if configured*

**In Mason:**
- Navigate with `j` and `k`
- Press `i` to install a server
- Press `g` then `u` to show all installed servers
- Press `q` to quit

**Required LSP Servers:**
- `ts_ls` (TypeScript/JavaScript)
- `pyright` (Python)
- `intelephense` (PHP)
- `html`
- `cssls`
- `tailwindcss`

**Note:** LSP servers defined in `lua/lsp.lua` should be installed automatically. Mason will confirm this.

### Step 4: Restart Neovim

After Mason finishes, quit and restart Neovim:

```vim
:qa
```

Then open Neovim again.

---

## First-Time Setup

### Verify Everything Works

1. **Open a project file:**
   ```bash
   cd your-project-directory
   nvim src/index.ts  # or any file in your project
   ```

2. **Check LSP is attached:**
   - Press `:LspInfo`
   - You should see the language server listed and status as "Running"

3. **Test autocomplete:**
   - Start typing a function or variable name
   - A completion menu should appear automatically

4. **Test goto definition:**
   - Place cursor on a function name
   - Press `gd`
   - Cursor should jump to function definition

5. **Test file explorer:**
   - Press `<Space>e` (leader + e)
   - File tree should open on the left

6. **Test fuzzy finder:**
   - Press `<Space>ff` (leader + ff)
   - Telescope file finder should open

---

## Quick Reference Card

### File Operations

| Keybinding | Action |
|------------|--------|
| `<Space>ff` | Find files (Telescope) |
| `<Space>fg` | Live grep (search text in files) |
| `<Space>fb` | Find open buffers |
| `<Space>e` | Toggle file explorer |
| `<Space>ef` | Focus file explorer |
| `<Space>gf` | Find git files |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |
| `<leader>bn` | Next buffer (tab) |
| `<leader>bp` | Previous buffer |
| `<leader>bd` | Close buffer |

### Window Navigation

| Keybinding | Action |
|------------|--------|
| `Ctrl+h` | Move to left window |
| `Ctrl+j` | Move to window below |
| `Ctrl+k` | Move to window above |
| `Ctrl+l` | Move to right window |
| `Ctrl+Up/Down/Left/Right` | Resize windows |

### LSP (Code Intelligence)

| Keybinding | Action |
|------------|--------|
| `gd` | Go to definition |
| `gD` | Go to type definition |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Show hover documentation |
| `Ctrl+k` | Signature help (function parameters) |
| `<leader>ca` | Code actions (quick fixes) |
| `<leader>d` | Show line diagnostics |
| `<leader>D` | Show all diagnostics |
| `<leader>rn` | Rename symbol |
| `<leader>fm` | Format code |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

### Autocompletion

| Keybinding | Action |
|------------|--------|
| `Ctrl+n` | Next completion item |
| `Ctrl+p` | Previous completion item |
| `Enter` | Accept completion |
| `Ctrl+e` | Close completion menu |
| `Tab` | Next snippet placeholder / accept completion |
| `Shift+Tab` | Previous snippet placeholder |
| `Ctrl+Space` | Trigger completion manually |

### Editing Shortcuts

| Keybinding | Action |
|------------|--------|
| `Alt+j` | Move line down |
| `Alt+k` | Move line up |
| `>` (visual mode) | Indent selection |
| `<` (visual mode) | Outdent selection |
| `Esc` (normal mode) | Clear search highlight |

### Common Commands

| Command | Action |
|---------|--------|
| `:Mason` | Open LSP server manager |
| `:LspInfo` | Show LSP server status |
| `:Telescope` | Open Telescope picker |
| `:NvimTreeToggle` | Toggle file explorer |
| `:NvimTreeFocus` | Focus file explorer |
| `:Lazy` | Open plugin manager |
| `:Lazy sync` | Update all plugins |
| `:TSUpdate` | Update Treesitter parsers |
| `:e file` | Edit file |
| `:w` | Save |
| `:q` | Quit |
| `:wq` | Save and quit |
| `:qa` | Quit all |

---

## Verification

### Check All Components

Run these commands to verify everything is working:

```bash
# Check Neovim version
nvim --version | head -1

# Check if config exists
ls -la ~/.config/nvim/

# Check if plugins are installed
ls -la ~/.local/share/nvim/lazy/

# Check if LSP servers are installed
ls -la ~/.local/share/nvim/mason/packages/
```

### Test Each Language

**TypeScript/JavaScript:**
```bash
nvim test.ts
# Type: console.log("hello")
# Hover over "console" and press K - should show documentation
```

**Python:**
```bash
nvim test.py
# Type: import os
# Type: os. (with dot) - should show completions
```

**PHP:**
```bash
nvim test.php
# Type: <?php echo
# Should see syntax highlighting
```

---

## Troubleshooting

### Plugins Not Installing

**Problem:** Plugins don't install automatically

**Solution:**
```vim
:Lazy
```
- Press `U` to update all plugins
- Press `X` to install clean (reinstall)

### LSP Not Starting

**Problem:** No autocomplete, `:LspInfo` shows "No client active"

**Solutions:**
1. Install LSP server via Mason: `:Mason`
2. Check LSP is configured in `lua/lsp.lua`
3. Restart Neovim
4. Check for errors: `:messages`

### File Tree Not Showing

**Problem:** `<Space>e` doesn't open file explorer

**Solutions:**
1. Run: `:NvimTreeToggle`
2. Check nvim-tree is installed: `:Lazy`
3. Look for errors: `:messages`

### Autocomplete Not Working

**Problem:** No completion menu appears

**Solutions:**
1. Ensure LSP is running: `:LspInfo`
2. Check cmp is installed: `:Lazy nvim-cmp`
3. Try manual trigger: `Ctrl+Space`
4. Check file type is supported: `:set filetype?`

### Syntax Highlighting Not Working

**Problem:** Code looks plain, no colors

**Solutions:**
1. Install treesitter parsers: `:TSInstall typescript python php`
2. Check treesitter status: `:TSInstallInfo`
3. Ensure colorscheme is loaded: `:colorscheme tokyonight`

### Mason Can't Download Servers

**Problem:** Mason shows download errors

**Solutions:**
1. Check internet connection
2. Ensure you have the required runtime (Node.js for TS/JS, Python for pyright)
3. Try installing manually:
   ```bash
   npm install -g typescript-language-server
   npm install -g vscode-langservers-extracted
   pip install pyright
   composer require intelephense/intelephense
   ```

### Performance Issues

**Problem:** Neovim feels slow

**Solutions:**
1. Reduce `updatetime` in `init.lua`
2. Disable unused plugins in `lua/plugins.lua`
3. Update Neovim: check for newer version
4. Check plugin performance: `:Lazy profile`

---

## Optional Enhancements

### Auto-formatting on Save

Add to `~/.config/nvim/lua/lsp.lua` in the `on_attach` function:

```lua
-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

### Additional LSP Servers

Add to `servers` list in `lua/lsp.lua`:

```lua
-- Lua (for Neovim config)
"lua_ls",

-- JSON
"jsonls",

-- YAML
"yamlls",

-- Docker
"dockerls",

-- Bash
"bashls",
```

### Additional Color Schemes

Install popular color schemes:

**In `lua/plugins.lua`:**

```lua
-- Gruvbox (retro groove style)
{ "ellisonleao/gruvbox.nvim", lazy = false, priority = 1000 },

-- Catppuccin (modern pastel)
{ "catppuccin/nvim", lazy = false, priority = 1000 },

-- Nord (arctic, bluish)
{ "nordtheme/vim", lazy = false, priority = 1000 },
```

Then change colorscheme:
```vim
:colorscheme gruvbox
```

### Git Integration (gitsigns.nvim)

Already included in plugins.lua! It shows:
- `+` for added lines
- `~` for changed lines
- `-` for deleted lines

Keybindings (add to `lua/keymaps.lua`):
```lua
-- Git staging
keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
keymap("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
```

### Status Line (lualine.nvim)

Already included! It shows:
- Mode (normal, insert, visual)
- Filename
- Git branch
- Filetype
- Cursor position

### Auto-pairs (automatically close brackets)

Install in `lua/plugins.lua`:

```lua
{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup()
  end,
},
```

### Comment.nvim (easy commenting)

Install in `lua/plugins.lua`:

```lua
{
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()
  end,
},
```

Usage:
- `gcc` - Toggle line comment
- `gc` + motion - Comment text object

---

## Getting Help

### Useful Resources

- **Neovim Documentation:** `:help`
- **LSP Configuration:** `:help lspconfig`
- **Lazy.nvim:** `:help lazy.nvim`
- **Telescope:** `:help telescope`
- **nvim-cmp:** `:help nvim-cmp`

### Online Resources

- [Neovim Wiki](https://github.com/neovim/neovim/wiki)
- [nvim-lspconfig Documentation](https://github.com/neovim/nvim-lspconfig)
- [Lazy.nvim GitHub](https://github.com/folke/lazy.nvim)
- [Neovim Discourse](https://neovim.io/discourse/)

---

## Summary

You now have a modern Neovim IDE setup with:

✅ LSP support for TypeScript, JavaScript, Python, and PHP
✅ Autocompletion with nvim-cmp
✅ File explorer with nvim-tree
✅ Fuzzy finder with Telescope
✅ Superior syntax highlighting with Treesitter
✅ Git integration with gitsigns
✅ Beautiful status line with lualine
✅ Modern colorscheme (Tokyo Night)

**Happy coding! 🚀**

---

*Last updated: 2025*
