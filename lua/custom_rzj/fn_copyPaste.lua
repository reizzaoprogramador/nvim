-- @file: custom_rzj/fn_copyPaste.lua
-- @mission: Modulo customizado de clipboard e registradores via API Lua nativa para cópia e colagem integrada

local function fn_copyPaste()
    -- @desc: Gerencia a integração de cópia e colagem com o clipboard do sistema nos modos normal, inserção e visual
    -- @mission: Unificar lógica de clipboard, atalhos de Ctrl+C / Ctrl+V e mapeamentos auxiliares em um único arquivo modular

    local function paste_system_clipboard()
        local text = vim.fn.getreg("+")
        if text and text ~= "" then
            vim.api.nvim_put(vim.split(text, "\n"), "c", true, true)
        end
    end

    -------------------------------------------------
    -- ATALHOS DE CLIPBOARD & REGISTRADORES
    -------------------------------------------------

    -- Copiar para o clipboard do sistema
    vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar para o clipboard do sistema" })
    vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copiar seleção para o clipboard do sistema (Ctrl + C)" })
    vim.keymap.set("i", "<C-c>", '<ESC>"+y`^i', { desc = "Copiar no modo Insert" })

    -- Colar no modo Insert (Ctrl + V mantendo a posição)
    vim.keymap.set("i", "<C-v>", '<ESC>"+p`^i', { desc = "Colar no modo Insert" })

    -- Modo Normal: 'p' e '<leader>pp'
    vim.keymap.set("n", "p", paste_system_clipboard, { desc = "Colar do clipboard do sistema (Nativo)" })
    vim.keymap.set("n", "<leader>pp", paste_system_clipboard, { desc = "Colar do clipboard do sistema (<leader>pp)" })

    -- Modo Insert adicional via função Lua
    vim.keymap.set("i", "<leader>pp", "<BS><C-r>+", { desc = "Colar no modo inserção (<leader>pp)" })

    -- Modo Visual: deleta para o registrador nulo e injeta o clipboard do sistema
    vim.keymap.set("v", "p", function()
        vim.cmd('normal! "_d')
        paste_system_clipboard()
    end, { desc = "Colar sobre seleção no modo visual" })

    vim.keymap.set("v", "<leader>pp", function()
        vim.cmd('normal! "_d')
        paste_system_clipboard()
    end, { desc = "Colar sobre seleção no modo visual" })
end

return fn_copyPaste()

-- =============================================================
-- @How_To_Use
-- fn_copyPaste()
-- 
-- 1. Pressione <C-c> no modo insert/visual ou <leader>y para copiar para o clipboard.
-- 2. Pressione <C-v> no modo insert, ou p / <leader>pp no modo normal/visual para colar.
-- ===========================================================