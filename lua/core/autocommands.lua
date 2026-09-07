-- @file: nvim/lua/native/autocommands.lua
-- @mission: Autocomandos de interface, destaque ao copiar, restauração de cursor e autoformat isolado

local rzj_group = vim.api.nvim_create_augroup("RzjUIAutomation", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Highlight selection on yank
autocmd("TextYankPost", {
  group = rzj_group,
  desc = "highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

-- Restore cursor to file position in previous editing session
autocmd("BufReadPost", {
  group = rzj_group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- AutoFormat Deno Seguro (SÓ executa em arquivos suportados e sem travar a fila de atalhos)
autocmd("BufWritePost", {
  group = rzj_group,
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.jsonc", "*.md" },
  callback = function(ev)
    -- Não roda em arquivos Lua ou sem nome no disco
    if vim.bo[ev.buf].filetype == "lua" or vim.fn.expand("%") == "" then
      return
    end

    -- Checa se o Deno está instalado no sistema
    if vim.fn.executable("deno") ~= 1 then
      return
    end

    local file = vim.fn.expand("%:p")
    local extra_config = vim.fn.expand("~/.config/nvim/config_extras/deno.json")

    if vim.fn.filereadable(extra_config) == 1 then
      vim.fn.jobstart({ "deno", "fmt", "--config", extra_config, file }, {
        on_exit = function(_, code)
          -- Só recarrega o buffer se o deno realmente alterou o arquivo com sucesso
          if code == 0 then
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ev.buf) and not vim.bo[ev.buf].modified then
                vim.cmd("silent! checktime " .. ev.buf)
              end
            end)
          end
        end,
      })
    end
  end,
})
