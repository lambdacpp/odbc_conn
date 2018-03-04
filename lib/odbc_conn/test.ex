defmodule OdbcConn.Test do
  @timeout 60000
  def start do
    568056..568060
    |> Enum.map(fn i -> async_call_square_root(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)
  end

  defp async_call_square_root(i) do
    Task.async(fn ->
      OdbcConn.execute_sql("select loginid,name from ut_users where userid=#{i}")
    end )
  end

  defp await_and_inspect(task), do: task |> Task.await(@timeout) |> IO.inspect()
  
end
