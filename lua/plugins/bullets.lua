-- @file: plugins/bullets.lua
-- @mission: Autocorreção, autonumeração e continuação automática de listas em arquivos de texto (.md, .txt)

return {
  "bullets-vim/bullets.vim",
  ft = { "markdown", "text" },
  config = function()
    vim.g.bullets_enabled_file_types = { "markdown", "text" }
    vim.g.bullets_enable_in_empty_buffers = 0
    vim.g.bullets_pad_right = 0
  end,
}
