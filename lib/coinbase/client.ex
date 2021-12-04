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

  def middleware(method, path, body, base_url \\ @base_url) do
    [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, headers(method, path, body)}
    ]
  end

  @doc """
  Provide a list of headers to be used in the Coinbase request. 
  """
  @spec headers(method :: String.t(), path :: String.t(), body :: String.t(), key :: String.t(), sign_fun :: (String.t(), String.t(), String.t()-> String.t()),timestamp :: String.t()) :: list(tuple())
  def headers(method, path, body, key_fun \\ Fetchers.fetch_key/0, sign_fun \\ Sign.sign, timestamp_fun \\ Fetchers.fetch) do
    timestamp = timestamp_fun.()

    [
      {"CB-ACCESS-KEY", key_fun.()},
      {"CB-ACCESS-SIGN", sign_fun.(method, path, body, timestamp)},
      {"CB-ACCESS-TIMESTAMP", timestamp_fun.()}
    ]
  end

  @spec unwrap_response(resp :: {atom(), any()}) :: map() | {atom(), any()}
  def unwrap_response(resp) do
    case resp do
      {:ok, resp}
	-> resp |> fetch_body()
      {:error, error}
	-> Logger.debug(error)
	   {:error, error}
    end
  end

  defp fetch_body(resp) do
    resp
  end

end
