-- @file: $ONVIM/lua/plugins/comment.lua
-- @mission: Comentario rapido de linhas e blocos via Comment.nvim

local M = {}

function M.setup()
    -- 1. Registra e carrega via vim.pack
    vim.pack.add({
        "https://github.com/numToStr/Comment.nvim",
    })

    vim.cmd("packadd Comment.nvim")

    -- 2. Configuração do Comment
    local comment_ok, comment = pcall(require, "Comment")
    if comment_ok then
        comment.setup()
    end
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- - `gcc`: Comenta / descomenta a linha atual.
-- - `gc` (em modo visual): Comenta / descomenta a selecao.
-- ==============================================================================
