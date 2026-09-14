-- @file: lua/custom_rzj/theme.lua
-- @mission: Aplicação global de tema com fundo transparente (apenas cores de letras/sintaxe)

local M = {}

-- Remove backgrounds de todos os grupos de destaque para garantir transparência total
local function apply_transparency()
    local transparent_groups = {
        "Normal",
        "NormalNC",
        "LineNr",
        "Folded",
        "NonText",
        "SpecialKey",
        "VertSplit",
        "SignColumn",
        "EndOfBuffer",
        "NormalFloat",
        "FloatBorder",
    }
    for _, group in ipairs(transparent_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
end

function M.setup()
    -- Garante True Color no terminal
    vim.opt.termguicolors = true

    -- Define o tema ativo (ex: catppuccin, tokyonight, dracula, etc.)
    local theme_name = "catppuccin"
    local ok, _ = pcall(vim.cmd.colorscheme, theme_name)

    if not ok then
        vim.notify("Tema '" .. theme_name .. "' não encontrado. Usando default.", vim.log.levels.WARN)
    end

    -- Aplica a transparência de imediato
    apply_transparency()

    -- Re-aplica a transparência sempre que o tema for alterado
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
            apply_transparency()
        end,
    })
end

return M

-- ==============================================================================
-- @README_FILE
--
-- @IMPORTANTE_PROFILE:
-- Módulo responsável por forçar bg = NONE nos grupos de interface.
-- Garante que qualquer colorscheme carregado utilize a transparência nativa do terminal.
-- ==============================================================================
