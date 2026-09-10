-- @file: ~/.config/nvim/lua/plugins/autopairs.lua
-- @mission: Configuração isolada do fechamento automático de chaves, parênteses e crases

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")

    npairs.setup({
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {},
    })

    -- Regra explícita para fechar crase e posicionar o cursor no meio
    local Rule = require("nvim-autopairs.rule")
    npairs.add_rules({
      Rule("`", "`"),
    })
  end,
}
