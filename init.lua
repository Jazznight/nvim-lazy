-- MUST set leader key before loading any plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core/lazy')
require('core/keymap')
require('core/colors')
require('core/options')
--require('core/statusline')
require('core/lsp')
require('plugins/nvim-tree')
require('plugins/nvim-treesitter')
require('plugins/telescope')
require('plugins/nvim-cmp')
require('plugins/alpha-nvim')
require('plugins/elixir-tools')
