-- @file: nvim/lua/core/keymaps.lua
-- @mission: Atalhos Master, Mapeamentos de Edição, Fechamento de Buffers, Tabs Visíveis e Copiar/Colar no Insert

local map = vim.keymap.set

-------------------------------------------------
-- CONFIGURAÇÃO VISUAL DE TABS (BUFFERLINE NO TOPO)
-------------------------------------------------
vim.opt.showtabline = 2 -- Mostra sempre a barra de abas no topo com os buffers abertos

-------------------------------------------------
-- FUNÇÃO DE CABEÇALHO CUSTOMIZADO
-------------------------------------------------

local function InsertHeader()
  local buf = 0
  local filepath = vim.api.nvim_buf_get_name(buf):gsub("^" .. vim.fn.expand("~"), "~")

  local ft_comments = {
    lua = "--",
    sh = "#",
    bash = "#",
    typescript = "//",
    javascript = "//",
    go = "//",
  }

  local comment = ft_comments[vim.bo.filetype] or "--"
  vim.api.nvim_buf_set_lines(buf, 0, 0, false, {
    comment .. " @file: " .. filepath,
    comment .. " @mission: ",
    "",
  })
end

-------------------------------------------------
-- ATALHOS RÁPIDOS NO MODO INSERT (INCLUINDO CTRL+C / CTRL+V)
-------------------------------------------------

map("i", "jj", "<Esc>", { desc = "Sair do modo de inserção" })
map("i", "<C-z>", "<Esc>ui", { desc = "Desfazer no modo inserção" })
map("i", "<leader>.", "<C-x><C-o>", { desc = "Autocomplete Nativo (Espaço + .)" })

-- Copiar e Colar no modo Insert de forma segura
map("i", "<C-c>", '<ESC>"+y`^i', { desc = "Copiar no modo Insert" })
map("i", "<C-v>", '<ESC>"+p`^i', { desc = "Colar no modo Insert" })

-------------------------------------------------
-- ATALHOS DE EDIÇÃO & NAVEGAÇÃO
-------------------------------------------------

map("n", "<leader>rc", function()
  vim.cmd("source $MYVIMRC")
end, { desc = "Recarregar configurações ($MYVIMRC)" })

map("n", "<leader>H", InsertHeader, { desc = "Inserir cabeçalho no arquivo" })

-- BUFFERS
map("n", "qq", "<cmd>bdelete<CR>", { desc = "Fechar buffer atual (qq)" })
map("n", "xx", "<cmd>%bd|enew<CR>", { desc = "Fechar todos os buffers (xx)" })

-- Formatar com Deno usando a config_extras global
map("n", "<leader>df", function()
  local extra_config = vim.fn.expand("~/.config/nvim/config_extras/deno.json")
  vim.cmd("silent !deno fmt --config " .. extra_config .. " %")
end, { desc = "Formatar com Deno (Extras Config)" })

-- Selecionar tudo
map({ "n", "v" }, "<C-a>", "ggVG", { desc = "Selecionar todo o texto (Ctrl + A)" })
map({ "n", "v" }, "<leader>aa", "ggVG", { desc = "Selecionar todo o texto (<leader>aa)" })

-------------------------------------------------
-- NAVEGAÇÃO ENTRE BUFFERS E JANELAS (SPLITS)
-------------------------------------------------

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

map("n", "<C-z>", "u", { desc = "Desfazer (Undo)" })
map("n", "U", "<C-r>", { silent = true, desc = "Refazer (Redo)" })

-------------------------------------------------
-- BLOQUEIO DE CRASH (SEGURO - SEM INTERFERIR NA BARRA '/')
-------------------------------------------------

map({ "n", "i", "t", "v" }, "<C-.>", "<nop>")

-------------------------------------------------
-- ATALHOS LSP
-------------------------------------------------

map("n", "gd", vim.lsp.buf.definition, { desc = "Ir para definição" })
map("n", "gh", vim.lsp.buf.hover, { desc = "Ver documentação (Hover)" })
map("n", "gr", vim.lsp.buf.references, { desc = "Ver referências" })

-------------------------------------------------
-- COMENTÁRIOS NATIVOS (LINHA E BLOCO)
-------------------------------------------------

