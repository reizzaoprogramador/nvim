-- @file: $ONVIM/lua/plugins/telescope.lua
-- @mission: Gerenciamento do Telescope via vim.pack compatível com o loader dinâmico

local M = {}

function M.setup()
    -- 1. Registra e carrega dependências via vim.pack
    vim.pack.add({
        "https://github.com/nvim-lua/plenary.nvim",
        "https://github.com/nvim-telescope/telescope.nvim",
    })

    vim.cmd("packadd plenary.nvim")
    vim.cmd("packadd telescope.nvim")

    -- 2. Configuração do Telescope
    local telescope_ok, telescope = pcall(require, "telescope")
    if telescope_ok then
        telescope.setup({
            defaults = {
                file_ignore_patterns = { "node_modules", "%.git/" },
                hidden = true,
            },
            pickers = {
                find_files = {
                    hidden = true,
                    no_ignore = false,
                },
            },
        })
    end

    -- 3. Mapeamento de Atalhos
    local builtin_ok, builtin = pcall(require, "telescope.builtin")
    if builtin_ok then
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Buscar arquivos no diretorio atual" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Buscar texto nos arquivos" })

        -- 4. Autocmd para renderização limpa no início sem travar o layout
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                if vim.fn.argc() == 0 then
                    vim.schedule(function()
                        builtin.find_files({
                            cwd = vim.fn.getcwd(),
                            hidden = true,
                        })
                    end)
                end
            end,
        })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Retorna a tabela M com o método .setup() para integração perfeita com o loader
-- de lua/plugins/init.lua, garantindo carregamento assíncrono e ordenado.
-- ==============================================================================
