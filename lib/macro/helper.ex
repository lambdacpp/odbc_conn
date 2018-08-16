defmodule OdbcConn.Helper do

  defmacro deffetchrow({name, _ , params}, [do: query]) when is_atom(name) and is_list(params)  do
    quote do
      def unquote(name)(unquote_splicing(params)) do
        OdbcConn.fetch_row (
          unquote(query)
        )
      end
    end
  end

end
