-- @file: $ONVIM/lua/plugins/treesitter.lua
-- @mission: Parser e highlight de sintaxe avancado via nvim-treesitter

local M = {}

function M.setup()
    -- 1. Registra e carrega via vim.pack
    vim.pack.add({
        "https://github.com/nvim-treesitter/nvim-treesitter",
    })

    vim.cmd("packadd nvim-treesitter")

    -- 2. Configuração do Treesitter
    local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
    if ts_ok then
        ts.setup({
            ensure_installed = { "lua", "vim", "vimdoc", "bash", "fish", "go", "json", "yaml", "markdown", "markdown_inline" },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
        })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Garante a instalacao automatica e o highlight de sintaxe moderno para
-- linguagens essenciais do seu fluxo (Lua, Bash, Fish, Go, Markdown).
-- ==============================================================================
