defmodule Aurum.Coinbase do

  @moduledoc """
  This module provides abstractions around basic HTTP methods within the context of the coinbase ecosystem. It's loosley 
  """
  alias Aurum.Coinbase.Client, as: Client
  alias Tesla

  def get(path) do
    Client.get(path)
  end

  def post(path, body) do
    Client.post(path, body)
  end

  def put(path, body) do
    Client.put(path, body)
  end

  def patch(path, body) do
    Client.patch(path, body)
  end

  def delete(path) do
    Client.delete(path)
  end

end
