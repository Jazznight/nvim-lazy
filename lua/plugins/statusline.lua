-- 建議更新後的 lua/plugins/statusline.lua
local status_ok, lualine = pcall(require, 'lualine')
if not status_ok then return end

local colors = require('core/colors').dracula

-- 2026 現代化 AI 狀態顯示
local function show_ai_status()
  -- 優先檢查 ClaudeCode/Snacks 的狀態
  if package.loaded["snacks"] then
    local snacks_status = require("snacks").profiler.status()
    if snacks_status ~= "" then return "󰚩 " .. snacks_status end
  end
  
  -- 原本的 Windsurf/Codeium 狀態
  local status_ok_codeium, codeium = pcall(require, 'codeium')
  if status_ok_codeium then
    local s = codeium.status_string()
    return s ~= '' and '󱐌 ' .. s or ''
  end
  return ''
end

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'dracula', -- 確保使用一致的配色
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = true, -- 2026 必備全域狀態欄
  },
  sections = {
    lualine_a = { { 'mode', separator = { left = '', right = '' }, right_padding = 2 } },
    lualine_b = { 
      { 'branch', icon = '' },
      { 'diff', colored = true },
      { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } } 
    },
    lualine_c = { 
      { 'filename', path = 1, file_status = true } 
    },
    lualine_x = {
      { show_ai_status, color = { fg = colors.green, gui = 'bold' } }, -- AI 狀態亮顯
      'encoding',
      'fileformat',
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { { 'location', separator = { left = '', right = '' }, left_padding = 2 } },
  },
}
