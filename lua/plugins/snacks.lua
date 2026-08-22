return {
  -- [未來感通知系統]
  notifier = {
    enabled = true,
    timeout = 3000,    -- 訊息顯示 3 秒
    style = "compact", -- 2026 流行更清爽的緊湊型設計
  },

  -- [2026 極簡風格 Dashboard]
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys",   gap = 1, padding = 1 },
      { section = "startup" },
      {
        text = "󱐌 " .. os.date("%Y/%m/%d %H:%M:%S"),
        align = "center",
        hl = "SnacksDashboardFooter",
        padding = 1,
      },
    },
    preset = {
      -- 根據您原本 alpha-nvim 的按鍵習慣重新配置
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰚩 ", key = "a", desc = "Claude AI", action = ":ClaudeCode" }, -- 2026 必備快速鍵
        { icon = "󰒲 ", key = "u", desc = "Update Plugins", action = ":Lazy update" },
        { icon = " ", key = "s", desc = "Settings", action = ":e $MYVIMRC" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
  },

  -- 其他核心組件
  picker = { enabled = true },
  input = { enabled = true },
  scope = { enabled = true },
  terminal = { enabled = true },
}
