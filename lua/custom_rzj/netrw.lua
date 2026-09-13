-- @file: lua/custom_rzj/netrw.lua
-- @mission: Configuração do explorador nativo Netrw na direita abrindo arquivos na janela principal

local M = {}

-- Garantia de inicialização do plugin nativo Netrw
vim.cmd("filetype plugin indent on")
vim.cmd("packadd! netrw")

-- Configurações Globais do Netrw
vim.g.netrw_liststyle = 3     -- Árvore de diretórios
vim.g.netrw_banner = 0        -- Oculta o banner superior
vim.g.netrw_winsize = 25       -- Largura fixada em 25%
vim.g.netrw_browse_split = 4  -- 4 força abrir o arquivo na janela anterior (horizontal principal)
vim.g.netrw_altfile = 1       -- Mantém a referência do arquivo alternativo
vim.g.netrw_altv = 1          -- Splits verticais à direita

-- Função de alternância do Netrw na extrema DIREITA (Lado da mão direita)
function M.toggle_netrw()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "netrw" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    -- Força a criação de uma janela vertical na extrema DIREITA e carrega o diretório
    vim.cmd("botright vertical 30 split +Explore")
end

_G.ToggleNetrw = M.toggle_netrw

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

function M.setup()
    -- Atalho exclusivo <leader>e
    if M.toggle_netrw then
        vim.keymap.set("n", "<leader>e", M.toggle_netrw, { desc = "Toggle Netrw Explorer (Direita)" })
    end

    -- Mapeamentos Nativos dentro do buffer do Netrw (Padrão Vim RZJ)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "netrw",
        callback = function()
            local bind = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { buffer = true, remap = true, silent = true, desc = desc })
            end

            -- Criar / Modificar / Deletar
            vim.keymap.set("n", "a", create_netrw_entry, { buffer = true, silent = true, desc = "Adicionar arquivo/pasta" })
            bind("c", "R", "Renomear (change)")
            bind("d", "D", "Deletar")
            bind("x", "D", "Recortar / Deletar")

            -- Copiar / Colar
            bind("y", "mf", "Marcar arquivo para copiar (yank)")
            bind("p", "mc", "Copiar arquivos marcados para diretório atual (paste)")

            -- Navegação (h, j, k, l + Setas)
            bind("h", "-", "Subir nível de diretório (esquerda)")
            bind("<Left>", "-", "Subir nível de diretório")
            bind("l", "<CR>", "Entrar no diretório / Abrir arquivo na janela principal (direita)")
            bind("<Right>", "<CR>", "Entrar no diretório / Abrir arquivo na janela principal")

            -- Atalhos de controle do Netrw
            bind(".", "gh", "Mostrar/Ocultar arquivos ocultos")
            bind("~", ":e ~/<CR>", "Ir para a Home")
            bind("H", ":e ~/<CR>", "Ir para a Home")
            bind("q", ":q<CR>", "Fechar Netrw (quit)")
            bind("u", "u", "Desfazer")
            bind("U", "<C-r>", "Refazer")
        end,
    })
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Configurado `vim.g.netrw_browse_split = 4` para direcionar a abertura do arquivo para o buffer principal anterior à sidebar.
-- Atalho mantido estritamente como '<leader>e'.
-- ==============================================================================

