-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter-quickstart`
--
-- nvim-treesitter's `main` branch (what we're on) is a full, incompatible
-- rewrite: there is no more `nvim-treesitter.configs` module and no more
-- single `.setup{ ensure_installed=, highlight=, indent=, textobjects= }`
-- table. Parser install, highlighting, folding, indentation and
-- textobjects are each wired up separately below.
-- nvim-treesitter-textobjects (a separate plugin) was rewritten the same
-- way, see `:help nvim-treesitter-textobjects`.

local ensure_installed = {
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
}

-- Install (or update) the parsers we want. This is async and a no-op for
-- parsers that are already installed, so it's safe to call unconditionally.
require('nvim-treesitter').install(ensure_installed)

-- 'vimdoc' is a parser name; its filetype is 'help'.
local filetypes = vim.tbl_map(function(lang)
  return lang == 'vimdoc' and 'help' or lang
end, ensure_installed)

-- Highlighting, folds and indentation are enabled per-filetype now
-- (previously `highlight.enable`/`indent.enable` in .configs.setup{}).
vim.api.nvim_create_autocmd('FileType', {
  pattern = filetypes,
  callback = function(ev)
    vim.treesitter.start()

    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'

    -- Treesitter indentation is still experimental; keep the classic
    -- indenter for python like the old config did (`indent.disable`).
    if ev.match ~= 'python' then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Incremental selection: nvim-treesitter no longer provides this, but
-- Neovim 0.12 core now has vim.treesitter.select() to do the same thing.
local function ts_select(target)
  return function()
    if vim.fn.mode() == 'n' then
      vim.cmd('normal! v')
    end
    vim.treesitter.select(target)
  end
end
vim.keymap.set({ 'n', 'x' }, '<c-space>', ts_select('parent'), { desc = 'Treesitter: expand selection' })
vim.keymap.set('x', '<c-bs>', ts_select('child'), { desc = 'Treesitter: shrink selection' })

-- Textobjects (nvim-treesitter-textobjects, new API)
local status_ok, textobjects = pcall(require, 'nvim-treesitter-textobjects')
if status_ok then
  textobjects.setup {
    select = {
      lookahead = true, -- jump forward to textobj, like targets.vim
    },
    move = {
      set_jumps = true,
    },
  }

  local select = require('nvim-treesitter-textobjects.select')
  local function select_map(keys, query)
    vim.keymap.set({ 'x', 'o' }, keys, function()
      select.select_textobject(query, 'textobjects')
    end, { desc = 'Textobject: ' .. query })
  end
  select_map('aa', '@parameter.outer')
  select_map('ia', '@parameter.inner')
  select_map('af', '@function.outer')
  select_map('if', '@function.inner')
  select_map('ac', '@class.outer')
  select_map('ic', '@class.inner')
  select_map('am', '@module.outer')
  select_map('im', '@module.inner')

  local move = require('nvim-treesitter-textobjects.move')
  local function move_map(keys, fn, query)
    vim.keymap.set({ 'n', 'x', 'o' }, keys, function()
      move[fn](query, 'textobjects')
    end, { desc = 'Textobject move: ' .. fn .. ' ' .. query })
  end
  move_map(']m', 'goto_next_start', '@function.outer')
  move_map(']]', 'goto_next_start', '@class.outer')
  move_map(']M', 'goto_next_end', '@function.outer')
  move_map('][', 'goto_next_end', '@class.outer')
  move_map('[m', 'goto_previous_start', '@function.outer')
  move_map('[[', 'goto_previous_start', '@class.outer')
  move_map('[M', 'goto_previous_end', '@function.outer')
  move_map('[]', 'goto_previous_end', '@class.outer')

  local swap = require('nvim-treesitter-textobjects.swap')
  vim.keymap.set('n', '<leader>pa', function()
    swap.swap_next('@parameter.inner')
  end, { desc = 'Textobject: swap parameter with next' })
  vim.keymap.set('n', '<leader>pA', function()
    swap.swap_previous('@parameter.inner')
  end, { desc = 'Textobject: swap parameter with previous' })
end
