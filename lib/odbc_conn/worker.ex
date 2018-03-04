defmodule OdbcConn.Worker do

 use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    conn_str = Application.get_env(:odbc_conn, :conn_str)
    conn_opts = Application.get_env(:odbc_conn, :conn_opts)
    {:ok, conn} = :odbc.connect(to_charlist(conn_str), conn_opts) 
    {:ok, conn}
  end

  def handle_call({:exec,sql}, _from, conn) do
    {:reply, :odbc.sql_query(conn, sql), conn}  
  end

  
  def terminate(_reason, conn) do
    :odbc.disconnect conn
  end

end




