-- @file: nvim/lua/functions/comment.lua
-- @mission: alternar comentarios em linha e bloco no modo normal e visual

local M = {}

local function get_comment_parts()
  local cs = vim.bo.commentstring
  if not cs or cs == "" then
    cs = "# %s"
  end
  local prefix = cs:match("^(.-)%%s") or "# "
  return vim.trim(prefix)
end

function M.toggle()
  local mode = vim.api.nvim_get_mode().mode
  local start_line, end_line

  if mode:match("[vV\22]") then
    vim.cmd("normal! \27")
    start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
    end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
  else
    start_line = vim.api.nvim_win_get_cursor(0)[1]
    end_line = start_line
  end

  if start_line == 0 or end_line == 0 then return end

  local prefix = get_comment_parts()
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  local all_commented = true
  for _, line in ipairs(lines) do
    local trimmed = vim.trim(line)
    if #trimmed > 0 and not trimmed:find("^" .. vim.pesc(prefix)) then
      all_commented = false
      break
    end
  end

  local new_lines = {}
  for _, line in ipairs(lines) do
    if all_commented then
      local indent, content = line:match("^(%s*)(.*)$")
      if content:find("^" .. vim.pesc(prefix)) then
        content = content:sub(#prefix + 1)
        if content:sub(1, 1) == " " then
          content = content:sub(2)
        end
      end
      table.insert(new_lines, indent .. content)
    else
      if #vim.trim(line) > 0 then
        local indent, content = line:match("^(%s*)(.*)$")
        table.insert(new_lines, indent .. prefix .. " " .. content)
      else
        table.insert(new_lines, line)
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
end

function M.toggle_block()
  local mode = vim.api.nvim_get_mode().mode
  local start_line, end_line

  if mode:match("[vV\22]") then
    vim.cmd("normal! \27")
    start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
    end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
  else
    start_line = vim.api.nvim_win_get_cursor(0)[1]
    end_line = start_line
  end

  if start_line == 0 or end_line == 0 then return end

  -- Garante ordem das linhas
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then return end

  local first_trimmed = vim.trim(lines[1])
  local last_trimmed = vim.trim(lines[#lines])

  -- Verifica se o bloco inteiro selecionado já está envolvido por /* e */
  local is_block_commented = (first_trimmed:find("^/%*") ~= nil and last_trimmed:find("%*/$") ~= nil)

  local new_lines = {}

  if is_block_commented then
    -- Descomentar o bloco inteiro
    for i, line in ipairs(lines) do
      local current = line
      if i == 1 then
        local indent, content = current:match("^(%s*)(.*)$")
        content = content:gsub("^/%*%s*", "")
        current = indent .. content
      end
      if i == #lines then
        local indent, content = current:match("^(%s*)(.*)$")
        content = content:gsub("%s*%*/$", "")
        current = indent .. content
      end
      table.insert(new_lines, current)
    end
  else
    -- Comentar as linhas selecionadas em um único bloco contínuo
    if #lines == 1 then
      local indent, content = lines[1]:match("^(%s*)(.*)$")
      table.insert(new_lines, string.format("%s/* %s */", indent, content))
    else
      for i, line in ipairs(lines) do
        if i == 1 then
          local indent, content = line:match("^(%s*)(.*)$")
          table.insert(new_lines, string.format("%s/* %s", indent, content))
        elseif i == #lines then
          local indent, content = line:match("^(%s*)(.*)$")
          table.insert(new_lines, string.format("%s   %s */", indent, content))
        else
          table.insert(new_lines, line)
        end
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
end

local group = vim.api.nvim_create_augroup("CommentStringSetup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "c", "cpp", "javascript", "typescript", "typescriptreact", "javascriptreact", "go", "java" },
  callback = function()
    vim.bo.commentstring = "// %s"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "sh", "bash", "python", "yaml", "toml", "conf" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

return M