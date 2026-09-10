-- @file: ~/.config/nvim/lua/plugins/git.lua
-- @mission: Configuração de painel Git visual estilo IDE (VS Code experience)

return {
  -- 1. Detalhes na margem esquerda (igual ao VS Code)
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "┆" },
      },
      current_line_blame = true, -- Mostra quem mexeu na linha discretamente
    },
  },

  -- 2. Painel lateral/central estilo Source Control do VS Code
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim", -- Visualizador de diffs lado a lado
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gs", "<cmd>Neogit<cr>", desc = "Painel Git (Estilo VS Code)" },
    },
    opts = {
      kind = "tab", -- Abre em uma aba limpa dedicada para gerenciar tudo
      integrations = {
        telescope = true,
        diffview = true,
      },
    },
  },
}

-- ==============================================================================
-- @README_File
--
-- @IMPORTANTE_PROFILE: Pressione <leader>gs para abrir a aba de controle de versão.
-- Interface organizada em blocos expansíveis idêntica à lógica de painéis de IDEs.
-- ==============================================================================