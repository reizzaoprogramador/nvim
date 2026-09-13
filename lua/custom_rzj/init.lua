-- @file: ~/.config/nvim/lua/custom_rzj/init.lua
-- @mission: Carregar todos os módulos de configuração em ordem sequencial

local modules = {
    "custom_rzj.netrw",
    "custom_rzj.01_options",
    "custom_rzj.02_keymaps",
    "custom_rzj.03_functions_custom",
}

for _, mod in ipairs(modules) do
    local ok, loaded_module = pcall(require, mod)
    if ok then
        -- Se o módulo retornar uma tabela com a função setup(), executa automaticamente
        if type(loaded_module) == "table" and type(loaded_module.setup) == "function" then
            loaded_module.setup()
        end
    else
        vim.notify("Erro ao carregar o módulo " .. mod .. ":\n" .. loaded_module, vim.log.levels.ERROR)
    end
end

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- O loop agora verifica se o módulo importado exporta uma função .setup() e a chama com segurança.
-- Certifique-se de que o arquivo netrw.lua esteja localizado em: ~/.config/nvim/lua/custom_rzj/netrw.lua
-- ==============================================================================
