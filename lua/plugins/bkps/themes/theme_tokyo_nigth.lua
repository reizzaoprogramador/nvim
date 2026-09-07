-- @file: ~/.config/nvim/lua/plugins/theme.lua
-- @mission: Paleta Tokyo Night Desagrupada (Variaveis var_*) + Fundo VSCodium Customizado

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      local catppuccin = require("catppuccin")

      catppuccin.setup({
        flavour = "mocha",
        transparent_background = false,
        custom_highlights = function(colors)
          -- Paleta de Fundo / Interface (Seu VSCodium)
          local bg_custom = "#0d1017"        -- Seu editor.background
          local bg_dark = "#010101"          -- Seu terminal.background
          local active_tab = "#08003c"       -- Sua aba ativa
          local purple_highlight = "#870096" -- Seu scrollbar hover

          -- Paleta Tokyo Night Oficial (Prefixo var_)
          local var_magenta = "#bb9af7"     -- Keywords de estrutura / Modificadores (async, await)
          local var_red = "#f7768e"         -- Controle de Fluxo / Exceções / Imports (if, return, export)
          local var_orange = "#ff9e64"      -- Declarações de variáveis (const, let, var) e Parâmetros
          local var_cyan = "#7dcfff"        -- Nomes de Classes, Interfaces e Tipos
          local var_blue = "#7aa2f7"        -- Nomes de Funções e Métodos Chamados
          local var_green = "#9ece6a"       -- Strings / Textos
          local var_teal = "#1abc9c"        -- Números e Booleans
          local var_purple = "#9d7cd8"      -- Palavras de escopo e nulos (this, super, null)
          local var_comment = "#565f89"     -- Comentários
          local var_foreground = "#c0caf5"  -- Texto Normal / Variáveis (Branco-Azulado)

          return {
            -------------------------------------------------------------------
            -- 1. INTERFACE & PAINÉIS (SEU FUNDO PERSONALIZADO)
            -------------------------------------------------------------------
            Normal = { bg = bg_custom, fg = var_foreground },
            NormalNC = { bg = bg_custom, fg = var_foreground },
            NormalFloat = { bg = "#040466" },
            FloatBorder = { bg = "#040466", fg = "#ffffff" },
            SignColumn = { bg = bg_custom },
            LineNr = { bg = bg_custom, fg = "#444444" },
            CursorLineNr = { bg = bg_custom, fg = var_orange },
            CursorLine = { bg = "#111111" },

            NvimTreeNormal = { bg = bg_custom },
            NvimTreeNormalNC = { bg = bg_custom },

            Pmenu = { bg = bg_dark, fg = "#ffffff" },
            PmenuSel = { bg = purple_highlight, fg = "#ffffff" },

            StatusLine = { bg = bg_custom, fg = "#ffffff" },
            TabLineSel = { bg = active_tab, fg = "#ffffff" },

            -------------------------------------------------------------------
            -- 2. DESAGRUPAMENTO DE PALAVRAS-CHAVE (ESTILO TOKYO NIGHT)
            -------------------------------------------------------------------

            -- A) CONTROLE DE FLUXO & IMPORTS (VERMELHO / ROSA TOKYO)
            -- if, else, switch, case, return, yield, try, catch, import, export
            ["@keyword.repeat"] = { fg = var_red },
            ["@keyword.conditional"] = { fg = var_red },
            ["@keyword.return"] = { fg = var_red },
            ["@keyword.exception"] = { fg = var_red },
            ["@keyword.import"] = { fg = var_red },
            ["@keyword.coroutine"] = { fg = var_red },
            ["@keyword.operator"] = { fg = var_red },

            -- B) ESTRUTURAS DE CÓDIGO (MAGENTA)
            -- class, function, interface, type, async, await
            ["@keyword.function"] = { fg = var_magenta },
            ["@keyword.type"] = { fg = var_magenta },
            ["@keyword.modifier"] = { fg = var_magenta },
            ["@keyword.directive"] = { fg = var_magenta },

            -- C) DECLARAÇÃO DE VARIÁVEIS (LARANJA)
            -- const, let, var, private, public, protected
            ["@keyword.storage"] = { fg = var_orange },

            -- D) PALAVRAS DE ESCOPO E NULOS (ROXO)
            -- this, super, new, null, undefined
            ["@variable.builtin"] = { fg = var_purple, style = { "italic" } },
            ["@constant.builtin"] = { fg = var_purple },

            -- FALLBACK PARA KEYWORDS
            ["@keyword"] = { fg = var_magenta },
            Keyword = { fg = var_magenta },

            -------------------------------------------------------------------
            -- 3. NOMES DE ESTRUTURAS, FUNÇÕES E SINTAXE
            -------------------------------------------------------------------

            -- Nomes de Classes, Interfaces e Tipos (Ciano Tokyo)
            Type = { fg = var_cyan },
            ["@type"] = { fg = var_cyan },
            ["@type.builtin"] = { fg = var_cyan },
            ["@type.definition"] = { fg = var_cyan },
            ["@lsp.type.class"] = { fg = var_cyan },
            ["@lsp.type.interface"] = { fg = var_cyan },
            ["@lsp.type.type"] = { fg = var_cyan },

            -- Funções e Chamadas de Métodos (Azul Tokyo)
            Function = { fg = var_blue },
            ["@function"] = { fg = var_blue },
            ["@function.call"] = { fg = var_blue },
            ["@method"] = { fg = var_blue },
            ["@method.call"] = { fg = var_blue },

            -- Textos / Strings (Verde Tokyo)
            String = { fg = var_green },
            ["@string"] = { fg = var_green },

            -- Comentários (Cinza-azulado com itálico)
            Comment = { fg = var_comment, style = { "italic" } },
            ["@comment"] = { fg = var_comment, style = { "italic" } },

            -- Identificadores e Parâmetros
            Identifier = { fg = var_foreground },
            ["@variable"] = { fg = var_foreground },
            ["@parameter"] = { fg = var_orange },

            -- Números e Booleanos (Teal / Ciano-esverdeado)
            Number = { fg = var_teal },
            Boolean = { fg = var_teal },
            ["@number"] = { fg = var_teal },
            ["@boolean"] = { fg = var_teal },

            -- Operadores (+, -, =, =>) (Vermelho/Rosa)
            Operator = { fg = var_red },
            ["@operator"] = { fg = var_red },

            -------------------------------------------------------------------
            -- 4. OVERRIDES DE SEMANTIC TOKENS DO LSP
            -------------------------------------------------------------------
            ["@lsp.type.keyword"] = {},
            ["@lsp.typemod.keyword.control"] = { fg = var_red },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

