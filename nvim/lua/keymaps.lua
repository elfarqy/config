-- ============================================================================
-- Global Key Mappings
-- ============================================================================
-- This file defines key mappings for Neovim that work across all file types.
-- LSP-specific key mappings are defined in lua/lsp.lua
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- Leader Key
-- ============================================================================
-- The leader key is set to SPACE in init.lua
-- This allows using <Space> as a modifier for custom keybindings
-- Example: <Space>ff means press SPACE, then 'f', then 'f'

-- ============================================================================
-- General Editor Key Mappings
-- ============================================================================

-- Clear search highlighting with <Esc>
-- Pressing Escape in normal mode clears the search highlight
keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save and quit shortcuts
-- <leader>w = save (write) file
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
-- <leader>q = quit
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
-- <leader>x = save and quit (exit)
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Window navigation (more intuitive than default Vim)
-- Use Ctrl + hjkl to move between split windows
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to window left" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to window right" })

-- Window resizing
-- <leader> + arrow keys to resize windows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
-- <leader>bn = next buffer
keymap("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- <leader>bp = previous buffer
keymap("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- <leader>bd = delete (close) buffer
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Close buffer" })

-- Move lines up and down (in visual and normal mode)
-- This is very useful for reorganizing code
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Indenting in visual mode
-- With text selected, < and > indent/outdent and reselect
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste behavior
-- When pasting over selected text, don't copy the deleted text to register
keymap("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Quick access to terminal
-- <leader>tt = open terminal in a horizontal split
keymap("n", "<leader>tt", ":split term://bash<CR>", { desc = "Open terminal" })

-- Toggle nvim-tree (file explorer)
-- <leader>e = toggle file explorer
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Focus nvim-tree (file explorer)
-- <leader>ef = focus file explorer
keymap("n", "<leader>ef", ":NvimTreeFocus<CR>", { desc = "Focus file explorer" })

-- ============================================================================
-- Telescope Key Mappings (Fuzzy Finder)
-- ============================================================================

-- Note: telescope_builtin is set in plugins.lua

-- Find files (<leader>ff = "find files")
keymap("n", "<leader>ff", function()
  if _G.telescope_builtin then
    _G.telescope_builtin.find_files()
  else
    print("Telescope not loaded yet. Try again after Neovim finishes loading.")
  end
end, { desc = "Find files" })

-- Live grep (search text in files) (<leader>fg = "find grep")
keymap("n", "<leader>fg", function()
  if _G.telescope_builtin then
    _G.telescope_builtin.live_grep()
  else
    print("Telescope not loaded yet. Try again after Neovim finishes loading.")
  end
end, { desc = "Live grep" })

-- Find buffers (open tabs) (<leader>fb = "find buffers")
keymap("n", "<leader>fb", function()
  if _G.telescope_builtin then
    _G.telescope_builtin.buffers()
  else
    print("Telescope not loaded yet. Try again after Neovim finishes loading.")
  end
end, { desc = "Find buffers" })

-- Find help tags (search Vim's documentation) (<leader>fh = "find help")
keymap("n", "<leader>fh", function()
  if _G.telescope_builtin then
    _G.telescope_builtin.help_tags()
  else
    print("Telescope not loaded yet. Try again after Neovim finishes loading.")
  end
end, { desc = "Find help tags" })

-- Git files (find files tracked by git) (<leader>gf = "git files")
keymap("n", "<leader>gf", function()
  if _G.telescope_builtin then
    _G.telescope_builtin.git_files()
  else
    print("Telescope not loaded yet. Try again after Neovim finishes loading.")
  end
end, { desc = "Find git files" })

-- ============================================================================
-- Diagnostic Key Mappings
-- ============================================================================

-- Go to previous diagnostic
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- Go to next diagnostic
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Show all diagnostics in a list
keymap("n", "<leader>D", vim.diagnostic.setloclist, { desc = "All diagnostics" })

-- Copy file paths to clipboard
keymap("n", "<leader>cp", function() vim.fn.setreg("+", vim.fn.expand("%")) end, { desc = "Copy relative path" })
keymap("n", "<leader>cP", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Copy absolute path" })

-- Lazygit (full git TUI: stage files, commit, push)
keymap("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open lazygit" })

-- ============================================================================
-- Convenience Functions
-- ============================================================================

-- Remove trailing whitespace on save
-- This helps keep your code clean
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
  desc = "Remove trailing whitespace on save",
})

-- Highlight on yank (shows what you just copied)
-- When you yank (copy) text, it will briefly highlight
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})
