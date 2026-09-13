-- @file: lua/custom_rzj/functions.lua
-- @mission: Módulo unificado de funções customizadas com registro automático de atalhos

local M = {}

-- ==============================================================================
-- 1. GERENCIAMENTO DE COMENTÁRIOS
-- ==============================================================================
local function get_comment_parts()
    local cs = vim.bo.commentstring
    if not cs or cs == "" then cs = "# %s" end
    local prefix = cs:match("^(.-)%%s") or "# "
    return vim.trim(prefix)
end

function M.toggle_comment()
    local mode = vim.api.nvim_get_mode().mode
    local start_line, end_line

    if mode:match("[vV\22]") then
        vim.cmd("normal! \27")
        start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
        end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
    else
        start_line = vim.api.nvim_win_get_cursor(0)[1]
        end_line = start_line
    end

    if start_line == 0 or end_line == 0 then return end

    local prefix = get_comment_parts()
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    local all_commented = true
    for _, line in ipairs(lines) do
        local trimmed = vim.trim(line)
        if #trimmed > 0 and not trimmed:find("^" .. vim.pesc(prefix)) then
            all_commented = false
            break
        end
    end

    local new_lines = {}
    for _, line in ipairs(lines) do
        if all_commented then
            local indent, content = line:match("^(%s*)(.*)$")
            if content:find("^" .. vim.pesc(prefix)) then
                content = content:sub(#prefix + 1)
                if content:sub(1, 1) == " " then content = content:sub(2) end
            end
            table.insert(new_lines, indent .. content)
        else
            if #vim.trim(line) > 0 then
                local indent, content = line:match("^(%s*)(.*)$")
                table.insert(new_lines, indent .. prefix .. " " .. content)
            else
                table.insert(new_lines, line)
            end
        end
    end

    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
end

function M.toggle_block_comment()
    local mode = vim.api.nvim_get_mode().mode
    local start_line, end_line

    if mode:match("[vV\22]") then
        vim.cmd("normal! \27")
        start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
        end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
    else
        start_line = vim.api.nvim_win_get_cursor(0)[1]
        end_line = start_line
    end

    if start_line == 0 or end_line == 0 then return end
    if start_line > end_line then start_line, end_line = end_line, start_line end

    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    if #lines == 0 then return end

    local first_trimmed = vim.trim(lines[1])
    local last_trimmed = vim.trim(lines[#lines])
    local is_block_commented = (first_trimmed:find("^/%*") ~= nil and last_trimmed:find("%*/$") ~= nil)

    local new_lines = {}
    if is_block_commented then
        for i, line in ipairs(lines) do
            local current = line
            if i == 1 then
                local indent, content = current:match("^(%s*)(.*)$")
                content = content:gsub("^/%*%s*", "")
                current = indent .. content
            end
            if i == #lines then
                local indent, content = current:match("^(%s*)(.*)$")
                content = content:gsub("%s*%*/$", "")
                current = indent .. content
            end
            table.insert(new_lines, current)
        end
    else
        if #lines == 1 then
            local indent, content = lines[1]:match("^(%s*)(.*)$")
            table.insert(new_lines, string.format("%s/* %s */", indent, content))
        else
            for i, line in ipairs(lines) do
                if i == 1 then
                    local indent, content = line:match("^(%s*)(.*)$")
                    table.insert(new_lines, string.format("%s/* %s", indent, content))
                elseif i == #lines then
                    local indent, content = line:match("^(%s*)(.*)$")
                    table.insert(new_lines, string.format("%s    %s */", indent, content))
                else
                    table.insert(new_lines, line)
                end
            end
        end
    end

    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
end

-- ==============================================================================
-- 2. INTEGRAÇÃO DE CLIPBOARD NATIVO
-- ==============================================================================
function M.paste_system_clipboard()
    local text = vim.fn.getreg("+")
    if text and text ~= "" then
        vim.api.nvim_put(vim.split(text, "\n"), "c", true, true)
    end
end

-- ==============================================================================
-- 3. FORMATAÇÃO SILENCIOSA COM DENO
-- ==============================================================================
function M.format_deno()
    local extra_config = vim.fn.expand("~/.config/nvim/config_extras/deno.json")
    vim.cmd("silent !deno fmt --config " .. extra_config .. " %")
    vim.cmd("edit!")
end

-- ==============================================================================
-- 4. INSERÇÃO DE CABEÇALHO AUTOMÁTICO
-- ==============================================================================
function M.insert_header()
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

-- ==============================================================================
-- 5. REGISTRADORES & TELESCOPE FALLBACK
-- ==============================================================================
function M.show_registers()
    local ok_builtin, builtin = pcall(require, "telescope.builtin")
    if ok_builtin and builtin.registers then
        builtin.registers()
    else
        vim.cmd("registers")
    end
end

-- ==============================================================================
-- 6. REPLACE ALL (SUBSTITUIÇÃO GLOBAL)
-- ==============================================================================
local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    if #lines == 0 then return "" end
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    lines[1] = string.sub(lines[1], s_start[3])
    return table.concat(lines, "\n")
end

function M.run_replace_all()
    local mode = vim.api.nvim_get_mode().mode
    local default_search = ""

    if mode:match("[vV]") or mode == "\22" then
        vim.cmd("normal! \27")
        default_search = get_visual_selection()
    end

    vim.ui.input({ prompt = "Texto a buscar: ", default = default_search }, function(target)
        if not target or target == "" then return end

        vim.ui.input({ prompt = "Substituir por: " }, function(replace_term)
            if replace_term == nil then return end

            vim.ui.input({ prompt = "Todas [a] ou Confirmar uma a uma [c]? ", default = "a" }, function(choice)
                if not choice then return end

                local flag = (choice:lower() == "c") and "gc" or "g"
                local search_esc = vim.fn.escape(target, "/")
                local replace_esc = vim.fn.escape(replace_term, "/")

                local success_grep, _ = pcall(vim.cmd, string.format("silent vimgrep /%s/gj **/*", search_esc))

                if success_grep then
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

-- ==============================================================================
-- INITIALIZER (Mapeamentos acoplados + Autocommands)
-- ==============================================================================
function M.setup()
    -- Configuração de Commentstring por extensão
    local group = vim.api.nvim_create_augroup("CommentStringSetup", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "c", "cpp", "javascript", "typescript", "typescriptreact", "javascriptreact", "go", "java" },
        callback = function() vim.bo.commentstring = "// %s" end,
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "sh", "bash", "python", "yaml", "toml", "conf" },
        callback = function() vim.bo.commentstring = "# %s" end,
    })

    -- Registro de Mapeamentos se a Função Existir no Módulo
    if M.toggle_comment then
        vim.keymap.set({ "n", "v" }, "<leader>cc", M.toggle_comment, { desc = "Alternar comentário (linha)" })
    end

    if M.toggle_block_comment then
        vim.keymap.set({ "n", "v" }, "<leader>cb", M.toggle_block_comment, { desc = "Alternar comentário em bloco" })
        vim.keymap.set({ "n", "v" }, "gb", M.toggle_block_comment, { desc = "Alternar comentário em bloco (gb)" })
    end

    if M.paste_system_clipboard then
        vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar para o clipboard do sistema" })
        vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copiar seleção para o clipboard do sistema" })
        vim.keymap.set("i", "<C-c>", '<ESC>"+y`^i', { desc = "Copiar no modo Insert" })
        vim.keymap.set("i", "<C-v>", '<ESC>"+p`^i', { desc = "Colar no modo Insert" })
        vim.keymap.set("n", "p", M.paste_system_clipboard, { desc = "Colar do clipboard do sistema" })
        vim.keymap.set("n", "<leader>pp", M.paste_system_clipboard, { desc = "Colar do clipboard do sistema" })
        vim.keymap.set("i", "<leader>pp", "<BS><C-r>+", { desc = "Colar no modo inserção" })
        vim.keymap.set("v", "p", function()
            vim.cmd('normal! "_d')
            M.paste_system_clipboard()
        end, { desc = "Colar sobre seleção no modo visual" })
    end

    if M.format_deno then
        vim.keymap.set("n", "<leader>df", M.format_deno, { desc = "Formatar com Deno" })
    end

    if M.insert_header then
        vim.keymap.set("n", "<leader>h", M.insert_header, { desc = "Inserir cabeçalho padrão" })
    end

    if M.show_registers then
        vim.keymap.set({ "n", "v" }, "<leader>rg", M.show_registers, { desc = "Mostrar registradores" })
        vim.keymap.set({ "n", "v" }, "<leader>fr", M.show_registers, { desc = "Find Registers" })
    end

    if M.run_replace_all then
        vim.keymap.set({ "n", "v" }, "<leader>cx", M.run_replace_all, { desc = "ReplaceAll Global" })
        vim.api.nvim_create_user_command("ReplaceAll", M.run_replace_all, { desc = "Substituir string no Workspace" })
    end

    -- Terminal Integrado
    vim.keymap.set("n", "tt", function()
        local ok, term = pcall(require, "functions.terminal")
        if ok and term.toggle_vsplit_terminal then
            term.toggle_vsplit_terminal()
        end
    end, { desc = "Alternar terminal em vsplit" })

    vim.keymap.set("t", "tt", "<C-\\><C-n><cmd>lua require('functions.terminal').toggle_vsplit_terminal()<CR>", {
        desc = "Fechar terminal integrado",
    })
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Módulo reestruturado para vincular os atalhos diretamente à existência das funções no setup().
-- Ao comentar ou remover uma função dentro da tabela M, o atalho deixa de ser registrado.
-- ==============================================================================

