defmodule Tablex.Parser.Expression.Date do
  @moduledoc false

  import NimbleParsec

  def date do
    integer(4)
    |> ignore(string("-"))
    |> integer(2)
    |> ignore(string("-"))
    |> integer(2)
    |> reduce({__MODULE__, :trans_date, []})
  end

  @doc false
  def trans_date([yyyy, mm, dd]) do
    Date.new!(yyyy, mm, dd)
  end

end
