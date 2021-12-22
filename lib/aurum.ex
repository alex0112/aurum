defmodule Aurum do
  @moduledoc """
  Aurum is an Elixir Client for the Coinbase API.

  > If gold rusts, what then can iron do?
  > ― Geoffrey Chaucer, The Canterbury Tales 

  ## Installation

  If [available in Hex](https://hex.pm/docs/publish), the package can be installed
  by adding `aurum` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:aurum, "~> 0.2.0"}
    ]
  end
  ```

  ## Usage: 

  ### API Key/Secret
  First, ensure that you have a coinbase API Key, and an API Secret. Details about how to obtain those can be found in the [Coinbase Documentation](https://developers.coinbase.com/docs/wallet/api-key-authentication).

  Once you have obtained them, make sure that they are in the environment your module will be running in under the names `COINBASE_KEY` and `COINBASE_SECRET`:
  ```bash
  $ export COINBASE_KEY=...
  $ export COINBASE_SECRET=...
  ```

  This will enable the client library to correctly sign your requests.

  ### Making requests to the API:
  To use the client, alias `Coinbase` into your module:

  ```elixir
  defmodule MyModule do
    alias Aurum.Coinbase

    ...

  end
  ```

  ### Basic Usage:
  Once you have access to the `Coinbase` module, you can begin making any of the requests outlined in [the documentation](https://developers.coinbase.com/api/v2#introduction) for V2 of the Coinbase API. All of the authentication steps should be completed automatically provided the `COINBASE_KEY` and `COINBASE_SECRET` are properly set. All calls to the API should follow the pathing scheme of `/v2/<resource path>`. 

  For example:

  ```elixir
  def fetch_btc_account do
    Coinbase.get("/v2/accounts/btc")
  end
  ```

  Sucessful responses are always in the form of:
  ```elixir
  %{
    "data" => %{
      ...
    },
    "warnings" => [ ## If any
      
    ]
  }
  ```

  And for any HTTP verbs that require a body (i.e. PUT/PATCH/POST), the body may be defined as a bare map:
  ```elixir
  Coinbase.post("/v2/...", %{amount: 10, currency: "USD"})
  ```

  ...or as a valid JSON string:
  ```elixir
  Coinbase.post("/v2/...", ~S({"amount": "10", "currency": "USD"}))
  ```

  ### Example: Buy $10.00 worth of Ethereum
  ```elixir
  iex(1)> alias Aurum.Coinbase
  Aurum.Coinbase
  iex(2)> eth_account = Coinbase.get("/v2/accounts/eth")
  %{
    "data" => %{
      "allow_deposits" => true,
      "allow_withdrawals" => true,
      "balance" => %{"amount" => "<amount>", "currency" => "ETH"},
      "created_at" => "...",
      "currency" => %{
	"address_regex" => "...",
	"asset_id" => "...",
	"code" => "ETH",
	"color" => "#627EEA",
	"exponent" => 8,
	"name" => "Ethereum",
	"slug" => "ethereum",
	"sort_index" => 102,
	"type" => "crypto"
      },
      "id" => "...",
      "name" => "ETH Wallet",
      "primary" => true,
      "resource" => "account",
      "resource_path" => "/v2/accounts/<account_id>",
      "type" => "wallet",
      "updated_at" => "2021-04-08T21:25:29Z"
    },
  }
  iex(3)> eth_resource = eth_account["data"]["resource_path"]
  "/v2/accounts/<account_id>"
  iex(4)> buy_string = eth_resource <> "/buys"
  "/v2/accounts/<account_id>/buys"
  iex(5)> Coinbase.post(buy_string, %{amount: 10, currency: "USD"})
  %{
    "data" => %{
      "amount" => %{"amount" => "0.00248885", "currency" => "ETH"},
      "committed" => true,
      "created_at" => "2021-12-22T01:02:32Z",
      "fee" => %{"amount" => "0.99", "currency" => "USD"},
      "hold_days" => 3,
      "hold_until" => "2021-12-25T00:00:00Z",
      "id" => "...",
      "idem" => "...",
      "instant" => true,
      "is_first_buy" => false,
      "next_step" => nil,
      "payment_method" => %{
	"id" => "...",
	"resource" => "payment_method",
	"resource_path" => "/v2/payment-methods/..."
      },
      "payout_at" => "2021-12-22T01:02:32Z",
      "requires_completion_step" => false,
      "resource" => "buy",
      "resource_path" => "/v2/accounts/<account_id>/buys/<buy_id>",
      "status" => "created",
      "subtotal" => %{"amount" => "10.00", "currency" => "USD"},
      "total" => %{"amount" => "10.99", "currency" => "USD"},
      "transaction" => nil,
      "unit_price" => %{"amount" => "4017.92", "currency" => "USD", "scale" => 2},
      "updated_at" => "2021-12-22T01:02:33Z",
      "user_reference" => "..."
    },
  }
  ```

  ## Known issues:
  You may see this warning pop up from time to time:
  ```
  17:55:32.021 [warn]  Description: 'Authenticity is not established by certificate path validation'
  Reason: 'Option {verify, verify_peer} and cacertfile/cacerts is missing'
  ```

  This is due to some configuration problems with the underlying HTTP client, and will be adressed in a future update.

  ## Disclaimer:
  Thanks for using this library! Pull requests and contributions are always welcome. Until this library is published as `>= 1.0.0` it should be considered public beta. You are welcome to use it in any of your projects, but until it is fully published please do not consider the API stable.

  It is my sincerest wish as the creator and maintainer of this repo to produce software that is as high quality as possible. That being said, this is a project I maintain in my free time and since there is potential to mis-use this library in ways that may cost you real money, I feel the need to re-iterate this portion of the license:

  ```
  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
  ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
  ```

  I am not responsible for any financial loss you incur while using this library to trade cryptocurrency, but may the odds be ever in your favor.

  ## Documentation:
  Docs can be found at [https://hexdocs.pm/aurum](https://hexdocs.pm/aurum).
  

  """
end
