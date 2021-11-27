defmodule Aurum.Coinbase do

  alias Tesla
  alias Aurum.Coinbase.Fetchers
  alias Aurum.Coinbase.Sign

  @spec client(path :: String.t(), method :: String.t(), key_fun :: (-> String.t()), secret_fun :: (-> String.t()), sign_fun :: (... -> String.t()), timestamp_fun :: (-> String.t())) :: %Tesla.Client{}
  def client(path, method, key_fun \\ &Fetchers.fetch_key/0, secret_fun \\ &Fetchers.fetch_secret/0, sign_fun \\ &Sign.sign/5, timestamp_fun \\ &Fetchers.fetch_timestamp/0) do
    timestamp = timestamp_fun.()
    key       = key_fun.()
    secret    = secret_fun.()

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.coinbase.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers,
       [
	 {"CB-ACCESS-KEY", key},
	 {"CB-ACCESS-SIGN", sign_fun.(secret, timestamp, method, path, "")},
	 {"CB-ACCESS-TIMESTAMP", timestamp}
       ]
      }
    ]

    Tesla.client(middleware)
  end
  
  def current_user do
    {:ok, data} =
      client("/v2/user", "GET")
      |> Tesla.get("/v2/user")

    data
  end

  def accounts do
    {:ok, resp} =
      client("/v2/accounts", "GET")
      |> Tesla.get("/v2/accounts")

    resp.body["data"]
  end

  def account_by_symbol(symbol) do
    accounts()
    |> Enum.filter(fn account ->
      account["currency"]["code"] == symbol
    end)
  end

  def account_id(account) do
    account["id"]
  end

  def resource_path(account) do
    account["resource_path"]
  end

end
