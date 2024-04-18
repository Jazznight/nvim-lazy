-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
local status_ok, elixirtools = pcall(require, 'elixir-tools.configs')
if not status_ok then
  return
end

local elixir = require("elixir")
local elixirls = require("elixir.elixirls")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
elixirtools.setup {
  nextls = {enable = true},
  credo = {},
  elixirls = {
    enable = true,
    settings = elixirls.settings {
      dialyzerEnabled = false,
      enableTestLenses = false,
    },
    on_attach = function(client, bufnr)
      vim.keymap.set("n", "<space>efp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("n", "<space>etp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
      vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
    end,
  }
}
