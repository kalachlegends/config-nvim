-- ~/.config/nvim/lua/plugins.lua

return {
  -- Другие плагины...

  -- Добавляем ваш локальный плагин
  {
    "format_current_lines", -- Имя плагина (может быть любое)
    dir = "~/.config/nvim/lua/custom-plugins/format_current_lines_ex/format_current_lines.lua",
    type = "local",
    config = function()
      local replace_with_execute = require "custom-plugins.format_current_lines_ex.format_current_lines"

      vim.api.nvim_create_user_command(
        "ReplaceWithExecute",
        function() replace_with_execute.replace_selection_with_execute() end,
        { range = true, nargs = 0, bang = false }
      )

      vim.api.nvim_set_keymap("v", "<leader>mf", ":ReplaceWithExecute<CR>", { noremap = true, silent = true })
    end,
  },
}
