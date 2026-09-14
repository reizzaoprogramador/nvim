-- @file: $ONVIM/init.lua
-- @mission: Inicializacao root do Neovim chamando os modulos custom_rzj e plugins

-- == INIT_ROOT : NVIM SO_CUSTOM_RZJ ==

-- -- OBRIGATORIO NO TOPO DO INIT ROOT : Garante que o leader seja o espaço antes de carregar os módulos --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- IMPORTS : MODULES --
require("custom_rzj")
require("plugins")

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Delegado para o require("custom_rzj") e require("plugins"), que se encarregam
-- de carregar os submódulos e plugins dinamicamente.
-- ==============================================================================
