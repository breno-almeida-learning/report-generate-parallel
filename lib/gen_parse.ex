defmodule GenReport.Parser do
  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  def parse_file(fileName) do
    fileName
    |> File.stream!()
    |> Enum.map(fn item -> handle_line(item) end)
  end

  defp handle_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &String.downcase/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, fn item -> @months[item] end)
    |> List.update_at(4, &String.to_integer/1)
  end
end
