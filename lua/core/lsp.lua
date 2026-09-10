#!/usr/bin/env lua
-- @file: lua/core/lsp.lua
-- @mission: core + lsp-nativo + integracao-diagnosticos-auto

local function setup_lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true, noremap = true }

  -- Navegação e diagnósticos
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

local function start_lsp()
  local ft = vim.bo.filetype
  if ft == "" or vim.bo.buftype ~= "" then return end

  local bufnr = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(bufnr)
  if buf_name == "" then return end

  -- Autocomplete Integration (Blink.cmp)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_blink, blink = pcall(require, "blink.cmp")
  if ok_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  -------------------------------------------------
  -- GO (GOPLS)
  -------------------------------------------------
  if ft == "go" and vim.fn.executable("gopls") == 1 then
    local root = vim.fs.root(bufnr, { "go.mod", "go.work", ".git" }) or vim.fs.dirname(buf_name)

    vim.lsp.start({
      name = "gopls",
      cmd = { "gopls" },
      root_dir = root,
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
            shadow = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    })
    setup_lsp_keymaps(bufnr)

  -------------------------------------------------
  -- LUA (LUA-LANGUAGE-SERVER)
  -------------------------------------------------
  elseif ft == "lua" and vim.fn.executable("lua-language-server") == 1 then
    local root = vim.fs.root(bufnr, { ".luarc.json", ".luacheckrc", ".git" }) or vim.fs.dirname(buf_name)

    vim.lsp.start({
      name = "lua_ls",
      cmd = { "lua-language-server" },
      root_dir = root,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME },
          },
          diagnostics = { globals = { "vim" } },
        },
      },
    })
    setup_lsp_keymaps(bufnr)

  -------------------------------------------------
  -- BASH / SHELL
  -------------------------------------------------
  elseif (ft == "sh" or ft == "bash") and vim.fn.executable("bash-language-server") == 1 then
    local root = vim.fs.root(bufnr, { ".git" }) or vim.fs.dirname(buf_name)

    vim.lsp.start({
      name = "bashls",
      cmd = { "bash-language-server", "start" },
      root_dir = root,
      capabilities = capabilities,
    })
    setup_lsp_keymaps(bufnr)

  -------------------------------------------------
  -- TYPESCRIPT / JAVASCRIPT / DENO (DENO LSP)
  -------------------------------------------------
  elseif (ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact") and vim.fn.executable("deno") == 1 then
    local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "package.json", ".git" }) or vim.fs.dirname(buf_name)

    vim.lsp.start({
      name = "denols",
      cmd = { "deno", "lsp" },
      root_dir = root,
      capabilities = capabilities,
      settings = {
        deno = {
          enable = true,
          lint = true,
          unstable = true,
        },
      },
    })
    setup_lsp_keymaps(bufnr)
  end
end

-- Configuração visual dos diagnósticos na tela
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})

-- Gatilho automático ao abrir ou alterar buffer
local augroup = vim.api.nvim_create_augroup("RzjLspDirect", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = augroup,
  callback = function()
    start_lsp()
  end,
})

-- ==============================================================================
-- @README_FILE
-- ESTE MÓDULO CONFIGURA O CLIENTE LSP NATIVO DO NEOVIM DE FORMA DIRETA E LEVE.
--
-- INCLUÍDO:
-- - SUPORTE NATIVO PARA LINGUAGENS: GO (gopls), LUA (lua-language-server), BASH (bashls) E TS/JS (deno lsp).
-- - ATALHOS PADRÃO DE NAVEGAÇÃO E DIAGNÓSTICO (K, gd, <leader>e, [d, ]d, <leader>ca).
-- - INTEGRAÇÃO AUTO-DETECTÁVEL COM O COMPLETAR BLINK.CMP.
-- - CONFIGURAÇÃO VISUAL PERSONALIZADA PARA MENSAGENS E SÍMBOLOS DE ERRO.
--
-- @PorqueFuncionou:
-- 1. INSTALAÇÃO DE DEPENDÊNCIAS NO SO: A EXECUÇÃO DOS PACOTES VIA APT/NPM INSTALOU OS EXECUTÁVEIS
--    NECESSÁRIOS NO PATH DO SISTEMA OPERACIONAL (COMO BASH-LANGUAGE-SERVER E DENO).
-- 2. SUPORTE NATIVO AO DENO: O BLOCO DE TS/JS FOI RECONFIGURADO PARA CHAMAR DIRETO O EXECUTÁVEL
--    `deno lsp`, QUE POSSUI ANALISADOR SINTÁTICO, LINTER E TYPE CHECKER EMBUTIDOS SEM NECESSITAR
--    DO PACOTE TYPESCRIPT-LANGUAGE-SERVER DO NPM GLOBAL.
-- 3. CORREÇÃO DA ESTRUTURA LUA: FECHAMENTO CORRETO DO BLOCO DE CONDIÇÕES E FUNÇÃO PRINCIPAL
--    `start_lsp()`, PERMITINDO QUE O AUTOCMD `BufEnter` LEIA E ATIVE O CLIENTE SEM ERROS DE SINTAXE.
--
-- COMO USAR / REQUISITOS:
-- 1. CERTIFIQUE-SE DE TER OS EXECUTÁVEIS INSTALADOS NO SISTEMA OPERACIONAL (gopls, lua-language-server, bash-language-server, deno).
-- 2. AO ABRIR UM ARQUIVO CORRESPONDENTE, O LSP SERÁ INICIADO AUTOMATICAMENTE.
-- 3. IMPORTADO DIRETO NO init.lua COM: require("core.lsp")
-- ==============================================================================