-- @file: $ONVIM/lua/plugins/explorer.lua
-- @mission: Explorador Oil.nvim configurado para abrir em janela flutuante (modal centralizada)

local M = {}

function M.setup()
    vim.pack.add({
        "https://github.com/nvim-tree/nvim-web-devicons",
        "https://github.com/stevearc/oil.nvim",
    })

    vim.cmd("packadd nvim-web-devicons")
    vim.cmd("packadd oil.nvim")

    local oil_ok, oil = pcall(require, "oil")
    if oil_ok then
        local function open_file_and_close_sidebar(entry)
            local oil_win = vim.api.nvim_get_current_win()
            local file_path = oil.get_current_dir() .. entry.name

            if #vim.api.nvim_list_wins() <= 1 then
                vim.cmd("vsplit " .. vim.fn.fnameescape(file_path))
            else
                local main_win = vim.fn.win_getid(vim.fn.winnr('#'))
                if main_win ~= 0 and main_win ~= oil_win then
                    vim.api.nvim_set_current_win(main_win)
                    vim.cmd("edit " .. vim.fn.fnameescape(file_path))
                else
                    vim.cmd("wincmd p | edit " .. vim.fn.fnameescape(file_path))
                end

                if vim.api.nvim_win_is_valid(oil_win) and #vim.api.nvim_list_wins() > 1 then
                    pcall(vim.api.nvim_win_close, oil_win, true)
                end
            end
        end

        oil.setup({
            default_file_explorer = true,
            columns = { "icon" },
            view_options = {
                show_hidden = true,
            },
            -- MUDANÇA (Flutuante): Configuração da janela flutuante do Oil.
            -- Para voltar ao modo normal (sidebar vertical na direita), comente ou remova o bloco "float" abaixo
            -- e recoloque a função de split vertical no atalho `ee`.
            float = {
                padding = 2,
                max_width = 90,
                max_height = 30,
                border = "rounded",
                win_options = {
                    winblend = 0,
                },
                override = function(conf)
                    return conf
                end,
            },
            keymaps = {
                ["g?"] = "actions.show_help",
                
                -- Movimentacao e Navegacao
                ["h"] = "actions.parent",
                ["<Left>"] = "actions.parent",
                ["j"] = "j",
                ["<Down>"] = "j",
                ["k"] = "k",
                ["<Up>"] = "k",
                ["."] = "actions.toggle_hidden",
                ["~"] = "actions.cd",
                ["H"] = "actions.cd",
                ["q"] = "actions.close",
                ["<BS>"] = "actions.parent",

                -- Entrada em pasta / Abertura de arquivo
                ["<CR>"] = {
                    callback = function()
                        local entry = oil.get_cursor_entry()
                        if entry and entry.type == "file" then
                            open_file_and_close_sidebar(entry)
                        else
                            oil.select()
                        end
                    end,
                    desc = "Abrir arquivo no painel principal e fechar sidebar",
                },
                ["l"] = {
                    callback = function()
                        local entry = oil.get_cursor_entry()
                        if entry then
                            if entry.type == "directory" then
                                oil.select()
                            else
                                open_file_and_close_sidebar(entry)
                            end
                        end
                    end,
                    desc = "Navegar em pasta ou abrir arquivo e fechar sidebar",
                },
                ["<Right>"] = "actions.select",

                -- Manipulacao estilo VIM (Baseada na edicao de buffer do Oil)
                ["a"] = {
                    callback = function()
                        vim.cmd("normal! o")
                        vim.cmd("startinsert")
                    end,
                    desc = "Adicionar/Criar entrada",
                },
                ["d"] = {
                    callback = function()
                        vim.cmd("normal! dd")
                        vim.cmd("write")
                    end,
                    desc = "Deletar entrada",
                },
                ["y"] = { "actions.yank_entry", desc = "Copiar nome/caminho" },
                ["x"] = {
                    callback = function()
                        vim.cmd("normal! dd")
                    end,
                    desc = "Recortar entrada",
                },
                ["p"] = {
                    callback = function()
                        vim.cmd("normal! p")
                        vim.cmd("write")
                    end,
                    desc = "Colar entrada",
                },
                ["c"] = {
                    callback = function()
                        vim.cmd("normal! cw")
                    end,
                    desc = "Modificar/Renomear palavra sob cursor",
                },
                ["r"] = {
                    callback = function()
                        vim.cmd("normal! cw")
                    end,
                    desc = "Renomear entrada",
                },
                ["u"] = {
                    callback = function()
                        vim.cmd("undo")
                    end,
                    desc = "Desfazer mudanca no buffer",
                },
                ["U"] = {
                    callback = function()
                        vim.cmd("redo")
                    end,
                    desc = "Refazer mudanca no buffer",
                },
            },
        })

        -- MUDANÇA (Flutuante): Ajustado o atalho `ee` para chamar diretamente o Oil flutuante (`oil.open_float`).
        -- PARA VOLTAR AO MODO NORMAL (Sidebar vertical na direita):
        -- Substitua a linha abaixo por:
        -- local function toggle_oil_right()
        --     if vim.bo.filetype == "oil" then
        --         vim.cmd("close")
        --     else
        --         vim.cmd("botright vsplit | vertical resize 35")
        --         oil.open()
        --     end
        -- end
        -- vim.keymap.set("n", "ee", toggle_oil_right, { desc = "Toggle Oil Explorer na direita" })
        vim.keymap.set("n", "ee", function()
            oil.open_float()
        end, { desc = "Abrir Oil Explorer Flutuante" })

        vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Abrir Oil no buffer atual" })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- - Atalhos alinhados com a especificacao Vim:
--   - `ee`: Abre o Oil.nvim em modo flutuante centralizado (Modal).
--   - Para reverter ao modo Sidebar vertical antigo: Remova a tabela `float = { ... }` do `oil.setup` e restaure a função `toggle_oil_right` no atalho `ee`.
--   - `a`: Adicionar novo arquivo/pasta.
--   - `d`: Deletar item atual (apaga linha + salva).
--   - `c` / `r`: Renomear arquivo/pasta (`cw`).
--   - `x`: Recortar.
--   - `y`: Copiar.
--   - `p`: Colar.
--   - `u` / `U`: Desfazer e Refazer alteracoes no buffer do Oil.
--   - `h` / `l` / `j` / `k`: Navegacao direcional padrao.
--   - `.` / `~` / `H`: Alternar ocultos e navegar para Home/Raiz.
-- ==============================================================================
