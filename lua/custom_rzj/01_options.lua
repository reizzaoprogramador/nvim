-- @file: nvim/lua/core/options.lua
-- @mission: Opções globais de configuração do Neovim

-- == OPTIONS ==
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.undofile = true
vim.o.autoread = true
vim.o.laststatus = 3
vim.opt.clipboard = "unnamedplus"

-------------------------------------------------
-- DISPLAY :: RESPIRO VERTICAL E TELA TOTAL NATIVA
-------------------------------------------------
vim.opt.scrolloff = 8 -- Margem de 8 linhas de segurança abaixo/acima do cursor no final do arquivo
vim.opt.sidescrolloff = 8 -- Margem de 8 colunas de respiro nas laterais ao rolar horizontalmente
vim.opt.cmdheight = 0 -- Oculta a linha de comando inferior inativa (100% de área útil vertical)
vim.opt.showtabline = 2 -- Oculta a barra de abas superior
vim.opt.signcolumn = "number" -- options: yes, number -- Integra os ícones de diagnóstico/LSP direto na coluna dos números
vim.opt.fillchars:append({ eob = " " }) -- Substitui os caracteres de til ('~') após a última linha por espaço limpo
vim.opt.virtualedit = "onemore" -- Permite mover o cursor um caractere além do fim da linha


