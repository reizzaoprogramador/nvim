-- @file: lua/plugins/telescope.lua
-- @mission: Localizador e buscador fuzzy de arquivos e textos

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
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Listar buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Buscar ajuda" })
  end,
}
