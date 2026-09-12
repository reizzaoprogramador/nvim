#!/usr/bin/env lua
-- @file: lua/core/save_close.lua
-- @mission: core + autocommit + fluxo continuo sem bloqueios

local map = vim.keymap.set
local save_group = vim.api.nvim_create_augroup("RzjSaveCloseGroup", { clear = true })

-------------------------------------------------
-- AUTO-SAVE NATIVO
-------------------------------------------------
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = save_group,
  callback = function()
    if vim.bo.modifiable and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
      pcall(vim.cmd, "silent! write!")
    end
  end,
})

-------------------------------------------------
-- MAPEAMENTOS NATIVOS DIRETO NO CORE
-------------------------------------------------

-- Forçar saída rápida sem salvar
map({ "n", "i" }, "kk", "<Esc><cmd>qa!<CR>", { noremap = true, silent = true, desc = "Forçar saída sem salvar" })

-- ==============================================================================
-- @README_FILE
-- ESTE MÓDULO GERENCIA O SALVAMENTO E FECHAMENTO SILENCIOSO NO NEOVIM.
--
-- INCLUÍDO:
-- - AUTO-SAVE NATIVO FORÇADO (write!) NOS EVENTOS InsertLeave E TextChanged.
-- - ATALHO 'kk' EM MODO NORMAL OU INSERÇÃO PARA FECHAR O EDITOR SEM SALVAR.
-- - SOBRESCRITA AUTOMÁTICA PARA EVITAR O ERRO E13.
--
-- COMO USAR:
-- 1. BASTA DIGITAR NORMALMENTE; AS ALTERAÇÕES SÃO GRAVADAS AUTOMATICAMENTE AO SAIR
--    DO MODO DE INSERÇÃO OU ALTERAR O TEXTO.
-- 2. USE 'kk' A QUALQUER MOMENTO PARA SAIR RAPIDAMENTE (qa!).
-- 3. IMPORTADO DIRETO NO init.lua COM: require("core.save_close")
-- ==============================================================================