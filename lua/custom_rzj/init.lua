-- @file: ~/.config/nvim/lua/custom_rzj/init.lua
-- @mission: Carregamento automático e dinâmico de todos os arquivos `.lua` dentro da pasta custom_rzj

local M = {}

function M.setup()
    local current_dir = vim.fn.stdpath('config') .. '/lua/custom_rzj'
    local files = vim.fn.readdir(current_dir, function(file)
        return file:match('%.lua$') and file ~= 'init.lua'
    end)

    for _, file in ipairs(files) do
        local mod_name = file:gsub('%.lua$', '')
        local ok, err = pcall(require, 'custom_rzj.' .. mod_name)
        if not ok then
            vim.notify('Erro ao carregar o módulo custom_rzj.' .. mod_name .. ': ' .. err, vim.log.levels.ERROR)
        end
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE: Carrega automaticamente qualquer arquivo .lua colocado na pasta custom_rzj.
-- 
-- @Como_Usar:
-- Basta soltar seus arquivos de configuração, atalhos ou funções na pasta lua/custom_rzj/ 
-- e eles serão carregados sozinhos ao iniciar o Neovim.
-- ==============================================================================