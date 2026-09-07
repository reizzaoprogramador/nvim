-- @file: ~/.config/nvim/lua/plugins/theme.lua
-- @mission: Paleta Omni/Dracula com separacao entre Keywords e Nomes de Classe + Ciano Claro

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

          -- Paleta Omni / Dracula Reajustada (Prefixo var_)
          local var_pink = "#ff79c6"        -- Controle de Fluxo / Exceções / Keyword 'class' e 'function'
          local var_green = "#50fa7b"       -- Funções e Métodos
          local var_yellow = "#f1fa8c"      -- Strings / Textos
          local var_purple = "#bd93f9"      -- Números, Bools, "this", "new", "null"
          local var_orange = "#ffb86c"      -- Declaradores (const, let) e Parâmetros
          local var_comment = "#6272a4"     -- Comentários
          local var_foreground = "#f8f8f2"  -- Texto Normal / Variáveis
          local var_cyan_light = "#78dce8"  -- Ciano Mais Claro para Nomes de Classes, Tipos e Interfaces

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
            CursorLineNr = { bg = bg_custom, fg = var_yellow },
            CursorLine = { bg = "#111111" },
            
            NvimTreeNormal = { bg = bg_custom },
            NvimTreeNormalNC = { bg = bg_custom },

            Pmenu = { bg = bg_dark, fg = "#ffffff" },
            PmenuSel = { bg = purple_highlight, fg = "#ffffff" },

            StatusLine = { bg = bg_custom, fg = "#ffffff" },
            TabLineSel = { bg = active_tab, fg = "#ffffff" },

            -------------------------------------------------------------------
            -- 2. PALAVRAS-CHAVE x NOMES DE ESTRUTURAS (SEPARADOS)
            -------------------------------------------------------------------

            -- A) PALAVRA-CHAVE "class", "function", "interface", "type" (ROSA)
            ["@keyword.function"] = { fg = var_pink },
            ["@keyword.type"] = { fg = var_pink },
            ["@keyword.modifier"] = { fg = var_pink },

            -- B) CONTROLE DE FLUXO & IMPORTS (ROSA)
            ["@keyword.repeat"] = { fg = var_pink },
            ["@keyword.conditional"] = { fg = var_pink },
            ["@keyword.return"] = { fg = var_pink },
            ["@keyword.exception"] = { fg = var_pink },
            ["@keyword.import"] = { fg = var_pink },
            ["@keyword.coroutine"] = { fg = var_pink },
            ["@keyword.operator"] = { fg = var_pink },

            -- C) DECLARAÇÃO DE VARIÁVEIS (LARANJA)
            ["@keyword.storage"] = { fg = var_orange }, -- const, let, var

            -- D) PALAVRAS DE ESCOPO E NULOS (ROXO)
            ["@variable.builtin"] = { fg = var_purple, style = { "italic" } }, -- this
            ["@constant.builtin"] = { fg = var_purple }, -- null, undefined

            -- FALLBACK PARA KEYWORDS GENÉRICAS
            ["@keyword"] = { fg = var_pink },
            Keyword = { fg = var_pink },

            -------------------------------------------------------------------
            -- 3. NOMES DAS CLASSES, TIPOS E INTERFACES (CIANO MAIS CLARO)
            -------------------------------------------------------------------
            Type = { fg = var_cyan_light },
            ["@type"] = { fg = var_cyan_light },
            ["@type.builtin"] = { fg = var_cyan_light },
            ["@type.definition"] = { fg = var_cyan_light },
            ["@lsp.type.class"] = { fg = var_cyan_light },
            ["@lsp.type.interface"] = { fg = var_cyan_light },
            ["@lsp.type.type"] = { fg = var_cyan_light },

            -------------------------------------------------------------------
            -- 4. OUTROS ELEMENTOS DE SINTAXE
            -------------------------------------------------------------------

            -- Funções e Chamadas de Métodos (Verde)
            Function = { fg = var_green },
            ["@function"] = { fg = var_green },
            ["@function.call"] = { fg = var_green },
            ["@method"] = { fg = var_green },
            ["@method.call"] = { fg = var_green },

            -- Textos / Strings (Amarelo)
            String = { fg = var_yellow },
            ["@string"] = { fg = var_yellow },

            -- Comentários (Cinza-azulado com itálico)
            Comment = { fg = var_comment, style = { "italic" } },
            ["@comment"] = { fg = var_comment, style = { "italic" } },

            -- Identificadores e Parâmetros
            Identifier = { fg = var_foreground },
            ["@variable"] = { fg = var_foreground },
            ["@parameter"] = { fg = var_orange },

            -- Números e Booleanos (Roxo)
            Number = { fg = var_purple },
            Boolean = { fg = var_purple },
            ["@number"] = { fg = var_purple },
            ["@boolean"] = { fg = var_purple },

            -- Operadores (+, -, =, =>) (Rosa)
            Operator = { fg = var_pink },
            ["@operator"] = { fg = var_pink },

            -------------------------------------------------------------------
            -- 5. OVERRIDES DE SEMANTIC TOKENS DO LSP
            -------------------------------------------------------------------
            ["@lsp.type.keyword"] = {}, -- Deixa o Treesitter controlar
            ["@lsp.typemod.keyword.control"] = { fg = var_pink },
          }
        end,
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}

-- ============================================================================
-- README_PLUGIN / GUIA DE GRUPOS E CORES DA SINTAXE (ESTILO OMNI / DRACULA)
-- ============================================================================
-- Este guia documenta qual grupo do Treesitter/LSP afeta cada elemento visual:
--
-- [ VARIÁVEIS DE COR UTILIZADAS ]
-- * var_pink     = "#ff79c6" (Rosa)
-- * var_orange   = "#ffb86c" (Laranja)
-- * var_cyan_light = "#78dce8" (Ciano Claro)
-- * var_purple   = "#bd93f9" (Roxo)
-- * var_green    = "#50fa7b" (Verde)
-- * var_yellow   = "#f1fa8c" (Amarelo)
-- * var_foreground = "#f8f8f2" (Texto Normal / Branco Suave)
--
-- [ MAPEAMENTO DE PALAVRAS-CHAVE E GRUPOS ]
-- 1. Palavras de Declaração de Estrutura (class, function, interface, type):
--    -> Afetadas por: ["@keyword.function"], ["@keyword.type"]
--
-- 2. Controle de Fluxo & Exceções (if, else, return, try, catch, import):
--    -> Afetadas por: ["@keyword.repeat"], ["@keyword.conditional"], ["@keyword.return"]
--
-- 3. Declaração de Variáveis (const, let, var):
--    -> Afetadas por: ["@keyword.storage"]
--
-- 4. Nomes de Classes, Interfaces e Tipos (Ex: class *MinhaClasse* {}):
--    -> Afetados por: Type, ["@type"], ["@lsp.type.class"], ["@lsp.type.interface"]
--
-- 5. Palavras de Escopo e Nulos (this, super, new, null, undefined):
--    -> Afetadas por: ["@variable.builtin"], ["@constant.builtin"]
--
-- 6. Funções e Métodos Chamados (Ex: *minhaFuncao()*):
--    -> Afetados por: Function, ["@function.call"], ["@method.call"]
-- ============================================================================
