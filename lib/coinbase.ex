defmodule Aurum.Coinbase do

  @moduledoc """
  This module provides abstractions around basic HTTP methods within the context of the coinbase ecosystem. It's loosley 
  """
  alias Aurum.Coinbase.Client, as: Client
  alias Tesla

  @spec get(path :: String.t(), client_module :: module()) :: map()
  def get(path, client_module \\ Tesla) do
    Client.new(path, "GET")
    |> client_module.get(path)
    |> Client.unwrap_response()
  end

  @spec post(path :: String.t(), body :: String.t(), client_module :: module()) :: map()
  def post(path, body, client_module \\ Tesla) do
    Client.new(path, "POST", body)
    |> client_module.post(path, body)
    |> Client.unwrap_response()
  end

  @spec put(path :: String.t(), body :: String.t(), client_module :: module()) :: map()
  def put(path, body, client_module \\ Tesla) do
    Client.new(path, "POST", body)
    |> client_module.put(path, body)
    |> Client.unwrap_response()
  end

  @spec delete(path :: String.t(), client_module :: module()) :: map()
  def delete(path, client_module \\ Tesla) do
    Client.new(path, "DELETE")
    |> client_module.delete(path)
    |> Client.unwrap_response()
  end

end
