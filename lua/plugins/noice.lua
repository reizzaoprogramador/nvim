-- @file: ~/.config/nvim/lua/plugins/noice.lua
-- @mission: Ativar a barra de comandos e notificações flutuantes na tela (estilo LazyVim)

return {
  "folke/noice.nvim",
  cond = not vim.g.vscode, -- Desativa o Noice quando rodar dentro do VSCodium
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- Evita conflitos caso você decida usar LSPs no futuro
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylua_num_args"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,    -- Mantém a barra de busca flutuando também
        command_palette = true,   -- Centraliza a barra de comandos (o cmdline clássico ':' vira flutuante!)
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,    -- Bordas arredondadas nos popups do sistema
      },
    })
  end
}
