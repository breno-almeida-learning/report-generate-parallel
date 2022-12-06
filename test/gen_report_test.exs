defmodule GenReportTest do
  use ExUnit.Case

  alias GenReport
  alias GenReport.Support.ReportFixture

  # @file_names ["part_1.csv", "part_2.csv", "part_3.csv"]
  @file_names ["gen_report.csv"]

  describe "build/1" do
    test "When passing file names return a report" do
      response = GenReport.build(@file_names)

      assert response == ReportFixture.build()
    end

    test "When no filename was given, returns an error" do
      response = GenReport.build()

      assert response == {:error, "Insira uma lista de nomes de arquivos"}
    end
  end
end
