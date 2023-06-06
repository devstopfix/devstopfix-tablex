defmodule Tablex.DateTest do
  use ExUnit.Case, async: true
  import Tablex, only: [new: 1]

  describe "Data comparison operators" do
    test "not equals" do
      table = new("""
      F dt (date)    || result
      1 !=2014-09-18 || Elixir
      """)
      assert %{result: "Elixir"} == Tablex.decide(table, [dt: Date.utc_today()])
    end
    test "equals" do
      table = new("""
      F dt (date)  || result
      1 2014-09-18 || "Elixir 1.0"
      """)
      assert %{result: "Elixir 1.0"} == Tablex.decide(table, [dt: ~D[2014-09-18]])
    end
    test "any" do
      table = new("""
      F dt (date)  || result
      1 _          || Elixir
      """)
      assert %{result: "Elixir"} == Tablex.decide(table, [dt: Date.utc_today()])
    end
    test "gt" do
      table = new("""
      C dt (date)    || result
      1 >2014-09-17  || lt
      2 >2014-09-18  || eq
      3 >2014-09-19  || gt
      """)
      assert [%{result: "eq"}, %{result: "gt"}] == Tablex.decide(table, [dt: "2014-09-18"])
    end

    test "gte" do
      table = new("""
      C dt (date)    || result
      1 >=2014-09-17 || lt
      2 >=2014-09-18 || eq
      3 >=2014-09-19 || gt
      """)
      assert [%{result: "eq"}, %{result: "gt"}] == Tablex.decide(table, [dt: "2014-09-18"])
    end

    test "lt" do
      table = new("""
      C dt (date)    || result
      1 <2014-09-17  || lt
      2 <2014-09-18  || eq
      3 <2014-09-19  || gt
      """)
      assert [%{result: "lt"}] == Tablex.decide(table, [dt: "2014-09-18"])
    end

    test "lte" do
      table = new("""
      C dt (date)    || result
      1 <=2014-09-17 || lt
      2 <=2014-09-18 || eq
      3 <=2014-09-19 || gt
      """)
      assert [%{result: "lt"}, %{result: "eq"}] == Tablex.decide(table, [dt: "2014-09-18"])
    end

  end

  describe "Date comparison range" do
    test "first >=", %{table: table} do
      assert %{generation: "Gen X"} == decide(table, ~D[1965-01-01])
    end
    test "first >", %{table: table} do
      assert %{generation: "Gen X"} == decide(table, ~D[1965-01-02])
    end
    test "first <", %{table: table} do
      assert %{generation: "Gen X"} == decide(table, ~D[1980-12-31])
    end
    test "second", %{table: table} do
      assert %{generation: "Millennial" } == decide(table, ~D[1990-07-05])
    end
    test "third", %{table: table} do
      assert %{generation: "Gen Z"}  == decide(table, ~D[1997-02-01])
    end
    test "miss before", %{table: table} do
      assert nil == decide(table, ~D[1964-01-01])
    end
    test "miss after", %{table: table} do
      assert nil == decide(table, ~D[2013-01-01])
    end

    setup do
      table = """
      F born_after (date)  born_before (date) || generation
      1 >=1965-01-01       <1981-01-01        || "Gen X"
      2 >=1981-01-01       <1996-01-01        || Millennial
      3 >=1997-01-01       <2012-01-01        || "Gen Z"
      """
      %{table: Tablex.new(table)}
    end

  end

  defp decide(table, date) do
    Tablex.decide(table, [born_after: date, born_before: date])
  end

end
