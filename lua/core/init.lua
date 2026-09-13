 -- @file: lua/core/init.lua
-- @mission: Carregar todos os módulos de configuração em ordem sequencial

local modules = {
  "core.04_colorscheme",
  "core.05_statusline",
  "core.06_autocommands",
  "core.07_diagnostics",
  "core.08_formatting",
  "core.09_abbreviations",
  "core.10_snippets",
  "core.lsp", --  LSP por último (garante que Lazy e Blink.cmp já estejam carregados)
}

for _, mod in ipairs(modules) do
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("Erro ao carregar o módulo " .. mod .. ":\n" .. err, vim.log.levels.ERROR)
  end
end

-- =============================================================
-- @How_To_Use
-- Use_1: Coloque este arquivo como init.lua dentro do diretório core/
-- Use_2: Certifique-se de que cada arquivo modular usa require ou armazena configs puras em Lua sem dependências externas falhas.
-- ===========================================================
