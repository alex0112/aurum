defmodule Aurum.Coinbase.Client do

  @moduledoc """
  Low(er) level API client. This module isn't particularly intended for user consumption. You are probably looking for the module `Aurum.Coinbase` instead.

  This module generates the middleware needed to provide a valid client, applies the signature function to generate the correct HMAC signature (see `Aurum.Coinbase.Sign`), and performs the actual HTTP requests, and unwraps the interesting part of the response body for consumption in the `Coinbase` module.

  This module is an implementation of the [runtime middlware](https://github.com/teamon/tesla#runtime-middleware) technique outlined in the Tesla docs. Middlware must be generated at runtime in order to properly sign each request, since the Coinbase API requires a unique signature per request. See the Coinbase API Key Authentication method outlined in [the docs](https://developers.coinbase.com/api/v2#api-key) for details.
  """

  alias Aurum.Coinbase.Fetchers, as: Fetchers
  alias Aurum.Coinbase.Sign, as: Sign
  alias Tesla

  require Logger
  
  @base_url "https://api.coinbase.com"

  @doc """
  Generate a new API client struct. This function is will return a signed `%Tesla.Client{}` struct that can be used in later HTTP calls.
  """
  @spec new(method :: String.t(), path :: String.t(), body :: String.t(), middlware_fun :: (-> list())) :: %Tesla.Client{}
  def new(method, path, body \\ "", middleware_fun \\ &middleware/3) do
    middleware = middleware_fun.(method, path, body)

    Tesla.client(middleware)
  end

  @doc """
  Generate a list of required middleware for consumption by `Client.new/3`.
  """
  @spec middleware(method :: String.t(), path :: String.t(), body :: String.t(), base_url :: String.t(), header_fun :: (... -> list())) :: list()
  def middleware(method, path, body, base_url \\ @base_url, header_fun \\ &headers/3) do
    [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, header_fun.(method, path, body)}
    ]
  end

  @doc """
  Provide a list of headers to be used in the Coinbase request.

  This includes information such as:
  - The API key
  - The timestamp (required for signature verification)
  - The signature to be included with the request
  """
  @spec headers(method :: String.t(), path :: String.t(), body :: String.t(), key :: String.t(), sign_fun :: (String.t(), String.t(), String.t()-> String.t()),timestamp :: String.t()) :: list({String.t(), any()})
  def headers(method, path, body, key_fun \\ &Fetchers.fetch_key/0, sign_fun \\ &Sign.sign/4, timestamp_fun \\ &Fetchers.fetch_timestamp/0) do
    timestamp = timestamp_fun.()

    [
      {"CB-ACCESS-KEY", key_fun.()},
      {"CB-ACCESS-SIGN", sign_fun.(method, path, body, timestamp)},
      {"CB-ACCESS-TIMESTAMP", timestamp}
    ]
  end

  @doc """
  Assuming the response was successful and able to connect, return the body or the error message produced by the request. This function essentially strips away response metadata and gets to the meat of the response.

  In all other cases where it is passed something other than `{:error, message}` or `{:ok, response}` this function will return `{:error, resp}`.
  """
  @spec unwrap_response(resp :: {atom(), map()}) :: map()
  def unwrap_response(resp) do
    case resp do
      {:ok, resp}
	-> resp.body
      {:error, message}
	-> message
      err
	-> {:error, err}
    end
  end


  @doc """
  Generate a signed client struct for a GET request to this specific path and make the request. Return the resulting JSON as a map if all goes well.
  """
  @spec get(path :: String.t()) :: map() | {:error, any()}
  def get(path) do
    new("GET", path)
    |> Tesla.get(path)
    |> unwrap_response()
  end

  @doc """
  Generate a signed client struct for a DELETE request to this specific path and make the request. Return the resulting JSON as a map if all goes well.
  """
  @spec delete(path :: String.t()) :: map() | {:error, any()}
  def delete(path) do
    new("DELETE", path)
    |> Tesla.delete(path)
    |> unwrap_response()
  end

  @doc """
  Generate a signed client struct for a POST request to this specific path and with the provided body, then make the request. Return the resulting JSON as a map if all goes well.
  """
  @spec post(path :: String.t(), body :: String.t() | map()) :: map() | {:error, any()}
  def post(path, body) when is_map(body), do: post(path, Poison.encode!(body))
  def post(path, body) when is_binary(body) do
    new("POST", path, body)
    |> Tesla.post(path, body)
    |> unwrap_response()
  end

  @doc """
  Generate a signed client struct for a PUT request to this specific path and with the provided body, then make the request. Return the resulting JSON as a map if all goes well.
  """
  @spec put(path :: String.t(), body :: String.t() | map()) :: map() | {:error, any()}
  def put(path, body) when is_map(body), do: post(path, Poison.encode!(body))
  def put(path, body) when is_binary(body) do
    new("PUT", path, body)
    |> Tesla.put(path, body)
    |> unwrap_response()
  end

  @doc """
  Generate a signed client struct for a PATCH request to this specific path and with the provided body, then make the request. Return the resulting JSON as a map if all goes well.
  """
  @spec patch(path :: String.t(), body :: String.t() | map()) :: map() | {:error, any()}
  def patch(path, body) when is_map(body), do: post(path, Poison.encode!(body))
  def patch(path, body) when is_binary(body) do
    new("PATCH", path, body)
    |> Tesla.patch(path, body)
    |> unwrap_response()
  end

end
