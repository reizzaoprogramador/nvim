-- @file: $ONVIM/lua/plugins/init.lua
-- @mission: Carregar automaticamente todos os módulos de lua/plugins em ordem alfabética

-- Configuração obrigatória do Leader Key antes de qualquer módulo
vim.g.mapleader = " "

local custom_dir = vim.fn.stdpath("config") .. "/lua/plugins"
local files = vim.fn.readdir(custom_dir)

-- Filtra apenas arquivos .lua e ignora o próprio init.lua
local lua_files = {}
for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" and file ~= "init.lua" then
        table.insert(lua_files, file)
    end
end

-- Ordena em ordem alfabética (01_, 02_, netrw, statusline...)
table.sort(lua_files)

-- Carrega dinamicamente cada módulo
for _, file in ipairs(lua_files) do
    local mod_name = "plugins." .. file:sub(1, -5)
    local ok, loaded_module = pcall(require, mod_name)

    if ok then
        if type(loaded_module) == "table" and type(loaded_module.setup) == "function" then
            loaded_module.setup()
        end
    else
        vim.notify("Erro ao carregar módulo: " .. mod_name .. "\n" .. tostring(loaded_module), vim.log.levels.ERROR)
    end
end

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Escaneia o diretório lua/plugins/ e executa o .setup() de forma sequencial ordenada.
-- Para definir a ordem de prioridade, basta nomear os arquivos com numeração (ex: 01_options.lua).
-- ==============================================================================
