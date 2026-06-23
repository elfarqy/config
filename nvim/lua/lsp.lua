-- ============================================================================
-- LSP (Language Server Protocol) Configuration
-- ============================================================================
-- This file configures Language Servers using Mason + nvim-lspconfig
-- ============================================================================

-- Module declaration
local M = {}

local mason_lspconfig = require("mason-lspconfig")

-- ============================================================================
-- LSP Server List
-- ============================================================================
local servers = {
  "pyright",
  "intelephense",
  "html",
  "cssls",
  "tailwindcss",
  "vtsls",
  "vue_ls",
}

-- ============================================================================
-- Key mappings
-- ============================================================================
local function on_attach(client, bufnr)
  local buf = vim.lsp.buf

  vim.keymap.set("n", "gd", buf.definition, { buffer = bufnr, desc = "Go to definition" })
  vim.keymap.set("n", "gD", buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
  vim.keymap.set("n", "gr", buf.references, { buffer = bufnr, desc = "Find references" })
  vim.keymap.set("n", "gi", buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
  vim.keymap.set("n", "K", buf.hover, { buffer = bufnr, desc = "Hover documentation" })
  vim.keymap.set("n", "<C-k>", buf.signature_help, { buffer = bufnr, desc = "Signature help" })
  vim.keymap.set("n", "<leader>ca", buf.code_action, { buffer = bufnr, desc = "Code actions" })
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { buffer = bufnr, desc = "Line diagnostics" })
  vim.keymap.set("n", "<leader>rn", buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  vim.keymap.set("n", "<leader>fm", function()
    vim.lsp.buf.format({ async = true })
  end, { buffer = bufnr, desc = "Format code" })
end

-- ============================================================================
-- Setup LSP Servers
-- ============================================================================
function M.setup_servers()
  -- Setup Mason to ensure servers are installed
  mason_lspconfig.setup({
    ensure_installed = servers,
  })

  -- Get capabilities from nvim-cmp
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

  -- Configure LSP servers using the new vim.lsp.config API (Neovim 0.11+)
  for _, server_name in ipairs(servers) do
    vim.lsp.config(server_name, {
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end

  local mason_pkgs = vim.fn.stdpath("data") .. "/mason/packages"
  local vue_ts_plugin = mason_pkgs .. "/vue-language-server/node_modules/@vue/typescript-plugin"

  -- vue_ls runs in hybrid mode (default in 3.x): it handles the SFC/template,
  -- and delegates all TypeScript to vtsls via the @vue/typescript-plugin below.
  vim.lsp.config("vue_ls", {
    cmd = { mason_bin .. "/vue-language-server", "--stdio" },
    capabilities = capabilities,
    on_attach = on_attach,
  })

  -- vtsls must attach to .vue files and load the Vue TS plugin so it can
  -- serve TypeScript inside <script> blocks.
  vim.lsp.config("vtsls", {
    cmd = { mason_bin .. "/vtsls", "--stdio" },
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_ts_plugin,
              languages = { "vue" },
              configNamespace = "typescript",
            },
          },
        },
      },
    },
  })

  -- Start the LSP servers for new buffers automatically
  vim.lsp.enable(servers)
end

return M
