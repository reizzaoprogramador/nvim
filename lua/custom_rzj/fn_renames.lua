-- @file: custom_rzj/fn_renames.lua
-- @mission: Configurar atalho para renomear símbolos de forma inteligente em todo o projeto usando o LSP

local function fn_renames()
    -- @desc: Registra o atalho <leader>cr para acionar o rename do LSP sob o cursor
    -- @mission: Mapear o comando de refatoração de renomeação para o modo normal

    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Renomear variável/função via LSP" })
end

return fn_renames()

-- =============================================================
-- @How_To_Use
-- fn_renames()
-- 
-- Pressione <leader>cr no modo normal sobre uma variável ou função para renomeá-la via LSP.
-- ===========================================================