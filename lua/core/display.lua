#!/usr/bin/env lua
-- @file: lua/core/display.lua
-- @mission: visual + scrolloff + espaco-abaixo-ultima-linha + respiro-vertical

-------------------------------------------------
-- RESPIRO VERTICAL E TELA TOTAL NATIVA
-------------------------------------------------

-- Margem de 8 linhas de segurança abaixo/acima do cursor no final do arquivo
vim.opt.scrolloff = 8

-- Margem de 8 colunas de respiro nas laterais ao rolar horizontalmente
vim.opt.sidescrolloff = 8

-- Oculta a linha de comando inferior inativa (100% de área útil vertical)
vim.opt.cmdheight = 0

-- Oculta a barra de abas superior
vim.opt.showtabline = 0

-- Integra os ícones de diagnóstico/LSP direto na coluna dos números
vim.opt.signcolumn = "number"

-- Substitui os caracteres de til ('~') após a última linha por espaço limpo
vim.opt.fillchars:append({ eob = " " })

-- Permite mover o cursor um caractere além do fim da linha
vim.opt.virtualedit = "onemore"

-- ==============================================================================
-- @README_FILE
-- MÓDULO DE CONFIGURAÇÃO VISUAL E OTIMIZAÇÃO DE TELA DO NEOVIM.
--
-- INCLUÍDO:
-- - VIM.OPT.SCROLLOFF = 8: GARANTE O RESPIRO VISUAL ABAIXO DA ÚLTIMA LINHA DO ARQUIVO.
-- - VIM.OPT.CMDHEIGHT = 0: OCULTA A LINHA INFERIOR DE COMANDOS SE NÃO ESTIVER EM USO.
-- - VIM.OPT.FILLCHARS (EOB = " "): REMOVE OS TILS ('~') DO RODAPÉ DO BUFFER.
--
-- NOTA DE CARREGAMENTO:
-- - DEVE SER REQUERIDO NO INIT.LUA LOGO APÓS A DEFINIÇÃO DO MAPLEADER E ANTES
--   DO GERENCIADOR DE PLUGINS (LAZY.NVIM).
-- ==============================================================================