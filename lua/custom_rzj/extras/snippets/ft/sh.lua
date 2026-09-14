-- @file: ~/.config/nvim/lua/snippets/ft/sh.lua
-- @mission: Snippets nativos para Shell Script / Bash

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("sh", {
  -- Snippet para cabeçalho Bash seguro
  s("sb", {
    t({ "#!/usr/bin/env bash", "set -euo pipefail", "", "" }),
    i(1, "# codigo"),
  }),
})
