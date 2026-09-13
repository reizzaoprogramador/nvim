-- @file: nvim/init.lua
-- @mission: Iniciar e mapear os arquivos do editor Neovim com a linguagem Lua

-- == IMPORTS ==


-- 1. Gerenciador de Plugins (Lazy) - Deve ser o primeiro a carregar
require("managers.manager_plugins_lazyvim")

-- 2. Chama o core/init que faz load registravel de todos cores lá no diretorio
require("custom_rzj")
require("core")

