-- @file: lua/core/abbreviations.lua
-- @mission: Carregamento dinâmico de abreviações a partir da pasta ./snippets/abbreviations

local config_path = vim.fn.stdpath("config") .. "/snippets/abbreviations"

-- Carrega abreviações globais
local global_file = config_path .. "/global.vim"
if vim.fn.filereadable(global_file) == 1 then
  vim.cmd("source " .. global_file)
end

-- Carrega abreviações específicas do tipo de arquivo (ft)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    local ft = vim.bo.filetype
    local ft_file = config_path .. "/" .. ft .. ".vim"
    if vim.fn.filereadable(ft_file) == 1 then
      vim.cmd("source " .. ft_file)
    end
  end,
})
