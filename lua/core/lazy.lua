-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: lazy.nvim
-- URL: https://github.com/folke/lazy.nvim

-- For information about installed plugins see the README:
-- neovim-lua/README.md
-- https://github.com/brainfucksec/neovim-lua#readme

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, 'lazy')
if not status_ok then
  print("Lazy loading error.........")
  return
end

-- Start setup
lazy.setup({
  spec = {
    -- Colorscheme:
    -- The colorscheme should be available when starting Neovim.
    {
      'Mofiqul/dracula.nvim', -- Dracula theme
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
    },

    -- tmux
    {
      'aserowy/tmux.nvim',
      lazy = true,
      config = function()
        require('tmux').setup{
          resize = {
            -- enables default keybindings (A-hjkl) for normal mode
            enable_default_keybindings = false
          }
        }
      end
    },

    -- Icons
    { 'kyazdani42/nvim-web-devicons', lazy = true },

    -- Dashboard (start screen)
    {
      'goolord/alpha-nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- Git labels
    {
      'lewis6991/gitsigns.nvim',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
        require('gitsigns').setup{}
      end
    },

    -- File explorer
    {
      'kyazdani42/nvim-tree.lua',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- Statusline
    {
      'freddiehaddad/feline.nvim',
      dependencies = {
        'kyazdani42/nvim-web-devicons',
        'lewis6991/gitsigns.nvim',
      },
    },

    -- Treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Additional text objects via treesitter
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
      },
    },

    -- Indent line
    { 'lukas-reineke/indent-blankline.nvim' },

    -- Tag viewer
    { 'preservim/tagbar' },

    -- Autopair
    {
      'windwp/nvim-autopairs',
      event = 'InsertEnter',
      config = function()
        require('nvim-autopairs').setup{}
      end
    },

    -- LSP
    -- {
    --   "williamboman/mason.nvim",
    --   build = ":MasonUpdate" -- :MasonUpdate updates registry contents
    -- },
    -- { 'williamboman/mason-lspconfig.nvim' },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Useful status updates for LSP
        'j-hui/fidget.nvim',

        -- Additional lua configuration, makes nvim stuff amazing
        'folke/neodev.nvim',
      }
    },

    -- Autocomplete
    {
      'hrsh7th/nvim-cmp',
      -- load cmp on InsertEnter
      event = 'InsertEnter',
      -- these dependencies will only be loaded when cmp loads
      -- dependencies are always lazy-loaded unless specified otherwise
      dependencies = {
        -- For styling
        'onsails/lspkind.nvim',

        -- Lua snippet engine
        'L3MON4D3/LuaSnip',

        -- different completion source
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',

        -- Others snippet engine in vscode format
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-vsnip'
      },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.1",
      lazy = true,
      dependencies = {
          "nvim-lua/plenary.nvim",
          {
              -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
              "nvim-telescope/telescope-fzf-native.nvim",
              build = "make",
              config = function() require("telescope").load_extension("fzf") end,
          },
          "kyazdani42/nvim-web-devicons",
      },
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim' },

    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },

    -- Github copilot
    { 'github/copilot.vim' }
  },
})
