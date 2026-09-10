-- @file: lua/plugins/which-key.lua
-- @mission: Captura e mostra os atalhos no nvim na barra ao acionar o <leader>

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300 -- Tempo em milissegundos para a janela aparecer
  end,
  config = function(_, opts)
    local wk = require("which-key")

    -- Aplica as opções padrão do plugin
    wk.setup(opts)

    -- Registra os nomes e categorias nos modos Normal e Visual
    wk.add({
      {
        mode = { "n", "v" },
        { "<leader>c", group = "Change +Comments" },
        { "<leader>f", group = "Telescope +Buscas" },
        { "<leader>r", group = "+Reloads/Registers" },
        { "<leader>w", group = "Write / Gravacoes/ Escritas" },
        { "<leader>b", group = "Buffers" },
        { "<leader>g", group = "Go/Ir/Views" },
      },
    })
  end,
}

--[[ README: 
- Este plugin which-key: lê o campo 'desc' automaticamente dos seus keymaps.
- A função config() é onde o plugin é iniciado e onde definimos os rótulos visuais
  dos grupos de teclas para organizar a janela pop-up.
]]
