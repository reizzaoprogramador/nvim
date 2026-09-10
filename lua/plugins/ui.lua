-- @file: ~/.config/nvim/lua/plugins/ui.lua
-- @mission: Configuração de componentes visuais da UI e barra de status com indicadores Git

return {
  -- 1. Barra de status colorida no rodapé com indicador Git (estilo VS Code)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
        },
        sections = {
          lualine_b = {
            'branch',
            {
              'diff',
              colored = true,
              symbols = { added = ' ', modified = ' ', removed = ' ' },
            }
          }
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
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = false,
        }
      })
    end
  }
}

-- ==============================================================================
-- @README_File
--
-- @IMPORTANTE_PROFILE: Este arquivo configura a interface visual do Neovim.
-- A barra inferior agora exibe em tempo real o branch atual e o contador de alterações
-- (adições, modificações e remoções) para você saber exatamente o que falta commitar.
--
-- @Como_Usar:
-- O plugin carrega automaticamente ao iniciar o Neovim. O Lualine exibirá o diff do git na seção lualine_b.
-- ==============================================================================