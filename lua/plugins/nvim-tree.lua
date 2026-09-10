-- @file: lua/plugins/nvim-tree.lua
-- @mission: explorador de arquivos (nvim-tree) com abertura automática no boot, atalhos padronizados seguros e atalho ee para toggle

return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  keys = {
    {
      "ee",
      function()
        require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
      end,
      desc = "nvim-tree: Toggle Explorer (ee)",
    },
    {
      "<leader>e",
      function()
        require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
      end,
      desc = "nvim-tree: Toggle (Projeto)",
    },
    {
      "<leader>E",
      function()
        require("nvim-tree.api").tree.toggle({ path = "/", focus = true })
      end,
      desc = "nvim-tree: Toggle (Raiz)",
    },
  },
  opts = {
    view = {
      side = "right",
    },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    filters = { dotfiles = false },
  },
  config = function(_, opts)
    local api = require("nvim-tree.api")

    opts.renderer = opts.renderer or {}
    opts.on_attach = function(bufnr)
      local function opts_map(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Carrega os padrões do plugin primeiro
      api.config.mappings.default_on_attach(bufnr)

      -- Padrão VIM unificado sem colisões
      vim.keymap.set("n", "q", api.tree.close, opts_map("Quit"))
      vim.keymap.set("n", "a", api.fs.create, opts_map("Add"))
      vim.keymap.set("n", "d", api.fs.remove, opts_map("Delete"))
      vim.keymap.set("n", "c", api.fs.rename, opts_map("Change"))
      
      -- Atalhos seguros ajustados para evitar conflito com os padrões do nvim-tree
      vim.keymap.set("n", "h", api.tree.toggle_hidden_filter, opts_map("Toggle Dotfiles (Ocultos)"))
      vim.keymap.set("n", "H", function()
        api.tree.change_root(vim.fn.expand("$HOME"))
      end, opts_map("CD Home"))
    end

    require("nvim-tree").setup(opts)

    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = function()
        require("nvim-tree.api").tree.open()
        vim.cmd("wincmd p")
      end,
    })
  end,
}

-- ==============================================================================
-- @README_Plugin
-- - O que deu certo (Solução Definitiva):
--    1. Adicionado o atalho `ee` no modo normal para abrir/fechar (toggle) rapidamente o explorador de arquivos.
--    2. Evitar remapear teclas de letra minúscula (`u`, `.`) que já pertencem ao mapa padrão de navegação interna do nvim-tree (`u` original = subir diretório). 
-- @ATENCAO: Testar visualiza as mudancas em outro console/terminal, as vezes o q esta (ou o yazi esta em cache), ja aconteceu isso cuidado .
--    3. Uso da tecla `H` (maiúscula) para alternar arquivos ocultos (`toggle_hidden_filter`), eliminando qualquer conflito de colisão de buffer.
--    4. Preservação das funções essenciais (`q` sair, `a` criar, `d` deletar, `c` renomear, `~` ir para home).
--
-- # REPLICADO EM APPS OS PRINCIPAIS COMANDOS VIM (se conflitar use as opcoes apos o ||)
-- criar = a, significado: add,, pt: adicionar,
-- deletar = d, significado: delete, pt: deletar,
-- copiar = y, significado: yank, pt: copiar
-- colar = p, significado: paste, pt: colar,
-- recortar = x, significado: cut, pt: recortar
-- renomear = c, significado: change, pt: modificar
-- desfazer = u, significado: undo, pt: desfazer
-- refazer = U, significado: redo, pt: refazer
-- mover_esquerda_ou_subir_nivel = h || seta_esquerda, significado: left, pt: esquerda_ou_subir_nivel
-- mover_baixo = j || seta_baixo, significado: down, pt: baixo
-- mover_cima = k || seta_cima, significado: up, pt: cima
-- mover_direita_ou_entrar = l || seta_direita, significado: right, pt: direita_ou_entrar
-- mostrar_ocultos: . <ponto> || h
-- ir_para_casa_home: ~ || H
-- sair: q, significado: quit, pt: sair
--
-- ==============================================================================