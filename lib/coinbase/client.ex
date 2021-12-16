defmodule Aurum.Coinbase.Client do
  alias Aurum.Coinbase.Fetchers, as: Fetchers
  alias Aurum.Coinbase.Sign, as: Sign
  alias Tesla

  require Logger
  
  @base_url "https://api.coinbase.com"

  @spec new(method :: String.t(), path :: String.t(), body :: String.t(), middlware_fun :: (-> list())) :: %Tesla.Client{}
  def new(method, path, body \\ "", middleware_fun \\ &middleware/3) do
    middleware = middleware_fun.(method, path, body)

    Tesla.client(middleware)
  end

  def middleware(method, path, body, base_url \\ @base_url, header_fun \\ &headers/3) do
    [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, header_fun.(method, path, body)}
    ]
  end

  @doc """
  Provide a list of headers to be used in the Coinbase request. 
  """
  @spec headers(method :: String.t(), path :: String.t(), body :: String.t(), key :: String.t(), sign_fun :: (String.t(), String.t(), String.t()-> String.t()),timestamp :: String.t()) :: list(tuple())
  def headers(method, path, body, key_fun \\ &Fetchers.fetch_key/0, sign_fun \\ &Sign.sign/4, timestamp_fun \\ &Fetchers.fetch_timestamp/0) do
    timestamp = timestamp_fun.()

    [
      {"CB-ACCESS-KEY", key_fun.()},
      {"CB-ACCESS-SIGN", sign_fun.(method, path, body, timestamp)},
      {"CB-ACCESS-TIMESTAMP", timestamp}
    ]
  end

  def unwrap_response(resp) do
    case resp do
      {:ok, resp}
	-> {:ok, resp.body}
      {:error, message}
	-> {:error, message}
      err
	-> {:error, err}
    end
  end

  def get(path) do
    new("GET", path)
    |> Tesla.get(path)
    |> unwrap_response()
  end

  def delete(path) do
    new("DELETE", path)
    |> Tesla.delete(path)
    |> unwrap_response()
  end

  def post(path, body) do
    new("POST", path, body)
    |> Tesla.post(path, body)
    |> unwrap_response()
  end

  def put(path, body) do
    new("PUT", path, body)
    |> Tesla.put(path, body)
    |> unwrap_response()
  end

  def patch(path, body) do
    new("PATCH", path, body)
    |> Tesla.patch(path, body)
    |> unwrap_response()
  end

end
