-- @file: nvim/init.lua
-- @mission: Iniciar e mapear os arquivos do editor Neovim com a linguagem Lua

-- == IMPORTS ==

-- 1. mapleader só funciona aqui no init no alto
vim.g.mapleader = " "

-- 2. Gerenciador de Plugins (Lazy) - Deve ser o primeiro a carregar
require("managers.manager_plugins_lazyvim")

-- 3. Chama o core/init que faz load registravel de todos cores lá no diretorio
require("core")
require("custom_rzj")

