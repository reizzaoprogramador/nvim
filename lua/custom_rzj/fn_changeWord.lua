-- @file: custom_rzj/fn_changeWord.lua
-- @mission: Configurar atalho para substituir todas as ocorrências da palavra sob o cursor em todo o arquivo

local function fn_changeWord()
    -- @desc: Registra o atalho <leader>cw para iniciar o comando de substituição global no arquivo utilizando a palavra atual do cursor
    -- @mission: Mapear o comando de busca e substituição rápida para o modo normal

    vim.keymap.set(
        "n",
        "<leader>cw",
        ":%s/\\<<C-r><C-w>\\>/",
        { noremap = true, silent = false, desc = "Substituir palavra sob o cursor (Arquivo)" }
    )
end

return fn_changeWord()

-- =============================================================
-- @How_To_Use
-- fn_changeWord()
-- 
-- Pressione <leader>cw no modo normal para preencher o comando de substituição com a palavra sob o cursor.
-- ===========================================================