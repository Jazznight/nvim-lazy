-- MUST set leader key before loading any plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core/lazy')
require('core/keymap')
require('core/colors')
require('core/options')
--require('core/statusline')
require('core/lsp')
require('plugins/snacks')
require('plugins/statusline')
require('plugins/nvim-tree')
require('plugins/nvim-treesitter')
require('plugins/nvim-cmp')
require('plugins/elixir-tools')
