-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

--- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
--telescope.load_extension('fzf')
