# @file: config_extras/nvim_fish.fish
# @mission: Scripts Fish e funções utilitárias para manutenção do Neovim RZJ

# ALIASES
alias onvim='cd $NVIM_DIR; ls -a'

# FUNCTIONS
function cleanCacheNvim --description "Limpa cache do LuaJIT, ShaDa e temporarios do Neovim"
    set_color yellow --bold
    echo "🧹 Limpando cache do LuaJIT, registros ShaDa e cache temporário..."
    set_color normal

    rm -rf "$HOME/.local/share/nvim/luajit-cache" \
           "$HOME/.local/state/nvim/shada" \
           "$HOME/.cache/nvim"

    set_color green --bold
    echo "✨ Cache limpo com sucesso! Pronto para voar."
    set_color normal
end
