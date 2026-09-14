-- @file: $ONVIM/lua/plugins/which_key.lua
-- @mission: Exibir menu flutuante interativo de atalhos ao pressionar a tecla Leader

local M = {}

function M.setup()
    -- 1. Registra e carrega via vim.pack
    vim.pack.add({
        "https://github.com/folke/which-key.nvim",
    })
    vim.cmd("packadd which-key.nvim")

    -- 2. Configuração do plugin
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
        wk.setup({
            preset = "classic",
            delay = 300, -- Tempo em ms para abrir o painel após apertar a Leader
        })

        -- Registra grupos visuais de atalhos
        wk.add({
            { "<leader>f", group = "Busca (Telescope)" },
            { "<leader>g", group = "Git (Neogit/Diffview)" },
        })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Painel visual acionado automaticamente ao pressionar a tecla Leader (`<space>`).
-- ==============================================================================
