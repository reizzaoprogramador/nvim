-- @file: custom_rzj/fn_insertHeader.lua
-- @mission: Inserir automaticamente o cabeçalho padronizado do arquivo com atalho integrado

local function InsertHeader()
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

-- Registra o atalho <leader>h para chamar a função no modo normal
vim.keymap.set('n', '<leader>h', InsertHeader, { desc = 'Inserir cabeçalho padrão' })

return InsertHeader

# ==============================================================================
# @README_FILE
#
# @IMPORTANTE_PROFILE: Automatiza a inserção do cabeçalho de arquivos.
# 
# @Como_Usar:
# Basta pressionar <leader>h em qualquer arquivo para injetar o bloco inicial 
# adaptado ao tipo de linguagem (comentários em #, -- ou //).
# ==============================================================================