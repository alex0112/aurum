defmodule Aurum.Coinbase.Sign do
  @moduledoc """
  This module is responsible for all the signing related to the HMAC authentication which must be present on every request to the Coinbase API.

  To understand some of the processes contained in this module, it is highly recommended to read the Coinbase API docs about API key authentication found [here](https://developers.coinbase.com/api/v2#api-key).
  """

  alias Aurum.Coinbase.Fetchers, as: Fetchers

  @doc """
  Given the secret, timestamp, method, path, and optional body: generate a valid signature. The following data given to this function should produce the hash outlined below, and this is how what the unit test of this particular function are testing against.

  ```
  secret    bar
  timestamp 1636971273
  method    GET
  path      /zork
  body      {'quux': 'zyzx'}
  
  message 1636971273GET/zork{'quux': 'zyzx'}
  hash:   6aed30a898d9c87ef9f652d81e49464c65ff9406801e7edd238febe959f58dca
  ```
  """
  @spec sign(secret :: String.t(), timestamp :: integer(), method :: String.t(), path :: String.t(), body :: String.t()) :: String.t()
  def sign(method, path, body \\ "", timestamp, secret_fun \\ &Fetchers.fetch_secret/0) do
    message    = generate_message(timestamp, method, path, body)
    secret     = secret_fun.()

    _signature =
      :crypto.mac(:hmac, :sha256, secret, message)
      |> Base.encode16(case: :lower)
  end

  @doc """
  Given the timestamp, method, path, and body used in a request, concatenate them in the correct order for use in the signature function later.
  """
  @spec generate_message(timestamp :: integer() | String.t(), method :: String.t(), path :: String.t(), body :: String.t()) :: String.t()
  def generate_message(timestamp, method, path, body \\ "") do
    "#{timestamp}#{method}#{path}#{body}"
  end

end
