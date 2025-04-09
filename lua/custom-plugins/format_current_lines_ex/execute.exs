# path/to/execute.exs

defmodule Execute do
  def main() do
    case File.read("/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/tmp.txt") do
      {:ok, result} ->
        # Декодируем входные данные из Base64
        # Обработка входных данных
        # Например, преобразуем все строки в верхний регистр
        output =
          result
          |> Code.format_string!()
          |> Enum.join()
          |> String.split("\n")
          |> Enum.map(fn string -> "\n\s\s" <> string end)
          |> Enum.join()

        File.write!(
          "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/result_tmp.txt",
          output
        )

      error ->
        File.write!(
          "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/result_tmp.txt",
          inspect(error)
        )
    end
  rescue
    e ->
      File.write!(
        "/home/artem/.config/nvim/lua/custom-plugins/format_current_lines_ex/result_tmp.txt",
        inspect(e)
      )
  end
end

  Execute.main()
