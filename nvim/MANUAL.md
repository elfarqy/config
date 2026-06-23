# Neovim IDE Configuration Manual

A complete guide to understanding your modern Neovim IDE setup.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [File Structure](#file-structure)
3. [Configuration Files Explained](#configuration-files-explained)
4. [Key Concepts](#key-concepts)
5. [How Everything Works Together](#how-everything-works-together)
6. [Customization Guide](#customization-guide)
7. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

Your Neovim configuration follows a modular architecture:

```
┌─────────────────────────────────────────────────────────────┐
│                      init.lua                               │
│                  (Entry Point)                              │
│  - Sets leader key                                          │
│  - Configures basic settings                                │
│  - Loads all modules                                        │
└────────────┬────────────────────────────────────────────────┘
             │
    ┌────────┴────────┐
    │                 │
    ▼                 ▼
┌─────────┐     ┌─────────────────┐
│ keymaps │     │   plugins.lua   │
│         │     │  (Plugin Mgr)   │
└─────────┘     └────────┬────────┘
                         │
            ┌────────────┼────────────┐
            ▼            ▼            ▼
      ┌─────────┐  ┌──────────┐  ┌─────────────┐
      │   lsp   │  │completion│  │  nvim-tree  │
      │         │  │          │  │  telescope  │
      └─────────┘  └──────────┘  └─────────────┘
```

### Key Components

| Component | Purpose |
|-----------|---------|
| **lazy.nvim** | Plugin manager - installs and manages all plugins |
| **nvim-lspconfig** | LSP client configuration |
| **mason.nvim** | LSP server installer |
| **nvim-cmp** | Autocompletion framework |
| **nvim-treesitter** | Advanced syntax highlighting |
| **telescope.nvim** | Fuzzy finder |
| **nvim-tree.lua** | File explorer |

---

## File Structure

```
~/.config/nvim/
├── init.lua              # Main entry point
├── MANUAL.md             # This file
├── SETUP-GUIDE.md        # Installation & quick reference
└── lua/
    ├── plugins.lua       # Plugin specifications
    ├── lsp.lua           # LSP configuration
    ├── keymaps.lua       # Key mappings
    └── completion.lua    # Autocompletion setup
```

---

## Configuration Files Explained

### 1. init.lua (Main Entry Point)

**Purpose:** The first file Neovim loads. It sets up the environment and loads all modules.

**What it does:**

```lua
-- 1. Installs lazy.nvim if not present
-- 2. Sets leader key to SPACE
-- 3. Configures basic Neovim settings
-- 4. Loads all configuration modules
```

**Key Settings Explained:**

| Setting | Purpose | Value |
|---------|---------|-------|
| `vim.g.mapleader = " "` | Sets SPACE as leader key | Used for custom keybindings like `<Space>ff` |
| `vim.opt.number = true` | Show line numbers | Helps with code navigation |
| `vim.opt.relativenumber = true` | Relative line numbers | Easier vertical movement with `j` and `k` |
| `vim.opt.tabstop = 2` | Tabs = 2 spaces | Web dev standard |
| `vim.opt.expandtab = true` | Use spaces instead of tabs | Consistency across systems |
| `vim.opt.termguicolors = true` | Enable true colors | For beautiful themes |
| `vim.opt.updatetime = 300` | Faster completion (300ms) | Default is 4000ms |

**Why Relative Line Numbers?**

```
Normal:            Relative:
1  function foo()    3  function foo()
2    local x = 1  →  2    local x = 1    ← Cursor here
3    return x       1    return x
4  end              2  end
```

With relative numbers, if you want to move 3 lines up, you just press `3k` (3 + k). Much easier than counting!

---

### 2. plugins.lua (Plugin Manager)

**Purpose:** Defines all plugins to install and their configurations.

**Structure:**

```lua
require("lazy").setup({
  -- Plugin 1
  {
    "author/plugin-name",
    config = function()
      -- Configuration here
    end,
  },

  -- Plugin 2
  { "author/plugin2" },
})
```

**Plugin Categories:**

#### A. LSP & Completion

| Plugin | Purpose |
|--------|---------|
| **mason.nvim** | Package manager for LSP servers |
| **mason-lspconfig.nvim** | Bridges Mason and nvim-lspconfig |
| **nvim-lspconfig** | LSP client configurations |
| **nvim-cmp** | Autocompletion engine |
| **LuaSnip** | Snippet engine |

#### B. File Navigation

| Plugin | Purpose |
|--------|---------|
| **nvim-tree.lua** | File explorer sidebar |
| **telescope.nvim** | Fuzzy finder for files/content |
| **nvim-web-devicons** | File icons (📁 📄 📝) |

#### C. Editing

| Plugin | Purpose |
|--------|---------|
| **nvim-treesitter** | Advanced syntax highlighting |
| **gitsigns.nvim** | Git change indicators in gutter |

#### D. UI

| Plugin | Purpose |
|--------|---------|
| **lualine.nvim** | Status line at bottom |
| **tokyonight.nvim** | Color scheme |

**Plugin Loading Options:**

```lua
{
  "author/plugin",

  -- Load immediately (not lazy)
  lazy = false,

  -- Load on specific event
  event = "BufReadPost",

  -- Load on command
  cmd = "Telescope",

  -- Load on keybinding
  keys = { "<leader>ff" },

  -- Run command after install
  build = ":TSUpdate",

  -- Plugin configuration
  config = function()
    require("plugin").setup()
  end,
}
```

---

### 3. lsp.lua (LSP Configuration)

**Purpose:** Configures Language Servers for intelligent code features.

**What is LSP?**

LSP (Language Server Protocol) provides:
- ✨ Autocompletion
- 🔍 Go to definition
- 📚 Hover documentation
- ⚠️ Error checking (diagnostics)
- 🔧 Code actions (quick fixes)
- 🔄 Find references

**File Structure:**

```lua
local M = {}              -- Module declaration

local servers = {         -- List of LSP servers
  "ts_ls",               -- TypeScript
  "pyright",             -- Python
  "intelephense",        -- PHP
}

local function on_attach(client, bufnr)
  -- Key mappings for when LSP attaches to buffer
end

function M.setup_servers()
  -- Setup Mason + configure each LSP server
end

return M                 -- Export module
```

**Key Functions:**

#### `on_attach(client, bufnr)`

Called when LSP attaches to a buffer. Sets up buffer-local key mappings.

**Why `on_attach`?**

LSP features only work when a language server is attached to your file. `on_attach` ensures key mappings are set up at the right time.

**Key Mappings Set:**

| Key | Action | Use Case |
|-----|--------|----------|
| `gd` | Go to definition | See where function is defined |
| `gD` | Go to type definition | See type of variable (TypeScript) |
| `gr` | Find references | See all places where symbol is used |
| `K` | Hover documentation | Show function/docs in popup |
| `<leader>ca` | Code actions | Quick fixes, refactorings |
| `<leader>rn` | Rename symbol | Smart rename across files |

#### `M.setup_servers()`

Configures which LSP servers to install and use.

```lua
-- 1. Tell Mason which servers to install
mason_lspconfig.setup({
  ensure_installed = servers,
})

-- 2. Get completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 3. Setup each server
for _, server_name in ipairs(servers) do
  lspconfig[server_name].setup({
    capabilities = capabilities,  -- Connect to autocompletion
    on_attach = on_attach,       -- Set up key mappings
  })
end
```

---

### 4. keymaps.lua (Key Mappings)

**Purpose:** Defines global keybindings for Neovim.

**Leader Key Explained:**

The leader key is a "prefix" key for custom commands. We set it to SPACE.

```
<leader>ff  = Press SPACE, then 'f', then 'f'
<leader>w   = Press SPACE, then 'w'
```

**Mapping Categories:**

#### A. File Operations

```lua
keymap("n", "<leader>ff", function() ... end)
--         │  └─ Function to call
--         │
--         └─ Keybinding: <Space> + f + f
```

| Key | Action | Mode |
|-----|--------|------|
| `<leader>ff` | Find files | Normal |
| `<leader>fg` | Search in files | Normal |
| `<leader>e` | Toggle file tree | Normal |

#### B. Window Navigation

```lua
keymap("n", "<C-h>", "<C-w>h")
-- Ctrl + h = Move to left window
```

#### C. Buffer (Tab) Management

```lua
keymap("n", "<leader>bn", ":bnext<CR>")
-- <Space> + b + n = Next buffer
```

**Modes Explained:**

| Mode | Meaning | When Active |
|------|---------|-------------|
| `"n"` | Normal mode | When not editing text |
| `"v"` | Visual mode | When text is selected |
| `"i"` | Insert mode | When typing text |

---

### 5. completion.lua (Autocompletion)

**Purpose:** Configures nvim-cmp for intelligent autocompletion.

**How Autocompletion Works:**

```
You type: con│
           └─ Cursor

nvim-cmp shows:
console        [LSP]
confirm        [Buffer]
config         [Snippet]
```

**Completion Sources (Priority Order):**

```lua
sources = {
  { name = "nvim_lsp" },  -- LSP suggestions (highest priority)
  { name = "luasnip" },   -- Code snippets
  { name = "buffer" },    -- Words in current file
  { name = "path" },      -- File paths
}
```

**Key Mappings:**

| Key | Action |
|-----|--------|
| `Ctrl+n` | Next completion item |
| `Ctrl+p` | Previous completion item |
| `Enter` | Accept completion |
| `Tab` | Next snippet placeholder |
| `Ctrl+Space` | Trigger completion manually |

**Icons Explained:**

```lua
Function [󰊕]  - Function icon
Variable [󰀫]  - Variable icon
Class    [󰠱]  - Class icon
```

---

## Key Concepts

### 1. Modular Configuration

Instead of one huge file, we split config into modules:

```lua
-- init.lua
require("keymaps")      -- Load key mappings
require("plugins")      -- Load and install plugins
require("lsp")          -- Load LSP setup
require("completion")   -- Load completion
```

**Benefits:**
- Easier to find and edit code
- Can comment out entire features
- More organized

### 2. Lazy Loading

Plugins load only when needed:

```lua
-- Load immediately
{ "plugin", lazy = false }

-- Load when opening a file
{ "plugin", event = "BufReadPost" }

-- Load when pressing a key
{ "plugin", keys = "<leader>ff" }
```

**Why?** Faster startup time!

### 3. Module Pattern

Each Lua file uses the module pattern:

```lua
-- Declaration
local M = {}

-- Public functions
function M.setup()
  -- Do something
end

-- Export
return M
```

**Usage in other files:**

```lua
local mymodule = require("mymodule")
mymodule.setup()
```

### 4. LSP Workflow

```
1. You open a file (e.g., index.ts)
2. Neovim detects filetype = "typescript"
3. LSP client attaches to buffer
4. on_attach() runs → Sets up key mappings
5. You can now use: gd, K, <leader>ca, etc.
```

---

## How Everything Works Together

### Startup Sequence

```
1. Neovim starts
   └─> Reads init.lua

2. init.lua:
   ├─> Installs lazy.nvim
   ├─> Sets leader key
   ├─> Configures basic settings
   └─> Loads modules:
       ├─> require("keymaps")     → Sets up global keybindings
       └─> require("plugins")      → Starts lazy.nvim

3. lazy.nvim:
   ├─> Clones plugins from GitHub
   ├─> Loads plugin configs
   │   ├─> mason.nvim setup
   │   ├─> nvim-cmp setup → require("completion")
   │   ├─> nvim-lspconfig setup → require("lsp")
   │   └─> Other plugins...

4. LSP Setup:
   ├─> Mason installs LSP servers
   ├─> nvim-lspconfig configures them
   └─> Servers attach when you open files

5. Ready to use!
```

### Example: Opening a TypeScript File

```
1. You run: nvim src/index.ts

2. Neovim detects filetype = "typescript"

3. ts_ls (TypeScript LSP) attaches:
   ├─> on_attach() runs
   ├─> Key mappings set up (gd, K, gr...)
   └─> Autocompletion enabled

4. You type: console│
   └─> nvim-cmp shows completions from LSP

5. You press K on "console"
   └─> Shows documentation popup

6. You press gd on function name
   └─> Jumps to function definition
```

---

## Customization Guide

### Add a New LSP Server

**1. Edit `lua/lsp.lua`:**

```lua
local servers = {
  "ts_ls",
  "pyright",
  "rust_analyzer",  -- Add this line
}
```

**2. Restart Neovim**

**3. Mason will install it automatically**

### Add a New Plugin

**1. Edit `lua/plugins.lua`:**

```lua
return {
  -- Existing plugins...

  -- Your new plugin
  {
    "author/plugin-name",
    config = function()
      require("plugin").setup({
        -- Options here
      })
    end,
  },
}
```

### Change a Keybinding

**1. Find the keybinding in `lua/keymaps.lua`**

**2. Edit it:**

```lua
-- Change from <leader>ff to <leader>files
keymap("n", "<leader>files", function() ... end)
```

### Add Custom Keybinding

**Add to `lua/keymaps.lua`:**

```lua
-- Example: Open terminal with <leader>tt
keymap("n", "<leader>tt", ":split term://bash<CR>", { desc = "Open terminal" })
```

### Change Color Scheme

**1. Edit `lua/plugins.lua`:**

```lua
-- Find the colorscheme plugin
{
  "folke/tokyonight.nvim",
  config = function()
    -- Change tokyonight to other available themes
    vim.cmd.colorscheme("tokyonight-night")  -- Options: night, storm, day, moon
  end,
},
```

**Available Tokyo Night themes:**
- `tokyonight-night` (default)
- `tokyonight-storm`
- `tokyonight-day`
- `tokyonight-moon`

### Disable a Plugin

**Edit `lua/plugins.lua` and comment it out:**

```lua
-- {
--   "lewis6991/gitsigns.nvim",
--   config = function()
--     require("gitsigns").setup()
--   end,
-- },
```

---

## File-by-File Reference

### init.lua

**What to change here:**
- Basic editor settings (tab size, colors, etc.)
- Leader key (if you don't like SPACE)
- Load order of modules

**What NOT to change here:**
- Plugin configs (use plugins.lua)
- LSP configs (use lsp.lua)
- Key mappings (use keymaps.lua)

### plugins.lua

**What to change here:**
- Add/remove plugins
- Configure plugin settings
- Change when plugins load

**What NOT to change here:**
- LSP server configs (use lsp.lua)

### lsp.lua

**What to change here:**
- Add/remove LSP servers
- Customize LSP key mappings
- Server-specific settings

**What NOT to change here:**
- General key mappings (use keymaps.lua)

### keymaps.lua

**What to change here:**
- Add custom key bindings
- Change existing key bindings
- Window management keys

**What NOT to change here:**
- LSP-specific keys (use lsp.lua)

### completion.lua

**What to change here:**
- Completion sources priority
- Completion key bindings
- Menu appearance

---

## Common Tasks

### Install a New LSP Server

```bash
# Method 1: Automatic (add to lua/lsp.lua)
# Edit lua/lsp.lua, add server name to list, restart nvim

# Method 2: Manual via Mason
nvim
:Mason
# Navigate with j/k, press 'i' to install
```

### Update All Plugins

```bash
nvim
:Lazy
# Press 'U' to update all
```

### Check LSP Status

```bash
nvim your-file.ts
:LspInfo
# Shows which LSP servers are attached
```

### View All Key Mappings

```bash
# In normal mode, press:
<leader>  (space)
# Then wait - shows all leader key mappings

# Or:
:map
# Shows all key mappings
```

### Open Configuration Files Quickly

```bash
# In Neovim, press:
:edit ~/.config/nvim/init.lua
# Or:
:tabedit ~/.config/nvim/lua/plugins.lua
```

---

## Troubleshooting

### LSP Not Working

**Symptom:** No autocomplete, `gd` doesn't work

**Check:**
1. `:LspInfo` - Is server attached?
2. `:Mason` - Is server installed?
3. Filetype correct? `:set filetype?`

### Plugins Not Installing

**Symptom:** Errors about missing modules

**Solution:**
1. `:Lazy sync`
2. Check internet connection
3. Clear cache: `rm -rf ~/.local/share/nvim/lazy`

### Key Bindings Not Working

**Check:**
1. Leader key set? `:echo mapleader`
2. Plugin loaded? `:Lazy`
3. Conflict? `:map <key>`

### Performance Issues

**Try:**
1. Reduce `updatetime` in init.lua
2. Disable unused plugins
3. Update Neovim
4. Check plugin performance: `:Lazy profile`

---

## Advanced Topics

### Understanding Autocommands

Autocommands run automatically on events:

```lua
-- Example: Run command when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Remove trailing whitespace before save
  end,
})
```

**Common Events:**
- `BufReadPost` - After opening a file
- `BufWritePre` - Before saving a file
- `FileType` - When filetype is detected
- `VimEnter` - When Neovim starts

### Understanding Buffer-Local Mappings

```lua
vim.keymap.set("n", "gd", buf.definition, { buffer = bufnr })
--                                         └─ Only works in this buffer
```

This is why LSP key mappings only work when LSP is attached!

### Module Lazy-Loading

```lua
-- This doesn't load completion until needed
config = function()
  require("completion").setup()
end,
```

The function inside `config` only runs when the plugin loads!

---

## Git Integration

Two plugins handle git: **gitsigns** (inline change indicators) and **lazygit** (a full git TUI for staging, committing, and pushing).

### gitsigns — inline change markers

Shows added/changed/deleted lines in the sign column automatically. Useful commands:

| Command | Purpose |
|---------|---------|
| `:Gitsigns blame_line` | Blame for the current line |
| `:Gitsigns preview_hunk` | Preview the change under the cursor |
| `:Gitsigns stage_hunk` | Stage the current hunk |
| `:Gitsigns reset_hunk` | Discard the current hunk |
| `:Gitsigns next_hunk` / `prev_hunk` | Jump between changes |

### lazygit — full git TUI (stage, commit, push)

A floating modal that handles the whole git workflow. The right panel shows the diff of whatever file/commit you're on, so it doubles as a visual diff viewer.

| Key | Action |
|-----|--------|
| `<leader>gg` | Open lazygit |
| `<leader>gf` | Find git-tracked files (telescope) |

> Requires the `lazygit` binary on your PATH (already installed). Plugin: `kdheepak/lazygit.nvim`.

**Committing specific files** (inside lazygit, cursor starts in the Files panel):

1. `j` / `k` — move to a file
2. `Space` — stage/unstage that specific file (or `a` to stage everything)
3. `c` — open the commit message prompt, type it, `Enter` to commit
4. `P` (capital) — push
5. `q` — quit back to Neovim

**Other lazygit keys:**

| Key | Action |
|-----|--------|
| `Enter` | Drill into a file's individual hunks/lines (for partial staging) |
| `e` | Edit the file under the cursor — opens it in **this** Neovim as a new tab |
| `?` | Show all lazygit keybindings |

> `e` opens files back in your running Neovim via `~/.config/lazygit/config.yml`
> (`os.edit = nvim --server "$NVIM" --remote-tab ...`). After editing, `q` quits
> lazygit and the file is waiting in a new tab.

### Tabs and panes

lazygit edits open files in **their own tab page**. The clickable items along the top are tabs, *not* windows. Navigate with the keyboard:

| Key / Command | Action |
|---------------|--------|
| `gt` | Next tab |
| `gT` | Previous tab |
| `1gt`, `2gt`, … | Jump to tab number N |
| `:tabclose` | Close the current tab |
| `:tabonly` | Close all tabs except the current one |

**Leader vs. direct keys:** built-in motions (`gt`, `gT`, `gd`, `<C-h>`/`<C-l>`) are typed directly — no leader. Only the custom shortcuts defined in `keymaps.lua` (`<leader>gg`, `<leader>e`, …) use the leader (Space).

---

## Summary

**Your Configuration Has:**

- ✅ Modular architecture (easy to understand)
- ✅ Plugin manager (lazy.nvim)
- ✅ LSP support (TypeScript, Python, PHP, HTML, CSS)
- ✅ Autocompletion (nvim-cmp)
- ✅ File explorer (nvim-tree)
- ✅ Fuzzy finder (telescope)
- ✅ Syntax highlighting (treesitter)
- ✅ Git integration (gitsigns + lazygit)
- ✅ Beautiful UI (lualine, tokyonight)

**Key Files:**
- `init.lua` - Main entry point
- `lua/plugins.lua` - Plugin definitions
- `lua/lsp.lua` - Language servers
- `lua/keymaps.lua` - Key bindings
- `lua/completion.lua` - Autocompletion

**Next Steps:**
1. Try opening different file types
2. Test all key bindings
3. Customize colorscheme
4. Add your own plugins

**Need Help?**
- `:help` - Neovim documentation
- `:Lazy` - Plugin manager
- `:Mason` - LSP server manager
- `:Telescope` - Fuzzy finder

---

*Last updated: 2025*
