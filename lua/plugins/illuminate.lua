-- @file: lua/plugins/illuminate.lua
-- @mission: Destaque inteligente de variáveis sob o cursor (estilo VS Code), ignorando comentários.

return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local illuminate = require("illuminate")

    illuminate.configure({
      -- Provedores em ordem de prioridade (Treesitter ignora comentários automaticamente)
      providers = {
        "lsp",
        "treesitter",
        "regex",
      },
      -- Delay de 100ms para resposta instantânea e fluida
      delay = 100,
      -- Não ilumina dentro de comentários ou strings se não for um símbolo real
      under_cursor = true,
      large_file_cutoff = 2000,
      filetypes_denylist = {
        "NvimTree",
        "TelescopePrompt",
        "harpoon",
        "help",
      },
    })

    -- 🎨 Personalização de Cores Estilo VS Code (Fundo suave em vez de sublinhado)
    local set_hl = vim.api.nvim_set_hl

    -- Destaque para leitura (onde a variável é usada)
    set_hl(0, "IlluminatedWordText", { bg = "#3a3d41", bold = false, underline = false })
    set_hl(0, "IlluminatedWordRead", { bg = "#3a3d41", bold = false, underline = false })

    -- Destaque para escrita (onde a variável é declarada/alterada)
    set_hl(0, "IlluminatedWordWrite", { bg = "#484e5b", bold = false, underline = false })
  end,
}
