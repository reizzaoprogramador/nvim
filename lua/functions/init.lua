-- @file: nvim/lua/functions/init.lua
-- @mission: Carregar e inicializar automaticamente todos os módulos dentro de lua/functions/

local functions_dir = vim.fn.stdpath("config") .. "/lua/functions"

for _, file in ipairs(vim.fn.readdir(functions_dir)) do
  -- Ignora este próprio arquivo init.lua e aceita apenas arquivos .lua
  if file ~= "init.lua" and file:match("%.lua$") then
    local module_name = file:sub(1, -5) -- Remove a extensão .lua
    
    -- Carrega o módulo com segurança contra erros de sintaxe
    local ok, mod = pcall(require, "functions." .. module_name)
    
    -- Se o módulo foi carregado e possui uma função .setup(), executa ela
    if ok and type(mod) == "table" and type(mod.setup) == "function" then
      mod.setup()
    end
  end
end
