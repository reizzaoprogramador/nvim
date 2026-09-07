-- @file: nvim/init.lua
-- @mission: Iniciar e mapear os arquivos do editor Neovim com a linguagem Lua

vim.g.mapleader = ",,"

-- Gerenciador de Plugins (Lazy) - Deve ser o primeiro a carregar
require("manager_lazy")

-- 2. Opções visuais, respiro vertical e layout nativo
require("core.display")

-- Módulos nativos e configurações
require("core.options")
require("core.save_close")
require("functions") -- Carrega o lua/functions/init.lua e todos os seus arquivos
require("core.colorscheme")
require("core.statusline")
require("core.autocommands")
require("core.diagnostics")
require("core.formatting")
require("core.abbreviations") -- Carrega as abreviações .vim
require("core.snippets")      -- Carrega os snippets .lua no LuaSnip       
require("core.keymaps")        -- Atalhos globais

-- LSP por último (garante que Lazy e Blink.cmp já estejam carregados)
require("core.lsp")


