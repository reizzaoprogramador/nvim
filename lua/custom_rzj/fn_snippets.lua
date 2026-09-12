-- @file: custom_rzj/fn_snippets.lua
-- @mission: Configurar a expansão e navegação entre campos de snippets usando o LuaSnip via Tab e Shift-Tab

local function fn_snippets()
    -- @desc: Registra os atalhos para avançar/expandir com <Tab> e retroceder com <S-Tab> nos modos de inserção e seleção
    -- @mission: Mapear teclas de navegação do LuaSnip com fallback seguro para o comportamento padrão do Tab

    vim.keymap.set({ "i", "s" }, "<Tab>", function()
        local ok, luasnip = pcall(require, "luasnip")
        if ok and luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
        end
    end, { silent = true, desc = "Expandir ou avançar campo no LuaSnip" })

    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        local ok, luasnip = pcall(require, "luasnip")
        if ok and luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
        end
    end, { silent = true, desc = "Voltar campo no LuaSnip" })
end

return fn_snippets()

-- =============================================================
-- @How_To_Use
-- fn_snippets()
-- 
-- Pressione <Tab> para expandir snippets ou avançar entre os campos, e <S-Tab> para voltar.
-- ===========================================================