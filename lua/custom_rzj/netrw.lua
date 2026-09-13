-- @file: nvim/lua/core/netrw.lua
-- @mission: Configuração do explorador nativo Netrw (Lado direito, padrões Vim)

local M = {}

-- Configurações Globais do Netrw
vim.g.netrw_liststyle = 3     -- Árvore de diretórios
vim.g.netrw_banner = 0        -- Oculta o banner superior
vim.g.netrw_winsize = 25       -- Largura fixada em 25%
vim.g.netrw_browse_split = 0  -- Abre arquivos na janela anterior
vim.g.netrw_altfile = 1       -- Mantém a referência do arquivo alternativo
vim.g.netrw_altv = 1          -- Splits verticais à direita

-- Função de alternância do Netrw na extrema DIREITA (botright)
function M.toggle_netrw()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "netrw" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    vim.cmd("botright vertical 25Lexplore")
end

_G.ToggleNetrw = M.toggle_netrw

-- Função para criar arquivos/pastas
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
    -- Atalhos Globais de Toggle (Lado Direito)
    vim.keymap.set("n", "ew", M.toggle_netrw, { desc = "Toggle Netrw Explorer (Direita)" })
    vim.keymap.set("n", "<leader>e", M.toggle_netrw, { desc = "Toggle Netrw Explorer (Direita)" })

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
            bind("l", "<CR>", "Entrar no diretório / Abrir arquivo (direita)")
            bind("<Right>", "<CR>", "Entrar no diretório / Abrir arquivo")

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
-- Configuração do Netrw abrindo via botright à direita.
-- Mapeamentos globais 'ew' e '<leader>e' para alternar o painel.
-- Mapeamentos do buffer convertidos para o padrão de teclas Vim (a, d, c, h, l, q).
-- ==============================================================================
