-- @file: lua/functions/paste.lua
-- @mission: Modulo customizado de clipboard e registradores via API Lua nativa

local M = {}
local map = vim.keymap.set

local function paste_system_clipboard()
  local text = vim.fn.getreg("+")
  if text and text ~= "" then
    vim.api.nvim_put(vim.split(text, "\n"), "c", true, true)
  end
end

function M.setup()
  -------------------------------------------------
  -- ATALHOS DE CLIPBOARD & REGISTRADORES
  -------------------------------------------------

  -- Modo Normal: 'p' e '<leader>pp'
  map("n", "p", paste_system_clipboard, { desc = "Colar do clipboard do sistema (Nativo)" })
  map("n", "<leader>pp", paste_system_clipboard, { desc = "Colar do clipboard do sistema (<leader>pp)" })

  -- Modo Insert: '<C-v>' e '<leader>pp'
  map("i", "<C-v>", "<C-r>+", { desc = "Colar no modo inserção (Ctrl + V)" })
  map("i", "<leader>pp", "<BS><C-r>+", { desc = "Colar no modo inserção (<leader>pp)" })

  -- Modo Visual: deleta para o registrador nulo e injeta o clipboard do sistema
  map("v", "p", function()
    vim.cmd('normal! "_d')
    paste_system_clipboard()
  end, { desc = "Colar sobre seleção no modo visual" })

  map("v", "<leader>pp", function()
    vim.cmd('normal! "_d')
    paste_system_clipboard()
  end, { desc = "Colar sobre seleção no modo visual" })

  -- Copiar para o clipboard do sistema
  map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copiar para o clipboard do sistema" })
end

return M
