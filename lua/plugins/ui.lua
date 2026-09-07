-- ~/.config/nvim/lua/plugins/ui.lua (ou dentro da lista de plugins do seu lazy.nvim)

return {
  -- 1. Barra de status colorida no rodapé (Lualine)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto', -- Adapta automaticamente as cores do modo ao seu colorscheme
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        }
      })
    end
  },

  -- 2. Mostrar buffers abertos como abas no topo (Bufferline)
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          mode = "buffers", -- Exibe os buffers abertos no topo
          diagnostics = "nvim_lsp", -- Mostra erros do LSP se disponível
          separator_style = "slant", -- Estilo visual das abas (slant, Separate, thin)
          show_buffer_close_icons = true,
          show_close_icon = false,
        }
      })
    end
  }
}