map({ "n", "v" }, "<leader>cc", function()
  local ok, comment = pcall(require, "functions.comment")
  if ok and comment.toggle then
    comment.toggle()
  end
end, { desc = "Alternar comentário (linha)" })

map({ "n", "v" }, "<leader>cb", function()
  local ok, comment = pcall(require, "functions.comment")
  if ok and comment.toggle_block then
    comment.toggle_block()
  end
end, { desc = "Alternar comentário (bloco /* */)" })

map({ "n", "v" }, "gb", function()
  local ok, comment = pcall(require, "functions.comment")
  if ok and comment.toggle_block then
    comment.toggle_block()
  end
end, { desc = "Alternar comentário em bloco (gb)" })

-------------------------------------------------
-- GERENCIADOR EXPLORER DE ARQUIVOS (NVIM-TREE)
-------------------------------------------------

map("n", "ee", "<cmd>NvimTreeToggle<CR>", { desc = "Alternar NvimTree" })
map("v", "ee", "<cmd>NvimTreeToggle<CR>", { desc = "Alternar NvimTree" })

-------------------------------------------------
-- INTERRUPTOR DO TERMINAL INTEGRADO
-------------------------------------------------

map("n", "<C-t>", function()
  require("functions.terminal").toggle_vsplit_terminal()
end, { desc = "Alternar terminal integrado em vsplit (Ctrl + T)" })

map("t", "<C-t>", "<C-\\><C-n><cmd>lua require('functions.terminal').toggle_vsplit_terminal()<CR>", {
  desc = "Fechar terminal integrado de dentro dele (Ctrl + T)",
})

map("n", "<leader>t", function()
  require("functions.terminal").toggle_vsplit_terminal()
end, { desc = "Alternar terminal integrado em vsplit (Espaço + T)" })

-------------------------------------------------
-- ATALHOS GRUPO C (SUBSTITUIÇÃO E MUDANÇAS)
-------------------------------------------------

map(
  "n",
  "<leader>cw",
  ":%s/\\<<C-r><C-w>\\>/",
  { noremap = true, silent = false, desc = "Substituir palavra sob o cursor (Arquivo)" }
)

map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Renomear variável/função via LSP" })

map({ "n", "v" }, "<leader>cx", function()
  local ok, rep = pcall(require, "functions.replaces")
  if ok and rep.replaceAll then
    rep.replaceAll()
  end
end, { desc = "Substituição interativa global (ReplaceAll)" })

-- Mover e duplicar linhas
map("n", "<A-d>", "<cmd>t.<CR>", { desc = "Duplicar linha atual para baixo (Alt + D)" })
map("v", "<A-d>", ":co '><CR>gv", { silent = true, desc = "Duplicar seleção para baixo (Alt + D)" })

map("n", "<C-Up>", "<cmd>m .-2<CR>==", { desc = "Mover linha para cima" })
map("n", "<C-Down>", "<cmd>m .+1<CR>==", { desc = "Mover linha para baixo" })
map("v", "<C-Up>", ":m '<-2<CR>gv=gv", { desc = "Mover bloco para cima" })
map("v", "<C-Down>", ":m '>+1<CR>gv=gv", { desc = "Mover bloco para baixo" })

-------------------------------------------------
-- REGISTRADORES & TELESCOPE
-------------------------------------------------

local function show_registers()
  local ok_builtin, builtin = pcall(require, "telescope.builtin")
  if ok_builtin and builtin.registers then
    builtin.registers()
  else
    vim.cmd("registers")
  end
end

map({ "n", "v" }, "<leader>rg", show_registers, { desc = "Mostrar menu de registradores (Clipboard)" })
map({ "n", "v" }, "<leader>fr", show_registers, { desc = "Find Registers (Menu do Clipboard)" })

-------------------------------------------------
-- EXPANSÃO E NAVEGAÇÃO DE SNIPPETS (LUASNip)
-------------------------------------------------

map({ "i", "s" }, "<Tab>", function()
  local ok, luasnip = pcall(require, "luasnip")
  if ok and luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { silent = true, desc = "Expandir ou avançar campo no LuaSnip" })

map({ "i", "s" }, "<S-Tab>", function()
  local ok, luasnip = pcall(require, "luasnip")
  if ok and luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
  end
end, { silent = true, desc = "Voltar campo no LuaSnip" })