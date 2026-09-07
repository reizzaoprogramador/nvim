-- @file: nvim/lua/functions/replaces.lua
-- @mission: Função de substituição interativa em todo o projeto (ReplaceAll) e comando de usuário.

local M = {}

local function get_visual_selection()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	if #lines == 0 then
		return ""
	end
	lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	lines[1] = string.sub(lines[1], s_start[3])
	return table.concat(lines, "\n")
end

function M.replaceAll()
	local mode = vim.api.nvim_get_mode().mode
	local default_search = ""

	if mode:match("[vV]") or mode == "\22" then
		vim.cmd("normal! \27")
		default_search = get_visual_selection()
	end

	vim.ui.input({
		prompt = "Texto a buscar: ",
		default = default_search,
	}, function(target)
		if not target or target == "" then
			return
		end

		vim.ui.input({
			prompt = "Substituir por: ",
		}, function(replace_term)
			if replace_term == nil then
				return
			end

			vim.ui.input({
				prompt = "Todas [a] ou Confirmar uma a uma [c]? ",
				default = "a",
			}, function(choice)
				if not choice then
					return
				end

				local flag = (choice:lower() == "c") and "gc" or "g"
				local search_esc = vim.fn.escape(target, "/")
				local replace_esc = vim.fn.escape(replace_term, "/")

				local success_grep, _ = pcall(vim.cmd, string.format("silent vimgrep /%s/gj **/*", search_esc))

				if success_grep then
					local cmd = string.format("cfdo %%s/%s/%s/%s | update", search_esc, replace_esc, flag)
					pcall(vim.cmd, cmd)
					print(string.format("✨ Substituição de '%s' para '%s' concluída!", target, replace_term))
				else
					vim.cmd(string.format("%%s/%s/%s/%s", search_esc, replace_esc, flag))
					print("✨ Substituição executada no buffer atual!")
				end
			end)
		end)
	end)
end

function M.setup()
	vim.api.nvim_create_user_command("ReplaceAll", function()
		M.replaceAll()
	end, { desc = "Substituir string no Workspace" })
end

return M