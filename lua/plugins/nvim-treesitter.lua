-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
local status_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not status_ok then
  return
end

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
treesitter.setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    'c',
    'awk',
    'lua',
    'python',
    'rust',
    'heex',
    'elixir',
    'erlang',
    'css',
    'html',
    'javascript',
    'typescript',
    'json',
    'yaml',
    'vim',
    'vimdoc',
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  auto_install = true,
  ignore_install = {},
  modules = {},

  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = { 'python' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ["am"] = "@module.outer",
        ["im"] = "@module.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>pa'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>pA'] = '@parameter.inner',
      },
    },
  },
}
