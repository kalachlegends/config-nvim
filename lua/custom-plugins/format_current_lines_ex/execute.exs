# path/to/execute.exs

defmodule Execute do
  def main() do
    case File.read("/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/tmp.txt") do
       {:ok, result}->

        # Декодируем входные данные из Base64
        # Обработка входных данных
        # Например, преобразуем все строки в верхний регистр
        output =
          result
          |> Code.format_string!()
          |> Enum.join()
          |> String.split("\n")
          |> Enum.map(fn string -> "\n\t" <> string end)
          |> Enum.join()
        # Вывод результата
        File.write!("/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/result_tmp.txt", output) 

      _ ->
        IO.puts("Не удалось почитать файл")
    end
  end
end

Execute.main()

