-- @file: custom_rzj/01_keymaps.lua
-- @mission: Atalhos master e opções globais nativas do Neovim, custom_rzj

local map = vim.keymap.set

-- == OPTIONS ==
vim.opt.showtabline = 2 -- Mostra sempre a barra de abas no topo com os buffers abertos

-- == ATALHOS RAPIDOS ==
map("i", "jj", "<Esc>", { desc = "Sair do modo de inserção" })
map("i", "<C-z>", "<Esc>ui", { desc = "Desfazer - no modo inserção" })
map("n", "<C-z>", "u", { desc = "Desfazer (Undo) - no modo normal" })
map("n", "U", "<C-r>", { silent = true, desc = "Refazer (Redo) - modo normal" })
map("i", "<C-.>", "<C-x><C-o>", { desc = "Autocomplete Nativo (Ctr + .)" })
map("n", "qq", "<cmd>bdelete<CR>", { desc = "Fechar buffer atual (qq)" })
map("n", "xx", "<cmd>%bd|enew<CR>", { desc = "Fechar todos os buffers (xx)" })
map({ "n", "v" }, "<C-a>", "ggVG", { desc = "Selecionar todo o texto (Ctrl + a)" })
map("n", "<A-d>", "<cmd>t.<CR>", { desc = "Duplicar linha atual para baixo (Alt + D)" })
map("v", "<A-d>", ":co '><CR>gv", { silent = true, desc = "Duplicar seleção para baixo (Alt + D)" })
map("n", "<C-Up>", "<cmd>m .-2<CR>==", { desc = "Mover linha para cima" })
map("n", "<C-Down>", "<cmd>m .+1<CR>==", { desc = "Mover linha para baixo" })
map("v", "<C-Up>", ":m '<-2<CR>gv=gv", { desc = "Mover bloco para cima" })
map("v", "<C-Down>", ":m '>+1<CR>gv=gv", { desc = "Mover bloco para baixo" })
map({ "n", "i", "t", "v" }, "<C-.>", "<nop>", { desc = "BLOQUEIO DE CRASH (SEGURO - SEM INTERFERIR NA BARRA '/')"} )

-- == NAVEGAÇÃO ENTRE BUFFERS E JANELAS (SPLITS) ==
map("n", "<C-Tab>", "<C-^>", { desc = "Alternar último arquivo" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Próximo buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })

-- Foco em janelas divididas com Ctrl + Shift + Setas
map("n", "<C-S-Up>", "<C-w>k", { desc = "Foco na janela acima" })
map("n", "<C-S-Down>", "<C-w>j", { desc = "Foco na janela abaixo" })
map("n", "<C-S-Left>", "<C-w>h", { desc = "Foco na janela à esquerda" })
map("n", "<C-S-Right>", "<C-w>l", { desc = "Foco na janela à direita" })

-- Navegação tradicional de pane (Ctrl + h/j/k/l)
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Mover para o split da esquerda" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Mover para o split abaixo" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Mover para o split acima" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Mover para o split da direita" })

-- Redimensionar janelas/splits (Alt + Setas)
map("n", "<A-Up>", "<cmd>resize -3<CR>", { desc = "Diminuir altura da janela" })
map("n", "<A-Down>", "<cmd>resize +3<CR>", { desc = "Aumentar altura da janela" })
map("n", "<A-Left>", "<cmd>vertical resize +5<CR>", { desc = "Aumentar largura para esquerda" })
map("n", "<A-Right>", "<cmd>vertical resize -5<CR>", { desc = "Diminuir largura para direita" })

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE: 
-- - Use somente nativos vim e neovim.
-- - Adicione somente atalhos nativos e opções globais aqui.
-- - Proibido criar funções ou chamar dependências externas neste arquivo.
-- 
-- @Como_Usar:
-- Carregado automaticamente pelo loader do custom_rzj/ para prover os atalhos base.
-- ==============================================================================