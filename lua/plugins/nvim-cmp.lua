local status_ok, cmp = pcall(require, 'cmp')
if not status_ok then
  return
end

local luasnip_status_ok, luasnip = pcall(require, 'luasnip')
if not luasnip_status_ok then
  return
end

local lspkind_status_ok, lspkind = pcall(require, "lspkind")
if not lspkind_status_ok then
  return
end

local border_opts = {
  border = "single",
  winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
    keyword_length = 2
  },
  window = {
    completion = cmp.config.window.bordered(border_opts),
    documentation = cmp.config.window.bordered(border_opts),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = require('lspkind').cmp_format({
      mode = "symbol",
      maxwidth = 50,
      ellipsis_char = '...',
      symbol_map = { 
        Codeium = "🤖",  -- Windsurf 的圖標
      }
    })
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },

    -- 使用表達式映射讓 Windsurf 優先
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        --cmp.confirm({ select = true })  -- ✅ 核心修改在這
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        --cmp.complete()
        fallback()  -- ✅ 回到預設 Tab 行為
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'codeium' },  -- Windsurf 的 cmp 來源
    { name = 'luasnip' },
  }, {
    { name = 'buffer' }
  }),
}
