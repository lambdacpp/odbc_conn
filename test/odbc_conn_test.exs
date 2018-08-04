defmodule OdbcConnTest do
  use ExUnit.Case


  @timeout 60000

  test "Async Access DB" do
    568056..568060
    |> Enum.map(fn i -> async_call_square_root(i) end)
    |> Enum.each(fn task -> await_and_inspect(task) end)

  end
  
  defp async_call_square_root(i) do
    Task.async(fn ->
      OdbcConn.fetch_row("select loginid,convert(name,'UTF8','ZHS16CGB231280') name from ut_users where userid=#{i}")
    end )
  end

  defp await_and_inspect(task) do
    task |> Task.await(@timeout) |> IO.inspect() 
  end

end