-- ============================================================================
-- README_PLUGIN / GUIA DE GRUPOS E CORES DA SINTAXE (ESTILO TOKYO NIGHT)
-- ============================================================================
-- Este guia documenta qual grupo do Treesitter/LSP afeta cada elemento visual:
--
-- [ VARIÁVEIS DE COR UTILIZADAS ]
-- * var_magenta    = "#bb9af7" (Magenta / Estruturas class, function)
-- * var_red        = "#f7768e" (Vermelho-Rosa / if, return, import)
-- * var_orange     = "#ff9e64" (Laranja / const, let, parâmetros)
-- * var_cyan       = "#7dcfff" (Ciano / Nome de Classes e Tipos)
-- * var_blue       = "#7aa2f7" (Azul / Nome de Funções e Métodos)
-- * var_green      = "#9ece6a" (Verde / Strings)
-- * var_teal       = "#1abc9c" (Teal / Números e Booleans)
-- * var_purple     = "#9d7cd8" (Roxo / this, super, null)
-- * var_foreground = "#c0caf5" (Branco-Azulado / Variáveis)
--
-- [ MAPEAMENTO DE PALAVRAS-CHAVE E GRUPOS ]
-- 1. Palavras de Declaração de Estrutura (class, function, interface, type):
--    -> Afetadas por: ["@keyword.function"], ["@keyword.type"]
--
-- 2. Controle de Fluxo & Exceções (if, else, return, try, catch, import):
--    -> Afetadas por: ["@keyword.repeat"], ["@keyword.conditional"], ["@keyword.return"]
--
-- 3. Declaração de Variáveis (const, let, var, private):
--    -> Afetadas por: ["@keyword.storage"]
--
-- 4. Nomes de Classes, Interfaces e Tipos (Ex: class *GestorDeSessao* {}):
--    -> Afetados por: Type, ["@type"], ["@lsp.type.class"], ["@lsp.type.interface"]
--
-- 5. Funções e Métodos Chamados (Ex: *autenticar()*):
--    -> Afetados por: Function, ["@function.call"], ["@method.call"]
-- ============================================================================
