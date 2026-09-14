-- @file: $ONVIM/lua/plugins/autopairs.lua
-- @mission: Fechamento automatico de aspas, parenteses e colchetes

local M = {}

function M.setup()
    -- 1. Registra e carrega via vim.pack
    vim.pack.add({
        "https://github.com/windwp/nvim-autopairs",
    })

    vim.cmd("packadd nvim-autopairs")

    -- 2. Configuração do Autopairs
    local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
    if autopairs_ok then
        autopairs.setup({
            check_ts = true, -- Integra com o Treesitter para evitar fechar aspas dentro de strings
        })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Auto-completa pares de caracteres e verifica contexto via Treesitter.
-- ==============================================================================
