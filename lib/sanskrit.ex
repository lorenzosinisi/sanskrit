defmodule Sanskrit do
  @moduledoc """
  Documentation for Sanskrit.
  """

  @doc """
  Parse a binary

  Check the other moduledocs for more examples


  """

  def parse(str) when is_binary(str) do
    case Sanskrit.Parser.parse(str) do
      parsed when is_list(parsed) ->
        {:ok, List.flatten(parsed)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
