-- Plug: para exibição de linhas verticais de guias de escopo/chaves no Neovim

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│", -- Caractere da linha vertical
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      highlight = { "Function", "Label" }, -- Destaca o bloco/chave em foco
    },
  },
}
