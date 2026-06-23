-- ============================================================================
-- Plugin Configuration (lazy.nvim)
-- ============================================================================
-- This file defines all plugins to be installed by lazy.nvim.
-- lazy.nvim automatically installs, updates, and configures plugins.
-- ============================================================================

require("lazy").setup({
  -- ==========================================================================
  -- LSP & Completion (Language Server Protocol)
  -- ==========================================================================

  -- Mason: Portable package manager for LSP servers, DAP, linters, and formatters
  -- This makes it easy to install language servers without manual configuration
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-LSPConfig: Bridge between Mason and nvim-lspconfig
  -- Automatically installs LSP servers defined in lsp.lua
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },

  -- nvim-lspconfig: Quickstart configurations for LSP clients
  -- Provides default configurations for various language servers
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- LSP completion source for nvim-cmp
    },
    config = function()
      -- LSP configuration is loaded from lua/lsp.lua
      require("lsp").setup_servers()
    end,
  },

  -- ==========================================================================
  -- Autocompletion
  -- ==========================================================================

  -- nvim-cmp: Autocompletion framework (like VS Code IntelliSense)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",             -- Snippet engine
      "saadparwaiz1/cmp_luasnip",     -- Snippet completion source
      "hrsh7th/cmp-nvim-lsp",         -- LSP completion source
      "hrsh7th/cmp-buffer",           -- Buffer text completion
      "hrsh7th/cmp-path",             -- File path completion
    },
    config = function()
      require("completion").setup()
    end,
  },

  -- LuaSnip: Snippet engine for Neovim
  -- Provides snippet expansion and navigation
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" }, -- Collection of useful snippets
  },

  -- ==========================================================================
  -- File Explorer & Fuzzy Finder
  -- ==========================================================================

  -- nvim-tree: File explorer sidebar (like VS Code file tree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- File icons
    config = function()
      -- Disable netrw (Vim's built-in file explorer) in favor of nvim-tree
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30, -- Width of the file tree
        },
        renderer = {
          group_empty = true, -- Compact empty folders
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
            },
          },
        },
        filters = {
          dotfiles = false, -- Show hidden files (set to true to hide)
        },
      })
    end,
  },

  -- nvim-web-devicons: File icons (adds icons to files in nvim-tree, telescope, etc.)
  "nvim-tree/nvim-web-devicons",

  -- Telescope: Fuzzy finder for files, text, git commits, etc.
  -- One of the most powerful plugins in the Neovim ecosystem
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Required utility functions
    config = function()
      local builtin = require("telescope.builtin")

      -- Keybindings are defined in lua/keymaps.lua
      -- Store builtin reference for use there
      _G.telescope_builtin = builtin
    end,
  },

  -- plenary: Required dependency for telescope and many other plugins
  { "nvim-lua/plenary.nvim", lazy = false }, -- Load immediately (not lazy)

  -- ==========================================================================
  -- Syntax Highlighting & Editing
  -- ==========================================================================

  -- nvim-treesitter: Advanced syntax highlighting and code parsing
  -- Provides much better highlighting than standard regex-based highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Automatically install parsers when plugin is installed/updated
    event = { "BufReadPost", "BufNewFile" }, -- Load when opening a file (not immediately)
    config = function()
      -- Safe require in case plugin isn't fully installed yet
      local ok, treesitter = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end

      treesitter.setup({
        -- Install parsers for these languages
        ensure_installed = {
          "lua",       -- For editing Neovim config
          "typescript", -- TypeScript
          "javascript", -- JavaScript
          "python",     -- Python
          "php",        -- PHP
          "html",       -- HTML
          "css",        -- CSS
          "json",       -- JSON
        },

        -- Install parsers synchronously (required for the first run)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        highlight = {
          enable = true,        -- Enable syntax highlighting
          additional_vim_regex_highlighting = false, -- Disable default highlighting for performance
        },

        indent = {
          enable = true,        -- Enable smart indentation
        },
      })
    end,
  },

  -- ==========================================================================
  -- Optional: Git Integration (gitsigns.nvim)
  -- ==========================================================================
  -- Shows git changes (additions/deletions) in the sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- lazygit.nvim: Full git TUI inside Neovim (stage files, commit, push)
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LazyGit", "LazyGitFilter", "LazyGitCurrentFile" },
  },

  -- ==========================================================================
  -- Optional: Status Line (lualine.nvim)
  -- ==========================================================================
  -- Beautiful status line at the bottom (shows mode, filename, git branch, etc.)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- Automatically sets theme based on colorscheme
        },
      })
    end,
  },

  -- ==========================================================================
  -- Optional: Color Scheme
  -- ==========================================================================
  -- A popular, clean colorscheme (you can change this to your preference)
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- Load at startup (not lazy)
    priority = 1000, -- Load before other plugins
    config = function()
      -- Set the colorscheme
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}, {
  -- lazy.nvim configuration options
  ui = {
    -- A border around the lazy.nvim floating window
    border = "rounded",
  },
  -- Display a startup time report
  performance = {
    cache = {
      enabled = true,
    },
  },
})
