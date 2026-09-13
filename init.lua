-- @file: nvim/init.lua
-- @mission: Iniciar e mapear os arquivos do editor Neovim com a linguagem Lua

-- == IMPORTS ==

-- == OBRIGATORIO NO TOPO DO INIT ROOT : Garante que o leader seja o espaço antes de carregar os módulos
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 21. Gerenciador de Plugins (Lazy) - Deve ser o primeiro a carregar
require("managers.manager_plugins_lazyvim")

-- 3. Chama o core/init que faz load registravel de todos cores lá no diretorio
require("custom_rzj")
require("core")

