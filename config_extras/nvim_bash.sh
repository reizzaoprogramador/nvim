#!/bin/bash
# @file: config_extras/nvim_bash.sh
# @mission: Scripts Bash e funções utilitárias para manutenção do Neovim RZJ

# FUNCTIONS
cleanCacheNvim() {
    echo "🧹 Limpando cache do LuaJIT, registros ShaDa e cache temporário..."
    rm -rf "$HOME/.local/share/nvim/luajit-cache" \
           "$HOME/.local/state/nvim/shada" \
           "$HOME/.cache/nvim"
    echo "✨ Cache limpo com sucesso! Pronto para voar."
}
