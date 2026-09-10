-- @file: custom_rzj/fn_atalhosLspNative.lua
-- @mission: Configurar os atalhos nativos do LSP para navegação de código (definição, hover e referências)

local function fn_atalhosLspNative()
    -- @desc: Registra os atalhos gd, gh e gr para interagir com o servidor LSP ativo no buffer atual
    -- @mission: Mapear comandos de inspeção de código para o modo normal respeitando o padrão modular

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Ir para definição" })
    vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Ver documentação (Hover)" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Ver referências" })
end

return fn_atalhosLspNative()

-- =============================================================
-- @How_To_Use
-- fn_atalhosLspNative()
-- 
-- Pressione gd para ir à definição, gh para ver o hover/documentação e gr para buscar referências.
-- ===========================================================