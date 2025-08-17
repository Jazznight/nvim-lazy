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
    -- Colorscheme:
    -- The colorscheme should be available when starting Neovim.
    {
      'Mofiqul/dracula.nvim', -- Dracula theme
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
    },

    -- copy text to the system clipboard using the ANSI OSC52 sequence
    {
      'ojroques/nvim-osc52',
      lazy = true,
    },

    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', ops={} },

    -- tmux
    {
      'aserowy/tmux.nvim',
      event = "BufReadPre",
      opts = {},

    },

    -- Indent line
    {
      'lukas-reineke/indent-blankline.nvim',
      event = "BufReadPre",
      main="ibl",
      opts = {
        indent = {
         char = "▏",
        },
        exclude = {
          filetypes = {
            'lspinfo',
            'packer',
            'checkhealth',
            'help',
            'man',
            'dashboard',
            'git',
            'markdown',
            'text',
            'terminal',
            'NvimTree',
          },
          buftypes = {
            'terminal',
            'nofile',
            'quickfix',
            'prompt',
          },
        },
      },
    },

    -- Git labels
    {
      'lewis6991/gitsigns.nvim',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        }
      }
    },

    -- Icons
    { 'kyazdani42/nvim-web-devicons', lazy = true },

    -- Dashboard (start screen)
    {
      'goolord/alpha-nvim',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- File explorer
    {
      'kyazdani42/nvim-tree.lua',
      dependencies = { 'kyazdani42/nvim-web-devicons' },
    },

    -- Statusline
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('core.statusline')
      end,
    },

    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
      },
    },

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

        -- Additional lua configuration, makes nvim stuff amazing
        'folke/neodev.nvim',
      }
    },

    {
        -- Useful status updates for LSP
        'j-hui/fidget.nvim',
        tag = "legacy",
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

        -- different completion source
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-cmdline',
        'saadparwaiz1/cmp_luasnip',

        -- Others snippet engine in vscode format
        --'hrsh7th/vim-vsnip',
        --'hrsh7th/cmp-vsnip'
      },
    },

    -- for codeium
    {
      'saghen/blink.cmp',
      dependencies = {
        {
          'Exafunction/codeium.nvim',
        },
      },
      opts = {
        fuzzy = { 
          implementation = "prefer_rust_with_warning",
          prebuilt_binaries = {
            force_version = "v1.4.1"
          }
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'codeium' },
          providers = {
            codeium = { name = 'Codeium', module = 'codeium.blink', async = true },
          },
        },
      },
    },

    -- Lua snippet engine
    {
      'L3MON4D3/LuaSnip',
      -- follow latest release.
	  version = "v2.3",
	  -- install jsregexp (optional!).
	  build = "make install_jsregexp"
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
      "nvim-telescope/telescope.nvim",
      tag = "0.1.8",
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
  
    -- Elixir tools
    {
      "elixir-tools/elixir-tools.nvim",
      version = "*",
      event = { "BufReadPre", "BufNewFile" },
      dependencies = { "nvim-lua/plenary.nvim", },
    },

    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },

    -- Windsurf and codeium
    {
      "Exafunction/windsurf.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
      },
      config = function()
        require('codeium.virtual_text').set_statusbar_refresh(function()
          require('lualine').refresh()
        end)
        require("codeium").setup({
          -- 啟用 virtual text 功能
          virtual_text = {
            enabled = true,
            manual = false,  -- 設為 true 可以手動觸發
            filetypes = {},  -- 可以指定特定文件類型
            default_filetype_enabled = true,
            idle_delay = 75,
            virtual_text_priority = 65535,
            map_keys = true,  -- 禁用默認按鍵映射，由 nvim-cmp 統一處理
            key_bindings = {
              accept = "<C-l>",       -- 啟用 Tab 映射
              accept_word = false,    -- 接受下一個詞
              accept_line = false,    -- 接受下一行
              clear = "<C-x>",        -- 清除 virtual text
              next = "<M-]>",         -- 下一個建議
              prev = "<M-[>",         -- 上一個建議
            }
          }
        })
      end
    },

    -- ClaudeCode
    {
      "coder/claudecode.nvim",
      dependencies = { "folke/snacks.nvim" },
      config = true,
      keys = {
        { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
        { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
        { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
        { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
        { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
        { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
        { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
        { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
      },
    }
})
