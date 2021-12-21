defmodule Aurum.Coinbase do

  @moduledoc """
  This module provides abstractions around basic HTTP methods within the context of the coinbase ecosystem. It takes care of using your Coinbase API Key/Secret to generate the required HMAC authentication signature based on the current timestamp so that the consumer of this module can focus on application logic.
  """
  alias Aurum.Coinbase.Client, as: Client

  @spec get(path :: String.t()) :: map()
  def get(path) do
    Client.get(path)
  end
  
  @spec post(path :: String.t(), body :: map()) :: map()
  def post(path, body) do
    Client.post(path, body)
  end

  @spec put(path :: String.t(), body :: map()) :: map()
  def put(path, body) do
    Client.put(path, body)
  end

  @spec patch(path :: String.t(), body :: map()) :: map()
  def patch(path, body) do
    Client.patch(path, body)
  end

  @spec delete(path :: String.t()) :: map()
  def delete(path) do
    Client.delete(path)
  end

end
