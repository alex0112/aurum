defmodule Aurum do

  @enforce_keys [:symbol, :client]
  defstruct symbol: nil, client: nil
  
  @moduledoc """
  Documentation for Aurum.
  """

  @doc """
  define a new Aurum
  """
  def new(symbol: symbol, client: client) do
    unless symbol && client, do: raise ArgumentError
    %Aurum{symbol: symbol, client: client}
  end
end
