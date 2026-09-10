-- @file: custom_rzj/fn_reload.lua
-- @mission: Configurar atalho para recarregar instantaneamente as configurações do Neovim ($MYVIMRC)

local function fn_reload()
    -- @desc: Registra o atalho <leader>rc para re-sourcear o arquivo de configuração principal do editor
    -- @mission: Mapear o comando de recarregamento rápido para o modo normal

    vim.keymap.set("n", "<leader>rc", function()
        vim.cmd("source $MYVIMRC")
        print("✨ Configurações recarregadas com sucesso!")
    end, { desc = "Recarregar configurações ($MYVIMRC)" })
end

return fn_reload()

-- =============================================================
-- @How_To_Use
-- fn_reload()
-- 
-- Pressione <leader>rc no modo normal para recarregar o arquivo de configuração ($MYVIMRC) em tempo de execução.
-- ===========================================================