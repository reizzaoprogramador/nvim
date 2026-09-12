#!/usr/bin/env lua
-- @file: lua/plugins/treesitter.lua
-- @mission: Highlight e analise sintatica do codigo

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local status, configs = pcall(require, "nvim-treesitter.configs")
    if not status then
      return
    end

    configs.setup({
      ensure_installed = { "lua", "vim", "vimdoc", "javascript", "typescript", "go", "bash", "json", "html", "css" },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
  end,
}

-- ==============================================================================
-- @README_FILE
-- CONFIGURAÇÃO DO NVIM-TREESITTER PARA REALCE DE SINTAXE E ÁRVORE SINTÁTICA.
--
-- INCLUÍDO:
-- - PARSERS ESSENCIAIS: LUA, VIM, VIMDOC, JAVASCRIPT, TYPESCRIPT, GO, BASH, JSON, HTML, CSS.
-- - AUTO_INSTALL ATIVO PARA COMPILAR NOVOS PARSERS AO ABRIR ARQUIVOS CORRESPONDENTES.
-- - SUPORTE A REENTRÂNCIA SEGURA UTILIZANDO PCALL.
--
-- @PorqueFuncionou:
-- 1. INSTALAÇÃO DO BUILD-ESSENTIAL: O TREESITTER COMPILA OS PARSERS EM C (`.SO`). A PRESENÇA
--    DO `GCC` / `BUILD-ESSENTIAL` NO SISTEMA PERMITIU GERAR O PARSER DE LUA CORRETAMENTE.
-- 2. LIMPEZA E REINSTALL (:TSINSTALL LUA): REMOVEU A BIBLIOTECA INCOMPLETA/CORROMPIDA
--    E GEROU O PARSER NATIVO COMPATÍVEL COM O RUNTIME DO NEOVIM.
--
-- COMO USAR:
-- 1. CERTIFIQUE-SE DE TER O `GCC` INSTALADO NO SO (`sudo apt install build-essential`).
-- 2. CASO DÊ ERRO EM OUTRA LINGUAGEM, RODE `:TSInstall <linguagem>` DENTRO DO EDITOR.
-- ==============================================================================