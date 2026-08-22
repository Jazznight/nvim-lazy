-- [[ Setting options ]]
-- See `:help vim.o`

local g = vim.g       -- Global variables
local opt = vim.opt   -- Set options (global/buffer/windows-scoped)

local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

g.python3_host_prog = '~/.pyenv/versions/3.9.21/bin/python3.9'
g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-----------------------------------------------------------
-- General
-----------------------------------------------------------
opt.mouse = 'a'                       -- Enable mouse support
opt.swapfile = false                  -- Don't use swapfile
opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options
-- vim.o.completeopt = 'menuone,noselect'

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true           -- Show line number
opt.relativenumber = true   -- Show line number
opt.showmatch = true        -- Highlight matching parenthesis
opt.foldmethod = 'marker'   -- Enable folding (default 'foldmarker')
opt.colorcolumn = '80'      -- Line lenght marker at 80 columns
opt.splitright = true       -- Vertical split to the right
opt.splitbelow = true       -- Horizontal split to the bottom
opt.ignorecase = true       -- Ignore case letters when search
opt.smartcase = true        -- Ignore lowercase for the whole pattern
opt.linebreak = true        -- Wrap on word boundary
opt.termguicolors = true    -- Enable 24-bit RGB colors
opt.laststatus=3            -- Set global statusline

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true        -- Use spaces instead of tabs
opt.shiftwidth = 2          -- Shift 4 spaces when tab
opt.tabstop = 2             -- 1 tab == 4 spaces
opt.smartindent = true      -- Autoindent new lines

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true           -- Enable background buffers
opt.history = 100           -- Remember N lines in history
opt.lazyredraw = true       -- Faster scrolling
opt.synmaxcol = 240         -- Max column for syntax highlight


-----------------------------------------------------------
-- Legecy settings
-----------------------------------------------------------
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set highlight on search
vim.o.hlsearch = false

-- Save undo history
vim.o.undofile = true

vim.wo.signcolumn = 'yes'

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- [[ 2026 效能與 UI 優化 ]]
local opt = vim.opt

-- 1. 渲染優化
opt.updatetime = 200             -- 更快的反應速度 (預設 4000)
opt.timeoutlen = 300             -- 縮短快捷鍵等待時間，手感更利落
opt.redrawtime = 1500            -- 限制語法高亮渲染時間，防止大檔案卡頓
opt.cursorlineopt = "number"     -- 僅高亮行號而非整行，減少渲染重繪負擔

-- 2. 現代化 UI 體驗
opt.smoothscroll = true          -- 2026 標準：啟用原生平滑捲動
opt.pumblend = 10                -- 讓補全選單稍微透明，更有未來感
opt.winblend = 10                 -- 讓浮動視窗稍微透明
opt.confirm = true               -- 退出未存檔檔案時彈出確認視窗，而非直接報錯

-- 3. 2026 棄用修正與行為調整
-- 修正 client.supports_method 相關的預設行為
vim.g.rendered_cursorline = true 
opt.shortmess:append "WcC"       -- 減少不必要的冗長訊息輸出


-- -- Disable builtin plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
   "tutor",
   "rplugin",
   "synmenu",
   "optwin",
   "compiler",
   "bugreport",
   "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end
