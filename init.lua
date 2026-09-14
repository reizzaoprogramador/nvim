-- @file: nvim/init.lua
-- @mission: Inicialização do ambiente Neovim com gerenciamento nativo vim.pack e LSP nativo (vim.lsp.config)

-- == 1. GERENCIADOR DE PACOTES ==
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig"
})

-- == 2. CONFIGURAÇÃO DO LSP NATIVO (GOPLS) ==
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

-- Ativa o servidor gopls no runtime
vim.lsp.enable("gopls")

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- A partir do Neovim 0.11+, prefira `vim.lsp.config.<server>` e `vim.lsp.enable()`
-- em vez do legado `require('lspconfig').<server>.setup()`. Isso elimina avisos 
-- de deprecation e utiliza o ecossistema 100% nativo.
-- ==============================================================================
