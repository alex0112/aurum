defmodule Aurum.Coinbase do

  @moduledoc """
  This module provides abstractions around basic HTTP methods within the context of the coinbase ecosystem. It takes care of using your Coinbase API Key/Secret to generate the required HMAC authentication signature based on the current timestamp so that the consumer of this module can focus on application logic.
  """

  alias Aurum.Coinbase.Client, as: Client

  @doc """
  Perform a signed get request to the specified path. Due to some of the implementation details the path string must begin with `/v2` in order to correctly call the API.
  """
  @spec get(path :: String.t()) :: map()
  def get(path) do
    Client.get(path)
  end
  
  @doc """
  Perform a signed post request to the specified path. Due to some of the implementation details the path string must begin with `/v2` in order to correctly call the API.

  The request body can be in the form of a map for your convienience, for example:


  ```
  Coinbase.post("/v2/accounts/<account_id>/sells", %{total: 10, currency: "USD"})
  ```

  Is equivalent to:

  ```
  Coinbase.post("/v2/accounts/<account_id>/sells", ~S({"total": "10", "currency": "USD"}))
  ```
  """
  @spec post(path :: String.t(), body :: map()) :: map()
  def post(path, body) do
    Client.post(path, body)
  end

  @doc """
  Perform a signed put request to the specified path. Due to some of the implementation details the path string must begin with `/v2` in order to correctly call the API.

  The request body can be in the form of a map for your convienience, for example:

  ```
  Coinbase.put("/v2/some/resource", %{total: 10, currency: "USD"})
  ```

  Is equivalent to:

  ```
  Coinbase.put("/v2/some/resource", ~S({"total": "10", "currency": "USD"}))
  ```
  """
  @spec put(path :: String.t(), body :: map()) :: map()
  def put(path, body) do
    Client.put(path, body)
  end

  @doc """
  Perform a signed put request to the specified path. Due to some of the implementation details the path string must begin with `/v2` in order to correctly call the API.

  The request body can be in the form of a map for your convienience, for example:

  ```
  Coinbase.patch("/v2/some/resource", %{total: 10, currency: "USD"})
  ```

  Is equivalent to:

  ```
  Coinbase.patch("/v2/some/resource", ~S({"total": "10", "currency": "USD"}))
  ```
  """
  @spec patch(path :: String.t(), body :: map()) :: map()
  def patch(path, body) do
    Client.patch(path, body)
  end

  @doc """
  Perform a signed delete request to the specified path. Due to some of the implementation details the path string must begin with `/v2` in order to correctly call the API.
  """
  @spec delete(path :: String.t()) :: map()
  def delete(path) do
    Client.delete(path)
  end

end
