-- @file: nvim/lua/core/colorscheme.lua
-- @mission: Carregamento seguro do tema catppuccin com fundo transparente

local status_ok, _ = pcall(vim.cmd.colorscheme, "catppuccin")

if not status_ok then
--  vim.notify("Colorscheme 'catppuccin' não encontrado. Usando tema padrão.", vim.log.levels.WARN)
  vim.cmd.colorscheme("default")
end

-- Mantém o fundo transparente do terminal
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })