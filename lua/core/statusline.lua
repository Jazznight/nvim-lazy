local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then return end

-- 使用 core/colors 裡的 dracula 配色
local colors = require('core/colors').dracula

-- vi mode 顏色對應
local vi_mode_colors = {
  NORMAL = colors.cyan, INSERT = colors.green, VISUAL = colors.yellow,
  OP = colors.cyan, BLOCK = colors.cyan, REPLACE = colors.red,
  ['V-REPLACE'] = colors.red, ENTER = colors.orange, MORE = colors.orange,
  SELECT = colors.yellow, COMMAND = colors.pink, SHELL = colors.pink,
  TERM = colors.pink, NONE = colors.yellow,
}

-- LSP diagnostics component
local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic', 'nvim_lsp' },
  symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
  sections = { 'error', 'warn', 'info', 'hint' },
  colored = true,
  update_in_insert = false,
  always_visible = false,
}

-- scroll bar 版本
local scroll_bar = function()
  return vim.fn["feline.providers.file"].scroll_bar()
end

local function show_windsurf()
  -- codeium.nvim 中的 status_string() 會回傳 "3/8", "0", "*" 等狀態
  local s = require('codeium').status_string()
  return s ~= '' and 'WS ' .. s or ''
end

lualine.setup {
  options = {
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
    --theme = 'onedark',
    theme = {
      normal = { a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
                 b = { fg = colors.fg, bg = colors.bg },
                 c = { fg = colors.fg, bg = colors.bg }},
      insert = { a = { fg = colors.bg, bg = colors.green, gui = 'bold' }},
      visual = { a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' }},
      replace = { a = { fg = colors.bg, bg = colors.red, gui = 'bold' }},
      command = { a = { fg = colors.bg, bg = colors.pink, gui = 'bold' }},
      inactive = { a = { fg = colors.fg, bg = colors.bg }}
    },
    -- component_separators = { left = ' ', right = ' ' },
    -- section_separators = { left = '', right = '' },
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', icon = ' ', color = { fg = colors.pink } },
      diagnostics,
      'diff',
    },
    lualine_c = {
      { 'filename', path = 1, file_status = true,
        fmt = function(str) return ' ' .. str end },
    },
    lualine_x = {
      show_windsurf,
      'filetype',
      {
        'fileformat',
        icons_enabled = true,
        symbols = {
          unix = '',
          dos  = '',
          mac  = '',
        }
      },
      'encoding',
    },
    lualine_y = {
      { 'progress', fmt = function(str) return str .. ' ' end },
      { scroll_bar, color = { fg = colors.fg } },
    },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'nvim-tree', 'quickfix' },
}
