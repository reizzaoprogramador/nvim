-- @file: nvim/lua/core/options.lua
-- @mission: Opções globais de configuração do Neovim

-- == OPTIONS ==
-- == OBRIGATORIO NO TOPO DO INIT ROOT :Repetidos Aqui:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- UTILS OPTIONS --
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.softtabstop = 2 --controla quantos espaços virtuais o Neovim insere ou remove quando você aperta <Tab> ou <Backspace> em Modo de Inserção. 
vim.o.undofile = true
vim.o.autoread = true
vim.o.laststatus = 3
vim.opt.clipboard = "unnamedplus"
vim.opt.showtabline = 0 -- Mostra sempre a barra de abas no topo com os buffers abertos :: SE MAIOR QUE 0 || 2


-- @mission: Opções fundamentais do Neovim (Habilitar True Color para statusline)
vim.opt.termguicolors = true   -- Ativa suporte a cores 24-bit no terminal
vim.opt.laststatus = 2         -- Garante que a statusline sempre apareça
vim.opt.showtabline = 2        -- Garante que a tabline (topo) sempre apareça

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


