-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      -- add more arguments for adding more treesitter parsers
    },
    textobjects = {
      select = {
        enable = false,
      },
    },

    indent = {
      enable = true,
      disable = { "dart" },
    },
  },
}
