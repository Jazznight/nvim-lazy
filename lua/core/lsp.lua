-- lua/core/lsp.lua
-- Neovim 0.11+ native LSP config.
-- Mason installs servers; mason-lspconfig enables them with vim.lsp.enable().
-- blink.cmp provides LSP capabilities.

local servers = {
  "lua_ls",
  "rust_analyzer",
  "pyright",
  "ts_ls",
  "elixirls",
  "jsonls",
  "yamlls",
  "bashls",
  "dockerls",
  "docker_compose_language_service",
}

-- Global LSP keymaps/autocmds: preferred over per-server on_attach.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local function nmap(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap("gr", function()
      Snacks.picker.lsp_references()
    end, "[G]oto [R]eferences")
    nmap("<leader>ds", function()
      Snacks.picker.lsp_symbols()
    end, "[D]ocument [S]ymbols")
    nmap("<leader>ws", function()
      Snacks.picker.lsp_workspace_symbols()
    end, "[W]orkspace [S]ymbols")

    -- Avoid deprecated client.supports_method form.
    if client:supports_method("textDocument/formatting", bufnr) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("user-lsp-format-" .. bufnr, { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 3000,
            -- Prefer a real formatter plugin later if you add conform.nvim.
            -- filter = function(c) return c.name ~= "ts_ls" end,
          })
        end,
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = true },
})

-- blink.cmp adds LSP completion capabilities.
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Server-specific overrides. nvim-lspconfig 2.x exposes defaults through vim.lsp.config().
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim", "Snacks" } },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
    },
  },
})

vim.lsp.config("pyright", {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("ts_ls", {
  capabilities = capabilities,
})

vim.lsp.config("elixirls", {
  capabilities = capabilities,
})

for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = servers,
  -- We call vim.lsp.enable() above after applying per-server config,
  -- so keep Mason from enabling servers first with incomplete config.
  automatic_enable = false,
})
