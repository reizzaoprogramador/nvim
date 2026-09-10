-- @file: custom_rzj/fn_registers.lua
-- @mission: Exibir o menu de registradores do Neovim via Telescope se disponível ou fallback nativo, com atalhos integrados

local function fn_registers()
    -- @desc: Abre a lista de registradores utilizando o Telescope (se instalado) ou o comando nativo :registers
    -- @mission: Mapear os atalhos <leader>rg e <leader>fr para acesso rápido ao histórico de colagem e cópia

    local function show_registers()
        local ok_builtin, builtin = pcall(require, "telescope.builtin")
        if ok_builtin and builtin.registers then
            builtin.registers()
        else
            vim.cmd("registers")
        end
    end

    vim.keymap.set({ "n", "v" }, "<leader>rg", show_registers, { desc = "Mostrar menu de registradores (Clipboard)" })
    vim.keymap.set({ "n", "v" }, "<leader>fr", show_registers, { desc = "Find Registers (Menu do Clipboard)" })
end

return fn_registers()

-- =============================================================
-- @How_To_Use
-- fn_registers()
-- 
-- Pressione <leader>rg ou <leader>fr nos modos normal ou visual para abrir o menu de registradores.
-- ===========================================================