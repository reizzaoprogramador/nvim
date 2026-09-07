-- @file: nvim/lua/core/netrw.lua
-- @mission: Configuração do explorador nativo Netrw (Lado esquerdo, largura 25)

vim.g.netrw_liststyle = 3      -- Árvore de diretórios
vim.g.netrw_banner = 0         -- Oculta o banner superior
vim.g.netrw_winsize = 25       -- Largura fixada em 25
vim.g.netrw_browse_split = 0   -- Abre arquivos na janela anterior
vim.g.netrw_altfile = 1        -- Mantém a referência do arquivo alternativo
vim.g.netrw_altv = 0           -- Abre splits verticais à esquerda

-- Função de alternância do Netrw na extrema ESQUERDA
local function toggle_netrw()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      vim.api.nvim_win_close(win, true)
      return
    end
  end
  vim.cmd("topleft vertical 25Lexplore")
end

_G.ToggleNetrw = toggle_netrw

-- Função nativa para criar arquivos/pastas abrindo na janela anterior
local function create_netrw_entry()
  local fname = vim.fn.input("Nome do arquivo/pasta: ")
  if fname == "" then return end

  local dir = vim.b.netrw_curdir or vim.fn.getcwd()
  local path = dir .. "/" .. fname

  if vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1 then
    vim.notify("Já existe: " .. fname, vim.log.levels.WARN)
    return
  end

  if fname:match("/$") then
    vim.fn.mkdir(path, "p")
    vim.cmd("edit")
  else
    local f = io.open(path, "w")
    if not f then
      vim.notify("Falha ao criar: " .. fname, vim.log.levels.ERROR)
      return
    end
    f:close()

    local escaped = vim.fn.fnameescape(path)
    if vim.fn.winnr("#") == 0 then
      vim.cmd("edit " .. escaped)
    else
      vim.cmd("wincmd p")
      vim.cmd("edit " .. escaped)
    end
  end
end

-- Mapeamentos dentro do buffer do Netrw
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    local bind = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = true, remap = true, silent = true, desc = desc })
    end

    -- Atalhos customizados
    vim.keymap.set("n", "a", create_netrw_entry, { buffer = true, silent = true, desc = "Adicionar arquivo" })
    vim.keymap.set("n", "%", create_netrw_entry, { buffer = true, silent = true, desc = "Adicionar arquivo" })

    bind("e", "R", "Renomear arquivo/diretório")
    bind("r", "D", "Remover/Deletar arquivo/diretório")
  end,
})
