defmodule Aurum.Coinbase.Fetchers do
  @moduledoc """
  This module isolates certain side-effect ridden operations into their own functions.

  All functions in this module are intended to be used as a default parameter in another module in such a way that the function here can be mocked.
  """

  alias Tesla
  require Logger

  @key_name "COINBASE_KEY"
  @secret_name "COINBASE_SECRET"

  @doc """
  Returns the value of the #{@key_name} environment variable. (At runtime)
  """
  @spec fetch_key :: String.t()
  def fetch_key do
    case System.fetch_env(@key_name) do
      {:ok, key} -> key
      :error -> Logger.warn("Coinbase key not found. Have you run `export COINBASE_KEY=... in your local environment?")
    end
  end

  @doc """
  Returns the value of the #{@secret_name} environment variable. (At runtime)
  """
  @spec fetch_secret :: String.t()
  def fetch_secret do
    case System.fetch_env(@secret_name) do
      {:ok, secret} -> secret
      :error -> Logger.warn("Coinbase secret not found. Have you run `export COINBASE_SECRET=... in your local environment?")
    end
  end

  @doc """
  Returns the current epoch timestamp according to the `/time` portion of the Coinbase API. This is used when generating the signed HMAC authentication string used in authenticated Coinbase requests.
  """
  @spec fetch_timestamp :: integer()
  def fetch_timestamp do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.coinbase.com/v2"},
      Tesla.Middleware.JSON,
    ]

    Tesla.client(middleware)
    |> Tesla.get("/time")
    |> parse_epoch
  end

  ### Just parse the pure epoch timestamp out of the response. We don't
  #   care about the human readable portion.
  defp parse_epoch({:ok, %Tesla.Env{body: %{"data" => %{"epoch" => epoch}}}}), do: epoch

end
