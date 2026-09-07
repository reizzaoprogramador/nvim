-- @file: ~/.config/nvim/lua/snippets/ft/lua.lua
-- @mission: Snippets nativos em Lua para o Neovim

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("lua", {
  -- Snippet para função
  s("fun", {
    t("function "),
    i(1, "nome"),
    t("("),
    i(2, "args"),
    t({ ")", "  " }),
    i(3, "-- corpo"),
    t({ "", "end" }),
  }),

  -- Snippet para require
  s("req", {
    t("local "),
    i(1, "mod"),
    t(' = require("'),
    i(2, "module"),
    t('")'),
  }),
})
