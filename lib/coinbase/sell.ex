defmodule Aurum.Coinbase.SellOrder do

  alias Aurum.Coinbase

  @moduledoc """
  This module provides a data structure representing an uncreated sell order.
  """

  @enforce_keys [:total]
  defstruct [:amount, :total, :currency, :payment_method, agree_btc_amount_varies: false, commit: false, quote: false]

end
