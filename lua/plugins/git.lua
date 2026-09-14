-- @file: $ONVIM/lua/custom_rzj/git.lua
-- @mission: Gerenciamento e carregamento seguro do Neogit e Diffview via vim.pack

-- 1. Registra e garante o download dos repositorios
vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/NeogitOrg/neogit",
})

-- 2. Força a inclusao dos pacotes no runtimepath atual
vim.cmd("packadd plenary.nvim")
vim.cmd("packadd diffview.nvim")
vim.cmd("packadd neogit")

-- ==============================================================================
-- 3. CONFIGURAÇÂO DOS PLUGINS (COM CARREGAMENTO SEGURO)
-- ==============================================================================

local diffview_ok, diffview = pcall(require, "diffview")
if diffview_ok then
    diffview.setup({
        enhanced_diff_hl = true,
        use_icons = true,
    })
end

local neogit_ok, neogit = pcall(require, "neogit")
if neogit_ok then
    neogit.setup({
        integrations = {
            diffview = true,
        },
    })
end

-- ==============================================================================
-- 4. MAPEAMENTO DE TECLAS (KEYMAPS)
-- ==============================================================================
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Abrir Neogit (Painel Git)" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Abrir Diffview (Visualizar Alteracoes)" })
vim.keymap.set("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Fechar Diffview" })

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- - Utiliza `packadd` explicito para disponibilizar os pacotes baixados pelo `vim.pack`.
-- - Proteção de inicialização via `pcall` para evitar travamentos no primeiro boot.
-- - Atalhos principais:
--   - `<leader>gg`: Painel Neogit.
--   - `<leader>gd`: Visualizador de Diffs e Conflitos.
-- ==============================================================================
