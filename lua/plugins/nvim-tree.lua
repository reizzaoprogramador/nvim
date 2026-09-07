-- @file: lua/plugins/nvim-tree.lua
-- @mission: explorador de arquivos (nvim-tree) com abertura automática no boot

return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false, -- Carrega no boot para abrir a sidebar de imediato
    keys = {
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
        desc = "nvim-tree: Toggle (Fora do Projeto / Raiz)",
      },
    },
    opts = {
      view = {
        side = "right", -- Define o menu na direita da tela
      },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      filters = { dotfiles = false },
      -- Configuração moderna de mappings
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Carrega os mappings padrões primeiro
        api.config.mappings.default_on_attach(bufnr)

        -- Suas customizações (Substituem ou adicionam)
        vim.keymap.set("n", "n", api.fs.create, opts("Create"))
        vim.keymap.set("n", "r", api.fs.remove, opts("Remove"))
        vim.keymap.set("n", "d", api.fs.copy.node, opts("Copy"))
        vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
        vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
        vim.keymap.set("n", "e", api.fs.rename, opts("Rename"))
        vim.keymap.set("n", "<C-h>", api.tree.toggle_hidden_filter, opts("Toggle Dotfiles"))

        -- Navegação Livre (Sair do Projeto)
        vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "~", function()
          api.tree.change_root("~")
        end, opts("CD Home"))
      end,
    },
    config = function(_, opts)
      -- Aplica todas as suas configurações do opts
      require("nvim-tree").setup(opts)

      -- Abre o nvim-tree automaticamente ao entrar no Neovim e devolve o foco pro código
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          require("nvim-tree.api").tree.open()
          vim.cmd("wincmd p") -- Move o foco da janela da sidebar de volta para o editor de código
        end,
      })
    end,
  },
}
