-- @file: lua/custom_rzj/99_statusline.lua
-- @mission: Statusline nativa (sem tabline no topo)

local M = {}

local mode_map = {
    ['n']      = 'N',
    ['no']     = 'N-OP',
    ['v']      = 'V',
    ['V']      = 'V-L',
    ['\22']    = 'V-B',
    ['s']      = 'S',
    ['S']      = 'S-L',
    ['\19']    = 'S-B',
    ['i']      = 'I',
    ['ic']     = 'I',
    ['ix']     = 'I',
    ['R']      = 'R',
    ['Rc']     = 'R',
    ['Rx']     = 'R',
    ['Rv']     = 'V-R',
    ['c']      = 'C',
    ['cv']     = 'EX',
    ['ce']     = 'EX',
    ['r']      = 'PROMPT',
    ['rm']     = 'MORE',
    ['r?']     = 'CONFIRM',
    ['!']      = 'SHELL',
    ['t']      = 'T',
}

local function apply_colors()
    vim.api.nvim_set_hl(0, "StatusNormal",     { fg = "#1e1e2e", bg = "#89b4fa", bold = true }) -- N: Azul
    vim.api.nvim_set_hl(0, "StatusInsert",     { fg = "#1e1e2e", bg = "#a6e3a1", bold = true }) -- I: Verde
    vim.api.nvim_set_hl(0, "StatusVisual",     { fg = "#1e1e2e", bg = "#fab387", bold = true }) -- V: Laranja
    vim.api.nvim_set_hl(0, "StatusVisualLine", { fg = "#1e1e2e", bg = "#f9e2af", bold = true }) -- V-L: Amarelo
    vim.api.nvim_set_hl(0, "StatusReplace",    { fg = "#1e1e2e", bg = "#f38ba8", bold = true }) -- R: Vermelho
    vim.api.nvim_set_hl(0, "StatusCmd",        { fg = "#1e1e2e", bg = "#cba6f7", bold = true }) -- C: Roxo
    vim.api.nvim_set_hl(0, "StatusOther",      { fg = "#1e1e2e", bg = "#94e2d5", bold = true })
end

function _G.statusline_mode()
    local m = vim.api.nvim_get_mode().mode
    local mode_str = mode_map[m] or 'N'

    if m == 'n' then
        return "%#StatusNormal# " .. mode_str .. " %*"
    elseif m == 'i' or m == 'ic' then
        return "%#StatusInsert# " .. mode_str .. " %*"
    elseif m == 'v' or m == '\22' then
        return "%#StatusVisual# " .. mode_str .. " %*"
    elseif m == 'V' then
        return "%#StatusVisualLine# " .. mode_str .. " %*"
    elseif m == 'R' then
        return "%#StatusReplace# " .. mode_str .. " %*"
    elseif m == 'c' then
        return "%#StatusCmd# " .. mode_str .. " %*"
    else
        return "%#StatusOther# " .. mode_str .. " %*"
    end
end

function _G.statusline_render()
    local mode = _G.statusline_mode()
    local filename = "%f %m%r"
    local align = "%="
    local filetype = "%Y"
    local percentage = "%p%%"
    local line_col = "%l:%c"

    return string.format("%s %s %s %s | %s | %s ", mode, filename, align, filetype, percentage, line_col)
end

function M.setup()
    apply_colors()

    vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
        callback = function()
            apply_colors()
        end,
    })

    vim.opt.laststatus = 2
    vim.opt.showtabline = 0 -- Desativa completamente a barra de buffers/abas no topo
    vim.o.statusline = "%!v:lua.statusline_render()"
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- showtabline setado para 0 para remover a barra superior do Neovim.
-- ==============================================================================
