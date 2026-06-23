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

-- Clipboard (OSC 52 for SSH/remote sessions — works with Alacritty + tmux)
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = function(lines, _) vim.fn.setreg("+", table.concat(lines, "\n")) end,
    ["*"] = function(lines, _) vim.fn.setreg("*", table.concat(lines, "\n")) end,
  },
  paste = {
    ["+"] = function() return vim.fn.split(vim.fn.getreg("+"), "\n") end,
    ["*"] = function() return vim.fn.split(vim.fn.getreg("*"), "\n") end,
  },
}

-- Send OSC 52 sequence on yank (writes to /dev/tty to bypass Neovim's stdout capture)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local text = table.concat(vim.v.event.regcontents, "\n")
    local encoded = vim.base64.encode(text)
    local tty = io.open("/dev/tty", "w")
    if tty then
      tty:write(string.format("\x1b]52;c;%s\x07", encoded))
      tty:close()
    end
  end,
})

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
