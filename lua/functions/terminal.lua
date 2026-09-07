-- @file: nvim/lua/functions/terminal.lua
-- @mission: Módulo isolado de controle do Terminal Integrado RZJ

local M = {}
local map = vim.keymap.set

function M.toggle_vsplit_terminal()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].buftype == "terminal" then
			vim.api.nvim_win_close(win, true)
			return
		end
	end

	vim.cmd("vsplit | terminal")
	vim.wo.number = false
	vim.wo.relativenumber = false

	local term_buf = vim.api.nvim_get_current_buf()

	map("t", "<C-LeftMouse>", "<C-\\><C-n><cmd>vertical wincmd f<CR>", {
		buffer = term_buf,
		desc = "Abrir link sob o cursor no terminal em um vsplit (Ctrl + Clique Esquerdo)",
	})

	map("t", "<2-LeftMouse>", "<C-\\><C-n><cmd>wincmd f<CR>", {
		buffer = term_buf,
		desc = "Abrir link sob o cursor no terminal em novo buffer (Clique Duplo)",
	})

	vim.cmd("startinsert")
end

return M