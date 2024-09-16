-- ~/.config/nvim/lua/replace_with_execute.lua

local M = {}
-- Функция для выполнения execute.exs с передачей данных через аргументы командной строки
local function run_execute_exs()
  -- Путь к вашему execute.exs
  local cmd = "elixir /home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/execute.exs"

  -- Запускаем внешний процесс
  local handle, err = io.popen(cmd, "r") -- "r" для чтения stdout, но если процесс пишет в файл, можно использовать "r" или "w"

  if not handle then
    -- Если не удалось запустить процесс, уведомляем пользователя
    vim.notify("Не удалось запустить команду: " .. (err or cmd), vim.log.levels.ERROR)
    return nil
  end

  -- Ждем завершения процесса
  local success, reason, exit_code = handle:close()

  if not success then
    -- Если процесс завершился с ошибкой, уведомляем пользователя
    vim.notify(
      string.format("Команда завершилась с ошибкой: %s (код %s)", reason, exit_code),
      vim.log.levels.ERROR
    )
    return nil
  end

  -- Путь к результирующему файлу
  local filename = "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/result_tmp.txt"

  -- Открываем файл для чтения
  local file, err = io.open(filename, "r")
  if not file then
    print("Ошибка открытия файла:", err)
    return nil
  end

  -- Читаем содержимое файла
  local content = file:read "*all"

  -- Закрываем файл
  file:close()

  return content
end

-- Основная функция плагина
function M.replace_selection_with_execute()
  -- Получаем текущий буфер
  local bufnr = vim.api.nvim_get_current_buf()

  -- Получаем режим выделения (visual)

  -- Получаем диапазон выделенных строк
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  -- Получаем выделенные строки
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)
  local input = table.concat(lines, "\n")
  vim.notify(input)
  -- Кодируем входные данные для передачи в аргументы командной строки
  -- Здесь мы используем base64, чтобы безопасно передать данные
  -- Выполняем execute.exs с аргументом
  local filename = "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/tmp.txt"

  -- Открываем файл в режиме записи ("w")
  local file, err = io.open(filename, "w")

  -- Проверяем, успешно ли открыт файл
  if not file then
    print("Ошибка открытия файла:", err)
    return
  end

  -- Строка для записи

  -- Пишем строку в файл
  file:write(input)

  -- Закрываем файл
  file:close()

  local output = run_execute_exs()

  if not output then
    vim.api.nvim_err_writeln "Не удалось выполнить execute.exs"
    return
  end
  vim.notify(output)
  -- Разбиваем вывод на строки
  local output_lines = {}
  for line in output:gmatch "[^\r\n]+" do
    table.insert(output_lines, line)
  end

  -- Заменяем выделенные строки на вывод execute.exs
  vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, output_lines)
end

return M
