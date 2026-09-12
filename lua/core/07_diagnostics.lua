-- @file: nvim/lua/core/diagnostics.lua
-- @mission: Configuração de diagnósticos do LSP e prevenção de salvamento com erros

-- Configuração visual dos diagnósticos
vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Atalhos de navegação e inspeção
vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.setqflist()
  vim.cmd("copen")
end, { silent = true })

vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- Menu Interativo: bloqueia salvamento e impede o fechamento no :wq
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ConfirmSaveOnLspError", { clear = true }),
  pattern = "*",
  callback = function(args)
    local errors = vim.diagnostic.get(args.buf, { severity = vim.diagnostic.severity.ERROR })
    
    if #errors > 0 then
      local prompt = "⚠️ O arquivo contém " .. #errors .. " erro(s) do LSP!\n"
        .. "[S]alvar assim mesmo | [C]ancelar e corrigir | [P]rimeiro erro\n"
        .. "Escolha uma opção (S/C/P) [padrão: C]: "

      local input = vim.fn.input(prompt)
      local choice = string.lower(vim.trim(input))

      if choice == "s" then
        -- Prossegue com o salvamento e fecha se for :wq
        return
      elseif choice == "p" then
        vim.schedule(function()
          vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
        end)
        vim.api.nvim_echo({ { "\n🚫 Salvamento cancelado. Movido para o primeiro erro.", "WarningMsg" } }, true, {})
      else
        vim.api.nvim_echo({ { "\n🚫 Salvamento cancelado.", "WarningMsg" } }, true, {})
      end

      -- Cancela o salvamento e aborta o :wq (impede o fechamento do Neovim)
      vim.api.nvim_cmd({ cmd = "cq" }, {})
    end
  end,
})
