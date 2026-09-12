-- @file: custom_rzj/fn_formatDeno.lua
-- @mission: Formatar o arquivo atual utilizando a ferramenta Deno com uma configuração global externa

fn_formatDeno() {
    -- @desc: Dispara a formatação via terminal do Deno apontando para o arquivo de configuração global especificado
    -- @mission: Executar o comando deno fmt de forma silenciosa no arquivo aberto atual utilizando o config_extras

    local function format()
        local extra_config = vim.fn.expand("~/.config/nvim/config_extras/deno.json")
        vim.cmd("silent !deno fmt --config " .. extra_config .. " %")
        vim.cmd("edit!") -- Recarrega o arquivo para refletir as alterações de formatação
    end

    -- Registra o atalho <leader>df para acionar a formatação no modo normal
    vim.keymap.set('n', '<leader>df', format, { desc = "Formatar com Deno (Extras Config)" })

    return format

-- =============================================================
-- @How_To_Use
-- fn_formatDeno()
-- 
-- Pressione <leader>df no modo normal do Neovim para formatar o arquivo atual.
-- ===========================================================
}