-- @file: nvim/init.lua
-- @mission: Iniciar e mapear os arquivos do editor Neovim com a linguagem Lua

-- == INIT_ROOT : NVIM SO_CUSTOM_RZJ ==

-- -- OBRIGATORIO NO TOPO DO INIT ROOT : Garante que o leader seja o espaço antes de carregar os módulos --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- IMPORTS : MODULES --
require("custom_rzj.managers.manager_plugins_lazyvim")
require("custom_rzj")

