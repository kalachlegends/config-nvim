return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(plugin, opts)
      local actions = require "telescope.actions"
      require "astronvim.plugins.configs.telescope"(plugin, opts)
      opts.defaults = {
        mappings = {
          i = {
            ["<c-t>"] = actions.file_vsplit,
          },
        },
      }
    end,
  },
}
