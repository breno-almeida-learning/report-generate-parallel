defmodule GenReport do
  alias GenReport.Parser

  def build(fileNames) when is_list(fileNames) and length(fileNames) > 0 do
    fileNames
    |> Task.async_stream(&Parser.parse_file(&1))
    |> Enum.map(&handle_report/1)
    |> Enum.reduce(%{}, fn line, result -> merge_reports(line, result) end)
  end

  def build() do
    {:error, "Insira uma lista de nomes de arquivos"}
  end

  defp merge_reports(
         current,
         result
       ) do
    result = %{
      "all_hours" => handle_merge(current["all_hours"], result["all_hours"] || %{}),
      "hours_per_month" =>
        Enum.reduce(current["hours_per_month"], %{}, fn {personName, months}, merged ->
          Map.put(merged, personName, handle_merge(months, result[personName] || %{}))
        end),
      "hours_per_year" =>
        Enum.reduce(current["hours_per_year"], %{}, fn {personName, years}, merged ->
          Map.put(merged, personName, handle_merge(years, result[personName] || %{}))
        end)
    }

    result
  end

  defp handle_merge(value1, value2) do
    Map.merge(value1, value2, fn _key, v1, v2 -> v1 + v2 end)
  end

  defp handle_report({:ok, result}) do
    %{
      "all_hours" => handle_total_hours(result),
      "hours_per_month" => handle_hours_per_month(result),
      "hours_per_year" => handle_hours_per_year(result)
    }
  end

  # GenReport.build("gen_report.csv")
  defp handle_total_hours(data) do
    data
    |> Enum.reduce(%{}, fn [name, hours, _day, _month, _year], result ->
      Map.put(result, name, (result[name] || 0) + hours)
    end)
  end

  defp handle_hours_per_month(data) do
    data
    |> Enum.reduce(%{}, fn [name, hours, _day, month, _year], result ->
      Map.put(
        result,
        name,
        Map.put(result[name] || %{}, month, (result[name][month] || 0) + hours)
      )
    end)
  end

  defp handle_hours_per_year(data) do
    data
    |> Enum.reduce(%{}, fn [name, hours, _day, _month, year], result ->
      Map.put(
        result,
        name,
        Map.put(result[name] || %{}, year, (result[name][year] || 0) + hours)
      )
    end)
  end
end
