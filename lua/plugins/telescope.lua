-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

local actions = require('telescope.actions')
telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,  -- 禁用 <C-u> 清空輸入框的預設行為
        ['<C-d>'] = false,  -- 禁用 <C-d> 刪除多行或預設下移的行為
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = { -- 正常模式
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
}

--- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
--telescope.load_extension('fzf')
