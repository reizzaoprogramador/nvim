-- @file: nvim/lua/core/snippets.lua
-- @mission: Carregar snippets dinâmicos do LuaSnip a partir de ~/.config/nvim/snippets/ft/

local ok, luasnip = pcall(require, "luasnip")
if not ok then return end

-- Habilita auto-snippets e expansão automática se desejar
luasnip.config.set_config({
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
})

-- Carrega todos os snippets .lua dentro de ~/.config/nvim/snippets/ft/
local snippets_path = vim.fn.stdpath("config") .. "/snippets/ft"
require("luasnip.loaders.from_lua").lazy_load({
  paths = { snippets_path },
})
