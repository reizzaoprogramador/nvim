-- @file: lua/plugins/telescope.lua
-- @mission: Localizador/buscador fuzzy e Dashboard nativo ao iniciar sem arquivos (Corrigido aviso de layout)

return {
  "nvim-telescope/telescope.nvim",
  branch = "master", -- Força o uso da branch atualizada (corrige o erro do ft_to_lang)
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules", "\\.git/" },
        path_display = { "truncate" },
      },
    })

    -- Atalhos de Busca
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Buscar arquivos" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto global" })
    vim.keymap.set("n", "<leader>fw", builtin.current_buffer_fuzzy_find, { desc = "Buscar palavra no arquivo atual" })
    vim.keymap.set("n", "<C-b>", builtin.buffers, { desc = "Listar buffers opcao com Ctr+b" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Listar buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Buscar ajuda" })

    -- Dashboard automático no evento UIEnter (Garante que a UI e o Layout já foram inicializados)
    vim.api.nvim_create_autocmd("UIEnter", {
      callback = function()
        if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
          vim.schedule(function()
            if vim.api.nvim_buf_get_name(0) == "" then
              builtin.find_files({
                prompt_title = "🔍 Dashboard - Arquivos do Projeto",
              })
            end
          end)
        end
      end,
    })
  end,
}

-- ==============================================================================
-- @README_PLUGIN
--
-- Substituído o evento VimEnter por UIEnter no Dashboard automático.
-- Previne a exceção 'utils.lua: attempt to index field layout (a nil value)'
-- garantindo a renderização do tamanho da janela do terminal antes do picker abrir.
-- ==============================================================================
