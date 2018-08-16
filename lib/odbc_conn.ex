defmodule OdbcConn do
  @moduledoc """
  Documentation for OdbcConn.
  """

  @doc """

  """
  def execute_sql(sql) when is_binary(sql), do: execute_sql(to_charlist(sql))

  def execute_sql(sql) when is_list(sql) do
    try do
      :poolboy.transaction(
        :worker, 
        fn(pid) -> GenServer.call(pid,{:exec,sql}) end,
        :infinity
      )
    rescue
      _ -> "Error"
    end
  end

  def fetch_row(sql_string) do
    {:selected, header, rec} = execute_sql(sql_string)

    if length(rec) == 0 do
      :notfound
    else
      header_atom = Enum.map(header,&(&1 |> to_string |> String.downcase |> String.to_atom))
      value_list = Enum.map( rec |> hd |> Tuple.to_list ,fn v -> if is_list(v), do: IO.iodata_to_binary(v), else: v end )
      rec |> IO.inspect
      value_list |> IO.inspect
      [header_atom, value_list] |> List.zip |> Map.new
    end
  end

  def fetch_column(sql_string) do
    {:selected, _header, rec} = execute_sql(sql_string)
    Enum.map( rec ,fn e -> e |> Tuple.to_list |>hd |> to_string end)
  end

  defmacro __using__(_opts) do
    quote do
      import OdbcConn.Helper
    end
  end
end
