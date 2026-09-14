-- @file: $ONVIM/lua/custom_rzj/lsp.lua
-- @mission: Gerenciamento de pacotes LSP, configuracao nativa de servidores e autoformat ao salvar

-- 1. Carrega dependencias nativas via vim.pack
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig"
})

-- ==============================================================================
-- 2. SERVIDORES LSP & LINTERS
-- ==============================================================================

-- == GOPLS (GO) ==
vim.lsp.config.gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            completeUnimported = true,
        },
    },
}
vim.lsp.enable("gopls")

-- == DENO (TYPESCRIPT / JAVASCRIPT / LINTER UNIFICADO) ==
vim.lsp.config.denols = {
    cmd = { "deno", "lsp" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_markers = { "deno.json", "deno.jsonc", "deno.lock", ".git" },
    settings = {
        deno = {
            enable = true,
            lint = true,     -- Ativa o linter nativo do Deno
            unstable = true, -- Permite acesso as APIs unstables
            suggest = {
                imports = {
                    hosts = {
                        ["https://deno.land"] = true,
                    },
                },
            },
        },
    },
}
vim.lsp.enable("denols")

-- ==============================================================================
-- 3. AUTO-FORMAT DA API NATIVA (BufWritePre)
-- ==============================================================================
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go", "*.ts", "*.tsx", "*.js", "*.jsx" },
    callback = function(args)
        vim.lsp.buf.format({ bufnr = args.buf, async = false })
    end,
})

-- ==============================================================================
-- @README_FILE E MODELO PARA NOVOS PROVEDORES
-- ==============================================================================
-- 
-- @IMPORTANTE_PROFILE:
-- Copie este bloco para adicionar novos provedores no futuro:
--
-- -- == NOVO LSP: [NOME_DA_LINGUAGEM] ==
-- vim.lsp.config.[NOME_DO_PROVEDOR] = {
--     cmd = { "[executavel-langserver]", "--stdio" },
--     filetypes = { "[extensao1]", "[extensao2]" },
--     root_markers = { "[arquivo.config]", ".git" },
--     settings = {
--         [nome_do_provedor] = {
--             analysis = {
--                 -- Regras de linter, paths estaticos, etc.
--             },
--         },
--     },
-- }
-- vim.lsp.enable("[NOME_DO_PROVEDOR]")
-- -- # importante o binario da linguagem alvo estar instalado , exemplo: deno --version
-- ==============================================================================
