-- @file: custom_rzj/fn_terminal.lua
-- @mission: Configurar atalhos para alternar e controlar o terminal integrado em divisão vertical (vsplit)

local function fn_terminal()
    -- @desc: Registra o atalho tt nos modos normal e terminal para abrir, fechar ou alternar o terminal integrado
    -- @mission: Mapear o gatilho tt para a função de toggle do terminal em split vertical de forma segura

    vim.keymap.set("n", "tt", function()
        require("functions.terminal").toggle_vsplit_terminal()
    end, { desc = "Alternar terminal integrado em vsplit (tt)" })

    vim.keymap.set("t", "tt", "<C-\\><C-n><cmd>lua require('functions.terminal').toggle_vsplit_terminal()<CR>", {
        desc = "Fechar terminal integrado de dentro dele (tt)",
    })
end

return fn_terminal()

-- =============================================================
-- @How_To_Use
-- fn_terminal()
-- 
-- Pressione tt no modo normal para abrir/fechar o terminal, ou tt de dentro do terminal para fechá-lo.
-- ===========================================================