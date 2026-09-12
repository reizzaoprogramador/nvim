-- @file: custom_rzj/fn_replaceAll.lua
-- @mission: Função de substituição interativa global (ReplaceAll) em todo o projeto com pré-visualização no Quickfix/Telescope e confirmação

local function fn_replaceAll()
    -- @desc: Executa substituição interativa de strings no projeto inteiro usando vimgrep e cfdo com opção de confirmação ou alteração global
    -- @mission: Unificar lógica de busca, substituição e atalho em um único arquivo modular auto-contido

    local function get_visual_selection()
        local s_start = vim.fn.getpos("'<")
        local s_end = vim.fn.getpos("'>")
        local n_lines = math.abs(s_end[2] - s_start[2]) + 1
        local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
        if #lines == 0 then
            return ""
        end
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
        lines[1] = string.sub(lines[1], s_start[3])
        return table.concat(lines, "\n")
    end

    local function runReplaceAll()
        local mode = vim.api.nvim_get_mode().mode
        local default_search = ""

        if mode:match("[vV]") or mode == "\22" then
            vim.cmd("normal! \27")
            default_search = get_visual_selection()
        end

        vim.ui.input({
            prompt = "Texto a buscar: ",
            default = default_search,
        }, function(target)
            if not target or target == "" then
                return
            end

            vim.ui.input({
                prompt = "Substituir por: ",
            }, function(replace_term)
                if replace_term == nil then
                    return
                end

                vim.ui.input({
                    prompt = "Todas [a] ou Confirmar uma a uma [c]? ",
                    default = "a",
                }, function(choice)
                    if not choice then
                        return
                    end

                    local flag = (choice:lower() == "c") and "gc" or "g"
                    local search_esc = vim.fn.escape(target, "/")
                    local replace_esc = vim.fn.escape(replace_term, "/")

                    -- Popula a lista de Quickfix com as ocorrências encontradas para visualização
                    local success_grep, _ = pcall(vim.cmd, string.format("silent vimgrep /%s/gj **/*", search_esc))

                    if success_grep then
                        -- Abre automaticamente a janela de Quickfix para o usuário ver onde está sendo achado antes de aplicar
                        vim.cmd("copen")
                        
                        vim.ui.select({ "Sim", "Não" }, {
                            prompt = "Deseja aplicar a substituição nas ocorrências listadas no Quickfix?",
                        }, function(confirm)
                            if confirm == "Sim" then
                                local cmd = string.format("cfdo %%s/%s/%s/%s | update", search_esc, replace_esc, flag)
                                pcall(vim.cmd, cmd)
                                vim.cmd("cclose")
                                print(string.format("✨ Substituição de '%s' para '%s' concluída!", target, replace_term))
                            else
                                print("❌ Substituição cancelada pelo usuário.")
                            end
                        end)
                    else
                        vim.cmd(string.format("%%s/%s/%s/%s", search_esc, replace_esc, flag))
                        print("✨ Substituição executada no buffer atual!")
                    end
                end)
            end)
        end)
    end

    -- Registra o comando de usuário :ReplaceAll
    vim.api.nvim_create_user_command("ReplaceAll", function()
        runReplaceAll()
    end, { desc = "Substituir string no Workspace" })

    -- Registra os atalhos nos modos normal e visual
    vim.keymap.set({ "n", "v" }, "<leader>cx", function()
        runReplaceAll()
    end, { desc = "Substituição interativa global (ReplaceAll)" })
end

return fn_replaceAll()

-- =============================================================
-- @How_To_Use
-- fn_replaceAll()
-- 
-- 1. Pressione <leader>cx (ou selecione um texto visualmente e aperte <leader>cx).
-- 2. Insira o termo a ser buscado e o termo substituto.
-- 3. O Neovim abrirá a janela de Quickfix mostrando exatamente onde as ocorrências estão localizadas, solicitando confirmação final antes de alterar os arquivos no disco.
-- ===========================================================