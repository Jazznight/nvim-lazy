-----------------------------------------------------------
-- Define keymaps of Neovim and installed plugins.
-----------------------------------------------------------

local function map(mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- [[ Basic Keymaps ]]
-- Leader key is set in init.lua before plugins load
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Change split orientation
map('n', '<leader>tk', '<C-w>t<C-w>K') -- change vertical to horizontal
map('n', '<leader>th', '<C-w>t<C-w>H') -- change horizontal to vertical

-- Move around splits using Ctrl + {h,j,k,l}
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Resize around splits using Option + {h,j,k,l}
map('n', '<M-h>', '<C-w><')
map('n', '<M-j>', '<C-w>+')
map('n', '<M-k>', '<C-w>-')
map('n', '<M-l>', '<C-w>>')

-- Clipboard control
map('v', '<leader>y', '"+y')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Tagbar
map('n', '<leader>z', ':TagbarToggle<CR>')          -- open/close

-- NvimTree
map('n', '<leader>n', ':NvimTreeToggle<CR>')        -- open/close


-- 取代原本 keymap.lua 中 Telescope 的部分

-- [?] 尋找最近開啟的檔案
vim.keymap.set('n', '<leader>?', function() Snacks.picker.recent() end, { desc = '[?] Find recently opened files' })
-- [ ] 尋找現有的緩衝區 (Buffers)
vim.keymap.set('n', '<leader><space>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })
-- [SF] 搜尋檔案 (Find Files)
vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files() end, { desc = '[S]earch [F]iles' })
-- [SH] 搜尋幫助文件 (Help Tags)
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })
-- [SW] 搜尋當前游標下的單字 (Grep Word)
vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })
-- [SG] 全域 Grep 搜尋 (Live Grep)
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })
-- [SD] 搜尋診斷資訊 (Diagnostics)
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })

-- 2026 加強版：搜尋 LSP 符號 (取代原本 LSP 中的 Telescope 調用)
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'LSP: [G]oto [R]eferences' })
vim.keymap.set('n', '<leader>ds', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP: [D]ocument [S]ymbols' })

-- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

