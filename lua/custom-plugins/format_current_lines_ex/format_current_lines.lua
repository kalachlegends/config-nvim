-- ~/.config/nvim/lua/replace_with_execute.lua

local M = {}
local function run_execute_exs()
  local cmd = "elixir /home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/execute.exs"

  local handle, err = io.popen(cmd, "r") -- "r" для чтения stdout, но если процесс пишет в файл, можно использовать "r" или "w"

  if not handle then
    vim.notify("Не удалось запустить команду: " .. (err or cmd), vim.log.levels.ERROR)
    return nil
  end

  local success, reason, exit_code = handle:close()

  if not success then
    vim.notify(
      string.format("Команда завершилась с ошибкой: %s (код %s)", reason, exit_code),
      vim.log.levels.ERROR
    )
    return nil
  end

  local filename = "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/result_tmp.txt"

  local file, err = io.open(filename, "r")
  if not file then
    print("Ошибка открытия файла:", err)
    return nil
  end

  local content = file:read "*all"

  file:close()

  return content
end

function M.replace_selection_with_execute()
  local bufnr = vim.api.nvim_get_current_buf()


  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
  local input = table.concat(lines, "\n")
  local filename = "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/tmp.txt"

  local file, err = io.open(filename, "w")

  if not file then
    print("Ошибка открытия файла:", err)
    return
  end


  file:write(input)

  file:close()

  local output = run_execute_exs()

  if not output then
    vim.api.nvim_err_writeln "Не удалось выполнить execute.exs"
    return
  end
  local output_lines = {}
  for line in output:gmatch "[^\r\n]+" do
    table.insert(output_lines, line)
  end

  vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, output_lines)
end

return M
