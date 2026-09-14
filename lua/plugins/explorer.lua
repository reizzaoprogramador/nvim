-- @file: $ONVIM/lua/plugins/explorer.lua
-- @mission: Explorador Oil.nvim em sidebar direita que abre arquivo no editor e fecha a sidebar com tratamento para E444

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

            -- Se houver apenas 1 janela aberta no Neovim, cria um split antes de abrir o arquivo
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

                -- Fecha a janela do Oil de forma segura usando pcall para ignorar E444
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
            keymaps = {
                ["g?"] = "actions.show_help",
                
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
                ["h"] = "actions.parent",
                ["<Left>"] = "actions.parent",
                ["."] = "actions.toggle_hidden",
                ["~"] = "actions.cd",
                ["q"] = "actions.close",
                ["<BS>"] = "actions.parent",
            },
        })

        -- Toggle da sidebar do Oil na direita
        local function toggle_oil_right()
            if vim.bo.filetype == "oil" then
                vim.cmd("close")
            else
                vim.cmd("botright vsplit | vertical resize 35")
                oil.open()
            end
        end

        vim.keymap.set("n", "ee", toggle_oil_right, { desc = "Toggle Oil Explorer na direita" })
        vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Abrir Oil no buffer atual" })
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- - Tratamento para `E444`: Utiliza verificação da quantidade de janelas e `pcall`
--   ao tentar fechar a sidebar do Oil, prevenindo erros de encerramento do editor.
-- ==============================================================================
