defmodule Tablex.Parser.Expression.Date do
  @moduledoc false

  import NimbleParsec
  import Tablex.Parser.Space, only: [eow: 0]

  def date do
    ascii_string([?0..?9], 4)
    |> string("-")
    |> ascii_string([?0..?1], 1)
    |> ascii_string([?0..?9], 1)
    |> string("-")
    |> ascii_string([?0..?3], 1)
    |> ascii_string([?0..?9], 1)
    |> lookahead(eow())
    |> reduce({__MODULE__, :trans_date, []})
  end

  @doc false
  def trans_date(parts) do
    parts |> to_string() |> Date.from_iso8601!()
  end

end
