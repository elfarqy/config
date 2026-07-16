-- ============================================================================
-- Neovim Modern IDE Configuration
-- ============================================================================
-- This is the main entry point for your Neovim configuration.
-- It sets up the plugin manager (lazy.nvim) and loads all modules.
-- ============================================================================

-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- use latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key to SPACE (must be done before plugins load)
-- This allows us to use <Space> as a modifier key for keybindings
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Basic Neovim Settings
-- ============================================================================

-- Line numbers
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers (helps with movement)

-- Indentation (uses 2 spaces by default - common in TypeScript/JavaScript)
vim.opt.tabstop = 2             -- Number of spaces tabs count for
vim.opt.shiftwidth = 2          -- Number of spaces for indentation
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.smartindent = true      -- Auto-indent on new lines

-- Search settings
vim.opt.ignorecase = true       -- Case-insensitive search
vim.opt.smartcase = true        -- Case-sensitive when uppercase present

-- Appearance
vim.opt.termguicolors = true    -- Enable true color support
vim.opt.signcolumn = "yes"      -- Always show sign column (prevents text shifting)
vim.opt.cursorline = true       -- Highlight current line

-- Clipboard (OSC 52 for SSH/remote sessions — works with any OSC-52 terminal
-- such as Alacritty or kitty, forwarded through tmux).
--
-- copy:  writes an OSC 52 escape straight to the controlling terminal so the
--        text lands in the *local* clipboard.
-- paste: returns the last text copied this way from a local cache, rather than
--        querying the terminal for its clipboard. Terminals rarely answer OSC 52
--        read requests over SSH, and that unanswered query coming back empty was
--        the old "Nothing in register" (E353) error on `p` after `y`.
vim.opt.clipboard = "unnamedplus"

local osc52_cache = {}

local function osc52_copy(reg)
  return function(lines, regtype)
    osc52_cache[reg] = { lines, regtype }
    local encoded = vim.base64.encode(table.concat(lines, "\n"))
    local tty = io.open("/dev/tty", "w")
    if tty then
      tty:write(string.format("\x1b]52;c;%s\x07", encoded))
      tty:close()
    end
  end
end

local function osc52_paste(reg)
  return function()
    return osc52_cache[reg] or { { "" }, "v" }
  end
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = { ["+"] = osc52_copy("+"), ["*"] = osc52_copy("*") },
  paste = { ["+"] = osc52_paste("+"), ["*"] = osc52_paste("*") },
}

-- Performance
vim.opt.updatetime = 300        -- Faster completion (default is 4000ms)
vim.opt.timeoutlen = 500        -- Faster key sequence completion

-- Split windows (more intuitive: split goes to right/bottom)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- =============================================================================
-- Load Configuration Modules
-- =============================================================================

-- Load key mappings first (doesn't depend on plugins)
require("keymaps")

-- Load plugin specifications (this installs and loads all plugins)
-- Plugin modules (lsp, completion) are called from within plugins.lua
-- after plugins are loaded
require("plugins")
