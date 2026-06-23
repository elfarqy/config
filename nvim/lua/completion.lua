-- ============================================================================
-- Autocompletion Configuration (nvim-cmp)
-- ============================================================================
-- This configures the autocompletion menu (like VS Code's IntelliSense).
-- It provides suggestions for:
-- - LSP (language server suggestions)
-- - Buffer text (words already in your file)
-- - File paths
-- - Snippets
-- ============================================================================

-- Module declaration
local M = {}

local cmp = require("cmp")

-- ============================================================================
-- Setup nvim-cmp
-- ============================================================================

function M.setup()
  cmp.setup({
    -- Snippet engine configuration
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require("luasnip").lsp_expand(args.body) -- Use LuaSnip for snippet expansion
      end,
    },

    -- Completion sources (order matters = priority)
    sources = cmp.config.sources({
      { name = "nvim_lsp" },     -- LSP completions (highest priority)
      { name = "luasnip" },      -- Snippet completions
      { name = "buffer" },       -- Words in current buffer
      { name = "path" },         -- File path completions
    }),

    -- Mapping for keyboard shortcuts in completion menu
    mapping = cmp.mapping.preset.insert({
      -- Navigate up/down the completion menu
      ["<C-n>"] = cmp.mapping.select_next_item(), -- Ctrl-n = next item
      ["<C-p>"] = cmp.mapping.select_prev_item(), -- Ctrl-p = previous item

      -- Scroll documentation window up/down
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),    -- Ctrl-b = scroll up
      ["<C-f>"] = cmp.mapping.scroll_docs(4),     -- Ctrl-f = scroll down

      -- Confirm (accept) completion
      -- Enter accepts the currently selected completion
      ["<CR>"] = cmp.mapping.confirm({ select = true }),

      -- Ctrl-e closes the completion menu
      ["<C-e>"] = cmp.mapping.abort(),

      -- Tab key for snippet navigation
      -- If a snippet is active, Tab jumps to the next placeholder
      -- Otherwise, it triggers completion
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif require("luasnip").expand_or_jumpable() then
          require("luasnip").expand_or_jump()
        else
          fallback() -- Default Tab behavior (indentation)
        end
      end, { "i", "s" }),

      -- Shift-Tab jumps to previous snippet placeholder
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif require("luasnip").jumpable(-1) then
          require("luasnip").jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),

      -- Ctrl-space triggers completion menu manually
      ["<C-Space>"] = cmp.mapping.complete(),
    }),

    -- Formatting of completion menu
    formatting = {
      -- Customize how completion items appear
      format = function(entry, vim_item)
        -- Add icons to completion items
        -- The 'kind' is determined by the LSP (Function, Variable, etc.)
        vim_item.kind = string.format("%s %s", get_icon(vim_item.kind), vim_item.kind)

        -- Show the source of the completion (LSP, Buffer, etc.)
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]

        return vim_item
      end,
    },

    -- Window appearance
    window = {
      -- Completion menu window
      completion = {
        border = "rounded",      -- Rounded corners
        winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel",
        scrollbar = true,
      },
      -- Documentation window (shows function signatures, etc.)
      documentation = {
        border = "rounded",
        winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocBorder",
        scrollbar = true,
      },
    },

    -- Completion behavior
    completion = {
      -- Automatically show completion menu while typing
      autocomplete = {
        cmp.TriggerEvent.TextChanged,
      },
      -- Complete after typing this many characters
      keyword_length = 1,
      -- Maximum number of completions to show
      completeopt = "menu,menuone,noselect",
    },

    -- Performance optimization
    performance = {
      -- Debounce the completion (in milliseconds)
      debounce = 60,
      -- Throttle the completion (in milliseconds)
      throttle = 30,
      -- Fetching timeout (in milliseconds)
      fetching_timeout = 500,
      -- Maximum number of items to show in the menu
      max_view_entries = 200,
    },
  })

  -- ============================================================================
  -- Completion for specific file types
  -- ============================================================================

  -- Command-line completion (: commands)
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" },
    }),
  })

  -- Search completion (/ and ? searches)
  cmp.setup.cmdline({ "/", "?" }, {
    sources = {
      { name = "buffer" },
    },
  })
end

-- ============================================================================
-- Helper Functions
-- ============================================================================

-- Get icons for completion kinds (Variable, Function, etc.)
-- These icons make it easier to identify the type of completion
function get_icon(kind)
  local icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "󰒓",
    Field = "󰜢",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "󰜰",
    Module = "󰏗",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "󰕘",
    Keyword = "󰌋",
    Snippet = "󰅱",
    Color = "󰏘",
    File = "󰈔",
    Reference = "󰈇",
    Folder = "󰉋",
    EnumMember = "󰕘",
    Constant = "󰏿",
    Struct = "󰙅",
    Event = "󰐛",
    Operator = "󰆕",
    TypeParameter = "󰊄",
  }
  return icons[kind] or "󰉿" -- Default icon if kind not found
end

return M
