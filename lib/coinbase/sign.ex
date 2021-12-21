defmodule Aurum.Coinbase.Sign do
  @moduledoc """
  This module is responsible for all the signing related to the HMAC authentication which must be present on every request to the Coinbase API.
  """

  alias Aurum.Coinbase.Fetchers, as: Fetchers

  @doc """
  secret    bar
  timestamp 1636971273
  method    GET
  path      /zork
  body      {'quux': 'zyzx'}
  
  message 1636971273GET/zork{'quux': 'zyzx'}
  hash:   6aed30a898d9c87ef9f652d81e49464c65ff9406801e7edd238febe959f58dca
  """
  @spec sign(secret :: String.t(), timestamp :: integer(), method :: String.t(), path :: String.t(), body :: String.t()) :: String.t()
  def sign(method, path, body \\ "", timestamp, secret_fun \\ &Fetchers.fetch_secret/0) do
    message    = generate_message(timestamp, method, path, body)
    secret     = secret_fun.()

    _signature =
      :crypto.mac(:hmac, :sha256, secret, message)
      |> Base.encode16(case: :lower)
  end

  def generate_message(timestamp, method, path, body \\ "") do
    "#{timestamp}#{method}#{path}#{body}"
  end

end
