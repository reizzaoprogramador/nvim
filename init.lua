-- @file: ~/.config/nvim/init.lua
-- @mission: Inicializacao root do Neovim chamando o modulo custom_rzj

<<<<<<< HEAD
=======
-- == INIT_ROOT : NVIM SO_CUSTOM_RZJ ==

-- -- OBRIGATORIO NO TOPO DO INIT ROOT : Garante que o leader seja o espaço antes de carregar os módulos --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- IMPORTS : MODULES --
require("custom_rzj.managers.manager_plugins_lazyvim")
>>>>>>> main
require("custom_rzj")

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Delegado 100% para o require("custom_rzj"), que se encarrega de carregar os submodulos.
-- ==============================================================================
