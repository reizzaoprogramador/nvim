-- @file: ~/.config/nvim/lua/snippets/ft/go.lua
-- @mission: Snippets nativos em Lua para Go (Golang)

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("go", {
  -- Atalho: soma
  s("soma", {
    t({ "func soma(x int, y int) int {", "\t" }),
    i(1, "op := x + y"),
    t({ "", "\t" }),
    i(2, "return op"),
    t({ "", "}" }),
  }),

  -- Atalho: prin -> fmt.Println(...)
  s("prin", {
    t('fmt.Println("'),
    i(1, "mensagem"),
    t('")'),
  }),

  -- Atalho: fn -> func nome(args) retorno { ... }
  s("fn", {
    t("func "),
    i(1, "nomeFuncao"),
    t("("),
    i(2, "args"),
    t(") "),
    i(3, "error"),
    t({ " {", "\t" }),
    i(4, "// codigo"),
    t({ "", "}" }),
  }),
})
