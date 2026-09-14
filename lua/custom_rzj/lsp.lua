-- @file: ~/.config/nvim/lua/custom_rzj/lsp.lua
-- @mission: Gerenciamento de pacotes LSP e configuracao nativa do servidor Go (gopls)

-- 1. Carrega dependencias nativas via vim.pack
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig"
})

-- 2. Configura o servidor gopls usando a API nativa (vim.lsp.config)
vim.lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            completeUnimported = true,
        },
    },
}

-- 3. Ativa o gopls no runtime
vim.lsp.enable("gopls")

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- - Carregado via require("custom_rzj.lsp").
-- - Mantem a API nativa do Neovim 0.11+ (vim.lsp.config e vim.lsp.enable).
-- ==============================================================================
